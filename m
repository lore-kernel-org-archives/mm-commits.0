From: akpm@linux-foundation.org
Subject: - workqueue-introduce-workqueue_struct-singlethread.patch removed from -mm tree
Date: Wed, 09 May 2007 14:51:51 -0700
Message-ID: <200705092151.l49LppgW002929@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759409AbXEIWJV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 18:09:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     workqueue: introduce workqueue_struct->singlethread
has been removed from the -mm tree.  Its filename was
     workqueue-introduce-workqueue_struct-singlethread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: workqueue: introduce workqueue_struct->singlethread
From: Oleg Nesterov <oleg@tv-sign.ru>

Add explicit workqueue_struct->singlethread flag.  This lessens .text a
little, but most importantly this allows us to manipulate wq->list without
changine the meaning of is_single_threaded().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN kernel/workqueue.c~workqueue-introduce-workqueue_struct-singlethread kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-introduce-workqueue_struct-singlethread
+++ a/kernel/workqueue.c
@@ -58,8 +58,9 @@ struct cpu_workqueue_struct {
  */
 struct workqueue_struct {
 	struct cpu_workqueue_struct *cpu_wq;
+	struct list_head list;
 	const char *name;
-	struct list_head list; 	/* Empty if single thread */
+	int singlethread;
 	int freezeable;		/* Freeze threads during suspend */
 };
 
@@ -76,7 +77,7 @@ static cpumask_t cpu_populated_map __rea
 /* If it's single threaded, it isn't in the list of workqueues. */
 static inline int is_single_threaded(struct workqueue_struct *wq)
 {
-	return list_empty(&wq->list);
+	return wq->singlethread;
 }
 
 static const cpumask_t *wq_cpu_map(struct workqueue_struct *wq)
@@ -401,7 +402,7 @@ static void flush_cpu_workqueue(struct c
 void fastcall flush_workqueue(struct workqueue_struct *wq)
 {
 	const cpumask_t *cpu_map = wq_cpu_map(wq);
-	int cpu
+	int cpu;
 
 	might_sleep();
 	for_each_cpu_mask(cpu, *cpu_map)
@@ -694,10 +695,11 @@ struct workqueue_struct *__create_workqu
 	}
 
 	wq->name = name;
+	wq->singlethread = singlethread;
 	wq->freezeable = freezeable;
+	INIT_LIST_HEAD(&wq->list);
 
 	if (singlethread) {
-		INIT_LIST_HEAD(&wq->list);
 		cwq = init_cpu_workqueue(wq, singlethread_cpu);
 		err = create_workqueue_thread(cwq, singlethread_cpu);
 	} else {
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
