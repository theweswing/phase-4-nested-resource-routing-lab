class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  def index
    if params[:user_id]
      user = User.find_by(id: params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    user = User.find_by(id: params[:user_id])
    items = user.items
    item = items.find_by(id: params[:id])
    render json: item, include: :user
  end

  def create
    user = User.find_by(id: params[:user_id])
    item = Item.create(strong_params)
    user.items << item
    render json: item, include: :user, status: :created
  end

  private

  def strong_params
    params.permit(:name, :description, :price)
  end

  def render_not_found_response(exception)
    render json: { error: "#{exception.model} not found" }, status: :not_found
  end
end
