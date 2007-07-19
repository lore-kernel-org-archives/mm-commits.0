From: akpm@linux-foundation.org
Subject: - x86-64-calgary-make-dump_error_regs-a-chip-op.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:09:19 -0700
Message-ID: <200707192009.l6JK9JPb020569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46402 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759889AbXGSUPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muli@il.ibm.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86-64: Calgary: make dump_error_regs a chip op
has been removed from the -mm tree.  Its filename was
     x86-64-calgary-make-dump_error_regs-a-chip-op.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86-64: Calgary: make dump_error_regs a chip op
From: Muli Ben-Yehuda <muli@il.ibm.com>

Provide seperate versions for Calgary and CalIOC2

Also print out the PCIe Root Complex Status on CalIOC2 errors

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |   42 +++++++++++++++++++++++------
 include/asm-x86_64/calgary.h     |    1 
 2 files changed, 35 insertions(+), 8 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-make-dump_error_regs-a-chip-op arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-make-dump_error_regs-a-chip-op
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -83,6 +83,7 @@ int use_calgary __read_mostly = 0;
 #define PHB_SAVIOR_L2           0x0DB0
 #define PHB_PAGE_MIG_CTRL       0x0DA8
 #define PHB_PAGE_MIG_DEBUG      0x0DA0
+#define PHB_ROOT_COMPLEX_STATUS 0x0CB0
 
 /* PHB_CONFIG_RW */
 #define PHB_TCE_ENABLE		0x20000000
@@ -165,17 +166,21 @@ struct calgary_bus_info {
 
 static void calgary_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev);
 static void calgary_tce_cache_blast(struct iommu_table *tbl);
+static void calgary_dump_error_regs(struct iommu_table *tbl);
 static void calioc2_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev);
 static void calioc2_tce_cache_blast(struct iommu_table *tbl);
+static void calioc2_dump_error_regs(struct iommu_table *tbl);
 
 static struct cal_chipset_ops calgary_chip_ops = {
 	.handle_quirks = calgary_handle_quirks,
-	.tce_cache_blast = calgary_tce_cache_blast
+	.tce_cache_blast = calgary_tce_cache_blast,
+	.dump_error_regs = calgary_dump_error_regs
 };
 
 static struct cal_chipset_ops calioc2_chip_ops = {
 	.handle_quirks = calioc2_handle_quirks,
-	.tce_cache_blast = calioc2_tce_cache_blast
+	.tce_cache_blast = calioc2_tce_cache_blast,
+	.dump_error_regs = calioc2_dump_error_regs
 };
 
 static struct calgary_bus_info bus_info[MAX_PHB_BUS_NUM] = { { NULL, 0, 0 }, };
@@ -895,7 +900,21 @@ static void __init calgary_free_bus(stru
 static void calgary_dump_error_regs(struct iommu_table *tbl)
 {
 	void __iomem *bbar = tbl->bbar;
-	u32 csr, csmr, plssr, mck;
+	u32 val32;
+	void __iomem *target;
+
+	target = calgary_reg(bbar, phb_offset(tbl->it_busno) | PHB_CSR_OFFSET);
+	val32 = be32_to_cpu(readl(target));
+
+	/* If no error, the agent ID in the CSR is not valid */
+	printk(KERN_EMERG "Calgary: DMA error on Calgary PHB 0x%x, "
+	       "CSR = 0x%08x\n", tbl->it_busno, val32);
+}
+
+static void calioc2_dump_error_regs(struct iommu_table *tbl)
+{
+	void __iomem *bbar = tbl->bbar;
+	u32 csr, csmr, plssr, mck, rcstat;
 	void __iomem *target;
 	unsigned long phboff = phb_offset(tbl->it_busno);
 	unsigned long erroff;
@@ -915,8 +934,11 @@ static void calgary_dump_error_regs(stru
 	target = calgary_reg(bbar, phboff | 0x800);
 	mck = be32_to_cpu(readl(target));
 
-	printk(KERN_EMERG "Calgary: 0x%08x@CSR 0x%08x@PLSSR 0x%08x@CSMR "
-	       "0x%08x@MCK\n", csr, plssr, csmr, mck);
+	printk(KERN_EMERG "Calgary: DMA error on CalIOC2 PHB 0x%x\n",
+	       tbl->it_busno);
+
+	printk(KERN_EMERG "Calgary: 0x%08x@CSR 0x%08x@PLSSR 0x%08x@CSMR 0x%08x@MCK\n",
+	       csr, plssr, csmr, mck);
 
 	/* dump rest of error regs */
 	printk(KERN_EMERG "Calgary: ");
@@ -927,6 +949,12 @@ static void calgary_dump_error_regs(stru
 		printk("0x%08x@0x%lx ", errregs[i], erroff);
 	}
 	printk("\n");
+
+	/* root complex status */
+	target = calgary_reg(bbar, phboff | PHB_ROOT_COMPLEX_STATUS);
+	rcstat = be32_to_cpu(readl(target));
+	printk(KERN_EMERG "Calgary: 0x%08x@0x%x\n", rcstat,
+	       PHB_ROOT_COMPLEX_STATUS);
 }
 
 static void calgary_watchdog(unsigned long data)
@@ -942,9 +970,7 @@ static void calgary_watchdog(unsigned lo
 
 	/* If no error, the agent ID in the CSR is not valid */
 	if (val32 & CSR_AGENT_MASK) {
-		printk(KERN_EMERG "Calgary: DMA error on PHB %#x\n",
-		       dev->bus->number);
-		calgary_dump_error_regs(tbl);
+		tbl->chip_ops->dump_error_regs(tbl);
 
 		/* reset error */
 		writel(0, target);
diff -puN include/asm-x86_64/calgary.h~x86-64-calgary-make-dump_error_regs-a-chip-op include/asm-x86_64/calgary.h
--- a/include/asm-x86_64/calgary.h~x86-64-calgary-make-dump_error_regs-a-chip-op
+++ a/include/asm-x86_64/calgary.h
@@ -46,6 +46,7 @@ struct iommu_table {
 struct cal_chipset_ops {
 	void (*handle_quirks)(struct iommu_table *tbl, struct pci_dev *dev);
 	void (*tce_cache_blast)(struct iommu_table *tbl);
+	void (*dump_error_regs)(struct iommu_table *tbl);
 };
 
 #define TCE_TABLE_SIZE_UNSPECIFIED	~0
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
