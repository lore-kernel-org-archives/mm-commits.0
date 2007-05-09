From: akpm@linux-foundation.org
Subject: - flush_cpu_workqueue-dont-flush-an-empty-worklist.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:00 -0700
Message-ID: <200705092151.l49Lp0PW002847@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755285AbXEIVva (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:51:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ego@in.ibm.com, vatsa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     flush_cpu_workqueue: don't flush an empty ->worklist
has been removed from the -mm tree.  Its filename was
     flush_cpu_workqueue-dont-flush-an-empty-worklist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: flush_cpu_workqueue: don't flush an empty ->worklist
From: Oleg Nesterov <oleg@tv-sign.ru>

Now when we have ->current_work we can avoid adding a barrier and waiting
for its completition when cwq's queue is empty.

Note: this change is also useful if we change flush_workqueue() to also
check the dead CPUs.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff -puN kernel/workqueue.c~flush_cpu_workqueue-dont-flush-an-empty-worklist kernel/workqueue.c
--- a/kernel/workqueue.c~flush_cpu_workqueue-dont-flush-an-empty-worklist
+++ a/kernel/workqueue.c
@@ -404,12 +404,15 @@ static void wq_barrier_func(struct work_
 	complete(&barr->done);
 }
 
-static inline void init_wq_barrier(struct wq_barrier *barr)
+static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
+					struct wq_barrier *barr, int tail)
 {
 	INIT_WORK(&barr->work, wq_barrier_func);
 	__set_bit(WORK_STRUCT_PENDING, work_data_bits(&barr->work));
 
 	init_completion(&barr->done);
+
+	insert_work(cwq, &barr->work, tail);
 }
 
 static void flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
@@ -428,13 +431,20 @@ static void flush_cpu_workqueue(struct c
 		preempt_disable();
 	} else {
 		struct wq_barrier barr;
+		int active = 0;
 
-		init_wq_barrier(&barr);
-		__queue_work(cwq, &barr.work);
+		spin_lock_irq(&cwq->lock);
+		if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
+			insert_wq_barrier(cwq, &barr, 1);
+			active = 1;
+		}
+		spin_unlock_irq(&cwq->lock);
 
-		preempt_enable();	/* Can no longer touch *cwq */
-		wait_for_completion(&barr.done);
-		preempt_disable();
+		if (active) {
+			preempt_enable();
+			wait_for_completion(&barr.done);
+			preempt_disable();
+		}
 	}
 }
 
@@ -475,8 +485,7 @@ static void wait_on_work(struct cpu_work
 
 	spin_lock_irq(&cwq->lock);
 	if (unlikely(cwq->current_work == work)) {
-		init_wq_barrier(&barr);
-		insert_work(cwq, &barr.work, 0);
+		insert_wq_barrier(cwq, &barr, 0);
 		running = 1;
 	}
 	spin_unlock_irq(&cwq->lock);
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
