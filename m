From: akpm@osdl.org
Subject: + workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch added to -mm tree
Date: Thu, 11 Jan 2007 15:58:46 -0800
Message-ID: <200701112358.l0BNwkuv007094@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44761 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbXAKX7E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 18:59:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ego@in.ibm.com, vatsa@in.ibm.com, venkatesh.pallipadi@intel.com


The patch titled
     workqueue: fix flush_workqueue() vs CPU_DEAD race
has been added to the -mm tree.  Its filename is
     workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: workqueue: fix flush_workqueue() vs CPU_DEAD race
From: Oleg Nesterov <oleg@tv-sign.ru>

Many thanks to Srivatsa Vaddagiri for the helpful discussion and for spotting
the bug in my previous attempt.

work->func() (and thus flush_workqueue()) must not use workqueue_mutex,
this leads to deadlock when CPU_DEAD does kthread_stop(). However without
this mutex held we can't detect CPU_DEAD in progress, which can move pending
works to another CPU while the dead one is not on cpu_online_map.

Change flush_workqueue() to use for_each_possible_cpu(). This means that
flush_cpu_workqueue() may hit CPU which is already dead. However in that
case

	!list_empty(&cwq->worklist) || cwq->current_work != NULL

means that CPU_DEAD in progress, it will do kthread_stop() + take_over_work()
so we can proceed and insert a barrier. We hold cwq->lock, so we are safe.

Also, add migrate_sequence incremented by take_over_work() under cwq->lock.
If take_over_work() happened before we checked this CPU, we should see the
new value after spin_unlock().

Further possible changes:

	remove CPU_DEAD handling (along with take_over_work, migrate_sequence)
	from workqueue.c. CPU_DEAD just sets cwq->please_exit_after_flush flag.

	CPU_UP_PREPARE->create_workqueue_thread() clears this flag, and creates
	the new thread if cwq->thread == NULL.

This way the workqueue/cpu-hotplug interaction is almost zero, workqueue_mutex
just protects "workqueues" list, CPU_LOCK_ACQUIRE/CPU_LOCK_RELEASE go away.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Gautham shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/workqueue.c |   44 ++++++++++++++++++++++++-------------------
 1 files changed, 25 insertions(+), 19 deletions(-)

diff -puN kernel/workqueue.c~workqueue-fix-flush_workqueue-vs-cpu_dead-race kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-fix-flush_workqueue-vs-cpu_dead-race
+++ a/kernel/workqueue.c
@@ -64,6 +64,7 @@ struct workqueue_struct {
 
 /* All the per-cpu workqueues on the system, for hotplug cpu to add/remove
    threads to each one as cpus come/go. */
+static long migrate_sequence __read_mostly;
 static DEFINE_MUTEX(workqueue_mutex);
 static LIST_HEAD(workqueues);
 
@@ -421,13 +422,7 @@ static void flush_cpu_workqueue(struct c
 		 * Probably keventd trying to flush its own queue. So simply run
 		 * it by hand rather than deadlocking.
 		 */
-		preempt_enable();
-		/*
-		 * We can still touch *cwq here because we are keventd, and
-		 * hot-unplug will be waiting us to exit.
-		 */
 		run_workqueue(cwq);
-		preempt_disable();
 	} else {
 		struct wq_barrier barr;
 		int active = 0;
@@ -439,11 +434,8 @@ static void flush_cpu_workqueue(struct c
 		}
 		spin_unlock_irq(&cwq->lock);
 
-		if (active) {
-			preempt_enable();
+		if (active)
 			wait_for_completion(&barr.done);
-			preempt_disable();
-		}
 	}
 }
 
@@ -462,17 +454,21 @@ static void flush_cpu_workqueue(struct c
  */
 void fastcall flush_workqueue(struct workqueue_struct *wq)
 {
-	preempt_disable();		/* CPU hotplug */
 	if (is_single_threaded(wq)) {
 		/* Always use first cpu's area. */
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, singlethread_cpu));
 	} else {
+		long sequence;
 		int cpu;
+again:
+		sequence = migrate_sequence;
 
-		for_each_online_cpu(cpu)
+		for_each_possible_cpu(cpu)
 			flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
+
+		if (unlikely(sequence != migrate_sequence))
+			goto again;
 	}
-	preempt_enable();
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
@@ -544,17 +540,21 @@ out:
 }
 EXPORT_SYMBOL_GPL(flush_work);
 
-static struct task_struct *create_workqueue_thread(struct workqueue_struct *wq,
-							int cpu)
+static void init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
 {
 	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
-	struct task_struct *p;
 
-	spin_lock_init(&cwq->lock);
 	cwq->wq = wq;
-	cwq->thread = NULL;
+	spin_lock_init(&cwq->lock);
 	INIT_LIST_HEAD(&cwq->worklist);
 	init_waitqueue_head(&cwq->more_work);
+}
+
+static struct task_struct *create_workqueue_thread(struct workqueue_struct *wq,
+							int cpu)
+{
+	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+	struct task_struct *p;
 
 	if (is_single_threaded(wq))
 		p = kthread_create(worker_thread, cwq, "%s", wq->name);
@@ -589,6 +589,7 @@ struct workqueue_struct *__create_workqu
 	mutex_lock(&workqueue_mutex);
 	if (singlethread) {
 		INIT_LIST_HEAD(&wq->list);
+		init_cpu_workqueue(wq, singlethread_cpu);
 		p = create_workqueue_thread(wq, singlethread_cpu);
 		if (!p)
 			destroy = 1;
@@ -596,7 +597,11 @@ struct workqueue_struct *__create_workqu
 			wake_up_process(p);
 	} else {
 		list_add(&wq->list, &workqueues);
-		for_each_online_cpu(cpu) {
+		for_each_possible_cpu(cpu) {
+			init_cpu_workqueue(wq, cpu);
+			if (!cpu_online(cpu))
+				continue;
+
 			p = create_workqueue_thread(wq, cpu);
 			if (p) {
 				kthread_bind(p, cpu);
@@ -831,6 +836,7 @@ static void take_over_work(struct workqu
 
 	spin_lock_irq(&cwq->lock);
 	list_replace_init(&cwq->worklist, &list);
+	migrate_sequence++;
 
 	while (!list_empty(&list)) {
 		printk("Taking work for %s\n", wq->name);
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
