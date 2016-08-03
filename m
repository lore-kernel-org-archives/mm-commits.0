From: akpm@linux-foundation.org
Subject: [folded-merged]
 drm-exynos-dma-mapping-use-unsigned-long-for-dma_attrs.patch removed from
 -mm tree
Date: Wed, 03 Aug 2016 13:13:48 -0700
Message-ID: <57a2507c.7RGlklAUIm0cOZfG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758066AbcHCUO0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:14:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, daniel.vetter@ffwll.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/exynos: dma-mapping: use unsigned long for dma_attrs
has been removed from the -mm tree.  Its filename was
     drm-exynos-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch was dropped because it was folded into dma-mapping-use-unsigned-long-for-dma_attrs.patch

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: drm/exynos: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-12-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch> [drm]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/exynos/exynos_drm_fbdev.c |    2 +-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c   |   12 +++++-------
 drivers/gpu/drm/exynos/exynos_drm_gem.c   |   20 ++++++++++----------
 drivers/gpu/drm/exynos/exynos_drm_gem.h   |    2 +-
 4 files changed, 17 insertions(+), 19 deletions(-)

diff -puN drivers/gpu/drm/exynos/exynos_drm_fbdev.c~drm-exynos-dma-mapping-use-unsigned-long-for-dma_attrs drivers/gpu/drm/exynos/exynos_drm_fbdev.c
--- a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c~drm-exynos-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
@@ -52,7 +52,7 @@ static int exynos_drm_fb_mmap(struct fb_
 
 	ret = dma_mmap_attrs(to_dma_dev(helper->dev), vma, exynos_gem->cookie,
 			     exynos_gem->dma_addr, exynos_gem->size,
-			     &exynos_gem->dma_attrs);
+			     exynos_gem->dma_attrs);
 	if (ret < 0) {
 		DRM_ERROR("failed to mmap.\n");
 		return ret;
diff -puN drivers/gpu/drm/exynos/exynos_drm_g2d.c~drm-exynos-dma-mapping-use-unsigned-long-for-dma_attrs drivers/gpu/drm/exynos/exynos_drm_g2d.c
--- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c~drm-exynos-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
@@ -17,7 +17,6 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <linux/dma-mapping.h>
-#include <linux/dma-attrs.h>
 #include <linux/of.h>
 
 #include <drm/drmP.h>
@@ -235,7 +234,7 @@ struct g2d_data {
 	struct mutex			cmdlist_mutex;
 	dma_addr_t			cmdlist_pool;
 	void				*cmdlist_pool_virt;
-	struct dma_attrs		cmdlist_dma_attrs;
+	unsigned long			cmdlist_dma_attrs;
 
 	/* runqueue*/
 	struct g2d_runqueue_node	*runqueue_node;
@@ -256,13 +255,12 @@ static int g2d_init_cmdlist(struct g2d_d
 	int ret;
 	struct g2d_buf_info *buf_info;
 
-	init_dma_attrs(&g2d->cmdlist_dma_attrs);
-	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &g2d->cmdlist_dma_attrs);
+	g2d->cmdlist_dma_attrs = DMA_ATTR_WRITE_COMBINE;
 
 	g2d->cmdlist_pool_virt = dma_alloc_attrs(to_dma_dev(subdrv->drm_dev),
 						G2D_CMDLIST_POOL_SIZE,
 						&g2d->cmdlist_pool, GFP_KERNEL,
-						&g2d->cmdlist_dma_attrs);
+						g2d->cmdlist_dma_attrs);
 	if (!g2d->cmdlist_pool_virt) {
 		dev_err(dev, "failed to allocate dma memory\n");
 		return -ENOMEM;
@@ -295,7 +293,7 @@ static int g2d_init_cmdlist(struct g2d_d
 err:
 	dma_free_attrs(to_dma_dev(subdrv->drm_dev), G2D_CMDLIST_POOL_SIZE,
 			g2d->cmdlist_pool_virt,
-			g2d->cmdlist_pool, &g2d->cmdlist_dma_attrs);
+			g2d->cmdlist_pool, g2d->cmdlist_dma_attrs);
 	return ret;
 }
 
@@ -309,7 +307,7 @@ static void g2d_fini_cmdlist(struct g2d_
 		dma_free_attrs(to_dma_dev(subdrv->drm_dev),
 				G2D_CMDLIST_POOL_SIZE,
 				g2d->cmdlist_pool_virt,
-				g2d->cmdlist_pool, &g2d->cmdlist_dma_attrs);
+				g2d->cmdlist_pool, g2d->cmdlist_dma_attrs);
 	}
 }
 
