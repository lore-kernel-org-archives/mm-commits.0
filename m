From: akpm@linux-foundation.org
Subject: [folded-merged]
 ia64-dma-mapping-use-unsigned-long-for-dma_attrs.patch removed from -mm
 tree
Date: Wed, 03 Aug 2016 13:14:20 -0700
Message-ID: <57a2509c.zkerzYXHPTNSjS55%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932593AbcHCUOb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:14:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: dma-mapping: use unsigned long for dma_attrs
has been removed from the -mm tree.  Its filename was
     ia64-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch was dropped because it was folded into dma-mapping-use-unsigned-long-for-dma_attrs.patch

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: ia64: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-28-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/hp/common/sba_iommu.c |   22 +++++++++++-----------
 arch/ia64/include/asm/machvec.h |    1 -
 arch/ia64/kernel/pci-swiotlb.c  |    4 ++--
 arch/ia64/sn/pci/pci_dma.c      |   12 ++++++------
 4 files changed, 19 insertions(+), 20 deletions(-)

diff -puN arch/ia64/hp/common/sba_iommu.c~ia64-dma-mapping-use-unsigned-long-for-dma_attrs arch/ia64/hp/common/sba_iommu.c
--- a/arch/ia64/hp/common/sba_iommu.c~ia64-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/ia64/hp/common/sba_iommu.c
@@ -919,7 +919,7 @@ sba_mark_invalid(struct ioc *ioc, dma_ad
 static dma_addr_t sba_map_page(struct device *dev, struct page *page,
 			       unsigned long poff, size_t size,
 			       enum dma_data_direction dir,
-			       struct dma_attrs *attrs)
+			       unsigned long attrs)
 {
 	struct ioc *ioc;
 	void *addr = page_address(page) + poff;
@@ -1005,7 +1005,7 @@ static dma_addr_t sba_map_page(struct de
 
 static dma_addr_t sba_map_single_attrs(struct device *dev, void *addr,
 				       size_t size, enum dma_data_direction dir,
-				       struct dma_attrs *attrs)
+				       unsigned long attrs)
 {
 	return sba_map_page(dev, virt_to_page(addr),
 			    (unsigned long)addr & ~PAGE_MASK, size, dir, attrs);
@@ -1046,7 +1046,7 @@ sba_mark_clean(struct ioc *ioc, dma_addr
  * See Documentation/DMA-API-HOWTO.txt
  */
 static void sba_unmap_page(struct device *dev, dma_addr_t iova, size_t size,
-			   enum dma_data_direction dir, struct dma_attrs *attrs)
+			   enum dma_data_direction dir, unsigned long attrs)
 {
 	struct ioc *ioc;
 #if DELAYED_RESOURCE_CNT > 0
@@ -1115,7 +1115,7 @@ static void sba_unmap_page(struct device
 }
 
 void sba_unmap_single_attrs(struct device *dev, dma_addr_t iova, size_t size,
-			    enum dma_data_direction dir, struct dma_attrs *attrs)
+			    enum dma_data_direction dir, unsigned long attrs)
 {
 	sba_unmap_page(dev, iova, size, dir, attrs);
 }
@@ -1130,7 +1130,7 @@ void sba_unmap_single_attrs(struct devic
  */
 static void *
 sba_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
-		   gfp_t flags, struct dma_attrs *attrs)
+		   gfp_t flags, unsigned long attrs)
 {
 	struct ioc *ioc;
 	void *addr;
@@ -1175,7 +1175,7 @@ sba_alloc_coherent(struct device *dev, s
 	 * device to map single to get an iova mapping.
 	 */
 	*dma_handle = sba_map_single_attrs(&ioc->sac_only_dev->dev, addr,
-					   size, 0, NULL);
+					   size, 0, 0);
 
 	return addr;
 }
@@ -1191,9 +1191,9 @@ sba_alloc_coherent(struct device *dev, s
  * See Documentation/DMA-API-HOWTO.txt
  */
 static void sba_free_coherent(struct device *dev, size_t size, void *vaddr,
-			      dma_addr_t dma_handle, struct dma_attrs *attrs)
+			      dma_addr_t dma_handle, unsigned long attrs)
 {
-	sba_unmap_single_attrs(dev, dma_handle, size, 0, NULL);
+	sba_unmap_single_attrs(dev, dma_handle, size, 0, 0);
 	free_pages((unsigned long) vaddr, get_order(size));
 }
 
@@ -1442,7 +1442,7 @@ sba_coalesce_chunks(struct ioc *ioc, str
 
 static void sba_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist,
 			       int nents, enum dma_data_direction dir,
-			       struct dma_attrs *attrs);
+			       unsigned long attrs);
 /**
  * sba_map_sg - map Scatter/Gather list
  * @dev: instance of PCI owned by the driver that's asking.
@@ -1455,7 +1455,7 @@ static void sba_unmap_sg_attrs(struct de
  */
 static int sba_map_sg_attrs(struct device *dev, struct scatterlist *sglist,
 			    int nents, enum dma_data_direction dir,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	struct ioc *ioc;
 	int coalesced, filled = 0;
@@ -1551,7 +1551,7 @@ static int sba_map_sg_attrs(struct devic
  */
 static void sba_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist,
 			       int nents, enum dma_data_direction dir,
-			       struct dma_attrs *attrs)
+			       unsigned long attrs)
 {
 #ifdef ASSERT_PDIR_SANITY
 	struct ioc *ioc;
diff -puN arch/ia64/include/asm/machvec.h~ia64-dma-mapping-use-unsigned-long-for-dma_attrs arch/ia64/include/asm/machvec.h
--- a/arch/ia64/include/asm/machvec.h~ia64-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/ia64/include/asm/machvec.h
@@ -22,7 +22,6 @@ struct pci_bus;
 struct task_struct;
 struct pci_dev;
 struct msi_desc;
-struct dma_attrs;
 
 typedef void ia64_mv_setup_t (char **);
 typedef void ia64_mv_cpu_init_t (void);
diff -puN arch/ia64/kernel/pci-swiotlb.c~ia64-dma-mapping-use-unsigned-long-for-dma_attrs arch/ia64/kernel/pci-swiotlb.c
--- a/arch/ia64/kernel/pci-swiotlb.c~ia64-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/ia64/kernel/pci-swiotlb.c
@@ -16,7 +16,7 @@ EXPORT_SYMBOL(swiotlb);
 
 static void *ia64_swiotlb_alloc_coherent(struct device *dev, size_t size,
 					 dma_addr_t *dma_handle, gfp_t gfp,
-					 struct dma_attrs *attrs)
+					 unsigned long attrs)
 {
 	if (dev->coherent_dma_mask != DMA_BIT_MASK(64))
 		gfp |= GFP_DMA;
@@ -25,7 +25,7 @@ static void *ia64_swiotlb_alloc_coherent
 
 static void ia64_swiotlb_free_coherent(struct device *dev, size_t size,
 				       void *vaddr, dma_addr_t dma_addr,
-				       struct dma_attrs *attrs)
+				       unsigned long attrs)
 {
 	swiotlb_free_coherent(dev, size, vaddr, dma_addr);
 }
