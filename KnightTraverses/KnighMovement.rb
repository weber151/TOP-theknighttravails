class Square
  attr_accessor :position, :parent, :children

  def initialize(position, parent = nil)
    @position = position
    @parent = parent
    @children = []
  end

end

class KnightBoard
  # class creates board on the fly depending on placement of individual knights

  attr_accessor :root, :history, :queue, :statement

  TRANSFORMATIONS = [[1, 2], [-2, -1], [-1, 2], [2, -1],
  [1, -2], [-2, 1], [-1, -2], [2, 1]].freeze

  def self.create_tree()
    @history = []
    @queue = []
    current_square = @root
    create_children(current_square)
    while @queue.length != 0
      create_children(@queue.shift)
    end
  end

  def self.knight_moves(current_position, selected_position)
    moves = 0

    return "It takes #{moves} for the knight to travel from #{current_position} to #{selected_position}" if selected_position == current_position

    @root = Square.new(current_position)
    create_tree
    nav_square = @root
    nav_square.children.each { |child| @queue << child }
    while @queue.empty? == false
      nav_square = @queue.shift
      break if nav_square.position == selected_position

      nav_square.children.each { |child| @queue << child }
    end
    # found node, now we march back up the parents to count its moves.
    @queue.clear
    while nav_square.position != current_position
      @queue << nav_square
      nav_square = nav_square.parent
    end
    @queue << nav_square
    puts "It takes #{@queue.length - 1} for the knight to travel from #{current_position} to #{selected_position}"
    puts "This is your path:"
    @queue.reverse.each { |sqr| p sqr.position }
  end

  def self.create_children(current_square)
    TRANSFORMATIONS.each_with_index do |t, count|
      new_position = [t[0] + current_square.position[0], t[1] + current_square.position[1]]
      next if position_valid?(new_position) == false
      next if @history.include?(new_position) == true
      new_square = Square.new(new_position, current_square)
      current_square.children << new_square
      @queue << new_square
      @history << new_position
    end
  end

  def self.position_valid?(position)
    return false if position[0] > 7 || position[1] > 7
    return false if position[0].negative? || position[1].negative?
    return false if @history.include?(position)
    true
  end

end

KnightBoard.knight_moves( [1,2], [6,7] )

