From: akpm@linux-foundation.org
Subject: + x86-64-calgary-grab-plssr-too-when-a-dma-error-occurs.patch added to -mm tree
Date: Mon, 04 Jun 2007 11:54:21 -0700
Message-ID: <200706041854.l54IsL2v010940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41971 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758176AbXFDS4u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 14:56:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: muli@il.ibm.com, ak@suse.de


The patch titled
     x86-64: Calgary: grab PLSSR too when a DMA error occurs
has been added to the -mm tree.  Its filename is
     x86-64-calgary-grab-plssr-too-when-a-dma-error-occurs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

x86-64-calgary-generalize-calgary_increase_split_completion_timeout.patch
x86-64-calgary-update-copyright-notice.patch
x86-64-calgary-introduce-handle_quirks-for-various-chipset-quirks.patch
x86-64-calgary-introduce-chipset-specific-ops.patch
x86-64-calgary-introduce-chipset-specific-ops-fix.patch
x86-64-calgary-abstract-how-we-find-the-iommu_table-for-a-device.patch
x86-64-calgary-introduce-calioc2-support.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2-fix.patch
x86-64-calgary-implement-calioc2-tce-cache-flush-sequence.patch
x86-64-calgary-make-dump_error_regs-a-chip-op.patch
x86-64-calgary-grab-plssr-too-when-a-dma-error-occurs.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions-fix.patch
x86-64-calgary-cleanup-of-unneeded-macros.patch
x86-64-calgary-tabify-and-trim-trailing-whitespace.patch
x86-64-calgary-only-reserve-the-first-1mb-of-io-space-for-calioc2.patch
x86-64-calgary-tidy-up-debug-printks.patch
oss-trident-massive-whitespace-removal.patch
oss-trident-fix-locking-around-write_voice_regs.patch
oss-trident-replace-deprecated-pci_find_device-with-pci_get_device.patch
