From: akpm@linux-foundation.org
Subject: + unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch added to -mm tree
Date: Wed, 14 Feb 2007 14:29:44 -0800
Message-ID: <200702142229.l1EMTiA9011263@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49016 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609AbXBNWaH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 17:30:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, davem@davemloft.net, jeff@garzik.org


The patch titled
     unify flush_work/flush_work_keventd and rename it to cancel_work_sync
has been added to the -mm tree.  Its filename is
     unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: unify flush_work/flush_work_keventd and rename it to cancel_work_sync
From: Oleg Nesterov <oleg@tv-sign.ru>

flush_work(wq, work) doesn't need the first parameter, we can use cwq->wq
(this was possible from the very beginnig, I missed this).  So we can unify
flush_work_keventd and flush_work.

Also, rename flush_work() to cancel_work_sync() and fix all callers. 
Perhaps this is not the best name, but "flush_work" is really bad.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ll_rw_blk.c              |    2 -
 drivers/ata/libata-core.c      |    8 +++---
 drivers/net/e1000/e1000_main.c |    2 -
 drivers/net/phy/phy.c          |    4 +--
 drivers/net/tg3.c              |    2 -
 fs/aio.c                       |    4 +--
 include/linux/workqueue.h      |   21 +++++++++--------
 kernel/relay.c                 |    2 -
 kernel/workqueue.c             |   38 ++++++++++++++-----------------
 net/ipv4/ipvs/ip_vs_ctl.c      |    2 -
 10 files changed, 43 insertions(+), 42 deletions(-)

diff -puN block/ll_rw_blk.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync
+++ a/block/ll_rw_blk.c
@@ -3600,7 +3600,7 @@ EXPORT_SYMBOL(kblockd_schedule_work);
 
 void kblockd_flush_work(struct work_struct *work)
 {
-	flush_work(kblockd_workqueue, work);
+	cancel_work_sync(work);
 }
 EXPORT_SYMBOL(kblockd_flush_work);
 