diff -puN arch/ia64/sn/pci/pci_dma.c~ia64-dma-mapping-use-unsigned-long-for-dma_attrs arch/ia64/sn/pci/pci_dma.c
--- a/arch/ia64/sn/pci/pci_dma.c~ia64-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/ia64/sn/pci/pci_dma.c
@@ -77,7 +77,7 @@ EXPORT_SYMBOL(sn_dma_set_mask);
  */
 static void *sn_dma_alloc_coherent(struct device *dev, size_t size,
 				   dma_addr_t * dma_handle, gfp_t flags,
-				   struct dma_attrs *attrs)
+				   unsigned long attrs)
 {
 	void *cpuaddr;
 	unsigned long phys_addr;
@@ -138,7 +138,7 @@ static void *sn_dma_alloc_coherent(struc
  * any associated IOMMU mappings.
  */
 static void sn_dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
-				 dma_addr_t dma_handle, struct dma_attrs *attrs)
+				 dma_addr_t dma_handle, unsigned long attrs)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
@@ -176,7 +176,7 @@ static void sn_dma_free_coherent(struct
 static dma_addr_t sn_dma_map_page(struct device *dev, struct page *page,
 				  unsigned long offset, size_t size,
 				  enum dma_data_direction dir,
-				  struct dma_attrs *attrs)
+				  unsigned long attrs)
 {
 	void *cpu_addr = page_address(page) + offset;
 	dma_addr_t dma_addr;
@@ -218,7 +218,7 @@ static dma_addr_t sn_dma_map_page(struct
  */
 static void sn_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
 			      size_t size, enum dma_data_direction dir,
-			      struct dma_attrs *attrs)
+			      unsigned long attrs)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
@@ -240,7 +240,7 @@ static void sn_dma_unmap_page(struct dev
  */
 static void sn_dma_unmap_sg(struct device *dev, struct scatterlist *sgl,
 			    int nhwentries, enum dma_data_direction dir,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	int i;
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -273,7 +273,7 @@ static void sn_dma_unmap_sg(struct devic
  */
 static int sn_dma_map_sg(struct device *dev, struct scatterlist *sgl,
 			 int nhwentries, enum dma_data_direction dir,
-			 struct dma_attrs *attrs)
+			 unsigned long attrs)
 {
 	unsigned long phys_addr;
 	struct scatterlist *saved_sg = sgl, *sg;
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

media-mtk-vcodec-remove-unused-dma_attrs.patch
dma-mapping-use-unsigned-long-for-dma_attrs.patch
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

