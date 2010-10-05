From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-add-interactive-mode.patch added to -mm tree
Date: Tue, 05 Oct 2010 14:09:43 -0700
Message-ID: <201010052109.o95L9h4Q020183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754639Ab0JEVJu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 17:09:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: florian@mickler.org, joe@perches.com


The patch titled
     scripts/get_maintainer.pl: add interactive mode
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-add-interactive-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: add interactive mode
From: Florian Mickler <florian@mickler.org>

This is a first version of an interactive mode for
scripts/get_maintainer.pl.

It allows the user to interact with the script.  Each cc candidate can be
selected and deselected and a shortlog of authored commits can be
displayed for each candidate.

The menu is displayed via STDERR, the end result is outputted to STDOUT. 
This unusual mechanism allows using get_maintainer.pl in interactive mode
via git send-email --cc-cmd.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |  146 ++++++++++++++++++++++++++++++++++--
 1 file changed, 141 insertions(+), 5 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-add-interactive-mode scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-add-interactive-mode
+++ a/scripts/get_maintainer.pl
@@ -33,6 +33,7 @@ my $email_git_max_maintainers = 5;
 my $email_git_min_percent = 5;
 my $email_git_since = "1-year-ago";
 my $email_hg_since = "-365";
+my $interactive = 0;
 my $email_remove_duplicates = 1;
 my $output_multiline = 1;
 my $output_separator = ", ";
@@ -52,6 +53,8 @@ my $help = 0;
 
 my $exit = 0;
 
+my %shortlog_buffer;
+
 my @penguin_chief = ();
 push(@penguin_chief, "Linus Torvalds:torvalds\@linux-foundation.org");
 #Andrew wants in on most everything - 2009/01/14
