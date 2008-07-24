From: akpm@linux-foundation.org
Subject: - checkpatch-macros-fix-statement-counting-block-end-detection.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:26:22 -0700
Message-ID: <200807242326.m6ONQM9H010971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755878AbYGXX0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:26:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: macros: fix statement counting block end detection
has been removed from the -mm tree.  Its filename was
     checkpatch-macros-fix-statement-counting-block-end-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: macros: fix statement counting block end detection
From: Andy Whitcroft <apw@shadowen.org>

We are incorrectly counting the lines in a block while accumulating
the trailing lines in a macro statement, leading to false positives.
Fix end of block handling and general counting for negative context lines.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-macros-fix-statement-counting-block-end-detection scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-macros-fix-statement-counting-block-end-detection
+++ a/scripts/checkpatch.pl
@@ -470,7 +470,9 @@ sub ctx_statement_block {
 		}
 		$off++;
 	}
+	# We are truly at the end, so shuffle to the next line.
 	if ($off == $len) {
+		$loff = $len + 1;
 		$line++;
 		$remain--;
 	}
@@ -1793,30 +1795,26 @@ sub process {
 				$lines[$ln - 1] =~ /^(?:-|..*\\$)/)
 			{
 				$ctx .= $rawlines[$ln - 1] . "\n";
+				$cnt-- if ($lines[$ln - 1] !~ /^-/);
 				$ln++;
-				$cnt--;
 			}
 			$ctx .= $rawlines[$ln - 1];
 
 			($dstat, $dcond, $ln, $cnt, $off) =
 				ctx_statement_block($linenr, $ln - $linenr + 1, 0);
 			#print "dstat<$dstat> dcond<$dcond> cnt<$cnt> off<$off>\n";
-			#print "LINE<$lines[$ln]> len<" . length($lines[$ln]) . "\n";
+			#print "LINE<$lines[$ln-1]> len<" . length($lines[$ln-1]) . "\n";
 
 			# Extract the remainder of the define (if any) and
 			# rip off surrounding spaces, and trailing \'s.
 			$rest = '';
-			if (defined $lines[$ln - 1] &&
-			    $off > length($lines[$ln - 1]))
-			{
-				$ln++;
-				$cnt--;
-				$off = 0;
-			}
-			while ($cnt > 0) {
-				$rest .= substr($lines[$ln - 1], $off) . "\n";
+			while ($off != 0 || ($cnt > 0 && $rest =~ /(?:^|\\)\s*$/)) {
+				#print "ADDING $off <" . substr($lines[$ln - 1], $off) . ">\n";
+				if ($off != 0 || $lines[$ln - 1] !~ /^-/) {
+					$rest .= substr($lines[$ln - 1], $off) . "\n";
+					$cnt--;
+				}
 				$ln++;
-				$cnt--;
 				$off = 0;
 			}
 			$rest =~ s/\\\n.//g;
@@ -1847,6 +1845,7 @@ sub process {
 				DEFINE_PER_CPU|
 				__typeof__\(
 			}x;
+			#print "REST<$rest>\n";
 			if ($rest ne '') {
 				if ($rest !~ /while\s*\(/ &&
 				    $dstat !~ /$exceptions/)
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
page-owner-tracking-leak-detector.patch

