From: akpm@linux-foundation.org
Subject: + rapidio-add-inbound-memory-mapping-interface.patch added to -mm tree
Date: Tue, 18 Sep 2012 14:41:01 -0700
Message-ID: <20120918214102.B58D85C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:44492 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab2IRVlG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 17:41:06 -0400
Received: by lbbge1 with SMTP id ge1so24689lbb.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 14:41:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, mporter@kernel.crashing.org


The patch titled
     Subject: rapidio: add inbound memory mapping interface
has been added to the -mm tree.  Its filename is
     rapidio-add-inbound-memory-mapping-interface.patch

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
Subject: rapidio: add inbound memory mapping interface

Add common inbound memory mapping/unmapping interface. This allows to make
local memory space accessible from the RapidIO side using hardware mapping
capabilities of RapidIO bridging devices. The new interface is intended to
enable data transfers between RapidIO devices in combination with DMA engine
support.

This patch is based on patch submitted by Li Yang <leoli@freescale.com>
(https://lists.ozlabs.org/pipermail/linuxppc-dev/2009-April/071210.html)

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c   |   44 ++++++++++++++++++++++++++++++++++++++
 include/linux/rio.h     |    5 ++++
 include/linux/rio_drv.h |    5 ++++
 3 files changed, 54 insertions(+)

diff -puN drivers/rapidio/rio.c~rapidio-add-inbound-memory-mapping-interface drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-add-inbound-memory-mapping-interface
+++ a/drivers/rapidio/rio.c
@@ -33,6 +33,7 @@
 
 static LIST_HEAD(rio_mports);
 static unsigned char next_portid;
+static DEFINE_SPINLOCK(rio_mmap_lock);
 
 /**
  * rio_local_get_device_id - Get the base/extended device id for a port
@@ -398,6 +399,49 @@ int rio_release_inb_pwrite(struct rio_de
 EXPORT_SYMBOL_GPL(rio_release_inb_pwrite);
 
 /**
+ * rio_map_inb_region -- Map inbound memory region.
+ * @mport: Master port.
+ * @lstart: physical address of memory region to be mapped
+ * @rbase: RIO base address assigned to this window
+ * @size: Size of the memory region
+ * @rflags: Flags for mapping.
+ *
+ * Return: 0 -- Success.
+ *
+ * This function will create the mapping from RIO space to local memory.
+ */
+int rio_map_inb_region(struct rio_mport *mport, dma_addr_t local,
+			u64 rbase, u32 size, u32 rflags)
+{
+	int rc = 0;
+	unsigned long flags;
+
+	if (!mport->ops->map_inb)
+		return -1;
+	spin_lock_irqsave(&rio_mmap_lock, flags);
+	rc = mport->ops->map_inb(mport, local, rbase, size, rflags);
+	spin_unlock_irqrestore(&rio_mmap_lock, flags);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(rio_map_inb_region);
+
+/**
+ * rio_unmap_inb_region -- Unmap the inbound memory region
+ * @mport: Master port
+ * @lstart: physical address of memory region to be unmapped
+ */
+void rio_unmap_inb_region(struct rio_mport *mport, dma_addr_t lstart)
+{
+	unsigned long flags;
+	if (!mport->ops->unmap_inb)
+		return;
+	spin_lock_irqsave(&rio_mmap_lock, flags);
+	mport->ops->unmap_inb(mport, lstart);
+	spin_unlock_irqrestore(&rio_mmap_lock, flags);
+}
+EXPORT_SYMBOL_GPL(rio_unmap_inb_region);
+
+/**
  * rio_mport_get_physefb - Helper function that returns register offset
  *                      for Physical Layer Extended Features Block.
  * @port: Master port to issue transaction
diff -puN include/linux/rio.h~rapidio-add-inbound-memory-mapping-interface include/linux/rio.h
--- a/include/linux/rio.h~rapidio-add-inbound-memory-mapping-interface
+++ a/include/linux/rio.h
@@ -301,6 +301,8 @@ struct rio_net {
  * @add_outb_message: Callback to add a message to an outbound mailbox queue.
  * @add_inb_buffer: Callback to	add a buffer to an inbound mailbox queue.
  * @get_inb_message: Callback to get a message from an inbound mailbox queue.
+ * @map_inb: Callback to map RapidIO address region into local memory space.
+ * @unmap_inb: Callback to unmap RapidIO address region mapped with map_inb().
  */
 struct rio_ops {
 	int (*lcread) (struct rio_mport *mport, int index, u32 offset, int len,
@@ -323,6 +325,9 @@ struct rio_ops {
 				 int mbox, void *buffer, size_t len);
 	int (*add_inb_buffer)(struct rio_mport *mport, int mbox, void *buf);
 	void *(*get_inb_message)(struct rio_mport *mport, int mbox);
+	int (*map_inb)(struct rio_mport *mport, dma_addr_t lstart,
+			u64 rstart, u32 size, u32 flags);
+	void (*unmap_inb)(struct rio_mport *mport, dma_addr_t lstart);
 };
 
 #define RIO_RESOURCE_MEM	0x00000100
diff -puN include/linux/rio_drv.h~rapidio-add-inbound-memory-mapping-interface include/linux/rio_drv.h
--- a/include/linux/rio_drv.h~rapidio-add-inbound-memory-mapping-interface
+++ a/include/linux/rio_drv.h
@@ -365,6 +365,11 @@ void rio_release_regions(struct rio_dev 
 int rio_request_region(struct rio_dev *, int, char *);
 void rio_release_region(struct rio_dev *, int);
 
+/* Memory mapping functions */
+extern int rio_map_inb_region(struct rio_mport *mport, dma_addr_t local,
+			u64 rbase, u32 size, u32 rflags);
+extern void rio_unmap_inb_region(struct rio_mport *mport, dma_addr_t lstart);
+
 /* Port-Write management */
 extern int rio_request_inb_pwrite(struct rio_dev *,
 			int (*)(struct rio_dev *, union rio_pw_msg*, int));
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

linux-next.patch
rapidio-tsi721-modify-mport-name-assignment.patch
rapidio-fix-kerneldoc-warnings-after-dma-support-was-added.patch
drivers-rapidio-devices-tsi721c-fix-error-return-code.patch
rapidio-add-inbound-memory-mapping-interface.patch
rapidio-tsi721-add-inbound-memory-mapping-callbacks.patch

