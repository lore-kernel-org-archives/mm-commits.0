From: akpm@linux-foundation.org
Subject: [to-be-updated] cciss-use-only-one-scan-thread.patch removed from -mm tree
Date: Thu, 06 Aug 2009 16:27:43 -0700
Message-ID: <200908062327.n76NRh18010091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756262AbZHFX1u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2009 19:27:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrew.patterson@hp.com, jens.axboe@oracle.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: use only one scan thread
has been removed from the -mm tree.  Its filename was
     cciss-use-only-one-scan-thread.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: use only one scan thread
From: Andrew Patterson <andrew.patterson@hp.com>

Replace the use of one scan kthread per controller with one per driver. 
Use a queue to hold a list of controllers that need to be rescanned with
routines to add and remove controllers from the queue.

Fix locking and completion handling to prevent a hang during rmmod.

Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |  156 +++++++++++++++++++++++++++++++++++-----
 drivers/block/cciss.h |    7 +
 2 files changed, 142 insertions(+), 21 deletions(-)

diff -puN drivers/block/cciss.c~cciss-use-only-one-scan-thread drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-use-only-one-scan-thread
+++ a/drivers/block/cciss.c
@@ -39,6 +39,7 @@
 #include <linux/hdreg.h>
 #include <linux/spinlock.h>
 #include <linux/compat.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
