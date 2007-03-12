From: akpm@linux-foundation.org
Subject: + sched-implement-rsdl-cpu-scheduler-accounting-fixes.patch added to -mm tree
Date: Sun, 11 Mar 2007 16:17:39 -0800
Message-ID: <200703120017.l2C0HdJZ022786@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34026 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966134AbXCLAR7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 20:17:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kernel@kolivas.org, mingo@elte.hu, nickpiggin@yahoo.com.au, suresh.b.siddha@intel.com


The patch titled
     sched: rsdl accounting fixes
has been added to the -mm tree.  Its filename is
     sched-implement-rsdl-cpu-scheduler-accounting-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: rsdl accounting fixes
From: Con Kolivas <kernel@kolivas.org>

Higher priority tasks should always preempt lower priority tasks if they
are queued higher than their static priority as non-rt tasks.  Fix it.

The deadline mechanism can be triggered before tasks' quota ever gets added
to the runqueue priority level's quota.  Add 1 to the quota in anticipation
of this.

The deadline mechanism should only be triggered if the quota is overrun
instead of as soon as the quota is expired allowing some aliasing errors in
scheduler_tick accounting.  Fix that

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff -puN kernel/sched.c~sched-implement-rsdl-cpu-scheduler-accounting-fixes kernel/sched.c
--- a/kernel/sched.c~sched-implement-rsdl-cpu-scheduler-accounting-fixes
+++ a/kernel/sched.c
@@ -95,10 +95,9 @@ unsigned long long __attribute__((weak))
  * provided it is not a realtime comparison.
  */
 #define TASK_PREEMPTS_CURR(p, curr) \
-	(((p)->prio < (curr)->prio) || (((p)->prio == (curr)->prio) && \
+	(((p)->prio < (curr)->prio) || (!rt_task(p) && \
 		((p)->static_prio < (curr)->static_prio && \
-			((curr)->static_prio > (curr)->prio)) && \
-				!rt_task(p)))
+			((curr)->static_prio > (curr)->prio))))
 
 /*
  * This is the time all tasks within the same priority round robin.
@@ -3322,7 +3321,7 @@ static inline void major_prio_rotation(s
  */
 static inline void rotate_runqueue_priority(struct rq *rq)
 {
-	int new_prio_level, remaining_quota;
+	int new_prio_level;
 	struct prio_array *array;
 
 	/*
@@ -3333,7 +3332,6 @@ static inline void rotate_runqueue_prior
 	if (unlikely(sched_find_first_bit(rq->dyn_bitmap) < rq->prio_level))
 		return;
 
-	remaining_quota = rq_quota(rq, rq->prio_level);
 	array = rq->active;
 	if (rq->prio_level > MAX_PRIO - 2) {
 		/* Major rotation required */
@@ -3367,10 +3365,11 @@ static inline void rotate_runqueue_prior
 	}
 	rq->prio_level = new_prio_level;
 	/*
-	 * While we usually rotate with the rq quota being 0, it is possible
-	 * to be negative so we subtract any deficit from the new level.
+	 * As we are merging to a prio_level that may not have anything in
+	 * its quota we add 1 to ensure the tasks get to run in schedule() to
+	 * add their quota to it.
 	 */
-	rq_quota(rq, new_prio_level) += remaining_quota;
+	rq_quota(rq, new_prio_level) += 1;
 }
 
 static void task_running_tick(struct rq *rq, struct task_struct *p)
@@ -3396,12 +3395,11 @@ static void task_running_tick(struct rq 
 	if (!--p->time_slice)
 		task_expired_entitlement(rq, p);
 	/*
-	 * The rq quota can become negative due to a task being queued in
-	 * scheduler without any quota left at that priority level. It is
-	 * cheaper to allow it to run till this scheduler tick and then
-	 * subtract it from the quota of the merged queues.
+	 * We only employ the deadline mechanism if we run over the quota.
+	 * It allows aliasing problems around the scheduler_tick to be
+	 * less harmful.
 	 */
-	if (!rt_task(p) && --rq_quota(rq, rq->prio_level) <= 0) {
+	if (!rt_task(p) && --rq_quota(rq, rq->prio_level) < 0) {
 		if (unlikely(p->first_time_slice))
 			p->first_time_slice = 0;
 		rotate_runqueue_priority(rq);
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
lists-add-list-splice-tail.patch
sched-remove-sleepavg-from-proc.patch
sched-remove-noninteractive-flag.patch
sched-implement-180-bit-sched-bitmap.patch
sched-dont-renice-kernel-threads.patch
sched-implement-rsdl-cpu-scheduler.patch
sched-implement-rsdl-cpu-scheduler-accounting-fixes.patch
sched-document-rsdl-cpu-scheduler.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
