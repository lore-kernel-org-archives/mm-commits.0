From: akpm@linux-foundation.org
Subject: - sched-implement-staircase-deadline-scheduler-further-improvements-1.patch removed from -mm tree
Date: Mon, 30 Apr 2007 11:47:50 -0700
Message-ID: <200704301847.l3UIlo77011791@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946600AbXD3SsH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 14:48:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@kolivas.org, mm-commits@vger.kernel.org


The patch titled
     sched: implement staircase deadline scheduler further improvements
has been removed from the -mm tree.  Its filename was
     sched-implement-staircase-deadline-scheduler-further-improvements-1.patch

This patch was dropped because I need to clear the decks

------------------------------------------------------
Subject: sched: implement staircase deadline scheduler further improvements
From: Con Kolivas <kernel@kolivas.org>

The prio_level was being inappropriately decreased if a higher priority
task was still using previous timeslice. Fix that.

Task expiration of higher priority tasks was not being taken into account
with allocating priority slots. Check the expired best_static_prio level
to facilitate that.

Explicitly check all better static priority prio_levels when deciding on
allocating slots for niced tasks.

These changes improve behaviour in many ways.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   64 +++++++++++++++++++++++++++++++----------------
 1 files changed, 43 insertions(+), 21 deletions(-)

diff -puN kernel/sched.c~sched-implement-staircase-deadline-scheduler-further-improvements-1 kernel/sched.c
--- a/kernel/sched.c~sched-implement-staircase-deadline-scheduler-further-improvements-1
+++ a/kernel/sched.c
@@ -146,6 +146,12 @@ struct prio_array {
 	 */
 	DECLARE_BITMAP(prio_bitmap, MAX_PRIO + 1);
 
+	/*
+	 * The best static priority (of the dynamic priority tasks) queued
+	 * this array.
+	 */
+	int best_static_prio;
+
 #ifdef CONFIG_SMP
 	/* For convenience looks back at rq */
 	struct rq *rq;
@@ -217,9 +223,9 @@ struct rq {
 
 	/*
 	 * The current dynamic priority level this runqueue is at per static
-	 * priority level, and the best static priority queued this rotation.
+	 * priority level.
 	 */
-	int prio_level[PRIO_RANGE], best_static_prio;
+	int prio_level[PRIO_RANGE];
 
 	/* How many times we have rotated the priority queue */
 	unsigned long prio_rotation;
@@ -696,7 +702,7 @@ static void task_new_array(struct task_s
 }
 
 /* Find the first slot from the relevant prio_matrix entry */
-static inline int first_prio_slot(struct task_struct *p)
+static int first_prio_slot(struct task_struct *p)
 {
 	if (unlikely(p->policy == SCHED_BATCH))
 		return p->static_prio;
@@ -709,11 +715,18 @@ static inline int first_prio_slot(struct
  * level. SCHED_BATCH tasks do not use the priority matrix. They only take
  * priority slots from their static_prio and above.
  */
-static inline int next_entitled_slot(struct task_struct *p, struct rq *rq)
+static int next_entitled_slot(struct task_struct *p, struct rq *rq)
 {
+	int search_prio = MAX_RT_PRIO, uprio = USER_PRIO(p->static_prio);
+	struct prio_array *array = rq->active;
 	DECLARE_BITMAP(tmp, PRIO_RANGE);
-	int search_prio, uprio = USER_PRIO(p->static_prio);
 
+	/*
+	 * Go straight to expiration if there are higher priority tasks
+	 * already expired.
+	 */
+	if (p->static_prio > rq->expired->best_static_prio)
+		return MAX_PRIO;
 	if (!rq->prio_level[uprio])
 		rq->prio_level[uprio] = MAX_RT_PRIO;
 	/*
@@ -721,15 +734,22 @@ static inline int next_entitled_slot(str
 	 * static_prio are acceptable, and only if it's not better than
 	 * a queued better static_prio's prio_level.
 	 */
-	if (p->static_prio < rq->best_static_prio) {
-		search_prio = MAX_RT_PRIO;
+	if (p->static_prio < array->best_static_prio) {
 		if (likely(p->policy != SCHED_BATCH))
-			rq->best_static_prio = p->static_prio;
-	} else if (p->static_prio == rq->best_static_prio)
+			array->best_static_prio = p->static_prio;
+	} else if (p->static_prio == array->best_static_prio) {
 		search_prio = rq->prio_level[uprio];
-	else {
-		search_prio = max(rq->prio_level[uprio],
-			rq->prio_level[USER_PRIO(rq->best_static_prio)]);
+	} else {
+		int i;
+
+		search_prio = rq->prio_level[uprio];
+		/* A bound O(n) function, worst case n is 40 */
+		for (i = array->best_static_prio; i <= p->static_prio ; i++) {
+			if (!rq->prio_level[USER_PRIO(i)])
+				rq->prio_level[USER_PRIO(i)] = MAX_RT_PRIO;
+			search_prio = max(search_prio,
+				      rq->prio_level[USER_PRIO(i)]);
+		}
 	}
 	if (unlikely(p->policy == SCHED_BATCH)) {
 		search_prio = max(search_prio, p->static_prio);
@@ -745,6 +765,8 @@ static void queue_expired(struct task_st
 {
 	task_new_array(p, rq, rq->expired);
 	p->prio = p->normal_prio = first_prio_slot(p);
+	if (p->static_prio < rq->expired->best_static_prio)
+		rq->expired->best_static_prio = p->static_prio;
 }
 
 #ifdef CONFIG_SMP
@@ -753,7 +775,7 @@ static void queue_expired(struct task_st
  * update its data appropriately. Note we may be reading data from src_rq->
  * outside of lock, but the occasional inaccurate result should be harmless.
  */
- static inline void update_if_moved(struct task_struct *p, struct rq *rq)
+ static void update_if_moved(struct task_struct *p, struct rq *rq)
 {
 	struct rq *src_rq = p->array->rq;
 
@@ -3446,8 +3468,10 @@ EXPORT_SYMBOL(sub_preempt_count);
 
 #endif
 
-static inline void reset_prio_levels(struct rq *rq)
+static void reset_prio_levels(struct rq *rq)
 {
+	rq->active->best_static_prio = MAX_PRIO - 1;
+	rq->expired->best_static_prio = MAX_PRIO - 1;
 	memset(rq->prio_level, 0, sizeof(int) * PRIO_RANGE);
 }
 
@@ -3468,7 +3492,6 @@ retry:
 		rq->active = array;
 		rq->exp_bitmap = rq->expired->prio_bitmap;
 		rq->dyn_bitmap = rq->active->prio_bitmap;
-		rq->best_static_prio = MAX_PRIO - 1;
 		rq->prio_rotation++;
 		idx = find_next_bit(rq->dyn_bitmap, MAX_PRIO, MAX_RT_PRIO);
 		reset_prio_levels(rq);
@@ -3490,9 +3513,10 @@ retry:
 	if (likely(next->policy != SCHED_BATCH)) {
 		int nstatic = next->static_prio;
 
-		if (nstatic < rq->best_static_prio)
-			rq->best_static_prio = nstatic;
-		rq->prio_level[USER_PRIO(nstatic)] = idx;
+		if (nstatic < array->best_static_prio)
+			array->best_static_prio = nstatic;
+		if (idx > rq->prio_level[USER_PRIO(nstatic)])
+			rq->prio_level[USER_PRIO(nstatic)] = idx;
 	}
 	return next;
 }
@@ -3577,7 +3601,6 @@ need_resched_nonpreemptible:
 	}
 switch_tasks:
 	if (next == rq->idle) {
-		rq->best_static_prio = MAX_PRIO - 1;
 		reset_prio_levels(rq);
 		rq->prio_rotation++;
 		schedstat_inc(rq, sched_goidle);
@@ -6891,10 +6914,9 @@ void __init sched_init(void)
 		lockdep_set_class(&rq->lock, &rq->rq_lock_key);
 		rq->nr_running = 0;
 		rq->prio_rotation = 0;
-		rq->best_static_prio = MAX_PRIO - 1;
-		reset_prio_levels(rq);
 		rq->active = rq->arrays;
 		rq->expired = rq->arrays + 1;
+		reset_prio_levels(rq);
 		rq->dyn_bitmap = rq->active->prio_bitmap;
 		rq->exp_bitmap = rq->expired->prio_bitmap;
 
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
sched-implement-staircase-deadline-scheduler-further-improvements-1.patch
sched-implement-staircase-deadline-scheduler-timeslice-fixes.patch
sched-implement-staircase-scheduler-yaf-fix.patch
sched-implement-staircase-deadline-scheduler-ymf-accounting-fixes.patch
sched-ymf-typo.patch
sched-implement-staircase-deadline-scheduler-load-weight-fix.patch
sched-increase-ksoftirqd-priority.patch
sched-remove-noninteractive-flag.patch
sched-document-sd-cpu-scheduler.patch
sched-implement-staircase-deadline-scheduler-rework-priomatrix-doc.patch
sched-consolidate-sched_clock-drift-adjustments.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
sched-implement-staircase-deadline-scheduler-docupdate.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
