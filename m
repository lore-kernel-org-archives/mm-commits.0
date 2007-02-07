From: akpm@linux-foundation.org
Subject: + workqueue-dont-save-interrupts-in-run_workqueue.patch added to -mm tree
Date: Tue, 06 Feb 2007 17:45:19 -0800
Message-ID: <200702070145.l171jJM6003620@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58664 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbXBGBph (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 20:45:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, mingo@elte.hu


The patch titled
     workqueue: don't save interrupts in run_workqueue()
has been added to the -mm tree.  Its filename is
     workqueue-dont-save-interrupts-in-run_workqueue.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: workqueue: don't save interrupts in run_workqueue()
From: Oleg Nesterov <oleg@tv-sign.ru>

work->func() may sleep, it's a bug to call run_workqueue() with irqs disabled.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff -puN kernel/workqueue.c~workqueue-dont-save-interrupts-in-run_workqueue kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-dont-save-interrupts-in-run_workqueue
+++ a/kernel/workqueue.c
@@ -227,13 +227,7 @@ EXPORT_SYMBOL_GPL(queue_delayed_work_on)
 
 static void run_workqueue(struct cpu_workqueue_struct *cwq)
 {
-	unsigned long flags;
-
-	/*
-	 * Keep taking off work from the queue until
-	 * done.
-	 */
-	spin_lock_irqsave(&cwq->lock, flags);
+	spin_lock_irq(&cwq->lock);
 	cwq->run_depth++;
 	if (cwq->run_depth > 3) {
 		/* morton gets to eat his hat */
@@ -248,7 +242,7 @@ static void run_workqueue(struct cpu_wor
 
 		cwq->current_work = work;
 		list_del_init(cwq->worklist.next);
-		spin_unlock_irqrestore(&cwq->lock, flags);
+		spin_unlock_irq(&cwq->lock);
 
 		BUG_ON(get_wq_data(work) != cwq);
 		if (!test_bit(WORK_STRUCT_NOAUTOREL, work_data_bits(work)))
@@ -266,11 +260,11 @@ static void run_workqueue(struct cpu_wor
 			dump_stack();
 		}
 
-		spin_lock_irqsave(&cwq->lock, flags);
+		spin_lock_irq(&cwq->lock);
 		cwq->current_work = NULL;
 	}
 	cwq->run_depth--;
-	spin_unlock_irqrestore(&cwq->lock, flags);
+	spin_unlock_irq(&cwq->lock);
 }
 
 /*
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
