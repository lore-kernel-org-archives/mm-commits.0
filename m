From: akpm@linux-foundation.org
Subject: - unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch removed from -mm tree
Date: Wed, 09 May 2007 14:52:20 -0700
Message-ID: <200705092152.l49LqKm9002988@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758989AbXEIVw6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, auke-jan.h.kok@intel.com, davem@davemloft.net, htejun@gmail.com, jeff@garzik.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     unify flush_work/flush_work_keventd and rename it to cancel_work_sync
has been removed from the -mm tree.  Its filename was
     unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: unify flush_work/flush_work_keventd and rename it to cancel_work_sync
From: Oleg Nesterov <oleg@tv-sign.ru>

flush_work(wq, work) doesn't need the first parameter, we can use cwq->wq
(this was possible from the very beginnig, I missed this).  So we can unify
flush_work_keventd and flush_work.

Also, rename flush_work() to cancel_work_sync() and fix all callers. 
Perhaps this is not the best name, but "flush_work" is really bad.

(akpm: this is why the earlier patches bypassed maintainers)

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Auke Kok <auke-jan.h.kok@intel.com>, 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ll_rw_blk.c              |    2 -
 drivers/ata/libata-core.c      |    8 +++---
 drivers/net/e1000/e1000_main.c |    2 -
 drivers/net/phy/phy.c          |    4 +--
 drivers/net/tg3.c              |    2 -
 fs/aio.c                       |    4 +--
 include/linux/workqueue.h      |   21 +++++++++--------
 kernel/workqueue.c             |   38 ++++++++++++++-----------------
 net/ipv4/ipvs/ip_vs_ctl.c      |    2 -
 9 files changed, 42 insertions(+), 41 deletions(-)

diff -puN block/ll_rw_blk.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync
+++ a/block/ll_rw_blk.c
@@ -3633,7 +3633,7 @@ EXPORT_SYMBOL(kblockd_schedule_work);
 
 void kblockd_flush_work(struct work_struct *work)
 {
-	flush_work(kblockd_workqueue, work);
+	cancel_work_sync(work);
 }
 EXPORT_SYMBOL(kblockd_flush_work);
 
diff -puN drivers/ata/libata-core.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync
+++ a/drivers/ata/libata-core.c
@@ -1316,7 +1316,7 @@ void ata_port_flush_task(struct ata_port
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	DPRINTK("flush #1\n");
-	flush_work(ata_wq, &ap->port_task.work); /* akpm: seems unneeded */
+	cancel_work_sync(&ap->port_task.work); /* akpm: seems unneeded */
 
 	/*
 	 * At this point, if a task is running, it's guaranteed to see
@@ -1327,7 +1327,7 @@ void ata_port_flush_task(struct ata_port
 		if (ata_msg_ctl(ap))
 			ata_port_printk(ap, KERN_DEBUG, "%s: flush #2\n",
 					__FUNCTION__);
-		flush_work(ata_wq, &ap->port_task.work);
+		cancel_work_sync(&ap->port_task.work);
 	}
 
 	spin_lock_irqsave(ap->lock, flags);
@@ -6475,9 +6475,9 @@ void ata_port_detach(struct ata_port *ap
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
@@ -1214,7 +1214,7 @@ e1000_remove(struct pci_dev *pdev)
 	int i;
 #endif
 
-	flush_work_keventd(&adapter->reset_task);
+	cancel_work_sync(&adapter->reset_task);
 
 	e1000_release_manageability(adapter);
 
diff -puN drivers/net/phy/phy.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync drivers/net/phy/phy.c
--- a/drivers/net/phy/phy.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync
+++ a/drivers/net/phy/phy.c
@@ -663,9 +663,9 @@ int phy_stop_interrupts(struct phy_devic
 
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
@@ -7386,7 +7386,7 @@ static int tg3_close(struct net_device *
 {
 	struct tg3 *tp = netdev_priv(dev);
 
-	flush_work_keventd(&tp->reset_task);
+	cancel_work_sync(&tp->reset_task);
 
 	netif_stop_queue(dev);
 
diff -puN fs/aio.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync fs/aio.c
--- a/fs/aio.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync
+++ a/fs/aio.c
@@ -348,7 +348,7 @@ void fastcall exit_aio(struct mm_struct 
 		/*
 		 * Ensure we don't leave the ctx on the aio_wq
 		 */
-		flush_work(aio_wq, &ctx->wq.work);
+		cancel_work_sync(&ctx->wq.work);
 
 		if (1 != atomic_read(&ctx->users))
 			printk(KERN_DEBUG
@@ -371,7 +371,7 @@ void fastcall __put_ioctx(struct kioctx 
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
@@ -128,30 +128,33 @@ extern struct workqueue_struct *__create
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
  * function may still be running on return from cancel_delayed_work(), unless
  * it returns 1 and the work doesn't re-arm itself. Run flush_workqueue() or
- * flush_work() or cancel_work_sync() to wait on it.
+ * cancel_work_sync() to wait on it.
  */
 static inline int cancel_delayed_work(struct delayed_work *work)
 {
diff -puN kernel/workqueue.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync kernel/workqueue.c
--- a/kernel/workqueue.c~unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync
+++ a/kernel/workqueue.c
@@ -413,23 +413,23 @@ static void wait_on_work(struct cpu_work
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
@@ -448,10 +448,13 @@ void flush_work(struct workqueue_struct 
 	work_clear_pending(work);
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
@@ -540,18 +543,13 @@ void flush_scheduled_work(void)
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
