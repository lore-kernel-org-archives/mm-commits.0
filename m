From: akpm@linux-foundation.org
Subject: - checkpatch-include-asm-checks-should-be-anchored.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:24 -0700
Message-ID: <200810182313.m9INDOu9028179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751084AbYJRXNc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: include/asm checks should be anchored
has been removed from the -mm tree.  Its filename was
     checkpatch-include-asm-checks-should-be-anchored.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: include/asm checks should be anchored
From: Andy Whitcroft <apw@shadowen.org>

It is possible to have other include/asm paths within the tree which are
not subject to the do not edit checks.  Ignore those.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-include-asm-checks-should-be-anchored scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-include-asm-checks-should-be-anchored
+++ a/scripts/checkpatch.pl
@@ -1134,7 +1134,7 @@ sub process {
 			$realfile = $1;
 			$realfile =~ s@^[^/]*/@@;
 
-			if ($realfile =~ m@include/asm/@) {
+			if ($realfile =~ m@^include/asm/@) {
 				ERROR("do not modify files in include/asm, change architecture specific files in include/asm-<architecture>\n" . "$here$rawline\n");
 			}
 			next;
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

