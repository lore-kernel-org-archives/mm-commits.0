From: akpm@linux-foundation.org
Subject: - resource-use-new-resource-type-changes.patch removed from -mm tree
Date: Fri, 18 Jul 2008 15:25:35 -0700
Message-ID: <200807182225.m6IMPZF1001682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754184AbYGRW1N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 18:27:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magnus.damm@gmail.com, benh@kernel.crashing.org, damm@igel.co.jp, davem@davemloft.net, davem@sunset.davemloft.net, galak@kernel.crashing.org, greg@kroah.com, gregkh@suse.de, jwboyer@g


The patch titled
     resource: use new resource type changes
has been removed from the -mm tree.  Its filename was
     resource-use-new-resource-type-changes.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: resource: use new resource type changes
From: Magnus Damm <magnus.damm@gmail.com>

Make sure resource_type() or IORESOURCE_TYPE_BITS are used instead of
bit operations. This needs more work, I ignored drivers/ for now.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Greg KH <greg@kroah.com>
Cc: Josh Boyer <jwboyer@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David S. Miller <davem@sunset.davemloft.net>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/pci.c                    |   21 ++++++------
 arch/arm/kernel/bios32.c                   |   16 ++++-----
 arch/arm/mach-iop13xx/pci.c                |    6 +--
 arch/arm/mm/iomap.c                        |    5 +--
 arch/arm/plat-s3c24xx/pm.c                 |    2 -
 arch/cris/arch-v32/drivers/pci/bios.c      |    6 +--
 arch/frv/mb93090-mb00/pci-frv.c            |   10 +++---
 arch/frv/mb93090-mb00/pci-iomap.c          |    3 +
 arch/ia64/pci/pci.c                        |    7 ++--
 arch/ia64/sn/kernel/io_init.c              |    2 -
 arch/m68k/kernel/bios32.c                  |    6 +--
 arch/mips/basler/excite/excite_device.c    |   12 +------
 arch/mips/lib/iomap-pci.c                  |    5 +--
 arch/mips/pci/pci.c                        |   24 +++++++-------
 arch/mips/pmc-sierra/yosemite/ht.c         |    6 +--
 arch/mn10300/unit-asb2305/pci-asb2305.c    |    8 ++--
 arch/mn10300/unit-asb2305/pci-iomap.c      |    3 +
 arch/parisc/kernel/pci.c                   |   15 ++++-----
 arch/parisc/lib/iomap.c                    |    5 +--
 arch/powerpc/kernel/iomap.c                |    5 +--
 arch/powerpc/kernel/legacy_serial.c        |    2 -
 arch/powerpc/kernel/pci-common.c           |   31 +++++++++----------
 arch/powerpc/kernel/pci_64.c               |    2 -
 arch/powerpc/kernel/prom_parse.c           |    4 +-
 arch/powerpc/platforms/fsl_uli1575.c       |    2 -
 arch/powerpc/platforms/maple/setup.c       |    2 -
 arch/powerpc/platforms/maple/time.c        |    2 -
 arch/powerpc/platforms/pseries/eeh_cache.c |    5 +--
 arch/powerpc/platforms/pseries/pci.c       |    4 +-
 arch/powerpc/sysdev/fsl_pci.c              |    4 +-
 arch/powerpc/sysdev/ppc4xx_pci.c           |    8 ++--
 arch/sh/drivers/pci/pci.c                  |   11 +++---
 arch/sh/kernel/io_trapped.c                |   10 ++++--
 arch/sparc/kernel/of_device.c              |    1 
 arch/sparc/kernel/pcic.c                   |   12 +++----
 arch/sparc/lib/iomap.c                     |    5 +--
 arch/sparc64/kernel/of_device.c            |    5 +--
 arch/sparc64/kernel/pci.c                  |   21 ++++++------
 arch/sparc64/lib/iomap.c                   |    5 +--
 arch/x86/kernel/pci-calgary_64.c           |    2 -
 arch/x86/pci/i386.c                        |    4 +-
 arch/xtensa/kernel/pci.c                   |   12 +++----
 42 files changed, 168 insertions(+), 153 deletions(-)

