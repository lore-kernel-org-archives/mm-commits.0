From: akpm@linux-foundation.org
Subject: - x86-64-calgary-tidy-up-debug-printks.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:09:34 -0700
Message-ID: <200707192009.l6JK9Y66020590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44330 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760803AbXGSUP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muli@il.ibm.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86-64: Calgary: tidy up debug printks
has been removed from the -mm tree.  Its filename was
     x86-64-calgary-tidy-up-debug-printks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86-64: Calgary: tidy up debug printks
From: Muli Ben-Yehuda <muli@il.ibm.com>

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-tidy-up-debug-printks arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-tidy-up-debug-printks
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -1224,10 +1224,9 @@ static int __init calgary_init(void)
 			continue;
 		}
 		tce_space = bus_info[dev->bus->number].tce_space;
-		if (!tce_space && !translate_empty_slots) {
-			printk("Calg: %p failed tce_space check\n", dev);
+		if (!tce_space && !translate_empty_slots)
 			continue;
-		}
+
 		ret = calgary_init_one(dev);
 		if (ret)
 			goto error;
@@ -1419,8 +1418,6 @@ void __init detect_calgary(void)
 				goto cleanup;
 			info->tce_space = tbl;
 			calgary_found = 1;
-			printk("Calg: allocated tce_table %p for bus 0x%x\n",
-			       info->tce_space, bus);
 		}
 	}
 
@@ -1555,10 +1552,6 @@ static void __init calgary_fixup_one_tce
 		npages = (r->end - r->start) >> PAGE_SHIFT;
 		npages++;
 
-		printk(KERN_DEBUG "Calg: dev %p [%x] tbl %p reserving "
-		       "0x%Lx-0x%Lx [0x%x pages]\n", dev, dev->bus->number,
-		       tbl, r->start, r->end, npages);
-
 		iommu_range_reserve(tbl, r->start, npages);
 	}
 }
@@ -1571,7 +1564,7 @@ static int __init calgary_fixup_tce_spac
 	if (no_iommu || swiotlb || !calgary_detected)
 		return -ENODEV;
 
-	printk(KERN_DEBUG "Calgary: fixing tce spaces\n");
+	printk(KERN_DEBUG "Calgary: fixing up tce spaces\n");
 
 	do {
 		dev = pci_get_device(PCI_VENDOR_ID_IBM, PCI_ANY_ID, dev);
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
