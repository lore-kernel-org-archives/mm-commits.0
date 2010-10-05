From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-improve-interactive-ui.patch added to -mm tree
Date: Tue, 05 Oct 2010 14:09:45 -0700
Message-ID: <201010052109.o95L9jCp020186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756240Ab0JEVJx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 17:09:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, florian@mickler.org


The patch titled
     scripts/get_maintainer.pl: improve --interactive UI
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-improve-interactive-ui.patch

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
Subject: scripts/get_maintainer.pl: improve --interactive UI
From: Joe Perches <joe@perches.com>

o Added searching by git-blame as well as git-history
o Added different selection toggles
o Added ability to list commits by author or by sign-off-type
o Use custom git and hg formats to make searching for subject/author
  a bit easier.
o Move inlined section matching and searching git/hg history to
  new get_maintainer subroutine
o Added subroutines save_commits_by_author and save_commits_by_signer
o Removed subroutines vcs_get_shortlog and vcs_email_shortlog
o Rename camelcase signaturePattern to signature_pattern

Update version to 0.26-beta.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Florian Mickler <florian@mickler.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |  642 +++++++++++++++++++++---------------
 1 file changed, 389 insertions(+), 253 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-improve-interactive-ui scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-improve-interactive-ui
+++ a/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.25';
+my $V = '0.26-beta';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -53,7 +53,8 @@ my $help = 0;
 
 my $exit = 0;
 
-my %shortlog_buffer;
+my %commit_author_hash;
+my %commit_signer_hash;
 
 my @penguin_chief = ();
 push(@penguin_chief, "Linus Torvalds:torvalds\@linux-foundation.org");
@@ -77,7 +78,7 @@ my @signature_tags = ();
 push(@signature_tags, "Signed-off-by:");
 push(@signature_tags, "Reviewed-by:");
 push(@signature_tags, "Acked-by:");
-my $signaturePattern = "\(" . join("|", @signature_tags) . "\)";
+my $signature_pattern = "\(" . join("|", @signature_tags) . "\)";
 
 # rfc822 email address - preloaded methods go here.
 my $rfc822_lwsp = "(?:(?:\\r\\n)?[ \\t])";
@@ -90,29 +91,52 @@ my %VCS_cmds;
 my %VCS_cmds_git = (
     "execute_cmd" => \&git_execute_cmd,
     "available" => '(which("git") ne "") && (-d ".git")',
-    "find_signers_cmd" => "git log --no-color --since=\$email_git_since -- \$file",
-    "find_commit_signers_cmd" => "git log --no-color -1 \$commit",
-    "find_commit_author_cmd" => "git log -1 --format=\"%an <%ae>\" \$commit",
+    "find_signers_cmd" =>
+	"git log --no-color --since=\$email_git_since " .
+	    '--format="GitCommit: %H%n' .
+		      'GitAuthor: %an <%ae>%n' .
+		      'GitDate: %aD%n' .
+		      'GitSubject: %s%n' .
+		      '%b%n"' .
+	    " -- \$file",
+    "find_commit_signers_cmd" =>
+	"git log --no-color -1 " .
+	    '--format="GitCommit: %H%n' .
+		      'GitAuthor: %an <%ae>%n' .
+		      'GitDate: %aD%n' .
+		      'GitSubject: %s%n' .
+		      '%b%n"' .
+	    " \$commit",
+    "find_commit_author_cmd" =>
+	"git log --no-color " .
+	    '--format="GitAuthor: %an <%ae>"' .
+	    " -1 \$commit",
     "blame_range_cmd" => "git blame -l -L \$diff_start,+\$diff_length \$file",
     "blame_file_cmd" => "git blame -l \$file",
-    "commit_pattern" => "^commit [0-9a-f]{40,40}",
+    "commit_pattern" => "^GitCommit: ([0-9a-f]{40,40})",
     "blame_commit_pattern" => "^([0-9a-f]+) ",
-    "shortlog_cmd" => "git log --no-color --oneline --since=\$email_git_since --author=\"\$email\" -- \$file"
+    "author_pattern" => "^GitAuthor: (.*)",
+    "subject_pattern" => "^GitSubject: (.*)",
 );
 
 my %VCS_cmds_hg = (
     "execute_cmd" => \&hg_execute_cmd,
     "available" => '(which("hg") ne "") && (-d ".hg")',
     "find_signers_cmd" =>
-	"hg log --date=\$email_hg_since" .
-		" --template='commit {node}\\n{desc}\\n' -- \$file",
+	"hg log --date=\$email_hg_since " .
+	    "--template='HgCommit: {node}\\nHgAuthor: {author}\\nHgSubject: {desc}\\n'" .
+	    " -- \$file",
     "find_commit_signers_cmd" => "hg log --template='{desc}\\n' -r \$commit",
-    "find_commit_author_cmd" => "hg log -l 1 --template='{author}\\n' -r \$commit",
+    "find_commit_author_cmd" =>
+	"hg log -l 1 " .
+	    "--template='HgAuthor: {author}\\n'" .
+	    "-r \$commit",
     "blame_range_cmd" => "",		# not supported
     "blame_file_cmd" => "hg blame -c \$file",
-    "commit_pattern" => "^commit [0-9a-f]{40,40}",
+    "commit_pattern" => "^HgCommit: ([0-9a-f]{40,40})",
     "blame_commit_pattern" => "^([0-9a-f]+):",
-    "shortlog_cmd" => "ht log --date=\$email_hg_since"
+    "author_pattern" => "^HgAuthor: (.*)",
+    "subject_pattern" => "^HgSubject: (.*)",
 );
 
 my $conf = which_conf(".get_maintainer.conf");
