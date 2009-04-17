From: akpm@linux-foundation.org
Subject: + frv-insert-pci-root-bus-resources-for-the-mb93090-devel-motherboard.patch added to -mm tree
Date: Fri, 17 Apr 2009 11:37:12 -0700
Message-ID: <200904171837.n3HIbCVa030334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760248AbZDQSj0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Apr 2009 14:39:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     frv: insert PCI root bus resources for the MB93090 devel motherboard
has been added to the -mm tree.  Its filename is
     frv-insert-pci-root-bus-resources-for-the-mb93090-devel-motherboard.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: insert PCI root bus resources for the MB93090 devel motherboard
From: David Howells <dhowells@redhat.com>

Insert PCI root bus resources for the FRV-based MB93090 development kit
motherboard.  This is required because the CPU's window onto the PCI bus
address space is considerably smaller than the CPU's full address space
and non-PCI devices lie outside of the PCI window that we might want to
access.

Without this patch, the PCI root bus uses the platform-level bus
resources, and these are then confined to the PCI window, thus making
platform_device_add() reject devices outside of this window.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/mb93090-mb00/pci-vdk.c |   65 +++++++++++++++++++++++-------
 1 file changed, 51 insertions(+), 14 deletions(-)

diff -puN arch/frv/mb93090-mb00/pci-vdk.c~frv-insert-pci-root-bus-resources-for-the-mb93090-devel-motherboard arch/frv/mb93090-mb00/pci-vdk.c
--- a/arch/frv/mb93090-mb00/pci-vdk.c~frv-insert-pci-root-bus-resources-for-the-mb93090-devel-motherboard
+++ a/arch/frv/mb93090-mb00/pci-vdk.c
@@ -31,6 +31,29 @@ struct pci_bus *__nongpreldata pci_root_
 struct pci_ops *__nongpreldata pci_root_ops;
 
 /*
+ * The accessible PCI window does not cover the entire CPU address space, but
+ * there are devices we want to access outside of that window, so we need to
+ * insert specific PCI bus resources instead of using the platform-level bus
+ * resources directly for the PCI root bus.
+ *
+ * These are configured and inserted by pcibios_init() and are attached to the
+ * root bus by pcibios_fixup_bus().
+ */
+static struct resource pci_ioport_resource = {
+	.name	= "PCI IO",
+	.start	= 0,
+	.end	= IO_SPACE_LIMIT,
+	.flags	= IORESOURCE_IO,
+};
+
+static struct resource pci_iomem_resource = {
+	.name	= "PCI mem",
+	.start	= 0,
+	.end	= -1,
+	.flags	= IORESOURCE_MEM,
+};
+
+/*
  * Functions for accessing PCI configuration space
  */
 
@@ -304,6 +327,12 @@ void __init pcibios_fixup_bus(struct pci
 #if 0
 	printk("### PCIBIOS_FIXUP_BUS(%d)\n",bus->number);
 #endif
+
+	if (bus->number == 0) {
+		bus->resource[0] = &pci_ioport_resource;
+		bus->resource[1] = &pci_iomem_resource;
+	}
+
 	pci_read_bridge_bases(bus);
 
 	if (bus->number == 0) {
@@ -350,28 +379,36 @@ int __init pcibios_init(void)
 	/* enable PCI arbitration */
 	__reg_MB86943_pci_arbiter	= MB86943_PCIARB_EN;
 
-	ioport_resource.start	= (__reg_MB86943_sl_pci_io_base << 9) & 0xfffffc00;
-	ioport_resource.end	= (__reg_MB86943_sl_pci_io_range << 9) | 0x3ff;
-	ioport_resource.end	+= ioport_resource.start;
+	pci_ioport_resource.start	= (__reg_MB86943_sl_pci_io_base << 9) & 0xfffffc00;
+	pci_ioport_resource.end		= (__reg_MB86943_sl_pci_io_range << 9) | 0x3ff;
+	pci_ioport_resource.end		+= pci_ioport_resource.start;
 
 	printk("PCI IO window:  %08llx-%08llx\n",
-	       (unsigned long long) ioport_resource.start,
-	       (unsigned long long) ioport_resource.end);
-
-	iomem_resource.start	= (__reg_MB86943_sl_pci_mem_base << 9) & 0xfffffc00;
+	       (unsigned long long) pci_ioport_resource.start,
+	       (unsigned long long) pci_ioport_resource.end);
 
-	/* Reserve somewhere to write to flush posted writes. */
-	iomem_resource.start += 0x400;
-
-	iomem_resource.end	= (__reg_MB86943_sl_pci_mem_range << 9) | 0x3ff;
-	iomem_resource.end	+= iomem_resource.start;
+	pci_iomem_resource.start	= (__reg_MB86943_sl_pci_mem_base << 9) & 0xfffffc00;
+	pci_iomem_resource.end		= (__reg_MB86943_sl_pci_mem_range << 9) | 0x3ff;
+	pci_iomem_resource.end		+= pci_iomem_resource.start;
+
+	/* Reserve somewhere to write to flush posted writes.  This is used by
+	 * __flush_PCI_writes() from asm/io.h to force the write FIFO in the
+	 * CPU-PCI bridge to flush as this doesn't happen automatically when a
+	 * read is performed on the MB93090 development kit motherboard.
+	 */
+	pci_iomem_resource.start	+= 0x400;
 
 	printk("PCI MEM window: %08llx-%08llx\n",
-	       (unsigned long long) iomem_resource.start,
-	       (unsigned long long) iomem_resource.end);
+	       (unsigned long long) pci_iomem_resource.start,
+	       (unsigned long long) pci_iomem_resource.end);
 	printk("PCI DMA memory: %08lx-%08lx\n",
 	       dma_coherent_mem_start, dma_coherent_mem_end);
 
+	if (insert_resource(&iomem_resource, &pci_iomem_resource) < 0)
+		panic("Unable to insert PCI IOMEM resource\n");
+	if (insert_resource(&ioport_resource, &pci_ioport_resource) < 0)
+		panic("Unable to insert PCI IOPORT resource\n");
+
 	if (!pci_probe)
 		return -ENXIO;
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
frv-insert-pci-root-bus-resources-for-the-mb93090-devel-motherboard.patch
rxrpc-fix-error-handling-for-rxrpc_alloc_connection.patch
frv-duplicate-output_buffer-of-e03.patch
slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
flat-fix-data-sections-alignment.patch
mutex-subsystem-synchro-test-module.patch

