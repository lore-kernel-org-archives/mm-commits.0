From: akpm@linux-foundation.org
Subject: + sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch added to -mm tree
Date: Mon, 09 Apr 2007 12:30:22 -0700
Message-ID: <200704091930.l39JUM8C021429@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56920 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbXDITbM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 15:31:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmitry.adamushko@gmail.com, kernel@kolivas.org, mingo@elte.hu


The patch titled
     sched: modification of TASK_PREEMPTS_CURRENT to avoid redundant reschedules (e.g. in set_user_nice) (update)
has been added to the -mm tree.  Its filename is
     sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: modification of TASK_PREEMPTS_CURRENT to avoid redundant reschedules (e.g. in set_user_nice) (update)


Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/sched.c~sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update kernel/sched.c
--- a/kernel/sched.c~sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update
+++ a/kernel/sched.c
@@ -4102,7 +4102,8 @@ void rt_mutex_setprio(struct task_struct
 		 * our priority decreased, or if our priority became higher
 		 * than the current's.
 		 */
-		if (TASK_PREEMPTS_CURR(p, rq) || (delta > 0 && task_running(rq, p)))
+		if (TASK_PREEMPTS_CURR(p, rq) ||
+				(delta > 0 && task_running(rq, p)))
 			resched_task(rq->curr);
 	}
 	task_rq_unlock(rq, &flags);
@@ -4154,7 +4155,8 @@ void set_user_nice(struct task_struct *p
 		 * our priority decreased, or if our priority became higher
 		 * than the current's.
 		 */
-		if (TASK_PREEMPTS_CURR(p, rq) || (delta > 0 && task_running(rq, p)))
+		if (TASK_PREEMPTS_CURR(p, rq) ||
+				(delta > 0 && task_running(rq, p)))
 			resched_task(rq->curr);
 	}
 out_unlock:
@@ -4384,7 +4386,8 @@ recheck:
 		 * our priority decreased, or our priority became higher
 		 * than the current's.
 		 */
-		if (TASK_PREEMPTS_CURR(p, rq) || (task_running(rq, p) && p->prio > oldprio))
+		if (TASK_PREEMPTS_CURR(p, rq) ||
+				(task_running(rq, p) && p->prio > oldprio))
 			resched_task(rq->curr);
 	}
 	__task_rq_unlock(rq);
_

Patches currently in -mm which might be from dmitry.adamushko@gmail.com are

kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements.patch
sched-implement-staircase-deadline-cpu-scheduler-improvements-fix.patch
