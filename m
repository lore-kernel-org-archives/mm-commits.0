From: akpm@linux-foundation.org
Subject: [folded-merged] rapidio-add-mport-char-device-driver-fix-3.patch
 removed from -mm tree
Date: Tue, 22 Mar 2016 13:56:28 -0700
Message-ID: <56f1b17c.Vcexs/wWOa2Ss1y9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbcCVU43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2016 16:56:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, mporter@kernel.crashing.org, rdunlap@infradead.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/rio_mport_cdev: fix build failure if CONFIG_DMA_ENGINE is not enabled
has been removed from the -mm tree.  Its filename was
     rapidio-add-mport-char-device-driver-fix-3.patch

This patch was dropped because it was folded into rapidio-add-mport-char-device-driver.patch

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/rio_mport_cdev: fix build failure if CONFIG_DMA_ENGINE is not enabled

Fix the driver build failure if CONFIG_DMA_ENGINE option is not enabled
This patch is applicable to linux-next tree.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff -puN drivers/rapidio/devices/rio_mport_cdev.c~rapidio-add-mport-char-device-driver-fix-3 drivers/rapidio/devices/rio_mport_cdev.c
--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-add-mport-char-device-driver-fix-3
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1133,7 +1133,7 @@ static int rio_mport_transfer_ioctl(stru
 	return -ENODEV;
 }
 
-static int rio_mport_wait_for_async_dma(struct file *filp, int32_t arg)
+static int rio_mport_wait_for_async_dma(struct file *filp, void __user *arg)
 {
 	return -ENODEV;
 }
@@ -1227,6 +1227,16 @@ static int rio_mport_free_dma(struct fil
 
 	return 0;
 }
+#else
+static int rio_mport_alloc_dma(struct file *filp, void __user *arg)
+{
+	return -ENODEV;
+}
+
+static int rio_mport_free_dma(struct file *filp, void __user *arg)
+{
+	return -ENODEV;
+}
 
 #endif /* CONFIG_RAPIDIO_DMA_ENGINE */
 
@@ -1935,10 +1945,7 @@ static int mport_cdev_open(struct inode
 
 	INIT_LIST_HEAD(&priv->db_filters);
 	INIT_LIST_HEAD(&priv->pw_filters);
-	INIT_LIST_HEAD(&priv->async_list);
-	INIT_LIST_HEAD(&priv->pend_list);
 	spin_lock_init(&priv->fifo_lock);
-	spin_lock_init(&priv->req_lock);
 	init_waitqueue_head(&priv->event_rx_wait);
 	ret = kfifo_alloc(&priv->event_fifo,
 			  sizeof(struct rio_event) * MPORT_EVENT_DEPTH,
@@ -1950,6 +1957,9 @@ static int mport_cdev_open(struct inode
 	}
 
 #ifdef CONFIG_DMA_ENGINE
+	INIT_LIST_HEAD(&priv->async_list);
+	INIT_LIST_HEAD(&priv->pend_list);
+	spin_lock_init(&priv->req_lock);
 	mutex_init(&priv->dma_lock);
 #endif
 
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
rapidio-add-mport-char-device-driver-fix-4.patch

