From: akpm@linux-foundation.org
Subject: + video-dma-mapping-use-unsigned-long-for-dma_attrs.patch added
 to -mm tree
Date: Wed, 13 Jul 2016 14:51:28 -0700
Message-ID: <5786b7e0.Ub4hRfDVjqBwdxdw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbcGMVv3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 17:51:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: video: dma-mapping: use unsigned long for dma_attrs
has been added to the -mm tree.  Its filename is
     video-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/video-dma-mapping-use-unsigned-long-for-dma_attrs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/video-dma-mapping-use-unsigned-long-for-dma_attrs.patch

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
Subject: video: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-23-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbdev/omap2/omapfb/omapfb-main.c |   12 ++++++------
 drivers/video/fbdev/omap2/omapfb/omapfb.h      |    3 +--
 2 files changed, 7 insertions(+), 8 deletions(-)

diff -puN drivers/video/fbdev/omap2/omapfb/omapfb-main.c~video-dma-mapping-use-unsigned-long-for-dma_attrs drivers/video/fbdev/omap2/omapfb/omapfb-main.c
--- a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c~video-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
@@ -1332,7 +1332,7 @@ static void omapfb_free_fbmem(struct fb_
 	}
 
 	dma_free_attrs(fbdev->dev, rg->size, rg->token, rg->dma_handle,
-			&rg->attrs);
+			rg->attrs);
 
 	rg->token = NULL;
 	rg->vaddr = NULL;
@@ -1370,7 +1370,7 @@ static int omapfb_alloc_fbmem(struct fb_
 	struct omapfb2_device *fbdev = ofbi->fbdev;
 	struct omapfb2_mem_region *rg;
 	void *token;
-	DEFINE_DMA_ATTRS(attrs);
+	unsigned long attrs;
 	dma_addr_t dma_handle;
 	int r;
 
@@ -1386,15 +1386,15 @@ static int omapfb_alloc_fbmem(struct fb_
 
 	size = PAGE_ALIGN(size);
 
-	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
+	attrs = DMA_ATTR_WRITE_COMBINE;
 
 	if (ofbi->rotation_type == OMAP_DSS_ROT_VRFB)
-		dma_set_attr(DMA_ATTR_NO_KERNEL_MAPPING, &attrs);
+		attrs |= DMA_ATTR_NO_KERNEL_MAPPING;
 
 	DBG("allocating %lu bytes for fb %d\n", size, ofbi->id);
 
 	token = dma_alloc_attrs(fbdev->dev, size, &dma_handle,
-			GFP_KERNEL, &attrs);
+			GFP_KERNEL, attrs);
 
 	if (token == NULL) {
 		dev_err(fbdev->dev, "failed to allocate framebuffer\n");
@@ -1408,7 +1408,7 @@ static int omapfb_alloc_fbmem(struct fb_
 		r = omap_vrfb_request_ctx(&rg->vrfb);
 		if (r) {
 			dma_free_attrs(fbdev->dev, size, token, dma_handle,
-					&attrs);
+					attrs);
 			dev_err(fbdev->dev, "vrfb create ctx failed\n");
 			return r;
 		}
diff -puN drivers/video/fbdev/omap2/omapfb/omapfb.h~video-dma-mapping-use-unsigned-long-for-dma_attrs drivers/video/fbdev/omap2/omapfb/omapfb.h
--- a/drivers/video/fbdev/omap2/omapfb/omapfb.h~video-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/video/fbdev/omap2/omapfb/omapfb.h
@@ -28,7 +28,6 @@
 #endif
 
 #include <linux/rwsem.h>
-#include <linux/dma-attrs.h>
 #include <linux/dma-mapping.h>
 
 #include <video/omapfb_dss.h>
@@ -51,7 +50,7 @@ extern bool omapfb_debug;
 
 struct omapfb2_mem_region {
 	int             id;
-	struct dma_attrs attrs;
+	unsigned long	attrs;
 	void		*token;
 	dma_addr_t	dma_handle;
 	u32		paddr;
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

