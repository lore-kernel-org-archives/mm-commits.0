From: akpm@linux-foundation.org
Subject: - checkpatch-complex-macros-fix-up-extension-handling.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:20 -0700
Message-ID: <200810182313.m9INDKsO028167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388AbYJRXN2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: complex macros -- fix up extension handling
has been removed from the -mm tree.  Its filename was
     checkpatch-complex-macros-fix-up-extension-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: complex macros -- fix up extension handling
From: Andy Whitcroft <apw@shadowen.org>

Only pull in new extension lines where the current contents ends with a \.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-complex-macros-fix-up-extension-handling scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-complex-macros-fix-up-extension-handling
+++ a/scripts/checkpatch.pl
@@ -1977,8 +1977,8 @@ sub process {
 			# Extract the remainder of the define (if any) and
 			# rip off surrounding spaces, and trailing \'s.
 			$rest = '';
-			while ($off != 0 || ($cnt > 0 && $rest =~ /(?:^|\\)\s*$/)) {
-				#print "ADDING $off <" . substr($lines[$ln - 1], $off) . ">\n";
+			while ($off != 0 || ($cnt > 0 && $rest =~ /\\\s*$/)) {
+				#print "ADDING cnt<$cnt> $off <" . substr($lines[$ln - 1], $off) . "> rest<$rest>\n";
 				if ($off != 0 || $lines[$ln - 1] !~ /^-/) {
 					$rest .= substr($lines[$ln - 1], $off) . "\n";
 					$cnt--;
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

