From: akpm@linux-foundation.org
Subject: + c6x-dma-mapping-use-unsigned-long-for-dma_attrs.patch added to
 -mm tree
Date: Mon, 11 Jul 2016 15:14:27 -0700
Message-ID: <57841a43.eidZgA0/mg1gFhZf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43652 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbcGKWO2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2016 18:14:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, msalter@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: c6x: dma-mapping: use unsigned long for dma_attrs
has been added to the -mm tree.  Its filename is
     c6x-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/c6x-dma-mapping-use-unsigned-long-for-dma_attrs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/c6x-dma-mapping-use-unsigned-long-for-dma_attrs.patch

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
Subject: c6x: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1467275171-6298-8-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Mark Salter <msalter@redhat.com> [c6x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/c6x/include/asm/dma-mapping.h |    4 ++--
 arch/c6x/kernel/dma.c              |    9 ++++-----
 arch/c6x/mm/dma-coherent.c         |    4 ++--
 3 files changed, 8 insertions(+), 9 deletions(-)

diff -puN arch/c6x/include/asm/dma-mapping.h~c6x-dma-mapping-use-unsigned-long-for-dma_attrs arch/c6x/include/asm/dma-mapping.h
--- a/arch/c6x/include/asm/dma-mapping.h~c6x-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/c6x/include/asm/dma-mapping.h
@@ -26,8 +26,8 @@ static inline struct dma_map_ops *get_dm
 
 extern void coherent_mem_init(u32 start, u32 size);
 void *c6x_dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
-		gfp_t gfp, struct dma_attrs *attrs);
+		gfp_t gfp, unsigned long attrs);
 void c6x_dma_free(struct device *dev, size_t size, void *vaddr,
-		dma_addr_t dma_handle, struct dma_attrs *attrs);
+		dma_addr_t dma_handle, unsigned long attrs);
 
 #endif	/* _ASM_C6X_DMA_MAPPING_H */
diff -puN arch/c6x/kernel/dma.c~c6x-dma-mapping-use-unsigned-long-for-dma_attrs arch/c6x/kernel/dma.c
--- a/arch/c6x/kernel/dma.c~c6x-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/c6x/kernel/dma.c
@@ -38,7 +38,7 @@ static void c6x_dma_sync(dma_addr_t hand
 
 static dma_addr_t c6x_dma_map_page(struct device *dev, struct page *page,
 		unsigned long offset, size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	dma_addr_t handle = virt_to_phys(page_address(page) + offset);
 
@@ -47,13 +47,13 @@ static dma_addr_t c6x_dma_map_page(struc
 }
 
 static void c6x_dma_unmap_page(struct device *dev, dma_addr_t handle,
-		size_t size, enum dma_data_direction dir, struct dma_attrs *attrs)
+		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
 	c6x_dma_sync(handle, size, dir);
 }
 
 static int c6x_dma_map_sg(struct device *dev, struct scatterlist *sglist,
-		int nents, enum dma_data_direction dir, struct dma_attrs *attrs)
+		int nents, enum dma_data_direction dir, unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -67,8 +67,7 @@ static int c6x_dma_map_sg(struct device
 }
 
 static void c6x_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
-		  int nents, enum dma_data_direction dir,
-		  struct dma_attrs *attrs)
+		  int nents, enum dma_data_direction dir, unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
diff -puN arch/c6x/mm/dma-coherent.c~c6x-dma-mapping-use-unsigned-long-for-dma_attrs arch/c6x/mm/dma-coherent.c
--- a/arch/c6x/mm/dma-coherent.c~c6x-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/c6x/mm/dma-coherent.c
@@ -74,7 +74,7 @@ static void __free_dma_pages(u32 addr, i
  * virtual and DMA address for that space.
  */
 void *c6x_dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
-		gfp_t gfp, struct dma_attrs *attrs)
+		gfp_t gfp, unsigned long attrs)
 {
 	u32 paddr;
 	int order;
@@ -99,7 +99,7 @@ void *c6x_dma_alloc(struct device *dev,
  * Free DMA coherent memory as defined by the above mapping.
  */
 void c6x_dma_free(struct device *dev, size_t size, void *vaddr,
-		dma_addr_t dma_handle, struct dma_attrs *attrs)
+		dma_addr_t dma_handle, unsigned long attrs)
 {
 	int order;
 
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

