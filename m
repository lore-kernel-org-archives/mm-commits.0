From: akpm@linux-foundation.org
Subject: + x86-64-calgary-tabify-and-trim-trailing-whitespace.patch added to -mm tree
Date: Mon, 04 Jun 2007 11:54:33 -0700
Message-ID: <200706041854.l54IsXOe010955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35746 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759705AbXFDSzF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 14:55:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: muli@il.ibm.com, ak@suse.de


The patch titled
     x86-64: Calgary: tabify and trim trailing whitespace
has been added to the -mm tree.  Its filename is
     x86-64-calgary-tabify-and-trim-trailing-whitespace.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86-64: Calgary: tabify and trim trailing whitespace
From: Muli Ben-Yehuda <muli@il.ibm.com>

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |   40 ++++++++++++++---------------
 1 files changed, 20 insertions(+), 20 deletions(-)

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
@@ -418,7 +418,7 @@ static int calgary_nontranslate_map_sg(s
 {
 	int i;
 
- 	for (i = 0; i < nelems; i++ ) {
+	for (i = 0; i < nelems; i++ ) {
 		struct scatterlist *s = &sg[i];
 		BUG_ON(!s->page);
 		s->dma_address = virt_to_bus(page_address(s->page) +s->offset);
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
