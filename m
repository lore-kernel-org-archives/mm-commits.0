From: akpm@linux-foundation.org
Subject: + drm-msm-dma-mapping-use-unsigned-long-for-dma_attrs.patch added to -mm tree
Date: Mon, 11 Jul 2016 15:14:37 -0700
Message-ID: <57841a4d.7ZFwn0dqhB9ZEE+X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43663 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbcGKWOi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2016 18:14:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/msm: dma-mapping: use unsigned long for dma_attrs
has been added to the -mm tree.  Its filename is
     drm-msm-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drm-msm-dma-mapping-use-unsigned-long-for-dma_attrs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drm-msm-dma-mapping-use-unsigned-long-for-dma_attrs.patch

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
Subject: drm/msm: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1467275171-6298-13-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/msm/msm_drv.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN drivers/gpu/drm/msm/msm_drv.c~drm-msm-dma-mapping-use-unsigned-long-for-dma_attrs drivers/gpu/drm/msm/msm_drv.c
--- a/drivers/gpu/drm/msm/msm_drv.c~drm-msm-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/gpu/drm/msm/msm_drv.c
@@ -230,11 +230,10 @@ static int msm_drm_uninit(struct device
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
@@ -299,21 +298,21 @@ static int msm_init_vram(struct drm_devi
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

