From: akpm@linux-foundation.org
Subject: [patch 50/51] checkpatch: fix ignoring cover-letter logic
Date: Tue, 03 Oct 2017 16:16:51 -0700
Message-ID: <59d41a63.xmqMHorD2lnyqJHU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58948 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXQx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:16:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, shorne@gmail.com, joe@perches.com

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
