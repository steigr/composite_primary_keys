require 'abstract_unit'
require 'fixtures/reference_type'
require 'fixtures/reference_code'

class IdsTest < Test::Unit::TestCase
  fixtures :reference_types, :reference_codes
  
  CLASSES = {
    :single => {
      :class => ReferenceType,
      :primary_keys => [:reference_type_id],
    },
    :dual   => { 
      :class => ReferenceCode,
      :primary_keys => [:reference_type_id, :reference_code],
    },
  }
  
  def setup
    super
    self.class.classes = CLASSES
  end
  
  def test_id
    testing_with do
      assert_equal @first.id, @first.ids if composite?
    end
  end
  
  def test_id_to_s
    testing_with do
      assert_equal first_id_str, @first.id.to_s
      assert_equal first_id_str, "#{@first.id}"
    end
  end
  
  def test_ids_to_s
    testing_with do
      to_test = @klass.find(:all)[0..1].map(&:id)
      assert_equal '(1,1),(1,2)', @klass.ids_to_s(to_test) if @key_test == :dual
      assert_equal '1,1;1,2', @klass.ids_to_s(to_test, ',', ';', '', '') if @key_test == :dual
    end
  end
  
  def test_primary_keys
    testing_with do
      if composite?
        assert_not_nil @klass.primary_keys
        assert_equal @primary_keys, @klass.primary_keys
        assert_equal @klass.primary_keys, @klass.primary_key
      else
        assert_not_nil @klass.primary_key
        assert_equal @primary_keys, [@klass.primary_key.to_sym]
      end
      assert_equal @primary_keys.join(','), @klass.primary_key.to_s
      # Need a :primary_keys should be Array with to_s overridden
    end
  end
end