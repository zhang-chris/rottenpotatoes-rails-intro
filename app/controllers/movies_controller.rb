class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    redir = false
    
    @all_ratings = Movie.all_ratings
    if params[:ratings]
      @ratings = params[:ratings]
      session[:ratings] = params[:ratings]
    else
      @ratings = session[:ratings]
      redir = true
    end
    
    if params[:sort]
      @sort = params[:sort]
      session[:sort] = params[:sort]
    else
      @sort = session[:sort]
      redir = true
    end
    
    if redir
      if session[:sort] != nil or session[:rating] != nil
        flash.keep
        redirect_to movies_path(:sort => @sort, :ratings => @ratings)
      end
    end

    
    if @sort == nil
      @sort = 'id'
    end
    if @ratings != nil
      ratings_list = @ratings.keys
      @movies = Movie.where(rating: ratings_list).order(@sort)
    else
      @ratings = {}
      @all_ratings.each do |rating|
        @ratings[rating] = true
      end
      @movies = Movie.order(@sort)
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
