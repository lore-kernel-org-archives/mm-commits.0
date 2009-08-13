From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-add-git-blame.patch added to -mm tree
Date: Thu, 13 Aug 2009 14:49:04 -0700
Message-ID: <200908132149.n7DLn5Vi012568@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751591AbZHMVuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 17:50:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     scripts/get_maintainer.pl: add --git-blame
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-add-git-blame.patch

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
Subject: scripts/get_maintainer.pl: add --git-blame
From: Joe Perches <joe@perches.com>

Julia Lawall suggested that get_maintainers.pl should have the
ability to include signatories of commits that are modified by
a particular patch.

Vegard Nossum did something similar once.
http://lkml.org/lkml/2008/5/29/449

The modified script looks the commits for all lines in the
patch, and includes the "-by:" signatories for those commits.
It uses the same git-min-percent, git-max-maintainers, and
git-min-signatures options.  git-since is ignored.

It can be used independently from the --git default, so
        ./scripts/get_maintainers.pl --nogit --git-blame <patch>
or
        ./scripts/get_maintainers.pl --nogit --git-blame -f <file>
is acceptable.

If used with -f <file>, all lines/commits for the file are
checked.

--git-blame can be slow if used with -f <file>
--git-blame does not work with -f <directory>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |  138 ++++++++++++++++++++++++++++--------
 1 file changed, 109 insertions(+), 29 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-add-git-blame scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-add-git-blame
+++ a/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.17';
+my $V = '0.18beta2';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -29,6 +29,7 @@ my $email_git_min_signatures = 1;
 my $email_git_max_maintainers = 5;
 my $email_git_min_percent = 5;
 my $email_git_since = "1-year-ago";
+my $email_git_blame = 0;
 my $output_multiline = 1;
 my $output_separator = ", ";
 my $scm = 0;
