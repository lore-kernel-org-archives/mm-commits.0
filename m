From: akpm@linux-foundation.org
Subject: + x86-64-calgary-get-rid-of-translate_phb.patch added to -mm tree
Date: Mon, 24 Sep 2007 13:27:46 -0700
Message-ID: <200709242027.l8OKRkqO015952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43568 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756975AbXIXU1y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Sep 2007 16:27:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: muli@il.ibm.com


The patch titled
     x86-64: Calgary - get rid of translate_phb
has been added to the -mm tree.  Its filename is
     x86-64-calgary-get-rid-of-translate_phb.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86-64: Calgary - get rid of translate_phb
From: Muli Ben-Yehuda <muli@il.ibm.com>

Now that we check for translation enabled/disabled based on the presence of
the IOMMU translation table, we can get rid of translate_phb.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |   31 ++++++++++++++---------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-get-rid-of-translate_phb arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-get-rid-of-translate_phb
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -228,12 +228,6 @@ static inline int translation_enabled(st
 	return (tbl != NULL);
 }
 
-static inline int translate_phb(struct pci_dev* dev)
-{
-	int disabled = bus_info[dev->bus->number].translation_disabled;
-	return !disabled;
-}
-
 static void iommu_range_reserve(struct iommu_table *tbl,
 	unsigned long start_addr, unsigned int npages)
 {
@@ -1200,7 +1194,7 @@ static int __init calgary_init(void)
 {
 	int ret;
 	struct pci_dev *dev = NULL;
-	void *tce_space;
+	struct calgary_bus_info *info;
 
 	ret = calgary_locate_bbars();
 	if (ret)
@@ -1212,12 +1206,14 @@ static int __init calgary_init(void)
 			break;
 		if (!is_cal_pci_dev(dev->device))
 			continue;
-		if (!translate_phb(dev)) {
+
+		info = &bus_info[dev->bus->number];
+		if (info->translation_disabled) {
 			calgary_init_one_nontraslated(dev);
 			continue;
 		}
-		tce_space = bus_info[dev->bus->number].tce_space;
-		if (!tce_space && !translate_empty_slots)
+
+		if (!info->tce_space && !translate_empty_slots)
 			continue;
 
 		ret = calgary_init_one(dev);
@@ -1235,11 +1231,13 @@ error:
 			break;
 		if (!is_cal_pci_dev(dev->device))
 			continue;
-		if (!translate_phb(dev)) {
+
+		info = &bus_info[dev->bus->number];
+		if (info->translation_disabled) {
 			pci_dev_put(dev);
 			continue;
 		}
-		if (!bus_info[dev->bus->number].tce_space && !translate_empty_slots)
+		if (!info->tce_space && !translate_empty_slots)
 			continue;
 
 		calgary_disable_translation(dev);
@@ -1552,7 +1550,7 @@ static void __init calgary_fixup_one_tce
 static int __init calgary_fixup_tce_spaces(void)
 {
 	struct pci_dev *dev = NULL;
-	void *tce_space;
+	struct calgary_bus_info *info;
 
 	if (no_iommu || swiotlb || !calgary_detected)
 		return -ENODEV;
@@ -1565,11 +1563,12 @@ static int __init calgary_fixup_tce_spac
 			break;
 		if (!is_cal_pci_dev(dev->device))
 			continue;
-		if (!translate_phb(dev))
+
+		info = &bus_info[dev->bus->number];
+		if (info->translation_disabled)
 			continue;
 
-		tce_space = bus_info[dev->bus->number].tce_space;
-		if (!tce_space)
+		if (!info->tce_space)
 			continue;
 
 		calgary_fixup_one_tce_space(dev);
_

Patches currently in -mm which might be from muli@il.ibm.com are

git-block.patch
x86-64-calgary-fix-calgary=disable=busnum-for-calioc2.patch
x86-64-calgary-get-rid-of-translate_phb.patch
unify-dma_bit_mask-definitions-v31.patch
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
