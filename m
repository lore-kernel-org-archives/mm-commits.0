From: akpm@linux-foundation.org
Subject: + checkpatch-fix-ignoring-cover-letter-logic.patch added to -mm
 tree
Date: Mon, 02 Oct 2017 16:06:16 -0700
Message-ID: <59d2c668.yWfPw3ZR/dzyx63D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45876 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdJBXGR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2017 19:06:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shorne@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix ignoring cover-letter logic
has been added to the -mm tree.  Its filename is
     checkpatch-fix-ignoring-cover-letter-logic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-ignoring-cover-letter-logic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-ignoring-cover-letter-logic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatch-fix-ignoring-cover-letter-logic.patch