@@ -93,7 +96,8 @@ my %VCS_cmds_git = (
     "blame_range_cmd" => "git blame -l -L \$diff_start,+\$diff_length \$file",
     "blame_file_cmd" => "git blame -l \$file",
     "commit_pattern" => "^commit [0-9a-f]{40,40}",
-    "blame_commit_pattern" => "^([0-9a-f]+) "
+    "blame_commit_pattern" => "^([0-9a-f]+) ",
+    "shortlog_cmd" => "git log --no-color --oneline --since=\$email_git_since --author=\"\$email\" -- \$file"
 );
 
 my %VCS_cmds_hg = (
@@ -107,7 +111,8 @@ my %VCS_cmds_hg = (
     "blame_range_cmd" => "",		# not supported
     "blame_file_cmd" => "hg blame -c \$file",
     "commit_pattern" => "^commit [0-9a-f]{40,40}",
-    "blame_commit_pattern" => "^([0-9a-f]+):"
+    "blame_commit_pattern" => "^([0-9a-f]+):",
+    "shortlog_cmd" => "ht log --date=\$email_hg_since"
 );
 
 my $conf = which_conf(".get_maintainer.conf");
@@ -148,6 +153,7 @@ if (!GetOptions(
 		'git-min-percent=i' => \$email_git_min_percent,
 		'git-since=s' => \$email_git_since,
 		'hg-since=s' => \$email_hg_since,
+		'i|interactive!' => \$interactive,
 		'remove-duplicates!' => \$email_remove_duplicates,
 		'm!' => \$email_maintainer,
 		'n!' => \$email_usename,
@@ -225,6 +231,8 @@ if ($email_git_all_signature_types) {
     $signaturePattern = "(.+?)[Bb][Yy]:";
 }
 
+
+
 ## Read MAINTAINERS for type/value pairs
 
 my @typevalue = ();
@@ -450,10 +458,13 @@ foreach my $file (@files) {
 	($email_git || ($email_git_fallback && !$exact_pattern_match))) {
 	vcs_file_signoffs($file);
     }
-
     if ($email && $email_git_blame) {
 	vcs_file_blame($file);
     }
+    if ($email && $interactive){
+	vcs_file_shortlogs($file);
+
+    }
 }
 
 if ($keywords) {
@@ -486,9 +497,13 @@ if ($email) {
     }
 }
 
+
 if ($email || $email_list) {
     my @to = ();
     if ($email) {
+	if ($interactive) {
+	    @email_to = @{vcs_interactive_menu(\@email_to)};
+	}
 	@to = (@to, @email_to);
     }
     if ($email_list) {
@@ -501,7 +516,6 @@ if ($scm) {
     @scm = uniq(@scm);
     output(@scm);
 }
-
 if ($status) {
     @status = uniq(@status);
     output(@status);
@@ -556,6 +570,7 @@ MAINTAINER field selection options:
     --git-blame => use git blame to find modified commits for patch or file
     --git-since => git history to use (default: $email_git_since)
     --hg-since => hg history to use (default: $email_hg_since)
+    --interactive => display a menu (mostly useful if used with the --git option)
     --m => include maintainer(s) if any
     --n => include name 'Full Name <addr\@domain.tld>'
     --l => include list(s) if any
@@ -1156,6 +1171,127 @@ sub vcs_exists {
     return 0;
 }
 
+sub vcs_interactive_menu {
+    my $list_ref = shift;
+    my @list = @$list_ref;
+
+    return if (!vcs_exists());
+
+    my %selected;
+    my %shortlog;
+    my $input;
+    my $count = 0;
+
+    #select maintainers by default
+    foreach my $entry (@list){
+	    my $role = $entry->[1];
+	    $selected{$count} = ($role =~ /maintainer:|supporter:/);
+	    $count++;
+    }
+
+    #menu loop
+    do {
+	my $count = 0;
+	foreach my $entry (@list){
+	    my $email = $entry->[0];
+	    my $role = $entry->[1];
+	    if ($selected{$count}){
+		print STDERR "* ";
+	    } else {
+		print STDERR "  ";
+	    }
+	    print STDERR "$count: $email,\t\t $role";
+	    print STDERR "\n";
+	    if ($shortlog{$count}){
+		my $entries_ref = vcs_get_shortlog($email);
+		foreach my $entry_ref (@{$entries_ref}){
+		    my $filename = @{$entry_ref}[0];
+		    my @shortlog = @{@{$entry_ref}[1]};
+		    print STDERR "\tshortlog for $filename (authored commits: " . @shortlog . ").\n";
+		    foreach my $commit (@shortlog){
+			print STDERR "\t  $commit\n";
+		    }
+		    print STDERR "\n";
+		}
+	    }
+	    $count++;
+	}
+	print STDERR "\n";
+	print STDERR "Choose whom to cc by entering a commaseperated list of numbers and hitting enter.\n";
+	print STDERR "To show a short list of commits, precede the number by a '?',\n";
+	print STDERR "A blank line indicates that you are satisfied with your choice.\n";
+	$input = <STDIN>;
+	chomp($input);
+
+	my @wish = split(/[, ]+/,$input);
+	foreach my $nr (@wish){
+		my $logtoggle = 0;
+		if ($nr =~ /\?/){
+			$nr =~ s/\?//;
+			$logtoggle = 1;
+		}
+
+		#skip out of bounds numbers
+		next unless ($nr <= $count && $nr >= 0);
+
+		if ($logtoggle){
+			$shortlog{$nr} = !$shortlog{$nr};
+		} else {
+			$selected{$nr} = !$selected{$nr};
+
+			#switch shortlog on if an entry get's selected
+			if ($selected{$nr}){
+				$shortlog{$nr}=1;
+			}
+		}
+	};
+    } while(length($input) > 0);
+
+    #drop not selected entries
+    $count = 0;
+    my @new_emailto;
+    foreach my $entry (@list){
+	if ($selected{$count}){
+		push(@new_emailto,$list[$count]);
+		print STDERR "$count: ";
+		print STDERR $email_to[$count]->[0];
+		print STDERR ",\t\t ";
+		print STDERR $email_to[$count]->[1];
+		print STDERR "\n";
+	}
+	$count++;
+    }
+    return \@new_emailto;
+}
+
+sub vcs_get_shortlog {
+    my $arg = shift;
+    my ($name, $address) = parse_email($arg);
+    return $shortlog_buffer{$address};
+}
+
+sub vcs_file_shortlogs {
+    my ($file) = @_;
+    print STDERR "shortlog processing $file:";
+    foreach my $entry (@email_to){
+	my ($name, $address) = parse_email($entry->[0]);
+	print STDERR ".";
+	my $commits_ref = vcs_email_shortlog($address, $file);
+	push(@{$shortlog_buffer{$address}}, [ $file, $commits_ref ]);
+    }
+    print STDERR "\n";
+}
+
+sub vcs_email_shortlog {
+    my $email = shift;
+    my ($file) = @_;
+
+    my $cmd = $VCS_cmds{"shortlog_cmd"};
+    $cmd =~ s/(\$\w+)/$1/eeg;		#substitute variables
+    my @lines = &{$VCS_cmds{"execute_cmd"}}($cmd);
+    return \@lines;
+}
+
 sub vcs_assign {
     my ($role, $divisor, @lines) = @_;
 
@@ -1236,7 +1372,7 @@ sub vcs_file_blame {
 	my @commit_signers = ();
 
 	my $cmd = $VCS_cmds{"find_commit_signers_cmd"};
-	$cmd =~ s/(\$\w+)/$1/eeg;	#interpolate $cmd
+	$cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
 
 	($commit_count, @commit_signers) = vcs_find_signers($cmd);
 
_

Patches currently in -mm which might be from florian@mickler.org are

origin.patch
scripts-get_maintainerpl-add-interactive-mode.patch
scripts-get_maintainerpl-improve-interactive-ui.patch
scripts-get_maintainerpl-update-interactive-ui-improve-hg-runtime.patch
scripts-get_maintainerpl-use-case-insensitive-name-de-duplication.patch
scripts-get_maintainerpl-fix-mailmap-handling.patch
scripts-get_maintainerpl-correct-indentation-in-a-few-places.patch
scripts-get_maintainerpl-use-mailmap-in-name-deduplication-and-other-updates.patch
scripts-get_maintainerpl-dont-deduplicate-unnamed-addresses-ie-mailing-lists.patch

