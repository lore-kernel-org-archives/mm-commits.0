From: akpm@linux-foundation.org
Subject: [patch 048/115] include/linux/backing-dev.h: simplify
 wb_stat_sum
Date: Mon, 10 Jul 2017 15:49:35 -0700
Message-ID: <20170710224935.jjbb1Efe6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42846 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754963AbdGJWth (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:49:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@fb.com, jack@suse.cz, mm-commits@vger.kernel.org, nborisov@suse.com, peterz@infradead.org, tj@kernel.org, torvalds@linux-foundation.org

From: Nikolay Borisov <nborisov@suse.com>
Subject: include/linux/backing-dev.h: simplify wb_stat_sum

wb_stat_sum() disables interrupts and calls __wb_stat_sum() which
eventually calls __percpu_counter_sum().  However, the percpu routine is
already irq-safe.  Simplify the code a bit by making wb_stat_sum()
directly call percpu_counter_sum_positive() and not disable interrupts. 
Also remove the now-uneeded __wb_stat_sum() which was just a wrapper over
percpu_counter_sum_positive().

Link: http://lkml.kernel.org/r/1498230681-29103-1-git-send-email-nborisov@suse.com
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff -puN include/linux/backing-dev.h~writeback-simplify-wb_stat_sum include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~writeback-simplify-wb_stat_sum
+++ a/include/linux/backing-dev.h
@@ -104,22 +104,9 @@ static inline s64 wb_stat(struct bdi_wri
 	return percpu_counter_read_positive(&wb->stat[item]);
 }
 
-static inline s64 __wb_stat_sum(struct bdi_writeback *wb,
-				enum wb_stat_item item)
-{
-	return percpu_counter_sum_positive(&wb->stat[item]);
-}
-
 static inline s64 wb_stat_sum(struct bdi_writeback *wb, enum wb_stat_item item)
 {
-	s64 sum;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	sum = __wb_stat_sum(wb, item);
-	local_irq_restore(flags);
