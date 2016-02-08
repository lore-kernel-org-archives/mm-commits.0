From: akpm@linux-foundation.org
Subject: + rapidio-move-rio_pw_enable-into-core-code.patch added to -mm
 tree
Date: Mon, 08 Feb 2016 13:22:34 -0800
Message-ID: <56b9071a.B3kx0RT5N1bl6kYp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35850 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbcBHVWf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 16:22:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: move rio_pw_enable into core code
has been added to the -mm tree.  Its filename is
     rapidio-move-rio_pw_enable-into-core-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-move-rio_pw_enable-into-core-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-move-rio_pw_enable-into-core-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: move rio_pw_enable into core code

Make rio_pw_enable() routine available to other RapidIO drivers.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |   11 -----------
 drivers/rapidio/rio.c      |   19 +++++++++++++++++++
 include/linux/rio.h        |    2 ++
 include/linux/rio_drv.h    |    1 +
 4 files changed, 22 insertions(+), 11 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-move-rio_pw_enable-into-core-code drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-move-rio_pw_enable-into-core-code
+++ a/drivers/rapidio/rio-scan.c
@@ -974,17 +974,6 @@ static void rio_init_em(struct rio_dev *
 }
 
 /**
- * rio_pw_enable - Enables/disables port-write handling by a master port
- * @port: Master port associated with port-write handling
- * @enable:  1=enable,  0=disable
- */
-static void rio_pw_enable(struct rio_mport *port, int enable)
-{
-	if (port->ops->pwenable)
-		port->ops->pwenable(port, enable);
-}
-
-/**
  * rio_enum_mport- Start enumeration through a master port
  * @mport: Master port to send transactions
  * @flags: Enumeration control flags
diff -puN drivers/rapidio/rio.c~rapidio-move-rio_pw_enable-into-core-code drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-move-rio_pw_enable-into-core-code
+++ a/drivers/rapidio/rio.c
@@ -560,6 +560,24 @@ int rio_release_inb_pwrite(struct rio_de
 EXPORT_SYMBOL_GPL(rio_release_inb_pwrite);
 
 /**
+ * rio_pw_enable - Enables/disables port-write handling by a master port
+ * @port: Master port associated with port-write handling
+ * @enable:  1=enable,  0=disable
+ */
+void rio_pw_enable(struct rio_mport *mport, int enable)
+{
+	if (mport->ops->pwenable) {
+		mutex_lock(&mport->lock);
+
+		if ((enable && ++mport->pwe_refcnt == 1) ||
+		    (!enable && mport->pwe_refcnt && --mport->pwe_refcnt == 0))
+			mport->ops->pwenable(mport, enable);
+		mutex_unlock(&mport->lock);
+	}
+}
+EXPORT_SYMBOL_GPL(rio_pw_enable);
+
+/**
  * rio_map_inb_region -- Map inbound memory region.
  * @mport: Master port.
  * @local: physical address of memory region to be mapped
@@ -2041,6 +2059,7 @@ int rio_mport_initialize(struct rio_mpor
 	mport->host_deviceid = rio_get_hdid(mport->id);
 	mport->nscan = NULL;
 	mutex_init(&mport->lock);
+	mport->pwe_refcnt = 0;
 
 	return 0;
 }
diff -puN include/linux/rio.h~rapidio-move-rio_pw_enable-into-core-code include/linux/rio.h
--- a/include/linux/rio.h~rapidio-move-rio_pw_enable-into-core-code
+++ a/include/linux/rio.h
@@ -266,6 +266,7 @@ enum rio_phy_type {
  * @dma: DMA device associated with mport
  * @nscan: RapidIO network enumeration/discovery operations
  * @state: mport device state
+ * @pwe_refcnt: port-write enable ref counter to track enable/disable requests
  */
 struct rio_mport {
 	struct list_head dbells;	/* list of doorbell events */
@@ -296,6 +297,7 @@ struct rio_mport {
 #endif
 	struct rio_scan *nscan;
 	atomic_t state;
+	unsigned int pwe_refcnt;
 };
 
 static inline int rio_mport_is_running(struct rio_mport *mport)
diff -puN include/linux/rio_drv.h~rapidio-move-rio_pw_enable-into-core-code include/linux/rio_drv.h
--- a/include/linux/rio_drv.h~rapidio-move-rio_pw_enable-into-core-code
+++ a/include/linux/rio_drv.h
@@ -375,6 +375,7 @@ extern int rio_request_inb_pwrite(struct
 			int (*)(struct rio_dev *, union rio_pw_msg*, int));
 extern int rio_release_inb_pwrite(struct rio_dev *);
 extern int rio_inb_pwrite_handler(union rio_pw_msg *pw_msg);
+extern void rio_pw_enable(struct rio_mport *mport, int enable);
 
 /* LDM support */
 int rio_register_driver(struct rio_driver *);
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

