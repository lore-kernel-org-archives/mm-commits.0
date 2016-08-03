From: akpm@linux-foundation.org
Subject: [folded-merged]
 xen-dma-mapping-use-unsigned-long-for-dma_attrs.patch removed from -mm tree
Date: Wed, 03 Aug 2016 13:14:04 -0700
Message-ID: <57a2508c.ApStJw5XaeaWYOjg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38988 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758266AbcHCUO2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:14:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, david.vrabel@citrix.com, konrad.wilk@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: xen: dma-mapping: use unsigned long for dma_attrs
has been removed from the -mm tree.  Its filename was
     xen-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch was dropped because it was folded into dma-mapping-use-unsigned-long-for-dma_attrs.patch

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: xen: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-20-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: David Vrabel <david.vrabel@citrix.com> [xen]
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> [xen swiotlb]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/swiotlb-xen.c |   14 +++++++-------
 include/xen/swiotlb-xen.h |   12 ++++++------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/xen/swiotlb-xen.c~xen-dma-mapping-use-unsigned-long-for-dma_attrs drivers/xen/swiotlb-xen.c
--- a/drivers/xen/swiotlb-xen.c~xen-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/xen/swiotlb-xen.c
@@ -294,7 +294,7 @@ error:
 void *
 xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			   dma_addr_t *dma_handle, gfp_t flags,
-			   struct dma_attrs *attrs)
+			   unsigned long attrs)
 {
 	void *ret;
 	int order = get_order(size);
@@ -346,7 +346,7 @@ EXPORT_SYMBOL_GPL(xen_swiotlb_alloc_cohe
 
 void
 xen_swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
-			  dma_addr_t dev_addr, struct dma_attrs *attrs)
+			  dma_addr_t dev_addr, unsigned long attrs)
 {
 	int order = get_order(size);
 	phys_addr_t phys;
@@ -378,7 +378,7 @@ EXPORT_SYMBOL_GPL(xen_swiotlb_free_coher
 dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 				unsigned long offset, size_t size,
 				enum dma_data_direction dir,
-				struct dma_attrs *attrs)
+				unsigned long attrs)
 {
 	phys_addr_t map, phys = page_to_phys(page) + offset;
 	dma_addr_t dev_addr = xen_phys_to_bus(phys);
@@ -434,7 +434,7 @@ EXPORT_SYMBOL_GPL(xen_swiotlb_map_page);
  */
 static void xen_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
 			     size_t size, enum dma_data_direction dir,
-				 struct dma_attrs *attrs)
+			     unsigned long attrs)
 {
 	phys_addr_t paddr = xen_bus_to_phys(dev_addr);
 
@@ -462,7 +462,7 @@ static void xen_unmap_single(struct devi
 
 void xen_swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
 			    size_t size, enum dma_data_direction dir,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	xen_unmap_single(hwdev, dev_addr, size, dir, attrs);
 }
@@ -538,7 +538,7 @@ EXPORT_SYMBOL_GPL(xen_swiotlb_sync_singl
 int
 xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 			 int nelems, enum dma_data_direction dir,
-			 struct dma_attrs *attrs)
+			 unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -599,7 +599,7 @@ EXPORT_SYMBOL_GPL(xen_swiotlb_map_sg_att
 void
 xen_swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 			   int nelems, enum dma_data_direction dir,
-			   struct dma_attrs *attrs)
+			   unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
diff -puN include/xen/swiotlb-xen.h~xen-dma-mapping-use-unsigned-long-for-dma_attrs include/xen/swiotlb-xen.h
--- a/include/xen/swiotlb-xen.h~xen-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/include/xen/swiotlb-xen.h
@@ -9,30 +9,30 @@ extern int xen_swiotlb_init(int verbose,
 extern void
 *xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			    dma_addr_t *dma_handle, gfp_t flags,
-			    struct dma_attrs *attrs);
+			    unsigned long attrs);
 
 extern void
 xen_swiotlb_free_coherent(struct device *hwdev, size_t size,
 			  void *vaddr, dma_addr_t dma_handle,
-			  struct dma_attrs *attrs);
+			  unsigned long attrs);
 
 extern dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 				       unsigned long offset, size_t size,
 				       enum dma_data_direction dir,
-				       struct dma_attrs *attrs);
+				       unsigned long attrs);
 
 extern void xen_swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
 				   size_t size, enum dma_data_direction dir,
-				   struct dma_attrs *attrs);
+				   unsigned long attrs);
 extern int
 xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 			 int nelems, enum dma_data_direction dir,
-			 struct dma_attrs *attrs);
+			 unsigned long attrs);
 
 extern void
 xen_swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 			   int nelems, enum dma_data_direction dir,
-			   struct dma_attrs *attrs);
+			   unsigned long attrs);
 
 extern void
 xen_swiotlb_sync_single_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

media-mtk-vcodec-remove-unused-dma_attrs.patch
dma-mapping-use-unsigned-long-for-dma_attrs.patch
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
remoteproc-qcom-use-unsigned-long-for-dma_attrs.patch
dma-mapping-remove-dma_get_attr.patch
dma-mapping-document-the-dma-attributes-next-to-the-declaration.patch

