From: akpm@linux-foundation.org
Subject: + x86-64-calgary-fix-few-style-problems-pointed-out-by-checkpatchpl.patch added to -mm tree
Date: Wed, 11 Jul 2007 17:42:52 -0700
Message-ID: <200707120042.l6C0gqqo030784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52066 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759651AbXGLAnE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 20:43:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: muli@il.ibm.com, ak@suse.de, akpm@linux-foundation.org


The patch titled
     x86-64: Calgary - fix few style problems pointed out by checkpatch.pl
has been added to the -mm tree.  Its filename is
     x86-64-calgary-fix-few-style-problems-pointed-out-by-checkpatchpl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86-64: Calgary - fix few style problems pointed out by checkpatch.pl
From: Muli Ben-Yehuda <muli@il.ibm.com>

No actual code was harmed in the production of this patch.

Thanks to Andrew Morton <akpm@linux-foundation.org> for telling me
about checkpatch.pl.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-fix-few-style-problems-pointed-out-by-checkpatchpl arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-fix-few-style-problems-pointed-out-by-checkpatchpl
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -375,7 +375,9 @@ static inline struct iommu_table *find_i
 		pbus = pdev->bus;
 
 	tbl = pbus->self->sysdata;
-	BUG_ON(pdev->bus->parent && (tbl->it_busno != pdev->bus->parent->number));
+
+	BUG_ON(pdev->bus->parent &&
+	       (tbl->it_busno != pdev->bus->parent->number));
 
 	return tbl;
 }
@@ -941,7 +943,8 @@ static void calioc2_dump_error_regs(stru
 	/* dump rest of error regs */
 	printk(KERN_EMERG "Calgary: ");
 	for (i = 0; i < ARRAY_SIZE(errregs); i++) {
-		erroff = (0x810 + (i * 0x10)); /* err regs are at 0x810 - 0x870 */
+		/* err regs are at 0x810 - 0x870 */
+		erroff = (0x810 + (i * 0x10));
 		target = calgary_reg(bbar, phboff | erroff);
 		errregs[i] = be32_to_cpu(readl(target));
 		printk("0x%08x@0x%lx ", errregs[i], erroff);
@@ -1207,7 +1210,7 @@ static int __init calgary_init(void)
 {
 	int ret;
 	struct pci_dev *dev = NULL;
-	void* tce_space;
+	void *tce_space;
 
 	ret = calgary_locate_bbars();
 	if (ret)
_

Patches currently in -mm which might be from muli@il.ibm.com are

x86-64-calgary-generalize-calgary_increase_split_completion_timeout.patch
x86-64-calgary-update-copyright-notice.patch
x86-64-calgary-introduce-handle_quirks-for-various-chipset-quirks.patch
x86-64-calgary-introduce-chipset-specific-ops.patch
x86-64-calgary-abstract-how-we-find-the-iommu_table-for-a-device.patch
x86-64-calgary-introduce-calioc2-support.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2.patch
x86-64-calgary-implement-calioc2-tce-cache-flush-sequence.patch
x86-64-calgary-make-dump_error_regs-a-chip-op.patch
x86-64-calgary-grab-plssr-too-when-a-dma-error-occurs.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch
x86-64-calgary-cleanup-of-unneeded-macros.patch
x86-64-calgary-tabify-and-trim-trailing-whitespace.patch
x86-64-calgary-only-reserve-the-first-1mb-of-io-space-for-calioc2.patch
x86-64-calgary-tidy-up-debug-printks.patch
x86-64-calgary-fix-few-style-problems-pointed-out-by-checkpatchpl.patch
x86-64-calgary-tighten-up-the-bitmap-locking.patch
x86-64-calgary-fold-in-redundant-functions.patch
x86_64-calgary-change-_map_single-etc-to-static.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
oss-trident-massive-whitespace-removal.patch
oss-trident-fix-locking-around-write_voice_regs.patch
oss-trident-replace-deprecated-pci_find_device-with-pci_get_device.patch
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
