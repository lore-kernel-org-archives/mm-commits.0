From: akpm@linux-foundation.org
Subject: +
 rapidio-move-rio_local_set_device_id-function-to-the-common-core.patch
 added to -mm tree
Date: Mon, 08 Feb 2016 13:22:32 -0800
Message-ID: <56b90718.KLnpRXKXQLewH46H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35843 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345AbcBHVWd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 16:22:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: move rio_local_set_device_id function to the common core
has been added to the -mm tree.  Its filename is
     rapidio-move-rio_local_set_device_id-function-to-the-common-core.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-move-rio_local_set_device_id-function-to-the-common-core.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-move-rio_local_set_device_id-function-to-the-common-core.patch

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
Subject: rapidio: move rio_local_set_device_id function to the common core

Make function rio_local_set_device_id() common for all components of
RapidIO subsystem.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |   13 -------------
 drivers/rapidio/rio.c      |   14 ++++++++++++++
 include/linux/rio_drv.h    |    1 +
 3 files changed, 15 insertions(+), 13 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-move-rio_local_set_device_id-function-to-the-common-core drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-move-rio_local_set_device_id-function-to-the-common-core
+++ a/drivers/rapidio/rio-scan.c
@@ -194,19 +194,6 @@ static void rio_set_device_id(struct rio
 }
 
 /**
- * rio_local_set_device_id - Set the base/extended device id for a port
- * @port: RIO master port
- * @did: Device ID value to be written
- *
- * Writes the base/extended device id from a device.
- */
-static void rio_local_set_device_id(struct rio_mport *port, u16 did)
-{
-	rio_local_write_config_32(port, RIO_DID_CSR, RIO_SET_DID(port->sys_size,
-				did));
-}
-
-/**
  * rio_clear_locks- Release all host locks and signal enumeration complete
  * @net: RIO network to run on
  *
diff -puN drivers/rapidio/rio.c~rapidio-move-rio_local_set_device_id-function-to-the-common-core drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-move-rio_local_set_device_id-function-to-the-common-core
+++ a/drivers/rapidio/rio.c
@@ -138,6 +138,20 @@ void rio_free_net(struct rio_net *net)
 EXPORT_SYMBOL_GPL(rio_free_net);
 
 /**
+ * rio_local_set_device_id - Set the base/extended device id for a port
+ * @port: RIO master port
+ * @did: Device ID value to be written
+ *
+ * Writes the base/extended device id from a device.
+ */
+void rio_local_set_device_id(struct rio_mport *port, u16 did)
+{
+	rio_local_write_config_32(port, RIO_DID_CSR,
+				  RIO_SET_DID(port->sys_size, did));
+}
+EXPORT_SYMBOL_GPL(rio_local_set_device_id);
+
+/**
  * rio_add_device- Adds a RIO device to the device model
  * @rdev: RIO device
  *
diff -puN include/linux/rio_drv.h~rapidio-move-rio_local_set_device_id-function-to-the-common-core include/linux/rio_drv.h
--- a/include/linux/rio_drv.h~rapidio-move-rio_local_set_device_id-function-to-the-common-core
+++ a/include/linux/rio_drv.h
@@ -435,6 +435,7 @@ static inline void rio_set_drvdata(struc
 
 /* Misc driver helpers */
 extern u16 rio_local_get_device_id(struct rio_mport *port);
+extern void rio_local_set_device_id(struct rio_mport *port, u16 did);
 extern struct rio_dev *rio_get_device(u16 vid, u16 did, struct rio_dev *from);
 extern struct rio_dev *rio_get_asm(u16 vid, u16 did, u16 asm_vid, u16 asm_did,
 				   struct rio_dev *from);
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

