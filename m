From: akpm@linux-foundation.org
Subject: + x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2.patch added to -mm tree
Date: Mon, 04 Jun 2007 11:54:09 -0700
Message-ID: <200706041854.l54Is9gE010924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54365 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758498AbXFDSyj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 14:54:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: muli@il.ibm.com, ak@suse.de


The patch titled
     x86-64: Calgary: add chip_ops and a quirk function for CalIOC2
has been added to the -mm tree.  Its filename is
     x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86-64: Calgary: add chip_ops and a quirk function for CalIOC2
From: Muli Ben-Yehuda <muli@il.ibm.com>

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |   37 +++++++++++++++++++++++++----
 1 files changed, 33 insertions(+), 4 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2 arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -79,6 +79,9 @@ int use_calgary __read_mostly = 0;
 #define PHB_MEM_2_SIZE_LOW	0x02E0
 #define PHB_DOSHOLE_OFFSET	0x08E0
 
+/* CalIOC2 specific */
+#define PHB_SAVIOR_L2           0x0DB0
+
 /* PHB_CONFIG_RW */
 #define PHB_TCE_ENABLE		0x20000000
 #define PHB_SLOT_DISABLE	0x1C000000
@@ -156,12 +159,18 @@ struct calgary_bus_info {
 
 static void calgary_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev);
 static void calgary_tce_cache_blast(struct iommu_table *tbl);
+static void calioc2_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev);
 
 static struct cal_chipset_ops calgary_chip_ops = {
 	.handle_quirks = calgary_handle_quirks,
 	.tce_cache_blast = calgary_tce_cache_blast
 };
 
+struct cal_chipset_ops calioc2_chip_ops = {
+	.handle_quirks = calioc2_handle_quirks,
+	.tce_cache_blast = NULL
+};
+
 static struct calgary_bus_info bus_info[MAX_PHB_BUS_NUM] = { { NULL, 0, 0 }, };
 
 /* enable this to stress test the chip's TCE cache */
@@ -743,7 +752,12 @@ static int __init calgary_setup_tar(stru
 	tbl->it_base = (unsigned long)bus_info[dev->bus->number].tce_space;
 	tce_free(tbl, 0, tbl->it_size);
 
-	tbl->chip_ops = &calgary_chip_ops;
+  	if (is_calgary(dev->device))
+  		tbl->chip_ops = &calgary_chip_ops;
+	else if (is_calioc2(dev->device))
+		tbl->chip_ops = &calioc2_chip_ops;
+  	else
+  		BUG();
 
 	calgary_reserve_regions(dev);
 
@@ -894,8 +908,23 @@ static void __init calgary_set_split_com
 	readq(target); /* flush */
 }
 
-static void __init calgary_handle_quirks(struct iommu_table *tbl,
-	struct pci_dev *dev)
+static void calioc2_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev)
+{
+	unsigned char busnum = dev->bus->number;
+	void __iomem *bbar = tbl->bbar;
+	void __iomem *target;
+	u32 val;
+
+ 	/*
+ 	 * CalIOC2 designers recommend setting bit 8 in 0xnDB0 to 1
+ 	 */
+ 	target = calgary_reg(bbar, phb_offset(busnum) | PHB_SAVIOR_L2);
+ 	val = cpu_to_be32(readl(target));
+ 	val |= 0x00800000;
+ 	writel(cpu_to_be32(val), target);
+}
+
+static void calgary_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev)
 {
 	unsigned char busnum = dev->bus->number;
 
@@ -903,7 +932,7 @@ static void __init calgary_handle_quirks
 	 * Give split completion a longer timeout on bus 1 for aic94xx
 	 * http://bugzilla.kernel.org/show_bug.cgi?id=7180
 	 */
-	if (busnum == 1)
+	if (is_calgary(dev->device) && (busnum == 1))
 		calgary_set_split_completion_timeout(tbl->bbar, busnum,
 						     CCR_2SEC_TIMEOUT);
 }
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
