From: akpm@linux-foundation.org
Subject: - x86-64-calgary-grab-plssr-too-when-a-dma-error-occurs.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:09:21 -0700
Message-ID: <200707192009.l6JK9L0d020572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52346 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756075AbXGSUPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muli@il.ibm.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86-64: Calgary: grab PLSSR too when a DMA error occurs
has been removed from the -mm tree.  Its filename was
     x86-64-calgary-grab-plssr-too-when-a-dma-error-occurs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86-64: Calgary: grab PLSSR too when a DMA error occurs
From: Muli Ben-Yehuda <muli@il.ibm.com>

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-grab-plssr-too-when-a-dma-error-occurs arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-grab-plssr-too-when-a-dma-error-occurs
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -900,15 +900,18 @@ static void __init calgary_free_bus(stru
 static void calgary_dump_error_regs(struct iommu_table *tbl)
 {
 	void __iomem *bbar = tbl->bbar;
-	u32 val32;
 	void __iomem *target;
+	u32 csr, plssr;
 
 	target = calgary_reg(bbar, phb_offset(tbl->it_busno) | PHB_CSR_OFFSET);
-	val32 = be32_to_cpu(readl(target));
+	csr = be32_to_cpu(readl(target));
+
+	target = calgary_reg(bbar, phb_offset(tbl->it_busno) | PHB_PLSSR_OFFSET);
+	plssr = be32_to_cpu(readl(target));
 
 	/* If no error, the agent ID in the CSR is not valid */
 	printk(KERN_EMERG "Calgary: DMA error on Calgary PHB 0x%x, "
-	       "CSR = 0x%08x\n", tbl->it_busno, val32);
+	       "0x%08x@CSR 0x%08x@PLSSR\n", tbl->it_busno, csr, plssr);
 }
 
 static void calioc2_dump_error_regs(struct iommu_table *tbl)
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
