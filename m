From: akpm@linux-foundation.org
Subject: - sched-implement-staircase-scheduler-yaf-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 11:47:56 -0700
Message-ID: <200704301847.l3UIluXm011797@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946599AbXD3SsB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 14:48:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@kolivas.org, a1426z@gawab.com, mm-commits@vger.kernel.org


The patch titled
     sched: implement staircase scheduler yaf fix
has been removed from the -mm tree.  Its filename was
     sched-implement-staircase-scheduler-yaf-fix.patch

This patch was dropped because I need to clear the decks

------------------------------------------------------
Subject: sched: implement staircase scheduler yaf fix
From: Con Kolivas <kernel@kolivas.org>

Management of time_slice sharing across fork was broken by changing
time_slice to a signed int.

first_time_slice was not being cleared anywhere near often enough.

SCHED_BATCH tasks in the current implementation should advance prio_level
and best_static_prio.

Thanks Al Boldi <a1426z@gawab.com> for making me check the fork code.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   50 +++++++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff -puN kernel/sched.c~sched-implement-staircase-scheduler-yaf-fix kernel/sched.c
--- a/kernel/sched.c~sched-implement-staircase-scheduler-yaf-fix
+++ a/kernel/sched.c
@@ -688,6 +688,12 @@ static void dequeue_task(struct task_str
 		__clear_bit(p->prio, p->array->prio_bitmap);
 }
 
+static void reset_first_time_slice(struct task_struct *p)
+{
+	if (unlikely(p->first_time_slice))
+		p->first_time_slice = 0;
+}
+
 /*
  * The task is being queued on a fresh array so it has its entitlement
  * bitmap cleared.
@@ -699,6 +705,7 @@ static void task_new_array(struct task_s
 	p->rotation = rq->prio_rotation;
 	p->time_slice = p->quota;
 	p->array = array;
+	reset_first_time_slice(p);
 }
 
 /* Find the first slot from the relevant prio_matrix entry */
@@ -767,6 +774,7 @@ static void queue_expired(struct task_st
 	p->prio = p->normal_prio = first_prio_slot(p);
 	if (p->static_prio < rq->expired->best_static_prio)
 		rq->expired->best_static_prio = p->static_prio;
+	reset_first_time_slice(p);
 }
 
 #ifdef CONFIG_SMP
@@ -1708,13 +1716,20 @@ void fastcall sched_fork(struct task_str
 	 * resulting in more scheduling fairness.
 	 */
 	local_irq_disable();
-	current->time_slice >>= 1;
-	p->time_slice = current->time_slice;
-	/*
-	 * The remainder of the first timeslice might be recovered by
-	 * the parent if the child exits early enough.
-	 */
-	p->first_time_slice = 1;
+	if (current->time_slice > 0) {
+		current->time_slice /= 2;
+		if (current->time_slice)
+			p->time_slice = current->time_slice;
+		else
+			p->time_slice = 1;
+		/*
+		 * The remainder of the first timeslice might be recovered by
+		 * the parent if the child exits early enough.
+		 */
+		p->first_time_slice = 1;
+	} else
+		p->time_slice = 0;
+
 	p->timestamp = sched_clock();
 	local_irq_enable();
 out:
@@ -1795,7 +1810,7 @@ void fastcall sched_exit(struct task_str
 
 	parent = p->parent;
 	rq = task_rq_lock(parent, &flags);
-	if (p->first_time_slice && task_cpu(p) == task_cpu(parent)) {
+	if (p->first_time_slice > 0 && task_cpu(p) == task_cpu(parent)) {
 		parent->time_slice += p->time_slice;
 		if (unlikely(parent->time_slice > parent->quota))
 			parent->time_slice = parent->quota;
@@ -3376,8 +3391,7 @@ static void task_expired_entitlement(str
 	struct prio_array *old_array;
 	int overrun, old_prio;
 
-	if (unlikely(p->first_time_slice))
-		p->first_time_slice = 0;
+	reset_first_time_slice(p);
 	if (rt_task(p)) {
 		p->time_slice = p->quota;
 		list_move_tail(&p->run_list, p->array->queue + p->prio);
@@ -3480,9 +3494,10 @@ static void reset_prio_levels(struct rq 
  */
 static inline struct task_struct *next_dynamic_task(struct rq *rq, int idx)
 {
+	struct prio_array *array = rq->active;
 	struct task_struct *next;
 	struct list_head *queue;
-	struct prio_array *array = rq->active;
+	int nstatic;
 
 retry:
 	if (idx >= MAX_PRIO) {
@@ -3510,14 +3525,11 @@ retry:
 		goto retry;
 	}
 	next->rotation = rq->prio_rotation;
-	if (likely(next->policy != SCHED_BATCH)) {
-		int nstatic = next->static_prio;
-
-		if (nstatic < array->best_static_prio)
-			array->best_static_prio = nstatic;
-		if (idx > rq->prio_level[USER_PRIO(nstatic)])
-			rq->prio_level[USER_PRIO(nstatic)] = idx;
-	}
+	nstatic = next->static_prio;
+	if (nstatic < array->best_static_prio)
+		array->best_static_prio = nstatic;
+	if (idx > rq->prio_level[USER_PRIO(nstatic)])
+		rq->prio_level[USER_PRIO(nstatic)] = idx;
 	return next;
 }
 
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
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
