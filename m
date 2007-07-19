From: akpm@linux-foundation.org
Subject: - x86-64-calgary-introduce-calioc2-support.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:09:13 -0700
Message-ID: <200707192009.l6JK9D8t020558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53371 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761149AbXGSUPo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muli@il.ibm.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86-64: Calgary: introduce CalIOC2 support
has been removed from the -mm tree.  Its filename was
     x86-64-calgary-introduce-calioc2-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86-64: Calgary: introduce CalIOC2 support
From: Muli Ben-Yehuda <muli@il.ibm.com>

CalIOC2 is a PCI-e implementation of the Calgary logic. Most of the
programming details are the same, but some differ, e.g., TCE cache
flush. This patch introduces CalIOC2 support - detection and various
support routines. It's not expected to work yet (but will with
follow-on patches).

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |  196 +++++++++++++++++++++++------
 1 files changed, 156 insertions(+), 40 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-introduce-calioc2-support arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-introduce-calioc2-support
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -50,8 +50,7 @@ int use_calgary __read_mostly = 0;
 #endif /* CONFIG_CALGARY_DEFAULT_ENABLED */
 
 #define PCI_DEVICE_ID_IBM_CALGARY 0x02a1
-#define PCI_VENDOR_DEVICE_ID_CALGARY \
-	(PCI_VENDOR_ID_IBM | PCI_DEVICE_ID_IBM_CALGARY << 16)
+#define PCI_DEVICE_ID_IBM_CALIOC2 0x0308
 
 /* we need these for register space address calculation */
 #define START_ADDRESS           0xfe000000
@@ -193,6 +192,7 @@ static inline unsigned long verify_bit_r
 {
 	return ~0UL;
 }
+
 #endif /* CONFIG_IOMMU_DEBUG */
 
 static inline unsigned int num_dma_pages(unsigned long dma, unsigned int dmalen)
