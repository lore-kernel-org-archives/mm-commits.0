From: akpm@linux-foundation.org
Subject: [merged] workqueue-lock-cwq-access-in-drain_workqueue.patch removed from -mm tree
Date: Thu, 15 Sep 2011 12:37:05 -0700
Message-ID: <201109151937.p8FJb51v014987@hpaq12.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:10948 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934575Ab1IOThu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2011 15:37:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ttuttle@chromium.org, stable@kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     workqueue: lock cwq access in drain_workqueue
has been removed from the -mm tree.  Its filename was
     workqueue-lock-cwq-access-in-drain_workqueue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: workqueue: lock cwq access in drain_workqueue
From: Thomas Tuttle <ttuttle@chromium.org>

Take cwq->gcwq->lock to avoid racing between drain_workqueue checking to
make sure the workqueues are empty and cwq_dec_nr_in_flight decrementing
and then incrementing nr_active when it activates a delayed work.

We discovered this when a corner case in one of our drivers resulted in us
trying to destroy a workqueue in which the remaining work would always
requeue itself again in the same workqueue.  We would hit this race
condition and trip the BUG_ON on workqueue.c:3080.

Signed-off-by: Thomas Tuttle <ttuttle@chromium.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN kernel/workqueue.c~workqueue-lock-cwq-access-in-drain_workqueue kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-lock-cwq-access-in-drain_workqueue
+++ a/kernel/workqueue.c
@@ -2412,8 +2412,13 @@ reflush:
 
 	for_each_cwq_cpu(cpu, wq) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+		bool drained;
 
-		if (!cwq->nr_active && list_empty(&cwq->delayed_works))
+		spin_lock_irq(&cwq->gcwq->lock);
+		drained = !cwq->nr_active && list_empty(&cwq->delayed_works);
+		spin_unlock_irq(&cwq->gcwq->lock);
+
+		if (drained)
 			continue;
 
 		if (++flush_cnt == 10 ||
_

Patches currently in -mm which might be from ttuttle@chromium.org are

origin.patch

