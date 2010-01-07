From: akpm@linux-foundation.org
Subject: + mn10300-insert-pci-root-bus-resources-for-the-asb2305-devel-motherboard.patch added to -mm tree
Date: Wed, 06 Jan 2010 16:28:33 -0800
Message-ID: <201001070028.o070SYGZ027664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932451Ab0AGA2w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jan 2010 19:28:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     mn10300: insert PCI root bus resources for the ASB2305 devel motherboard
has been added to the -mm tree.  Its filename is
     mn10300-insert-pci-root-bus-resources-for-the-asb2305-devel-motherboard.patch

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
Subject: mn10300: insert PCI root bus resources for the ASB2305 devel motherboard
From: David Howells <dhowells@redhat.com>

Insert PCI root bus resources for the MN10300-based ASB2305 development
kit motherboard.  This is required because the CPU's window onto the PCI
bus address space is considerably smaller than the CPU's full address
space and non-PCI devices lie outside of the PCI window that we might want
to access.

Without this patch, the PCI root bus uses the platform-level bus
resources, and these are then confined to the PCI window, thus making
platform_device_add() reject devices outside of this window.

We also add a reservation for the PCI SRAM region.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/unit-asb2305/pci.c |   57 ++++++++++++++++++------------
 1 file changed, 35 insertions(+), 22 deletions(-)

diff -puN arch/mn10300/unit-asb2305/pci.c~mn10300-insert-pci-root-bus-resources-for-the-asb2305-devel-motherboard arch/mn10300/unit-asb2305/pci.c
--- a/arch/mn10300/unit-asb2305/pci.c~mn10300-insert-pci-root-bus-resources-for-the-asb2305-devel-motherboard
+++ a/arch/mn10300/unit-asb2305/pci.c
@@ -27,6 +27,29 @@ struct pci_bus *pci_root_bus;
 struct pci_ops *pci_root_ops;
 
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
+	.start	= 0xbe000000,
+	.end	= 0xbe03ffff,
+	.flags	= IORESOURCE_IO,
+};
+
+static struct resource pci_iomem_resource = {
+	.name	= "PCI mem",
+	.start	= 0xb8000000,
+	.end	= 0xbbffffff,
+	.flags	= IORESOURCE_MEM,
+};
+
+/*
  * Functions for accessing PCI configuration space
  */
 
@@ -297,6 +320,7 @@ static int __init pci_check_direct(void)
 		printk(KERN_INFO "PCI: Using configuration ampci\n");
 		request_mem_region(0xBE040000, 256, "AMPCI bridge");
 		request_mem_region(0xBFFFFFF4, 12, "PCI ampci");
+		request_mem_region(0xBC000000, 32 * 1024 * 1024, "PCI SRAM");
 		return 0;
 	}
 
@@ -358,6 +382,11 @@ void __devinit pcibios_fixup_bus(struct 
 {
 	struct pci_dev *dev;
 
+	if (bus->number == 0) {
+		bus->resource[0] = &pci_ioport_resource;
+		bus->resource[1] = &pci_iomem_resource;
+	}
+
 	if (bus->self) {
 		pci_read_bridge_bases(bus);
 		pcibios_fixup_device_resources(bus->self);
@@ -380,6 +409,11 @@ static int __init pcibios_init(void)
 	iomem_resource.start	= 0xA0000000;
 	iomem_resource.end	= 0xDFFFFFFF;
 
+	if (insert_resource(&iomem_resource, &pci_iomem_resource) < 0)
+		panic("Unable to insert PCI IOMEM resource\n");
+	if (insert_resource(&ioport_resource, &pci_ioport_resource) < 0)
+		panic("Unable to insert PCI IOPORT resource\n");
+
 	if (!pci_probe)
 		return 0;
 
@@ -391,32 +425,11 @@ static int __init pcibios_init(void)
 	printk(KERN_INFO "PCI: Probing PCI hardware [mempage %08x]\n",
 	       MEM_PAGING_REG);
 
-	{
-#if 0
-		static struct pci_bus am33_root_bus = {
-			.children  = LIST_HEAD_INIT(am33_root_bus.children),
-			.devices   = LIST_HEAD_INIT(am33_root_bus.devices),
-			.number    = 0,
-			.secondary = 0,
-			.resource = { &ioport_resource, &iomem_resource },
-		};
-
-		am33_root_bus.ops = pci_root_ops;
-		list_add_tail(&am33_root_bus.node, &pci_root_buses);
-
-		am33_root_bus.subordinate = pci_do_scan_bus(0);
-
-		pci_root_bus = &am33_root_bus;
-#else
-		pci_root_bus = pci_scan_bus(0, &pci_direct_ampci, NULL);
-#endif
-	}
+	pci_root_bus = pci_scan_bus(0, &pci_direct_ampci, NULL);
 
 	pcibios_irq_init();
 	pcibios_fixup_irqs();
-#if 0
 	pcibios_resource_survey();
-#endif
 	return 0;
 }
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

mm-make-totalhigh_pages-unsigned-long.patch
fdpic-respect-pt_gnu_stack-exec-protection-markings-when-creating-nommu-stack.patch
nommu-avoiding-duplicate-icache-flushes-of-shared-maps.patch
nommu-use-copy__user_page-in-access_process_vm.patch
mn10300-signal-stack-fix.patch
mn10300-objcopy-flags-fix.patch
mn10300-add-cc-clobbers-to-asm-statements.patch
mn10300-wire-up-missing-new-syscalls.patch
fix-several-bogus-includes-on-mn10300-abs2305.patch
mn10300-use-kern_err-not-kern_error.patch
mn10300-use-generic-pci_enable_resources.patch
mn10300-insert-pci-root-bus-resources-for-the-asb2305-devel-motherboard.patch
mn10300-make-the-asb2305s-pcnet32-nic-work-by-using-the-pci-bridges-sram.patch
mn10300-update-the-asb2303-defconfig.patch
kernel-credc-use-kmem_cache_free.patch
frv-duplicate-output_buffer-of-e03.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