@@ -346,9 +346,20 @@ static void iommu_free(struct iommu_tabl
 
 static inline struct iommu_table *find_iommu_table(struct device *dev)
 {
+	struct pci_dev *pdev;
+	struct pci_bus *pbus;
 	struct iommu_table *tbl;
 
-	tbl = to_pci_dev(dev)->bus->self->sysdata;
+	pdev = to_pci_dev(dev);
+
+	/* is the device behind a bridge? */
+	if (unlikely(pdev->bus->parent))
+		pbus = pdev->bus->parent;
+	else
+		pbus = pdev->bus;
+
+	tbl = pbus->self->sysdata;
+	BUG_ON(pdev->bus->parent && (tbl->it_busno != pdev->bus->parent->number));
 
 	return tbl;
 }
@@ -565,6 +576,21 @@ static inline void __iomem* calgary_reg(
 	return (void __iomem*)target;
 }
 
+static inline int is_calioc2(unsigned short device)
+{
+	return (device == PCI_DEVICE_ID_IBM_CALIOC2);
+}
+
+static inline int is_calgary(unsigned short device)
+{
+	return (device == PCI_DEVICE_ID_IBM_CALGARY);
+}
+
+static inline int is_cal_pci_dev(unsigned short device)
+{
+	return (is_calgary(device) || is_calioc2(device));
+}
+
 static void calgary_tce_cache_blast(struct iommu_table *tbl)
 {
 	u64 val;
@@ -685,8 +711,14 @@ static void __init calgary_reserve_regio
 	iommu_range_reserve(tbl, bad_dma_address, EMERGENCY_PAGES);
 
 	/* avoid the BIOS/VGA first 640KB-1MB region */
-	start = (640 * 1024);
-	npages = ((1024 - 640) * 1024) >> PAGE_SHIFT;
+	/* for CalIOC2 - avoid the entire first 2MB */
+	if (is_calgary(dev->device)) {
+		start = (640 * 1024);
+		npages = ((1024 - 640) * 1024) >> PAGE_SHIFT;
+	} else { /* calioc2 */
+		start = 0;
+		npages = (2 * 1024 * 1024) >> PAGE_SHIFT;
+	}
 	iommu_range_reserve(tbl, start, npages);
 
 	/* reserve the two PCI peripheral memory regions in IO space */
@@ -721,15 +753,15 @@ static int __init calgary_setup_tar(stru
 
 	/* zero out all TAR bits under sw control */
 	val64 &= ~TAR_SW_BITS;
-
-	tbl = dev->sysdata;
 	table_phys = (u64)__pa(tbl->it_base);
+
 	val64 |= table_phys;
 
 	BUG_ON(specified_table_size > TCE_TABLE_SIZE_8M);
 	val64 |= (u64) specified_table_size;
 
 	tbl->tar_val = cpu_to_be64(val64);
+
 	writeq(tbl->tar_val, target);
 	readq(target); /* flush */
 
@@ -760,6 +792,43 @@ static void __init calgary_free_bus(stru
 	bus_info[dev->bus->number].tce_space = NULL;
 }
 
+static void calgary_dump_error_regs(struct iommu_table *tbl)
+{
+	void __iomem *bbar = tbl->bbar;
+	u32 csr, csmr, plssr, mck;
+	void __iomem *target;
+	unsigned long phboff = phb_offset(tbl->it_busno);
+	unsigned long erroff;
+	u32 errregs[7];
+	int i;
+
+	/* dump CSR */
+	target = calgary_reg(bbar, phboff | PHB_CSR_OFFSET);
+	csr = be32_to_cpu(readl(target));
+	/* dump PLSSR */
+	target = calgary_reg(bbar, phboff | PHB_PLSSR_OFFSET);
+	plssr = be32_to_cpu(readl(target));
+	/* dump CSMR */
+	target = calgary_reg(bbar, phboff | 0x290);
+	csmr = be32_to_cpu(readl(target));
+	/* dump mck */
+	target = calgary_reg(bbar, phboff | 0x800);
+	mck = be32_to_cpu(readl(target));
+
+	printk(KERN_EMERG "Calgary: 0x%08x@CSR 0x%08x@PLSSR 0x%08x@CSMR "
+	       "0x%08x@MCK\n", csr, plssr, csmr, mck);
+
+	/* dump rest of error regs */
+	printk(KERN_EMERG "Calgary: ");
+	for (i = 0; i < ARRAY_SIZE(errregs); i++) {
+		erroff = (0x810 + (i * 0x10)); /* err regs are at 0x810 - 0x870 */
+		target = calgary_reg(bbar, phboff | erroff);
+		errregs[i] = be32_to_cpu(readl(target));
+		printk("0x%08x@0x%lx ", errregs[i], erroff);
+	}
+	printk("\n");
+}
+
 static void calgary_watchdog(unsigned long data)
 {
 	struct pci_dev *dev = (struct pci_dev *)data;
@@ -773,13 +842,16 @@ static void calgary_watchdog(unsigned lo
 
 	/* If no error, the agent ID in the CSR is not valid */
 	if (val32 & CSR_AGENT_MASK) {
-		printk(KERN_EMERG "calgary_watchdog: DMA error on PHB %#x, "
-				  "CSR = %#x\n", dev->bus->number, val32);
+		printk(KERN_EMERG "Calgary: DMA error on PHB %#x\n",
+		       dev->bus->number);
+		calgary_dump_error_regs(tbl);
+
+		/* reset error */
 		writel(0, target);
 
 		/* Disable bus that caused the error */
 		target = calgary_reg(bbar, phb_offset(tbl->it_busno) |
-					   PHB_CONFIG_RW_OFFSET);
+				     PHB_CONFIG_RW_OFFSET);
 		val32 = be32_to_cpu(readl(target));
 		val32 |= PHB_SLOT_DISABLE;
 		writel(cpu_to_be32(val32), target);
@@ -853,7 +925,9 @@ static void __init calgary_enable_transl
 	val32 = be32_to_cpu(readl(target));
 	val32 |= PHB_TCE_ENABLE | PHB_DAC_DISABLE | PHB_MCSR_ENABLE;
 
-	printk(KERN_INFO "Calgary: enabling translation on PHB %#x\n", busnum);
+	printk(KERN_INFO "Calgary: enabling translation on %s PHB %#x\n",
+	       (dev->device == PCI_DEVICE_ID_IBM_CALGARY) ?
+	       "Calgary" : "CalIOC2", busnum);
 	printk(KERN_INFO "Calgary: errant DMAs will now be prevented on this "
 	       "bus.\n");
 
@@ -894,7 +968,12 @@ static void __init calgary_init_one_nont
 {
 	pci_dev_get(dev);
 	dev->sysdata = NULL;
-	dev->bus->self = dev;
+
+	/* is the device behind a bridge? */
+	if (dev->bus->parent)
+		dev->bus->parent->self = dev;
+	else
+		dev->bus->self = dev;
 }
 
 static int __init calgary_init_one(struct pci_dev *dev)
@@ -911,7 +990,14 @@ static int __init calgary_init_one(struc
 		goto done;
 
 	pci_dev_get(dev);
-	dev->bus->self = dev;
+
+	if (dev->bus->parent) {
+		if (dev->bus->parent->self)
+			printk(KERN_WARNING "Calgary: IEEEE, dev %p has "
+			       "bus->parent->self!\n", dev);
+		dev->bus->parent->self = dev;
+	} else
+		dev->bus->self = dev;
 
 	tbl = dev->sysdata;
 	tbl->chip_ops->handle_quirks(tbl, dev);
@@ -951,11 +1037,18 @@ static int __init calgary_locate_bbars(v
 			target = calgary_reg(bbar, offset);
 
 			val = be32_to_cpu(readl(target));
+
 			start_bus = (u8)((val & 0x00FF0000) >> 16);
 			end_bus = (u8)((val & 0x0000FF00) >> 8);
-			for (bus = start_bus; bus <= end_bus; bus++) {
-				bus_info[bus].bbar = bbar;
-				bus_info[bus].phbid = phb;
+
+			if (end_bus) {
+				for (bus = start_bus; bus <= end_bus; bus++) {
+					bus_info[bus].bbar = bbar;
+					bus_info[bus].phbid = phb;
+				}
+			} else {
+				bus_info[start_bus].bbar = bbar;
+				bus_info[start_bus].phbid = phb;
 			}
 		}
 	}
@@ -975,24 +1068,27 @@ static int __init calgary_init(void)
 {
 	int ret;
 	struct pci_dev *dev = NULL;
+	void* tce_space;
 
 	ret = calgary_locate_bbars();
 	if (ret)
 		return ret;
 
 	do {
-		dev = pci_get_device(PCI_VENDOR_ID_IBM,
-				     PCI_DEVICE_ID_IBM_CALGARY,
-				     dev);
+		dev = pci_get_device(PCI_VENDOR_ID_IBM, PCI_ANY_ID, dev);
 		if (!dev)
 			break;
+		if (!is_cal_pci_dev(dev->device))
+			continue;
 		if (!translate_phb(dev)) {
 			calgary_init_one_nontraslated(dev);
 			continue;
 		}
-		if (!bus_info[dev->bus->number].tce_space && !translate_empty_slots)
+		tce_space = bus_info[dev->bus->number].tce_space;
+		if (!tce_space && !translate_empty_slots) {
+			printk("Calg: %p failed tce_space check\n", dev);
 			continue;
-
+		}
 		ret = calgary_init_one(dev);
 		if (ret)
 			goto error;
@@ -1003,10 +1099,11 @@ static int __init calgary_init(void)
 error:
 	do {
 		dev = pci_get_device_reverse(PCI_VENDOR_ID_IBM,
-					      PCI_DEVICE_ID_IBM_CALGARY,
-					      dev);
+					     PCI_ANY_ID, dev);
 		if (!dev)
 			break;
+		if (!is_cal_pci_dev(dev->device))
+			continue;
 		if (!translate_phb(dev)) {
 			pci_dev_put(dev);
 			continue;
@@ -1084,9 +1181,29 @@ static int __init build_detail_arrays(vo
 	return 0;
 }
 
-void __init detect_calgary(void)
+static int __init calgary_bus_has_devices(int bus, unsigned short pci_dev)
 {
+	int dev;
 	u32 val;
+
+	if (pci_dev == PCI_DEVICE_ID_IBM_CALIOC2) {
+		/*
+		 * FIXME: properly scan for devices accross the
+		 * PCI-to-PCI bridge on every CalIOC2 port.
+		 */
+		return 1;
+	}
+
+	for (dev = 1; dev < 8; dev++) {
+		val = read_pci_config(bus, dev, 0, 0);
+		if (val != 0xffffffff)
+			break;
+	}
+	return (val != 0xffffffff);
+}
+
+void __init detect_calgary(void)
+{
 	int bus;
 	void *tbl;
 	int calgary_found = 0;
@@ -1143,29 +1260,28 @@ void __init detect_calgary(void)
 	specified_table_size = determine_tce_table_size(end_pfn * PAGE_SIZE);
 
 	for (bus = 0; bus < MAX_PHB_BUS_NUM; bus++) {
-		int dev;
 		struct calgary_bus_info *info = &bus_info[bus];
+		unsigned short pci_device;
+		u32 val;
+
+		val = read_pci_config(bus, 0, 0, 0);
+		pci_device = (val & 0xFFFF0000) >> 16;
 
-		if (read_pci_config(bus, 0, 0, 0) != PCI_VENDOR_DEVICE_ID_CALGARY)
+		if (!is_cal_pci_dev(pci_device))
 			continue;
 
 		if (info->translation_disabled)
 			continue;
 
-		/*
-		 * Scan the slots of the PCI bus to see if there is a device present.
-		 * The parent bus will be the zero-ith device, so start at 1.
-		 */
-		for (dev = 1; dev < 8; dev++) {
-			val = read_pci_config(bus, dev, 0, 0);
-			if (val != 0xffffffff || translate_empty_slots) {
-				tbl = alloc_tce_table();
-				if (!tbl)
-					goto cleanup;
-				info->tce_space = tbl;
-				calgary_found = 1;
-				break;
-			}
+		if (calgary_bus_has_devices(bus, pci_device) ||
+		    translate_empty_slots) {
+			tbl = alloc_tce_table();
+			if (!tbl)
+				goto cleanup;
+			info->tce_space = tbl;
+			calgary_found = 1;
+			printk("Calg: allocated tce_table %p for bus 0x%x\n",
+			       info->tce_space, bus);
 		}
 	}
 
_

Patches currently in -mm which might be from muli@il.ibm.com are

origin.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
