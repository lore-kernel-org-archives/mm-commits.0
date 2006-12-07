From: akpm@osdl.org
Subject: - aio-kill-pointless-ki_nbytes-assignment-in-aio_setup_single_vector.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:17:07 -0800
Message-ID: <200612072317.kB7NH7OE030902@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53874 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163875AbWLGXRm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:17:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenneth.w.chen@intel.com, bcrl@kvack.org, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     aio: kill pointless ki_nbytes assignment in aio_setup_single_vector
has been removed from the -mm tree.  Its filename was
     aio-kill-pointless-ki_nbytes-assignment-in-aio_setup_single_vector.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: aio: kill pointless ki_nbytes assignment in aio_setup_single_vector
From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>

io_submit_one assigns ki_left = ki_nbytes = iocb->aio_nbytes, then calls
down to aio_setup_iocb, then to aio_setup_single_vector.  In there,
ki_nbytes is reassigned to the same value it got two call stack above it. 
There is no need to do so.

Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>
Acked-by: Zach Brown <zach.brown@oracle.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/aio.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/aio.c~aio-kill-pointless-ki_nbytes-assignment-in-aio_setup_single_vector fs/aio.c
--- a/fs/aio.c~aio-kill-pointless-ki_nbytes-assignment-in-aio_setup_single_vector
+++ a/fs/aio.c
@@ -1413,7 +1413,6 @@ static ssize_t aio_setup_single_vector(s
 	kiocb->ki_iovec->iov_len = kiocb->ki_left;
 	kiocb->ki_nr_segs = 1;
 	kiocb->ki_cur_seg = 0;
-	kiocb->ki_nbytes = kiocb->ki_left;
 	return 0;
 }
 
_

Patches currently in -mm which might be from kenneth.w.chen@intel.com are

origin.patch
optimize-o_direct-on-block-device-v3.patch
optimize-o_direct-on-block-device-v3-tweak.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-add-option-to-serialize-load-balancing-fix.patch
sched-improve-migration-accuracy.patch
sched-improve-migration-accuracy-tidy.patch
sched-remove-lb_stopbalance-counter.patch
sched-optimize-activate_task-for-rt-task.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch

