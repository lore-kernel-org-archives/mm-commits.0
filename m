From: akpm@linux-foundation.org
Subject: + writeback-simplify-wb_stat_sum.patch added to -mm tree
Date: Mon, 26 Jun 2017 14:53:40 -0700
Message-ID: <59518264.ouYYvmR0ZhAdM95W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34036 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751439AbdFZVxl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jun 2017 17:53:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nborisov@suse.com, a.p.zijlstra@chello.nl, axboe@fb.com, jack@suse.cz, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/backing-dev.h: simplify wb_stat_sum
has been added to the -mm tree.  Its filename is
     writeback-simplify-wb_stat_sum.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/writeback-simplify-wb_stat_sum.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/writeback-simplify-wb_stat_sum.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
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
