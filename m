From: akpm@linux-foundation.org
Subject: + lib-percpu_counterc-fix-__percpu_counter_add.patch added to -mm tree
Date: Mon, 13 Jan 2014 13:39:52 -0800
Message-ID: <52d45d28.eXWr5R9oTfrsOBtW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaAMVjx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jan 2014 16:39:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shli@fusionio.com, paul.gortmaker@windriver.com, fan.du@windriver.com, axboe@kernel.dk, tom.leiming@gmail.com

Subject: + lib-percpu_counterc-fix-__percpu_counter_add.patch added to -mm tree
To: tom.leiming@gmail.com,axboe@kernel.dk,fan.du@windriver.com,paul.gortmaker@windriver.com,shli@fusionio.com
From: akpm@linux-foundation.org
Date: Mon, 13 Jan 2014 13:39:52 -0800


The patch titled
     Subject: lib/percpu_counter.c: fix __percpu_counter_add
has been added to the -mm tree.  Its filename is
     lib-percpu_counterc-fix-__percpu_counter_add.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-percpu_counterc-fix-__percpu_counter_add.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-percpu_counterc-fix-__percpu_counter_add.patch

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
Subject: lib/percpu_counter.c: fix __percpu_counter_add

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

lib-percpu_counterc-fix-__percpu_counter_add.patch
linux-next.patch

