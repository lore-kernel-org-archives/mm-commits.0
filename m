From: akpm@linux-foundation.org
Subject: + x86-64-calgary-only-reserve-the-first-1mb-of-io-space-for-calioc2.patch added to -mm tree
Date: Mon, 04 Jun 2007 11:54:36 -0700
Message-ID: <200706041854.l54Isa33010958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46049 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760050AbXFDSzI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 14:55:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: muli@il.ibm.com, ak@suse.de


The patch titled
     x86-64: Calgary: only reserve the first 1MB of IO space for CalIOC2
has been added to the -mm tree.  Its filename is
     x86-64-calgary-only-reserve-the-first-1mb-of-io-space-for-calioc2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86-64: Calgary: only reserve the first 1MB of IO space for CalIOC2
From: Muli Ben-Yehuda <muli@il.ibm.com>

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-only-reserve-the-first-1mb-of-io-space-for-calioc2 arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-only-reserve-the-first-1mb-of-io-space-for-calioc2
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -806,13 +806,13 @@ static void __init calgary_reserve_regio
 	iommu_range_reserve(tbl, bad_dma_address, EMERGENCY_PAGES);
 
 	/* avoid the BIOS/VGA first 640KB-1MB region */
-	/* for CalIOC2 - avoid the entire first 2MB */
+	/* for CalIOC2 - avoid the entire first MB */
 	if (is_calgary(dev->device)) {
 		start = (640 * 1024);
 		npages = ((1024 - 640) * 1024) >> PAGE_SHIFT;
 	} else { /* calioc2 */
 		start = 0;
-		npages = (2 * 1024 * 1024) >> PAGE_SHIFT;
+		npages = (1 * 1024 * 1024) >> PAGE_SHIFT;
 	}
 	iommu_range_reserve(tbl, start, npages);
 
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
