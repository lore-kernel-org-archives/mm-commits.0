From: akpm@linux-foundation.org
Subject: [wrecked]
 arm64-dma-mapping-constify-attrs-passed-to-internal-functions.patch removed from -mm tree
Date: Mon, 11 Jul 2016 15:18:00 -0700
Message-ID: <57841b18.DJ/VvDlH+uP+VIs6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254AbcGKWSB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2016 18:18:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, catalin.marinas@arm.com, joro@8bytes.org, konrad.wilk@oracle.com, linux@armlinux.org.uk, m.szyprowski@samsung.com, sstabellini@kernel.org, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: dma-mapping: constify attrs passed to internal functions
has been removed from the -mm tree.  Its filename was
     arm64-dma-mapping-constify-attrs-passed-to-internal-functions.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: arm64: dma-mapping: constify attrs passed to internal functions

Some of the non-exported functions do not modify passed dma_attrs so the
pointer can point to const data.

Link: http://lkml.kernel.org/r/1464071290-15948-4-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/dma-mapping.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/arm64/mm/dma-mapping.c~arm64-dma-mapping-constify-attrs-passed-to-internal-functions arch/arm64/mm/dma-mapping.c
--- a/arch/arm64/mm/dma-mapping.c~arm64-dma-mapping-constify-attrs-passed-to-internal-functions
+++ a/arch/arm64/mm/dma-mapping.c
@@ -29,7 +29,7 @@
 
 #include <asm/cacheflush.h>
 
-static pgprot_t __get_dma_pgprot(struct dma_attrs *attrs, pgprot_t prot,
+static pgprot_t __get_dma_pgprot(const struct dma_attrs *attrs, pgprot_t prot,
 				 bool coherent)
 {
 	if (!coherent || dma_get_attr(DMA_ATTR_WRITE_COMBINE, attrs))
@@ -88,7 +88,7 @@ static int __free_from_pool(void *start,
 
 static void *__dma_alloc_coherent(struct device *dev, size_t size,
 				  dma_addr_t *dma_handle, gfp_t flags,
-				  struct dma_attrs *attrs)
+				  const struct dma_attrs *attrs)
 {
 	if (dev == NULL) {
 		WARN_ONCE(1, "Use an actual device structure for DMA allocation\n");
@@ -118,7 +118,7 @@ static void *__dma_alloc_coherent(struct
 
 static void __dma_free_coherent(struct device *dev, size_t size,
 				void *vaddr, dma_addr_t dma_handle,
-				struct dma_attrs *attrs)
+				const struct dma_attrs *attrs)
 {
 	bool freed;
 	phys_addr_t paddr = dma_to_phys(dev, dma_handle);
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

