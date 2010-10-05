From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-update-interactive-ui-improve-hg-runtime.patch added to -mm tree
Date: Tue, 05 Oct 2010 14:09:47 -0700
Message-ID: <201010052109.o95L9ltN020192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754639Ab0JEVJx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 17:09:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, florian@mickler.org


The patch titled
     scripts/get_maintainer.pl: update --interactive UI, improve hg runtime
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-update-interactive-ui-improve-hg-runtime.patch

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
Subject: scripts/get_maintainer.pl: update --interactive UI, improve hg runtime
From: Joe Perches <joe@perches.com>

o Add option --git-blame-signatures default:on to search each
  commit used by the current file for signatures
o Use consistent style in VCS_cmds_(git|hg)
o Add more options to be controlled at the --interactive prompt
o Speed up hg commit searching runtime by issuing a single
  hg command to search all modified commits instead of running
  multiple hg commands with a single commit each.

Update to 0.26 beta3

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Florian Mickler <florian@mickler.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |  347 +++++++++++++++++++++++++++---------
 1 file changed, 266 insertions(+), 81 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-update-interactive-ui-improve-hg-runtime scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-update-interactive-ui-improve-hg-runtime
+++ a/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.26-beta';
+my $V = '0.26-beta3';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -27,6 +27,7 @@ my $email_git_penguin_chiefs = 0;
 my $email_git = 0;
 my $email_git_all_signature_types = 0;
 my $email_git_blame = 0;
+my $email_git_blame_signatures = 1;
 my $email_git_fallback = 1;
 my $email_git_min_signatures = 1;
 my $email_git_max_maintainers = 5;
@@ -51,6 +52,8 @@ my $pattern_depth = 0;
 my $version = 0;
 my $help = 0;
 
+my $vcs_used = 0;
+
 my $exit = 0;
 
 my %commit_author_hash;
@@ -78,7 +81,6 @@ my @signature_tags = ();
 push(@signature_tags, "Signed-off-by:");
 push(@signature_tags, "Reviewed-by:");
 push(@signature_tags, "Acked-by:");
-my $signature_pattern = "\(" . join("|", @signature_tags) . "\)";
 
 # rfc822 email address - preloaded methods go here.
 my $rfc822_lwsp = "(?:(?:\\r\\n)?[ \\t])";
