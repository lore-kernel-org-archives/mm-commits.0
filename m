From: akpm@linux-foundation.org
Subject: + sched-implement-staircase-deadline-cpu-scheduler-tweak.patch added to -mm tree
Date: Wed, 11 Apr 2007 13:16:22 -0700
Message-ID: <200704112016.l3BKGMqC013362@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59028 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965194AbXDKUQq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 16:16:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmitry.adamushko@gmail.com, kernel@kolivas.org, mingo@elte.hu


The patch titled
     sd-sched: (micro-optimisation) remove redundant assignment in recalc_task_prio()
has been added to the -mm tree.  Its filename is
     sched-implement-staircase-deadline-cpu-scheduler-tweak.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements.patch
sched-implement-staircase-deadline-cpu-scheduler-improvements-fix.patch
sched-implement-staircase-deadline-cpu-scheduler-avoid-redundant-reschedule-in-set_user_nice.patch
sched-implement-staircase-deadline-cpu-scheduler-tweak.patch
