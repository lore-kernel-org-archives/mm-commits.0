From: akpm@linux-foundation.org
Subject: - sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch removed from -mm tree
Date: Mon, 30 Apr 2007 13:21:00 -0700
Message-ID: <200704302021.l3UKL2vN014065@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946762AbXD3UVu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 16:21:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmitry.adamushko@gmail.com, kernel@kolivas.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sched: modification of TASK_PREEMPTS_CURRENT to avoid redundant reschedules (e.g. in set_user_nice) (update)
has been removed from the -mm tree.  Its filename was
     sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch

This patch was dropped because it was folded into sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch

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
