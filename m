From: akpm@linux-foundation.org
Subject: - x86_64-calgary-change-_map_single-etc-to-static.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:09:42 -0700
Message-ID: <200707192009.l6JK9gNS020602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48606 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761356AbXGSUQI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai.lu@Sun.COM, ak@suse.de, muli@il.ibm.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: Calgary - change _map_single, etc to static
has been removed from the -mm tree.  Its filename was
     x86_64-calgary-change-_map_single-etc-to-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: Calgary - change _map_single, etc to static
From: Yinghai Lu <yinghai.lu@sun.com>

there function are called via dma_ops->.., so change them to static

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86_64-calgary-change-_map_single-etc-to-static arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86_64-calgary-change-_map_single-etc-to-static
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -417,7 +417,7 @@ static int calgary_nontranslate_map_sg(s
 	return nelems;
 }
 
-int calgary_map_sg(struct device *dev, struct scatterlist *sg,
+static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 	int nelems, int direction)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
@@ -462,7 +462,7 @@ error:
 	return 0;
 }
 
-dma_addr_t calgary_map_single(struct device *dev, void *vaddr,
+static dma_addr_t calgary_map_single(struct device *dev, void *vaddr,
 	size_t size, int direction)
 {
 	dma_addr_t dma_handle = bad_dma_address;
@@ -481,7 +481,7 @@ dma_addr_t calgary_map_single(struct dev
 	return dma_handle;
 }
 
-void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
+static void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
 	size_t size, int direction)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
@@ -494,7 +494,7 @@ void calgary_unmap_single(struct device 
 	iommu_free(tbl, dma_handle, npages);
 }
 
-void* calgary_alloc_coherent(struct device *dev, size_t size,
+static void* calgary_alloc_coherent(struct device *dev, size_t size,
 	dma_addr_t *dma_handle, gfp_t flag)
 {
 	void *ret = NULL;
_

Patches currently in -mm which might be from yinghai.lu@sun.com are

origin.patch
