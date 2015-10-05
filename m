From: akpm@linux-foundation.org
Subject: + nouveau-dont-call-pci_dma_supported.patch added to -mm tree
Date: Mon, 05 Oct 2015 14:29:24 -0700
Message-ID: <5612ebb4.NvYTk98HKcqTs74F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbbJEV3Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 17:29:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, acourbot@nvidia.com, airlied@linux.ie, airlied@redhat.com, bskeggs@redhat.com, daniel.vetter@ffwll.ch, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nouveau: don't call pci_dma_supported
has been added to the -mm tree.  Its filename is
     nouveau-dont-call-pci_dma_supported.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nouveau-dont-call-pci_dma_supported.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nouveau-dont-call-pci_dma_supported.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -350,11 +350,14 @@ nouveau_ttm_init(struct nouveau_drm *drm
 
 	bits = nvxx_mmu(&drm->device)->dma_bits;
 	if (nvxx_device(&drm->device)->func->pci) {
-		if (drm->agp.bridge ||
-		     !pci_dma_supported(dev->pdev, DMA_BIT_MASK(bits)))
+		if (drm->agp.bridge)
 			bits = 32;
 
 		ret = pci_set_dma_mask(dev->pdev, DMA_BIT_MASK(bits));
+		if (ret && bits != 32) {
+			bits = 32;
+			ret = pci_set_dma_mask(dev->pdev, DMA_BIT_MASK(bits));
+		}
 		if (ret)
 			return ret;
 
_

Patches currently in -mm which might be from hch@lst.de are

pcnet32-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
tw68-core-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
saa7164-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
saa7134-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
cx88-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
cx25821-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
cx23885-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
netup_unidvb-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch
mpsc-use-dma_set_mask-insted-of-dma_supported.patch
nouveau-dont-call-pci_dma_supported.patch
sfc-dont-call-dma_supported.patch
kaweth-remove-ifdefed-out-call-to-dma_supported.patch
usbnet-remove-ifdefed-out-call-to-dma_supported.patch
pci-remove-pci_dma_supported.patch
dma-remove-external-references-to-dma_supported.patch

