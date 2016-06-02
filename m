From: akpm@linux-foundation.org
Subject: +
 arm64-dma-mapping-constify-attrs-passed-to-internal-functions.patch added
 to -mm tree
Date: Thu, 02 Jun 2016 16:11:08 -0700
Message-ID: <5750bd0c.+Cir/LXkvt4y/vR6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52917 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090AbcFBXLJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 19:11:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, catalin.marinas@arm.com, joro@8bytes.org, konrad.wilk@oracle.com, linux@armlinux.org.uk, m.szyprowski@samsung.com, sstabellini@kernel.org, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: dma-mapping: constify attrs passed to internal functions
has been added to the -mm tree.  Its filename is
     arm64-dma-mapping-constify-attrs-passed-to-internal-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-dma-mapping-constify-attrs-passed-to-internal-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-dma-mapping-constify-attrs-passed-to-internal-functions.patch

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

dma-mapping-constify-attrs-passed-to-dma_get_attr.patch
arm-dma-mapping-constify-attrs-passed-to-internal-functions.patch
arm64-dma-mapping-constify-attrs-passed-to-internal-functions.patch

