# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

unless Rails.env.development?
  puts "No seeds for mode: #{Rails.env}"
  exit
end

User.find_or_create_by(username: 'user') do |user|
  user.email = 'user@user.local'
  user.password = 'password'
  user.password_confirmation = 'password'
  user.first_name = 'User'
  user.last_name = 'Userson'
  user.agree_policy_terms = true
  user.email_fallback = 'user2@user.local'
end

user = User.last
Recovery.create(
  user: user,
  email_or_username: [user.email, user.username].sample
)

User.find_or_create_by(username: 'admin') do |u|
  u.email = 'admin@admin.local'
  u.password = 'password'
  u.password_confirmation = 'password'
  u.first_name = 'Admin'
  u.last_name = 'Adminerson'
  u.agree_policy_terms = true
  u.add_role :superadmin
end

100.times do
  Organization.create!(
    name: FFaker::Product.product,
    slug: FFaker::Product.letters(3),
    address_1: FFaker::Address.street_address,
    description: FFaker::Lorem.sentence,
    county: "County",
    country_code: "es",
    workflow_state: ['approved', 'pending', 'rejected'].sample,
    kind: Organization::KINDS[0]
  )
end

RefereeApprovalProcess.create!(
  referred_lab_id: 2,
  referee_lab_id: 2
)

# ActiveRecord::RecordInvalid: Validation failed: Referee approval processes can't be blank,
# Referee approval processes is the wrong length (should be 3 characters)
100.times do
  @lab = Lab.create!(
    name: "MyLab#{Lab.count}",
    kind: 1,
    email: FFaker::Internet.email,
    country_code: 'is',
    address_1: 'MyStreet 24',
    network: true,
    tools: true,
    programs: true,
    workflow_state: 'approved',
    latitude: 64.963,
    longitude: 19.0208,
    description: 'This is a description of your lab',
    phone: '0',
    blurb: 'Promotional message'
    #referee_id: 1
  )
end

Project.create!(
  title: "Project ",
  owner: User.first
)

Machine.create!(
  name: 'Machine '
)

Brand.create!(
  name: 'A Brand',
  description: 'brand'
)

Thing.create!(
  name: 'Something',
  description: 'A thing',
  brand: Brand.first
  # creator:
)

Facility.find_or_create_by(
  lab: Lab.first,
  thing: Thing.first
)

Employee.find_or_create_by(
  user: User.first,
  lab: Lab.first,
  job_title: FFaker::Job.title
)

Document.create!

10.times do |index|
  Event.create!(
    name: "Event name #{index}",
    description: 'Some Description',
    starts_at: 100.days.from_now,
    ends_at: 101.days.from_now,
    lab: Lab.all.sample
  )
end
