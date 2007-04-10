From: akpm@linux-foundation.org
Subject: + sched-implement-staircase-deadline-cpu-scheduler-avoid-redundant-reschedule-in-set_user_nice.patch added to -mm tree
Date: Tue, 10 Apr 2007 16:57:28 -0700
Message-ID: <200704102357.l3ANvSc3023499@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52882 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161135AbXDJX5t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 19:57:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmitry.adamushko@gmail.com, kernel@kolivas.org, mingo@elte.hu


The patch titled
     SD sched: avoid redundant reschedule in set_user_nice()
has been added to the -mm tree.  Its filename is
     sched-implement-staircase-deadline-cpu-scheduler-avoid-redundant-reschedule-in-set_user_nice.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SD sched: avoid redundant reschedule in set_user_nice()
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>

Call for reschedule upon increasing a task's priority in set_user_nice()
only if the task may preempt the current one.

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff -puN kernel/sched.c~sched-implement-staircase-deadline-cpu-scheduler-avoid-redundant-reschedule-in-set_user_nice kernel/sched.c
--- a/kernel/sched.c~sched-implement-staircase-deadline-cpu-scheduler-avoid-redundant-reschedule-in-set_user_nice
+++ a/kernel/sched.c
@@ -4021,14 +4021,14 @@ EXPORT_SYMBOL(sleep_on_timeout);
 void rt_mutex_setprio(struct task_struct *p, int prio)
 {
 	unsigned long flags;
-	int queued, oldprio;
+	int queued, delta;
 	struct rq *rq;
 
 	BUG_ON(prio < 0 || prio > MAX_PRIO);
 
 	rq = task_rq_lock(p, &flags);
 
-	oldprio = p->prio;
+	delta = prio - p->prio;
 	queued = task_queued(p);
 	if (queued)
 		dequeue_task(p, rq);
@@ -4042,7 +4042,7 @@ void rt_mutex_setprio(struct task_struct
 		 * this runqueue and our priority is higher than the current's
 		 */
 		if (task_running(rq, p)) {
-			if (p->prio > oldprio)
+			if (delta > 0)
 				resched_task(rq->curr);
 		} else
 			try_preempt(p, rq);
@@ -4054,7 +4054,7 @@ void rt_mutex_setprio(struct task_struct
 
 void set_user_nice(struct task_struct *p, long nice)
 {
-	int queued, old_prio,delta;
+	int queued, old_prio, delta;
 	unsigned long flags;
 	struct rq *rq;
 
@@ -4095,8 +4095,11 @@ void set_user_nice(struct task_struct *p
 		 * If the task increased its priority or is running and
 		 * lowered its priority, then reschedule its CPU:
 		 */
-		if (delta < 0 || (delta > 0 && task_running(rq, p)))
-			resched_task(rq->curr);
+		if (task_running(rq, p)) {
+			if (delta > 0)
+				resched_task(rq->curr);
+		} else
+			try_preempt(p, rq);
 	}
 out_unlock:
 	task_rq_unlock(rq, &flags);
_

Patches currently in -mm which might be from dmitry.adamushko@gmail.com are

kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements.patch
sched-implement-staircase-deadline-cpu-scheduler-improvements-fix.patch
sched-implement-staircase-deadline-cpu-scheduler-avoid-redundant-reschedule-in-set_user_nice.patch
