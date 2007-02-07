From: akpm@linux-foundation.org
Subject: + workqueue-kill-run_scheduled_work.patch added to -mm tree
Date: Tue, 06 Feb 2007 17:45:13 -0800
Message-ID: <200702070145.l171jDns003612@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58665 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933113AbXBGBpk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 20:45:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, mingo@elte.hu


The patch titled
     workqueue: kill run_scheduled_work()
has been added to the -mm tree.  Its filename is
     workqueue-kill-run_scheduled_work.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: workqueue: kill run_scheduled_work()
From: Oleg Nesterov <oleg@tv-sign.ru>

Because it has no callers.

Actually, I think the whole idea of run_scheduled_work() was not right, not
good to mix "unqueue this work and execute its ->func()" in one function.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/workqueue.h |    1 
 kernel/workqueue.c        |   73 ------------------------------------
 2 files changed, 74 deletions(-)

diff -puN include/linux/workqueue.h~workqueue-kill-run_scheduled_work include/linux/workqueue.h
--- a/include/linux/workqueue.h~workqueue-kill-run_scheduled_work
+++ a/include/linux/workqueue.h
@@ -176,7 +176,6 @@ extern void flush_work(struct workqueue_
 extern void flush_work_keventd(struct work_struct *work);
 
 extern int FASTCALL(schedule_work(struct work_struct *work));
-extern int FASTCALL(run_scheduled_work(struct work_struct *work));
 extern int FASTCALL(schedule_delayed_work(struct delayed_work *work, unsigned long delay));
 
 extern int schedule_delayed_work_on(int cpu, struct delayed_work *work, unsigned long delay);
diff -puN kernel/workqueue.c~workqueue-kill-run_scheduled_work kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-kill-run_scheduled_work
+++ a/kernel/workqueue.c
@@ -98,79 +98,6 @@ static inline void *get_wq_data(struct w
 	return (void *) (atomic_long_read(&work->data) & WORK_STRUCT_WQ_DATA_MASK);
 }
 
-static int __run_work(struct cpu_workqueue_struct *cwq, struct work_struct *work)
-{
-	int ret = 0;
-	unsigned long flags;
-
-	spin_lock_irqsave(&cwq->lock, flags);
-	/*
-	 * We need to re-validate the work info after we've gotten
-	 * the cpu_workqueue lock. We can run the work now iff:
-	 *
-	 *  - the wq_data still matches the cpu_workqueue_struct
-	 *  - AND the work is still marked pending
-	 *  - AND the work is still on a list (which will be this
-	 *    workqueue_struct list)
-	 *
-	 * All these conditions are important, because we
-	 * need to protect against the work being run right
-	 * now on another CPU (all but the last one might be
-	 * true if it's currently running and has not been
-	 * released yet, for example).
-	 */
-	if (get_wq_data(work) == cwq
-	    && work_pending(work)
-	    && !list_empty(&work->entry)) {
-		work_func_t f = work->func;
-		cwq->current_work = work;
-		list_del_init(&work->entry);
-		spin_unlock_irqrestore(&cwq->lock, flags);
-
-		if (!test_bit(WORK_STRUCT_NOAUTOREL, work_data_bits(work)))
-			work_release(work);
-		f(work);
-
-		spin_lock_irqsave(&cwq->lock, flags);
-		cwq->current_work = NULL;
-		ret = 1;
-	}
-	spin_unlock_irqrestore(&cwq->lock, flags);
-	return ret;
-}
-
-/**
- * run_scheduled_work - run scheduled work synchronously
- * @work: work to run
- *
- * This checks if the work was pending, and runs it
- * synchronously if so. It returns a boolean to indicate
- * whether it had any scheduled work to run or not.
- *
- * NOTE! This _only_ works for normal work_structs. You
- * CANNOT use this for delayed work, because the wq data
- * for delayed work will not point properly to the per-
- * CPU workqueue struct, but will change!
- */
-int fastcall run_scheduled_work(struct work_struct *work)
-{
-	for (;;) {
-		struct cpu_workqueue_struct *cwq;
-
-		if (!work_pending(work))
-			return 0;
-		if (list_empty(&work->entry))
-			return 0;
-		/* NOTE! This depends intimately on __queue_work! */
-		cwq = get_wq_data(work);
-		if (!cwq)
-			return 0;
-		if (__run_work(cwq, work))
-			return 1;
-	}
-}
-EXPORT_SYMBOL(run_scheduled_work);
-
 static void insert_work(struct cpu_workqueue_struct *cwq,
 				struct work_struct *work, int tail)
 {
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
