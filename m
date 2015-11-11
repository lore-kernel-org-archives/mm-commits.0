From: akpm@linux-foundation.org
Subject: [merged] nouveau-dont-call-pci_dma_supported.patch removed from
 -mm tree
Date: Wed, 11 Nov 2015 11:48:30 -0800
Message-ID: <56439b8e.rTamdfP7R1KBlasf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbbKKTsb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 14:48:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, acourbot@nvidia.com, airlied@linux.ie, airlied@redhat.com, bskeggs@redhat.com, daniel.vetter@ffwll.ch, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nouveau: don't call pci_dma_supported
has been removed from the -mm tree.  Its filename was
     nouveau-dont-call-pci_dma_supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: nouveau: don't call pci_dma_supported

Just try to set a 64-bit DMA mask first and retry with the smaller dma_mask
if dma_set_mask failed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Dave Airlie <airlied@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/nouveau/nouveau_ttm.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/drm/nouveau/nouveau_ttm.c~nouveau-dont-call-pci_dma_supported drivers/gpu/drm/nouveau/nouveau_ttm.c
--- a/drivers/gpu/drm/nouveau/nouveau_ttm.c~nouveau-dont-call-pci_dma_supported
+++ a/drivers/gpu/drm/nouveau/nouveau_ttm.c
@@ -353,8 +353,7 @@ nouveau_ttm_init(struct nouveau_drm *drm
 
 	bits = nvxx_mmu(&drm->device)->dma_bits;
 	if (nvxx_device(&drm->device)->func->pci) {
-		if (drm->agp.bridge ||
-		     !dma_supported(dev->dev, DMA_BIT_MASK(bits)))
+		if (drm->agp.bridge)
 			bits = 32;
 	} else if (device->func->tegra) {
 		struct nvkm_device_tegra *tegra = device->func->tegra(device);
@@ -369,6 +368,10 @@ nouveau_ttm_init(struct nouveau_drm *drm
 	}
 
 	ret = dma_set_mask(dev->dev, DMA_BIT_MASK(bits));
+	if (ret && bits != 32) {
+		bits = 32;
+		ret = dma_set_mask(dev->dev, DMA_BIT_MASK(bits));
+	}
 	if (ret)
 		return ret;
 
_

Patches currently in -mm which might be from hch@lst.de are


