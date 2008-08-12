From: akpm@linux-foundation.org
Subject: + checkpatch-suspect-indent-skip-over-preprocessor-label-and-blank-lines.patch added to -mm tree
Date: Tue, 12 Aug 2008 15:27:06 -0700
Message-ID: <200808122227.m7CMR6Ql016734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967AbYHLWbI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 18:31:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     checkpatch: suspect indent -- skip over preprocessor, label and blank lines
has been added to the -mm tree.  Its filename is
     checkpatch-suspect-indent-skip-over-preprocessor-label-and-blank-lines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

hugetlbfs-allocate-structures-for-reservation-tracking-outside-of-spinlocks.patch
allocate-structures-for-reservation-tracking-in-hugetlbfs-outside-of-spinlocks-v2.patch
checkpatch-square-brackets-exemption-for-array-slices-in-braces.patch
checkpatch-values-double-ampersand-may-be-unary.patch
checkpatch-conditional-indent-labels-have-different-indent-rules.patch
checkpatch-switch-indent-allow-plain-return.patch
checkpatch-add-tests-for-the-attribute-matcher.patch
checkpatch-____cacheline_aligned-et-al-are-modifiers.patch
checkpatch-complex-macros-fix-up-extension-handling.patch
checkpatch-fix-up-comment-checks-search-to-scan-the-entire-block.patch
checkpatch-include-asm-checks-should-be-anchored.patch
checkpatch-reduce-warnings-for-include-of-asm-fooh-to-check-from-arch-barc.patch
checkpatch-report-any-absolute-references-to-kernel-source-files.patch
checkpatch-report-the-real-first-line-of-all-suspect-indents.patch
checkpatch-suspect-indent-skip-over-preprocessor-label-and-blank-lines.patch
checkpatch-%lx-tests-should-hand-%%-as-a-literal.patch
checkpatch-report-the-correct-lines-for-single-statement-blocks.patch
checkpatch-perform-indent-checks-on-perl.patch
checkpatch-version-022.patch
page-owner-tracking-leak-detector.patch

