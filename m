From: akpm@linux-foundation.org
Subject: + workqueue-lock-cwq-access-in-drain_workqueue.patch added to -mm tree
Date: Wed, 14 Sep 2011 13:43:30 -0700
Message-ID: <201109142043.p8EKhUO4007639@hpaq6.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15141 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143Ab1INUoQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2011 16:44:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ttuttle@chromium.org, stable@kernel.org, tj@kernel.org


The patch titled
     workqueue: lock cwq access in drain_workqueue
has been added to the -mm tree.  Its filename is
     workqueue-lock-cwq-access-in-drain_workqueue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

workqueue-lock-cwq-access-in-drain_workqueue.patch

