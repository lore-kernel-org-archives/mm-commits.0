From: akpm@linux-foundation.org
Subject: - checkpatch-labels-are-not-possible-types.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:58 -0700
Message-ID: <200810182313.m9INDwMR028297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096AbYJRXOI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:14:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: labels are not possible types
has been removed from the -mm tree.  Its filename was
     checkpatch-labels-are-not-possible-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: labels are not possible types
From: Andy Whitcroft <apw@shadowen.org>

A label is not a candidate for a possible type.  Exclude them.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-labels-are-not-possible-types scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-labels-are-not-possible-types
+++ a/scripts/checkpatch.pl
@@ -1324,7 +1324,7 @@ sub process {
 				possible($type, "A:" . $s);
 
 			# definitions in global scope can only start with types
-			} elsif ($s =~ /^.(?:$Storage\s+)?(?:$Inline\s+)?(?:const\s+)?($Ident)\b/s) {
+			} elsif ($s =~ /^.(?:$Storage\s+)?(?:$Inline\s+)?(?:const\s+)?($Ident)\b\s*(?!:)/s) {
 				possible($1, "B:" . $s);
 			}
 
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

