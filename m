From: akpm@linux-foundation.org
Subject: - checkpatch-fix-the-perlcritic-errors.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:17:10 -0800
Message-ID: <200901072217.n07MHAv7016810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758315AbZAGWRm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:17:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: fix the perlcritic errors
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-the-perlcritic-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