@@ -193,13 +217,9 @@ if (-t STDIN && !@ARGV) {
     die "$P: missing patchfile or -f file - use --help if necessary\n";
 }
 
-if ($output_separator ne ", ") {
-    $output_multiline = 0;
-}
-
-if ($output_rolestats) {
-    $output_roles = 1;
-}
+$output_multiline = 0 if ($output_separator ne ", ");
+$output_rolestats = 1 if ($interactive);
+$output_roles = 1 if ($output_rolestats);
 
 if ($sections) {
     $email = 0;
@@ -228,11 +248,9 @@ if (!top_of_kernel_tree($lk_path)) {
 }
 
 if ($email_git_all_signature_types) {
-    $signaturePattern = "(.+?)[Bb][Yy]:";
+    $signature_pattern = "(.+?)[Bb][Yy]:";
 }
 
-
-
 ## Read MAINTAINERS for type/value pairs
 
 my @typevalue = ();
@@ -371,168 +389,186 @@ foreach my $file (@ARGV) {
 
 @file_emails = uniq(@file_emails);
 
+my %email_hash_name;
+my %email_hash_address;
 my @email_to = ();
+my %hash_list_to;
 my @list_to = ();
 my @scm = ();
 my @web = ();
 my @subsystem = ();
 my @status = ();
 
-# Find responsible parties
+my @to = get_maintainer();
 
-foreach my $file (@files) {
+@to = merge_email(@to);
 
-    my %hash;
-    my $exact_pattern_match = 0;
-    my $tvi = find_first_section();
-    while ($tvi < @typevalue) {
-	my $start = find_starting_index($tvi);
-	my $end = find_ending_index($tvi);
-	my $exclude = 0;
-	my $i;
-
-	#Do not match excluded file patterns
-
-	for ($i = $start; $i < $end; $i++) {
-	    my $line = $typevalue[$i];
-	    if ($line =~ m/^(\C):\s*(.*)/) {
-		my $type = $1;
-		my $value = $2;
-		if ($type eq 'X') {
-		    if (file_match_pattern($file, $value)) {
-			$exclude = 1;
-			last;
-		    }
-		}
-	    }
-	}
+output(@to) if (@to);
+
+if ($scm) {
+    @scm = uniq(@scm);
+    output(@scm);
+}
+
+if ($status) {
+    @status = uniq(@status);
+    output(@status);
+}
+
+if ($subsystem) {
+    @subsystem = uniq(@subsystem);
+    output(@subsystem);
+}
+
+if ($web) {
+    @web = uniq(@web);
+    output(@web);
+}
+
+exit($exit);
+
+sub get_maintainer {
+    %email_hash_name = ();
+    %email_hash_address = ();
+    %commit_author_hash = ();
+    %commit_signer_hash = ();
+    @email_to = ();
+    %hash_list_to = ();
+    @list_to = ();
+    @scm = ();
+    @web = ();
+    @subsystem = ();
+    @status = ();
+
+    # Find responsible parties
+
+    foreach my $file (@files) {
+
+	my %hash;
+	my $exact_pattern_match = 0;
+	my $tvi = find_first_section();
+	while ($tvi < @typevalue) {
+	    my $start = find_starting_index($tvi);
+	    my $end = find_ending_index($tvi);
+	    my $exclude = 0;
+	    my $i;
+
+	    #Do not match excluded file patterns
 
-	if (!$exclude) {
 	    for ($i = $start; $i < $end; $i++) {
 		my $line = $typevalue[$i];
 		if ($line =~ m/^(\C):\s*(.*)/) {
 		    my $type = $1;
 		    my $value = $2;
-		    if ($type eq 'F') {
+		    if ($type eq 'X') {
 			if (file_match_pattern($file, $value)) {
-			    my $value_pd = ($value =~ tr@/@@);
-			    my $file_pd = ($file  =~ tr@/@@);
-			    $value_pd++ if (substr($value,-1,1) ne "/");
-			    $value_pd = -1 if ($value =~ /^\.\*/);
-			    $exact_pattern_match = 1 if ($value_pd >= $file_pd);
-			    if ($pattern_depth == 0 ||
-				(($file_pd - $value_pd) < $pattern_depth)) {
-				$hash{$tvi} = $value_pd;
+			    $exclude = 1;
+			    last;
+			}
+		    }
+		}
+	    }
+
+	    if (!$exclude) {
+		for ($i = $start; $i < $end; $i++) {
+		    my $line = $typevalue[$i];
+		    if ($line =~ m/^(\C):\s*(.*)/) {
+			my $type = $1;
+			my $value = $2;
+			if ($type eq 'F') {
+			    if (file_match_pattern($file, $value)) {
+				my $value_pd = ($value =~ tr@/@@);
+				my $file_pd = ($file  =~ tr@/@@);
+				$value_pd++ if (substr($value,-1,1) ne "/");
+				$value_pd = -1 if ($value =~ /^\.\*/);
+				$exact_pattern_match = 1 if ($value_pd >= $file_pd);
+				if ($pattern_depth == 0 ||
+				    (($file_pd - $value_pd) < $pattern_depth)) {
+				    $hash{$tvi} = $value_pd;
+				}
 			    }
 			}
 		    }
 		}
 	    }
+	    $tvi = $end + 1;
 	}
 
-	$tvi = $end + 1;
-    }
-
-    foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
-	add_categories($line);
-	if ($sections) {
-	    my $i;
-	    my $start = find_starting_index($line);
-	    my $end = find_ending_index($line);
-	    for ($i = $start; $i < $end; $i++) {
-		my $line = $typevalue[$i];
-		if ($line =~ /^[FX]:/) {		##Restore file patterns
-		    $line =~ s/([^\\])\.([^\*])/$1\?$2/g;
-		    $line =~ s/([^\\])\.$/$1\?/g;	##Convert . back to ?
-		    $line =~ s/\\\./\./g;       	##Convert \. to .
-		    $line =~ s/\.\*/\*/g;       	##Convert .* to *
+	foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
+	    add_categories($line);
+	    if ($sections) {
+		my $i;
+		my $start = find_starting_index($line);
+		my $end = find_ending_index($line);
+		for ($i = $start; $i < $end; $i++) {
+		    my $line = $typevalue[$i];
+		    if ($line =~ /^[FX]:/) {		##Restore file patterns
+			$line =~ s/([^\\])\.([^\*])/$1\?$2/g;
+			$line =~ s/([^\\])\.$/$1\?/g;	##Convert . back to ?
+			$line =~ s/\\\./\./g;       	##Convert \. to .
+			$line =~ s/\.\*/\*/g;       	##Convert .* to *
+		    }
+		    $line =~ s/^([A-Z]):/$1:\t/g;
+		    print("$line\n");
 		}
-		$line =~ s/^([A-Z]):/$1:\t/g;
-		print("$line\n");
+		print("\n");
 	    }
-	    print("\n");
 	}
-    }
-
-    if ($email &&
-	($email_git || ($email_git_fallback && !$exact_pattern_match))) {
-	vcs_file_signoffs($file);
-    }
-    if ($email && $email_git_blame) {
-	vcs_file_blame($file);
-    }
-    if ($email && $interactive){
-	vcs_file_shortlogs($file);
 
+	if ($email && ($email_git ||
+		       ($email_git_fallback && !$exact_pattern_match))) {
+	    vcs_file_signoffs($file);
+	}
+	if ($email && $email_git_blame) {
+	    vcs_file_blame($file);
+	}
     }
-}
 
-if ($keywords) {
-    @keyword_tvi = sort_and_uniq(@keyword_tvi);
-    foreach my $line (@keyword_tvi) {
-	add_categories($line);
+    if ($keywords) {
+	@keyword_tvi = sort_and_uniq(@keyword_tvi);
+	foreach my $line (@keyword_tvi) {
+	    add_categories($line);
+	}
     }
-}
-
-if ($email) {
-    foreach my $chief (@penguin_chief) {
-	if ($chief =~ m/^(.*):(.*)/) {
-	    my $email_address;
 
-	    $email_address = format_email($1, $2, $email_usename);
-	    if ($email_git_penguin_chiefs) {
-		push(@email_to, [$email_address, 'chief penguin']);
-	    } else {
-		@email_to = grep($_->[0] !~ /${email_address}/, @email_to);
+    if ($email) {
+	foreach my $chief (@penguin_chief) {
+	    if ($chief =~ m/^(.*):(.*)/) {
+		my $email_address;
+
+		$email_address = format_email($1, $2, $email_usename);
+		if ($email_git_penguin_chiefs) {
+		    push(@email_to, [$email_address, 'chief penguin']);
+		} else {
+		    @email_to = grep($_->[0] !~ /${email_address}/, @email_to);
+		}
 	    }
 	}
-    }
 
-    foreach my $email (@file_emails) {
-	my ($name, $address) = parse_email($email);
+	foreach my $email (@file_emails) {
+	    my ($name, $address) = parse_email($email);
 
-	my $tmp_email = format_email($name, $address, $email_usename);
-	push_email_address($tmp_email, '');
-	add_role($tmp_email, 'in file');
+	    my $tmp_email = format_email($name, $address, $email_usename);
+	    push_email_address($tmp_email, '');
+	    add_role($tmp_email, 'in file');
+	}
     }
-}
-
 
-if ($email || $email_list) {
     my @to = ();
-    if ($email) {
-	if ($interactive) {
-	    @email_to = @{vcs_interactive_menu(\@email_to)};
+    if ($email || $email_list) {
+	if ($email) {
+	    @to = (@to, @email_to);
+	}
+	if ($email_list) {
+	    @to = (@to, @list_to);
 	}
-	@to = (@to, @email_to);
-    }
-    if ($email_list) {
-	@to = (@to, @list_to);
     }
-    output(merge_email(@to));
-}
-
-if ($scm) {
-    @scm = uniq(@scm);
-    output(@scm);
-}
-if ($status) {
-    @status = uniq(@status);
-    output(@status);
-}
 
-if ($subsystem) {
-    @subsystem = uniq(@subsystem);
-    output(@subsystem);
-}
+    @to = interactive_get_maintainer(\@to) if ($interactive);
 
-if ($web) {
-    @web = uniq(@web);
-    output(@web);
+    return @to;
 }
 
-exit($exit);
-
 sub file_match_pattern {
     my ($file, $pattern) = @_;
     if (substr($pattern, -1) eq "/") {
@@ -561,7 +597,7 @@ MAINTAINER field selection options:
   --email => print email address(es) if any
     --git => include recent git \*-by: signers
     --git-all-signature-types => include signers regardless of signature type
-        or use only ${signaturePattern} signers (default: $email_git_all_signature_types)
+        or use only ${signature_pattern} signers (default: $email_git_all_signature_types)
     --git-fallback => use git when no exact MAINTAINERS pattern (default: $email_git_fallback)
     --git-chief-penguins => include ${penguin_chiefs}
     --git-min-signatures => number of signatures required (default: $email_git_min_signatures)
@@ -847,11 +883,19 @@ sub add_categories {
 		}
 		if ($list_additional =~ m/subscribers-only/) {
 		    if ($email_subscriber_list) {
-			push(@list_to, [$list_address, "subscriber list${list_role}"]);
+			if (!$hash_list_to{$list_address}) {
+			    $hash_list_to{$list_address} = 1;
+			    push(@list_to, [$list_address,
+					    "subscriber list${list_role}"]);
+			}
 		    }
 		} else {
 		    if ($email_list) {
-			push(@list_to, [$list_address, "open list${list_role}"]);
+			if (!$hash_list_to{$list_address}) {
+			    $hash_list_to{$list_address} = 1;
+			    push(@list_to, [$list_address,
+					    "open list${list_role}"]);
+			}
 		    }
 		}
 	    } elsif ($ptype eq "M") {
@@ -882,9 +926,6 @@ sub add_categories {
     }
 }
 
-my %email_hash_name;
-my %email_hash_address;
-
 sub email_inuse {
     my ($name, $address) = @_;
 
@@ -1037,10 +1078,31 @@ sub hg_execute_cmd {
     return @lines;
 }
 
+sub extract_formatted_signatures {
+    my (@signature_lines) = @_;
+
+    my @type = @signature_lines;
+
+    s/\s*(.*):.*/$1/ for (@type);
+
+    # cut -f2- -d":"
+    s/\s*.*:\s*(.+)\s*/$1/ for (@signature_lines);
+
+## Reformat email addresses (with names) to avoid badly written signatures
+
+    foreach my $signer (@signature_lines) {
+	my ($name, $address) = parse_email($signer);
+	$signer = format_email($name, $address, 1);
+    }
+
+    return (\@type, \@signature_lines);
+}
+
 sub vcs_find_signers {
     my ($cmd) = @_;
-    my @lines = ();
     my $commits;
+    my @lines = ();
+    my @signatures = ();
 
     @lines = &{$VCS_cmds{"execute_cmd"}}($cmd);
 
@@ -1048,24 +1110,20 @@ sub vcs_find_signers {
 
     $commits = grep(/$pattern/, @lines);	# of commits
 
-    @lines = grep(/^[ \t]*${signaturePattern}.*\@.*$/, @lines);
-    if (!$email_git_penguin_chiefs) {
-	@lines = grep(!/${penguin_chiefs}/i, @lines);
-    }
+    @signatures = grep(/^[ \t]*${signature_pattern}.*\@.*$/, @lines);
 
-    return (0, @lines) if !@lines;
+    return (0, @signatures) if !@signatures;
 
-    # cut -f2- -d":"
-    s/.*:\s*(.+)\s*/$1/ for (@lines);
+    save_commits_by_author(@lines) if ($interactive);
+    save_commits_by_signer(@lines) if ($interactive);
 
-## Reformat email addresses (with names) to avoid badly written signatures
-
-    foreach my $line (@lines) {
-	my ($name, $address) = parse_email($line);
-	$line = format_email($name, $address, 1);
+    if (!$email_git_penguin_chiefs) {
+	@signatures = grep(!/${penguin_chiefs}/i, @signatures);
     }
 
-    return ($commits, @lines);
+    my ($types_ref, $signers_ref) = extract_formatted_signatures(@signatures);
+
+    return ($commits, @$signers_ref);
 }
 
 sub vcs_find_author {
@@ -1080,14 +1138,19 @@ sub vcs_find_author {
 
     return @lines if !@lines;
 
+    my @authors = ();
+    foreach my $line (@lines) {
+	push(@authors, $1) if ($line =~ m/$VCS_cmds{"author_pattern"}/);
+    }
+
 ## Reformat email addresses (with names) to avoid badly written signatures
 
-    foreach my $line (@lines) {
-	my ($name, $address) = parse_email($line);
-	$line = format_email($name, $address, 1);
+    foreach my $author (@authors) {
+	my ($name, $address) = parse_email($author);
+	$author = format_email($name, $address, 1);
     }
 
-    return @lines;
+    return @authors;
 }
 
 sub vcs_save_commits {
@@ -1171,125 +1234,198 @@ sub vcs_exists {
     return 0;
 }
 
-sub vcs_interactive_menu {
-    my $list_ref = shift;
+sub interactive_get_maintainer {
+    my ($list_ref) = @_;
     my @list = @$list_ref;
 
-    return if (!vcs_exists());
-
     my %selected;
-    my %shortlog;
-    my $input;
+    my %authored;
+    my %signed;
     my $count = 0;
 
     #select maintainers by default
     foreach my $entry (@list){
-	    my $role = $entry->[1];
-	    $selected{$count} = ($role =~ /maintainer:|supporter:/);
-	    $count++;
+	my $role = $entry->[1];
+	$selected{$count} = ($role =~ /^(maintainer|supporter|open list)/);
+	$authored{$count} = 0;
+	$signed{$count} = 0;
+	$count++;
     }
 
     #menu loop
-    do {
-	my $count = 0;
-	foreach my $entry (@list){
-	    my $email = $entry->[0];
-	    my $role = $entry->[1];
-	    if ($selected{$count}){
-		print STDERR "* ";
-	    } else {
-		print STDERR "  ";
-	    }
-	    print STDERR "$count: $email,\t\t $role";
-	    print STDERR "\n";
-	    if ($shortlog{$count}){
-		my $entries_ref = vcs_get_shortlog($email);
-		foreach my $entry_ref (@{$entries_ref}){
-		    my $filename = @{$entry_ref}[0];
-		    my @shortlog = @{@{$entry_ref}[1]};
-		    print STDERR "\tshortlog for $filename (authored commits: " . @shortlog . ").\n";
-		    foreach my $commit (@shortlog){
-			print STDERR "\t  $commit\n";
+    my $done = 0;
+    my $redraw = 1;
+    while (!$done) {
+	$count = 0;
+	if ($redraw) {
+	    foreach my $entry (@list) {
+		my $email = $entry->[0];
+		my $role = $entry->[1];
+		my $sel = "";
+		$sel = "*" if ($selected{$count});
+		my $commit_author = $commit_author_hash{$email};
+		my $commit_signer = $commit_signer_hash{$email};
+		my $authored = 0;
+		my $signed = 0;
+		$authored++ for (@{$commit_author});
+		$signed++ for (@{$commit_signer});
+		printf STDERR "%1s %2d %-52s",
+			      $sel, $count + 1, $email;
+		printf STDERR " Author:%3d Signer:%3d",
+			      $authored, $signed
+			      if ($authored > 0 || $signed > 0);
+		printf STDERR "\n     %s\n", $role;
+		if ($authored{$count}) {
+		    my $commit_author = $commit_author_hash{$email};
+		    foreach my $ref (@{$commit_author}) {
+			print STDERR "     Author: @{$ref}[1]\n";
+		    }
+		}
+		if ($signed{$count}) {
+		    my $commit_signer = $commit_signer_hash{$email};
+		    foreach my $ref (@{$commit_signer}) {
+			print STDERR "     @{$ref}[2]: @{$ref}[1]\n";
 		    }
-		    print STDERR "\n";
 		}
+
+		$count++;
 	    }
-	    $count++;
 	}
-	print STDERR "\n";
-	print STDERR "Choose whom to cc by entering a commaseperated list of numbers and hitting enter.\n";
-	print STDERR "To show a short list of commits, precede the number by a '?',\n";
-	print STDERR "A blank line indicates that you are satisfied with your choice.\n";
-	$input = <STDIN>;
+	print STDERR
+"\n#(toggle), A#(author), S#(signed) *(all), ^(none), O(options), Y(approve): ";
+	my $input = <STDIN>;
 	chomp($input);
 
-	my @wish = split(/[, ]+/,$input);
-	foreach my $nr (@wish){
-		my $logtoggle = 0;
-		if ($nr =~ /\?/){
-			$nr =~ s/\?//;
-			$logtoggle = 1;
+	my @wish = split(/[, ]+/, $input);
+	$redraw = 1;
+	foreach my $nr (@wish) {
+	    my $sel = lc(substr($nr, 0, 1));
+	    my $str = substr($nr, 1);
+	    my $val = 0;
+	    $val = $1 if $str =~ /^(\d+)$/;
+
+	    if ($sel eq "y") {
+		$interactive = 0;
+		$done = 1;
+		$output_rolestats = 0;
+		$output_roles = 0;
+		last;
+	    } elsif ($sel eq "*" || $sel eq '^') {
+		my $toggle = 0;
+		$toggle = 1 if ($sel eq '*');
+		for (my $i = 0; $i < $count; $i++) {
+		    $selected{$i} = $toggle;
 		}
-
-		#skip out of bounds numbers
-		next unless ($nr <= $count && $nr >= 0);
-
-		if ($logtoggle){
-			$shortlog{$nr} = !$shortlog{$nr};
-		} else {
-			$selected{$nr} = !$selected{$nr};
-
-			#switch shortlog on if an entry get's selected
-			if ($selected{$nr}){
-				$shortlog{$nr}=1;
-			}
+	    } elsif ($sel eq "0") {
+		for (my $i = 0; $i < $count; $i++) {
+		    $selected{$i} = !$selected{$i};
+		}
+	    } elsif ($sel eq "a") {
+		if ($val > 0 && $val <= $count) {
+		    $authored{$val - 1} = !$authored{$val - 1};
+		} elsif ($str eq '*' || $str eq '^') {
+		    my $toggle = 0;
+		    $toggle = 1 if ($str eq '*');
+		    for (my $i = 0; $i < $count; $i++) {
+			$authored{$i} = $toggle;
+		    }
+		}
+	    } elsif ($sel eq "s") {
+		if ($val > 0 && $val <= $count) {
+		    $signed{$val - 1} = !$signed{$val - 1};
+		} elsif ($str eq '*' || $str eq '^') {
+		    print("yes\n");
+		    my $toggle = 0;
+		    $toggle = 1 if ($str eq '*');
+		    for (my $i = 0; $i < $count; $i++) {
+			$signed{$i} = $toggle;
+		    }
+		}
+	    } elsif ($sel eq "o") {
+		print STDERR
+"0(toggle all) g(use git history([$email_git]) b(Use git blame[$email_git_blame])\n" .
+"c#(minimum commits[$email_git_min_signatures]) x#(max maintainers[$email_git_max_maintainers] d#(history to use[$email_git_since])\n";
+		$redraw = 0;
+	    } elsif ($sel eq "b") {
+		$email_git_blame = !$email_git_blame;
+		goto &get_maintainer;
+	    } elsif ($sel eq "g") {
+		$email_git = !$email_git;
+		goto &get_maintainer;
+	    } elsif ($sel eq "x") {
+		if ($val > 0) {
+		    $email_git_max_maintainers = $val;
+		}
+		goto &get_maintainer;
+	    } elsif ($sel eq "%") {
+		if ($val >= 0) {
+		    $email_git_min_percent = $val;
 		}
-	};
-    } while(length($input) > 0);
+		goto &get_maintainer;
+	    } elsif ($sel eq "c") {
+		if ($val >= 0) {
+		    $email_git_min_signatures = $val;
+		}
+		goto &get_maintainer;
+	    } elsif ($sel eq "d") {
+		$email_git_since = $str;
+		goto &get_maintainer;
+	    } elsif ($sel =~ /^\d+$/ && $sel > 0 && $nr <= $count) {
+		$selected{$nr - 1} = !$selected{$nr - 1};
+	    }
+	}
+    }
 
     #drop not selected entries
     $count = 0;
-    my @new_emailto;
-    foreach my $entry (@list){
-	if ($selected{$count}){
-		push(@new_emailto,$list[$count]);
-		print STDERR "$count: ";
-		print STDERR $email_to[$count]->[0];
-		print STDERR ",\t\t ";
-		print STDERR $email_to[$count]->[1];
-		print STDERR "\n";
+    my @new_emailto = ();
+    foreach my $entry (@list) {
+	if ($selected{$count}) {
+	    push(@new_emailto, $list[$count]);
 	}
 	$count++;
     }
-    return \@new_emailto;
+    return @new_emailto;
 }
 
-sub vcs_get_shortlog {
-    my $arg = shift;
-    my ($name, $address) = parse_email($arg);
-    return $shortlog_buffer{$address};
-}
+sub save_commits_by_author {
+    my (@lines) = @_;
 
-sub vcs_file_shortlogs {
-    my ($file) = @_;
-    print STDERR "shortlog processing $file:";
-    foreach my $entry (@email_to){
-	my ($name, $address) = parse_email($entry->[0]);
-	print STDERR ".";
-	my $commits_ref = vcs_email_shortlog($address, $file);
-	push(@{$shortlog_buffer{$address}}, [ $file, $commits_ref ]);
+    my @authors = ();
+    my @commits = ();
+    my @subjects = ();
+
+    foreach my $line (@lines) {
+	push(@authors, $1) if ($line =~ m/$VCS_cmds{"author_pattern"}/);
+	push(@commits, $1) if ($line =~ m/$VCS_cmds{"commit_pattern"}/);
+	push(@subjects, $1) if ($line =~ m/$VCS_cmds{"subject_pattern"}/);
+    }
+
+    for (my $i = 0; $i < @authors; $i++) {
+	push(@{$commit_author_hash{$authors[$i]}},
+	     [ ($commits[$i], $subjects[$i]) ]);
     }
-    print STDERR "\n";
 }
 
-sub vcs_email_shortlog {
-    my $email = shift;
-    my ($file) = @_;
+sub save_commits_by_signer {
+    my (@lines) = @_;
 
-    my $cmd = $VCS_cmds{"shortlog_cmd"};
-    $cmd =~ s/(\$\w+)/$1/eeg;		#substitute variables
-    my @lines = &{$VCS_cmds{"execute_cmd"}}($cmd);
-    return \@lines;
+    my $commit = "";
+    my $subject = "";
+
+    foreach my $line (@lines) {
+	$commit = $1 if ($line =~ m/$VCS_cmds{"commit_pattern"}/);
+	$subject = $1 if ($line =~ m/$VCS_cmds{"subject_pattern"}/);
+	if ($line =~ /^[ \t]*${signature_pattern}.*\@.*$/) {
+	    my @signature = ($line);
+	    my ($types_ref, $signers_ref) = extract_formatted_signatures(@signature);
+	    my @type = @$types_ref;
+	    my @signer = @$signers_ref;
+
+	    push(@{$commit_signer_hash{$signer[0]}},
+		 [ ($commit, $subject, $type[0]) ]);
+	}
+    }
 }
 
 sub vcs_assign {
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
kernelh-add-minmax3-macros.patch
kernelh-add-minmax3-macros-fix.patch
replace-nested-max-min-macros-with-maxmin3-macro.patch
vsprintfc-use-default-pointer-field-size-for-null-strings.patch
vsprintfc-use-default-pointer-field-size-for-null-strings-fix.patch
lib-fix-scnprintf-if-size-is-==-0.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
scripts-get_maintainerpl-use-correct-indentation.patch
scripts-get_maintainerpl-dont-search-maintainers-for-keywords-or-emails.patch
scripts-get_maintainerpl-add-default-git-fallback-remove-default-git.patch
scripts-get_maintainerpl-use-get_maintainerconf-from-then-home-then-scripts.patch
scripts-get_maintainerpl-add-interactive-mode.patch
scripts-get_maintainerpl-improve-interactive-ui.patch
scripts-get_maintainerpl-update-interactive-ui-improve-hg-runtime.patch
scripts-get_maintainerpl-use-case-insensitive-name-de-duplication.patch
scripts-get_maintainerpl-fix-mailmap-handling.patch
scripts-get_maintainerpl-correct-indentation-in-a-few-places.patch
scripts-get_maintainerpl-use-mailmap-in-name-deduplication-and-other-updates.patch
scripts-get_maintainerpl-dont-deduplicate-unnamed-addresses-ie-mailing-lists.patch
maintainers-fix-colibri-pxa270-file-pattern.patch
maintainers-merge-imote2-and-stargate.patch
maintainers-merge-s3c-244x-sections.patch
maintainers-merge-s3c6400-and-6410-to-64xx.patch
maintainers-remove-usb-ov511-driver.patch
maintainers-remove-usb-zc0301-driver.patch
maintainers-use-t-git-and-whitespace-trivia.patch
checkpatch-add-check-for-space-after-struct-union-and-enum.patch
checkpatch-add-additional-attribute-defines.patch
scripts-checkpatchpl-add-warnings-for-static-char-that-could-be-static-const-char.patch