@@ -68,6 +69,7 @@ if (!GetOptions(
 		'git-max-maintainers=i' => \$email_git_max_maintainers,
 		'git-min-percent=i' => \$email_git_min_percent,
 		'git-since=s' => \$email_git_since,
+		'git-blame!' => \$email_git_blame,
 		'm!' => \$email_maintainer,
 		'n!' => \$email_usename,
 		'l!' => \$email_list,
@@ -107,8 +109,9 @@ if ($selections == 0) {
     die "$P:  Missing required option: email, scm, status, subsystem or web\n";
 }
 
-if ($email && ($email_maintainer + $email_list + $email_subscriber_list
-	       + $email_git + $email_git_penguin_chiefs) == 0) {
+if ($email &&
+    ($email_maintainer + $email_list + $email_subscriber_list +
+     $email_git + $email_git_penguin_chiefs + $email_git_blame) == 0) {
     usage();
     die "$P: Please select at least 1 email option\n";
 }
@@ -150,6 +153,7 @@ close(MAINT);
 ## use the filenames on the command line or find the filenames in the patchfiles
 
 my @files = ();
+my @range = ();
 
 foreach my $file (@ARGV) {
     ##if $file is a directory and it lacks a trailing slash, add one
@@ -162,13 +166,19 @@ foreach my $file (@ARGV) {
 	push(@files, $file);
     } else {
 	my $file_cnt = @files;
+	my $lastfile;
 	open(PATCH, "<$file") or die "$P: Can't open ${file}\n";
 	while (<PATCH>) {
 	    if (m/^\+\+\+\s+(\S+)/) {
 		my $filename = $1;
 		$filename =~ s@^[^/]*/@@;
 		$filename =~ s@\n@@;
+		$lastfile = $filename;
 		push(@files, $filename);
+	    } elsif (m/^\@\@ -(\d+),(\d+)/) {
+		if ($email_git_blame) {
+		    push(@range, "$lastfile:$1:$2");
+		}
 	    }
 	}
 	close(PATCH);
@@ -226,6 +236,9 @@ foreach my $file (@files) {
 	recent_git_signoffs($file);
     }
 
+    if ($email && $email_git_blame) {
+	git_assign_blame($file);
+    }
 }
 
 if ($email) {
@@ -311,6 +324,7 @@ MAINTAINER field selection options:
     --git-max-maintainers => maximum maintainers to add (default: 5)
     --git-min-percent => minimum percentage of commits required (default: 5)
     --git-since => git history to use (default: 1-year-ago)
+    --git-blame => use git blame to find modified commits for patch or file
     --m => include maintainer(s) if any
     --n => include name 'Full Name <addr\@domain.tld>'
     --l => include list(s) if any
@@ -333,13 +347,15 @@ Other options:
 
 Notes:
   Using "-f directory" may give unexpected results:
-
-  Used with "--git", git signators for _all_ files in and below
-     directory are examined as git recurses directories.
-     Any specified X: (exclude) pattern matches are _not_ ignored.
-  Used with "--nogit", directory is used as a pattern match,
-     no individual file within the directory or subdirectory
-     is matched.
+      Used with "--git", git signators for _all_ files in and below
+          directory are examined as git recurses directories.
+          Any specified X: (exclude) pattern matches are _not_ ignored.
+      Used with "--nogit", directory is used as a pattern match,
+         no individual file within the directory or subdirectory
+         is matched.
+      Used with "--git-blame", does not iterate all files in directory
+  Using "--git-blame" is slow and may add old committers and authors
+      that are no longer active maintainers to the output.
 EOT
 }
 
@@ -449,14 +465,19 @@ sub push_email_address {
     my ($email_address) = @_;
 
     my $email_name = "";
-    if ($email_address =~ m/([^<]+)<(.*\@.*)>$/) {
-	$email_name = $1;
-	$email_address = $2;
-    }
 
     if ($email_maintainer) {
-	if ($email_usename && $email_name) {
-	    push(@email_to, format_email($email_name, $email_address));
+	if ($email_address =~ m/([^<]+)<(.*\@.*)>$/) {
+	    $email_name = $1;
+	    $email_address = $2;
+	    if ($email_usename) {
+		push(@email_to, format_email($email_name, $email_address));
+	    } else {
+		push(@email_to, $email_address);
+	    }
+	} elsif ($email_address =~ m/<(.+)>/) {
+	    $email_address = $1;
+	    push(@email_to, $email_address);
 	} else {
 	    push(@email_to, $email_address);
 	}
@@ -545,20 +566,79 @@ sub recent_git_signoffs {
 		last;
 	    }
 	}
-	if ($line =~ m/(.+)<(.+)>/) {
-	    my $git_name = $1;
-	    my $git_addr = $2;
-	    if ($email_usename) {
-		push(@email_to, format_email($git_name, $git_addr));
-	    } else {
-		push(@email_to, $git_addr);
-	    }
-	} elsif ($line =~ m/<(.+)>/) {
-	    my $git_addr = $1;
-	    push(@email_to, $git_addr);
-	} else {
-	    push(@email_to, $line);
+	push_email_address($line);
+    }
+}
+
+sub save_commits {
+    my ($cmd, @commits) = @_;
+    my $output;
+    my @lines = ();
+
+    $output = `${cmd}`;
+
+    @lines = split("\n", $output);
+    foreach my $line (@lines) {
+	if ($line =~ m/^(\w+) /) {
+	    push (@commits, $1);
+	}
+    }
+    return @commits;
+}
+
+sub git_assign_blame {
+    my ($file) = @_;
+
+    my @lines = ();
+    my @commits = ();
+    my $cmd;
+    my $output;
+    my %hash;
+    my $total_sign_offs;
+    my $count;
+
+    if (@range) {
+	foreach my $file_range_diff (@range) {
+	    next if (!($file_range_diff =~ m/(.+):(.+):(.+)/));
+	    my $diff_file = $1;
+	    my $diff_start = $2;
+	    my $diff_length = $3;
+	    next if (!("$file" eq "$diff_file"));
+	    $cmd = "git blame -l -L $diff_start,+$diff_length $file\n";
+	    @commits = save_commits($cmd, @commits);
 	}
+    } else {
+	if (-f $file) {
+	    $cmd = "git blame -l $file\n";
+	    @commits = save_commits($cmd, @commits);
+	}
+    }
+
+    $total_sign_offs = 0;
+    @commits = uniq(@commits);
+    foreach my $commit (@commits) {
+	$cmd = "git log -1 ${commit}";
+	$cmd .= " | grep -Ei \"^[-_ 	a-z]+by:.*\\\@.*\$\"";
+	if (!$email_git_penguin_chiefs) {
+	    $cmd .= " | grep -Ev \"${penguin_chiefs}\"";
+	}
+	$cmd .= " | cut -f2- -d\":\"";
+
+	$output = `${cmd}`;
+	$output =~ s/^\s*//gm;
+	@lines = split("\n", $output);
+	$hash{$_}++ for @lines;
+	$total_sign_offs += @lines;
+    }
+
+    $count = 0;
+    foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
+	my $sign_offs = $hash{$line};
+	$count++;
+	last if ($sign_offs < $email_git_min_signatures ||
+		 $count > $email_git_max_maintainers ||
+		 $sign_offs * 100 / $total_sign_offs < $email_git_min_percent);
+	push_email_address($line);
     }
 }
 
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-osd-library-and-filesystem-pattern-fix.patch
linux-next.patch
maintainers-add-ipvs-include-files.patch
scripts-get_maintainerpl-add-git-blame.patch
scripts-get_maintainerpl-add-sections-in-pattern-match-depth-order.patch
scripts-get_maintainerpl-add-pattern-depth.patch
scripts-get_maintainerpl-better-email-routines-use-perl-not-shell-where-possible.patch
scripts-get_maintainerpl-add-mailmap-use-shell-and-email-cleanups.patch
scripts-get_maintainerpl-using-separator-implies-nomultiline.patch
scripts-get_maintainerpl-add-remove-duplicates.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch
maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator.patch

