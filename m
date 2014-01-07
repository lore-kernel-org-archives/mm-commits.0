From: akpm@linux-foundation.org
Subject: +
 lib-percpu_counterc-disable-local-irq-when-updating-percpu-couter.patch
 added to -mm tree
Date: Tue, 07 Jan 2014 14:28:34 -0800
Message-ID: <52cc7f92.zuJBYU73waXmCOFC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbaAGW2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jan 2014 17:28:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, shli@fusionio.com, paul.gortmaker@windriver.com, fan.du@windriver.com, axboe@kernel.dk, akpm@linux-foundation.org, tom.leiming@gmail.com

Subject: + lib-percpu_counterc-disable-local-irq-when-updating-percpu-couter.patch added to -mm tree
To: tom.leiming@gmail.com,akpm@linux-foundation.org,axboe@kernel.dk,fan.du@windriver.com,paul.gortmaker@windriver.com,shli@fusionio.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 07 Jan 2014 14:28:34 -0800


The patch titled
     Subject: lib/percpu_counter.c: disable local irq when updating percpu couter
has been added to the -mm tree.  Its filename is
     lib-percpu_counterc-disable-local-irq-when-updating-percpu-couter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-percpu_counterc-disable-local-irq-when-updating-percpu-couter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-percpu_counterc-disable-local-irq-when-updating-percpu-couter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ming Lei <tom.leiming@gmail.com>
Subject: lib/percpu_counter.c: disable local irq when updating percpu couter

__percpu_counter_add() may be called in softirq/hardirq handler (such as,
blk_mq_queue_exit() is typically called in hardirq/softirq handler), so we
need to disable local irq when updating the percpu counter, otherwise
counts may be lost.

The patch fixes problem that 'rmmod null_blk' may hang in blk_cleanup_queue()
because of miscounting of request_queue->mq_usage_counter.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Fan Du <fan.du@windriver.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu_counter.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN lib/percpu_counter.c~lib-percpu_counterc-disable-local-irq-when-updating-percpu-couter lib/percpu_counter.c
--- a/lib/percpu_counter.c~lib-percpu_counterc-disable-local-irq-when-updating-percpu-couter
+++ a/lib/percpu_counter.c
@@ -75,19 +75,19 @@ EXPORT_SYMBOL(percpu_counter_set);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 {
 	s64 count;
+	unsigned long flags;
 
-	preempt_disable();
+	raw_local_irq_save(flags);
 	count = __this_cpu_read(*fbc->counters) + amount;
 	if (count >= batch || count <= -batch) {
-		unsigned long flags;
-		raw_spin_lock_irqsave(&fbc->lock, flags);
+		raw_spin_lock(&fbc->lock);
 		fbc->count += count;
-		raw_spin_unlock_irqrestore(&fbc->lock, flags);
+		raw_spin_unlock(&fbc->lock);
 		__this_cpu_write(*fbc->counters, 0);
 	} else {
 		__this_cpu_write(*fbc->counters, count);
 	}
-	preempt_enable();
+	raw_local_irq_restore(flags);
 }
 EXPORT_SYMBOL(__percpu_counter_add);
 
_

Patches currently in -mm which might be from tom.leiming@gmail.com are

lib-percpu_counterc-disable-local-irq-when-updating-percpu-couter.patch
linux-next.patch

