From: akpm@linux-foundation.org
Subject: - x86-64-calgary-only-reserve-the-first-1mb-of-io-space-for-calioc2.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:09:32 -0700
Message-ID: <200707192009.l6JK9WFS020585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37651 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757932AbXGSUPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muli@il.ibm.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86-64: Calgary: only reserve the first 1MB of IO space for CalIOC2
has been removed from the -mm tree.  Its filename was
     x86-64-calgary-only-reserve-the-first-1mb-of-io-space-for-calioc2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
