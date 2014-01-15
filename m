From: akpm@linux-foundation.org
Subject: [merged] lib-percpu_counterc-fix-__percpu_counter_add.patch
 removed from -mm tree
Date: Wed, 15 Jan 2014 12:28:50 -0800
Message-ID: <52d6ef82.uxEN3KWordRqLOmn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaAOU2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jan 2014 15:28:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shli@fusionio.com, paul.gortmaker@windriver.com, fan.du@windriver.com, axboe@kernel.dk, tom.leiming@gmail.com

Subject: [merged] lib-percpu_counterc-fix-__percpu_counter_add.patch removed from -mm tree
To: tom.leiming@gmail.com,axboe@kernel.dk,fan.du@windriver.com,paul.gortmaker@windriver.com,shli@fusionio.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 15 Jan 2014 12:28:50 -0800


The patch titled
     Subject: lib/percpu_counter.c: fix __percpu_counter_add()
has been removed from the -mm tree.  Its filename was
     lib-percpu_counterc-fix-__percpu_counter_add.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ming Lei <tom.leiming@gmail.com>
Subject: lib/percpu_counter.c: fix __percpu_counter_add()

__percpu_counter_add() may be called in softirq/hardirq handler (such as,
blk_mq_queue_exit() is typically called in hardirq/softirq handler), so we
need to call this_cpu_add()(irq safe helper) to update percpu counter,
otherwise counts may be lost.

The patch fixes problem that 'rmmod null_blk' hangs in blk_cleanup_queue()
because of miscounting of request_queue->mq_usage_counter.

This patch is the v1 of previous one of "lib/percpu_counter.c:
disable local irq when updating percpu couter", and takes Andrew's
approach which may be more efficient for ARCHs(x86, s390) that
have optimized this_cpu_add().

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Fan Du <fan.du@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu_counter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/percpu_counter.c~lib-percpu_counterc-fix-__percpu_counter_add lib/percpu_counter.c
--- a/lib/percpu_counter.c~lib-percpu_counterc-fix-__percpu_counter_add
+++ a/lib/percpu_counter.c
@@ -82,10 +82,10 @@ void __percpu_counter_add(struct percpu_
 		unsigned long flags;
 		raw_spin_lock_irqsave(&fbc->lock, flags);
 		fbc->count += count;
+		 __this_cpu_sub(*fbc->counters, count);
 		raw_spin_unlock_irqrestore(&fbc->lock, flags);
-		__this_cpu_write(*fbc->counters, 0);
 	} else {
-		__this_cpu_write(*fbc->counters, count);
+		this_cpu_add(*fbc->counters, amount);
 	}
 	preempt_enable();
 }
_

Patches currently in -mm which might be from tom.leiming@gmail.com are

origin.patch
linux-next.patch

