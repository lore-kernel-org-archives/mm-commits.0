From: akpm@linux-foundation.org
Subject: + sched-rsdl-check-for-niced-tasks-lowering-prio-level.patch added to -mm tree
Date: Wed, 21 Mar 2007 22:12:40 -0800
Message-ID: <200703220612.l2M6CevX013659@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40762 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbXCVGMq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 02:12:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kernel@kolivas.org


The patch titled
     sched: rsdl check for niced tasks lowering prio level
has been added to the -mm tree.  Its filename is
     sched-rsdl-check-for-niced-tasks-lowering-prio-level.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: rsdl check for niced tasks lowering prio level
From: Con Kolivas <kernel@kolivas.org>

Ensure niced tasks are not inappropriately limiting sleeping unniced tasks
by explicitly checking what the best static priority that has run this
major rotation was.

Reimplement SCHED_BATCH using this check.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff -puN kernel/sched.c~sched-rsdl-check-for-niced-tasks-lowering-prio-level kernel/sched.c
--- a/kernel/sched.c~sched-rsdl-check-for-niced-tasks-lowering-prio-level
+++ a/kernel/sched.c
@@ -201,8 +201,11 @@ struct rq {
 	struct prio_array *active, *expired, arrays[2];
 	unsigned long *dyn_bitmap, *exp_bitmap;
 
-	int prio_level;
-	/* The current dynamic priority level this runqueue is at */
+	int prio_level, best_static_prio;
+	/*
+	 * The current dynamic priority level this runqueue is at, and the
+	 * best static priority queued this major rotation.
+	 */
 
 	unsigned long prio_rotation;
 	/* How many times we have rotated the priority queue */
@@ -704,16 +707,24 @@ static inline int entitled_slot(int stat
 
 /*
  * Find the first unused slot by this task that is also in its prio_matrix
- * level.
+ * level. Ensure that the prio_level is not unnecessarily low by checking
+ * that best_static_prio this major rotation was not a niced task.
+ * SCHED_BATCH tasks do not perform this check so they do not induce
+ * latencies in tasks of any nice level.
  */
 static inline int next_entitled_slot(struct task_struct *p, struct rq *rq)
 {
-	DECLARE_BITMAP(tmp, PRIO_RANGE);
+	if (p->static_prio < rq->best_static_prio && p->policy != SCHED_BATCH)
+		return SCHED_PRIO(find_first_zero_bit(p->bitmap, PRIO_RANGE));
+	else {
+		DECLARE_BITMAP(tmp, PRIO_RANGE);
 
-	bitmap_or(tmp, p->bitmap, prio_matrix[USER_PRIO(p->static_prio)],
-		  PRIO_RANGE);
-	return SCHED_PRIO(find_next_zero_bit(tmp, PRIO_RANGE,
-		USER_PRIO(rq->prio_level)));
+		bitmap_or(tmp, p->bitmap,
+			  prio_matrix[USER_PRIO(p->static_prio)],
+			  PRIO_RANGE);
+		return SCHED_PRIO(find_next_zero_bit(tmp, PRIO_RANGE,
+			USER_PRIO(rq->prio_level)));
+	}
 }
 
 static void queue_expired(struct task_struct *p, struct rq *rq)
@@ -3315,6 +3326,7 @@ static inline void major_prio_rotation(s
 	rq->active = new_array;
 	rq->exp_bitmap = rq->expired->prio_bitmap;
 	rq->dyn_bitmap = rq->active->prio_bitmap;
+	rq->best_static_prio = MAX_PRIO;
 	rq->prio_rotation++;
 }
 
@@ -3640,10 +3652,12 @@ need_resched_nonpreemptible:
 	}
 switch_tasks:
 	if (next == rq->idle) {
+		rq->best_static_prio = MAX_PRIO;
 		rq->prio_level = MAX_RT_PRIO;
 		rq->prio_rotation++;
 		schedstat_inc(rq, sched_goidle);
-	}
+	} else if (next->static_prio < rq->best_static_prio)
+		rq->best_static_prio = next->static_prio;
 	prefetch(next);
 	prefetch_stack(next);
 	clear_tsk_need_resched(prev);
@@ -7093,6 +7107,7 @@ void __init sched_init(void)
 		lockdep_set_class(&rq->lock, &rq->rq_lock_key);
 		rq->nr_running = 0;
 		rq->prio_rotation = 0;
+		rq->best_static_prio = MAX_PRIO;
 		rq->prio_level = MAX_RT_PRIO;
 		rq->active = rq->arrays;
 		rq->expired = rq->arrays + 1;
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
lists-add-list-splice-tail.patch
sched-remove-sleepavg-from-proc.patch
sched-remove-noninteractive-flag.patch
sched-dont-renice-kernel-threads.patch
sched-implement-rsdl-cpu-scheduler.patch
sched-document-rsdl-cpu-scheduler.patch
sched-rsdl-improvements.patch
sched-rsdl-check-for-niced-tasks-lowering-prio-level.patch
