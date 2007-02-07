From: akpm@linux-foundation.org
Subject: + workqueue-introduce-cpu_singlethread_map.patch added to -mm tree
Date: Tue, 06 Feb 2007 17:45:34 -0800
Message-ID: <200702070145.l171jYon003630@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58675 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965603AbXBGBpw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 20:45:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, mingo@elte.hu


The patch titled
     workqueue: introduce cpu_singlethread_map
has been added to the -mm tree.  Its filename is
     workqueue-introduce-cpu_singlethread_map.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: workqueue: introduce cpu_singlethread_map
From: Oleg Nesterov <oleg@tv-sign.ru>

The code like

	if (is_single_threaded(wq))
		do_something(singlethread_cpu);
	else {
		for_each_cpu_mask(cpu, cpu_populated_map)
			do_something(cpu);
	}

looks very annoying. We can add "static cpumask_t cpu_singlethread_map" and
simplify the code. Lessens .text a bit, and imho makes the code more readable.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   52 +++++++++++++++++++------------------------
 1 files changed, 24 insertions(+), 28 deletions(-)

diff -puN kernel/workqueue.c~workqueue-introduce-cpu_singlethread_map kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-introduce-cpu_singlethread_map
+++ a/kernel/workqueue.c
@@ -69,6 +69,7 @@ static DEFINE_MUTEX(workqueue_mutex);
 static LIST_HEAD(workqueues);
 
 static int singlethread_cpu __read_mostly;
+static cpumask_t cpu_singlethread_map __read_mostly;
 /* optimization, we could use cpu_possible_map */
 static cpumask_t cpu_populated_map __read_mostly;
 
@@ -78,6 +79,12 @@ static inline int is_single_threaded(str
 	return list_empty(&wq->list);
 }
 
+static const cpumask_t *wq_cpu_map(struct workqueue_struct *wq)
+{
+	return is_single_threaded(wq)
+		? &cpu_singlethread_map : &cpu_populated_map;
+}
+
 /*
  * Set the workqueue on which a work item is to be run
  * - Must *only* be called if the pending flag is set
@@ -394,14 +401,11 @@ static void flush_cpu_workqueue(struct c
  */
 void fastcall flush_workqueue(struct workqueue_struct *wq)
 {
-	if (is_single_threaded(wq))
-		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, singlethread_cpu));
-	else {
-		int cpu;
+	const cpumask_t *cpu_map = wq_cpu_map(wq);
+	int cpu;
 
-		for_each_cpu_mask(cpu, cpu_populated_map)
-			flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
-	}
+	for_each_cpu_mask(cpu, *cpu_map)
+		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
@@ -438,7 +442,9 @@ static void wait_on_work(struct cpu_work
  */
 void flush_work(struct workqueue_struct *wq, struct work_struct *work)
 {
+	const cpumask_t *cpu_map = wq_cpu_map(wq);
 	struct cpu_workqueue_struct *cwq;
+	int cpu;
 
 	cwq = get_wq_data(work);
 	/* Was it ever queued ? */
@@ -454,14 +460,8 @@ void flush_work(struct workqueue_struct 
 	work_release(work);
 	spin_unlock_irq(&cwq->lock);
 
-	if (is_single_threaded(wq))
-		wait_on_work(per_cpu_ptr(wq->cpu_wq, singlethread_cpu), work);
-	else {
-		int cpu;
-
-		for_each_cpu_mask(cpu, cpu_populated_map)
-			wait_on_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
-	}
+	for_each_cpu_mask(cpu, *cpu_map)
+		wait_on_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
 }
 EXPORT_SYMBOL_GPL(flush_work);
 
@@ -754,22 +754,17 @@ static void cleanup_workqueue_thread(str
  */
 void destroy_workqueue(struct workqueue_struct *wq)
 {
+	const cpumask_t *cpu_map = wq_cpu_map(wq);
 	struct cpu_workqueue_struct *cwq;
+	int cpu;
 
-	if (is_single_threaded(wq)) {
-		cwq = per_cpu_ptr(wq->cpu_wq, singlethread_cpu);
-		cleanup_workqueue_thread(cwq, singlethread_cpu);
-	} else {
-		int cpu;
-
-		mutex_lock(&workqueue_mutex);
-		list_del(&wq->list);
-		mutex_unlock(&workqueue_mutex);
+	mutex_lock(&workqueue_mutex);
+	list_del(&wq->list);
+	mutex_unlock(&workqueue_mutex);
 
-		for_each_cpu_mask(cpu, cpu_populated_map) {
-			cwq = per_cpu_ptr(wq->cpu_wq, cpu);
-			cleanup_workqueue_thread(cwq, cpu);
-		}
+	for_each_cpu_mask(cpu, *cpu_map) {
+		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+		cleanup_workqueue_thread(cwq, cpu);
 	}
 
 	free_percpu(wq->cpu_wq);
@@ -828,6 +823,7 @@ void init_workqueues(void)
 {
 	cpu_populated_map = cpu_online_map;
 	singlethread_cpu = first_cpu(cpu_possible_map);
+	cpu_singlethread_map = cpumask_of_cpu(singlethread_cpu);
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

git-dvb.patch
git-block.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
vt-refactor-console-sak-processing.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
kill_pid_info-kill-acquired_tasklist_lock.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
_proc_do_string-fix-short-reads.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
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
posix-timers-rcu-optimization-for-clock_gettime.patch
posix-timers-rcu-optimization-for-clock_gettime-fix.patch
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
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-dont-save-interrupts-in-run_workqueue-update.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
rework-compat_sys_io_submit.patch
fix-aioh-includes.patch
fix-access_ok-checks.patch
make-good_sigevent-non-static.patch
make-good_sigevent-non-static-fix.patch
make-__sigqueue_free-and.patch
aio-completion-signal-notification.patch
aio-completion-signal-notification-fix.patch
aio-completion-signal-notification-fixes-and-cleanups.patch
aio-completion-signal-notification-small-cleanup.patch
add-listio-syscall-support.patch
hotplug-allow-modules-to-use-the-cpu-hotplug-notifiers.patch
