From: akpm@linux-foundation.org
Subject: - checkpatch-suspect-code-indent-must-stop-at-else-elif.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:14:08 -0700
Message-ID: <200810182314.m9INE8CX028342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751510AbYJRXOQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:14:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: suspect code indent must stop at #else/#elif
has been removed from the -mm tree.  Its filename was
     checkpatch-suspect-code-indent-must-stop-at-else-elif.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: suspect code indent must stop at #else/#elif
From: Andy Whitcroft <apw@shadowen.org>

When we hit and #else or #elif we know we are meeting an alternative piece
of code.  All bets are off on indent if we did not see the open of the
control so stop checking.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-suspect-code-indent-must-stop-at-else-elif scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-suspect-code-indent-must-stop-at-else-elif
+++ a/scripts/checkpatch.pl
@@ -1468,6 +1468,12 @@ sub process {
 			while ($cond_ptr != $cond_lines) {
 				$cond_ptr = $cond_lines;
 
+				# If we see an #else/#elif then the code
+				# is not linear.
+				if ($s =~ /^\s*\#\s*(?:else|elif)/) {
+					$check = 0;
+				}
+
 				# Ignore:
 				#  1) blank lines, they should be at 0,
 				#  2) preprocessor lines, and
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

