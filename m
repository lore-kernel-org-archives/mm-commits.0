From: akpm@linux-foundation.org
Subject: - checkpatch-suspect-indent-skip-over-preprocessor-label-and-blank-lines.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:32 -0700
Message-ID: <200810182313.m9INDWJF028203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431AbYJRXNs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: suspect indent -- skip over preprocessor, label and blank lines
has been removed from the -mm tree.  Its filename was
     checkpatch-suspect-indent-skip-over-preprocessor-label-and-blank-lines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: suspect indent -- skip over preprocessor, label and blank lines
From: Andy Whitcroft <apw@shadowen.org>

We should skip over and check the lines which follow preprocessor
statements, labels, and blank lines.  These all have legitimate reasons to
be indented differently.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-suspect-indent-skip-over-preprocessor-label-and-blank-lines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-suspect-indent-skip-over-preprocessor-label-and-blank-lines
+++ a/scripts/checkpatch.pl
@@ -1434,7 +1434,7 @@ sub process {
 			if ($s =~ s/^\s*\\//) {
 				$continuation = 1;
 			}
-			if ($s =~ s/^\s*\n//) {
+			if ($s =~ s/^\s*?\n//) {
 				$check = 1;
 				$cond_lines++;
 			}
@@ -1446,15 +1446,20 @@ sub process {
 				$check = 0;
 			}
 
-			# Ignore the current line if its is a preprocessor
-			# line.
-			if ($s =~ /^\s*#\s*/) {
-				$check = 0;
-			}
-
-			# Ignore the current line if it is label.
-			if ($s =~ /^\s*$Ident\s*:/) {
-				$check = 0;
+			my $cond_ptr = -1;
+			while ($cond_ptr != $cond_lines) {
+				$cond_ptr = $cond_lines;
+
+				# Ignore:
+				#  1) blank lines, they should be at 0,
+				#  2) preprocessor lines, and
+				#  3) labels.
+				if ($s =~ /^\s*?\n/ ||
+				    $s =~ /^\s*#\s*?/ ||
+				    $s =~ /^\s*$Ident\s*:/) {
+					$s =~ s/^.*?\n//;
+					$cond_lines++;
+				}
 			}
 
 			my (undef, $sindent) = line_stats("+" . $s);
@@ -1470,7 +1475,7 @@ sub process {
 				$stat_real = "[...]\n$stat_real";
 			}
 
-			##print "line<$line> prevline<$prevline> indent<$indent> sindent<$sindent> check<$check> continuation<$continuation> s<$s> cond_lines<$cond_lines> stat_real<$stat_real> stat<$stat>\n";
+			#print "line<$line> prevline<$prevline> indent<$indent> sindent<$sindent> check<$check> continuation<$continuation> s<$s> cond_lines<$cond_lines> stat_real<$stat_real> stat<$stat>\n";
 
 			if ($check && (($sindent % 8) != 0 ||
 			    ($sindent <= $indent && $s ne ''))) {
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

