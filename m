From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-add-mailmap-use-shell-and-email-cleanups.patch added to -mm tree
Date: Thu, 13 Aug 2009 14:49:15 -0700
Message-ID: <200908132149.n7DLnF6S012902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753567AbZHMVuP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 17:50:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     scripts/get_maintainer.pl: add .mailmap use, shell and email cleanups
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-add-mailmap-use-shell-and-email-cleanups.patch

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
Subject: scripts/get_maintainer.pl: add .mailmap use, shell and email cleanups
From: Joe Perches <joe@perches.com>

Add reading and using .mailmap file if it exists
Convert address entries in .mailmap to first encountered address
Don't terminate shell commands with \n
Strip characters found after sign-offs by: name <address> [stripped]

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   72 ++++++++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 7 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-add-mailmap-use-shell-and-email-cleanups scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-add-mailmap-use-shell-and-email-cleanups
+++ a/scripts/get_maintainer.pl
@@ -152,6 +152,36 @@ while (<MAINT>) {
 }
 close(MAINT);
 
+my %mailmap;
+
+open(MAILMAP, "<${lk_path}.mailmap") || warn "$P: Can't open .mailmap\n";
+while (<MAILMAP>) {
+    my $line = $_;
+
+    next if ($line =~ m/^\s*#/);
+    next if ($line =~ m/^\s*$/);
+
+    my ($name, $address) = parse_email($line);
+    $line = format_email($name, $address);
+
+    next if ($line =~ m/^\s*$/);
+
+    if (exists($mailmap{$name})) {
+	my $obj = $mailmap{$name};
+	push(@$obj, $address);
+    } else {
+	my @arr = ($address);
+	$mailmap{$name} = \@arr;
+    }
+}
+close(MAILMAP);
+
+foreach my $name (sort {$mailmap{$a} <=> $mailmap{$b}} keys %mailmap) {
+    my $obj = $mailmap{$name};
+    foreach my $address (@$obj) {
+    }
+}
+
 ## use the filenames on the command line or find the filenames in the patchfiles
 
 my @files = ();
@@ -403,12 +433,12 @@ sub parse_email {
     my $name = "";
     my $address = "";
 
-    if ($formatted_email =~ /^([^<]+)<(.*\@.*)>$/) {
+    if ($formatted_email =~ /^([^<]+)<(.*\@.*)>.*$/) {
 	$name = $1;
 	$address = $2;
-    } elsif ($formatted_email =~ /^<(.*\@.*)>$/) {
+    } elsif ($formatted_email =~ /^\s*<(.*\@.*)>.*$/) {
 	$address = $1;
-    } elsif ($formatted_email =~ /^(.*\@.*)$/) {
+    } elsif ($formatted_email =~ /^\s*(.*\@.*)$/) {
 	$address = $1;
     }
 
@@ -557,6 +587,29 @@ sub which {
     return "";
 }
 
+sub mailmap {
+    my @lines = @_;
+    my %hash;
+
+    foreach my $line (@lines) {
+	my ($name, $address) = parse_email($line);
+	if (!exists($hash{$name})) {
+	    $hash{$name} = $address;
+	}
+	if (exists($mailmap{$name})) {
+	    my $obj = $mailmap{$name};
+	    foreach my $map_address (@$obj) {
+		if (($map_address eq $address) &&
+		    ($map_address ne $hash{$name})) {
+		    $line = format_email($name, $hash{$name});
+		}
+	    }
+	}
+    }
+
+    return @lines;
+}
+
 sub recent_git_signoffs {
     my ($file) = @_;
 
@@ -592,9 +645,10 @@ sub recent_git_signoffs {
     # cut -f2- -d":"
     s/.*:\s*(.+)\s*/$1/ for (@lines);
 
+    $total_sign_offs = @lines;
+
     @lines = mailmap(@lines);
 
-    $total_sign_offs = @lines;
     @lines = sort(@lines);
     # uniq -c
     foreach my $line (@lines) {
@@ -655,12 +709,12 @@ sub git_assign_blame {
 	    my $diff_start = $2;
 	    my $diff_length = $3;
 	    next if (!("$file" eq "$diff_file"));
-	    $cmd = "git blame -l -L $diff_start,+$diff_length $file\n";
+	    $cmd = "git blame -l -L $diff_start,+$diff_length $file";
 	    @commits = save_commits($cmd, @commits);
 	}
     } else {
 	if (-f $file) {
-	    $cmd = "git blame -l $file\n";
+	    $cmd = "git blame -l $file";
 	    @commits = save_commits($cmd, @commits);
 	}
     }
@@ -678,11 +732,15 @@ sub git_assign_blame {
 	if (!$email_git_penguin_chiefs) {
 	    @lines = grep(!/${penguin_chiefs}/i, @lines);
 	}
+
 	# cut -f2- -d":"
 	s/.*:\s*(.+)\s*/$1/ for (@lines);
 
-	$hash{$_}++ for @lines;
 	$total_sign_offs += @lines;
+
+	@lines = mailmap(@lines);
+
+	$hash{$_}++ for @lines;
     }
 
     $count = 0;
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

