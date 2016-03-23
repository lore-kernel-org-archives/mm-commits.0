From: akpm@linux-foundation.org
Subject: [merged] rapidio-add-outbound-window-support.patch removed from
 -mm tree
Date: Wed, 23 Mar 2016 10:41:58 -0700
Message-ID: <56f2d566.8TIsmV8TsQIt48Uh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505AbcCWRl7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:41:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, leoli@freescale.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: add outbound window support
has been removed from the -mm tree.  Its filename was
     rapidio-add-outbound-window-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -400,6 +400,8 @@ struct rio_mport_attr {
  * @map_inb: Callback to map RapidIO address region into local memory space.
  * @unmap_inb: Callback to unmap RapidIO address region mapped with map_inb().
  * @query_mport: Callback to query mport device attributes.
+ * @map_outb: Callback to map outbound address region into local memory space.
+ * @unmap_outb: Callback to unmap outbound RapidIO address region.
  */
 struct rio_ops {
 	int (*lcread) (struct rio_mport *mport, int index, u32 offset, int len,
@@ -427,6 +429,9 @@ struct rio_ops {
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


