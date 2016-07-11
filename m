From: akpm@linux-foundation.org
Subject: + powerpc-dma-mapping-use-unsigned-long-for-dma_attrs.patch added to -mm tree
Date: Mon, 11 Jul 2016 15:14:51 -0700
Message-ID: <57841a5b.58MjcGFzaJMSK1Pb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbcGKWOw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2016 18:14:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: dma-mapping: use unsigned long for dma_attrs
has been added to the -mm tree.  Its filename is
     powerpc-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-dma-mapping-use-unsigned-long-for-dma_attrs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: powerpc: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1467275171-6298-21-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/dma-mapping.h    |    7 +++----
 arch/powerpc/include/asm/iommu.h          |   10 +++++-----
 arch/powerpc/kernel/dma-iommu.c           |   12 ++++++------
 arch/powerpc/kernel/dma.c                 |   18 +++++++++---------
 arch/powerpc/kernel/ibmebus.c             |   12 ++++++------
 arch/powerpc/kernel/iommu.c               |   12 ++++++------
 arch/powerpc/kernel/vio.c                 |   12 ++++++------
 arch/powerpc/platforms/cell/iommu.c       |   16 ++++++++--------
 arch/powerpc/platforms/pasemi/iommu.c     |    2 +-
 arch/powerpc/platforms/powernv/npu-dma.c  |    8 ++++----
 arch/powerpc/platforms/powernv/pci-ioda.c |    4 ++--
 arch/powerpc/platforms/powernv/pci.c      |    2 +-
 arch/powerpc/platforms/powernv/pci.h      |    2 +-
 arch/powerpc/platforms/ps3/system-bus.c   |   18 +++++++++---------
 arch/powerpc/platforms/pseries/iommu.c    |    6 +++---
 arch/powerpc/sysdev/dart_iommu.c          |    2 +-
 16 files changed, 71 insertions(+), 72 deletions(-)

diff -puN arch/powerpc/include/asm/dma-mapping.h~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/include/asm/dma-mapping.h
--- a/arch/powerpc/include/asm/dma-mapping.h~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/include/asm/dma-mapping.h
@@ -13,7 +13,6 @@
 /* need struct page definitions */
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
-#include <linux/dma-attrs.h>
 #include <linux/dma-debug.h>
 #include <asm/io.h>
 #include <asm/swiotlb.h>
