From: akpm@linux-foundation.org
Subject: + sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch added to -mm tree
Date: Fri, 06 Apr 2007 17:03:24 -0700
Message-ID: <200704070003.l3703OnC023254@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39509 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933543AbXDGADd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 20:03:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmitry.adamushko@gmail.com, kernel@kolivas.org, mingo@elte.hu


The patch titled
     sched: redundant reschedule when set_user_nice() boosts a prio of a task from the "expired" array
has been added to the -mm tree.  Its filename is
     sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: redundant reschedule when set_user_nice() boosts a prio of a task from the "expired" array
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>

- Make TASK_PREEMPTS_CURR(task, rq) return "true" only if the task's prio
  is higher than the current's one and the task is in the "active" array. 
  This ensures we don't make redundant resched_task() calls when the task
  is in the "expired" array (as may happen now in set_user_prio(),
  rt_mutex_setprio() and pull_task() ) ;

- generalise conditions for a call to resched_task() in set_user_nice(),
  rt_mutex_setprio() and sched_setscheduler()

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff -puN kernel/sched.c~sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array kernel/sched.c
--- a/kernel/sched.c~sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array
+++ a/kernel/sched.c
@@ -169,7 +169,7 @@ unsigned long long __attribute__((weak))
 		(MAX_BONUS / 2 + DELTA((p)) + 1) / MAX_BONUS - 1))
 
 #define TASK_PREEMPTS_CURR(p, rq) \
-	((p)->prio < (rq)->curr->prio)
+	(((p)->prio < (rq)->curr->prio) && ((p)->array == (rq)->active))
 
 #define SCALE_PRIO(x, prio) \
 	max(x * (MAX_PRIO - prio) / (MAX_USER_PRIO / 2), MIN_TIMESLICE)
@@ -4077,13 +4077,13 @@ void rt_mutex_setprio(struct task_struct
 	struct prio_array *array;
 	unsigned long flags;
 	struct rq *rq;
-	int oldprio;
+	int delta;
 
 	BUG_ON(prio < 0 || prio > MAX_PRIO);
 
 	rq = task_rq_lock(p, &flags);
 
-	oldprio = p->prio;
+	delta = prio - p->prio;
 	array = p->array;
 	if (array)
 		dequeue_task(p, array);
@@ -4099,13 +4099,10 @@ void rt_mutex_setprio(struct task_struct
 		enqueue_task(p, array);
 		/*
 		 * Reschedule if we are currently running on this runqueue and
-		 * our priority decreased, or if we are not currently running on
-		 * this runqueue and our priority is higher than the current's
+		 * our priority decreased, or if our priority became higher
+		 * than the current's.
 		 */
-		if (task_running(rq, p)) {
-			if (p->prio > oldprio)
-				resched_task(rq->curr);
-		} else if (TASK_PREEMPTS_CURR(p, rq))
+		if (TASK_PREEMPTS_CURR(p, rq) || (delta > 0 && task_running(rq, p)))
 			resched_task(rq->curr);
 	}
 	task_rq_unlock(rq, &flags);
@@ -4153,10 +4150,11 @@ void set_user_nice(struct task_struct *p
 		enqueue_task(p, array);
 		inc_raw_weighted_load(rq, p);
 		/*
-		 * If the task increased its priority or is running and
-		 * lowered its priority, then reschedule its CPU:
+		 * Reschedule if we are currently running on this runqueue and
+		 * our priority decreased, or if our priority became higher
+		 * than the current's.
 		 */
-		if (delta < 0 || (delta > 0 && task_running(rq, p)))
+		if (TASK_PREEMPTS_CURR(p, rq) || (delta > 0 && task_running(rq, p)))
 			resched_task(rq->curr);
 	}
 out_unlock:
@@ -4383,13 +4381,10 @@ recheck:
 		__activate_task(p, rq);
 		/*
 		 * Reschedule if we are currently running on this runqueue and
-		 * our priority decreased, or if we are not currently running on
-		 * this runqueue and our priority is higher than the current's
+		 * our priority decreased, or our priority became higher
+		 * than the current's.
 		 */
-		if (task_running(rq, p)) {
-			if (p->prio > oldprio)
-				resched_task(rq->curr);
-		} else if (TASK_PREEMPTS_CURR(p, rq))
+		if (TASK_PREEMPTS_CURR(p, rq) || (task_running(rq, p) && p->prio > oldprio))
 			resched_task(rq->curr);
 	}
 	__task_rq_unlock(rq);
_

Patches currently in -mm which might be from dmitry.adamushko@gmail.com are

kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements.patch
sched-implement-staircase-deadline-cpu-scheduler-improvements-fix.patch
