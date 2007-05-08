From: akpm@linux-foundation.org
Subject: + libata-core-convert-to-use-cancel_rearming_delayed_work.patch added to -mm tree
Date: Tue, 08 May 2007 13:44:34 -0700
Message-ID: <200705082044.l48KiYZi000870@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933223AbXEHUol (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 16:44:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru


The patch titled
     libata-core: convert to use cancel_rearming_delayed_work()
has been added to the -mm tree.  Its filename is
     libata-core-convert-to-use-cancel_rearming_delayed_work.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata-core: convert to use cancel_rearming_delayed_work()
From: Oleg Nesterov <oleg@tv-sign.ru>

We should not use cancel_work_sync(delayed_work->work). This works, but not
good. We can use cancel_rearming_delayed_work(), this also simplifies the
code.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   44 +++---------------------------------
 include/linux/libata.h    |    1 
 2 files changed, 4 insertions(+), 41 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-core-convert-to-use-cancel_rearming_delayed_work drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-core-convert-to-use-cancel_rearming_delayed_work
+++ a/drivers/ata/libata-core.c
@@ -1286,18 +1286,11 @@ static unsigned int ata_id_xfermask(cons
 void ata_port_queue_task(struct ata_port *ap, work_func_t fn, void *data,
 			 unsigned long delay)
 {
-	int rc;
-
-	if (ap->pflags & ATA_PFLAG_FLUSH_PORT_TASK)
-		return;
-
 	PREPARE_DELAYED_WORK(&ap->port_task, fn);
 	ap->port_task_data = data;
 
-	rc = queue_delayed_work(ata_wq, &ap->port_task, delay);
-
-	/* rc == 0 means that another user is using port task */
-	WARN_ON(rc == 0);
+	/* may fail if ata_port_flush_task() in progress */
+	queue_delayed_work(ata_wq, &ap->port_task, delay);
 }
 
 /**
@@ -1312,32 +1305,9 @@ void ata_port_queue_task(struct ata_port
  */
 void ata_port_flush_task(struct ata_port *ap)
 {
-	unsigned long flags;
-
 	DPRINTK("ENTER\n");
 
-	spin_lock_irqsave(ap->lock, flags);
-	ap->pflags |= ATA_PFLAG_FLUSH_PORT_TASK;
-	spin_unlock_irqrestore(ap->lock, flags);
-
-	DPRINTK("flush #1\n");
-	cancel_work_sync(&ap->port_task.work); /* akpm: seems unneeded */
-
-	/*
-	 * At this point, if a task is running, it's guaranteed to see
-	 * the FLUSH flag; thus, it will never queue pio tasks again.
-	 * Cancel and flush.
-	 */
-	if (!cancel_delayed_work(&ap->port_task)) {
-		if (ata_msg_ctl(ap))
-			ata_port_printk(ap, KERN_DEBUG, "%s: flush #2\n",
-					__FUNCTION__);
-		cancel_work_sync(&ap->port_task.work);
-	}
-
-	spin_lock_irqsave(ap->lock, flags);
-	ap->pflags &= ~ATA_PFLAG_FLUSH_PORT_TASK;
-	spin_unlock_irqrestore(ap->lock, flags);
+	cancel_rearming_delayed_work(&ap->port_task);
 
 	if (ata_msg_ctl(ap))
 		ata_port_printk(ap, KERN_DEBUG, "%s: EXIT\n", __FUNCTION__);
@@ -6518,13 +6488,7 @@ void ata_port_detach(struct ata_port *ap
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	ata_port_wait_eh(ap);
-
-	/* Flush hotplug task.  The sequence is similar to
-	 * ata_port_flush_task().
-	 */
-	cancel_work_sync(&ap->hotplug_task.work); /* akpm: why? */
-	cancel_delayed_work(&ap->hotplug_task);
-	cancel_work_sync(&ap->hotplug_task.work);
+	cancel_rearming_delayed_work(&ap->hotplug_task);
 
  skip_eh:
 	/* remove the associated SCSI host */
diff -puN include/linux/libata.h~libata-core-convert-to-use-cancel_rearming_delayed_work include/linux/libata.h
--- a/include/linux/libata.h~libata-core-convert-to-use-cancel_rearming_delayed_work
+++ a/include/linux/libata.h
@@ -193,7 +193,6 @@ enum {
 	ATA_PFLAG_SCSI_HOTPLUG	= (1 << 6), /* SCSI hotplug scheduled */
 	ATA_PFLAG_INITIALIZING	= (1 << 7), /* being initialized, don't touch */
 
-	ATA_PFLAG_FLUSH_PORT_TASK = (1 << 16), /* flush port task */
 	ATA_PFLAG_SUSPENDED	= (1 << 17), /* port is suspended (power) */
 	ATA_PFLAG_PM_PENDING	= (1 << 18), /* PM operation pending */
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
allow-access-to-proc-pid-fd-after-setuid.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
futex-restartable-futex_wait.patch
add-support-for-deferrable-timers-respun.patch
add-a-new-deferrable-delayed-work-init.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
reimplement-flush_workqueue.patch
implement-flush_work.patch
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
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
workqueues-shift-kthread_bind-from-cpu_up_prepare-to-cpu_online.patch
make-queue_delayed_work-friendly-to-flush_fork.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
workqueue-introduce-wq_per_cpu-helper.patch
make-cancel_rearming_delayed_work-work-on-any-workqueue-not-just-keventd_wq.patch
ipvs-flush-defense_work-before-module-unload.patch
workqueue-kill-noautorel-works.patch
worker_thread-dont-play-with-signals.patch
worker_thread-fix-racy-try_to_freeze-usage.patch
zap_other_threads-remove-unneeded-exit_signal-change.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch
____call_usermodehelper-dont-flush_signals.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
kthread-dont-depend-on-work-queues-take-2.patch
change-reparent_to_init-to-reparent_to_kthreadd.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
usbatm_heavy_init-dont-use-clone_sighand.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
worker_thread-dont-play-with-sigchld-and-numa-policy.patch
change-kernel-threads-to-ignore-signals-instead-of-blocking-them.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
remvoe-kthread_bind-call-from-_cpu_down.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
make-cancel_rearming_delayed_work-reliable.patch
make-cancel_rearming_delayed_work-reliable-spelling.patch
make-cancel_rearming_delayed_work-reliable-fix.patch
libata-core-convert-to-use-cancel_rearming_delayed_work.patch
dont-init-pgrp-and-__session-in-init_signals.patch
add-suspend-related-notifications-for-cpu-hotplug-cleanup.patch
vmstat-use-our-own-timer-events-fix.patch
