From: akpm@linux-foundation.org
Subject: - workqueue-dont-clear-cwq-thread-until-it-exits.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:38 -0700
Message-ID: <200705092151.l49LpcoF002899@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758688AbXEIVwG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ego@in.ibm.com, vatsa@in.ibm.com, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     workqueue: don't clear cwq->thread until it exits
has been removed from the -mm tree.  Its filename was
     workqueue-dont-clear-cwq-thread-until-it-exits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: workqueue: don't clear cwq->thread until it exits
From: Oleg Nesterov <oleg@tv-sign.ru>

Pointed out by Srivatsa Vaddagiri.

cleanup_workqueue_thread() sets cwq->thread = NULL and does kthread_stop().
This breaks the "if (cwq->thread == current)" logic in flush_cpu_workqueue()
and leads to deadlock.

Kill the thead first, then clear cwq->thread. workqueue_mutex protects us
from create_workqueue_thread() so we don't need cwq->lock.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Gautham shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN kernel/workqueue.c~workqueue-dont-clear-cwq-thread-until-it-exits kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-dont-clear-cwq-thread-until-it-exits
+++ a/kernel/workqueue.c
@@ -625,17 +625,12 @@ EXPORT_SYMBOL_GPL(__create_workqueue);
 
 static void cleanup_workqueue_thread(struct workqueue_struct *wq, int cpu)
 {
-	struct cpu_workqueue_struct *cwq;
-	unsigned long flags;
-	struct task_struct *p;
+	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
 
-	cwq = per_cpu_ptr(wq->cpu_wq, cpu);
-	spin_lock_irqsave(&cwq->lock, flags);
-	p = cwq->thread;
-	cwq->thread = NULL;
-	spin_unlock_irqrestore(&cwq->lock, flags);
-	if (p)
-		kthread_stop(p);
+	if (cwq->thread) {
+		kthread_stop(cwq->thread);
+		cwq->thread = NULL;
+	}
 }
 
 /**
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
libata-core-convert-to-use-cancel_rearming_delayed_work.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
dont-init-pgrp-and-__session-in-init_signals.patch
