From: akpm@linux-foundation.org
Subject: [merged] sparc-use-dma_map_page-instead-of-dma_map_single.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:44:01 -0700
Message-ID: <200906162244.n5GMi1FA005854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761671AbZFPWoa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:44:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, reif@earthlink.net, mm-commits@vger.kernel.org


The patch titled
     sparc: use dma_map_page instead of dma_map_single
has been removed from the -mm tree.  Its filename was
     sparc-use-dma_map_page-instead-of-dma_map_single.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc: use dma_map_page instead of dma_map_single
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Convert dma_map_single and dma_unmap_single to use map_page and unmap_page
respectively and removes unnecessary map_single and unmap_single. 
map_page can be used to implement map_single but the opposite is
impossible.  Having only dma_map_page in struct dma_ops is enough.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Robert Reif <reif@earthlink.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/dma-mapping_64.h |   23 +++++++++++-----------
 arch/sparc/kernel/iommu.c               |   15 +++++++-------
 arch/sparc/kernel/pci_sun4v.c           |   15 +++++++-------
 3 files changed, 28 insertions(+), 25 deletions(-)

diff -puN arch/sparc/include/asm/dma-mapping_64.h~sparc-use-dma_map_page-instead-of-dma_map_single arch/sparc/include/asm/dma-mapping_64.h
--- a/arch/sparc/include/asm/dma-mapping_64.h~sparc-use-dma_map_page-instead-of-dma_map_single
+++ a/arch/sparc/include/asm/dma-mapping_64.h
@@ -9,12 +9,12 @@ struct dma_ops {
 				dma_addr_t *dma_handle, gfp_t flag);
 	void (*free_coherent)(struct device *dev, size_t size,
 			      void *cpu_addr, dma_addr_t dma_handle);
