From: akpm@osdl.org
Subject: + pci-legacy-resource-fix.patch added to -mm tree
Date: Wed, 06 Dec 2006 21:24:33 -0800
Message-ID: <200612070524.kB75OXVP031341@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50081 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968806AbWLGFYz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 00:24:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, alan@redhat.com, greg@kroah.com


The patch titled
     PCI legacy resource fix
has been added to the -mm tree.  Its filename is
     pci-legacy-resource-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PCI legacy resource fix
From: Ralf Baechle <ralf@linux-mips.org>

Since commit 368c73d4f689dae0807d0a2aa74c61fd2b9b075f the kernel will try
to update the non-writeable BAR registers 0..3 of PIIX4 IDE adapters if
pci_assign_unassigned_resources() is used to do full resource assignment of
the bus.  This fails because in the PIIX4 these BAR registers have
implicitly assumed values and read back as zero; it used to work because
the kernel used to just write zero to that register the read back value did
match what was written.

The fix is a new resource flag IORESOURCE_PCI_FIXED used to mark a resource
as non-movable.  This will also be useful to keep other import system
resources from being moved around - for example system consoles on PCI
busses.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/probe.c     |   11 +++++++----
 drivers/pci/setup-res.c |   11 +++++++++++
 include/linux/ioport.h  |    3 +++
 3 files changed, 21 insertions(+), 4 deletions(-)

diff -puN drivers/pci/probe.c~pci-legacy-resource-fix drivers/pci/probe.c
--- a/drivers/pci/probe.c~pci-legacy-resource-fix
+++ a/drivers/pci/probe.c
@@ -692,6 +692,9 @@ static void pci_read_irq(struct pci_dev 
  * Returns 0 on success and -1 if unknown type of device (not normal, bridge
  * or CardBus).
  */
+
+#define LEGACY_IO_RESOURCE	(IORESOURCE_IO | IORESOURCE_PCI_FIXED)
+
 static int pci_setup_device(struct pci_dev * dev)
 {
 	u32 class;
@@ -735,18 +738,18 @@ static int pci_setup_device(struct pci_d
 			if ((progif & 1) == 0) {
 				dev->resource[0].start = 0x1F0;
 				dev->resource[0].end = 0x1F7;
-				dev->resource[0].flags = IORESOURCE_IO;
+				dev->resource[0].flags = LEGACY_IO_RESOURCE;
 				dev->resource[1].start = 0x3F6;
 				dev->resource[1].end = 0x3F6;
-				dev->resource[1].flags = IORESOURCE_IO;
+				dev->resource[1].flags = LEGACY_IO_RESOURCE;
 			}
 			if ((progif & 4) == 0) {
 				dev->resource[2].start = 0x170;
 				dev->resource[2].end = 0x177;
-				dev->resource[2].flags = IORESOURCE_IO;
+				dev->resource[2].flags = LEGACY_IO_RESOURCE;
 				dev->resource[3].start = 0x376;
 				dev->resource[3].end = 0x376;
-				dev->resource[3].flags = IORESOURCE_IO;
+				dev->resource[3].flags = LEGACY_IO_RESOURCE;
 			}
 		}
 		break;
diff -puN drivers/pci/setup-res.c~pci-legacy-resource-fix drivers/pci/setup-res.c
--- a/drivers/pci/setup-res.c~pci-legacy-resource-fix
+++ a/drivers/pci/setup-res.c
@@ -38,6 +38,13 @@ pci_update_resource(struct pci_dev *dev,
 	if (!res->flags)
 		return;
 
+	/* Ignore non-moveable resources.  This might be legacy resources for
+	   which no functional BAR register exists or another important
+	   system resource we should better not move around in system address
+	   space.  */
+	if (res->flags & IORESOURCE_PCI_FIXED)
+		return;
+
 	pcibios_resource_to_bus(dev, &region, res);
 
 	pr_debug("  got res [%llx:%llx] bus [%lx:%lx] flags %lx for "
@@ -212,6 +219,10 @@ pdev_sort_resources(struct pci_dev *dev,
 		resource_size_t r_align;
 
 		r = &dev->resource[i];
+
+		if (r->flags & IORESOURCE_PCI_FIXED)
+			continue;
+
 		r_align = r->end - r->start;
 		
 		if (!(r->flags) || r->parent)
diff -puN include/linux/ioport.h~pci-legacy-resource-fix include/linux/ioport.h
--- a/include/linux/ioport.h~pci-legacy-resource-fix
+++ a/include/linux/ioport.h
@@ -91,6 +91,9 @@ struct resource_list {
 #define IORESOURCE_ROM_COPY		(1<<2)	/* ROM is alloc'd copy, resource field overlaid */
 #define IORESOURCE_ROM_BIOS_COPY	(1<<3)	/* ROM is BIOS copy, resource field overlaid */
 
+/* PCI control bits.  Shares IORESOURCE_BITS with above PCI ROM.  */
+#define IORESOURCE_PCI_FIXED		(1<<4)	/* Do not move resource */
+
 /* PC/ISA/whatever - the normal PC address spaces: IO and memory */
 extern struct resource ioport_resource;
 extern struct resource iomem_resource;
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
export-pm_suspend-for-the-shared-apm-emulation.patch
add-struct-dev-pointer-to-dma_is_consistent.patch
pass-struct-dev-pointer-to-dma_cache_sync.patch
futex-remove-unneeded-barrier.patch
mips-dbg_io-stray-brackets-fix.patch
mmc-fix-syntax-error.patch
git-mtd.patch
git-netdev-all.patch
pci-legacy-resource-fix.patch
generic-ioremap_page_range-mips-conversion.patch

