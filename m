From: akpm@linux-foundation.org
Subject: [folded-merged]
 drm-rockship-dma-mapping-use-unsigned-long-for-dma_attrs.patch removed from -mm tree
Date: Wed, 03 Aug 2016 13:13:56 -0700
Message-ID: <57a25084.TjCz002/zb3x4ucX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758246AbcHCUO1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:14:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, daniel.vetter@ffwll.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/rockship: dma-mapping: use unsigned long for dma_attrs
has been removed from the -mm tree.  Its filename was
     drm-rockship-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch was dropped because it was folded into dma-mapping-use-unsigned-long-for-dma_attrs.patch

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: drm/rockship: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-16-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch> [drm]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/rockchip/rockchip_drm_gem.c |   17 +++++++----------
 drivers/gpu/drm/rockchip/rockchip_drm_gem.h |    2 +-
 2 files changed, 8 insertions(+), 11 deletions(-)

diff -puN drivers/gpu/drm/rockchip/rockchip_drm_gem.c~drm-rockship-dma-mapping-use-unsigned-long-for-dma_attrs drivers/gpu/drm/rockchip/rockchip_drm_gem.c
--- a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c~drm-rockship-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
@@ -17,8 +17,6 @@
 #include <drm/drm_gem.h>
 #include <drm/drm_vma_manager.h>
 
-#include <linux/dma-attrs.h>
-
 #include "rockchip_drm_drv.h"
 #include "rockchip_drm_gem.h"
 
@@ -28,15 +26,14 @@ static int rockchip_gem_alloc_buf(struct
 	struct drm_gem_object *obj = &rk_obj->base;
 	struct drm_device *drm = obj->dev;
 
-	init_dma_attrs(&rk_obj->dma_attrs);
-	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &rk_obj->dma_attrs);
+	rk_obj->dma_attrs = DMA_ATTR_WRITE_COMBINE;
 
 	if (!alloc_kmap)
-		dma_set_attr(DMA_ATTR_NO_KERNEL_MAPPING, &rk_obj->dma_attrs);
+		rk_obj->dma_attrs |= DMA_ATTR_NO_KERNEL_MAPPING;
 
 	rk_obj->kvaddr = dma_alloc_attrs(drm->dev, obj->size,
 					 &rk_obj->dma_addr, GFP_KERNEL,
-					 &rk_obj->dma_attrs);
+					 rk_obj->dma_attrs);
 	if (!rk_obj->kvaddr) {
 		DRM_ERROR("failed to allocate %zu byte dma buffer", obj->size);
 		return -ENOMEM;
@@ -51,7 +48,7 @@ static void rockchip_gem_free_buf(struct
 	struct drm_device *drm = obj->dev;
 
 	dma_free_attrs(drm->dev, obj->size, rk_obj->kvaddr, rk_obj->dma_addr,
-		       &rk_obj->dma_attrs);
+		       rk_obj->dma_attrs);
 }
 
 static int rockchip_drm_gem_object_mmap(struct drm_gem_object *obj,
@@ -70,7 +67,7 @@ static int rockchip_drm_gem_object_mmap(
 	vma->vm_pgoff = 0;
 
 	ret = dma_mmap_attrs(drm->dev, vma, rk_obj->kvaddr, rk_obj->dma_addr,
-			     obj->size, &rk_obj->dma_attrs);
+			     obj->size, rk_obj->dma_attrs);
 	if (ret)
 		drm_gem_vm_close(vma);
 
@@ -262,7 +259,7 @@ struct sg_table *rockchip_gem_prime_get_
 
 	ret = dma_get_sgtable_attrs(drm->dev, sgt, rk_obj->kvaddr,
 				    rk_obj->dma_addr, obj->size,
-				    &rk_obj->dma_attrs);
+				    rk_obj->dma_attrs);
 	if (ret) {
 		DRM_ERROR("failed to allocate sgt, %d\n", ret);
 		kfree(sgt);
@@ -276,7 +273,7 @@ void *rockchip_gem_prime_vmap(struct drm
 {
 	struct rockchip_gem_object *rk_obj = to_rockchip_obj(obj);
 
-	if (dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, &rk_obj->dma_attrs))
+	if (dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, rk_obj->dma_attrs))
 		return NULL;
 
 	return rk_obj->kvaddr;
diff -puN drivers/gpu/drm/rockchip/rockchip_drm_gem.h~drm-rockship-dma-mapping-use-unsigned-long-for-dma_attrs drivers/gpu/drm/rockchip/rockchip_drm_gem.h
--- a/drivers/gpu/drm/rockchip/rockchip_drm_gem.h~drm-rockship-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/gpu/drm/rockchip/rockchip_drm_gem.h
@@ -23,7 +23,7 @@ struct rockchip_gem_object {
 
 	void *kvaddr;
 	dma_addr_t dma_addr;
-	struct dma_attrs dma_attrs;
+	unsigned long dma_attrs;
 };
 
 struct sg_table *rockchip_gem_prime_get_sg_table(struct drm_gem_object *obj);
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

media-mtk-vcodec-remove-unused-dma_attrs.patch
dma-mapping-use-unsigned-long-for-dma_attrs.patch
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

