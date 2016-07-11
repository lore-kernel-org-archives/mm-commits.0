From: akpm@linux-foundation.org
Subject: + sh-dma-mapping-use-unsigned-long-for-dma_attrs.patch added to
 -mm tree
Date: Mon, 11 Jul 2016 15:15:25 -0700
Message-ID: <57841a7d.soF6FfmSZ+S1WRmp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075AbcGKWP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2016 18:15:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: dma-mapping: use unsigned long for dma_attrs
has been added to the -mm tree.  Its filename is
     sh-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-dma-mapping-use-unsigned-long-for-dma_attrs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-dma-mapping-use-unsigned-long-for-dma_attrs.patch

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
Subject: sh: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1467275171-6298-38-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/dma-mapping.h |    4 ++--
 arch/sh/kernel/dma-nommu.c        |    4 ++--
 arch/sh/mm/consistent.c           |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/sh/include/asm/dma-mapping.h~sh-dma-mapping-use-unsigned-long-for-dma_attrs arch/sh/include/asm/dma-mapping.h
--- a/arch/sh/include/asm/dma-mapping.h~sh-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/sh/include/asm/dma-mapping.h
@@ -17,9 +17,9 @@ void dma_cache_sync(struct device *dev,
 /* arch/sh/mm/consistent.c */
 extern void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 					dma_addr_t *dma_addr, gfp_t flag,
-					struct dma_attrs *attrs);
+					unsigned long attrs);
 extern void dma_generic_free_coherent(struct device *dev, size_t size,
 				      void *vaddr, dma_addr_t dma_handle,
-				      struct dma_attrs *attrs);
+				      unsigned long attrs);
 
 #endif /* __ASM_SH_DMA_MAPPING_H */
diff -puN arch/sh/kernel/dma-nommu.c~sh-dma-mapping-use-unsigned-long-for-dma_attrs arch/sh/kernel/dma-nommu.c
--- a/arch/sh/kernel/dma-nommu.c~sh-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/sh/kernel/dma-nommu.c
@@ -13,7 +13,7 @@
 static dma_addr_t nommu_map_page(struct device *dev, struct page *page,
 				 unsigned long offset, size_t size,
 				 enum dma_data_direction dir,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	dma_addr_t addr = page_to_phys(page) + offset;
 
@@ -25,7 +25,7 @@ static dma_addr_t nommu_map_page(struct
 
 static int nommu_map_sg(struct device *dev, struct scatterlist *sg,
 			int nents, enum dma_data_direction dir,
-			struct dma_attrs *attrs)
+			unsigned long attrs)
 {
 	struct scatterlist *s;
 	int i;
diff -puN arch/sh/mm/consistent.c~sh-dma-mapping-use-unsigned-long-for-dma_attrs arch/sh/mm/consistent.c
--- a/arch/sh/mm/consistent.c~sh-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/sh/mm/consistent.c
@@ -34,7 +34,7 @@ fs_initcall(dma_init);
 
 void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 				 dma_addr_t *dma_handle, gfp_t gfp,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	void *ret, *ret_nocache;
 	int order = get_order(size);
@@ -66,7 +66,7 @@ void *dma_generic_alloc_coherent(struct
 
 void dma_generic_free_coherent(struct device *dev, size_t size,
 			       void *vaddr, dma_addr_t dma_handle,
-			       struct dma_attrs *attrs)
+			       unsigned long attrs)
 {
 	int order = get_order(size);
 	unsigned long pfn = dma_handle >> PAGE_SHIFT;
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