@@ -25,14 +24,14 @@
 /* Some dma direct funcs must be visible for use in other dma_ops */
 extern void *__dma_direct_alloc_coherent(struct device *dev, size_t size,
 					 dma_addr_t *dma_handle, gfp_t flag,
-					 struct dma_attrs *attrs);
+					 unsigned long attrs);
 extern void __dma_direct_free_coherent(struct device *dev, size_t size,
 				       void *vaddr, dma_addr_t dma_handle,
-				       struct dma_attrs *attrs);
+				       unsigned long attrs);
 extern int dma_direct_mmap_coherent(struct device *dev,
 				    struct vm_area_struct *vma,
 				    void *cpu_addr, dma_addr_t handle,
-				    size_t size, struct dma_attrs *attrs);
+				    size_t size, unsigned long attrs);
 
 #ifdef CONFIG_NOT_COHERENT_CACHE
 /*
diff -puN arch/powerpc/include/asm/iommu.h~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/include/asm/iommu.h
--- a/arch/powerpc/include/asm/iommu.h~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/include/asm/iommu.h
@@ -53,7 +53,7 @@ struct iommu_table_ops {
 			long index, long npages,
 			unsigned long uaddr,
 			enum dma_data_direction direction,
-			struct dma_attrs *attrs);
+			unsigned long attrs);
 #ifdef CONFIG_IOMMU_API
 	/*
 	 * Exchanges existing TCE with new TCE plus direction bits;
@@ -248,12 +248,12 @@ extern int ppc_iommu_map_sg(struct devic
 			    struct scatterlist *sglist, int nelems,
 			    unsigned long mask,
 			    enum dma_data_direction direction,
-			    struct dma_attrs *attrs);
+			    unsigned long attrs);
 extern void ppc_iommu_unmap_sg(struct iommu_table *tbl,
 			       struct scatterlist *sglist,
 			       int nelems,
 			       enum dma_data_direction direction,
-			       struct dma_attrs *attrs);
+			       unsigned long attrs);
 
 extern void *iommu_alloc_coherent(struct device *dev, struct iommu_table *tbl,
 				  size_t size, dma_addr_t *dma_handle,
@@ -264,10 +264,10 @@ extern dma_addr_t iommu_map_page(struct
 				 struct page *page, unsigned long offset,
 				 size_t size, unsigned long mask,
 				 enum dma_data_direction direction,
-				 struct dma_attrs *attrs);
+				 unsigned long attrs);
 extern void iommu_unmap_page(struct iommu_table *tbl, dma_addr_t dma_handle,
 			     size_t size, enum dma_data_direction direction,
-			     struct dma_attrs *attrs);
+			     unsigned long attrs);
 
 extern void iommu_init_early_pSeries(void);
 extern void iommu_init_early_dart(struct pci_controller_ops *controller_ops);
diff -puN arch/powerpc/kernel/dma-iommu.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/kernel/dma-iommu.c
--- a/arch/powerpc/kernel/dma-iommu.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/kernel/dma-iommu.c
@@ -18,7 +18,7 @@
  */
 static void *dma_iommu_alloc_coherent(struct device *dev, size_t size,
 				      dma_addr_t *dma_handle, gfp_t flag,
-				      struct dma_attrs *attrs)
+				      unsigned long attrs)
 {
 	return iommu_alloc_coherent(dev, get_iommu_table_base(dev), size,
 				    dma_handle, dev->coherent_dma_mask, flag,
@@ -27,7 +27,7 @@ static void *dma_iommu_alloc_coherent(st
 
 static void dma_iommu_free_coherent(struct device *dev, size_t size,
 				    void *vaddr, dma_addr_t dma_handle,
-				    struct dma_attrs *attrs)
+				    unsigned long attrs)
 {
 	iommu_free_coherent(get_iommu_table_base(dev), size, vaddr, dma_handle);
 }
@@ -40,7 +40,7 @@ static void dma_iommu_free_coherent(stru
 static dma_addr_t dma_iommu_map_page(struct device *dev, struct page *page,
 				     unsigned long offset, size_t size,
 				     enum dma_data_direction direction,
-				     struct dma_attrs *attrs)
+				     unsigned long attrs)
 {
 	return iommu_map_page(dev, get_iommu_table_base(dev), page, offset,
 			      size, device_to_mask(dev), direction, attrs);
@@ -49,7 +49,7 @@ static dma_addr_t dma_iommu_map_page(str
 
 static void dma_iommu_unmap_page(struct device *dev, dma_addr_t dma_handle,
 				 size_t size, enum dma_data_direction direction,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	iommu_unmap_page(get_iommu_table_base(dev), dma_handle, size, direction,
 			 attrs);
@@ -58,7 +58,7 @@ static void dma_iommu_unmap_page(struct
 
 static int dma_iommu_map_sg(struct device *dev, struct scatterlist *sglist,
 			    int nelems, enum dma_data_direction direction,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	return ppc_iommu_map_sg(dev, get_iommu_table_base(dev), sglist, nelems,
 				device_to_mask(dev), direction, attrs);
@@ -66,7 +66,7 @@ static int dma_iommu_map_sg(struct devic
 
 static void dma_iommu_unmap_sg(struct device *dev, struct scatterlist *sglist,
 		int nelems, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	ppc_iommu_unmap_sg(get_iommu_table_base(dev), sglist, nelems,
 			   direction, attrs);
diff -puN arch/powerpc/kernel/dma.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/kernel/dma.c
--- a/arch/powerpc/kernel/dma.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/kernel/dma.c
@@ -64,7 +64,7 @@ static int dma_direct_dma_supported(stru
 
 void *__dma_direct_alloc_coherent(struct device *dev, size_t size,
 				  dma_addr_t *dma_handle, gfp_t flag,
-				  struct dma_attrs *attrs)
+				  unsigned long attrs)
 {
 	void *ret;
 #ifdef CONFIG_NOT_COHERENT_CACHE
@@ -121,7 +121,7 @@ void *__dma_direct_alloc_coherent(struct
 
 void __dma_direct_free_coherent(struct device *dev, size_t size,
 				void *vaddr, dma_addr_t dma_handle,
-				struct dma_attrs *attrs)
+				unsigned long attrs)
 {
 #ifdef CONFIG_NOT_COHERENT_CACHE
 	__dma_free_coherent(size, vaddr);
@@ -132,7 +132,7 @@ void __dma_direct_free_coherent(struct d
 
 static void *dma_direct_alloc_coherent(struct device *dev, size_t size,
 				       dma_addr_t *dma_handle, gfp_t flag,
-				       struct dma_attrs *attrs)
+				       unsigned long attrs)
 {
 	struct iommu_table *iommu;
 
@@ -156,7 +156,7 @@ static void *dma_direct_alloc_coherent(s
 
 static void dma_direct_free_coherent(struct device *dev, size_t size,
 				     void *vaddr, dma_addr_t dma_handle,
-				     struct dma_attrs *attrs)
+				     unsigned long attrs)
 {
 	struct iommu_table *iommu;
 
@@ -177,7 +177,7 @@ static void dma_direct_free_coherent(str
 
 int dma_direct_mmap_coherent(struct device *dev, struct vm_area_struct *vma,
 			     void *cpu_addr, dma_addr_t handle, size_t size,
-			     struct dma_attrs *attrs)
+			     unsigned long attrs)
 {
 	unsigned long pfn;
 
@@ -195,7 +195,7 @@ int dma_direct_mmap_coherent(struct devi
 
 static int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl,
 			     int nents, enum dma_data_direction direction,
-			     struct dma_attrs *attrs)
+			     unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -211,7 +211,7 @@ static int dma_direct_map_sg(struct devi
 
 static void dma_direct_unmap_sg(struct device *dev, struct scatterlist *sg,
 				int nents, enum dma_data_direction direction,
-				struct dma_attrs *attrs)
+				unsigned long attrs)
 {
 }
 
@@ -232,7 +232,7 @@ static inline dma_addr_t dma_direct_map_
 					     unsigned long offset,
 					     size_t size,
 					     enum dma_data_direction dir,
-					     struct dma_attrs *attrs)
+					     unsigned long attrs)
 {
 	BUG_ON(dir == DMA_NONE);
 	__dma_sync_page(page, offset, size, dir);
@@ -243,7 +243,7 @@ static inline void dma_direct_unmap_page
 					 dma_addr_t dma_address,
 					 size_t size,
 					 enum dma_data_direction direction,
-					 struct dma_attrs *attrs)
+					 unsigned long attrs)
 {
 }
 
diff -puN arch/powerpc/kernel/ibmebus.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/kernel/ibmebus.c
--- a/arch/powerpc/kernel/ibmebus.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/kernel/ibmebus.c
@@ -65,7 +65,7 @@ static void *ibmebus_alloc_coherent(stru
 				    size_t size,
 				    dma_addr_t *dma_handle,
 				    gfp_t flag,
-				    struct dma_attrs *attrs)
+				    unsigned long attrs)
 {
 	void *mem;
 
@@ -78,7 +78,7 @@ static void *ibmebus_alloc_coherent(stru
 static void ibmebus_free_coherent(struct device *dev,
 				  size_t size, void *vaddr,
 				  dma_addr_t dma_handle,
-				  struct dma_attrs *attrs)
+				  unsigned long attrs)
 {
 	kfree(vaddr);
 }
@@ -88,7 +88,7 @@ static dma_addr_t ibmebus_map_page(struc
 				   unsigned long offset,
 				   size_t size,
 				   enum dma_data_direction direction,
-				   struct dma_attrs *attrs)
+				   unsigned long attrs)
 {
 	return (dma_addr_t)(page_address(page) + offset);
 }
@@ -97,7 +97,7 @@ static void ibmebus_unmap_page(struct de
 			       dma_addr_t dma_addr,
 			       size_t size,
 			       enum dma_data_direction direction,
-			       struct dma_attrs *attrs)
+			       unsigned long attrs)
 {
 	return;
 }
@@ -105,7 +105,7 @@ static void ibmebus_unmap_page(struct de
 static int ibmebus_map_sg(struct device *dev,
 			  struct scatterlist *sgl,
 			  int nents, enum dma_data_direction direction,
-			  struct dma_attrs *attrs)
+			  unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -121,7 +121,7 @@ static int ibmebus_map_sg(struct device
 static void ibmebus_unmap_sg(struct device *dev,
 			     struct scatterlist *sg,
 			     int nents, enum dma_data_direction direction,
-			     struct dma_attrs *attrs)
+			     unsigned long attrs)
 {
 	return;
 }
diff -puN arch/powerpc/kernel/iommu.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/kernel/iommu.c
--- a/arch/powerpc/kernel/iommu.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/kernel/iommu.c
@@ -307,7 +307,7 @@ static dma_addr_t iommu_alloc(struct dev
 			      void *page, unsigned int npages,
 			      enum dma_data_direction direction,
 			      unsigned long mask, unsigned int align_order,
-			      struct dma_attrs *attrs)
+			      unsigned long attrs)
 {
 	unsigned long entry;
 	dma_addr_t ret = DMA_ERROR_CODE;
@@ -431,7 +431,7 @@ static void iommu_free(struct iommu_tabl
 int ppc_iommu_map_sg(struct device *dev, struct iommu_table *tbl,
 		     struct scatterlist *sglist, int nelems,
 		     unsigned long mask, enum dma_data_direction direction,
-		     struct dma_attrs *attrs)
+		     unsigned long attrs)
 {
 	dma_addr_t dma_next = 0, dma_addr;
 	struct scatterlist *s, *outs, *segstart;
@@ -574,7 +574,7 @@ int ppc_iommu_map_sg(struct device *dev,
 
 void ppc_iommu_unmap_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 			int nelems, enum dma_data_direction direction,
-			struct dma_attrs *attrs)
+			unsigned long attrs)
 {
 	struct scatterlist *sg;
 
@@ -753,7 +753,7 @@ void iommu_free_table(struct iommu_table
 dma_addr_t iommu_map_page(struct device *dev, struct iommu_table *tbl,
 			  struct page *page, unsigned long offset, size_t size,
 			  unsigned long mask, enum dma_data_direction direction,
-			  struct dma_attrs *attrs)
+			  unsigned long attrs)
 {
 	dma_addr_t dma_handle = DMA_ERROR_CODE;
 	void *vaddr;
@@ -790,7 +790,7 @@ dma_addr_t iommu_map_page(struct device
 
 void iommu_unmap_page(struct iommu_table *tbl, dma_addr_t dma_handle,
 		      size_t size, enum dma_data_direction direction,
-		      struct dma_attrs *attrs)
+		      unsigned long attrs)
 {
 	unsigned int npages;
 
@@ -845,7 +845,7 @@ void *iommu_alloc_coherent(struct device
 	nio_pages = size >> tbl->it_page_shift;
 	io_order = get_iommu_order(size, tbl);
 	mapping = iommu_alloc(dev, tbl, ret, nio_pages, DMA_BIDIRECTIONAL,
-			      mask >> tbl->it_page_shift, io_order, NULL);
+			      mask >> tbl->it_page_shift, io_order, 0);
 	if (mapping == DMA_ERROR_CODE) {
 		free_pages((unsigned long)ret, order);
 		return NULL;
diff -puN arch/powerpc/kernel/vio.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/kernel/vio.c
--- a/arch/powerpc/kernel/vio.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/kernel/vio.c
@@ -482,7 +482,7 @@ static void vio_cmo_balance(struct work_
 
 static void *vio_dma_iommu_alloc_coherent(struct device *dev, size_t size,
 					  dma_addr_t *dma_handle, gfp_t flag,
-					  struct dma_attrs *attrs)
+					  unsigned long attrs)
 {
 	struct vio_dev *viodev = to_vio_dev(dev);
 	void *ret;
@@ -503,7 +503,7 @@ static void *vio_dma_iommu_alloc_coheren
 
 static void vio_dma_iommu_free_coherent(struct device *dev, size_t size,
 					void *vaddr, dma_addr_t dma_handle,
-					struct dma_attrs *attrs)
+					unsigned long attrs)
 {
 	struct vio_dev *viodev = to_vio_dev(dev);
 
@@ -515,7 +515,7 @@ static void vio_dma_iommu_free_coherent(
 static dma_addr_t vio_dma_iommu_map_page(struct device *dev, struct page *page,
                                          unsigned long offset, size_t size,
                                          enum dma_data_direction direction,
-                                         struct dma_attrs *attrs)
+                                         unsigned long attrs)
 {
 	struct vio_dev *viodev = to_vio_dev(dev);
 	struct iommu_table *tbl;
@@ -539,7 +539,7 @@ static dma_addr_t vio_dma_iommu_map_page
 static void vio_dma_iommu_unmap_page(struct device *dev, dma_addr_t dma_handle,
 				     size_t size,
 				     enum dma_data_direction direction,
-				     struct dma_attrs *attrs)
+				     unsigned long attrs)
 {
 	struct vio_dev *viodev = to_vio_dev(dev);
 	struct iommu_table *tbl;
@@ -552,7 +552,7 @@ static void vio_dma_iommu_unmap_page(str
 
 static int vio_dma_iommu_map_sg(struct device *dev, struct scatterlist *sglist,
                                 int nelems, enum dma_data_direction direction,
-                                struct dma_attrs *attrs)
+                                unsigned long attrs)
 {
 	struct vio_dev *viodev = to_vio_dev(dev);
 	struct iommu_table *tbl;
@@ -588,7 +588,7 @@ static int vio_dma_iommu_map_sg(struct d
 static void vio_dma_iommu_unmap_sg(struct device *dev,
 		struct scatterlist *sglist, int nelems,
 		enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	struct vio_dev *viodev = to_vio_dev(dev);
 	struct iommu_table *tbl;
diff -puN arch/powerpc/platforms/cell/iommu.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/platforms/cell/iommu.c
--- a/arch/powerpc/platforms/cell/iommu.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/platforms/cell/iommu.c
@@ -166,7 +166,7 @@ static void invalidate_tce_cache(struct
 
 static int tce_build_cell(struct iommu_table *tbl, long index, long npages,
 		unsigned long uaddr, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	int i;
 	unsigned long *io_pte, base_pte;
@@ -526,7 +526,7 @@ cell_iommu_setup_window(struct cbe_iommu
 
 	__set_bit(0, window->table.it_map);
 	tce_build_cell(&window->table, window->table.it_offset, 1,
-		       (unsigned long)iommu->pad_page, DMA_TO_DEVICE, NULL);
+		       (unsigned long)iommu->pad_page, DMA_TO_DEVICE, 0);
 
 	return window;
 }
@@ -572,7 +572,7 @@ static struct iommu_table *cell_get_iomm
 
 static void *dma_fixed_alloc_coherent(struct device *dev, size_t size,
 				      dma_addr_t *dma_handle, gfp_t flag,
-				      struct dma_attrs *attrs)
+				      unsigned long attrs)
 {
 	if (iommu_fixed_is_weak)
 		return iommu_alloc_coherent(dev, cell_get_iommu_table(dev),
@@ -586,7 +586,7 @@ static void *dma_fixed_alloc_coherent(st
 
 static void dma_fixed_free_coherent(struct device *dev, size_t size,
 				    void *vaddr, dma_addr_t dma_handle,
-				    struct dma_attrs *attrs)
+				    unsigned long attrs)
 {
 	if (iommu_fixed_is_weak)
 		iommu_free_coherent(cell_get_iommu_table(dev), size, vaddr,
@@ -598,7 +598,7 @@ static void dma_fixed_free_coherent(stru
 static dma_addr_t dma_fixed_map_page(struct device *dev, struct page *page,
 				     unsigned long offset, size_t size,
 				     enum dma_data_direction direction,
-				     struct dma_attrs *attrs)
+				     unsigned long attrs)
 {
 	if (iommu_fixed_is_weak == dma_get_attr(DMA_ATTR_WEAK_ORDERING, attrs))
 		return dma_direct_ops.map_page(dev, page, offset, size,
@@ -611,7 +611,7 @@ static dma_addr_t dma_fixed_map_page(str
 
 static void dma_fixed_unmap_page(struct device *dev, dma_addr_t dma_addr,
 				 size_t size, enum dma_data_direction direction,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	if (iommu_fixed_is_weak == dma_get_attr(DMA_ATTR_WEAK_ORDERING, attrs))
 		dma_direct_ops.unmap_page(dev, dma_addr, size, direction,
@@ -623,7 +623,7 @@ static void dma_fixed_unmap_page(struct
 
 static int dma_fixed_map_sg(struct device *dev, struct scatterlist *sg,
 			   int nents, enum dma_data_direction direction,
-			   struct dma_attrs *attrs)
+			   unsigned long attrs)
 {
 	if (iommu_fixed_is_weak == dma_get_attr(DMA_ATTR_WEAK_ORDERING, attrs))
 		return dma_direct_ops.map_sg(dev, sg, nents, direction, attrs);
@@ -635,7 +635,7 @@ static int dma_fixed_map_sg(struct devic
 
 static void dma_fixed_unmap_sg(struct device *dev, struct scatterlist *sg,
 			       int nents, enum dma_data_direction direction,
-			       struct dma_attrs *attrs)
+			       unsigned long attrs)
 {
 	if (iommu_fixed_is_weak == dma_get_attr(DMA_ATTR_WEAK_ORDERING, attrs))
 		dma_direct_ops.unmap_sg(dev, sg, nents, direction, attrs);
diff -puN arch/powerpc/platforms/pasemi/iommu.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/platforms/pasemi/iommu.c
--- a/arch/powerpc/platforms/pasemi/iommu.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/platforms/pasemi/iommu.c
@@ -88,7 +88,7 @@ static int iommu_table_iobmap_inited;
 static int iobmap_build(struct iommu_table *tbl, long index,
 			 long npages, unsigned long uaddr,
 			 enum dma_data_direction direction,
-			 struct dma_attrs *attrs)
+			 unsigned long attrs)
 {
 	u32 *ip;
 	u32 rpn;
diff -puN arch/powerpc/platforms/powernv/npu-dma.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/platforms/powernv/npu-dma.c
--- a/arch/powerpc/platforms/powernv/npu-dma.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/platforms/powernv/npu-dma.c
@@ -73,7 +73,7 @@ EXPORT_SYMBOL(pnv_pci_get_npu_dev);
 
 static void *dma_npu_alloc(struct device *dev, size_t size,
 			   dma_addr_t *dma_handle, gfp_t flag,
-			   struct dma_attrs *attrs)
+			   unsigned long attrs)
 {
 	NPU_DMA_OP_UNSUPPORTED();
 	return NULL;
@@ -81,7 +81,7 @@ static void *dma_npu_alloc(struct device
 
 static void dma_npu_free(struct device *dev, size_t size,
 			 void *vaddr, dma_addr_t dma_handle,
-			 struct dma_attrs *attrs)
+			 unsigned long attrs)
 {
 	NPU_DMA_OP_UNSUPPORTED();
 }
@@ -89,7 +89,7 @@ static void dma_npu_free(struct device *
 static dma_addr_t dma_npu_map_page(struct device *dev, struct page *page,
 				   unsigned long offset, size_t size,
 				   enum dma_data_direction direction,
-				   struct dma_attrs *attrs)
+				   unsigned long attrs)
 {
 	NPU_DMA_OP_UNSUPPORTED();
 	return 0;
@@ -97,7 +97,7 @@ static dma_addr_t dma_npu_map_page(struc
 
 static int dma_npu_map_sg(struct device *dev, struct scatterlist *sglist,
 			  int nelems, enum dma_data_direction direction,
-			  struct dma_attrs *attrs)
+			  unsigned long attrs)
 {
 	NPU_DMA_OP_UNSUPPORTED();
 	return 0;
diff -puN arch/powerpc/platforms/powernv/pci-ioda.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/platforms/powernv/pci-ioda.c
--- a/arch/powerpc/platforms/powernv/pci-ioda.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1783,7 +1783,7 @@ static void pnv_pci_ioda1_tce_invalidate
 static int pnv_ioda1_tce_build(struct iommu_table *tbl, long index,
 		long npages, unsigned long uaddr,
 		enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	int ret = pnv_tce_build(tbl, index, npages, uaddr, direction,
 			attrs);
@@ -1912,7 +1912,7 @@ static void pnv_pci_ioda2_tce_invalidate
 static int pnv_ioda2_tce_build(struct iommu_table *tbl, long index,
 		long npages, unsigned long uaddr,
 		enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	int ret = pnv_tce_build(tbl, index, npages, uaddr, direction,
 			attrs);
diff -puN arch/powerpc/platforms/powernv/pci.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/platforms/powernv/pci.c
--- a/arch/powerpc/platforms/powernv/pci.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/platforms/powernv/pci.c
@@ -587,7 +587,7 @@ static __be64 *pnv_tce(struct iommu_tabl
 
 int pnv_tce_build(struct iommu_table *tbl, long index, long npages,
 		unsigned long uaddr, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	u64 proto_tce = iommu_direction_to_tce_perm(direction);
 	u64 rpn = __pa(uaddr) >> tbl->it_page_shift;
diff -puN arch/powerpc/platforms/powernv/pci.h~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/platforms/powernv/pci.h
--- a/arch/powerpc/platforms/powernv/pci.h~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/platforms/powernv/pci.h
@@ -178,7 +178,7 @@ struct pnv_phb {
 extern struct pci_ops pnv_pci_ops;
 extern int pnv_tce_build(struct iommu_table *tbl, long index, long npages,
 		unsigned long uaddr, enum dma_data_direction direction,
-		struct dma_attrs *attrs);
+		unsigned long attrs);
 extern void pnv_tce_free(struct iommu_table *tbl, long index, long npages);
 extern int pnv_tce_xchg(struct iommu_table *tbl, long index,
 		unsigned long *hpa, enum dma_data_direction *direction);
diff -puN arch/powerpc/platforms/ps3/system-bus.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/platforms/ps3/system-bus.c
--- a/arch/powerpc/platforms/ps3/system-bus.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/platforms/ps3/system-bus.c
@@ -516,7 +516,7 @@ core_initcall(ps3_system_bus_init);
  */
 static void * ps3_alloc_coherent(struct device *_dev, size_t size,
 				 dma_addr_t *dma_handle, gfp_t flag,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	int result;
 	struct ps3_system_bus_device *dev = ps3_dev_to_system_bus_dev(_dev);
@@ -553,7 +553,7 @@ clean_none:
 }
 
 static void ps3_free_coherent(struct device *_dev, size_t size, void *vaddr,
-			      dma_addr_t dma_handle, struct dma_attrs *attrs)
+			      dma_addr_t dma_handle, unsigned long attrs)
 {
 	struct ps3_system_bus_device *dev = ps3_dev_to_system_bus_dev(_dev);
 
@@ -569,7 +569,7 @@ static void ps3_free_coherent(struct dev
 
 static dma_addr_t ps3_sb_map_page(struct device *_dev, struct page *page,
 	unsigned long offset, size_t size, enum dma_data_direction direction,
-	struct dma_attrs *attrs)
+	unsigned long attrs)
 {
 	struct ps3_system_bus_device *dev = ps3_dev_to_system_bus_dev(_dev);
 	int result;
@@ -592,7 +592,7 @@ static dma_addr_t ps3_sb_map_page(struct
 static dma_addr_t ps3_ioc0_map_page(struct device *_dev, struct page *page,
 				    unsigned long offset, size_t size,
 				    enum dma_data_direction direction,
-				    struct dma_attrs *attrs)
+				    unsigned long attrs)
 {
 	struct ps3_system_bus_device *dev = ps3_dev_to_system_bus_dev(_dev);
 	int result;
@@ -626,7 +626,7 @@ static dma_addr_t ps3_ioc0_map_page(stru
 }
 
 static void ps3_unmap_page(struct device *_dev, dma_addr_t dma_addr,
-	size_t size, enum dma_data_direction direction, struct dma_attrs *attrs)
+	size_t size, enum dma_data_direction direction, unsigned long attrs)
 {
 	struct ps3_system_bus_device *dev = ps3_dev_to_system_bus_dev(_dev);
 	int result;
@@ -640,7 +640,7 @@ static void ps3_unmap_page(struct device
 }
 
 static int ps3_sb_map_sg(struct device *_dev, struct scatterlist *sgl,
-	int nents, enum dma_data_direction direction, struct dma_attrs *attrs)
+	int nents, enum dma_data_direction direction, unsigned long attrs)
 {
 #if defined(CONFIG_PS3_DYNAMIC_DMA)
 	BUG_ON("do");
@@ -670,14 +670,14 @@ static int ps3_sb_map_sg(struct device *
 static int ps3_ioc0_map_sg(struct device *_dev, struct scatterlist *sg,
 			   int nents,
 			   enum dma_data_direction direction,
-			   struct dma_attrs *attrs)
+			   unsigned long attrs)
 {
 	BUG();
 	return 0;
 }
 
 static void ps3_sb_unmap_sg(struct device *_dev, struct scatterlist *sg,
-	int nents, enum dma_data_direction direction, struct dma_attrs *attrs)
+	int nents, enum dma_data_direction direction, unsigned long attrs)
 {
 #if defined(CONFIG_PS3_DYNAMIC_DMA)
 	BUG_ON("do");
@@ -686,7 +686,7 @@ static void ps3_sb_unmap_sg(struct devic
 
 static void ps3_ioc0_unmap_sg(struct device *_dev, struct scatterlist *sg,
 			    int nents, enum dma_data_direction direction,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	BUG();
 }
diff -puN arch/powerpc/platforms/pseries/iommu.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/platforms/pseries/iommu.c
--- a/arch/powerpc/platforms/pseries/iommu.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/platforms/pseries/iommu.c
@@ -152,7 +152,7 @@ static void tce_invalidate_pSeries_sw(st
 static int tce_build_pSeries(struct iommu_table *tbl, long index,
 			      long npages, unsigned long uaddr,
 			      enum dma_data_direction direction,
-			      struct dma_attrs *attrs)
+			      unsigned long attrs)
 {
 	u64 proto_tce;
 	__be64 *tcep, *tces;
@@ -208,7 +208,7 @@ static void tce_freemulti_pSeriesLP(stru
 static int tce_build_pSeriesLP(struct iommu_table *tbl, long tcenum,
 				long npages, unsigned long uaddr,
 				enum dma_data_direction direction,
-				struct dma_attrs *attrs)
+				unsigned long attrs)
 {
 	u64 rc = 0;
 	u64 proto_tce, tce;
@@ -251,7 +251,7 @@ static DEFINE_PER_CPU(__be64 *, tce_page
 static int tce_buildmulti_pSeriesLP(struct iommu_table *tbl, long tcenum,
 				     long npages, unsigned long uaddr,
 				     enum dma_data_direction direction,
-				     struct dma_attrs *attrs)
+				     unsigned long attrs)
 {
 	u64 rc = 0;
 	u64 proto_tce;
diff -puN arch/powerpc/sysdev/dart_iommu.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs arch/powerpc/sysdev/dart_iommu.c
--- a/arch/powerpc/sysdev/dart_iommu.c~powerpc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/powerpc/sysdev/dart_iommu.c
@@ -163,7 +163,7 @@ static void dart_flush(struct iommu_tabl
 static int dart_build(struct iommu_table *tbl, long index,
 		       long npages, unsigned long uaddr,
 		       enum dma_data_direction direction,
-		       struct dma_attrs *attrs)
+		       unsigned long attrs)
 {
 	unsigned int *dp;
 	unsigned int rpn;
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

dma-mapping-use-unsigned-long-for-dma_attrs.patch
alpha-dma-mapping-use-unsigned-long-for-dma_attrs.patch
arc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
arm-dma-mapping-use-unsigned-long-for-dma_attrs.patch
arm64-dma-mapping-use-unsigned-long-for-dma_attrs.patch
avr32-dma-mapping-use-unsigned-long-for-dma_attrs.patch
blackfin-dma-mapping-use-unsigned-long-for-dma_attrs.patch
c6x-dma-mapping-use-unsigned-long-for-dma_attrs.patch
cris-dma-mapping-use-unsigned-long-for-dma_attrs.patch
frv-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-exynos-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-mediatek-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-msm-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-nouveau-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-rockship-dma-mapping-use-unsigned-long-for-dma_attrs.patch
infiniband-dma-mapping-use-unsigned-long-for-dma_attrs.patch
iommu-dma-mapping-use-unsigned-long-for-dma_attrs.patch
xen-dma-mapping-use-unsigned-long-for-dma_attrs.patch
swiotlb-dma-mapping-use-unsigned-long-for-dma_attrs.patch
powerpc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
video-dma-mapping-use-unsigned-long-for-dma_attrs.patch
x86-dma-mapping-use-unsigned-long-for-dma_attrs.patch
iommu-intel-dma-mapping-use-unsigned-long-for-dma_attrs.patch
h8300-dma-mapping-use-unsigned-long-for-dma_attrs.patch
hexagon-dma-mapping-use-unsigned-long-for-dma_attrs.patch
ia64-dma-mapping-use-unsigned-long-for-dma_attrs.patch
m68k-dma-mapping-use-unsigned-long-for-dma_attrs.patch
metag-dma-mapping-use-unsigned-long-for-dma_attrs.patch
microblaze-dma-mapping-use-unsigned-long-for-dma_attrs.patch
mips-dma-mapping-use-unsigned-long-for-dma_attrs.patch
mn10300-dma-mapping-use-unsigned-long-for-dma_attrs.patch
nios2-dma-mapping-use-unsigned-long-for-dma_attrs.patch
openrisc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
parisc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
misc-mic-dma-mapping-use-unsigned-long-for-dma_attrs.patch
s390-dma-mapping-use-unsigned-long-for-dma_attrs.patch
sh-dma-mapping-use-unsigned-long-for-dma_attrs.patch
sparc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
tile-dma-mapping-use-unsigned-long-for-dma_attrs.patch
unicore32-dma-mapping-use-unsigned-long-for-dma_attrs.patch
xtensa-dma-mapping-use-unsigned-long-for-dma_attrs.patch
dma-mapping-remove-dma_get_attr.patch
dma-mapping-document-the-dma-attributes-next-to-the-declaration.patch
dma-mapping-constify-attrs-passed-to-dma_get_attr.patch
arm-dma-mapping-constify-attrs-passed-to-internal-functions.patch
arm64-dma-mapping-constify-attrs-passed-to-internal-functions.patch

