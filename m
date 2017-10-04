From: akpm@linux-foundation.org
Subject: [merged] checkpatch-fix-ignoring-cover-letter-logic.patch
 removed from -mm tree
Date: Wed, 04 Oct 2017 12:42:20 -0700
Message-ID: <20171004194220.C7I0PWKAW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33806 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDTmV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:42:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org, shorne@gmail.com


The patch titled
     Subject: checkpatch: fix ignoring cover-letter logic
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-ignoring-cover-letter-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stafford Horne <shorne@gmail.com>
Subject: checkpatch: fix ignoring cover-letter logic

Currently running checkpatch on a directory with a cover-letter.patch
file reports the following error:

  -----------------------------------------
  patches/smp-v2/v2-0000-cover-letter.patch
  -----------------------------------------

  ERROR: Does not appear to be a unified-diff format patch

The logic to suppress the unified-diff check for cover letters is there
but is checking $file instead of $filename.  Fix the variable to use the
correct one.

Link: http://lkml.kernel.org/r/20170909090406.31523-1-shorne@gmail.com
Signed-off-by: Stafford Horne <shorne@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-ignoring-cover-letter-logic scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-ignoring-cover-letter-logic
+++ a/scripts/checkpatch.pl
@@ -6390,7 +6390,7 @@ sub process {
 		exit(0);
 	}
 
-	if (!$is_patch && $file !~ /cover-letter\.patch$/) {
+	if (!$is_patch && $filename !~ /cover-letter\.patch$/) {
 		ERROR("NOT_UNIFIED_DIFF",
 		      "Does not appear to be a unified-diff format patch\n");
 	}
_

Patches currently in -mm which might be from shorne@gmail.com are


