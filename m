Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11542C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E85C261186
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbhKESs6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:48:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232952AbhKESs6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 14:48:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 679DC6023D;
        Fri,  5 Nov 2021 18:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636137978;
        bh=RyQBqcZPkymiFM8BJkLLSumelMiZUffHp3OZrLpwvN4=;
        h=Date:From:To:Subject:From;
        b=UOKcXohEKzospykVLRLS80yes3T6CRRPykJ6OHBIIpO97szXr76o8y4a6qZRnpLJE
         wtjn8/RG7jqDZHfqnK6hEnyLMsxGKxxW1Hy+nIvxuvsxrxeyGT6OusqkSjQMyB1IZ1
         bG5yWC0av6evTa7xJW9zTNPJLlC/M+NhMtRO+mQM=
Date:   Fri, 05 Nov 2021 11:46:17 -0700
From:   akpm@linux-foundation.org
To:     bgeffon@google.com, minchan@kernel.org, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 zram-introduce-an-aged-idle-interface-v5.patch removed from -mm tree
Message-ID: <20211105184617.-HoNUPWBP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram-introduce-an-aged-idle-interface-v5
has been removed from the -mm tree.  Its filename was
     zram-introduce-an-aged-idle-interface-v5.patch

This patch was dropped because it was folded into zram-introduce-an-aged-idle-interface.patch

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
zram-introduce-an-aged-idle-interface-v6.patch

