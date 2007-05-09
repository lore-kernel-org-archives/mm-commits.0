From: akpm@linux-foundation.org
Subject: - workqueues-shift-kthread_bind-from-cpu_up_prepare-to-cpu_online.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:55 -0700
Message-ID: <200705092151.l49LptV8002937@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758854AbXEIVw0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ego@in.ibm.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     workqueues: shift kthread_bind() from CPU_UP_PREPARE to CPU_ONLINE
has been removed from the -mm tree.  Its filename was
     workqueues-shift-kthread_bind-from-cpu_up_prepare-to-cpu_online.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: workqueues: shift kthread_bind() from CPU_UP_PREPARE to CPU_ONLINE
From: Oleg Nesterov <oleg@tv-sign.ru>

CPU_UP_PREPARE binds cwq->thread to the new CPU.  So CPU_UP_CANCELED tries to
wake up the task which is bound to the failed CPU.

With this patch we don't bind cwq->thread until CPU becomes online.  The first
wake_up() after kthread_create() is a bit special, make a simple helper for
that.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff -puN kernel/workqueue.c~workqueues-shift-kthread_bind-from-cpu_up_prepare-to-cpu_online kernel/workqueue.c
--- a/kernel/workqueue.c~workqueues-shift-kthread_bind-from-cpu_up_prepare-to-cpu_online
+++ a/kernel/workqueue.c
@@ -668,15 +668,21 @@ static int create_workqueue_thread(struc
 
 	cwq->thread = p;
 	cwq->should_stop = 0;
-	if (!is_single_threaded(wq))
-		kthread_bind(p, cpu);
-
-	if (is_single_threaded(wq) || cpu_online(cpu))
-		wake_up_process(p);
 
 	return 0;
 }
 
+static void start_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
+{
+	struct task_struct *p = cwq->thread;
+
+	if (p != NULL) {
+		if (cpu >= 0)
+			kthread_bind(p, cpu);
+		wake_up_process(p);
+	}
+}
+
 struct workqueue_struct *__create_workqueue(const char *name,
 					    int singlethread, int freezeable)
 {
@@ -702,6 +708,7 @@ struct workqueue_struct *__create_workqu
 	if (singlethread) {
 		cwq = init_cpu_workqueue(wq, singlethread_cpu);
 		err = create_workqueue_thread(cwq, singlethread_cpu);
+		start_workqueue_thread(cwq, -1);
 	} else {
 		mutex_lock(&workqueue_mutex);
 		list_add(&wq->list, &workqueues);
@@ -711,6 +718,7 @@ struct workqueue_struct *__create_workqu
 			if (err || !cpu_online(cpu))
 				continue;
 			err = create_workqueue_thread(cwq, cpu);
+			start_workqueue_thread(cwq, cpu);
 		}
 		mutex_unlock(&workqueue_mutex);
 	}
@@ -808,12 +816,11 @@ static int __devinit workqueue_cpu_callb
 			return NOTIFY_BAD;
 
 		case CPU_ONLINE:
-			wake_up_process(cwq->thread);
+			start_workqueue_thread(cwq, cpu);
 			break;
 
 		case CPU_UP_CANCELED:
-			if (cwq->thread)
-				wake_up_process(cwq->thread);
+			start_workqueue_thread(cwq, -1);
 		case CPU_DEAD:
 			cleanup_workqueue_thread(cwq, cpu);
 			break;
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
