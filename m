From: akpm@linux-foundation.org
Subject: + sparc-dma-mapping-use-unsigned-long-for-dma_attrs.patch added
 to -mm tree
Date: Mon, 11 Jul 2016 15:15:27 -0700
Message-ID: <57841a7f.3sXZ0seX/wXez7kG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075AbcGKWP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2016 18:15:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc: dma-mapping: use unsigned long for dma_attrs
has been added to the -mm tree.  Its filename is
     sparc-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sparc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sparc-dma-mapping-use-unsigned-long-for-dma_attrs.patch

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
Subject: sparc: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1467275171-6298-39-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/iommu.c     |   12 ++++++------
 arch/sparc/kernel/ioport.c    |   24 ++++++++++++------------
 arch/sparc/kernel/pci_sun4v.c |   12 ++++++------
 3 files changed, 24 insertions(+), 24 deletions(-)

diff -puN arch/sparc/kernel/iommu.c~sparc-dma-mapping-use-unsigned-long-for-dma_attrs arch/sparc/kernel/iommu.c
--- a/arch/sparc/kernel/iommu.c~sparc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/sparc/kernel/iommu.c
@@ -196,7 +196,7 @@ static inline void iommu_free_ctx(struct
 
 static void *dma_4u_alloc_coherent(struct device *dev, size_t size,
 				   dma_addr_t *dma_addrp, gfp_t gfp,
-				   struct dma_attrs *attrs)
+				   unsigned long attrs)
 {
 	unsigned long order, first_page;
 	struct iommu *iommu;
@@ -245,7 +245,7 @@ static void *dma_4u_alloc_coherent(struc
 
 static void dma_4u_free_coherent(struct device *dev, size_t size,
 				 void *cpu, dma_addr_t dvma,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	struct iommu *iommu;
 	unsigned long order, npages;
@@ -263,7 +263,7 @@ static void dma_4u_free_coherent(struct
 static dma_addr_t dma_4u_map_page(struct device *dev, struct page *page,
 				  unsigned long offset, size_t sz,
 				  enum dma_data_direction direction,
-				  struct dma_attrs *attrs)
+				  unsigned long attrs)
 {
 	struct iommu *iommu;
 	struct strbuf *strbuf;
@@ -385,7 +385,7 @@ do_flush_sync:
 
 static void dma_4u_unmap_page(struct device *dev, dma_addr_t bus_addr,
 			      size_t sz, enum dma_data_direction direction,
-			      struct dma_attrs *attrs)
+			      unsigned long attrs)
 {
 	struct iommu *iommu;
 	struct strbuf *strbuf;
@@ -431,7 +431,7 @@ static void dma_4u_unmap_page(struct dev
 
 static int dma_4u_map_sg(struct device *dev, struct scatterlist *sglist,
 			 int nelems, enum dma_data_direction direction,
-			 struct dma_attrs *attrs)
+			 unsigned long attrs)
 {
 	struct scatterlist *s, *outs, *segstart;
 	unsigned long flags, handle, prot, ctx;
@@ -607,7 +607,7 @@ static unsigned long fetch_sg_ctx(struct
 
 static void dma_4u_unmap_sg(struct device *dev, struct scatterlist *sglist,
 			    int nelems, enum dma_data_direction direction,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	unsigned long flags, ctx;
 	struct scatterlist *sg;
diff -puN arch/sparc/kernel/ioport.c~sparc-dma-mapping-use-unsigned-long-for-dma_attrs arch/sparc/kernel/ioport.c
--- a/arch/sparc/kernel/ioport.c~sparc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/sparc/kernel/ioport.c
@@ -260,7 +260,7 @@ EXPORT_SYMBOL(sbus_set_sbus64);
  */
 static void *sbus_alloc_coherent(struct device *dev, size_t len,
 				 dma_addr_t *dma_addrp, gfp_t gfp,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	struct platform_device *op = to_platform_device(dev);
 	unsigned long len_total = PAGE_ALIGN(len);
@@ -315,7 +315,7 @@ err_nopages:
 }
 
 static void sbus_free_coherent(struct device *dev, size_t n, void *p,
-			       dma_addr_t ba, struct dma_attrs *attrs)
+			       dma_addr_t ba, unsigned long attrs)
 {
 	struct resource *res;
 	struct page *pgv;
@@ -355,7 +355,7 @@ static void sbus_free_coherent(struct de
 static dma_addr_t sbus_map_page(struct device *dev, struct page *page,
 				unsigned long offset, size_t len,
 				enum dma_data_direction dir,
-				struct dma_attrs *attrs)
+				unsigned long attrs)
 {
 	void *va = page_address(page) + offset;
 
@@ -371,20 +371,20 @@ static dma_addr_t sbus_map_page(struct d
 }
 
 static void sbus_unmap_page(struct device *dev, dma_addr_t ba, size_t n,
-			    enum dma_data_direction dir, struct dma_attrs *attrs)
+			    enum dma_data_direction dir, unsigned long attrs)
 {
 	mmu_release_scsi_one(dev, ba, n);
 }
 
 static int sbus_map_sg(struct device *dev, struct scatterlist *sg, int n,
-		       enum dma_data_direction dir, struct dma_attrs *attrs)
+		       enum dma_data_direction dir, unsigned long attrs)
 {
 	mmu_get_scsi_sgl(dev, sg, n);
 	return n;
 }
 
 static void sbus_unmap_sg(struct device *dev, struct scatterlist *sg, int n,
-			  enum dma_data_direction dir, struct dma_attrs *attrs)
+			  enum dma_data_direction dir, unsigned long attrs)
 {
 	mmu_release_scsi_sgl(dev, sg, n);
 }
@@ -429,7 +429,7 @@ arch_initcall(sparc_register_ioport);
  */
 static void *pci32_alloc_coherent(struct device *dev, size_t len,
 				  dma_addr_t *pba, gfp_t gfp,
-				  struct dma_attrs *attrs)
+				  unsigned long attrs)
 {
 	unsigned long len_total = PAGE_ALIGN(len);
 	void *va;
@@ -482,7 +482,7 @@ err_nopages:
  * past this call are illegal.
  */
 static void pci32_free_coherent(struct device *dev, size_t n, void *p,
-				dma_addr_t ba, struct dma_attrs *attrs)
+				dma_addr_t ba, unsigned long attrs)
 {
 	struct resource *res;
 
@@ -518,14 +518,14 @@ static void pci32_free_coherent(struct d
 static dma_addr_t pci32_map_page(struct device *dev, struct page *page,
 				 unsigned long offset, size_t size,
 				 enum dma_data_direction dir,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	/* IIep is write-through, not flushing. */
 	return page_to_phys(page) + offset;
 }
 
 static void pci32_unmap_page(struct device *dev, dma_addr_t ba, size_t size,
-			     enum dma_data_direction dir, struct dma_attrs *attrs)
+			     enum dma_data_direction dir, unsigned long attrs)
 {
 	if (dir != PCI_DMA_TODEVICE)
 		dma_make_coherent(ba, PAGE_ALIGN(size));
@@ -548,7 +548,7 @@ static void pci32_unmap_page(struct devi
  */
 static int pci32_map_sg(struct device *device, struct scatterlist *sgl,
 			int nents, enum dma_data_direction dir,
-			struct dma_attrs *attrs)
+			unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int n;
@@ -567,7 +567,7 @@ static int pci32_map_sg(struct device *d
  */
 static void pci32_unmap_sg(struct device *dev, struct scatterlist *sgl,
 			   int nents, enum dma_data_direction dir,
-			   struct dma_attrs *attrs)
+			   unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int n;
diff -puN arch/sparc/kernel/pci_sun4v.c~sparc-dma-mapping-use-unsigned-long-for-dma_attrs arch/sparc/kernel/pci_sun4v.c
--- a/arch/sparc/kernel/pci_sun4v.c~sparc-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/sparc/kernel/pci_sun4v.c
@@ -130,7 +130,7 @@ static inline long iommu_batch_end(void)
 
 static void *dma_4v_alloc_coherent(struct device *dev, size_t size,
 				   dma_addr_t *dma_addrp, gfp_t gfp,
-				   struct dma_attrs *attrs)
+				   unsigned long attrs)
 {
 	unsigned long flags, order, first_page, npages, n;
 	struct iommu *iommu;
@@ -213,7 +213,7 @@ static void dma_4v_iommu_demap(void *dem
 }
 
 static void dma_4v_free_coherent(struct device *dev, size_t size, void *cpu,
-				 dma_addr_t dvma, struct dma_attrs *attrs)
+				 dma_addr_t dvma, unsigned long attrs)
 {
 	struct pci_pbm_info *pbm;
 	struct iommu *iommu;
@@ -235,7 +235,7 @@ static void dma_4v_free_coherent(struct
 static dma_addr_t dma_4v_map_page(struct device *dev, struct page *page,
 				  unsigned long offset, size_t sz,
 				  enum dma_data_direction direction,
-				  struct dma_attrs *attrs)
+				  unsigned long attrs)
 {
 	struct iommu *iommu;
 	unsigned long flags, npages, oaddr;
@@ -294,7 +294,7 @@ iommu_map_fail:
 
 static void dma_4v_unmap_page(struct device *dev, dma_addr_t bus_addr,
 			      size_t sz, enum dma_data_direction direction,
-			      struct dma_attrs *attrs)
+			      unsigned long attrs)
 {
 	struct pci_pbm_info *pbm;
 	struct iommu *iommu;
@@ -322,7 +322,7 @@ static void dma_4v_unmap_page(struct dev
 
 static int dma_4v_map_sg(struct device *dev, struct scatterlist *sglist,
 			 int nelems, enum dma_data_direction direction,
-			 struct dma_attrs *attrs)
+			 unsigned long attrs)
 {
 	struct scatterlist *s, *outs, *segstart;
 	unsigned long flags, handle, prot;
@@ -466,7 +466,7 @@ iommu_map_failed:
 
 static void dma_4v_unmap_sg(struct device *dev, struct scatterlist *sglist,
 			    int nelems, enum dma_data_direction direction,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	struct pci_pbm_info *pbm;
 	struct scatterlist *sg;
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

