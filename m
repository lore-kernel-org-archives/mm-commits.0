From: akpm@linux-foundation.org
Subject: - sched-rsdl-yet-more-fixes.patch removed from -mm tree
Date: Mon, 26 Mar 2007 15:37:37 -0700
Message-ID: <200703262237.l2QMbbKY032451@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56515 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933755AbXCZWhj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 18:37:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@kolivas.org, mm-commits@vger.kernel.org


The patch titled
     sched: rsdl yet more fixes
has been removed from the -mm tree.  Its filename was
     sched-rsdl-yet-more-fixes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: sched: rsdl yet more fixes
From: Con Kolivas <kernel@kolivas.org>

The wrong bit could be unset on requeue_task which could cause an oops. 
Fix that.

sched_yield semantics became almost a noop so change back to expiring tasks
when yield is called.

recalc_task_prio() performed during pull_task() on SMP may not reliably be
doing the right thing to tasks queued on the new runqueue.  Add a special
variant of enqueue_task that does its own local recalculation of priority
and quota.

rq->best_static_prio should not be set by realtime or SCHED_BATCH tasks. 
Correct that, and microoptimise the code around setting best_static_prio.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |  103 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 71 insertions(+), 32 deletions(-)

diff -puN kernel/sched.c~sched-rsdl-yet-more-fixes kernel/sched.c
--- a/kernel/sched.c~sched-rsdl-yet-more-fixes
+++ a/kernel/sched.c
@@ -720,17 +720,17 @@ static inline int entitled_slot(int stat
  */
 static inline int next_entitled_slot(struct task_struct *p, struct rq *rq)
 {
-	if (p->static_prio < rq->best_static_prio && p->policy != SCHED_BATCH)
-		return SCHED_PRIO(find_first_zero_bit(p->bitmap, PRIO_RANGE));
-	else {
-		DECLARE_BITMAP(tmp, PRIO_RANGE);
+	DECLARE_BITMAP(tmp, PRIO_RANGE);
+	int search_prio;
 
-		bitmap_or(tmp, p->bitmap,
-			  prio_matrix[USER_PRIO(p->static_prio)],
-			  PRIO_RANGE);
-		return SCHED_PRIO(find_next_zero_bit(tmp, PRIO_RANGE,
-			USER_PRIO(rq->prio_level)));
-	}
+	if (p->static_prio < rq->best_static_prio && p->policy != SCHED_BATCH)
+		search_prio = MAX_RT_PRIO;
+	else
+		search_prio = rq->prio_level;
+	bitmap_or(tmp, p->bitmap, prio_matrix[USER_PRIO(p->static_prio)],
+		  PRIO_RANGE);
+	return SCHED_PRIO(find_next_zero_bit(tmp, PRIO_RANGE,
+		USER_PRIO(search_prio)));
 }
 
 static void queue_expired(struct task_struct *p, struct rq *rq)
@@ -823,7 +823,7 @@ static void requeue_task(struct task_str
 	list_move_tail(&p->run_list, p->array->queue + p->prio);
 	if (!rt_task(p)) {
 		if (list_empty(old_array->queue + old_prio))
-			__clear_bit(old_prio, p->array->prio_bitmap);
+			__clear_bit(old_prio, old_array->prio_bitmap);
 		set_dynamic_bit(p, rq);
 	}
 }
@@ -2080,25 +2080,54 @@ void sched_exec(void)
 }
 
 /*
+ * This is a unique version of enqueue_task for the SMP case where a task
+ * has just been moved across runqueues. It uses the information from the
+ * old runqueue to help it make a decision much like recalc_task_prio. As
+ * the new runqueue is almost certainly at a different prio_level than the
+ * src_rq it is cheapest just to pick the next entitled slot.
+ */
+static inline void enqueue_pulled_task(struct rq *src_rq, struct rq *rq,
+				       struct task_struct *p)
+{
+	int queue_prio;
+
+	p->array = rq->active;
+	if (!rt_task(p)) {
+		if (p->rotation == src_rq->prio_rotation) {
+			if (p->array == src_rq->expired) {
+				queue_expired(p, rq);
+				goto out_queue;
+			}
+		} else
+			task_new_array(p, rq);
+	}
+	queue_prio = next_entitled_slot(p, rq);
+	if (queue_prio >= MAX_PRIO) {
+		queue_expired(p, rq);
+		goto out_queue;
+	}
+	rq_quota(rq, queue_prio) += p->quota;
+	p->prio = queue_prio;
+out_queue:
+	p->normal_prio = p->prio;
+	p->rotation = rq->prio_rotation;
+	sched_info_queued(p);
+	set_dynamic_bit(p, rq);
+	list_add_tail(&p->run_list, p->array->queue + p->prio);
+}
+
+/*
  * pull_task - move a task from a remote runqueue to the local runqueue.
  * Both runqueues must be locked.
  */
