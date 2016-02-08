From: akpm@linux-foundation.org
Subject: + rapidio-add-outbound-window-support.patch added to -mm tree
Date: Mon, 08 Feb 2016 13:22:42 -0800
Message-ID: <56b90722.9YYJPeozM5AG7dCw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377AbcBHVWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 16:22:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, leoli@freescale.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: add outbound window support
has been added to the -mm tree.  Its filename is
     rapidio-add-outbound-window-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-add-outbound-window-support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-add-outbound-window-support.patch

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
Subject: rapidio: add outbound window support

Add RapidIO controller (mport) outbound window configuration operations.
  This patch is a part of the original patch submitted by Li Yang
  (https://lists.ozlabs.org/pipermail/linuxppc-dev/2009-April/071210.html).
  For some reason the original part was not applied to mainline code
  tree.  The inbound window mapping part has been applied later during
  tsi721 mport driver submission.  Now goes the second part with
  corresponding HW support.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c   |   50 ++++++++++++++++++++++++++++++++++++++
 include/linux/rio.h     |    5 +++
 include/linux/rio_drv.h |    4 +++
 3 files changed, 59 insertions(+)

diff -puN drivers/rapidio/rio.c~rapidio-add-outbound-window-support drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-add-outbound-window-support
+++ a/drivers/rapidio/rio.c
@@ -700,6 +700,56 @@ void rio_unmap_inb_region(struct rio_mpo
 EXPORT_SYMBOL_GPL(rio_unmap_inb_region);
 
 /**
+ * rio_map_outb_region -- Map outbound memory region.
+ * @mport: Master port.
+ * @destid: destination id window points to
+ * @rbase: RIO base address window translates to
+ * @size: Size of the memory region
+ * @rflags: Flags for mapping.
+ * @local: physical address of memory region mapped
+ *
+ * Return: 0 -- Success.
+ *
+ * This function will create the mapping from RIO space to local memory.
+ */
+int rio_map_outb_region(struct rio_mport *mport, u16 destid, u64 rbase,
+			u32 size, u32 rflags, dma_addr_t *local)
+{
+	int rc = 0;
+	unsigned long flags;
+
+	if (!mport->ops->map_outb)
+		return -ENODEV;
+
+	spin_lock_irqsave(&rio_mmap_lock, flags);
+	rc = mport->ops->map_outb(mport, destid, rbase, size,
+		rflags, local);
+	spin_unlock_irqrestore(&rio_mmap_lock, flags);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(rio_map_outb_region);
+
+/**
+ * rio_unmap_inb_region -- Unmap the inbound memory region
+ * @mport: Master port
+ * @destid: destination id mapping points to
+ * @rstart: RIO base address window translates to
+ */
+void rio_unmap_outb_region(struct rio_mport *mport, u16 destid, u64 rstart)
+{
+	unsigned long flags;
+
+	if (!mport->ops->unmap_outb)
+		return;
+
+	spin_lock_irqsave(&rio_mmap_lock, flags);
+	mport->ops->unmap_outb(mport, destid, rstart);
+	spin_unlock_irqrestore(&rio_mmap_lock, flags);
+}
+EXPORT_SYMBOL_GPL(rio_unmap_outb_region);
+
+/**
  * rio_mport_get_physefb - Helper function that returns register offset
  *                      for Physical Layer Extended Features Block.
  * @port: Master port to issue transaction
diff -puN include/linux/rio.h~rapidio-add-outbound-window-support include/linux/rio.h
--- a/include/linux/rio.h~rapidio-add-outbound-window-support
+++ a/include/linux/rio.h
@@ -399,6 +399,8 @@ struct rio_mport_attr {
  * @map_inb: Callback to map RapidIO address region into local memory space.
  * @unmap_inb: Callback to unmap RapidIO address region mapped with map_inb().
  * @query_mport: Callback to query mport device attributes.
+ * @map_outb: Callback to map outbound address region into local memory space.
+ * @unmap_outb: Callback to unmap outbound RapidIO address region.
  */
 struct rio_ops {
 	int (*lcread) (struct rio_mport *mport, int index, u32 offset, int len,
@@ -426,6 +428,9 @@ struct rio_ops {
 	void (*unmap_inb)(struct rio_mport *mport, dma_addr_t lstart);
 	int (*query_mport)(struct rio_mport *mport,
 			   struct rio_mport_attr *attr);
+	int (*map_outb)(struct rio_mport *mport, u16 destid, u64 rstart,
+			u32 size, u32 flags, dma_addr_t *laddr);
+	void (*unmap_outb)(struct rio_mport *mport, u16 destid, u64 rstart);
 };
 
 #define RIO_RESOURCE_MEM	0x00000100
diff -puN include/linux/rio_drv.h~rapidio-add-outbound-window-support include/linux/rio_drv.h
--- a/include/linux/rio_drv.h~rapidio-add-outbound-window-support
+++ a/include/linux/rio_drv.h
@@ -369,6 +369,10 @@ void rio_release_region(struct rio_dev *
 extern int rio_map_inb_region(struct rio_mport *mport, dma_addr_t local,
 			u64 rbase, u32 size, u32 rflags);
 extern void rio_unmap_inb_region(struct rio_mport *mport, dma_addr_t lstart);
+extern int rio_map_outb_region(struct rio_mport *mport, u16 destid, u64 rbase,
+			u32 size, u32 rflags, dma_addr_t *local);
+extern void rio_unmap_outb_region(struct rio_mport *mport,
+				  u16 destid, u64 rstart);
 
 /* Port-Write management */
 extern int rio_request_inb_pwrite(struct rio_dev *,
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

