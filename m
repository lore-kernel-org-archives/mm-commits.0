From: akpm@linux-foundation.org
Subject: + rapidio-rework-common-rio-device-add-delete-routines.patch
 added to -mm tree
Date: Mon, 08 Feb 2016 13:22:16 -0800
Message-ID: <56b90708.ozVkLE1PAYfxu3F4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282AbcBHVWR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 16:22:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: rework common RIO device add/delete routines
has been added to the -mm tree.  Its filename is
     rapidio-rework-common-rio-device-add-delete-routines.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-rework-common-rio-device-add-delete-routines.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-rework-common-rio-device-add-delete-routines.patch

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
Subject: rapidio: rework common RIO device add/delete routines

This patch moves per-net device list handling from rio-scan to common
RapidIO core and adds a matching device deletion routine. This makes
device object creation/removal available to other implementations of
enumeration/discovery process.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |   13 ++-----------
 drivers/rapidio/rio.c      |   33 ++++++++++++++++++++++++++++++++-
 drivers/rapidio/rio.h      |    2 ++
 3 files changed, 36 insertions(+), 12 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-rework-common-rio-device-add-delete-routines drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-rework-common-rio-device-add-delete-routines
+++ a/drivers/rapidio/rio-scan.c
@@ -449,9 +449,6 @@ static struct rio_dev *rio_setup_device(
 
 		if (do_enum)
 			rio_route_clr_table(rdev, RIO_GLOBAL_TABLE, 0);
-
-		list_add_tail(&rswitch->node, &net->switches);
-
 	} else {
 		if (do_enum)
 			/*Enable Input Output Port (transmitter reviever)*/
@@ -463,11 +460,7 @@ static struct rio_dev *rio_setup_device(
 
 	rdev->dev.parent = &port->dev;
 	rio_attach_device(rdev);
-
-	device_initialize(&rdev->dev);
 	rdev->dev.release = rio_release_dev;
-	rio_dev_get(rdev);
-
 	rdev->dma_mask = DMA_BIT_MASK(32);
 	rdev->dev.dma_mask = &rdev->dma_mask;
 	rdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
@@ -480,6 +473,8 @@ static struct rio_dev *rio_setup_device(
 	if (ret)
 		goto cleanup;
 
+	rio_dev_get(rdev);
+
 	return rdev;
 
 cleanup:
@@ -621,8 +616,6 @@ static int rio_enum_peer(struct rio_net
 	rdev = rio_setup_device(net, port, RIO_ANY_DESTID(port->sys_size),
 					hopcount, 1);
 	if (rdev) {
-		/* Add device to the global and bus/net specific list. */
-		list_add_tail(&rdev->net_list, &net->devices);
 		rdev->prev = prev;
 		if (prev && rio_is_switch(prev))
 			prev->rswitch->nextdev[prev_port] = rdev;
@@ -778,8 +771,6 @@ rio_disc_peer(struct rio_net *net, struc
 
 	/* Setup new RIO device */
 	if ((rdev = rio_setup_device(net, port, destid, hopcount, 0))) {
-		/* Add device to the global and bus/net specific list. */
-		list_add_tail(&rdev->net_list, &net->devices);
 		rdev->prev = prev;
 		if (prev && rio_is_switch(prev))
 			prev->rswitch->nextdev[prev_port] = rdev;
diff -puN drivers/rapidio/rio.c~rapidio-rework-common-rio-device-add-delete-routines drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-rework-common-rio-device-add-delete-routines
+++ a/drivers/rapidio/rio.c
@@ -96,12 +96,18 @@ int rio_add_device(struct rio_dev *rdev)
 {
 	int err;
 
-	err = device_add(&rdev->dev);
+	err = device_register(&rdev->dev);
 	if (err)
 		return err;
 
 	spin_lock(&rio_global_list_lock);
 	list_add_tail(&rdev->global_list, &rio_devices);
+	if (rdev->net) {
+		list_add_tail(&rdev->net_list, &rdev->net->devices);
+		if (rdev->pef & RIO_PEF_SWITCH)
+			list_add_tail(&rdev->rswitch->node,
+				      &rdev->net->switches);
+	}
 	spin_unlock(&rio_global_list_lock);
 
 	rio_create_sysfs_dev_files(rdev);
@@ -110,6 +116,31 @@ int rio_add_device(struct rio_dev *rdev)
 }
 EXPORT_SYMBOL_GPL(rio_add_device);
 
+/*
+ * rio_del_device - removes a RIO device from the device model
+ * @rdev: RIO device
+ *
+ * Removes the RIO device to the kernel device list and subsystem's device list.
+ * Clears sysfs entries for the removed device.
+ */
+void rio_del_device(struct rio_dev *rdev)
+{
+	pr_debug("RIO: %s: removing %s\n", __func__, rio_name(rdev));
+	spin_lock(&rio_global_list_lock);
+	list_del(&rdev->global_list);
+	if (rdev->net) {
+		list_del(&rdev->net_list);
+		if (rdev->pef & RIO_PEF_SWITCH) {
+			list_del(&rdev->rswitch->node);
+			kfree(rdev->rswitch->route_table);
+		}
+	}
+	spin_unlock(&rio_global_list_lock);
+	rio_remove_sysfs_dev_files(rdev);
+	device_unregister(&rdev->dev);
+}
+EXPORT_SYMBOL_GPL(rio_del_device);
+
 /**
  * rio_request_inb_mbox - request inbound mailbox service
  * @mport: RIO master port from which to allocate the mailbox resource
diff -puN drivers/rapidio/rio.h~rapidio-rework-common-rio-device-add-delete-routines drivers/rapidio/rio.h
--- a/drivers/rapidio/rio.h~rapidio-rework-common-rio-device-add-delete-routines
+++ a/drivers/rapidio/rio.h
@@ -28,6 +28,7 @@ extern u32 rio_mport_get_efb(struct rio_
 extern int rio_mport_chk_dev_access(struct rio_mport *mport, u16 destid,
 				    u8 hopcount);
 extern int rio_create_sysfs_dev_files(struct rio_dev *rdev);
+extern void rio_remove_sysfs_dev_files(struct rio_dev *rdev);
 extern int rio_lock_device(struct rio_mport *port, u16 destid,
 			u8 hopcount, int wait_ms);
 extern int rio_unlock_device(struct rio_mport *port, u16 destid, u8 hopcount);
@@ -39,6 +40,7 @@ extern int rio_route_clr_table(struct ri
 extern int rio_set_port_lockout(struct rio_dev *rdev, u32 pnum, int lock);
 extern struct rio_dev *rio_get_comptag(u32 comp_tag, struct rio_dev *from);
 extern int rio_add_device(struct rio_dev *rdev);
+extern void rio_del_device(struct rio_dev *rdev);
 extern int rio_enable_rx_tx_port(struct rio_mport *port, int local, u16 destid,
 				 u8 hopcount, u8 port_num);
 extern int rio_register_scan(int mport_id, struct rio_scan *scan_ops);
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