@@ -100,16 +102,19 @@ my %VCS_cmds_git = (
 		      '%b%n"' .
 	    " -- \$file",
     "find_commit_signers_cmd" =>
-	"git log --no-color -1 " .
+	"git log --no-color " .
 	    '--format="GitCommit: %H%n' .
 		      'GitAuthor: %an <%ae>%n' .
 		      'GitDate: %aD%n' .
 		      'GitSubject: %s%n' .
 		      '%b%n"' .
-	    " \$commit",
+	    " -1 \$commit",
     "find_commit_author_cmd" =>
 	"git log --no-color " .
-	    '--format="GitAuthor: %an <%ae>"' .
+	    '--format="GitCommit: %H%n' .
+		      'GitAuthor: %an <%ae>%n' .
+		      'GitDate: %aD%n' .
+		      'GitSubject: %s%n"' .
 	    " -1 \$commit",
     "blame_range_cmd" => "git blame -l -L \$diff_start,+\$diff_length \$file",
     "blame_file_cmd" => "git blame -l \$file",
@@ -124,17 +129,24 @@ my %VCS_cmds_hg = (
     "available" => '(which("hg") ne "") && (-d ".hg")',
     "find_signers_cmd" =>
 	"hg log --date=\$email_hg_since " .
-	    "--template='HgCommit: {node}\\nHgAuthor: {author}\\nHgSubject: {desc}\\n'" .
+	    "--template='HgCommit: {node}\\n" .
+	                "HgAuthor: {author}\\n" .
+			"HgSubject: {desc}\\n'" .
 	    " -- \$file",
-    "find_commit_signers_cmd" => "hg log --template='{desc}\\n' -r \$commit",
+    "find_commit_signers_cmd" =>
+	"hg log " .
+	    "--template='HgSubject: {desc}\\n'" .
+	    " -r \$commit",
     "find_commit_author_cmd" =>
-	"hg log -l 1 " .
-	    "--template='HgAuthor: {author}\\n'" .
-	    "-r \$commit",
+	"hg log " .
+	    "--template='HgCommit: {node}\\n" .
+		        "HgAuthor: {author}\\n" .
+			"HgSubject: {desc|firstline}\\n'" .
+	    " -r \$commit",
     "blame_range_cmd" => "",		# not supported
-    "blame_file_cmd" => "hg blame -c \$file",
+    "blame_file_cmd" => "hg blame -n \$file",
     "commit_pattern" => "^HgCommit: ([0-9a-f]{40,40})",
-    "blame_commit_pattern" => "^([0-9a-f]+):",
+    "blame_commit_pattern" => "^([ 0-9a-f]+):",
     "author_pattern" => "^HgAuthor: (.*)",
     "subject_pattern" => "^HgSubject: (.*)",
 );
@@ -170,6 +182,7 @@ if (!GetOptions(
 		'git!' => \$email_git,
 		'git-all-signature-types!' => \$email_git_all_signature_types,
 		'git-blame!' => \$email_git_blame,
+		'git-blame-signatures!' => \$email_git_blame_signatures,
 		'git-fallback!' => \$email_git_fallback,
 		'git-chief-penguins!' => \$email_git_penguin_chiefs,
 		'git-min-signatures=i' => \$email_git_min_signatures,
@@ -247,10 +260,6 @@ if (!top_of_kernel_tree($lk_path)) {
 	. "a linux kernel source tree.\n";
 }
 
-if ($email_git_all_signature_types) {
-    $signature_pattern = "(.+?)[Bb][Yy]:";
-}
-
 ## Read MAINTAINERS for type/value pairs
 
 my @typevalue = ();
@@ -398,6 +407,7 @@ my @scm = ();
 my @web = ();
 my @subsystem = ();
 my @status = ();
+my $signature_pattern;
 
 my @to = get_maintainer();
 
@@ -440,6 +450,12 @@ sub get_maintainer {
     @subsystem = ();
     @status = ();
 
+    if ($email_git_all_signature_types) {
+	$signature_pattern = "(.+?)[Bb][Yy]:";
+    } else {
+	$signature_pattern = "\(" . join("|", @signature_tags) . "\)";
+    }
+
     # Find responsible parties
 
     foreach my $file (@files) {
@@ -1140,15 +1156,16 @@ sub vcs_find_author {
 
     my @authors = ();
     foreach my $line (@lines) {
-	push(@authors, $1) if ($line =~ m/$VCS_cmds{"author_pattern"}/);
+	if ($line =~ m/$VCS_cmds{"author_pattern"}/) {
+	    my $author = $1;
+	    my ($name, $address) = parse_email($author);
+	    $author = format_email($name, $address, 1);
+	    push(@authors, $author);
+	}
     }
 
-## Reformat email addresses (with names) to avoid badly written signatures
-
-    foreach my $author (@authors) {
-	my ($name, $address) = parse_email($author);
-	$author = format_email($name, $address, 1);
-    }
+    save_commits_by_author(@lines) if ($interactive);
+    save_commits_by_signer(@lines) if ($interactive);
 
     return @authors;
 }
@@ -1222,7 +1239,7 @@ sub vcs_exists {
     %VCS_cmds = %VCS_cmds_git;
     return 1 if eval $VCS_cmds{"available"};
     %VCS_cmds = %VCS_cmds_hg;
-    return 1 if eval $VCS_cmds{"available"};
+    return 2 if eval $VCS_cmds{"available"};
     %VCS_cmds = ();
     if (!$printed_novcs) {
 	warn("$P: No supported VCS found.  Add --nogit to options?\n");
@@ -1234,10 +1251,20 @@ sub vcs_exists {
     return 0;
 }
 
+sub vcs_is_git {
+    return $vcs_used == 1;
+}
+
+sub vcs_is_hg {
+    return $vcs_used == 2;
+}
+
 sub interactive_get_maintainer {
     my ($list_ref) = @_;
     my @list = @$list_ref;
 
+    vcs_exists();
+
     my %selected;
     my %authored;
     my %signed;
@@ -1254,10 +1281,13 @@ sub interactive_get_maintainer {
 
     #menu loop
     my $done = 0;
+    my $print_options = 0;
     my $redraw = 1;
     while (!$done) {
 	$count = 0;
 	if ($redraw) {
+	    printf STDERR "\n%1s %2s %-65sauth sign\n",
+		"*", "#", "email/list and role:stats";
 	    foreach my $entry (@list) {
 		my $email = $entry->[0];
 		my $role = $entry->[1];
@@ -1269,11 +1299,9 @@ sub interactive_get_maintainer {
 		my $signed = 0;
 		$authored++ for (@{$commit_author});
 		$signed++ for (@{$commit_signer});
-		printf STDERR "%1s %2d %-52s",
-			      $sel, $count + 1, $email;
-		printf STDERR " Author:%3d Signer:%3d",
-			      $authored, $signed
-			      if ($authored > 0 || $signed > 0);
+		printf STDERR "%1s %2d %-65s", $sel, $count + 1, $email;
+		printf STDERR "%4d %4d", $authored, $signed
+		    if ($authored > 0 || $signed > 0);
 		printf STDERR "\n     %s\n", $role;
 		if ($authored{$count}) {
 		    my $commit_author = $commit_author_hash{$email};
@@ -1291,15 +1319,42 @@ sub interactive_get_maintainer {
 		$count++;
 	    }
 	}
+	my $date_ref = \$email_git_since;
+	$date_ref = \$email_hg_since if (vcs_is_hg());
+	if ($print_options) {
+	    $print_options = 0;
+	    if (vcs_exists()) {
+		print STDERR
+"\nVersion Control options:\n" .
+"g  use git history      [$email_git]\n" .
+"gf use git-fallback     [$email_git_fallback]\n" .
+"b  use git blame        [$email_git_blame]\n" .
+"bs use blame signatures [$email_git_blame_signatures]\n" .
+"c# minimum commits      [$email_git_min_signatures]\n" .
+"%# min percent          [$email_git_min_percent]\n" .
+"d# history to use       [$$date_ref]\n" .
+"x# max maintainers      [$email_git_max_maintainers]\n" .
+"t  all signature types  [$email_git_all_signature_types]\n";
+	    }
+	    print STDERR "\nAdditional options:\n" .
+"0  toggle all\n" .
+"f  emails in file       [$file_emails]\n" .
+"k  keywords in file     [$keywords]\n" .
+"r  remove duplicates    [$email_remove_duplicates]\n" .
+"p# pattern match depth  [$pattern_depth]\n";
+	}
 	print STDERR
 "\n#(toggle), A#(author), S#(signed) *(all), ^(none), O(options), Y(approve): ";
+
 	my $input = <STDIN>;
 	chomp($input);
 
-	my @wish = split(/[, ]+/, $input);
 	$redraw = 1;
+	my $rerun = 0;
+	my @wish = split(/[, ]+/, $input);
 	foreach my $nr (@wish) {
-	    my $sel = lc(substr($nr, 0, 1));
+	    $nr = lc($nr);
+	    my $sel = substr($nr, 0, 1);
 	    my $str = substr($nr, 1);
 	    my $val = 0;
 	    $val = $1 if $str =~ /^(\d+)$/;
@@ -1310,6 +1365,8 @@ sub interactive_get_maintainer {
 		$output_rolestats = 0;
 		$output_roles = 0;
 		last;
+	    } elsif ($nr =~ /^\d+$/ && $nr > 0 && $nr <= $count) {
+		$selected{$nr - 1} = !$selected{$nr - 1};
 	    } elsif ($sel eq "*" || $sel eq '^') {
 		my $toggle = 0;
 		$toggle = 1 if ($sel eq '*');
@@ -1334,7 +1391,6 @@ sub interactive_get_maintainer {
 		if ($val > 0 && $val <= $count) {
 		    $signed{$val - 1} = !$signed{$val - 1};
 		} elsif ($str eq '*' || $str eq '^') {
-		    print("yes\n");
 		    my $toggle = 0;
 		    $toggle = 1 if ($str eq '*');
 		    for (my $i = 0; $i < $count; $i++) {
@@ -1342,38 +1398,71 @@ sub interactive_get_maintainer {
 		    }
 		}
 	    } elsif ($sel eq "o") {
-		print STDERR
-"0(toggle all) g(use git history([$email_git]) b(Use git blame[$email_git_blame])\n" .
-"c#(minimum commits[$email_git_min_signatures]) x#(max maintainers[$email_git_max_maintainers] d#(history to use[$email_git_since])\n";
-		$redraw = 0;
-	    } elsif ($sel eq "b") {
-		$email_git_blame = !$email_git_blame;
-		goto &get_maintainer;
+		$print_options = 1;
+		$redraw = 1;
 	    } elsif ($sel eq "g") {
-		$email_git = !$email_git;
-		goto &get_maintainer;
+		if ($str eq "f") {
+		    bool_invert(\$email_git_fallback);
+		} else {
+		    bool_invert(\$email_git);
+		}
+		$rerun = 1;
+	    } elsif ($sel eq "b") {
+		if ($str eq "s") {
+		    bool_invert(\$email_git_blame_signatures);
+		} else {
+		    bool_invert(\$email_git_blame);
+		}
+		$rerun = 1;
+	    } elsif ($sel eq "c") {
+		if ($val > 0) {
+		    $email_git_min_signatures = $val;
+		    $rerun = 1;
+		}
 	    } elsif ($sel eq "x") {
 		if ($val > 0) {
 		    $email_git_max_maintainers = $val;
+		    $rerun = 1;
 		}
-		goto &get_maintainer;
 	    } elsif ($sel eq "%") {
-		if ($val >= 0) {
+		if ($str ne "" && $val >= 0) {
 		    $email_git_min_percent = $val;
+		    $rerun = 1;
 		}
-		goto &get_maintainer;
-	    } elsif ($sel eq "c") {
-		if ($val >= 0) {
-		    $email_git_min_signatures = $val;
-		}
-		goto &get_maintainer;
 	    } elsif ($sel eq "d") {
-		$email_git_since = $str;
-		goto &get_maintainer;
-	    } elsif ($sel =~ /^\d+$/ && $sel > 0 && $nr <= $count) {
-		$selected{$nr - 1} = !$selected{$nr - 1};
+		if (vcs_is_git()) {
+		    $email_git_since = $str;
+		} elsif (vcs_is_hg()) {
+		    $email_hg_since = $str;
+		}
+		$rerun = 1;
+	    } elsif ($sel eq "t") {
+		bool_invert(\$email_git_all_signature_types);
+		$rerun = 1;
+	    } elsif ($sel eq "f") {
+		bool_invert(\$file_emails);
+		$rerun = 1;
+	    } elsif ($sel eq "r") {
+		bool_invert(\$email_remove_duplicates);
+		$rerun = 1;
+	    } elsif ($sel eq "k") {
+		bool_invert(\$keywords);
+		$rerun = 1;
+	    } elsif ($sel eq "p") {
+		if ($str ne "" && $val >= 0) {
+		    $pattern_depth = $val;
+		    $rerun = 1;
+		}
+	    } else {
+		print STDERR "invalid option: '$nr'\n";
+		$redraw = 0;
 	    }
 	}
+	if ($rerun) {
+	    print STDERR "git-blame can be very slow, please have patience..."
+		if ($email_git_blame);
+	    goto &get_maintainer;
+	}
     }
 
     #drop not selected entries
@@ -1388,6 +1477,16 @@ sub interactive_get_maintainer {
     return @new_emailto;
 }
 
+sub bool_invert {
+    my ($bool_ref) = @_;
+
+    if ($$bool_ref) {
+	$$bool_ref = 0;
+    } else {
+	$$bool_ref = 1;
+    }
+}
+
 sub save_commits_by_author {
     my (@lines) = @_;
 
@@ -1396,14 +1495,29 @@ sub save_commits_by_author {
     my @subjects = ();
 
     foreach my $line (@lines) {
-	push(@authors, $1) if ($line =~ m/$VCS_cmds{"author_pattern"}/);
+	if ($line =~ m/$VCS_cmds{"author_pattern"}/) {
+	    my $author = $1;
+	    my ($name, $address) = parse_email($author);
+	    $author = format_email($name, $address, 1);
+	    push(@authors, $author);
+	}
 	push(@commits, $1) if ($line =~ m/$VCS_cmds{"commit_pattern"}/);
 	push(@subjects, $1) if ($line =~ m/$VCS_cmds{"subject_pattern"}/);
     }
 
     for (my $i = 0; $i < @authors; $i++) {
-	push(@{$commit_author_hash{$authors[$i]}},
-	     [ ($commits[$i], $subjects[$i]) ]);
+	my $exists = 0;
+	foreach my $ref(@{$commit_author_hash{$authors[$i]}}) {
+	    if (@{$ref}[0] eq $commits[$i] &&
+		@{$ref}[1] eq $subjects[$i]) {
+		$exists = 1;
+		last;
+	    }
+	}
+	if (!$exists) {
+	    push(@{$commit_author_hash{$authors[$i]}},
+		 [ ($commits[$i], $subjects[$i]) ]);
+	}
     }
 }
 
@@ -1417,13 +1531,27 @@ sub save_commits_by_signer {
 	$commit = $1 if ($line =~ m/$VCS_cmds{"commit_pattern"}/);
 	$subject = $1 if ($line =~ m/$VCS_cmds{"subject_pattern"}/);
 	if ($line =~ /^[ \t]*${signature_pattern}.*\@.*$/) {
-	    my @signature = ($line);
-	    my ($types_ref, $signers_ref) = extract_formatted_signatures(@signature);
-	    my @type = @$types_ref;
-	    my @signer = @$signers_ref;
-
-	    push(@{$commit_signer_hash{$signer[0]}},
-		 [ ($commit, $subject, $type[0]) ]);
+	    my @signatures = ($line);
+	    my ($types_ref, $signers_ref) = extract_formatted_signatures(@signatures);
+	    my @types = @$types_ref;
+	    my @signers = @$signers_ref;
+
+	    my $type = $types[0];
+	    my $signer = $signers[0];
+
+	    my $exists = 0;
+	    foreach my $ref(@{$commit_signer_hash{$signer}}) {
+		if (@{$ref}[0] eq $commit &&
+		    @{$ref}[1] eq $subject &&
+		    @{$ref}[2] eq $type) {
+		    $exists = 1;
+		    last;
+		}
+	    }
+	    if (!$exists) {
+		push(@{$commit_signer_hash{$signer}},
+		     [ ($commit, $subject, $type) ]);
+	    }
 	}
     }
 }
@@ -1478,7 +1606,8 @@ sub vcs_file_signoffs {
     my @signers = ();
     my $commits;
 
-    return if (!vcs_exists());
+    $vcs_used = vcs_exists();
+    return if (!$vcs_used);
 
     my $cmd = $VCS_cmds{"find_signers_cmd"};
     $cmd =~ s/(\$\w+)/$1/eeg;		# interpolate $cmd
@@ -1496,37 +1625,93 @@ sub vcs_file_blame {
     my $total_commits;
     my $total_lines;
 
-    return if (!vcs_exists());
+    $vcs_used = vcs_exists();
+    return if (!$vcs_used);
 
     @all_commits = vcs_blame($file);
     @commits = uniq(@all_commits);
     $total_commits = @commits;
     $total_lines = @all_commits;
 
-    foreach my $commit (@commits) {
-	my $commit_count;
-	my @commit_signers = ();
+    if ($email_git_blame_signatures) {
+	if (vcs_is_hg()) {
+	    my $commit_count;
+	    my @commit_signers = ();
+	    my $commit = join(" -r ", @commits);
+	    my $cmd;
+
+	    $cmd = $VCS_cmds{"find_commit_signers_cmd"};
+	    $cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
+
+	    ($commit_count, @commit_signers) = vcs_find_signers($cmd);
+
+	    push(@signers, @commit_signers);
+	} else {
+	    foreach my $commit (@commits) {
+		my $commit_count;
+		my @commit_signers = ();
+		my $cmd;
 
-	my $cmd = $VCS_cmds{"find_commit_signers_cmd"};
-	$cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
+		$cmd = $VCS_cmds{"find_commit_signers_cmd"};
+		$cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
 
-	($commit_count, @commit_signers) = vcs_find_signers($cmd);
+		($commit_count, @commit_signers) = vcs_find_signers($cmd);
 
-	push(@signers, @commit_signers);
+		push(@signers, @commit_signers);
+	    }
+	}
     }
 
     if ($from_filename) {
 	if ($output_rolestats) {
 	    my @blame_signers;
-	    foreach my $commit (@commits) {
-		my $i;
-		my $cmd = $VCS_cmds{"find_commit_author_cmd"};
-		$cmd =~ s/(\$\w+)/$1/eeg;	#interpolate $cmd
-		my @author = vcs_find_author($cmd);
-		next if !@author;
-		my $count = grep(/$commit/, @all_commits);
-		for ($i = 0; $i < $count ; $i++) {
-		    push(@blame_signers, $author[0]);
+	    if (vcs_is_hg()) {{		# Double brace for last exit
+		my $commit_count;
+		my @commit_signers = ();
+		@commits = uniq(@commits);
+		@commits = sort(@commits);
+		my $commit = join(" -r ", @commits);
+		my $cmd;
+
+		$cmd = $VCS_cmds{"find_commit_author_cmd"};
+		$cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
+
+		my @lines = ();
+
+		@lines = &{$VCS_cmds{"execute_cmd"}}($cmd);
+
+		if (!$email_git_penguin_chiefs) {
+		    @lines = grep(!/${penguin_chiefs}/i, @lines);
+		}
+
+		last if !@lines;
+
+		my @authors = ();
+		foreach my $line (@lines) {
+		    if ($line =~ m/$VCS_cmds{"author_pattern"}/) {
+			my $author = $1;
+			my ($name, $address) = parse_email($author);
+			$author = format_email($name, $address, 1);
+			push(@authors, $1);
+		    }
+		}
+
+		save_commits_by_author(@lines) if ($interactive);
+		save_commits_by_signer(@lines) if ($interactive);
+
+		push(@signers, @authors);
+	    }}
+	    else {
+		foreach my $commit (@commits) {
+		    my $i;
+		    my $cmd = $VCS_cmds{"find_commit_author_cmd"};
+		    $cmd =~ s/(\$\w+)/$1/eeg;	#interpolate $cmd
+		    my @author = vcs_find_author($cmd);
+		    next if !@author;
+		    my $count = grep(/$commit/, @all_commits);
+		    for ($i = 0; $i < $count ; $i++) {
+			push(@blame_signers, $author[0]);
+		    }
 		}
 	    }
 	    if (@blame_signers) {
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

