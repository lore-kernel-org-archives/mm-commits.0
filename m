From: akpm@linux-foundation.org
Subject: - sched-implement-staircase-deadline-cpu-scheduler-tweak.patch removed from -mm tree
Date: Mon, 30 Apr 2007 11:47:36 -0700
Message-ID: <200704301847.l3UIlaiV011785@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946605AbXD3Ssc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 14:48:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmitry.adamushko@gmail.com, kernel@kolivas.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sd-sched: (micro-optimisation) remove redundant assignment in recalc_task_prio()
has been removed from the -mm tree.  Its filename was
     sched-implement-staircase-deadline-cpu-scheduler-tweak.patch

This patch was dropped because I need to clear the decks

------------------------------------------------------
Subject: sd-sched: (micro-optimisation) remove redundant assignment in recalc_task_prio()
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>

Remove redundant "p->array = array" assignment at the end of
recalc_task_prio().  All the code pathes have already configured p->array
accordingly by this moment.

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN kernel/sched.c~sched-implement-staircase-deadline-cpu-scheduler-tweak kernel/sched.c
--- a/kernel/sched.c~sched-implement-staircase-deadline-cpu-scheduler-tweak
+++ a/kernel/sched.c
@@ -810,7 +810,6 @@ static void recalc_task_prio(struct task
 		return;
 	}
 	p->prio = p->normal_prio = queue_prio;
-	p->array = array;
 	__set_bit(USER_PRIO(p->prio), p->bitmap);
 }
 
_

Patches currently in -mm which might be from dmitry.adamushko@gmail.com are

kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
sched-implement-staircase-deadline-cpu-scheduler-tweak.patch
