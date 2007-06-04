From: akpm@linux-foundation.org
Subject: + x86-64-calgary-tidy-up-debug-printks.patch added to -mm tree
Date: Mon, 04 Jun 2007 11:54:39 -0700
Message-ID: <200706041854.l54Isdi0010961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59754 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759695AbXFDSzK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 14:55:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: muli@il.ibm.com, ak@suse.de


The patch titled
     x86-64: Calgary: tidy up debug printks
has been added to the -mm tree.  Its filename is
     x86-64-calgary-tidy-up-debug-printks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
