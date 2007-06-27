From: akpm@linux-foundation.org
Subject: + x86_64-change-_map_single-to-static-in-pci_gartc-etc.patch added to -mm tree
Date: Wed, 27 Jun 2007 12:25:28 -0700
Message-ID: <200706271925.l5RJPSgZ003988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39035 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751426AbXF0T0E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 15:26:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, yinghai.lu@Sun.COM


The patch titled
     x86_64: change _map_single to static in pci_gart.c etc
has been added to the -mm tree.  Its filename is
     x86_64-change-_map_single-to-static-in-pci_gartc-etc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -427,7 +427,7 @@ static int calgary_nontranslate_map_sg(s
 	return nelems;
 }
 
-int calgary_map_sg(struct device *dev, struct scatterlist *sg,
+static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 	int nelems, int direction)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
@@ -478,7 +478,7 @@ error:
 	return 0;
 }
 
-dma_addr_t calgary_map_single(struct device *dev, void *vaddr,
+static dma_addr_t calgary_map_single(struct device *dev, void *vaddr,
 	size_t size, int direction)
 {
 	dma_addr_t dma_handle = bad_dma_address;
@@ -497,7 +497,7 @@ dma_addr_t calgary_map_single(struct dev
 	return dma_handle;
 }
 
-void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
+static void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
 	size_t size, int direction)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
@@ -510,7 +510,7 @@ void calgary_unmap_single(struct device 
 	iommu_free(tbl, dma_handle, npages);
 }
 
-void* calgary_alloc_coherent(struct device *dev, size_t size,
+static void* calgary_alloc_coherent(struct device *dev, size_t size,
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

serial-assert-dtr-for-serial-console-devices.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
x86_64-change-_map_single-to-static-in-pci_gartc-etc.patch
x86_64-geode-hw-random-number-generator-depend-on-x86_3.patch
console-more-buf-for-index-parsing.patch
console-console-handover-to-preferred-console.patch
serial-convert-early_uart-to-earlycon-for-8250.patch
serial-convert-early_uart-to-earlycon-for-8250-fix.patch
serial-convert-early_uart-to-earlycon-for-8250-ia64-fix.patch
serial-convert-early_uart-to-earlycon-for-8250-fix-3-alias.patch
