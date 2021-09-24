Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6CFCC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 19:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEBEF610EA
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 19:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345937AbhIXT4H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 15:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344832AbhIXT4H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 15:56:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 946A36103D;
        Fri, 24 Sep 2021 19:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632513273;
        bh=M9sF0lpmPTPw7Mr1ASJcgK2RRhZ1520U78fF2skPPGY=;
        h=Date:From:To:Subject:From;
        b=mydB4KbJfvCYuDeMU7o24blF4XVFIsGl85v4QXqNlqB+qGUuPcWo6Qex2w2r26bPT
         PJPjk1jVrb9JQzIYoZWQJtQlFipj3hZp6XGbufLc8APSg+TAfRP5oKb8bCpq01c7tW
         6MA8nql2mNu3/9IcT64B0NAuu9OsLahnPTUzJTCg=
Date:   Fri, 24 Sep 2021 12:54:33 -0700
From:   akpm@linux-foundation.org
To:     bgeffon@google.com, minchan@kernel.org, mm-commits@vger.kernel.org
Subject:  + zram-introduce-an-aged-idle-interface-v5.patch added to
 -mm tree
Message-ID: <20210924195433.ISDhnI8Dk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram-introduce-an-aged-idle-interface-v5
has been added to the -mm tree.  Its filename is
     zram-introduce-an-aged-idle-interface-v5.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zram-introduce-an-aged-idle-interface-v5.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zram-introduce-an-aged-idle-interface-v5.patch

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
Subject: zram-introduce-an-aged-idle-interface-v5

use IS_ENABLED and cleanup comment

Link: https://lkml.kernel.org/r/20210924161128.1508015-1-bgeffon@google.com
Signed-off-by: Brian Geffon <bgeffon@google.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-introduce-an-aged-idle-interface-v5
+++ a/drivers/block/zram/zram_drv.c
@@ -294,7 +294,7 @@ static ssize_t mem_used_max_store(struct
 /*
  * Mark all pages which are older than or equal to cutoff as IDLE.
  * Callers should hold the zram init lock in read mode
- **/
+ */
 static void mark_idle(struct zram *zram, ktime_t cutoff)
 {
 	int is_idle = 1;
@@ -310,7 +310,7 @@ static void mark_idle(struct zram *zram,
 		if (zram_allocated(zram, index) &&
 				!zram_test_flag(zram, index, ZRAM_UNDER_WB)) {
 #ifdef CONFIG_ZRAM_MEMORY_TRACKING
-			is_idle = (!cutoff || ktime_after(cutoff, zram->table[index].ac_time));
+				is_idle = (!cutoff || ktime_after(cutoff, zram->table[index].ac_time));
 #endif
 			if (is_idle)
 				zram_set_flag(zram, index, ZRAM_IDLE);
@@ -327,14 +327,15 @@ static ssize_t idle_store(struct device
 	ssize_t rv = -EINVAL;
 
 	if (!sysfs_streq(buf, "all")) {
-#ifdef CONFIG_ZRAM_MEMORY_TRACKING
+		/*
+		 * If it did not parse as 'all' try to treat it as an integer when
+		 * we have memory tracking enabled.
+		 */
 		u64 age_sec;
-		/* If it did not parse as 'all' try to treat it as an integer */
-		if (!kstrtoull(buf, 0, &age_sec))
+		if (IS_ENABLED(CONFIG_ZRAM_MEMORY_TRACKING) && !kstrtoull(buf, 0, &age_sec))
 			cutoff_time = ktime_sub(ktime_get_boottime(),
 					ns_to_ktime(age_sec * NSEC_PER_SEC));
 		else
-#endif
 			goto out;
 	}
 
_

Patches currently in -mm which might be from bgeffon@google.com are

zram-introduce-an-aged-idle-interface.patch
zram-introduce-an-aged-idle-interface-v5.patch