diff -puN drivers/ata/libata-core.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync
+++ a/drivers/ata/libata-core.c
@@ -1071,7 +1071,7 @@ void ata_port_flush_task(struct ata_port
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	DPRINTK("flush #1\n");
-	flush_work(ata_wq, &ap->port_task.work); /* akpm: seems unneeded */
+	cancel_work_sync(&ap->port_task.work); /* akpm: seems unneeded */
 
 	/*
 	 * At this point, if a task is running, it's guaranteed to see
@@ -1082,7 +1082,7 @@ void ata_port_flush_task(struct ata_port
 		if (ata_msg_ctl(ap))
 			ata_port_printk(ap, KERN_DEBUG, "%s: flush #2\n",
 					__FUNCTION__);
-		flush_work(ata_wq, &ap->port_task.work);
+		cancel_work_sync(&ap->port_task.work);
 	}
 
 	spin_lock_irqsave(ap->lock, flags);
@@ -5880,9 +5880,9 @@ void ata_port_detach(struct ata_port *ap
 	/* Flush hotplug task.  The sequence is similar to
 	 * ata_port_flush_task().
 	 */
-	flush_work(ata_aux_wq, &ap->hotplug_task.work); /* akpm: why? */
+	cancel_work_sync(&ap->hotplug_task.work); /* akpm: why? */
 	cancel_delayed_work(&ap->hotplug_task);
-	flush_work(ata_aux_wq, &ap->hotplug_task.work);
+	cancel_work_sync(&ap->hotplug_task.work);
 
  skip_eh:
 	/* remove the associated SCSI host */
diff -puN drivers/net/e1000/e1000_main.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync
+++ a/drivers/net/e1000/e1000_main.c
@@ -1216,7 +1216,7 @@ e1000_remove(struct pci_dev *pdev)
 	int i;
 #endif
 
-	flush_work_keventd(&adapter->reset_task);
+	cancel_work_sync(&adapter->reset_task);
 
 	e1000_release_manageability(adapter);
 
diff -puN drivers/net/phy/phy.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync drivers/net/phy/phy.c
--- a/drivers/net/phy/phy.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync
+++ a/drivers/net/phy/phy.c
@@ -657,9 +657,9 @@ int phy_stop_interrupts(struct phy_devic
 
 	/*
 	 * Finish any pending work; we might have been scheduled to be called
-	 * from keventd ourselves, but flush_work_keventd() handles that.
+	 * from keventd ourselves, but cancel_work_sync() handles that.
 	 */
-	flush_work_keventd(&phydev->phy_queue);
+	cancel_work_sync(&phydev->phy_queue);
 
 	free_irq(phydev->irq, phydev);
 
diff -puN drivers/net/tg3.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync drivers/net/tg3.c
--- a/drivers/net/tg3.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync
+++ a/drivers/net/tg3.c
@@ -7358,7 +7358,7 @@ static int tg3_close(struct net_device *
 {
 	struct tg3 *tp = netdev_priv(dev);
 
-	flush_work_keventd(&tp->reset_task);
+	cancel_work_sync(&tp->reset_task);
 
 	netif_stop_queue(dev);
 
diff -puN fs/aio.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync fs/aio.c
--- a/fs/aio.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync
+++ a/fs/aio.c
@@ -351,7 +351,7 @@ void fastcall exit_aio(struct mm_struct 
 		/*
 		 * Ensure we don't leave the ctx on the aio_wq
 		 */
-		flush_work(aio_wq, &ctx->wq.work);
+		cancel_work_sync(&ctx->wq.work);
 
 		if (1 != atomic_read(&ctx->users))
 			printk(KERN_DEBUG
@@ -374,7 +374,7 @@ void fastcall __put_ioctx(struct kioctx 
 	BUG_ON(ctx->reqs_active);
 
 	cancel_delayed_work(&ctx->wq);
-	flush_work(aio_wq, &ctx->wq.work);
+	cancel_work_sync(&ctx->wq.work);
 	aio_free_ring(ctx);
 	mmdrop(ctx->mm);
 	ctx->mm = NULL;
diff -puN include/linux/workqueue.h~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync include/linux/workqueue.h
--- a/include/linux/workqueue.h~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync
+++ a/include/linux/workqueue.h
@@ -168,29 +168,32 @@ extern struct workqueue_struct *__create
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
 extern int FASTCALL(queue_work(struct workqueue_struct *wq, struct work_struct *work));
-extern int FASTCALL(queue_delayed_work(struct workqueue_struct *wq, struct delayed_work *work, unsigned long delay));
+extern int FASTCALL(queue_delayed_work(struct workqueue_struct *wq,
+			struct delayed_work *work, unsigned long delay));
 extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
-	struct delayed_work *work, unsigned long delay);
+			struct delayed_work *work, unsigned long delay);
+
 extern void FASTCALL(flush_workqueue(struct workqueue_struct *wq));
-extern void flush_work(struct workqueue_struct *wq, struct work_struct *work);
-extern void flush_work_keventd(struct work_struct *work);
+extern void flush_scheduled_work(void);
 
 extern int FASTCALL(schedule_work(struct work_struct *work));
-extern int FASTCALL(schedule_delayed_work(struct delayed_work *work, unsigned long delay));
-
-extern int schedule_delayed_work_on(int cpu, struct delayed_work *work, unsigned long delay);
+extern int FASTCALL(schedule_delayed_work(struct delayed_work *work,
+					unsigned long delay));
+extern int schedule_delayed_work_on(int cpu, struct delayed_work *work,
+					unsigned long delay);
 extern int schedule_on_each_cpu(work_func_t func);
-extern void flush_scheduled_work(void);
 extern int current_is_keventd(void);
 extern int keventd_up(void);
 
 extern void init_workqueues(void);
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
+extern void cancel_work_sync(struct work_struct *work);
+
 /*
  * Kill off a pending schedule_delayed_work().  Note that the work callback
  * function may still be running on return from cancel_delayed_work().  Run
- * flush_workqueue() or flush_work() to wait on it.
+ * flush_workqueue() or cancel_work_sync() to wait on it.
  */
 static inline int cancel_delayed_work(struct delayed_work *work)
 {
diff -puN kernel/relay.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync kernel/relay.c
--- a/kernel/relay.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync
+++ a/kernel/relay.c
@@ -340,7 +340,7 @@ static void __relay_reset(struct rchan_b
 		INIT_DELAYED_WORK(&buf->wake_readers, NULL);
 	} else {
 		cancel_delayed_work(&buf->wake_readers);
-		flush_work_keventd(&buf->wake_readers.work);
+		cancel_work_sync(&buf->wake_readers.work);
 	}
 
 	buf->subbufs_produced = 0;
diff -puN kernel/workqueue.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync kernel/workqueue.c
--- a/kernel/workqueue.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync
+++ a/kernel/workqueue.c
@@ -420,23 +420,23 @@ static void wait_on_work(struct cpu_work
 }
 
 /**
- * flush_work - block until a work_struct's callback has terminated
- * @wq: the workqueue on which the work is queued
+ * cancel_work_sync - block until a work_struct's callback has terminated
  * @work: the work which is to be flushed
  *
- * flush_work() will attempt to cancel the work if it is queued.  If the work's
- * callback appears to be running, flush_work() will block until it has
- * completed.
- *
- * flush_work() is designed to be used when the caller is tearing down data
- * structures which the callback function operates upon.  It is expected that,
- * prior to calling flush_work(), the caller has arranged for the work to not
- * be requeued.
+ * cancel_work_sync() will attempt to cancel the work if it is queued. If the
+ * work's callback appears to be running, cancel_work_sync() will block until
+ * it has completed.
+ *
+ * cancel_work_sync() is designed to be used when the caller is tearing down
+ * data structures which the callback function operates upon. It is expected
+ * that, prior to calling cancel_work_sync(), the caller has arranged for the
+ * work to not be requeued.
  */
-void flush_work(struct workqueue_struct *wq, struct work_struct *work)
+void cancel_work_sync(struct work_struct *work)
 {
-	const cpumask_t *cpu_map = wq_cpu_map(wq);
 	struct cpu_workqueue_struct *cwq;
+	struct workqueue_struct *wq;
+	const cpumask_t *cpu_map;
 	int cpu;
 
 	might_sleep();
@@ -455,10 +455,13 @@ void flush_work(struct workqueue_struct 
 	work_release(work);
 	spin_unlock_irq(&cwq->lock);
 
+	wq = cwq->wq;
+	cpu_map = wq_cpu_map(wq);
+
 	for_each_cpu_mask(cpu, *cpu_map)
 		wait_on_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
 }
-EXPORT_SYMBOL_GPL(flush_work);
+EXPORT_SYMBOL_GPL(cancel_work_sync);
 
 
 static struct workqueue_struct *keventd_wq;
@@ -547,18 +550,13 @@ void flush_scheduled_work(void)
 }
 EXPORT_SYMBOL(flush_scheduled_work);
 
-void flush_work_keventd(struct work_struct *work)
-{
-	flush_work(keventd_wq, work);
-}
-EXPORT_SYMBOL(flush_work_keventd);
-
 /**
  * cancel_rearming_delayed_work - kill off a delayed work whose handler rearms the delayed work.
  * @dwork: the delayed work struct
  *
  * Note that the work callback function may still be running on return from
- * cancel_delayed_work(). Run flush_workqueue() or flush_work() to wait on it.
+ * cancel_delayed_work(). Run flush_workqueue() or cancel_work_sync() to wait
+ * on it.
  */
 void cancel_rearming_delayed_work(struct delayed_work *dwork)
 {
diff -puN net/ipv4/ipvs/ip_vs_ctl.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync net/ipv4/ipvs/ip_vs_ctl.c
--- a/net/ipv4/ipvs/ip_vs_ctl.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync
+++ a/net/ipv4/ipvs/ip_vs_ctl.c
@@ -2387,7 +2387,7 @@ void ip_vs_control_cleanup(void)
 	EnterFunction(2);
 	ip_vs_trash_cleanup();
 	cancel_rearming_delayed_work(&defense_work);
-	flush_work_keventd(&defense_work.work);
+	cancel_work_sync(&defense_work.work);
 	ip_vs_kill_estimator(&ip_vs_stats);
 	unregister_sysctl_table(sysctl_header);
 	proc_net_remove("ip_vs_stats");
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
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
workqueue-dont-save-interrupts-in-run_workqueue-update-2.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
make-queue_delayed_work-friendly-to-flush_fork.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
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
