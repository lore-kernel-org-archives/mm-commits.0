From: akpm@linux-foundation.org
Subject: - cciss-add-reboot-notifier-support-to-driver.patch removed from -mm tree
Date: Wed, 21 Feb 2007 19:35:40 -0800
Message-ID: <200702220335.l1M3Zeec003369@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35705 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbXBVDi4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 22:38:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikem@beardog.cca.cpqcorp.net, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: add reboot notifier support to driver
has been removed from the -mm tree.  Its filename was
     cciss-add-reboot-notifier-support-to-driver.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: cciss: add reboot notifier support to driver
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>

This patch adds reboot_notifier support to cciss.  Changes in firmware make
this patch essential.  Without this patch there may be valid data left in the
controller's battery backed write cache (BBWC) on shutdown.  We found out the
hard way that the kernel does not call our cleanup routines on shutdown or
reboot.  It seems that only rmmod calls the cleanup.  Please consider this for
inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   42 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff -puN drivers/block/cciss.c~cciss-add-reboot-notifier-support-to-driver drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-add-reboot-notifier-support-to-driver
+++ a/drivers/block/cciss.c
@@ -45,6 +45,7 @@
 #include <linux/blkdev.h>
 #include <linux/genhd.h>
 #include <linux/completion.h>
+#include <linux/reboot.h>
 
 #define CCISS_DRIVER_VERSION(maj,min,submin) ((maj<<16)|(min<<8)|(submin))
 #define DRIVER_NAME "HP CISS Driver (v 3.6.14)"
@@ -132,6 +133,7 @@ static struct board_type products[] = {
 #define MAX_CTLR_ORIG 	8
 
 static ctlr_info_t *hba[MAX_CTLR];
+static int notify_count;
 
 static void do_cciss_request(request_queue_t *q);
 static irqreturn_t do_cciss_intr(int irq, void *dev_id);
@@ -142,6 +144,8 @@ static int cciss_ioctl(struct inode *ino
 static int cciss_getgeo(struct block_device *bdev, struct hd_geometry *geo);
 
 static int cciss_revalidate(struct gendisk *disk);
+static int cciss_notify_reboot(struct notifier_block *this,
+					unsigned long code, void *x);
 static int rebuild_lun_table(ctlr_info_t *h, struct gendisk *del_disk);
 static int deregister_disk(struct gendisk *disk, drive_info_struct *drv,
 			   int clear_all);
@@ -193,6 +197,36 @@ static struct block_device_operations cc
 	.revalidate_disk = cciss_revalidate,
 };
 
+static struct notifier_block cciss_notifier = {
+	.notifier_call  = cciss_notify_reboot,
+};
+
+static int cciss_notify_reboot(struct notifier_block *this,
+                            unsigned long code, void *x)
+{
+	int i, return_code;
+	char flush_buf[4];
+
+	if ((code == SYS_DOWN) || (code == SYS_HALT) ||
+					(code == SYS_POWER_OFF)) {
+		printk(KERN_INFO "cciss: stopping all cciss devices.\n");
+		/* double check that all controller entrys have been removed */
+		for (i = 0; i < MAX_CTLR; i++) {
+			if (hba[i] != NULL) {
+				printk(KERN_WARNING "cciss: removing "
+						"controller %d\n", i);
+				/* flush data in battery backed cache to disks */
+				memset(flush_buf, 0, 4);
+				return_code = sendcmd(CCISS_CACHE_FLUSH, i, flush_buf, 4, 								0, 0, 0, NULL, TYPE_CMD);
+				if(return_code != IO_OK) {
+					printk(KERN_WARNING "Error Flushing cache on "
+								" controller %d\n", i);
+				}
+			}
+		}
+	}
+	return NOTIFY_DONE;
+}
 /*
  * Enqueuing and dequeuing functions for cmdlists.
  */
@@ -3287,6 +3321,12 @@ static int __devinit cciss_init_one(stru
 	       ((hba[i]->nr_cmds + BITS_PER_LONG -
 		 1) / BITS_PER_LONG) * sizeof(unsigned long));
 
+	if (notify_count == 0) {
+		register_reboot_notifier(&cciss_notifier);
+		notify_count=1;
+	}
+
+
 #ifdef CCISS_DEBUG
 	printk(KERN_DEBUG "Scanning for drives on controller cciss%d\n", i);
 #endif				/* CCISS_DEBUG */
@@ -3494,6 +3534,8 @@ static void __exit cciss_cleanup(void)
 	int i;
 
 	pci_unregister_driver(&cciss_pci_driver);
+	if (notify_count)
+		unregister_reboot_notifier(&cciss_notifier);
 	/* double check that all controller entrys have been removed */
 	for (i = 0; i < MAX_CTLR; i++) {
 		if (hba[i] != NULL) {
_

Patches currently in -mm which might be from mikem@beardog.cca.cpqcorp.net are

cciss-fix-for-2tb-support.patch
cciss-add-reboot-notifier-support-to-driver.patch