@@ -155,6 +156,10 @@ static struct board_type products[] = {
 
 static ctlr_info_t *hba[MAX_CTLR];
 
+static struct task_struct *cciss_scan_thread;
+static DEFINE_MUTEX(scan_mutex);
+static LIST_HEAD(scan_q);
+
 static void do_cciss_request(struct request_queue *q);
 static irqreturn_t do_cciss_intr(int irq, void *dev_id);
 static int cciss_open(struct block_device *bdev, fmode_t mode);
@@ -3232,20 +3237,121 @@ static irqreturn_t do_cciss_intr(int irq
 	return IRQ_HANDLED;
 }
 
+/**
+ * add_to_scan_list() - add controller to rescan queue
+ * @h:		      Pointer to the controller.
+ *
+ * Adds the controller to the rescan queue if not already on the queue.
+ *
+ * returns 1 if added to the queue, 0 if skipped (could be on the
+ * queue already, or the controller could be initializing or shutting
+ * down).
+ **/
+static int add_to_scan_list(struct ctlr_info *h)
+{
+	struct ctlr_info *test_h;
+	int found = 0;
+	int ret = 0;
+
+	if (mutex_is_locked(&h->busy_initializing))
+		return 0;
+
+	if (!mutex_trylock(&h->busy_shutting_down))
+		return 0;
+
+	mutex_lock(&scan_mutex);
+	list_for_each_entry(test_h, &scan_q, scan_list) {
+		if (test_h == h) {
+			found = 1;
+			break;
+		}
+	}
+	if (!found && !h->busy_scanning) {
+		INIT_COMPLETION(h->scan_wait);
+		list_add_tail(&h->scan_list, &scan_q);
+		ret = 1;
+	}
+	mutex_unlock(&scan_mutex);
+	mutex_unlock(&h->busy_shutting_down);
+
+	return ret;
+}
+
+/**
+ * remove_from_scan_list() - remove controller from rescan queue
+ * @h:			   Pointer to the controller.
+ *
+ * Removes the controller from the rescan queue if present. Blocks if
+ * the controller is currently conducting a rescan.
+ **/
+static void remove_from_scan_list(struct ctlr_info *h)
+{
+	struct ctlr_info *test_h, *tmp_h;
+	int scanning = 0;
+
+	mutex_lock(&scan_mutex);
+	list_for_each_entry_safe(test_h, tmp_h, &scan_q, scan_list) {
+		if (test_h == h) {
+			list_del(&h->scan_list);
+			complete_all(&h->scan_wait);
+			mutex_unlock(&scan_mutex);
+			return;
+		}
+	}
+	if (&h->busy_scanning)
+		scanning = 0;
+	mutex_unlock(&scan_mutex);
+
+	if (scanning)
+		wait_for_completion(&h->scan_wait);
+}
+
+/**
+ * scan_thread() - kernel thread used to rescan controllers
+ * @data:	 Ignored.
+ *
+ * A kernel thread used scan for drive topology changes on
+ * controllers. The thread processes only one controller at a time
+ * using a queue.  Controllers are added to the queue using
+ * add_to_scan_list() and removed from the queue either after done
+ * processing or using remove_from_scan_list().
+ *
+ * returns 0.
+ **/
 static int scan_thread(void *data)
 {
-	ctlr_info_t *h = data;
-	int rc;
-	DECLARE_COMPLETION_ONSTACK(wait);
-	h->rescan_wait = &wait;
+	struct ctlr_info *h;
 
-	for (;;) {
-		rc = wait_for_completion_interruptible(&wait);
+	while (1) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule();
 		if (kthread_should_stop())
 			break;
-		if (!rc)
-			rebuild_lun_table(h, 0);
+
+		while (1) {
+			mutex_lock(&scan_mutex);
+			if (list_empty(&scan_q)) {
+				mutex_unlock(&scan_mutex);
+				break;
+			}
+
+			h = list_entry(scan_q.next,
+				       struct ctlr_info,
+				       scan_list);
+			list_del(&h->scan_list);
+			h->busy_scanning = 1;
+			mutex_unlock(&scan_mutex);
+
+			if (h) {
+				rebuild_lun_table(h, 0);
+				complete_all(&h->scan_wait);
+				mutex_lock(&scan_mutex);
+				h->busy_scanning = 0;
+				mutex_unlock(&scan_mutex);
+			}
+		}
 	}
+
 	return 0;
 }
 
@@ -3268,8 +3374,8 @@ static int check_for_unit_attention(ctlr
 	case REPORT_LUNS_CHANGED:
 		printk(KERN_WARNING "cciss%d: report LUN data "
 			"changed\n", h->ctlr);
-		if (h->rescan_wait)
-			complete(h->rescan_wait);
+		add_to_scan_list(h);
+		wake_up_process(cciss_scan_thread);
 		return 1;
 	break;
 	case POWER_OR_RESET:
@@ -3919,6 +4025,7 @@ static int __devinit cciss_init_one(stru
 	mutex_lock(&hba[i]->busy_initializing);
 	INIT_HLIST_HEAD(&hba[i]->cmpQ);
 	INIT_HLIST_HEAD(&hba[i]->reqQ);
+	mutex_init(&hba[i]->busy_shutting_down);
 
 	if (cciss_pci_init(hba[i], pdev) != 0)
 		goto clean0;
@@ -3927,6 +4034,8 @@ static int __devinit cciss_init_one(stru
 	hba[i]->ctlr = i;
 	hba[i]->pdev = pdev;
 
+	init_completion(&hba[i]->scan_wait);
+
 	if (cciss_create_hba_sysfs_entry(hba[i]))
 		goto clean0;
 
@@ -4035,13 +4144,9 @@ static int __devinit cciss_init_one(stru
 
 	hba[i]->cciss_max_sectors = 2048;
 
-	mutex_unlock(&hba[i]->busy_initializing);
-
 	rebuild_lun_table(hba[i], 1);
-	hba[i]->cciss_scan_thread = kthread_run(scan_thread, hba[i],
-				"cciss_scan%02d", i);
-	if (IS_ERR(hba[i]->cciss_scan_thread))
-		return PTR_ERR(hba[i]->cciss_scan_thread);
+
+	mutex_unlock(&hba[i]->busy_initializing);
 
 	return 1;
 
@@ -4126,8 +4231,9 @@ static void __devexit cciss_remove_one(s
 		return;
 	}
 
-	kthread_stop(hba[i]->cciss_scan_thread);
+	mutex_lock(&hba[i]->busy_shutting_down);
 
+	remove_from_scan_list(hba[i]);
 	remove_proc_entry(hba[i]->devname, proc_cciss);
 	unregister_blkdev(hba[i]->major, hba[i]->devname);
 
@@ -4174,6 +4280,7 @@ static void __devexit cciss_remove_one(s
 	pci_release_regions(pdev);
 	pci_set_drvdata(pdev, NULL);
 	cciss_destroy_hba_sysfs_entry(hba[i]);
+	mutex_unlock(&hba[i]->busy_shutting_down);
 	free_hba(i);
 }
 
@@ -4206,15 +4313,25 @@ static int __init cciss_init(void)
 	if (err)
 		return err;
 
+	/* Start the scan thread */
+	cciss_scan_thread = kthread_run(scan_thread, NULL, "cciss_scan");
+	if (IS_ERR(cciss_scan_thread)) {
+		err = PTR_ERR(cciss_scan_thread);
+		goto err_bus_unregister;
+	}
+
 	/* Register for our PCI devices */
 	err = pci_register_driver(&cciss_pci_driver);
 	if (err)
-		goto err_bus_register;
+		goto err_thread_stop;
 
 	return 0;
 
-err_bus_register:
+err_thread_stop:
+	kthread_stop(cciss_scan_thread);
+err_bus_unregister:
 	bus_unregister(&cciss_bus_type);
+
 	return err;
 }
 
@@ -4231,6 +4348,7 @@ static void __exit cciss_cleanup(void)
 			cciss_remove_one(hba[i]->pdev);
 		}
 	}
+	kthread_stop(cciss_scan_thread);
 	remove_proc_entry("driver/cciss", NULL);
 	bus_unregister(&cciss_bus_type);
 }
diff -puN drivers/block/cciss.h~cciss-use-only-one-scan-thread drivers/block/cciss.h
--- a/drivers/block/cciss.h~cciss-use-only-one-scan-thread
+++ a/drivers/block/cciss.h
@@ -2,6 +2,7 @@
 #define CCISS_H
 
 #include <linux/genhd.h>
+#include <linux/mutex.h>
 
 #include "cciss_cmd.h"
 
@@ -108,6 +109,8 @@ struct ctlr_info 
 	int			nr_frees; 
 	int			busy_configuring;
 	struct mutex		busy_initializing;
+	int			busy_scanning;
+	struct mutex   		busy_shutting_down;
 
 	/* This element holds the zero based queue number of the last
 	 * queue to be started.  It is used for fairness.
@@ -122,8 +125,8 @@ struct ctlr_info 
 	/* and saved for later processing */
 #endif
 	unsigned char alive;
-	struct completion *rescan_wait;
-	struct task_struct *cciss_scan_thread;
+	struct list_head scan_list;
+	struct completion scan_wait;
 	struct device dev;
 };
 
_

Patches currently in -mm which might be from andrew.patterson@hp.com are

origin.patch
cciss-use-only-one-scan-thread.patch
cciss-kick-off-logical-drive-topology-rescan-through-sysfs.patch

