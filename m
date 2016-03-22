From: akpm@linux-foundation.org
Subject: [folded-merged] rapidio-add-mport-char-device-driver-fix-4.patch
 removed from -mm tree
Date: Tue, 22 Mar 2016 13:56:31 -0700
Message-ID: <56f1b17f.bi+74NhjcFRdyNgs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59428 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbcCVU4c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2016 16:56:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, mporter@kernel.crashing.org, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/rio_mport_cdev: fix conflicting DMA configuration options
has been removed from the -mm tree.  Its filename was
     rapidio-add-mport-char-device-driver-fix-4.patch

This patch was dropped because it was folded into rapidio-add-mport-char-device-driver.patch

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/rio_mport_cdev: fix conflicting DMA configuration options

Fix to ensure that only CONFIG_RAPIDIO_DMA_ENGINE option is used to control
DMA code build.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |   32 +++++++++------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff -puN drivers/rapidio/devices/rio_mport_cdev.c~rapidio-add-mport-char-device-driver-fix-4 drivers/rapidio/devices/rio_mport_cdev.c
--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-add-mport-char-device-driver-fix-4
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -178,7 +178,7 @@ struct mport_dev {
 	struct list_head		portwrites;
 	spinlock_t			pw_lock;
 	struct list_head	mappings;
-#ifdef CONFIG_DMA_ENGINE
+#ifdef CONFIG_RAPIDIO_DMA_ENGINE
 	struct dma_chan *dma_chan;
 	struct kref	dma_ref;
 	struct completion comp;
@@ -209,7 +209,7 @@ struct mport_cdev_priv {
 	wait_queue_head_t       event_rx_wait;
 	spinlock_t              fifo_lock;
 	unsigned int            event_mask; /* RIO_DOORBELL, RIO_PORTWRITE */
-#ifdef CONFIG_DMA_ENGINE
+#ifdef CONFIG_RAPIDIO_DMA_ENGINE
 	struct dma_chan		*dmach;
 	struct list_head	async_list;
 	struct list_head	pend_list;
@@ -532,7 +532,7 @@ static int maint_comptag_set(struct mpor
 	return 0;
 }
 
-#ifdef CONFIG_DMA_ENGINE
+#ifdef CONFIG_RAPIDIO_DMA_ENGINE
 
 struct mport_dma_req {
 	struct list_head node;
@@ -1127,19 +1127,6 @@ err_tmo:
 	spin_unlock(&priv->req_lock);
 	return ret;
 }
-#else /* CONFIG_DMA_ENGINE */
-static int rio_mport_transfer_ioctl(struct file *filp, void *arg)
-{
-	return -ENODEV;
-}
-
-static int rio_mport_wait_for_async_dma(struct file *filp, void __user *arg)
-{
-	return -ENODEV;
-}
-#endif /* CONFIG_DMA_ENGINE */
-
-#ifdef CONFIG_RAPIDIO_DMA_ENGINE
 
 static int rio_mport_create_dma_mapping(struct mport_dev *md, struct file *filp,
 			uint64_t size, struct rio_mport_mapping **mapping)
@@ -1228,6 +1215,16 @@ static int rio_mport_free_dma(struct fil
 	return 0;
 }
 #else
+static int rio_mport_transfer_ioctl(struct file *filp, void *arg)
+{
+	return -ENODEV;
+}
+
+static int rio_mport_wait_for_async_dma(struct file *filp, void __user *arg)
+{
+	return -ENODEV;
+}
+
 static int rio_mport_alloc_dma(struct file *filp, void __user *arg)
 {
 	return -ENODEV;
@@ -1237,7 +1234,6 @@ static int rio_mport_free_dma(struct fil
 {
 	return -ENODEV;
 }
-
 #endif /* CONFIG_RAPIDIO_DMA_ENGINE */
 
 /*
@@ -1956,7 +1952,7 @@ static int mport_cdev_open(struct inode
 		goto err_fifo;
 	}
 
-#ifdef CONFIG_DMA_ENGINE
+#ifdef CONFIG_RAPIDIO_DMA_ENGINE
 	INIT_LIST_HEAD(&priv->async_list);
 	INIT_LIST_HEAD(&priv->pend_list);
 	spin_lock_init(&priv->req_lock);
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-tsi721-fix-hardcoded-mrrs-setting.patch
rapidio-tsi721-add-check-for-overlapped-ib-window-mappings.patch
rapidio-tsi721-add-option-to-configure-direct-mapping-of-ib-window.patch
rapidio-tsi721_dma-fix-pending-transaction-queue-handling.patch
rapidio-add-query_mport-operation.patch
rapidio-tsi721-add-query_mport-callback.patch
rapidio-add-shutdown-notification-for-rapidio-devices.patch
rapidio-tsi721-add-shutdown-notification-callback.patch
rapidio-rionet-add-shutdown-event-handling.patch
rapidio-rework-common-rio-device-add-delete-routines.patch
rapidio-move-net-allocation-into-core-code.patch
rapidio-add-core-mport-removal-support.patch
rapidio-tsi721-add-hw-specific-mport-removal.patch
powerpc-fsl_rio-changes-to-mport-registration.patch
rapidio-rionet-add-locking-into-add-remove-device.patch
rapidio-rionet-add-mport-removal-handling.patch
rapidio-add-lock-protection-for-doorbell-list.patch
rapidio-move-rio_local_set_device_id-function-to-the-common-core.patch
rapidio-move-rio_pw_enable-into-core-code.patch
rapidio-add-global-inbound-port-write-interfaces.patch
rapidio-tsi721-fix-locking-in-ob_msg-processing.patch
rapidio-add-outbound-window-support.patch
rapidio-tsi721-add-outbound-windows-mapping-support.patch
rapidio-tsi721-add-filtered-debug-output.patch
rapidio-tsi721_dma-update-error-reporting-from-prep_sg-callback.patch
rapidio-tsi721_dma-fix-synchronization-issues.patch
rapidio-tsi721_dma-fix-hardware-error-handling.patch
rapidio-add-mport-char-device-driver.patch

