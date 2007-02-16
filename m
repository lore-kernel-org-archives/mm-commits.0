From: akpm@linux-foundation.org
Subject: + workqueue-introduce-wq_per_cpu-helper.patch added to -mm tree
Date: Fri, 16 Feb 2007 14:44:30 -0800
Message-ID: <200702162244.l1GMiUbt011867@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39612 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946277AbXBPWom (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 17:44:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru


The patch titled
     workqueue: introduce wq_per_cpu() helper
has been added to the -mm tree.  Its filename is
     workqueue-introduce-wq_per_cpu-helper.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: workqueue: introduce wq_per_cpu() helper
From: Oleg Nesterov <oleg@tv-sign.ru>

Cleanup.  A number of per_cpu_ptr(wq->cpu_wq, cpu) users have to check that
cpu is valid for this wq.  Make a simple helper.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff -puN kernel/workqueue.c~workqueue-introduce-wq_per_cpu-helper kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-introduce-wq_per_cpu-helper
+++ a/kernel/workqueue.c
@@ -86,6 +86,14 @@ static const cpumask_t *wq_cpu_map(struc
 		? &cpu_singlethread_map : &cpu_populated_map;
 }
 
+static
+struct cpu_workqueue_struct *wq_per_cpu(struct workqueue_struct *wq, int cpu)
+{
+	if (unlikely(is_single_threaded(wq)))
+		cpu = singlethread_cpu;
+	return per_cpu_ptr(wq->cpu_wq, cpu);
+}
+
 /*
  * Set the workqueue on which a work item is to be run
  * - Must *only* be called if the pending flag is set
@@ -142,16 +150,14 @@ static void __queue_work(struct cpu_work
  */
 int fastcall queue_work(struct workqueue_struct *wq, struct work_struct *work)
 {
-	int ret = 0, cpu = get_cpu();
+	int ret = 0;
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
-		if (unlikely(is_single_threaded(wq)))
-			cpu = singlethread_cpu;
 		BUG_ON(!list_empty(&work->entry));
-		__queue_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
+		__queue_work(wq_per_cpu(wq, get_cpu()), work);
+		put_cpu();
 		ret = 1;
 	}
-	put_cpu();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(queue_work);
@@ -161,12 +167,8 @@ void delayed_work_timer_fn(unsigned long
 	struct delayed_work *dwork = (struct delayed_work *)__data;
 	struct cpu_workqueue_struct *cwq = get_wq_data(&dwork->work);
 	struct workqueue_struct *wq = cwq->wq;
-	int cpu = smp_processor_id();
-
-	if (unlikely(is_single_threaded(wq)))
-		cpu = singlethread_cpu;
 
-	__queue_work(per_cpu_ptr(wq->cpu_wq, cpu), &dwork->work);
+	__queue_work(wq_per_cpu(wq, smp_processor_id()), &dwork->work);
 }
 
 /**
@@ -209,9 +211,7 @@ int queue_delayed_work_on(int cpu, struc
 		BUG_ON(!list_empty(&work->entry));
 
 		/* This stores cwq for the moment, for the timer_fn */
-		set_wq_data(work,
-			per_cpu_ptr(wq->cpu_wq, wq->singlethread ?
-				singlethread_cpu : raw_smp_processor_id()));
+		set_wq_data(work, wq_per_cpu(wq, raw_smp_processor_id()));
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-rcu-optimization-for-clock_gettime.patch
git-block.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
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
workqueue-dont-save-interrupts-in-run_workqueue-update-2.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
make-queue_delayed_work-friendly-to-flush_fork.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
unify-queue_delayed_work-and-queue_delayed_work_on-fix.patch
workqueue-introduce-wq_per_cpu-helper.patch
make-cancel_rearming_delayed_work-work-on-any-workqueue-not-just-keventd_wq.patch
ipvs-flush-defense_work-before-module-unload.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch
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
