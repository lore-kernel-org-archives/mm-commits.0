From: akpm@linux-foundation.org
Subject: - checkpatch-report-the-correct-lines-for-single-statement-blocks.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:36 -0700
Message-ID: <200810182313.m9INDaUD028227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413AbYJRXNr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: report the correct lines for single statement blocks
has been removed from the -mm tree.  Its filename was
     checkpatch-report-the-correct-lines-for-single-statement-blocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: report the correct lines for single statement blocks
From: Andy Whitcroft <apw@shadowen.org>

Report the correct lines for single statement blocks.  Currently we are
reporting the right number of lines, but not skipping the negative lines.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-report-the-correct-lines-for-single-statement-blocks scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-report-the-correct-lines-for-single-statement-blocks
+++ a/scripts/checkpatch.pl
@@ -2214,10 +2214,10 @@ sub process {
 			}
 			if ($level == 0 && $block =~ /^\s*\{/ && !$allowed) {
 				my $herectx = $here . "\n";;
-				my $end = $linenr + statement_rawlines($block) - 1;
+				my $cnt = statement_rawlines($block);
 
-				for (my $ln = $linenr - 1; $ln < $end; $ln++) {
-					$herectx .= $rawlines[$ln] . "\n";;
+				for (my $n = 0; $n < $cnt; $n++) {
+					$herectx .= raw_line($linenr, $n) . "\n";;
 				}
 
 				WARN("braces {} are not necessary for single statement blocks\n" . $herectx);
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

