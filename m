From: akpm@linux-foundation.org
Subject: + sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements.patch added to -mm tree
Date: Mon, 02 Apr 2007 18:47:22 -0700
Message-ID: <200704030147.l331lM5V014918@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57004 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966143AbXDCBr0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 21:47:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kernel@kolivas.org, dmitry.adamushko@gmail.com


The patch titled
     sched: staircase deadline improvements
has been added to the -mm tree.  Its filename is
     sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: staircase deadline improvements
From: Con Kolivas <kernel@kolivas.org>

Staircase Deadline improvements.

Nice is better distributed for waking tasks with a per-static-prio prio_level.

SCHED_RR tasks were not being requeued on expiration.

Tighten up accounting.

Fix comment style.

Microoptimisation courtesy of Dmitry Adamushko <dmitry.adamushko@gmail.com>

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   97 +++++++++++++++++++++++++++++------------------
 1 file changed, 60 insertions(+), 37 deletions(-)

diff -puN kernel/sched.c~sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements kernel/sched.c
--- a/kernel/sched.c~sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements
+++ a/kernel/sched.c
@@ -131,20 +131,20 @@ struct rq;
  * These are the runqueue data structures:
  */
 struct prio_array {
-	struct list_head queue[MAX_PRIO];
 	/* Tasks queued at each priority */
+	struct list_head queue[MAX_PRIO];
 
-	DECLARE_BITMAP(prio_bitmap, MAX_PRIO + 1);
 	/*
 	 * The bitmap of priorities queued for this array. While the expired
 	 * array will never have realtime tasks on it, it is simpler to have
 	 * equal sized bitmaps for a cheap array swap. Include 1 bit for
 	 * delimiter.
 	 */
+	DECLARE_BITMAP(prio_bitmap, MAX_PRIO + 1);
 
 #ifdef CONFIG_SMP
-	struct rq *rq;
 	/* For convenience looks back at rq */
+	struct rq *rq;
 #endif
 };
 
