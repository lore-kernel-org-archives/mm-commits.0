From: akpm@linux-foundation.org
Subject: - x86-64-calgary-implement-calioc2-tce-cache-flush-sequence.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:09:17 -0700
Message-ID: <200707192009.l6JK9H41020566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50996 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761039AbXGSUPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muli@il.ibm.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86-64: Calgary: implement CalIOC2 TCE cache flush sequence
has been removed from the -mm tree.  Its filename was
     x86-64-calgary-implement-calioc2-tce-cache-flush-sequence.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86-64: Calgary: implement CalIOC2 TCE cache flush sequence
From: Muli Ben-Yehuda <muli@il.ibm.com>

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |   88 ++++++++++++++++++++++++++++-
 1 files changed, 87 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-implement-calioc2-tce-cache-flush-sequence arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-implement-calioc2-tce-cache-flush-sequence
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -81,6 +81,8 @@ int use_calgary __read_mostly = 0;
 
 /* CalIOC2 specific */
 #define PHB_SAVIOR_L2           0x0DB0
+#define PHB_PAGE_MIG_CTRL       0x0DA8
+#define PHB_PAGE_MIG_DEBUG      0x0DA0
 
 /* PHB_CONFIG_RW */
 #define PHB_TCE_ENABLE		0x20000000
@@ -95,6 +97,10 @@ int use_calgary __read_mostly = 0;
 #define CSR_AGENT_MASK		0xffe0ffff
 /* CCR (Calgary Configuration Register) */
 #define CCR_2SEC_TIMEOUT        0x000000000000000EUL
+/* PMCR/PMDR (Page Migration Control/Debug Registers */
+#define PMR_SOFTSTOP            0x80000000
+#define PMR_SOFTSTOPFAULT       0x40000000
+#define PMR_HARDSTOP            0x20000000
 
 #define MAX_NUM_OF_PHBS		8 /* how many PHBs in total? */
 #define MAX_NUM_CHASSIS		8 /* max number of chassis */
@@ -160,6 +166,7 @@ struct calgary_bus_info {
 static void calgary_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev);
 static void calgary_tce_cache_blast(struct iommu_table *tbl);
 static void calioc2_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev);
+static void calioc2_tce_cache_blast(struct iommu_table *tbl);
 
 static struct cal_chipset_ops calgary_chip_ops = {
 	.handle_quirks = calgary_handle_quirks,
@@ -168,7 +175,7 @@ static struct cal_chipset_ops calgary_ch
 
 static struct cal_chipset_ops calioc2_chip_ops = {
 	.handle_quirks = calioc2_handle_quirks,
-	.tce_cache_blast = NULL
+	.tce_cache_blast = calioc2_tce_cache_blast
 };
 
 static struct calgary_bus_info bus_info[MAX_PHB_BUS_NUM] = { { NULL, 0, 0 }, };
@@ -637,6 +644,85 @@ static void calgary_tce_cache_blast(stru
 	(void)readl(target); /* flush */
 }
 
+static void calioc2_tce_cache_blast(struct iommu_table *tbl)
+{
+	void __iomem *bbar = tbl->bbar;
+	void __iomem *target;
+	u64 val64;
+	u32 val;
+	int i = 0;
+	int count = 1;
+	unsigned char bus = tbl->it_busno;
+
+begin:
+	printk(KERN_DEBUG "Calgary: CalIOC2 bus 0x%x entering tce cache blast "
+	       "sequence - count %d\n", bus, count);
+
+	/* 1. using the Page Migration Control reg set SoftStop */
+	target = calgary_reg(bbar, phb_offset(bus) | PHB_PAGE_MIG_CTRL);
+	val = be32_to_cpu(readl(target));
+	printk(KERN_DEBUG "1a. read 0x%x [LE] from %p\n", val, target);
+	val |= PMR_SOFTSTOP;
+	printk(KERN_DEBUG "1b. writing 0x%x [LE] to %p\n", val, target);
+	writel(cpu_to_be32(val), target);
+
+	/* 2. poll split queues until all DMA activity is done */
+	printk(KERN_DEBUG "2a. starting to poll split queues\n");
+	target = calgary_reg(bbar, split_queue_offset(bus));
+	do {
+		val64 = readq(target);
+		i++;
+	} while ((val64 & 0xff) != 0xff && i < 100);
+	if (i == 100)
+		printk(KERN_WARNING "CalIOC2: PCI bus not quiesced, "
+		       "continuing anyway\n");
+
+	/* 3. poll Page Migration DEBUG for SoftStopFault */
+	target = calgary_reg(bbar, phb_offset(bus) | PHB_PAGE_MIG_DEBUG);
+	val = be32_to_cpu(readl(target));
+	printk(KERN_DEBUG "3. read 0x%x [LE] from %p\n", val, target);
+
+	/* 4. if SoftStopFault - goto (1) */
+	if (val & PMR_SOFTSTOPFAULT) {
+		if (++count < 100)
+			goto begin;
+		else {
+			printk(KERN_WARNING "CalIOC2: too many SoftStopFaults, "
+			       "aborting TCE cache flush sequence!\n");
+			return; /* pray for the best */
+		}
+	}
+
+	/* 5. Slam into HardStop by reading PHB_PAGE_MIG_CTRL */
+	target = calgary_reg(bbar, phb_offset(bus) | PHB_PAGE_MIG_CTRL);
+	printk(KERN_DEBUG "5a. slamming into HardStop by reading %p\n", target);
+	val = be32_to_cpu(readl(target));
+	printk(KERN_DEBUG "5b. read 0x%x [LE] from %p\n", val, target);
+	target = calgary_reg(bbar, phb_offset(bus) | PHB_PAGE_MIG_DEBUG);
+	val = be32_to_cpu(readl(target));
+	printk(KERN_DEBUG "5c. read 0x%x [LE] from %p (debug)\n", val, target);
+
+	/* 6. invalidate TCE cache */
+	printk(KERN_DEBUG "6. invalidating TCE cache\n");
+	target = calgary_reg(bbar, tar_offset(bus));
+	writeq(tbl->tar_val, target);
+
+	/* 7. Re-read PMCR */
+	printk(KERN_DEBUG "7a. Re-reading PMCR\n");
+	target = calgary_reg(bbar, phb_offset(bus) | PHB_PAGE_MIG_CTRL);
+	val = be32_to_cpu(readl(target));
+	printk(KERN_DEBUG "7b. read 0x%x [LE] from %p\n", val, target);
+
+	/* 8. Remove HardStop */
+	printk(KERN_DEBUG "8a. removing HardStop from PMCR\n");
+	target = calgary_reg(bbar, phb_offset(bus) | PHB_PAGE_MIG_CTRL);
+	val = 0;
+	printk(KERN_DEBUG "8b. writing 0x%x [LE] to %p\n", val, target);
+	writel(cpu_to_be32(val), target);
+	val = be32_to_cpu(readl(target));
+	printk(KERN_DEBUG "8c. read 0x%x [LE] from %p\n", val, target);
+}
+
 static void __init calgary_reserve_mem_region(struct pci_dev *dev, u64 start,
 	u64 limit)
 {
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