diff -puN drivers/gpu/drm/exynos/exynos_drm_gem.c~drm-exynos-dma-mapping-use-unsigned-long-for-dma_attrs drivers/gpu/drm/exynos/exynos_drm_gem.c
--- a/drivers/gpu/drm/exynos/exynos_drm_gem.c~drm-exynos-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/gpu/drm/exynos/exynos_drm_gem.c
@@ -24,7 +24,7 @@
 static int exynos_drm_alloc_buf(struct exynos_drm_gem *exynos_gem)
 {
 	struct drm_device *dev = exynos_gem->base.dev;
-	enum dma_attr attr;
+	unsigned long attr;
 	unsigned int nr_pages;
 	struct sg_table sgt;
 	int ret = -ENOMEM;
@@ -34,7 +34,7 @@ static int exynos_drm_alloc_buf(struct e
 		return 0;
 	}
 
-	init_dma_attrs(&exynos_gem->dma_attrs);
+	exynos_gem->dma_attrs = 0;
 
 	/*
 	 * if EXYNOS_BO_CONTIG, fully physically contiguous memory
@@ -42,7 +42,7 @@ static int exynos_drm_alloc_buf(struct e
 	 * as possible.
 	 */
 	if (!(exynos_gem->flags & EXYNOS_BO_NONCONTIG))
-		dma_set_attr(DMA_ATTR_FORCE_CONTIGUOUS, &exynos_gem->dma_attrs);
+		exynos_gem->dma_attrs |= DMA_ATTR_FORCE_CONTIGUOUS;
 
 	/*
 	 * if EXYNOS_BO_WC or EXYNOS_BO_NONCACHABLE, writecombine mapping
@@ -54,8 +54,8 @@ static int exynos_drm_alloc_buf(struct e
 	else
 		attr = DMA_ATTR_NON_CONSISTENT;
 
-	dma_set_attr(attr, &exynos_gem->dma_attrs);
-	dma_set_attr(DMA_ATTR_NO_KERNEL_MAPPING, &exynos_gem->dma_attrs);
+	exynos_gem->dma_attrs |= attr;
+	exynos_gem->dma_attrs |= DMA_ATTR_NO_KERNEL_MAPPING;
 
 	nr_pages = exynos_gem->size >> PAGE_SHIFT;
 
@@ -67,7 +67,7 @@ static int exynos_drm_alloc_buf(struct e
 
 	exynos_gem->cookie = dma_alloc_attrs(to_dma_dev(dev), exynos_gem->size,
 					     &exynos_gem->dma_addr, GFP_KERNEL,
-					     &exynos_gem->dma_attrs);
+					     exynos_gem->dma_attrs);
 	if (!exynos_gem->cookie) {
 		DRM_ERROR("failed to allocate buffer.\n");
 		goto err_free;
@@ -75,7 +75,7 @@ static int exynos_drm_alloc_buf(struct e
 
 	ret = dma_get_sgtable_attrs(to_dma_dev(dev), &sgt, exynos_gem->cookie,
 				    exynos_gem->dma_addr, exynos_gem->size,
-				    &exynos_gem->dma_attrs);
+				    exynos_gem->dma_attrs);
 	if (ret < 0) {
 		DRM_ERROR("failed to get sgtable.\n");
 		goto err_dma_free;
@@ -99,7 +99,7 @@ err_sgt_free:
 	sg_free_table(&sgt);
 err_dma_free:
 	dma_free_attrs(to_dma_dev(dev), exynos_gem->size, exynos_gem->cookie,
-		       exynos_gem->dma_addr, &exynos_gem->dma_attrs);
+		       exynos_gem->dma_addr, exynos_gem->dma_attrs);
 err_free:
 	drm_free_large(exynos_gem->pages);
 
@@ -120,7 +120,7 @@ static void exynos_drm_free_buf(struct e
 
 	dma_free_attrs(to_dma_dev(dev), exynos_gem->size, exynos_gem->cookie,
 			(dma_addr_t)exynos_gem->dma_addr,
-			&exynos_gem->dma_attrs);
+			exynos_gem->dma_attrs);
 
 	drm_free_large(exynos_gem->pages);
 }
@@ -346,7 +346,7 @@ static int exynos_drm_gem_mmap_buffer(st
 
 	ret = dma_mmap_attrs(to_dma_dev(drm_dev), vma, exynos_gem->cookie,
 			     exynos_gem->dma_addr, exynos_gem->size,
-			     &exynos_gem->dma_attrs);
+			     exynos_gem->dma_attrs);
 	if (ret < 0) {
 		DRM_ERROR("failed to mmap.\n");
 		return ret;
diff -puN drivers/gpu/drm/exynos/exynos_drm_gem.h~drm-exynos-dma-mapping-use-unsigned-long-for-dma_attrs drivers/gpu/drm/exynos/exynos_drm_gem.h
--- a/drivers/gpu/drm/exynos/exynos_drm_gem.h~drm-exynos-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/gpu/drm/exynos/exynos_drm_gem.h
@@ -50,7 +50,7 @@ struct exynos_drm_gem {
 	void			*cookie;
 	void __iomem		*kvaddr;
 	dma_addr_t		dma_addr;
-	struct dma_attrs	dma_attrs;
+	unsigned long		dma_attrs;
 	struct page		**pages;
 	struct sg_table		*sgt;
 };
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

media-mtk-vcodec-remove-unused-dma_attrs.patch
dma-mapping-use-unsigned-long-for-dma_attrs.patch
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

