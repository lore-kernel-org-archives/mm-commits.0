From: akpm@linux-foundation.org
Subject: + parisc-dma-mapping-use-unsigned-long-for-dma_attrs.patch added
 to -mm tree
Date: Wed, 13 Jul 2016 14:51:54 -0700
Message-ID: <5786b7fa.ZWa+010IlwB5mOr6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41264 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbcGMVvz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 17:51:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: dma-mapping: use unsigned long for dma_attrs
has been added to the -mm tree.  Its filename is
     parisc-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parisc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parisc-dma-mapping-use-unsigned-long-for-dma_attrs.patch

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
Subject: parisc: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-36-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/pci-dma.c |   16 ++++++++--------
 drivers/parisc/ccio-dma.c    |   16 ++++++++--------
 drivers/parisc/sba_iommu.c   |   16 ++++++++--------
 3 files changed, 24 insertions(+), 24 deletions(-)

diff -puN arch/parisc/kernel/pci-dma.c~parisc-dma-mapping-use-unsigned-long-for-dma_attrs arch/parisc/kernel/pci-dma.c
--- a/arch/parisc/kernel/pci-dma.c~parisc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/parisc/kernel/pci-dma.c
@@ -414,7 +414,7 @@ pcxl_dma_init(void)
 __initcall(pcxl_dma_init);
 
 static void *pa11_dma_alloc(struct device *dev, size_t size,
-		dma_addr_t *dma_handle, gfp_t flag, struct dma_attrs *attrs)
+		dma_addr_t *dma_handle, gfp_t flag, unsigned long attrs)
 {
 	unsigned long vaddr;
 	unsigned long paddr;
@@ -441,7 +441,7 @@ static void *pa11_dma_alloc(struct devic
 }
 
 static void pa11_dma_free(struct device *dev, size_t size, void *vaddr,
-		dma_addr_t dma_handle, struct dma_attrs *attrs)
+		dma_addr_t dma_handle, unsigned long attrs)
 {
 	int order;
 
@@ -454,7 +454,7 @@ static void pa11_dma_free(struct device
 
 static dma_addr_t pa11_dma_map_page(struct device *dev, struct page *page,
 		unsigned long offset, size_t size,
-		enum dma_data_direction direction, struct dma_attrs *attrs)
+		enum dma_data_direction direction, unsigned long attrs)
 {
 	void *addr = page_address(page) + offset;
 	BUG_ON(direction == DMA_NONE);
@@ -465,7 +465,7 @@ static dma_addr_t pa11_dma_map_page(stru
 
 static void pa11_dma_unmap_page(struct device *dev, dma_addr_t dma_handle,
 		size_t size, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	BUG_ON(direction == DMA_NONE);
 
@@ -484,7 +484,7 @@ static void pa11_dma_unmap_page(struct d
 
 static int pa11_dma_map_sg(struct device *dev, struct scatterlist *sglist,
 		int nents, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	int i;
 	struct scatterlist *sg;
@@ -503,7 +503,7 @@ static int pa11_dma_map_sg(struct device
 
 static void pa11_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 		int nents, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	int i;
 	struct scatterlist *sg;
@@ -577,7 +577,7 @@ struct dma_map_ops pcxl_dma_ops = {
 };
 
 static void *pcx_dma_alloc(struct device *dev, size_t size,
-		dma_addr_t *dma_handle, gfp_t flag, struct dma_attrs *attrs)
+		dma_addr_t *dma_handle, gfp_t flag, unsigned long attrs)
 {
 	void *addr;
 
@@ -592,7 +592,7 @@ static void *pcx_dma_alloc(struct device
 }
 
 static void pcx_dma_free(struct device *dev, size_t size, void *vaddr,
-		dma_addr_t iova, struct dma_attrs *attrs)
+		dma_addr_t iova, unsigned long attrs)
 {
 	free_pages((unsigned long)vaddr, get_order(size));
 	return;
diff -puN drivers/parisc/ccio-dma.c~parisc-dma-mapping-use-unsigned-long-for-dma_attrs drivers/parisc/ccio-dma.c
--- a/drivers/parisc/ccio-dma.c~parisc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/parisc/ccio-dma.c
@@ -790,7 +790,7 @@ ccio_map_single(struct device *dev, void
 static dma_addr_t
 ccio_map_page(struct device *dev, struct page *page, unsigned long offset,
 		size_t size, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	return ccio_map_single(dev, page_address(page) + offset, size,
 			direction);
@@ -806,7 +806,7 @@ ccio_map_page(struct device *dev, struct
  */
 static void 
 ccio_unmap_page(struct device *dev, dma_addr_t iova, size_t size,
-		enum dma_data_direction direction, struct dma_attrs *attrs)
+		enum dma_data_direction direction, unsigned long attrs)
 {
 	struct ioc *ioc;
 	unsigned long flags; 
@@ -844,7 +844,7 @@ ccio_unmap_page(struct device *dev, dma_
  */
 static void * 
 ccio_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle, gfp_t flag,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
       void *ret;
 #if 0
@@ -878,9 +878,9 @@ ccio_alloc(struct device *dev, size_t si
  */
 static void 
 ccio_free(struct device *dev, size_t size, void *cpu_addr,
-		dma_addr_t dma_handle, struct dma_attrs *attrs)
+		dma_addr_t dma_handle, unsigned long attrs)
 {
-	ccio_unmap_page(dev, dma_handle, size, 0, NULL);
+	ccio_unmap_page(dev, dma_handle, size, 0, 0);
 	free_pages((unsigned long)cpu_addr, get_order(size));
 }
 
@@ -907,7 +907,7 @@ ccio_free(struct device *dev, size_t siz
  */
 static int
 ccio_map_sg(struct device *dev, struct scatterlist *sglist, int nents, 
-	    enum dma_data_direction direction, struct dma_attrs *attrs)
+	    enum dma_data_direction direction, unsigned long attrs)
 {
 	struct ioc *ioc;
 	int coalesced, filled = 0;
@@ -984,7 +984,7 @@ ccio_map_sg(struct device *dev, struct s
  */
 static void 
 ccio_unmap_sg(struct device *dev, struct scatterlist *sglist, int nents, 
-	      enum dma_data_direction direction, struct dma_attrs *attrs)
+	      enum dma_data_direction direction, unsigned long attrs)
 {
 	struct ioc *ioc;
 
@@ -1004,7 +1004,7 @@ ccio_unmap_sg(struct device *dev, struct
 		ioc->usg_pages += sg_dma_len(sglist) >> PAGE_SHIFT;
 #endif
 		ccio_unmap_page(dev, sg_dma_address(sglist),
-				  sg_dma_len(sglist), direction, NULL);
+				  sg_dma_len(sglist), direction, 0);
 		++sglist;
 	}
 
diff -puN drivers/parisc/sba_iommu.c~parisc-dma-mapping-use-unsigned-long-for-dma_attrs drivers/parisc/sba_iommu.c
--- a/drivers/parisc/sba_iommu.c~parisc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/parisc/sba_iommu.c
@@ -783,7 +783,7 @@ sba_map_single(struct device *dev, void
 static dma_addr_t
 sba_map_page(struct device *dev, struct page *page, unsigned long offset,
 		size_t size, enum dma_data_direction direction,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	return sba_map_single(dev, page_address(page) + offset, size,
 			direction);
@@ -801,7 +801,7 @@ sba_map_page(struct device *dev, struct
  */
 static void
 sba_unmap_page(struct device *dev, dma_addr_t iova, size_t size,
-		enum dma_data_direction direction, struct dma_attrs *attrs)
+		enum dma_data_direction direction, unsigned long attrs)
 {
 	struct ioc *ioc;
 #if DELAYED_RESOURCE_CNT > 0
@@ -876,7 +876,7 @@ sba_unmap_page(struct device *dev, dma_a
  * See Documentation/DMA-API-HOWTO.txt
  */
 static void *sba_alloc(struct device *hwdev, size_t size, dma_addr_t *dma_handle,
-		gfp_t gfp, struct dma_attrs *attrs)
+		gfp_t gfp, unsigned long attrs)
 {
 	void *ret;
 
@@ -908,9 +908,9 @@ static void *sba_alloc(struct device *hw
  */
 static void
 sba_free(struct device *hwdev, size_t size, void *vaddr,
-		    dma_addr_t dma_handle, struct dma_attrs *attrs)
+		    dma_addr_t dma_handle, unsigned long attrs)
 {
-	sba_unmap_page(hwdev, dma_handle, size, 0, NULL);
+	sba_unmap_page(hwdev, dma_handle, size, 0, 0);
 	free_pages((unsigned long) vaddr, get_order(size));
 }
 
@@ -943,7 +943,7 @@ int dump_run_sg = 0;
  */
 static int
 sba_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
-	   enum dma_data_direction direction, struct dma_attrs *attrs)
+	   enum dma_data_direction direction, unsigned long attrs)
 {
 	struct ioc *ioc;
 	int coalesced, filled = 0;
@@ -1026,7 +1026,7 @@ sba_map_sg(struct device *dev, struct sc
  */
 static void 
 sba_unmap_sg(struct device *dev, struct scatterlist *sglist, int nents,
-	     enum dma_data_direction direction, struct dma_attrs *attrs)
+	     enum dma_data_direction direction, unsigned long attrs)
 {
 	struct ioc *ioc;
 #ifdef ASSERT_PDIR_SANITY
@@ -1051,7 +1051,7 @@ sba_unmap_sg(struct device *dev, struct
 	while (sg_dma_len(sglist) && nents--) {
 
 		sba_unmap_page(dev, sg_dma_address(sglist), sg_dma_len(sglist),
-				direction, NULL);
+				direction, 0);
 #ifdef SBA_COLLECT_STATS
 		ioc->usg_pages += ((sg_dma_address(sglist) & ~IOVP_MASK) + sg_dma_len(sglist) + IOVP_SIZE - 1) >> PAGE_SHIFT;
 		ioc->usingle_calls--;	/* kluge since call is unmap_sg() */
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

media-mtk-vcodec-remove-unused-dma_attrs.patch
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

