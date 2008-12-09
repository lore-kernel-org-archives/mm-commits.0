From: akpm@linux-foundation.org
Subject: + checkpatch-fix-the-perlcritic-errors.patch added to -mm tree
Date: Mon, 08 Dec 2008 16:04:48 -0800
Message-ID: <200812090004.mB904mWO031264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753623AbYLIAOA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 19:14:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com


The patch titled
     checkpatch: fix the perlcritic errors
has been added to the -mm tree.  Its filename is
     checkpatch-fix-the-perlcritic-errors.patch

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
Subject: checkpatch: fix the perlcritic errors
From: Andy Whitcroft <apw@canonical.com>

Clean up checkpatch using perlcritic.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-the-perlcritic-errors scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-the-perlcritic-errors
+++ a/scripts/checkpatch.pl
@@ -69,7 +69,9 @@ my $dbg_possible = 0;
 my $dbg_type = 0;
 my $dbg_attr = 0;
 for my $key (keys %debug) {
-	eval "\${dbg_$key} = '$debug{$key}';"
+	## no critic
+	eval "\${dbg_$key} = '$debug{$key}';";
+	die "$@" if ($@);
 }
 
 if ($terse) {
@@ -206,9 +208,9 @@ my @dep_includes = ();
 my @dep_functions = ();
 my $removal = "Documentation/feature-removal-schedule.txt";
 if ($tree && -f "$root/$removal") {
-	open(REMOVE, "<$root/$removal") ||
+	open(my $REMOVE, '<', "$root/$removal") ||
 				die "$P: $removal: open failed - $!\n";
-	while (<REMOVE>) {
+	while (<$REMOVE>) {
 		if (/^Check:\s+(.*\S)/) {
 			for my $entry (split(/[, ]+/, $1)) {
 				if ($entry =~ m@include/(.*)@) {
@@ -220,17 +222,21 @@ if ($tree && -f "$root/$removal") {
 			}
 		}
 	}
+	close($REMOVE);
 }
 
 my @rawlines = ();
 my @lines = ();
 my $vname;
 for my $filename (@ARGV) {
+	my $FILE;
 	if ($file) {
-		open(FILE, "diff -u /dev/null $filename|") ||
+		open($FILE, '-|', "diff -u /dev/null $filename") ||
 			die "$P: $filename: diff failed - $!\n";
+	} elsif ($filename eq '-') {
+		open($FILE, '<&STDIN');
 	} else {
-		open(FILE, "<$filename") ||
+		open($FILE, '<', "$filename") ||
 			die "$P: $filename: open failed - $!\n";
 	}
 	if ($filename eq '-') {
@@ -238,11 +244,11 @@ for my $filename (@ARGV) {
 	} else {
 		$vname = $filename;
 	}
-	while (<FILE>) {
+	while (<$FILE>) {
 		chomp;
 		push(@rawlines, $_);
 	}
-	close(FILE);
+	close($FILE);
 	if (!process($filename)) {
 		$exit = 1;
 	}
_

Patches currently in -mm which might be from apw@canonical.com are

linux-next.patch
checkpatch-update-copyrights.patch
checkpatch-add-warning-for-p0-patches.patch
checkpatch-allow-parentheses-on-return-for-comparisons.patch
checkpatch-try-to-catch-missing-vmlinux_symbol-in-vmlinuxldsh.patch
checkpatch-loosen-spacing-on-typedef-function-checks.patch
checkpatch-fix-continuation-detection-when-handling-spacing-on-operators.patch
checkpatch-track-ifdef-else-endif-when-tracking-blocks.patch
checkpatch-do-not-report-nr_static-as-a-static-declaration.patch
checkpatch-ensure-we-actually-detect-if-assignments-split-across-lines.patch
checkpatch-struct-file_operations-should-normally-be-const.patch
checkpatch-fix-the-perlcritic-errors.patch
checkpatch-version-026.patch