@@ -211,14 +211,14 @@ struct rq {
 	struct prio_array *active, *expired, arrays[2];
 	unsigned long *dyn_bitmap, *exp_bitmap;
 
-	int prio_level, best_static_prio;
 	/*
-	 * The current dynamic priority level this runqueue is at, and the
-	 * best static priority queued this major rotation.
+	 * The current dynamic priority level this runqueue is at per static
+	 * priority level, and the best static priority queued this rotation.
 	 */
+	int prio_level[PRIO_RANGE], best_static_prio;
 
-	unsigned long prio_rotation;
 	/* How many times we have rotated the priority queue */
+	unsigned long prio_rotation;
 
 	atomic_t nr_iowait;
 
@@ -706,19 +706,29 @@ static inline int first_prio_slot(struct
 static inline int next_entitled_slot(struct task_struct *p, struct rq *rq)
 {
 	DECLARE_BITMAP(tmp, PRIO_RANGE);
-	int search_prio;
+	int search_prio, uprio = USER_PRIO(p->static_prio);
 
-	if (p->static_prio < rq->best_static_prio)
+	/*
+	 * Only priorities equal to the prio_level and above for their
+	 * static_prio are acceptable, and only if it's not better than
+	 * a queued better static_prio's prio_level.
+	 */
+	if (p->static_prio < rq->best_static_prio) {
 		search_prio = MAX_RT_PRIO;
-	else
-		search_prio = rq->prio_level;
+		if (likely(p->policy != SCHED_BATCH))
+			rq->best_static_prio = p->static_prio;
+	} else if (p->static_prio == rq->best_static_prio)
+		search_prio = rq->prio_level[uprio];
+	else {
+		search_prio = max(rq->prio_level[uprio],
+			rq->prio_level[USER_PRIO(rq->best_static_prio)]);
+	}
 	if (unlikely(p->policy == SCHED_BATCH)) {
 		search_prio = max(search_prio, p->static_prio);
 		return SCHED_PRIO(find_next_zero_bit(p->bitmap, PRIO_RANGE,
 				  USER_PRIO(search_prio)));
 	}
-	bitmap_or(tmp, p->bitmap, prio_matrix[USER_PRIO(p->static_prio)],
-		  PRIO_RANGE);
+	bitmap_or(tmp, p->bitmap, prio_matrix[uprio], PRIO_RANGE);
 	return SCHED_PRIO(find_next_zero_bit(tmp, PRIO_RANGE,
 		USER_PRIO(search_prio)));
 }
@@ -744,14 +754,18 @@ static void queue_expired(struct task_st
 
 	if (src_rq == rq)
 		return;
-	if (p->rotation == src_rq->prio_rotation)
+	/*
+	 * Only need to set p->array when p->rotation == rq->prio_rotation as
+	 * they will be set in recalc_task_prio when != rq->prio_rotation.
+	 */
+	if (p->rotation == src_rq->prio_rotation) {
 		p->rotation = rq->prio_rotation;
-	else
+		if (p->array == src_rq->expired)
+			p->array = rq->expired;
+		else
+			p->array = rq->active;
+	} else
 		p->rotation = 0;
-	if (p->array == src_rq->expired)
-		p->array = rq->expired;
-	else
-		p->array = rq->active;
 }
 #else
 static inline void update_if_moved(struct task_struct *p, struct rq *rq)
@@ -1670,16 +1684,16 @@ void fastcall sched_fork(struct task_str
 	 * total amount of pending timeslices in the system doesn't change,
 	 * resulting in more scheduling fairness.
 	 */
-	if (unlikely(p->time_slice < 2))
-		p->time_slice = 2;
-	p->time_slice = current->time_slice >> 1;
+	local_irq_disable();
+	current->time_slice >>= 1;
+	p->time_slice = current->time_slice;
 	/*
 	 * The remainder of the first timeslice might be recovered by
 	 * the parent if the child exits early enough.
 	 */
 	p->first_time_slice = 1;
-	current->time_slice >>= 1;
 	p->timestamp = sched_clock();
+	local_irq_enable();
 out:
 	put_cpu();
 }
@@ -3333,18 +3347,23 @@ void account_steal_time(struct task_stru
 static void task_expired_entitlement(struct rq *rq, struct task_struct *p)
 {
 	struct prio_array *old_array;
+	int overrun;
 	int old_prio;
 
 	if (unlikely(p->first_time_slice))
 		p->first_time_slice = 0;
 	if (rt_task(p)) {
 		p->time_slice = p->quota;
+		list_move_tail(&p->run_list, p->array->queue + p->prio);
 		return;
 	}
 	old_array = p->array;
 	old_prio = p->prio;
+	overrun = p->time_slice;
 	/* p->prio and p->array will be updated in recalc_task_prio */
 	recalc_task_prio(p, rq);
+	/* Subtract any extra time this task ran over its time_slice */
+	p->time_slice += overrun;
 	requeue_task(p, rq, old_array, old_prio);
 }
 
@@ -3354,16 +3373,11 @@ static void task_running_tick(struct rq 
 	/* SCHED_FIFO tasks never run out of timeslice. */
 	if (p->time_slice > 0 || p->policy == SCHED_FIFO)
 		return;
-	spin_lock(&rq->lock);
-	if (unlikely(!task_queued(p))) {
-		/* Task has expired but was not scheduled off yet */
-		set_tsk_need_resched(p);
-		goto out_unlock;
-	}
 	/* p->time_slice <= 0 */
-	task_expired_entitlement(rq, p);
+	spin_lock(&rq->lock);
+	if (likely(task_queued(p)))
+		task_expired_entitlement(rq, p);
 	set_tsk_need_resched(p);
-out_unlock:
 	spin_unlock(&rq->lock);
 }
 
@@ -3428,6 +3442,11 @@ EXPORT_SYMBOL(sub_preempt_count);
 
 #endif
 
+static inline void reset_prio_levels(struct rq *rq)
+{
+	memset(rq->prio_level, MAX_RT_PRIO, ARRAY_SIZE(rq->prio_level));
+}
+
 /*
  * next_dynamic_task finds the next suitable dynamic task.
  */
@@ -3448,6 +3467,7 @@ retry:
 		rq->best_static_prio = MAX_PRIO - 1;
 		rq->prio_rotation++;
 		idx = find_next_bit(rq->dyn_bitmap, MAX_PRIO, MAX_RT_PRIO);
+		reset_prio_levels(rq);
 	}
 	queue = array->queue + idx;
 	next = list_entry(queue->next, struct task_struct, run_list);
@@ -3462,11 +3482,14 @@ retry:
 		idx = find_next_bit(rq->dyn_bitmap, MAX_PRIO, MAX_RT_PRIO);
 		goto retry;
 	}
-	rq->prio_level = idx;
 	next->rotation = rq->prio_rotation;
-	if (next->static_prio < rq->best_static_prio &&
-	    next->policy != SCHED_BATCH)
-		rq->best_static_prio = next->static_prio;
+	if (likely(next->policy != SCHED_BATCH)) {
+		int nstatic = next->static_prio;
+
+		if (nstatic < rq->best_static_prio)
+			rq->best_static_prio = nstatic;
+		rq->prio_level[USER_PRIO(nstatic)] = idx;
+	}
 	return next;
 }
 
@@ -3551,7 +3574,7 @@ need_resched_nonpreemptible:
 switch_tasks:
 	if (next == rq->idle) {
 		rq->best_static_prio = MAX_PRIO - 1;
-		rq->prio_level = MAX_RT_PRIO;
+		reset_prio_levels(rq);
 		rq->prio_rotation++;
 		schedstat_inc(rq, sched_goidle);
 	}
@@ -6905,7 +6928,7 @@ void __init sched_init(void)
 		rq->nr_running = 0;
 		rq->prio_rotation = 0;
 		rq->best_static_prio = MAX_PRIO - 1;
-		rq->prio_level = MAX_RT_PRIO;
+		reset_prio_levels(rq);
 		rq->active = rq->arrays;
 		rq->expired = rq->arrays + 1;
 		rq->dyn_bitmap = rq->active->prio_bitmap;
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-dont-renice-kernel-threads.patch
sched-remove-sleepavg-from-proc.patch
sched-implement-staircase-deadline-cpu-scheduler.patch
sched-implement-staircase-deadline-cpu-scheduler-misc-fixes.patch
sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements.patch
sched-remove-noninteractive-flag.patch
sched-document-sd-cpu-scheduler.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
