From: akpm@linux-foundation.org
Subject: [folded-merged]
 iommu-dma-mapping-use-unsigned-long-for-dma_attrs.patch removed from -mm
 tree
Date: Wed, 03 Aug 2016 13:14:00 -0700
Message-ID: <57a25088.OH08BS4023TGrPbi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758264AbcHCUO2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:14:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, jroedel@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: iommu: dma-mapping: use unsigned long for dma_attrs
has been removed from the -mm tree.  Its filename was
     iommu-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch was dropped because it was folded into dma-mapping-use-unsigned-long-for-dma_attrs.patch

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: iommu: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-18-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Joerg Roedel <jroedel@suse.de> [iommu]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/amd_iommu.c |   12 ++++++------
 drivers/iommu/dma-iommu.c |    6 +++---
 include/linux/dma-iommu.h |    6 +++---
 3 files changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/iommu/amd_iommu.c~iommu-dma-mapping-use-unsigned-long-for-dma_attrs drivers/iommu/amd_iommu.c
--- a/drivers/iommu/amd_iommu.c~iommu-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/iommu/amd_iommu.c
@@ -2375,7 +2375,7 @@ static void __unmap_single(struct dma_op
 static dma_addr_t map_page(struct device *dev, struct page *page,
 			   unsigned long offset, size_t size,
 			   enum dma_data_direction dir,
-			   struct dma_attrs *attrs)
+			   unsigned long attrs)
 {
 	phys_addr_t paddr = page_to_phys(page) + offset;
 	struct protection_domain *domain;
@@ -2398,7 +2398,7 @@ static dma_addr_t map_page(struct device
  * The exported unmap_single function for dma_ops.
  */
 static void unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
-		       enum dma_data_direction dir, struct dma_attrs *attrs)
+		       enum dma_data_direction dir, unsigned long attrs)
 {
 	struct protection_domain *domain;
 	struct dma_ops_domain *dma_dom;
@@ -2444,7 +2444,7 @@ static int sg_num_pages(struct device *d
  */
 static int map_sg(struct device *dev, struct scatterlist *sglist,
 		  int nelems, enum dma_data_direction direction,
-		  struct dma_attrs *attrs)
+		  unsigned long attrs)
 {
 	int mapped_pages = 0, npages = 0, prot = 0, i;
 	struct protection_domain *domain;
@@ -2525,7 +2525,7 @@ out_err:
  */
 static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 		     int nelems, enum dma_data_direction dir,
-		     struct dma_attrs *attrs)
+		     unsigned long attrs)
 {
 	struct protection_domain *domain;
 	struct dma_ops_domain *dma_dom;
@@ -2548,7 +2548,7 @@ static void unmap_sg(struct device *dev,
  */
 static void *alloc_coherent(struct device *dev, size_t size,
 			    dma_addr_t *dma_addr, gfp_t flag,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	u64 dma_mask = dev->coherent_dma_mask;
 	struct protection_domain *domain;
@@ -2604,7 +2604,7 @@ out_free:
  */
 static void free_coherent(struct device *dev, size_t size,
 			  void *virt_addr, dma_addr_t dma_addr,
-			  struct dma_attrs *attrs)
+			  unsigned long attrs)
 {
 	struct protection_domain *domain;
 	struct dma_ops_domain *dma_dom;
diff -puN drivers/iommu/dma-iommu.c~iommu-dma-mapping-use-unsigned-long-for-dma_attrs drivers/iommu/dma-iommu.c
--- a/drivers/iommu/dma-iommu.c~iommu-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/iommu/dma-iommu.c
@@ -286,7 +286,7 @@ void iommu_dma_free(struct device *dev,
  *	   or NULL on failure.
  */
 struct page **iommu_dma_alloc(struct device *dev, size_t size, gfp_t gfp,
-		struct dma_attrs *attrs, int prot, dma_addr_t *handle,
+		unsigned long attrs, int prot, dma_addr_t *handle,
 		void (*flush_page)(struct device *, const void *, phys_addr_t))
 {
 	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
@@ -400,7 +400,7 @@ dma_addr_t iommu_dma_map_page(struct dev
 }
 
 void iommu_dma_unmap_page(struct device *dev, dma_addr_t handle, size_t size,
-		enum dma_data_direction dir, struct dma_attrs *attrs)
+		enum dma_data_direction dir, unsigned long attrs)
 {
 	__iommu_dma_unmap(iommu_get_domain_for_dev(dev), handle);
 }
@@ -560,7 +560,7 @@ out_restore_sg:
 }
 
 void iommu_dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
-		enum dma_data_direction dir, struct dma_attrs *attrs)
+		enum dma_data_direction dir, unsigned long attrs)
 {
 	/*
 	 * The scatterlist segments are mapped into a single
diff -puN include/linux/dma-iommu.h~iommu-dma-mapping-use-unsigned-long-for-dma_attrs include/linux/dma-iommu.h
--- a/include/linux/dma-iommu.h~iommu-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/include/linux/dma-iommu.h
@@ -39,7 +39,7 @@ int dma_direction_to_prot(enum dma_data_
  * the arch code to take care of attributes and cache maintenance
  */
 struct page **iommu_dma_alloc(struct device *dev, size_t size, gfp_t gfp,
-		struct dma_attrs *attrs, int prot, dma_addr_t *handle,
+		unsigned long attrs, int prot, dma_addr_t *handle,
 		void (*flush_page)(struct device *, const void *, phys_addr_t));
 void iommu_dma_free(struct device *dev, struct page **pages, size_t size,
 		dma_addr_t *handle);
@@ -56,9 +56,9 @@ int iommu_dma_map_sg(struct device *dev,
  * directly as DMA mapping callbacks for simplicity
  */
 void iommu_dma_unmap_page(struct device *dev, dma_addr_t handle, size_t size,
-		enum dma_data_direction dir, struct dma_attrs *attrs);
+		enum dma_data_direction dir, unsigned long attrs);
 void iommu_dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
-		enum dma_data_direction dir, struct dma_attrs *attrs);
+		enum dma_data_direction dir, unsigned long attrs);
 int iommu_dma_supported(struct device *dev, u64 mask);
 int iommu_dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
 
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

media-mtk-vcodec-remove-unused-dma_attrs.patch
dma-mapping-use-unsigned-long-for-dma_attrs.patch
media-dma-mapping-use-unsigned-long-for-dma_attrs.patch
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
remoteproc-qcom-use-unsigned-long-for-dma_attrs.patch
dma-mapping-remove-dma_get_attr.patch
dma-mapping-document-the-dma-attributes-next-to-the-declaration.patch

