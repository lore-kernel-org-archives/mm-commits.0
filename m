From: akpm@linux-foundation.org
Subject: [folded-merged]
 drm-mediatek-dma-mapping-use-unsigned-long-for-dma_attrs.patch removed from -mm tree
Date: Wed, 03 Aug 2016 13:13:50 -0700
Message-ID: <57a2507e.CZ/rqNayY7x7hFo9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758232AbcHCUO1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:14:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, daniel.vetter@ffwll.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/mediatek: dma-mapping: use unsigned long for dma_attrs
has been removed from the -mm tree.  Its filename was
     drm-mediatek-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch was dropped because it was folded into dma-mapping-use-unsigned-long-for-dma_attrs.patch

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: drm/mediatek: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-13-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch> [drm]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/mediatek/mtk_drm_gem.c |   13 ++++++-------
 drivers/gpu/drm/mediatek/mtk_drm_gem.h |    2 +-
 2 files changed, 7 insertions(+), 8 deletions(-)

diff -puN drivers/gpu/drm/mediatek/mtk_drm_gem.c~drm-mediatek-dma-mapping-use-unsigned-long-for-dma_attrs drivers/gpu/drm/mediatek/mtk_drm_gem.c
--- a/drivers/gpu/drm/mediatek/mtk_drm_gem.c~drm-mediatek-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/gpu/drm/mediatek/mtk_drm_gem.c
@@ -54,15 +54,14 @@ struct mtk_drm_gem_obj *mtk_drm_gem_crea
 
 	obj = &mtk_gem->base;
 
-	init_dma_attrs(&mtk_gem->dma_attrs);
-	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &mtk_gem->dma_attrs);
+	mtk_gem->dma_attrs = DMA_ATTR_WRITE_COMBINE;
 
 	if (!alloc_kmap)
-		dma_set_attr(DMA_ATTR_NO_KERNEL_MAPPING, &mtk_gem->dma_attrs);
+		mtk_gem->dma_attrs |= DMA_ATTR_NO_KERNEL_MAPPING;
 
 	mtk_gem->cookie = dma_alloc_attrs(priv->dma_dev, obj->size,
 					  &mtk_gem->dma_addr, GFP_KERNEL,
-					  &mtk_gem->dma_attrs);
+					  mtk_gem->dma_attrs);
 	if (!mtk_gem->cookie) {
 		DRM_ERROR("failed to allocate %zx byte dma buffer", obj->size);
 		ret = -ENOMEM;
@@ -93,7 +92,7 @@ void mtk_drm_gem_free_object(struct drm_
 		drm_prime_gem_destroy(obj, mtk_gem->sg);
 	else
 		dma_free_attrs(priv->dma_dev, obj->size, mtk_gem->cookie,
-			       mtk_gem->dma_addr, &mtk_gem->dma_attrs);
+			       mtk_gem->dma_addr, mtk_gem->dma_attrs);
 
 	/* release file pointer to gem object. */
 	drm_gem_object_release(obj);
@@ -173,7 +172,7 @@ static int mtk_drm_gem_object_mmap(struc
 	vma->vm_pgoff = 0;
 
 	ret = dma_mmap_attrs(priv->dma_dev, vma, mtk_gem->cookie,
-			     mtk_gem->dma_addr, obj->size, &mtk_gem->dma_attrs);
+			     mtk_gem->dma_addr, obj->size, mtk_gem->dma_attrs);
 	if (ret)
 		drm_gem_vm_close(vma);
 
@@ -224,7 +223,7 @@ struct sg_table *mtk_gem_prime_get_sg_ta
 
 	ret = dma_get_sgtable_attrs(priv->dma_dev, sgt, mtk_gem->cookie,
 				    mtk_gem->dma_addr, obj->size,
-				    &mtk_gem->dma_attrs);
+				    mtk_gem->dma_attrs);
 	if (ret) {
 		DRM_ERROR("failed to allocate sgt, %d\n", ret);
 		kfree(sgt);
diff -puN drivers/gpu/drm/mediatek/mtk_drm_gem.h~drm-mediatek-dma-mapping-use-unsigned-long-for-dma_attrs drivers/gpu/drm/mediatek/mtk_drm_gem.h
--- a/drivers/gpu/drm/mediatek/mtk_drm_gem.h~drm-mediatek-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/gpu/drm/mediatek/mtk_drm_gem.h
@@ -35,7 +35,7 @@ struct mtk_drm_gem_obj {
 	void			*cookie;
 	void			*kvaddr;
 	dma_addr_t		dma_addr;
-	struct dma_attrs	dma_attrs;
+	unsigned long		dma_attrs;
 	struct sg_table		*sg;
 };
 
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

media-mtk-vcodec-remove-unused-dma_attrs.patch
dma-mapping-use-unsigned-long-for-dma_attrs.patch
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

