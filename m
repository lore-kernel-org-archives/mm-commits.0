From: akpm@linux-foundation.org
Subject: + drm-nouveau-dma-mapping-use-unsigned-long-for-dma_attrs.patch
 added to -mm tree
Date: Wed, 13 Jul 2016 14:51:12 -0700
Message-ID: <5786b7d0.S1bfVGIloVbbsQgY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbcGMVvN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 17:51:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, daniel.vetter@ffwll.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/nouveau: dma-mapping: use unsigned long for dma_attrs
has been added to the -mm tree.  Its filename is
     drm-nouveau-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drm-nouveau-dma-mapping-use-unsigned-long-for-dma_attrs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drm-nouveau-dma-mapping-use-unsigned-long-for-dma_attrs.patch

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
Subject: drm/nouveau: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-15-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch> [drm]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c |   13 ++++------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c~drm-nouveau-dma-mapping-use-unsigned-long-for-dma_attrs drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c~drm-nouveau-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c
@@ -109,7 +109,7 @@ struct gk20a_instmem {
 	u16 iommu_bit;
 
 	/* Only used by DMA API */
-	struct dma_attrs attrs;
+	unsigned long attrs;
 };
 #define gk20a_instmem(p) container_of((p), struct gk20a_instmem, base)
 
@@ -293,7 +293,7 @@ gk20a_instobj_dtor_dma(struct nvkm_memor
 		goto out;
 
 	dma_free_attrs(dev, node->base.mem.size << PAGE_SHIFT, node->base.vaddr,
-		       node->handle, &imem->attrs);
+		       node->handle, imem->attrs);
 
 out:
 	return node;
@@ -386,7 +386,7 @@ gk20a_instobj_ctor_dma(struct gk20a_inst
 
 	node->base.vaddr = dma_alloc_attrs(dev, npages << PAGE_SHIFT,
 					   &node->handle, GFP_KERNEL,
-					   &imem->attrs);
+					   imem->attrs);
 	if (!node->base.vaddr) {
 		nvkm_error(subdev, "cannot allocate DMA memory\n");
 		return -ENOMEM;
@@ -597,10 +597,9 @@ gk20a_instmem_new(struct nvkm_device *de
 
 		nvkm_info(&imem->base.subdev, "using IOMMU\n");
 	} else {
-		init_dma_attrs(&imem->attrs);
-		dma_set_attr(DMA_ATTR_NON_CONSISTENT, &imem->attrs);
-		dma_set_attr(DMA_ATTR_WEAK_ORDERING, &imem->attrs);
-		dma_set_attr(DMA_ATTR_WRITE_COMBINE, &imem->attrs);
+		imem->attrs = DMA_ATTR_NON_CONSISTENT |
+			      DMA_ATTR_WEAK_ORDERING |
+			      DMA_ATTR_WRITE_COMBINE;
 
 		nvkm_info(&imem->base.subdev, "using DMA API\n");
 	}
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

