From: akpm@linux-foundation.org
Subject: [folded-merged]
 drm-msm-dma-mapping-use-unsigned-long-for-dma_attrs.patch removed from -mm
 tree
Date: Wed, 03 Aug 2016 13:13:52 -0700
Message-ID: <57a25080.i3rPDH62z7DB8HE+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758172AbcHCUO0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:14:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, daniel.vetter@ffwll.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/msm: dma-mapping: use unsigned long for dma_attrs
has been removed from the -mm tree.  Its filename was
     drm-msm-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch was dropped because it was folded into dma-mapping-use-unsigned-long-for-dma_attrs.patch

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: drm/msm: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-14-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch> [drm]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/msm/msm_drv.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN drivers/gpu/drm/msm/msm_drv.c~drm-msm-dma-mapping-use-unsigned-long-for-dma_attrs drivers/gpu/drm/msm/msm_drv.c
--- a/drivers/gpu/drm/msm/msm_drv.c~drm-msm-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/gpu/drm/msm/msm_drv.c
@@ -238,11 +238,10 @@ static int msm_drm_uninit(struct device
 	}
 
 	if (priv->vram.paddr) {
-		DEFINE_DMA_ATTRS(attrs);
-		dma_set_attr(DMA_ATTR_NO_KERNEL_MAPPING, &attrs);
+		unsigned long attrs = DMA_ATTR_NO_KERNEL_MAPPING;
 		drm_mm_takedown(&priv->vram.mm);
 		dma_free_attrs(dev, priv->vram.size, NULL,
-			       priv->vram.paddr, &attrs);
+			       priv->vram.paddr, attrs);
 	}
 
 	component_unbind_all(dev, ddev);
@@ -310,21 +309,21 @@ static int msm_init_vram(struct drm_devi
 	}
 
 	if (size) {
-		DEFINE_DMA_ATTRS(attrs);
+		unsigned long attrs = 0;
 		void *p;
 
 		priv->vram.size = size;
 
 		drm_mm_init(&priv->vram.mm, 0, (size >> PAGE_SHIFT) - 1);
 
-		dma_set_attr(DMA_ATTR_NO_KERNEL_MAPPING, &attrs);
-		dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
+		attrs |= DMA_ATTR_NO_KERNEL_MAPPING;
+		attrs |= DMA_ATTR_WRITE_COMBINE;
 
 		/* note that for no-kernel-mapping, the vaddr returned
 		 * is bogus, but non-null if allocation succeeded:
 		 */
 		p = dma_alloc_attrs(dev->dev, size,
-				&priv->vram.paddr, GFP_KERNEL, &attrs);
+				&priv->vram.paddr, GFP_KERNEL, attrs);
 		if (!p) {
 			dev_err(dev->dev, "failed to allocate VRAM\n");
 			priv->vram.paddr = 0;
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

media-mtk-vcodec-remove-unused-dma_attrs.patch
dma-mapping-use-unsigned-long-for-dma_attrs.patch
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

