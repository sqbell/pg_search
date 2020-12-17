# frozen_string_literal: true

require 'digest'

module PgSearch
  class Configuration
    class Column
      attr_reader :weight, :name, :transformation

      def initialize(column_name, weight, model, transformation)
        @name = column_name.to_s
        @column_name = column_name.to_s
        @weight = weight
        @model = model
        @connection = model.connection
        @transformation = transformation
      end

      def full_name
        "#{table_name}.#{column_name}"
      end

      def to_sql
        if transformation
          transformation.sub(":#{name}", "coalesce(#{expression}::text, '')")
        else
          "coalesce(#{expression}::text, '')"
        end
      end

      private

      def table_name
        @model.quoted_table_name
      end

      def column_name
        @connection.quote_column_name(@column_name)
      end

      def expression
        full_name
      end
    end
  end
end
