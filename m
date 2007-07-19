From: akpm@linux-foundation.org
Subject: - x86_64-change-_map_single-to-static-in-pci_gartc-etc.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:10:21 -0700
Message-ID: <200707192010.l6JKALtE020662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36603 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760933AbXGSUPa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     x86_64: change _map_single to static in pci_gart.c etc
has been removed from the -mm tree.  Its filename was
     x86_64-change-_map_single-to-static-in-pci_gartc-etc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: change _map_single to static in pci_gart.c etc
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

This function is called via dma_ops->.., so change it to static

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |    8 ++++----
 arch/x86_64/kernel/pci-gart.c    |    6 +++---
 arch/x86_64/kernel/pci-nommu.c   |    6 +++---
 3 files changed, 10 insertions(+), 10 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86_64-change-_map_single-to-static-in-pci_gartc-etc arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86_64-change-_map_single-to-static-in-pci_gartc-etc
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -417,7 +417,7 @@ static int calgary_nontranslate_map_sg(s
 	return nelems;
 }
 
-static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
+int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 	int nelems, int direction)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
@@ -462,7 +462,7 @@ error:
 	return 0;
 }
 
-static dma_addr_t calgary_map_single(struct device *dev, void *vaddr,
+dma_addr_t calgary_map_single(struct device *dev, void *vaddr,
 	size_t size, int direction)
 {
 	dma_addr_t dma_handle = bad_dma_address;
@@ -481,7 +481,7 @@ static dma_addr_t calgary_map_single(str
 	return dma_handle;
 }
 
-static void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
+void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
 	size_t size, int direction)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
@@ -494,7 +494,7 @@ static void calgary_unmap_single(struct 
 	iommu_free(tbl, dma_handle, npages);
 }
 
-static void* calgary_alloc_coherent(struct device *dev, size_t size,
+void* calgary_alloc_coherent(struct device *dev, size_t size,
 	dma_addr_t *dma_handle, gfp_t flag)
 {
 	void *ret = NULL;
diff -puN arch/x86_64/kernel/pci-gart.c~x86_64-change-_map_single-to-static-in-pci_gartc-etc arch/x86_64/kernel/pci-gart.c
--- a/arch/x86_64/kernel/pci-gart.c~x86_64-change-_map_single-to-static-in-pci_gartc-etc
+++ a/arch/x86_64/kernel/pci-gart.c
@@ -236,7 +236,7 @@ static dma_addr_t gart_map_simple(struct
 }
 
 /* Map a single area into the IOMMU */
-dma_addr_t gart_map_single(struct device *dev, void *addr, size_t size, int dir)
+static dma_addr_t gart_map_single(struct device *dev, void *addr, size_t size, int dir)
 {
 	unsigned long phys_mem, bus;
 
@@ -254,7 +254,7 @@ dma_addr_t gart_map_single(struct device
 /*
  * Free a DMA mapping.
  */
-void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
+static void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
 		      size_t size, int direction)
 {
 	unsigned long iommu_page;
@@ -276,7 +276,7 @@ void gart_unmap_single(struct device *de
 /*
  * Wrapper for pci_unmap_single working with scatterlists.
  */
-void gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
+static void gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 {
 	int i;
 
diff -puN arch/x86_64/kernel/pci-nommu.c~x86_64-change-_map_single-to-static-in-pci_gartc-etc arch/x86_64/kernel/pci-nommu.c
--- a/arch/x86_64/kernel/pci-nommu.c~x86_64-change-_map_single-to-static-in-pci_gartc-etc
+++ a/arch/x86_64/kernel/pci-nommu.c
@@ -34,7 +34,7 @@ nommu_map_single(struct device *hwdev, v
 	return bus;
 }
 
-void nommu_unmap_single(struct device *dev, dma_addr_t addr,size_t size,
+static void nommu_unmap_single(struct device *dev, dma_addr_t addr,size_t size,
 			int direction)
 {
 }
@@ -54,7 +54,7 @@ void nommu_unmap_single(struct device *d
  * Device ownership issues as mentioned above for pci_map_single are
  * the same here.
  */
-int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
+static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 	       int nents, int direction)
 {
 	int i;
@@ -74,7 +74,7 @@ int nommu_map_sg(struct device *hwdev, s
  * Again, cpu read rules concerning calls here are the same as for
  * pci_unmap_single() above.
  */
-void nommu_unmap_sg(struct device *dev, struct scatterlist *sg,
+static void nommu_unmap_sg(struct device *dev, struct scatterlist *sg,
 		  int nents, int dir)
 {
 }
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