-static void pull_task(struct rq *src_rq, struct prio_array *src_array,
-		      struct task_struct *p, struct rq *this_rq,
-		      int this_cpu)
+static void pull_task(struct rq *src_rq, struct task_struct *p,
+		      struct rq *this_rq, int this_cpu)
 {
 	dequeue_task(p, src_rq);
 	dec_nr_running(p, src_rq);
 	set_task_cpu(p, this_cpu);
 	inc_nr_running(p, this_rq);
-
-	/*
-	 * If this task has already been running on src_rq this priority
-	 * cycle, make the new runqueue think it has been on its cycle
-	 */
-	if (p->rotation == src_rq->prio_rotation)
-		p->rotation = this_rq->prio_rotation;
-	enqueue_task(p, this_rq);
+	enqueue_pulled_task(src_rq, this_rq, p);
 	p->timestamp = (p->timestamp - src_rq->most_recent_timestamp)
 				+ this_rq->most_recent_timestamp;
 	try_preempt(p, this_rq);
@@ -2243,7 +2272,7 @@ skip_queue:
 		goto skip_bitmap;
 	}
 
-	pull_task(busiest, array, tmp, this_rq, this_cpu);
+	pull_task(busiest, tmp, this_rq, this_cpu);
 	pulled++;
 	rem_load_move -= tmp->load_weight;
 
@@ -3372,7 +3401,7 @@ static inline void major_prio_rotation(s
 	rq->active = new_array;
 	rq->exp_bitmap = rq->expired->prio_bitmap;
 	rq->dyn_bitmap = rq->active->prio_bitmap;
-	rq->best_static_prio = MAX_PRIO;
+	rq->best_static_prio = MAX_PRIO - 1;
 	rq->prio_rotation++;
 }
 
@@ -3615,6 +3644,9 @@ retry:
 	 */
 	next->prio = idx;
 	next->array = array;
+	if (next->static_prio < rq->best_static_prio &&
+	    next->policy != SCHED_BATCH)
+		rq->best_static_prio = next->static_prio;
 	return next;
 }
 
@@ -3698,12 +3730,11 @@ need_resched_nonpreemptible:
 	}
 switch_tasks:
 	if (next == rq->idle) {
-		rq->best_static_prio = MAX_PRIO;
+		rq->best_static_prio = MAX_PRIO - 1;
 		rq->prio_level = MAX_RT_PRIO;
 		rq->prio_rotation++;
 		schedstat_inc(rq, sched_goidle);
-	} else if (next->static_prio < rq->best_static_prio)
-		rq->best_static_prio = next->static_prio;
+	}
 	prefetch(next);
 	prefetch_stack(next);
 	clear_tsk_need_resched(prev);
@@ -4718,8 +4749,9 @@ asmlinkage long sys_sched_getaffinity(pi
  * sys_sched_yield - yield the current processor to other threads.
  *
  * This function yields the current CPU by moving the calling thread
- * to the end of its current priority queue. If there are no other
- * threads running on this cpu this function will return.
+ * to the expired array if SCHED_NORMAL or the end of its current priority
+ * queue if a realtime task. If there are no other threads running on this
+ * cpu this function will return.
  */
 asmlinkage long sys_sched_yield(void)
 {
@@ -4729,8 +4761,15 @@ asmlinkage long sys_sched_yield(void)
 	schedstat_inc(rq, yld_cnt);
 	if (rq->nr_running == 1)
 		schedstat_inc(rq, yld_both_empty);
-	else
-		list_move_tail(&p->run_list, p->array->queue + p->prio);
+	else {
+		struct prio_array *old_array = p->array;
+		int old_prio = p->prio;
+
+		/* p->prio will be updated in requeue_task via queue_expired */
+		if (!rt_task(p))
+			p->array = rq->expired;
+		requeue_task(p, rq, old_array, old_prio);
+	}
 
 	/*
 	 * Since we are going to call schedule() anyway, there's
@@ -7154,7 +7193,7 @@ void __init sched_init(void)
 		lockdep_set_class(&rq->lock, &rq->rq_lock_key);
 		rq->nr_running = 0;
 		rq->prio_rotation = 0;
-		rq->best_static_prio = MAX_PRIO;
+		rq->best_static_prio = MAX_PRIO - 1;
 		rq->prio_level = MAX_RT_PRIO;
 		rq->active = rq->arrays;
 		rq->expired = rq->arrays + 1;
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
sched-rsdl-yet-more-fixes.patch
