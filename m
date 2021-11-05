Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABAF2C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:46:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90D9561186
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:46:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbhKEStB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:49:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231904AbhKEStB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 14:49:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3871F611C0;
        Fri,  5 Nov 2021 18:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636137981;
        bh=9nuqn4ZKQjW3VbXKxueRKkkTRxoaTwsyJ3TH6/l2+D8=;
        h=Date:From:To:Subject:From;
        b=ur6fgUrF310HUMCutfO22GzuLqCpCWGigBYQGjS+L6EMAAEf9xVlLLYWgjEcs85K2
         YWapyHSe2H/eFJ/54IomaDK6l7YpMzVw8ISWhPL/Dr9HzAoMcaiggV8SVi8q8+oqMh
         1PWXcW/VFx4HmP+KEc0whbxn5/wvx7jMvYaRiIXI=
Date:   Fri, 05 Nov 2021 11:46:20 -0700
From:   akpm@linux-foundation.org
To:     bgeffon@google.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        senozhatsky@chromium.org
Subject:  [folded-merged]
 zram-introduce-an-aged-idle-interface-v6.patch removed from -mm tree
Message-ID: <20211105184620.3531q1N3b%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: Introduce an aged idle interface
has been removed from the -mm tree.  Its filename was
     zram-introduce-an-aged-idle-interface-v6.patch

This patch was dropped because it was folded into zram-introduce-an-aged-idle-interface.patch

------------------------------------------------------
From: Brian Geffon <bgeffon@google.com>
Subject: zram: Introduce an aged idle interface

Sergey's cleanup suggestions

Link: https://lkml.kernel.org/r/20210929143056.13067-1-bgeffon@google.com
Signed-off-by: Brian Geffon <bgeffon@google.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
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