-	dma_addr_t (*map_single)(struct device *dev, void *cpu_addr,
-				 size_t size,
-				 enum dma_data_direction direction);
-	void (*unmap_single)(struct device *dev, dma_addr_t dma_addr,
-			     size_t size,
-			     enum dma_data_direction direction);
+	dma_addr_t (*map_page)(struct device *dev, struct page *page,
+			       unsigned long offset, size_t size,
+			       enum dma_data_direction direction);
+	void (*unmap_page)(struct device *dev, dma_addr_t dma_addr,
+			   size_t size,
+			   enum dma_data_direction direction);
 	int (*map_sg)(struct device *dev, struct scatterlist *sg, int nents,
 		      enum dma_data_direction direction);
 	void (*unmap_sg)(struct device *dev, struct scatterlist *sg,
@@ -51,29 +51,30 @@ static inline dma_addr_t dma_map_single(
 					size_t size,
 					enum dma_data_direction direction)
 {
-	return dma_ops->map_single(dev, cpu_addr, size, direction);
+	return dma_ops->map_page(dev, virt_to_page(cpu_addr),
+				 (unsigned long)cpu_addr & ~PAGE_MASK, size,
+				 direction);
 }
 
 static inline void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
 				    size_t size,
 				    enum dma_data_direction direction)
 {
-	dma_ops->unmap_single(dev, dma_addr, size, direction);
+	dma_ops->unmap_page(dev, dma_addr, size, direction);
 }
 
 static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 				      unsigned long offset, size_t size,
 				      enum dma_data_direction direction)
 {
-	return dma_ops->map_single(dev, page_address(page) + offset,
-				   size, direction);
+	return dma_ops->map_page(dev, page, offset, size, direction);
 }
 
 static inline void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
 				  size_t size,
 				  enum dma_data_direction direction)
 {
-	dma_ops->unmap_single(dev, dma_address, size, direction);
+	dma_ops->unmap_page(dev, dma_address, size, direction);
 }
 
 static inline int dma_map_sg(struct device *dev, struct scatterlist *sg,
diff -puN arch/sparc/kernel/iommu.c~sparc-use-dma_map_page-instead-of-dma_map_single arch/sparc/kernel/iommu.c
--- a/arch/sparc/kernel/iommu.c~sparc-use-dma_map_page-instead-of-dma_map_single
+++ a/arch/sparc/kernel/iommu.c
@@ -351,8 +351,9 @@ static void dma_4u_free_coherent(struct 
 		free_pages((unsigned long)cpu, order);
 }
 
-static dma_addr_t dma_4u_map_single(struct device *dev, void *ptr, size_t sz,
-				    enum dma_data_direction direction)
+static dma_addr_t dma_4u_map_page(struct device *dev, struct page *page,
+				  unsigned long offset, size_t sz,
+				  enum dma_data_direction direction)
 {
 	struct iommu *iommu;
 	struct strbuf *strbuf;
@@ -368,7 +369,7 @@ static dma_addr_t dma_4u_map_single(stru
 	if (unlikely(direction == DMA_NONE))
 		goto bad_no_ctx;
 
-	oaddr = (unsigned long)ptr;
+	oaddr = (unsigned long)(page_address(page) + offset);
 	npages = IO_PAGE_ALIGN(oaddr + sz) - (oaddr & IO_PAGE_MASK);
 	npages >>= IO_PAGE_SHIFT;
 
@@ -472,8 +473,8 @@ do_flush_sync:
 		       vaddr, ctx, npages);
 }
 
-static void dma_4u_unmap_single(struct device *dev, dma_addr_t bus_addr,
-				size_t sz, enum dma_data_direction direction)
+static void dma_4u_unmap_page(struct device *dev, dma_addr_t bus_addr,
+			      size_t sz, enum dma_data_direction direction)
 {
 	struct iommu *iommu;
 	struct strbuf *strbuf;
@@ -824,8 +825,8 @@ static void dma_4u_sync_sg_for_cpu(struc
 static const struct dma_ops sun4u_dma_ops = {
 	.alloc_coherent		= dma_4u_alloc_coherent,
 	.free_coherent		= dma_4u_free_coherent,
-	.map_single		= dma_4u_map_single,
-	.unmap_single		= dma_4u_unmap_single,
+	.map_page		= dma_4u_map_page,
+	.unmap_page		= dma_4u_unmap_page,
 	.map_sg			= dma_4u_map_sg,
 	.unmap_sg		= dma_4u_unmap_sg,
 	.sync_single_for_cpu	= dma_4u_sync_single_for_cpu,
diff -puN arch/sparc/kernel/pci_sun4v.c~sparc-use-dma_map_page-instead-of-dma_map_single arch/sparc/kernel/pci_sun4v.c
--- a/arch/sparc/kernel/pci_sun4v.c~sparc-use-dma_map_page-instead-of-dma_map_single
+++ a/arch/sparc/kernel/pci_sun4v.c
@@ -230,8 +230,9 @@ static void dma_4v_free_coherent(struct 
 		free_pages((unsigned long)cpu, order);
 }
 
-static dma_addr_t dma_4v_map_single(struct device *dev, void *ptr, size_t sz,
-				    enum dma_data_direction direction)
+static dma_addr_t dma_4v_map_page(struct device *dev, struct page *page,
+				  unsigned long offset, size_t sz,
+				  enum dma_data_direction direction)
 {
 	struct iommu *iommu;
 	unsigned long flags, npages, oaddr;
@@ -245,7 +246,7 @@ static dma_addr_t dma_4v_map_single(stru
 	if (unlikely(direction == DMA_NONE))
 		goto bad;
 
-	oaddr = (unsigned long)ptr;
+	oaddr = (unsigned long)(page_address(page) + offset);
 	npages = IO_PAGE_ALIGN(oaddr + sz) - (oaddr & IO_PAGE_MASK);
 	npages >>= IO_PAGE_SHIFT;
 
@@ -294,8 +295,8 @@ iommu_map_fail:
 	return DMA_ERROR_CODE;
 }
 
-static void dma_4v_unmap_single(struct device *dev, dma_addr_t bus_addr,
-				size_t sz, enum dma_data_direction direction)
+static void dma_4v_unmap_page(struct device *dev, dma_addr_t bus_addr,
+			      size_t sz, enum dma_data_direction direction)
 {
 	struct pci_pbm_info *pbm;
 	struct iommu *iommu;
@@ -537,8 +538,8 @@ static void dma_4v_sync_sg_for_cpu(struc
 static const struct dma_ops sun4v_dma_ops = {
 	.alloc_coherent			= dma_4v_alloc_coherent,
 	.free_coherent			= dma_4v_free_coherent,
-	.map_single			= dma_4v_map_single,
-	.unmap_single			= dma_4v_unmap_single,
+	.map_page			= dma_4v_map_page,
+	.unmap_page			= dma_4v_unmap_page,
 	.map_sg				= dma_4v_map_sg,
 	.unmap_sg			= dma_4v_unmap_sg,
 	.sync_single_for_cpu		= dma_4v_sync_single_for_cpu,
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
linux-next.patch
ib-mthca-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated.patch
dma-mapping-mark-dma_sync_single-and-dma_sync_sg-as-deprecated.patch
dma-mapping-add-asm-generic-dma-mapping-commonh.patch
dma-mapping-x86-use-asm-generic-dma-mapping-commonh.patch
dma-mapping-ia64-use-asm-generic-dma-mapping-commonh.patch
dma-mapping-ia64-add-config_dma_api_debug-support.patch
dma-mapping-dma-debug-fix-compiler-warnings-on-ia64.patch

