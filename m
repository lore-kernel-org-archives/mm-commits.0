From: akpm@linux-foundation.org
Subject: + instmem-gk20a-do-not-use-non-portable-dma_to_phys.patch added
 to -mm tree
Date: Tue, 10 Nov 2015 15:02:56 -0800
Message-ID: <564277a0.7FsV6PD3IRnyfISG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36626 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbbKJXC5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 18:02:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acourbot@nvidia.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: instmem/gk20a: do not use non-portable dma_to_phys()
has been added to the -mm tree.  Its filename is
     instmem-gk20a-do-not-use-non-portable-dma_to_phys.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/instmem-gk20a-do-not-use-non-portable-dma_to_phys.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/instmem-gk20a-do-not-use-non-portable-dma_to_phys.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Courbot <acourbot@nvidia.com>
Subject: instmem/gk20a: do not use non-portable dma_to_phys()

dma_to_phys() is not guaranteed to be available on all platforms and
should not be used outside of arch/. Replace it with what it is expected
to do in our case: simply cast the DMA handle to a physical address.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c~instmem-gk20a-do-not-use-non-portable-dma_to_phys drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c~instmem-gk20a-do-not-use-non-portable-dma_to_phys
+++ a/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c
@@ -134,13 +134,17 @@ static void __iomem *
 gk20a_instobj_cpu_map_dma(struct nvkm_memory *memory)
 {
 	struct gk20a_instobj_dma *node = gk20a_instobj_dma(memory);
-	struct device *dev = node->base.imem->base.subdev.device->dev;
 	int npages = nvkm_memory_size(memory) >> 12;
 	struct page *pages[npages];
 	int i;
 
-	/* phys_to_page does not exist on all platforms... */
-	pages[0] = pfn_to_page(dma_to_phys(dev, node->handle) >> PAGE_SHIFT);
+	/*
+	 * Ideally we would have a function to translate a handle to a physical
+	 * address, but there is no portable way of doing this. However since we
+	 * always use the DMA API without an IOMMU, we can assume that handles
+	 * are actual physical addresses.
+	 */
+	pages[0] = pfn_to_page(((phys_addr_t)node->handle) >> PAGE_SHIFT);
 	for (i = 1; i < npages; i++)
 		pages[i] = pages[0] + i;
 
_

Patches currently in -mm which might be from acourbot@nvidia.com are

instmem-gk20a-do-not-use-non-portable-dma_to_phys.patch

