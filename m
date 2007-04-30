From: akpm@linux-foundation.org
Subject: - sched-implement-staircase-deadline-cpu-scheduler-avoid-redundant-reschedule-in-set_user_nice.patch removed from -mm tree
Date: Mon, 30 Apr 2007 11:47:33 -0700
Message-ID: <200704301847.l3UIlXoU011782@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946594AbXD3Srr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 14:47:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmitry.adamushko@gmail.com, kernel@kolivas.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     SD sched: avoid redundant reschedule in set_user_nice()
has been removed from the -mm tree.  Its filename was
     sched-implement-staircase-deadline-cpu-scheduler-avoid-redundant-reschedule-in-set_user_nice.patch

This patch was dropped because I need to clear the decks

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
sched-implement-staircase-deadline-cpu-scheduler-avoid-redundant-reschedule-in-set_user_nice.patch
sched-implement-staircase-deadline-cpu-scheduler-tweak.patch
