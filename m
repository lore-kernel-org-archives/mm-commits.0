Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7354C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 29 Sep 2021 23:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C69A461423
	for <mm-commits@archiver.kernel.org>; Wed, 29 Sep 2021 23:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347041AbhI2XpQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Sep 2021 19:45:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346682AbhI2XpQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 29 Sep 2021 19:45:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADDBE61269;
        Wed, 29 Sep 2021 23:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632959014;
        bh=jY8m1EZoRyNkIWGH2qSIgkPwICwFnEDz6Yl6aXv82rA=;
        h=Date:From:To:Subject:From;
        b=UUL4dXh9R8lK2e3/Oqy6xCGml8RuwOQfwTkGd/RKA5D328E4Pcv9SiMrNq3ZeONUJ
         dSmaC/NFyqmUhG0QyK5pGVnlpwcEMTZ3SpbA0RCbYg4YGT/izdLWTnzqDOvcgDkmyB
         G5ITcxWUmz3n3iHmunl98b988dHTexCOAt+kQSBI=
Date:   Wed, 29 Sep 2021 16:43:34 -0700
From:   akpm@linux-foundation.org
To:     bgeffon@google.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        senozhatsky@chromium.org
Subject:  + zram-introduce-an-aged-idle-interface-v6.patch added to
 -mm tree
Message-ID: <20210929234334.qZxwN3qB4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: Introduce an aged idle interface
has been added to the -mm tree.  Its filename is
     zram-introduce-an-aged-idle-interface-v6.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zram-introduce-an-aged-idle-interface-v6.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zram-introduce-an-aged-idle-interface-v6.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Brian Geffon <bgeffon@google.com>
Subject: zram: Introduce an aged idle interface

Sergey's cleanup suggestions

Link: https://lkml.kernel.org/r/20210929143056.13067-1-bgeffon@google.com
Signed-off-by: Brian Geffon <bgeffon@google.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-introduce-an-aged-idle-interface-v6
+++ a/drivers/block/zram/zram_drv.c
@@ -310,7 +310,7 @@ static void mark_idle(struct zram *zram,
 		if (zram_allocated(zram, index) &&
 				!zram_test_flag(zram, index, ZRAM_UNDER_WB)) {
 #ifdef CONFIG_ZRAM_MEMORY_TRACKING
-				is_idle = (!cutoff || ktime_after(cutoff, zram->table[index].ac_time));
+			is_idle = !cutoff || ktime_after(cutoff, zram->table[index].ac_time);
 #endif
 			if (is_idle)
 				zram_set_flag(zram, index, ZRAM_IDLE);
@@ -332,6 +332,7 @@ static ssize_t idle_store(struct device
 		 * we have memory tracking enabled.
 		 */
 		u64 age_sec;
+
 		if (IS_ENABLED(CONFIG_ZRAM_MEMORY_TRACKING) && !kstrtoull(buf, 0, &age_sec))
 			cutoff_time = ktime_sub(ktime_get_boottime(),
 					ns_to_ktime(age_sec * NSEC_PER_SEC));
@@ -343,7 +344,7 @@ static ssize_t idle_store(struct device
 	if (!init_done(zram))
 		goto out_unlock;
 
-	/* A age_sec of 0 marks everything as idle, this is the "all" behavior */
+	/* A cutoff_time of 0 marks everything as idle, this is the "all" behavior */
 	mark_idle(zram, cutoff_time);
 	rv = len;
 
_

Patches currently in -mm which might be from bgeffon@google.com are

zram-introduce-an-aged-idle-interface.patch
zram-introduce-an-aged-idle-interface-v5.patch
zram-introduce-an-aged-idle-interface-v6.patch

