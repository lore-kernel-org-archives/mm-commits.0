From: akpm@osdl.org
Subject: + workqueue-fix-freezeable-workqueues-implementation.patch added to -mm tree
Date: Thu, 11 Jan 2007 15:58:44 -0800
Message-ID: <200701112358.l0BNwi9a007091@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44776 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbXAKX7M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 18:59:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ego@in.ibm.com, vatsa@in.ibm.com, venkatesh.pallipadi@intel.com


The patch titled
     workqueue: fix freezeable workqueues implementation
has been added to the -mm tree.  Its filename is
     workqueue-fix-freezeable-workqueues-implementation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: workqueue: fix freezeable workqueues implementation
From: Oleg Nesterov <oleg@tv-sign.ru>

Currently ->freezeable is per-cpu, this is wrong. CPU_UP_PREPARE creates
cwq->thread which is not freezeable. Move ->freezeable to workqueue_struct.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Gautham shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/workqueue.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff -puN kernel/workqueue.c~workqueue-fix-freezeable-workqueues-implementation kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-fix-freezeable-workqueues-implementation
+++ a/kernel/workqueue.c
@@ -49,8 +49,6 @@ struct cpu_workqueue_struct {
 	struct work_struct *current_work;
 
 	int run_depth;		/* Detect run_workqueue() recursion depth */
-
-	int freezeable;		/* Freeze the thread during suspend */
 } ____cacheline_aligned;
 
 /*
@@ -61,6 +59,7 @@ struct workqueue_struct {
 	struct cpu_workqueue_struct *cpu_wq;
 	const char *name;
 	struct list_head list; 	/* Empty if single thread */
+	int freezeable;		/* Freeze threads during suspend */
 };
 
 /* All the per-cpu workqueues on the system, for hotplug cpu to add/remove
@@ -351,7 +350,7 @@ static int worker_thread(void *__cwq)
 	struct k_sigaction sa;
 	sigset_t blocked;
 
-	if (!cwq->freezeable)
+	if (!cwq->wq->freezeable)
 		current->flags |= PF_NOFREEZE;
 
 	set_user_nice(current, -5);
@@ -375,7 +374,7 @@ static int worker_thread(void *__cwq)
 
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
-		if (cwq->freezeable)
+		if (cwq->wq->freezeable)
 			try_to_freeze();
 
 		add_wait_queue(&cwq->more_work, &wait);
@@ -546,7 +545,7 @@ out:
 EXPORT_SYMBOL_GPL(flush_work);
 
 static struct task_struct *create_workqueue_thread(struct workqueue_struct *wq,
-						   int cpu, int freezeable)
+							int cpu)
 {
 	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
 	struct task_struct *p;
@@ -554,7 +553,6 @@ static struct task_struct *create_workqu
 	spin_lock_init(&cwq->lock);
 	cwq->wq = wq;
 	cwq->thread = NULL;
-	cwq->freezeable = freezeable;
 	INIT_LIST_HEAD(&cwq->worklist);
 	init_waitqueue_head(&cwq->more_work);
 
@@ -586,10 +584,12 @@ struct workqueue_struct *__create_workqu
 	}
 
 	wq->name = name;
+	wq->freezeable = freezeable;
+
 	mutex_lock(&workqueue_mutex);
 	if (singlethread) {
 		INIT_LIST_HEAD(&wq->list);
-		p = create_workqueue_thread(wq, singlethread_cpu, freezeable);
+		p = create_workqueue_thread(wq, singlethread_cpu);
 		if (!p)
 			destroy = 1;
 		else
@@ -597,7 +597,7 @@ struct workqueue_struct *__create_workqu
 	} else {
 		list_add(&wq->list, &workqueues);
 		for_each_online_cpu(cpu) {
-			p = create_workqueue_thread(wq, cpu, freezeable);
+			p = create_workqueue_thread(wq, cpu);
 			if (p) {
 				kthread_bind(p, cpu);
 				wake_up_process(p);
@@ -857,7 +857,7 @@ static int __devinit workqueue_cpu_callb
 	case CPU_UP_PREPARE:
 		/* Create a new workqueue thread for it. */
 		list_for_each_entry(wq, &workqueues, list) {
-			if (!create_workqueue_thread(wq, hotcpu, 0)) {
+			if (!create_workqueue_thread(wq, hotcpu)) {
 				printk("workqueue for %i failed\n", hotcpu);
 				return NOTIFY_BAD;
 			}
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

git-block.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
vt-refactor-console-sak-processing.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
kill_pid_info-kill-acquired_tasklist_lock.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
reimplement-flush_workqueue.patch
implement-flush_work.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
flush_cpu_workqueue-dont-flush-an-empty-worklist.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
slab-use-cpu_lock_.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