diff -puN arch/alpha/kernel/pci.c~resource-use-new-resource-type-changes arch/alpha/kernel/pci.c
--- a/arch/alpha/kernel/pci.c~resource-use-new-resource-type-changes
+++ a/arch/alpha/kernel/pci.c
@@ -135,7 +135,7 @@ pcibios_align_resource(void *data, struc
 	unsigned long alignto;
 	resource_size_t start = res->start;
 
-	if (res->flags & IORESOURCE_IO) {
+	if (resource_type(res) == IORESOURCE_IO) {
 		/* Make sure we start at our min on all hoses */
 		if (start - hose->io_space->start < PCIBIOS_MIN_IO)
 			start = PCIBIOS_MIN_IO + hose->io_space->start;
@@ -146,7 +146,7 @@ pcibios_align_resource(void *data, struc
 		if (start & 0x300)
 			start = (start + 0x3ff) & ~0x3ff;
 	}
-	else if	(res->flags & IORESOURCE_MEM) {
+	else if	(resource_type(res) == IORESOURCE_MEM) {
 		/* Make sure we start at our min on all hoses */
 		if (start - hose->mem_space->start < PCIBIOS_MIN_MEM)
 			start = PCIBIOS_MIN_MEM + hose->mem_space->start;
@@ -269,10 +269,10 @@ pcibios_fixup_device_resources(struct pc
 	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
 		if (!dev->resource[i].start)
 			continue;
-		if (dev->resource[i].flags & IORESOURCE_IO)
+		if (resource_type(&dev->resource[i]) == IORESOURCE_IO)
 			pcibios_fixup_resource(&dev->resource[i],
 					       hose->io_space);
-		else if (dev->resource[i].flags & IORESOURCE_MEM)
+		else if (resource_type(&dev->resource[i]) == IORESOURCE_MEM)
 			pcibios_fixup_resource(&dev->resource[i],
 					       hose->mem_space);
 	}
@@ -345,9 +345,9 @@ pcibios_resource_to_bus(struct pci_dev *
 	struct pci_controller *hose = (struct pci_controller *)dev->sysdata;
 	unsigned long offset = 0;
 
-	if (res->flags & IORESOURCE_IO)
+	if (resource_type(res) == IORESOURCE_IO)
 		offset = hose->io_space->start;
-	else if (res->flags & IORESOURCE_MEM)
+	else if (resource_type(res) == IORESOURCE_MEM)
 		offset = hose->mem_space->start;
 
 	region->start = res->start - offset;
@@ -360,9 +360,9 @@ void pcibios_bus_to_resource(struct pci_
 	struct pci_controller *hose = (struct pci_controller *)dev->sysdata;
 	unsigned long offset = 0;
 
-	if (res->flags & IORESOURCE_IO)
+	if (resource_type(res) == IORESOURCE_IO)
 		offset = hose->io_space->start;
-	else if (res->flags & IORESOURCE_MEM)
+	else if (resource_type(res) == IORESOURCE_MEM)
 		offset = hose->mem_space->start;
 
 	res->start = region->start + offset;
@@ -534,14 +534,15 @@ void __iomem *pci_iomap(struct pci_dev *
 	resource_size_t start = pci_resource_start(dev, bar);
 	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
+	unsigned long type = flags & IORESOURCE_TYPE_BITS;
 
 	if (!len || !start)
 		return NULL;
 	if (maxlen && len > maxlen)
 		len = maxlen;
-	if (flags & IORESOURCE_IO)
+	if (type == IORESOURCE_IO)
 		return ioport_map(start, len);
-	if (flags & IORESOURCE_MEM) {
+	if (type == IORESOURCE_MEM) {
 		/* Not checking IORESOURCE_CACHEABLE because alpha does
 		   not distinguish between ioremap and ioremap_nocache.  */
 		return ioremap(start, len);
diff -puN arch/arm/kernel/bios32.c~resource-use-new-resource-type-changes arch/arm/kernel/bios32.c
--- a/arch/arm/kernel/bios32.c~resource-use-new-resource-type-changes
+++ a/arch/arm/kernel/bios32.c
@@ -331,7 +331,7 @@ pdev_fixup_device_resources(struct pci_s
 	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
 		if (dev->resource[i].start == 0)
 			continue;
-		if (dev->resource[i].flags & IORESOURCE_MEM)
+		if (resource_type(&dev->resource[i]) == IORESOURCE_MEM)
 			offset = root->mem_offset;
 		else
 			offset = root->io_offset;
@@ -448,9 +448,9 @@ pcibios_resource_to_bus(struct pci_dev *
 	struct pci_sys_data *root = dev->sysdata;
 	unsigned long offset = 0;
 
-	if (res->flags & IORESOURCE_IO)
+	if (resource_type(res) == IORESOURCE_IO)
 		offset = root->io_offset;
-	if (res->flags & IORESOURCE_MEM)
+	if (resource_type(res) == IORESOURCE_MEM)
 		offset = root->mem_offset;
 
 	region->start = res->start - offset;
@@ -464,9 +464,9 @@ pcibios_bus_to_resource(struct pci_dev *
 	struct pci_sys_data *root = dev->sysdata;
 	unsigned long offset = 0;
 
-	if (res->flags & IORESOURCE_IO)
+	if (resource_type(res) == IORESOURCE_IO)
 		offset = root->io_offset;
-	if (res->flags & IORESOURCE_MEM)
+	if (resource_type(res) == IORESOURCE_MEM)
 		offset = root->mem_offset;
 
 	res->start = region->start + offset;
@@ -648,7 +648,7 @@ void pcibios_align_resource(void *data, 
 {
 	resource_size_t start = res->start;
 
-	if (res->flags & IORESOURCE_IO && start & 0x300)
+	if (resource_type(res) == IORESOURCE_IO && start & 0x300)
 		start = (start + 0x3ff) & ~0x3ff;
 
 	res->start = (start + align - 1) & ~(align - 1);
@@ -677,9 +677,9 @@ int pcibios_enable_device(struct pci_dev
 			       " of resource collisions\n", pci_name(dev));
 			return -EINVAL;
 		}
-		if (r->flags & IORESOURCE_IO)
+		if (resource_type(r) == IORESOURCE_IO)
 			cmd |= PCI_COMMAND_IO;
-		if (r->flags & IORESOURCE_MEM)
+		if (resource_type(r) == IORESOURCE_MEM)
 			cmd |= PCI_COMMAND_MEMORY;
 	}
 
diff -puN arch/arm/mach-iop13xx/pci.c~resource-use-new-resource-type-changes arch/arm/mach-iop13xx/pci.c
--- a/arch/arm/mach-iop13xx/pci.c~resource-use-new-resource-type-changes
+++ a/arch/arm/mach-iop13xx/pci.c
@@ -70,9 +70,9 @@ void iop13xx_map_pci_memory(void)
 					max = DEVICE_COUNT_RESOURCE;
 
 				for (i = 0; i < max; i++) {
-					struct resource *res = &dev->resource[i];
-					if (res->flags & IORESOURCE_MEM)
-						end = max(res->end, end);
+					struct resource *r = &dev->resource[i];
+					if (resource_type(r) == IORESOURCE_MEM)
+						end = max(r->end, end);
 				}
 			}
 
diff -puN arch/arm/mm/iomap.c~resource-use-new-resource-type-changes arch/arm/mm/iomap.c
--- a/arch/arm/mm/iomap.c~resource-use-new-resource-type-changes
+++ a/arch/arm/mm/iomap.c
@@ -29,14 +29,15 @@ void __iomem *pci_iomap(struct pci_dev *
 	resource_size_t start = pci_resource_start(dev, bar);
 	resource_size_t len   = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
+	unsigned long type = flags & IORESOURCE_TYPE_BITS;
 
 	if (!len || !start)
 		return NULL;
 	if (maxlen && len > maxlen)
 		len = maxlen;
-	if (flags & IORESOURCE_IO)
+	if (type == IORESOURCE_IO)
 		return ioport_map(start, len);
-	if (flags & IORESOURCE_MEM) {
+	if (type == IORESOURCE_MEM) {
 		if (flags & IORESOURCE_CACHEABLE)
 			return ioremap(start, len);
 		return ioremap_nocache(start, len);
diff -puN arch/arm/plat-s3c24xx/pm.c~resource-use-new-resource-type-changes arch/arm/plat-s3c24xx/pm.c
--- a/arch/arm/plat-s3c24xx/pm.c~resource-use-new-resource-type-changes
+++ a/arch/arm/plat-s3c24xx/pm.c
@@ -208,7 +208,7 @@ static void s3c2410_pm_run_res(struct re
 		if (ptr->child != NULL)
 			s3c2410_pm_run_res(ptr->child, fn, arg);
 
-		if ((ptr->flags & IORESOURCE_MEM) &&
+		if ((resource_type(ptr) == IORESOURCE_MEM) &&
 		    strcmp(ptr->name, "System RAM") == 0) {
 			DBG("Found system RAM at %08lx..%08lx\n",
 			    ptr->start, ptr->end);
diff -puN arch/cris/arch-v32/drivers/pci/bios.c~resource-use-new-resource-type-changes arch/cris/arch-v32/drivers/pci/bios.c
--- a/arch/cris/arch-v32/drivers/pci/bios.c~resource-use-new-resource-type-changes
+++ a/arch/cris/arch-v32/drivers/pci/bios.c
@@ -45,7 +45,7 @@ void
 pcibios_align_resource(void *data, struct resource *res,
 		       resource_size_t size, resource_size_t align)
 {
-	if (res->flags & IORESOURCE_IO) {
+	if (resource_type(res) == IORESOURCE_IO) {
 		resource_size_t start = res->start;
 
 		if (start & 0x300) {
@@ -73,9 +73,9 @@ int pcibios_enable_resources(struct pci_
 			printk(KERN_ERR "PCI: Device %s not available because of resource collisions\n", pci_name(dev));
 			return -EINVAL;
 		}
-		if (r->flags & IORESOURCE_IO)
+		if (resource_type(r) == IORESOURCE_IO)
 			cmd |= PCI_COMMAND_IO;
-		if (r->flags & IORESOURCE_MEM)
+		if (resource_type(r) == IORESOURCE_MEM)
 			cmd |= PCI_COMMAND_MEMORY;
 	}
 	if (dev->resource[PCI_ROM_RESOURCE].start)
diff -puN arch/frv/mb93090-mb00/pci-frv.c~resource-use-new-resource-type-changes arch/frv/mb93090-mb00/pci-frv.c
--- a/arch/frv/mb93090-mb00/pci-frv.c~resource-use-new-resource-type-changes
+++ a/arch/frv/mb93090-mb00/pci-frv.c
@@ -36,7 +36,7 @@ void
 pcibios_align_resource(void *data, struct resource *res,
 		       resource_size_t size, resource_size_t align)
 {
-	if (res->flags & IORESOURCE_IO) {
+	if (resource_type(res) == IORESOURCE_IO) {
 		resource_size_t start = res->start;
 
 		if (start & 0x300) {
@@ -120,7 +120,7 @@ static void __init pcibios_allocate_reso
 				continue;
 			if (!r->start)		/* Address not assigned at all */
 				continue;
-			if (r->flags & IORESOURCE_IO)
+			if (resource_type(r) == IORESOURCE_IO)
 				disabled = !(command & PCI_COMMAND_IO);
 			else
 				disabled = !(command & PCI_COMMAND_MEMORY);
@@ -170,7 +170,7 @@ static void __init pcibios_assign_resour
 			 *  Don't touch IDE controllers and I/O ports of video cards!
 			 */
 			if ((class == PCI_CLASS_STORAGE_IDE && idx < 4) ||
-			    (class == PCI_CLASS_DISPLAY_VGA && (r->flags & IORESOURCE_IO)))
+			    (class == PCI_CLASS_DISPLAY_VGA && (resource_type(r) == IORESOURCE_IO)))
 				continue;
 
 			/*
@@ -219,9 +219,9 @@ int pcibios_enable_resources(struct pci_
 			printk(KERN_ERR "PCI: Device %s not available because of resource collisions\n", pci_name(dev));
 			return -EINVAL;
 		}
-		if (r->flags & IORESOURCE_IO)
+		if (resource_type(r) == IORESOURCE_IO)
 			cmd |= PCI_COMMAND_IO;
-		if (r->flags & IORESOURCE_MEM)
+		if (resource_type(r) == IORESOURCE_MEM)
 			cmd |= PCI_COMMAND_MEMORY;
 	}
 	if (dev->resource[PCI_ROM_RESOURCE].start)
diff -puN arch/frv/mb93090-mb00/pci-iomap.c~resource-use-new-resource-type-changes arch/frv/mb93090-mb00/pci-iomap.c
--- a/arch/frv/mb93090-mb00/pci-iomap.c~resource-use-new-resource-type-changes
+++ a/arch/frv/mb93090-mb00/pci-iomap.c
@@ -16,11 +16,12 @@ void __iomem *pci_iomap(struct pci_dev *
 	resource_size_t start = pci_resource_start(dev, bar);
 	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
+	unsigned long type = flags & IORESOURCE_TYPE_BITS;
 
 	if (!len || !start)
 		return NULL;
 
-	if ((flags & IORESOURCE_IO) || (flags & IORESOURCE_MEM))
+	if (type == IORESOURCE_IO || type == IORESOURCE_MEM)
 		return (void __iomem *) start;
 
 	return NULL;
diff -puN arch/ia64/pci/pci.c~resource-use-new-resource-type-changes arch/ia64/pci/pci.c
--- a/arch/ia64/pci/pci.c~resource-use-new-resource-type-changes
+++ a/arch/ia64/pci/pci.c
@@ -309,7 +309,7 @@ pcibios_setup_root_windows(struct pci_bu
 		struct resource *res = &ctrl->window[i].resource;
 		/* HP's firmware has a hack to work around a Windows bug.
 		 * Ignore these tiny memory ranges */
-		if ((res->flags & IORESOURCE_MEM) &&
+		if (resource_type(res) == IORESOURCE_MEM &&
 		    (res->end - res->start < 16))
 			continue;
 		if (j >= PCI_BUS_NUM_RESOURCES) {
@@ -432,15 +432,16 @@ EXPORT_SYMBOL(pcibios_bus_to_resource);
 
 static int __devinit is_valid_resource(struct pci_dev *dev, int idx)
 {
-	unsigned int i, type_mask = IORESOURCE_IO | IORESOURCE_MEM;
+	unsigned int i;
 	struct resource *devr = &dev->resource[idx];
+	unsigned long type = resource_type(devr);
 
 	if (!dev->bus)
 		return 0;
 	for (i=0; i<PCI_BUS_NUM_RESOURCES; i++) {
 		struct resource *busr = dev->bus->resource[i];
 
-		if (!busr || ((busr->flags ^ devr->flags) & type_mask))
+		if (!busr || (resource_type(busr) != type))
 			continue;
 		if ((devr->start) && (devr->start >= busr->start) &&
 				(devr->end <= busr->end))
diff -puN arch/ia64/sn/kernel/io_init.c~resource-use-new-resource-type-changes arch/ia64/sn/kernel/io_init.c
--- a/arch/ia64/sn/kernel/io_init.c~resource-use-new-resource-type-changes
+++ a/arch/ia64/sn/kernel/io_init.c
@@ -255,7 +255,7 @@ sn_io_slot_fixup(struct pci_dev *dev)
 		if (dev->resource[idx].parent && dev->resource[idx].parent->child)
 			release_resource(&dev->resource[idx]);
 
-		if (dev->resource[idx].flags & IORESOURCE_IO)
+		if (resource_type(&dev->resource[idx]) == IORESOURCE_IO)
 			insert_resource(&ioport_resource, &dev->resource[idx]);
 		else
 			insert_resource(&iomem_resource, &dev->resource[idx]);
diff -puN arch/m68k/kernel/bios32.c~resource-use-new-resource-type-changes arch/m68k/kernel/bios32.c
--- a/arch/m68k/kernel/bios32.c~resource-use-new-resource-type-changes
+++ a/arch/m68k/kernel/bios32.c
@@ -392,12 +392,12 @@ static void __init pcibios_claim_resourc
 				if ((r->start == 0) || (r->parent != NULL))
 					continue;
 #if 1
-				if (r->flags & IORESOURCE_IO)
+				if (resource_type(r) == IORESOURCE_IO)
 					pr = &bus_info->io_space;
 				else
 					pr = &bus_info->mem_space;
 #else
-				if (r->flags & IORESOURCE_IO)
+				if (resource_type(r) == IORESOURCE_IO)
 					pr = &ioport_resource;
 				else
 					pr = &iomem_resource;
@@ -438,7 +438,7 @@ int __init pcibios_assign_resource(struc
 	if (!pr)
 		return -EINVAL;
 
-	if (r->flags & IORESOURCE_IO)
+	if (resource_type(r) == IORESOURCE_IO)
 	{
 		if (size > 0x100)
 			return -EFBIG;
diff -puN arch/mips/basler/excite/excite_device.c~resource-use-new-resource-type-changes arch/mips/basler/excite/excite_device.c
--- a/arch/mips/basler/excite/excite_device.c~resource-use-new-resource-type-changes
+++ a/arch/mips/basler/excite/excite_device.c
@@ -146,15 +146,13 @@ static struct resource
 static void adjust_resources(struct resource *res, unsigned int n)
 {
 	struct resource *p;
-	const unsigned long mask = IORESOURCE_IO | IORESOURCE_MEM
-				   | IORESOURCE_IRQ | IORESOURCE_DMA;
 
 	for (p = res; p < res + n; p++) {
 		const struct resource * const parent = p->parent;
 		if (parent) {
 			p->start += parent->start;
 			p->end   += parent->start;
-			p->flags =  parent->flags & mask;
+			p->flags =  resource_type(parent);
 		}
 	}
 }
@@ -389,12 +387,8 @@ static int __init excite_setup_devs(void
 	res = request_resource(&iomem_resource, &excite_nand_resource);
 	if (res)
 		return res;
-	excite_fpga_resource.flags = excite_fpga_resource.parent->flags &
-				   ( IORESOURCE_IO | IORESOURCE_MEM
-				   | IORESOURCE_IRQ | IORESOURCE_DMA);
-	excite_nand_resource.flags = excite_nand_resource.parent->flags &
-				   ( IORESOURCE_IO | IORESOURCE_MEM
-				   | IORESOURCE_IRQ | IORESOURCE_DMA);
+	excite_fpga_resource.flags = resource_type(excite_fpga_resource.parent);
+	excite_nand_resource.flags = resource_type(excite_nand_resource.parent);
 
 	return 0;
 }
diff -puN arch/mips/lib/iomap-pci.c~resource-use-new-resource-type-changes arch/mips/lib/iomap-pci.c
--- a/arch/mips/lib/iomap-pci.c~resource-use-new-resource-type-changes
+++ a/arch/mips/lib/iomap-pci.c
@@ -48,14 +48,15 @@ void __iomem *pci_iomap(struct pci_dev *
 	resource_size_t start = pci_resource_start(dev, bar);
 	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
+	unsigned long type = flags & IORESOURCE_TYPE_BITS;
 
 	if (!len || !start)
 		return NULL;
 	if (maxlen && len > maxlen)
 		len = maxlen;
-	if (flags & IORESOURCE_IO)
+	if (type == IORESOURCE_IO)
 		return ioport_map_pci(dev, start, len);
-	if (flags & IORESOURCE_MEM) {
+	if (type == IORESOURCE_MEM) {
 		if (flags & IORESOURCE_CACHEABLE)
 			return ioremap(start, len);
 		return ioremap_nocache(start, len);
diff -puN arch/mips/pci/pci.c~resource-use-new-resource-type-changes arch/mips/pci/pci.c
--- a/arch/mips/pci/pci.c~resource-use-new-resource-type-changes
+++ a/arch/mips/pci/pci.c
@@ -55,7 +55,7 @@ pcibios_align_resource(void *data, struc
 	struct pci_controller *hose = dev->sysdata;
 	resource_size_t start = res->start;
 
-	if (res->flags & IORESOURCE_IO) {
+	if (resource_type(res) == IORESOURCE_IO) {
 		/* Make sure we start at our min on all hoses */
 		if (start < PCIBIOS_MIN_IO + hose->io_resource->start)
 			start = PCIBIOS_MIN_IO + hose->io_resource->start;
@@ -65,7 +65,7 @@ pcibios_align_resource(void *data, struc
 		 */
 		if (start & 0x300)
 			start = (start + 0x3ff) & ~0x3ff;
-	} else if (res->flags & IORESOURCE_MEM) {
+	} else if (resource_type(res) == IORESOURCE_MEM) {
 		/* Make sure we start at our min on all hoses */
 		if (start < PCIBIOS_MIN_MEM + hose->mem_resource->start)
 			start = PCIBIOS_MIN_MEM + hose->mem_resource->start;
@@ -167,6 +167,7 @@ static int pcibios_enable_resources(stru
 	u16 cmd, old_cmd;
 	int idx;
 	struct resource *r;
+	unsigned long type;
 
 	pci_read_config_word(dev, PCI_COMMAND, &cmd);
 	old_cmd = cmd;
@@ -176,7 +177,8 @@ static int pcibios_enable_resources(stru
 			continue;
 
 		r = &dev->resource[idx];
-		if (!(r->flags & (IORESOURCE_IO | IORESOURCE_MEM)))
+		type = resource_type(r);
+		if (type != IORESOURCE_IO && type != IORESOURCE_MEM)))
 			continue;
 		if ((idx == PCI_ROM_RESOURCE) &&
 				(!(r->flags & IORESOURCE_ROM_ENABLE)))
@@ -187,9 +189,9 @@ static int pcibios_enable_resources(stru
 			       pci_name(dev));
 			return -EINVAL;
 		}
-		if (r->flags & IORESOURCE_IO)
+		if (type == IORESOURCE_IO)
 			cmd |= PCI_COMMAND_IO;
-		if (r->flags & IORESOURCE_MEM)
+		if (type == IORESOURCE_MEM)
 			cmd |= PCI_COMMAND_MEMORY;
 	}
 	if (cmd != old_cmd) {
@@ -249,9 +251,9 @@ static void pcibios_fixup_device_resourc
 			continue;
 		if (dev->resource[i].flags & IORESOURCE_PCI_FIXED)
 			continue;
-		if (dev->resource[i].flags & IORESOURCE_IO)
+		if (resource_type(&dev->resource[i]) == IORESOURCE_IO)
 			offset = hose->io_offset;
-		else if (dev->resource[i].flags & IORESOURCE_MEM)
+		else if (resource_type(&dev->resource[i]) == IORESOURCE_MEM)
 			offset = hose->mem_offset;
 
 		dev->resource[i].start += offset;
@@ -296,9 +298,9 @@ void pcibios_resource_to_bus(struct pci_
 	struct pci_controller *hose = (struct pci_controller *)dev->sysdata;
 	unsigned long offset = 0;
 
-	if (res->flags & IORESOURCE_IO)
+	if (resource_type(res) == IORESOURCE_IO)
 		offset = hose->io_offset;
-	else if (res->flags & IORESOURCE_MEM)
+	else if (resource_type(res) == IORESOURCE_MEM)
 		offset = hose->mem_offset;
 
 	region->start = res->start - offset;
@@ -312,9 +314,9 @@ pcibios_bus_to_resource(struct pci_dev *
 	struct pci_controller *hose = (struct pci_controller *)dev->sysdata;
 	unsigned long offset = 0;
 
-	if (res->flags & IORESOURCE_IO)
+	if (resource_type(res) == IORESOURCE_IO)
 		offset = hose->io_offset;
-	else if (res->flags & IORESOURCE_MEM)
+	else if (resource_type(res) == IORESOURCE_MEM)
 		offset = hose->mem_offset;
 
 	res->start = region->start + offset;
diff -puN arch/mips/pmc-sierra/yosemite/ht.c~resource-use-new-resource-type-changes arch/mips/pmc-sierra/yosemite/ht.c
--- a/arch/mips/pmc-sierra/yosemite/ht.c~resource-use-new-resource-type-changes
+++ a/arch/mips/pmc-sierra/yosemite/ht.c
@@ -304,9 +304,9 @@ int pcibios_enable_resources(struct pci_
                                "resource collisions\n", pci_name(dev));
                         return -EINVAL;
                 }
-                if (r->flags & IORESOURCE_IO)
+                if (resource_type(r) == IORESOURCE_IO)
                         cmd |= PCI_COMMAND_IO;
-                if (r->flags & IORESOURCE_MEM)
+                if (resource_type(r) ==  IORESOURCE_MEM)
                         cmd |= PCI_COMMAND_MEMORY;
         }
         if (cmd != old_cmd) {
@@ -350,7 +350,7 @@ void pcibios_align_resource(void *data, 
 {
         struct pci_dev *dev = data;
 
-        if (res->flags & IORESOURCE_IO) {
+        if (resource_type(res) == IORESOURCE_IO) {
                 resource_size_t start = res->start;
 
                 /* We need to avoid collisions with `mirrored' VGA ports
diff -puN arch/mn10300/unit-asb2305/pci-asb2305.c~resource-use-new-resource-type-changes arch/mn10300/unit-asb2305/pci-asb2305.c
--- a/arch/mn10300/unit-asb2305/pci-asb2305.c~resource-use-new-resource-type-changes
+++ a/arch/mn10300/unit-asb2305/pci-asb2305.c
@@ -47,7 +47,7 @@ void pcibios_align_resource(void *data, 
 	       );
 #endif
 
-	if (res->flags & IORESOURCE_IO) {
+	if (resource_type(res) == IORESOURCE_IO) {
 		unsigned long start = res->start;
 
 		if (start & 0x300) {
@@ -142,7 +142,7 @@ static void __init pcibios_allocate_reso
 				continue;
 			if (!r->start)		/* Address not assigned */
 				continue;
-			if (r->flags & IORESOURCE_IO)
+			if (resource_type(r) == IORESOURCE_IO)
 				disabled = !(command & PCI_COMMAND_IO);
 			else
 				disabled = !(command & PCI_COMMAND_MEMORY);
@@ -242,9 +242,9 @@ int pcibios_enable_resources(struct pci_
 			return -EINVAL;
 		}
 
-		if (r->flags & IORESOURCE_IO)
+		if (resource_type(r) == IORESOURCE_IO)
 			cmd |= PCI_COMMAND_IO;
-		if (r->flags & IORESOURCE_MEM)
+		if (resource_type(r) == IORESOURCE_MEM)
 			cmd |= PCI_COMMAND_MEMORY;
 	}
 
diff -puN arch/mn10300/unit-asb2305/pci-iomap.c~resource-use-new-resource-type-changes arch/mn10300/unit-asb2305/pci-iomap.c
--- a/arch/mn10300/unit-asb2305/pci-iomap.c~resource-use-new-resource-type-changes
+++ a/arch/mn10300/unit-asb2305/pci-iomap.c
@@ -19,11 +19,12 @@ void __iomem *pci_iomap(struct pci_dev *
 	resource_size_t start = pci_resource_start(dev, bar);
 	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
+	unsigned long type = flags & IORESOURCE_TYPE_BITS;
 
 	if (!len || !start)
 		return NULL;
 
-	if ((flags & IORESOURCE_IO) || (flags & IORESOURCE_MEM))
+	if (type == IORESOURCE_IO || type == IORESOURCE_MEM)
 		return (void __iomem *) start;
 
 	return NULL;
diff -puN arch/parisc/kernel/pci.c~resource-use-new-resource-type-changes arch/parisc/kernel/pci.c
--- a/arch/parisc/kernel/pci.c~resource-use-new-resource-type-changes
+++ a/arch/parisc/kernel/pci.c
@@ -202,7 +202,7 @@ void __devinit pcibios_resource_to_bus(s
 	struct pci_hba_data *hba = HBA_DATA(dev->bus->bridge->platform_data);
 #endif
 
-	if (res->flags & IORESOURCE_IO) {
+	if (resource_type(res) == IORESOURCE_IO) {
 		/*
 		** I/O space may see busnumbers here. Something
 		** in the form of 0xbbxxxx where bb is the bus num
@@ -212,15 +212,15 @@ void __devinit pcibios_resource_to_bus(s
 		*/
 		region->start = PCI_PORT_ADDR(res->start);
 		region->end   = PCI_PORT_ADDR(res->end);
-	} else if (res->flags & IORESOURCE_MEM) {
+	} else if (resource_type(res) == IORESOURCE_MEM) {
 		/* Convert MMIO addr to PCI addr (undo global virtualization) */
 		region->start = PCI_BUS_ADDR(hba, res->start);
 		region->end   = PCI_BUS_ADDR(hba, res->end);
 	}
 
 	DBG_RES("pcibios_resource_to_bus(%02x %s [%lx,%lx])\n",
-		dev->bus->number, res->flags & IORESOURCE_IO ? "IO" : "MEM",
-		region->start, region->end);
+		dev->bus->number, resource_type(res) == IORESOURCE_IO ? "IO"
+		: "MEM", region->start, region->end);
 }
 
 void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
@@ -230,12 +230,12 @@ void pcibios_bus_to_resource(struct pci_
 	struct pci_hba_data *hba = HBA_DATA(dev->bus->bridge->platform_data);
 #endif
 
-	if (res->flags & IORESOURCE_MEM) {
+	if (resource_type(res) == IORESOURCE_MEM) {
 		res->start = PCI_HOST_ADDR(hba, region->start);
 		res->end = PCI_HOST_ADDR(hba, region->end);
 	}
 
-	if (res->flags & IORESOURCE_IO) {
+	if (resource_type(res) == IORESOURCE_IO) {
 		res->start = region->start;
 		res->end = region->end;
 	}
@@ -266,7 +266,8 @@ void pcibios_align_resource(void *data, 
 		(int) res->flags, size, alignment);
 
 	/* If it's not IO, then it's gotta be MEM */
-	align = (res->flags & IORESOURCE_IO) ? PCIBIOS_MIN_IO : PCIBIOS_MIN_MEM;
+	align = (resource_type(res) == IORESOURCE_IO) ? PCIBIOS_MIN_IO
+	  : PCIBIOS_MIN_MEM;
 
 	/* Align to largest of MIN or input size */
 	mask = max(alignment, align) - 1;
diff -puN arch/parisc/lib/iomap.c~resource-use-new-resource-type-changes arch/parisc/lib/iomap.c
--- a/arch/parisc/lib/iomap.c~resource-use-new-resource-type-changes
+++ a/arch/parisc/lib/iomap.c
@@ -441,14 +441,15 @@ void __iomem *pci_iomap(struct pci_dev *
 	resource_size_t start = pci_resource_start(dev, bar);
 	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
+	unsigned long type = flags & IORESOURCE_TYPE_BITS;
 
 	if (!len || !start)
 		return NULL;
 	if (maxlen && len > maxlen)
 		len = maxlen;
-	if (flags & IORESOURCE_IO)
+	if (type == IORESOURCE_IO)
 		return ioport_map(start, len);
-	if (flags & IORESOURCE_MEM) {
+	if (type == IORESOURCE_MEM) {
 		if (flags & IORESOURCE_CACHEABLE)
 			return ioremap(start, len);
 		return ioremap_nocache(start, len);
diff -puN arch/powerpc/kernel/iomap.c~resource-use-new-resource-type-changes arch/powerpc/kernel/iomap.c
--- a/arch/powerpc/kernel/iomap.c~resource-use-new-resource-type-changes
+++ a/arch/powerpc/kernel/iomap.c
@@ -122,14 +122,15 @@ void __iomem *pci_iomap(struct pci_dev *
 	resource_size_t start = pci_resource_start(dev, bar);
 	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
+	unsigned long type = flags & IORESOURCE_TYPE_BITS;
 
 	if (!len)
 		return NULL;
 	if (max && len > max)
 		len = max;
-	if (flags & IORESOURCE_IO)
+	if (type == IORESOURCE_IO)
 		return ioport_map(start, len);
-	if (flags & IORESOURCE_MEM)
+	if (type == IORESOURCE_MEM)
 		return ioremap(start, len);
 	/* What? */
 	return NULL;
diff -puN arch/powerpc/kernel/legacy_serial.c~resource-use-new-resource-type-changes arch/powerpc/kernel/legacy_serial.c
--- a/arch/powerpc/kernel/legacy_serial.c~resource-use-new-resource-type-changes
+++ a/arch/powerpc/kernel/legacy_serial.c
@@ -233,7 +233,7 @@ static int __init add_legacy_pci_port(st
 		return -1;
 
 	/* We only support BAR 0 for now */
-	iotype = (flags & IORESOURCE_MEM) ? UPIO_MEM : UPIO_PORT;
+	iotype = ((flags & IORESOURCE_TYPE_BITS) == IORESOURCE_MEM) ? UPIO_MEM : UPIO_PORT;
 	addr = of_translate_address(pci_dev, addrp);
 	if (addr == OF_BAD_ADDR)
 		return -1;
diff -puN arch/powerpc/kernel/pci-common.c~resource-use-new-resource-type-changes arch/powerpc/kernel/pci-common.c
--- a/arch/powerpc/kernel/pci-common.c~resource-use-new-resource-type-changes
+++ a/arch/powerpc/kernel/pci-common.c
@@ -305,10 +305,10 @@ static struct resource *__pci_mmap_make_
 
 		/* treat ROM as memory (should be already) */
 		if (i == PCI_ROM_RESOURCE)
-			flags |= IORESOURCE_MEM;
+			flags = IORESOURCE_MEM;
 
 		/* Active and same type? */
-		if ((flags & res_bit) == 0)
+		if ((flags & IORESOURCE_TYPE_BITS) != res_bit)
 			continue;
 
 		/* In the range of this resource? */
@@ -382,10 +382,9 @@ pgprot_t pci_phys_mem_access_prot(struct
 	for_each_pci_dev(pdev) {
 		for (i = 0; i <= PCI_ROM_RESOURCE; i++) {
 			struct resource *rp = &pdev->resource[i];
-			int flags = rp->flags;
 
 			/* Active and same type? */
-			if ((flags & IORESOURCE_MEM) == 0)
+			if (resource_type(rp) != IORESOURCE_MEM)
 				continue;
 			/* In the range of this resource? */
 			if (offset < (rp->start & PAGE_MASK) ||
@@ -451,7 +450,7 @@ void pci_resource_to_user(const struct p
 	if (hose == NULL)
 		return;
 
-	if (rsrc->flags & IORESOURCE_IO)
+	if (resource_type(rsrc) == IORESOURCE_IO)
 		offset = (unsigned long)hose->io_base_virt - _IO_BASE;
 
 	/* We pass a fully fixed up address to userland for MMIO instead of
@@ -472,7 +471,7 @@ void pci_resource_to_user(const struct p
 	 * BenH.
 	 */
 #if 0
-	else if (rsrc->flags & IORESOURCE_MEM)
+	else if (resource_type(rsrc) == IORESOURCE_MEM)
 		offset = hose->pci_mem_offset;
 #endif
 
@@ -680,10 +679,10 @@ void pcibios_resource_to_bus(struct pci_
 
 	if (!hose)
 		return;
-	if (res->flags & IORESOURCE_IO) {
+	if (resource_type(res) == IORESOURCE_IO) {
 		offset = (unsigned long)hose->io_base_virt - _IO_BASE;
 		mask = 0xffffffffu;
-	} else if (res->flags & IORESOURCE_MEM)
+	} else if (resource_type(res) == IORESOURCE_MEM)
 		offset = hose->pci_mem_offset;
 
 	region->start = (res->start - offset) & mask;
@@ -699,10 +698,10 @@ void pcibios_bus_to_resource(struct pci_
 
 	if (!hose)
 		return;
-	if (res->flags & IORESOURCE_IO) {
+	if (resource_type(res) == IORESOURCE_IO) {
 		offset = (unsigned long)hose->io_base_virt - _IO_BASE;
 		mask = 0xffffffffu;
-	} else if (res->flags & IORESOURCE_MEM)
+	} else if (resource_type(res) == IORESOURCE_MEM)
 		offset = hose->pci_mem_offset;
 	res->start = (region->start + offset) & mask;
 	res->end = (region->end + offset) & mask;
@@ -715,10 +714,10 @@ static void __devinit fixup_resource(str
 	struct pci_controller *hose = pci_bus_to_host(dev->bus);
 	resource_size_t offset = 0, mask = (resource_size_t)-1;
 
-	if (res->flags & IORESOURCE_IO) {
+	if (resource_type(res) == IORESOURCE_IO) {
 		offset = (unsigned long)hose->io_base_virt - _IO_BASE;
 		mask = 0xffffffffu;
-	} else if (res->flags & IORESOURCE_MEM)
+	} else if (resource_type(res) == IORESOURCE_MEM)
 		offset = hose->pci_mem_offset;
 
 	res->start = (res->start + offset) & mask;
@@ -813,7 +812,7 @@ static void __devinit __pcibios_fixup_bu
 			 * equal to the pci_mem_offset of the host bridge and
 			 * their size is smaller than 1M.
 			 */
-			if (res->flags & IORESOURCE_MEM &&
+			if (resource_type(res) == IORESOURCE_MEM &&
 			    res->start == hose->pci_mem_offset &&
 			    res->end < 0x100000) {
 				printk(KERN_INFO
@@ -895,7 +894,7 @@ void pcibios_align_resource(void *data, 
 {
 	struct pci_dev *dev = data;
 
-	if (res->flags & IORESOURCE_IO) {
+	if (resource_type(res) == IORESOURCE_IO) {
 		resource_size_t start = res->start;
 
 		if (skip_isa_ioresource_align(dev))
@@ -991,7 +990,7 @@ static void __init pcibios_allocate_bus_
 			    || res->start > res->end)
 				continue;
 			if (bus->parent == NULL)
-				pr = (res->flags & IORESOURCE_IO) ?
+				pr = (resource_type(res) == IORESOURCE_IO) ?
 					&ioport_resource : &iomem_resource;
 			else {
 				/* Don't bother with non-root busses when
@@ -1085,7 +1084,7 @@ static void __init pcibios_allocate_reso
 				continue;
 			if (!r->flags || (r->flags & IORESOURCE_UNSET))
 				continue;	/* Not assigned at all */
-			if (r->flags & IORESOURCE_IO)
+			if (resource_type(r) == IORESOURCE_IO)
 				disabled = !(command & PCI_COMMAND_IO);
 			else
 				disabled = !(command & PCI_COMMAND_MEMORY);
diff -puN arch/powerpc/kernel/pci_64.c~resource-use-new-resource-type-changes arch/powerpc/kernel/pci_64.c
--- a/arch/powerpc/kernel/pci_64.c~resource-use-new-resource-type-changes
+++ a/arch/powerpc/kernel/pci_64.c
@@ -316,7 +316,7 @@ void __devinit of_scan_pci_bridge(struct
 		size = of_read_number(&ranges[6], 2);
 		if (flags == 0 || size == 0)
 			continue;
-		if (flags & IORESOURCE_IO) {
+		if ((flags & IORESOUCE_TYPE_BITS) == IORESOURCE_IO) {
 			res = bus->resource[0];
 			if (res->flags) {
 				printk(KERN_ERR "PCI: ignoring extra I/O range"
diff -puN arch/powerpc/kernel/prom_parse.c~resource-use-new-resource-type-changes arch/powerpc/kernel/prom_parse.c
--- a/arch/powerpc/kernel/prom_parse.c~resource-use-new-resource-type-changes
+++ a/arch/powerpc/kernel/prom_parse.c
@@ -614,13 +614,13 @@ static int __of_address_to_resource(stru
 {
 	u64 taddr;
 
-	if ((flags & (IORESOURCE_IO | IORESOURCE_MEM)) == 0)
+	if (flags != IORESOURCE_IO && flags != IORESOURCE_MEM)
 		return -EINVAL;
 	taddr = of_translate_address(dev, addrp);
 	if (taddr == OF_BAD_ADDR)
 		return -EINVAL;
 	memset(r, 0, sizeof(struct resource));
-	if (flags & IORESOURCE_IO) {
+	if (flags == IORESOURCE_IO) {
 		unsigned long port;
 		port = pci_address_to_pio(taddr);
 		if (port == (unsigned long)-1)
diff -puN arch/powerpc/platforms/fsl_uli1575.c~resource-use-new-resource-type-changes arch/powerpc/platforms/fsl_uli1575.c
--- a/arch/powerpc/platforms/fsl_uli1575.c~resource-use-new-resource-type-changes
+++ a/arch/powerpc/platforms/fsl_uli1575.c
@@ -222,7 +222,7 @@ static void __devinit quirk_final_uli524
 
 	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
 		if ((bus->resource[i]) &&
-			(bus->resource[i]->flags & IORESOURCE_MEM)) {
+			(resource_type(bus->resource[i]) == IORESOURCE_MEM)) {
 			dummy = ioremap(bus->resource[i]->end - 3, 0x4);
 			if (dummy) {
 				in_8(dummy);
diff -puN arch/powerpc/platforms/maple/setup.c~resource-use-new-resource-type-changes arch/powerpc/platforms/maple/setup.c
--- a/arch/powerpc/platforms/maple/setup.c~resource-use-new-resource-type-changes
+++ a/arch/powerpc/platforms/maple/setup.c
@@ -85,7 +85,7 @@ static unsigned long maple_find_nvram_ba
 			       " address\n");
 			goto bail;
 		}
-		if (!(r.flags & IORESOURCE_IO)) {
+		if (resource_type(&r) != IORESOURCE_IO) {
 			printk(KERN_EMERG "Maple: NVRAM address isn't PIO!\n");
 			goto bail;
 		}
diff -puN arch/powerpc/platforms/maple/time.c~resource-use-new-resource-type-changes arch/powerpc/platforms/maple/time.c
--- a/arch/powerpc/platforms/maple/time.c~resource-use-new-resource-type-changes
+++ a/arch/powerpc/platforms/maple/time.c
@@ -151,7 +151,7 @@ unsigned long __init maple_get_boot_time
 			       " address\n");
 			goto bail;
 		}
-		if (!(r.flags & IORESOURCE_IO)) {
+		if (resource_type(&r) != IORESOURCE_IO) {
 			printk(KERN_EMERG "Maple: RTC address isn't PIO!\n");
 			goto bail;
 		}
diff -puN arch/powerpc/platforms/pseries/eeh_cache.c~resource-use-new-resource-type-changes arch/powerpc/platforms/pseries/eeh_cache.c
--- a/arch/powerpc/platforms/pseries/eeh_cache.c~resource-use-new-resource-type-changes
+++ a/arch/powerpc/platforms/pseries/eeh_cache.c
@@ -120,7 +120,7 @@ static void pci_addr_cache_print(struct 
 		struct pci_io_addr_range *piar;
 		piar = rb_entry(n, struct pci_io_addr_range, rb_node);
 		printk(KERN_DEBUG "PCI: %s addr range %d [%lx-%lx]: %s\n",
-		       (piar->flags & IORESOURCE_IO) ? "i/o" : "mem", cnt,
+		       ((piar->flags & IORESOURCE_TYPE_BITS) == IORESOURCE_IO) ? "i/o" : "mem", cnt,
 		       piar->addr_lo, piar->addr_hi, pci_name(piar->pcidev));
 		cnt++;
 		n = rb_next(n);
@@ -202,9 +202,10 @@ static void __pci_addr_cache_insert_devi
 		unsigned long start = pci_resource_start(dev,i);
 		unsigned long end = pci_resource_end(dev,i);
 		unsigned int flags = pci_resource_flags(dev,i);
+		unsigned int type = flags & IORESOURCE_TYPE_BITS;
 
 		/* We are interested only bus addresses, not dma or other stuff */
-		if (0 == (flags & (IORESOURCE_IO | IORESOURCE_MEM)))
+		if (type != IORESOURCE_IO | type != IORESOURCE_MEM)
 			continue;
 		if (start == 0 || ~start == 0 || end == 0 || ~end == 0)
 			 continue;
diff -puN arch/powerpc/platforms/pseries/pci.c~resource-use-new-resource-type-changes arch/powerpc/platforms/pseries/pci.c
--- a/arch/powerpc/platforms/pseries/pci.c~resource-use-new-resource-type-changes
+++ a/arch/powerpc/platforms/pseries/pci.c
@@ -96,9 +96,9 @@ static void fixup_winbond_82c105(struct 
 
 	for (i = 0; i < DEVICE_COUNT_RESOURCE; ++i) {
 		/* zap the 2nd function of the winbond chip */
-		if (dev->resource[i].flags & IORESOURCE_IO
+		if (resource_type(&dev->resource[i]) == IORESOURCE_IO
 		    && dev->bus->number == 0 && dev->devfn == 0x81)
-			dev->resource[i].flags &= ~IORESOURCE_IO;
+			dev->resource[i].flags &= ~IORESOURCE_TYPE_BITS;
 		if (dev->resource[i].start == 0 && dev->resource[i].end) {
 			dev->resource[i].flags = 0;
 			dev->resource[i].end = 0;
diff -puN arch/powerpc/sysdev/fsl_pci.c~resource-use-new-resource-type-changes arch/powerpc/sysdev/fsl_pci.c
--- a/arch/powerpc/sysdev/fsl_pci.c~resource-use-new-resource-type-changes
+++ a/arch/powerpc/sysdev/fsl_pci.c
@@ -46,7 +46,7 @@ void __init setup_pci_atmu(struct pci_co
 
 	/* Setup outbound MEM window */
 	for(i = 0; i < 3; i++)
-		if (hose->mem_resources[i].flags & IORESOURCE_MEM){
+		if (resource_type(&hose->mem_resources[i]) == IORESOURCE_MEM){
 			resource_size_t pci_addr_start =
 				 hose->mem_resources[i].start -
 				 hose->pci_mem_offset;
@@ -65,7 +65,7 @@ void __init setup_pci_atmu(struct pci_co
 		}
 
 	/* Setup outbound IO window */
-	if (hose->io_resource.flags & IORESOURCE_IO){
+	if (resource_type(&hose->io_resource) == IORESOURCE_IO){
 		pr_debug("PCI IO resource start 0x%016llx, size 0x%016llx, "
 			 "phy base 0x%016llx.\n",
 			(u64)hose->io_resource.start,
diff -puN arch/powerpc/sysdev/ppc4xx_pci.c~resource-use-new-resource-type-changes arch/powerpc/sysdev/ppc4xx_pci.c
--- a/arch/powerpc/sysdev/ppc4xx_pci.c~resource-use-new-resource-type-changes
+++ a/arch/powerpc/sysdev/ppc4xx_pci.c
@@ -210,7 +210,7 @@ static void __init ppc4xx_configure_pci_
 		struct resource *res = &hose->mem_resources[i];
 
 		/* we only care about memory windows */
-		if (!(res->flags & IORESOURCE_MEM))
+		if (resource_type(res) != IORESOURCE_MEM)
 			continue;
 		if (j > 2) {
 			printk(KERN_WARNING "%s: Too many ranges\n",
@@ -361,7 +361,7 @@ static void __init ppc4xx_configure_pcix
 		struct resource *res = &hose->mem_resources[i];
 
 		/* we only care about memory windows */
-		if (!(res->flags & IORESOURCE_MEM))
+		if (resource_type(res) != IORESOURCE_MEM)
 			continue;
 		if (j > 1) {
 			printk(KERN_WARNING "%s: Too many ranges\n",
@@ -1327,7 +1327,7 @@ static void __init ppc4xx_configure_pcie
 		struct resource *res = &hose->mem_resources[i];
 
 		/* we only care about memory windows */
-		if (!(res->flags & IORESOURCE_MEM))
+		if (resource_type(res) != IORESOURCE_MEM)
 			continue;
 		if (j > 1) {
 			printk(KERN_WARNING "%s: Too many ranges\n",
@@ -1372,7 +1372,7 @@ static void __init ppc4xx_configure_pcie
 	}
 
 	/* Configure IO, always 64K starting at 0 */
-	if (hose->io_resource.flags & IORESOURCE_IO) {
+	if (resource_type(&hose->io_resource) == IORESOURCE_IO) {
 		lah = RES_TO_U32_HIGH(hose->io_base_phys);
 		lal = RES_TO_U32_LOW(hose->io_base_phys);
 		out_le32(mbase + PECFG_POM2LAH, 0);
diff -puN arch/sh/drivers/pci/pci.c~resource-use-new-resource-type-changes arch/sh/drivers/pci/pci.c
--- a/arch/sh/drivers/pci/pci.c~resource-use-new-resource-type-changes
+++ a/arch/sh/drivers/pci/pci.c
@@ -89,7 +89,7 @@ void pcibios_align_resource(void *data, 
 void pcibios_align_resource(void *data, struct resource *res,
 			    resource_size_t size, resource_size_t align)
 {
-	if (res->flags & IORESOURCE_IO) {
+	if (resource_type(res) == IORESOURCE_IO) {
 		resource_size_t start = res->start;
 
 		if (start & 0x300) {
@@ -116,9 +116,9 @@ int pcibios_enable_device(struct pci_dev
 			       "of resource collisions\n", pci_name(dev));
 			return -EINVAL;
 		}
-		if (r->flags & IORESOURCE_IO)
+		if (resource_type(r) == IORESOURCE_IO)
 			cmd |= PCI_COMMAND_IO;
-		if (r->flags & IORESOURCE_MEM)
+		if (resource_type(r) == IORESOURCE_MEM)
 			cmd |= PCI_COMMAND_MEMORY;
 	}
 	if (dev->resource[PCI_ROM_RESOURCE].start)
@@ -162,6 +162,7 @@ void __iomem *pci_iomap(struct pci_dev *
 	resource_size_t start = pci_resource_start(dev, bar);
 	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
+	unsigned long type = flags & IORESOURCE_TYPE_BITS;
 
 	if (unlikely(!len || !start))
 		return NULL;
@@ -178,9 +179,9 @@ void __iomem *pci_iomap(struct pci_dev *
 	 * punted off to __ioremap().
 	 *					-- PFM.
 	 */
-	if (flags & IORESOURCE_IO)
+	if (type == IORESOURCE_IO)
 		return ioport_map(start, len);
-	if (flags & IORESOURCE_MEM)
+	if (type == IORESOURCE_MEM)
 		return ioremap(start, len);
 
 	return NULL;
diff -puN arch/sh/kernel/io_trapped.c~resource-use-new-resource-type-changes arch/sh/kernel/io_trapped.c
--- a/arch/sh/kernel/io_trapped.c~resource-use-new-resource-type-changes
+++ a/arch/sh/kernel/io_trapped.c
@@ -70,7 +70,7 @@ int register_trapped_io(struct trapped_i
 		res = tiop->resource + k;
 		pr_info("trapped io 0x%08lx overrides %s 0x%08lx\n",
 		       (unsigned long)(tiop->virt_base + len),
-		       res->flags & IORESOURCE_IO ? "io" : "mmio",
+			resource_type(res) == IORESOURCE_IO ? "io" : "mmio",
 		       (unsigned long)res->start);
 		len += roundup((res->end - res->start) + 1, PAGE_SIZE);
 	}
@@ -78,10 +78,14 @@ int register_trapped_io(struct trapped_i
 	tiop->magic = IO_TRAPPED_MAGIC;
 	INIT_LIST_HEAD(&tiop->list);
 	spin_lock_irq(&trapped_lock);
-	if (flags & IORESOURCE_IO)
+	switch(flags & IORESOURCE_TYPE_BITS) {
+	case IORESOURCE_IO:
 		list_add(&tiop->list, &trapped_io);
-	if (flags & IORESOURCE_MEM)
+		break;
+	case IORESOURCE_MEM:
 		list_add(&tiop->list, &trapped_mem);
+		break;
+	}
 	spin_unlock_irq(&trapped_lock);
 
 	return 0;
diff -puN arch/sparc/kernel/of_device.c~resource-use-new-resource-type-changes arch/sparc/kernel/of_device.c
--- a/arch/sparc/kernel/of_device.c~resource-use-new-resource-type-changes
+++ a/arch/sparc/kernel/of_device.c
@@ -202,6 +202,7 @@ static unsigned int of_bus_pci_get_flags
 	switch((w >> 24) & 0x03) {
 	case 0x01:
 		flags |= IORESOURCE_IO;
+		break;
 	case 0x02: /* 32 bits */
 	case 0x03: /* 64 bits */
 		flags |= IORESOURCE_MEM;
diff -puN arch/sparc/kernel/pcic.c~resource-use-new-resource-type-changes arch/sparc/kernel/pcic.c
--- a/arch/sparc/kernel/pcic.c~resource-use-new-resource-type-changes
+++ a/arch/sparc/kernel/pcic.c
@@ -482,7 +482,7 @@ static void pcic_map_pci_device(struct l
 		address = dev->resource[j].start;
 		if (address == 0) break;	/* are sequential */
 		flags = dev->resource[j].flags;
-		if ((flags & IORESOURCE_IO) != 0) {
+		if (resource_type(&dev->resource[j]) == IORESOURCE_IO) {
 			if (address < 0x10000) {
 				/*
 				 * A device responds to I/O cycles on PCI.
@@ -508,8 +508,8 @@ static void pcic_map_pci_device(struct l
 				dev->resource[j].start =
 				    pcic->pcic_io + address;
 				dev->resource[j].end = 1;  /* XXX */
-				dev->resource[j].flags =
-				    (flags & ~IORESOURCE_IO) | IORESOURCE_MEM;
+				dev->resource[j].flags = IORESOURCE_MEM |
+				    (flags & ~IORESOURCE_TYPE_BITS);
 			} else {
 				/*
 				 * OOPS... PCI Spec allows this. Sun does
@@ -636,10 +636,10 @@ void __devinit pcibios_fixup_bus(struct 
 		 */
 		has_io = has_mem = 0;
 		for(i=0; i<6; i++) {
-			unsigned long f = dev->resource[i].flags;
-			if (f & IORESOURCE_IO) {
+			unsigned long type = resource_type(&dev->resource[i]);
+			if (type == IORESOURCE_IO) {
 				has_io = 1;
-			} else if (f & IORESOURCE_MEM)
+			} else if (type == IORESOURCE_MEM)
 				has_mem = 1;
 		}
 		pcic_read_config(dev->bus, dev->devfn, PCI_COMMAND, 2, &cmd);
diff -puN arch/sparc/lib/iomap.c~resource-use-new-resource-type-changes arch/sparc/lib/iomap.c
--- a/arch/sparc/lib/iomap.c~resource-use-new-resource-type-changes
+++ a/arch/sparc/lib/iomap.c
@@ -24,14 +24,15 @@ void __iomem *pci_iomap(struct pci_dev *
 	resource_size_t start = pci_resource_start(dev, bar);
 	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
+	unsigned long type = flags & IORESOURCE_TYPE_BITS;
 
 	if (!len || !start)
 		return NULL;
 	if (maxlen && len > maxlen)
 		len = maxlen;
-	if (flags & IORESOURCE_IO)
+	if (type == IORESOURCE_IO)
 		return ioport_map(start, len);
-	if (flags & IORESOURCE_MEM) {
+	if (type == IORESOURCE_MEM) {
 		if (flags & IORESOURCE_CACHEABLE)
 			return ioremap(start, len);
 		return ioremap_nocache(start, len);
diff -puN arch/sparc64/kernel/of_device.c~resource-use-new-resource-type-changes arch/sparc64/kernel/of_device.c
--- a/arch/sparc64/kernel/of_device.c~resource-use-new-resource-type-changes
+++ a/arch/sparc64/kernel/of_device.c
@@ -15,7 +15,7 @@ void __iomem *of_ioremap(struct resource
 	unsigned long ret = res->start + offset;
 	struct resource *r;
 
-	if (res->flags & IORESOURCE_MEM)
+	if (resource_type(res) == IORESOURCE_MEM)
 		r = request_mem_region(ret, size, name);
 	else
 		r = request_region(ret, size, name);
@@ -28,7 +28,7 @@ EXPORT_SYMBOL(of_ioremap);
 
 void of_iounmap(struct resource *res, void __iomem *base, unsigned long size)
 {
-	if (res->flags & IORESOURCE_MEM)
+	if (resource_type(res) == IORESOURCE_MEM)
 		release_mem_region((unsigned long) base, size);
 	else
 		release_region((unsigned long) base, size);
@@ -260,6 +260,7 @@ static unsigned int of_bus_pci_get_flags
 	switch((w >> 24) & 0x03) {
 	case 0x01:
 		flags |= IORESOURCE_IO;
+		break;
 	case 0x02: /* 32 bits */
 	case 0x03: /* 64 bits */
 		flags |= IORESOURCE_MEM;
diff -puN arch/sparc64/kernel/pci.c~resource-use-new-resource-type-changes arch/sparc64/kernel/pci.c
--- a/arch/sparc64/kernel/pci.c~resource-use-new-resource-type-changes
+++ a/arch/sparc64/kernel/pci.c
@@ -656,7 +656,7 @@ static void __devinit of_scan_pci_bridge
 		size = GET_64BIT(ranges, 6);
 		if (flags == 0 || size == 0)
 			continue;
-		if (flags & IORESOURCE_IO) {
+		if ((flags & IORESOUCE_TYPE_BITS) == IORESOURCE_IO) {
 			res = bus->resource[0];
 			if (res->flags) {
 				printk(KERN_ERR "PCI: ignoring extra I/O range"
@@ -844,9 +844,9 @@ struct resource *pcibios_select_root(str
 	struct pci_pbm_info *pbm = pdev->bus->sysdata;
 	struct resource *root = NULL;
 
-	if (r->flags & IORESOURCE_IO)
+	if (resource_type(r) == IORESOURCE_IO)
 		root = &pbm->io_space;
-	if (r->flags & IORESOURCE_MEM)
+	if (resource_type(r) == IORESOURCE_MEM)
 		root = &pbm->mem_space;
 
 	return root;
@@ -876,9 +876,9 @@ int pcibios_enable_device(struct pci_dev
 		if (!(mask & (1<<i)))
 			continue;
 
-		if (res->flags & IORESOURCE_IO)
+		if (resource_type(res) == IORESOURCE_IO)
 			cmd |= PCI_COMMAND_IO;
-		if (res->flags & IORESOURCE_MEM)
+		if (resource_type(res) == IORESOURCE_MEM)
 			cmd |= PCI_COMMAND_MEMORY;
 	}
 
@@ -901,7 +901,7 @@ void pcibios_resource_to_bus(struct pci_
 	zero_res.end = 0;
 	zero_res.flags = res->flags;
 
-	if (res->flags & IORESOURCE_IO)
+	if (resource_type(res) == IORESOURCE_IO)
 		root = &pbm->io_space;
 	else
 		root = &pbm->mem_space;
@@ -922,7 +922,7 @@ void pcibios_bus_to_resource(struct pci_
 	res->start = region->start;
 	res->end = region->end;
 
-	if (res->flags & IORESOURCE_IO)
+	if (resource_type(res) == IORESOURCE_IO)
 		root = &pbm->io_space;
 	else
 		root = &pbm->mem_space;
@@ -1017,6 +1017,7 @@ static int __pci_mmap_make_offset(struct
 
 	for (i = 0; i <= PCI_ROM_RESOURCE; i++) {
 		struct resource *rp = &pdev->resource[i];
+		unsigned long type = resource_type(rp);
 
 		/* Active? */
 		if (!rp->flags)
@@ -1028,9 +1029,9 @@ static int __pci_mmap_make_offset(struct
 				continue;
 		} else {
 			if ((mmap_state == pci_mmap_io &&
-			     (rp->flags & IORESOURCE_IO) == 0) ||
+			     type != IORESOURCE_IO) ||
 			    (mmap_state == pci_mmap_mem &&
-			     (rp->flags & IORESOURCE_MEM) == 0))
+			     type != IORESOURCE_MEM))
 				continue;
 		}
 
@@ -1207,7 +1208,7 @@ void pci_resource_to_user(const struct p
 	struct pci_pbm_info *pbm = pdev->dev.archdata.host_controller;
 	unsigned long offset;
 
-	if (rp->flags & IORESOURCE_IO)
+	if (resource_type(rp) == IORESOURCE_IO)
 		offset = pbm->io_space.start;
 	else
 		offset = pbm->mem_space.start;
diff -puN arch/sparc64/lib/iomap.c~resource-use-new-resource-type-changes arch/sparc64/lib/iomap.c
--- a/arch/sparc64/lib/iomap.c~resource-use-new-resource-type-changes
+++ a/arch/sparc64/lib/iomap.c
@@ -24,14 +24,15 @@ void __iomem *pci_iomap(struct pci_dev *
 	resource_size_t start = pci_resource_start(dev, bar);
 	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
+	unsigned long type = flags & IORESOURCE_TYPE_BITS;
 
 	if (!len || !start)
 		return NULL;
 	if (maxlen && len > maxlen)
 		len = maxlen;
-	if (flags & IORESOURCE_IO)
+	if (type == IORESOURCE_IO)
 		return ioport_map(start, len);
-	if (flags & IORESOURCE_MEM) {
+	if (type == IORESOURCE_MEM) {
 		if (flags & IORESOURCE_CACHEABLE)
 			return ioremap(start, len);
 		return ioremap_nocache(start, len);
diff -puN arch/x86/kernel/pci-calgary_64.c~resource-use-new-resource-type-changes arch/x86/kernel/pci-calgary_64.c
--- a/arch/x86/kernel/pci-calgary_64.c~resource-use-new-resource-type-changes
+++ a/arch/x86/kernel/pci-calgary_64.c
@@ -1522,7 +1522,7 @@ static void __init calgary_fixup_one_tce
 		struct resource *r = &dev->resource[PCI_BRIDGE_RESOURCES + i];
 
 		/* Don't give out TCEs that map MEM resources */
-		if (!(r->flags & IORESOURCE_MEM))
+		if (resource_type(r) != IORESOURCE_MEM)
 			continue;
 
 		/* 0-based? we reserve the whole 1st MB anyway */
diff -puN arch/x86/pci/i386.c~resource-use-new-resource-type-changes arch/x86/pci/i386.c
--- a/arch/x86/pci/i386.c~resource-use-new-resource-type-changes
+++ a/arch/x86/pci/i386.c
@@ -64,7 +64,7 @@ pcibios_align_resource(void *data, struc
 {
 	struct pci_dev *dev = data;
 
-	if (res->flags & IORESOURCE_IO) {
+	if (resource_type(res) == IORESOURCE_IO) {
 		resource_size_t start = res->start;
 
 		if (skip_isa_ioresource_align(dev))
@@ -159,7 +159,7 @@ static void __init pcibios_allocate_reso
 				continue;
 			if (!r->start)		/* Address not assigned at all */
 				continue;
-			if (r->flags & IORESOURCE_IO)
+			if (resource_type(r) == IORESOURCE_IO)
 				disabled = !(command & PCI_COMMAND_IO);
 			else
 				disabled = !(command & PCI_COMMAND_MEMORY);
diff -puN arch/xtensa/kernel/pci.c~resource-use-new-resource-type-changes arch/xtensa/kernel/pci.c
--- a/arch/xtensa/kernel/pci.c~resource-use-new-resource-type-changes
+++ a/arch/xtensa/kernel/pci.c
@@ -75,7 +75,7 @@ pcibios_align_resource(void *data, struc
 {
 	struct pci_dev *dev = data;
 
-	if (res->flags & IORESOURCE_IO) {
+	if (resource_type(res) == IORESOURCE_IO) {
 		resource_size_t start = res->start;
 
 		if (size > 0x100) {
@@ -107,9 +107,9 @@ pcibios_enable_resources(struct pci_dev 
 				"of resource collisions\n", pci_name(dev));
 			return -EINVAL;
 		}
-		if (r->flags & IORESOURCE_IO)
+		if (resource_type(r) == IORESOURCE_IO)
 			cmd |= PCI_COMMAND_IO;
-		if (r->flags & IORESOURCE_MEM)
+		if (resource_type(r) == IORESOURCE_MEM)
 			cmd |= PCI_COMMAND_MEMORY;
 	}
 	if (dev->resource[PCI_ROM_RESOURCE].start)
@@ -215,7 +215,7 @@ void __init pcibios_fixup_bus(struct pci
 		for (i = 0; i < 4; i++) {
 			if ((res = bus->resource[i]) == NULL || !res->flags)
 				continue;
-			if (io_offset && (res->flags & IORESOURCE_IO)) {
+			if (io_offset && resource_type(res) == IORESOURCE_IO)) {
 				res->start += io_offset;
 				res->end += io_offset;
 			}
@@ -251,9 +251,9 @@ int pcibios_enable_device(struct pci_dev
 			       "of resource collisions\n", pci_name(dev));
 			return -EINVAL;
 		}
-		if (r->flags & IORESOURCE_IO)
+		if (resource_type(r) == IORESOURCE_IO)
 			cmd |= PCI_COMMAND_IO;
-		if (r->flags & IORESOURCE_MEM)
+		if (resource_type(r) == IORESOURCE_MEM)
 			cmd |= PCI_COMMAND_MEMORY;
 	}
 	if (cmd != old_cmd) {
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

linux-next.patch
video-superh-mobile-lcdc-driver.patch
video-superh-mobile-lcdc-driver-update.patch
resource-use-new-resource-type-changes.patch
resource-add-new-ioresource_clk-type.patch

