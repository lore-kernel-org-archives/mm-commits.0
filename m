From: akpm@linux-foundation.org
Subject: - x86-64-calgary-tabify-and-trim-trailing-whitespace.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:09:30 -0700
Message-ID: <200707192009.l6JK9UPU020582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43424 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760913AbXGSUPb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muli@il.ibm.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86-64: Calgary: tabify and trim trailing whitespace
has been removed from the -mm tree.  Its filename was
     x86-64-calgary-tabify-and-trim-trailing-whitespace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86-64: Calgary: tabify and trim trailing whitespace
From: Muli Ben-Yehuda <muli@il.ibm.com>

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |   38 ++++++++++++++---------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-tabify-and-trim-trailing-whitespace arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-tabify-and-trim-trailing-whitespace
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -75,9 +75,9 @@ int use_calgary __read_mostly = 0;
 #define PHB_DOSHOLE_OFFSET	0x08E0
 
 /* CalIOC2 specific */
-#define PHB_SAVIOR_L2           0x0DB0
-#define PHB_PAGE_MIG_CTRL       0x0DA8
-#define PHB_PAGE_MIG_DEBUG      0x0DA0
+#define PHB_SAVIOR_L2		0x0DB0
+#define PHB_PAGE_MIG_CTRL	0x0DA8
+#define PHB_PAGE_MIG_DEBUG	0x0DA0
 #define PHB_ROOT_COMPLEX_STATUS 0x0CB0
 
 /* PHB_CONFIG_RW */
@@ -92,11 +92,11 @@ int use_calgary __read_mostly = 0;
 /* CSR (Channel/DMA Status Register) */
 #define CSR_AGENT_MASK		0xffe0ffff
 /* CCR (Calgary Configuration Register) */
-#define CCR_2SEC_TIMEOUT        0x000000000000000EUL
+#define CCR_2SEC_TIMEOUT	0x000000000000000EUL
 /* PMCR/PMDR (Page Migration Control/Debug Registers */
-#define PMR_SOFTSTOP            0x80000000
-#define PMR_SOFTSTOPFAULT       0x40000000
-#define PMR_HARDSTOP            0x20000000
+#define PMR_SOFTSTOP		0x80000000
+#define PMR_SOFTSTOPFAULT	0x40000000
+#define PMR_HARDSTOP		0x20000000
 
 #define MAX_NUM_OF_PHBS		8 /* how many PHBs in total? */
 #define MAX_NUM_CHASSIS		8 /* max number of chassis */
@@ -228,7 +228,7 @@ static inline int translate_phb(struct p
 }
 
 static void iommu_range_reserve(struct iommu_table *tbl,
-        unsigned long start_addr, unsigned int npages)
+	unsigned long start_addr, unsigned int npages)
 {
 	unsigned long index;
 	unsigned long end;
@@ -838,12 +838,12 @@ static int __init calgary_setup_tar(stru
 	tbl->it_base = (unsigned long)bus_info[dev->bus->number].tce_space;
 	tce_free(tbl, 0, tbl->it_size);
 
-  	if (is_calgary(dev->device))
-  		tbl->chip_ops = &calgary_chip_ops;
+	if (is_calgary(dev->device))
+		tbl->chip_ops = &calgary_chip_ops;
 	else if (is_calioc2(dev->device))
 		tbl->chip_ops = &calioc2_chip_ops;
-  	else
-  		BUG();
+	else
+		BUG();
 
 	calgary_reserve_regions(dev);
 
@@ -1025,13 +1025,13 @@ static void calioc2_handle_quirks(struct
 	void __iomem *target;
 	u32 val;
 
- 	/*
- 	 * CalIOC2 designers recommend setting bit 8 in 0xnDB0 to 1
- 	 */
- 	target = calgary_reg(bbar, phb_offset(busnum) | PHB_SAVIOR_L2);
- 	val = cpu_to_be32(readl(target));
- 	val |= 0x00800000;
- 	writel(cpu_to_be32(val), target);
+	/*
+	 * CalIOC2 designers recommend setting bit 8 in 0xnDB0 to 1
+	 */
+	target = calgary_reg(bbar, phb_offset(busnum) | PHB_SAVIOR_L2);
+	val = cpu_to_be32(readl(target));
+	val |= 0x00800000;
+	writel(cpu_to_be32(val), target);
 }
 
 static void calgary_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev)
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
