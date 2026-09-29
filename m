Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1610B233722
	for <mm-commits@vger.kernel.org>; Tue, 29 Sep 2026 00:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790640515; cv=none; b=CVMzokhiiKwz7Bc2udQCMjXyQIbeQGxP3t6ezJjFdjDc/xLqZLnLIr1QgvZdxX9oi15FKbj0zQnvsI+cr7Yna8+RBMNYb1Z5cMJ4bgImmPXQIpx5v+Ea36WB9AbPH1nJ+O0zY4dalhaiNtt2Uf99DMObK4yfHPTAeM15ky9PcZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790640515; c=relaxed/simple;
	bh=DdfzYTAb3NsNyMlx5lYT5Rj46/j8qCNKcYLu71hw5G4=;
	h=Date:To:From:Subject:Message-Id; b=qtal0/R9DwKx7PZyxWB276JWNSac756yS7oMBnZKu7S0q4JupqEbJY7qdT5T+6kGjxZ6kMzceRwEyCjMcr2xmtog9GvYC4Ee2CPh1vIi8TC8NmX0CvCNDYGj3qAfAutY7YrlfFIRQtbWSEVJPzQoEDU1nDufi/ejiX9jAZFnvNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XHnJ5R3i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XHnJ5R3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7C71F00893;
	Tue, 29 Sep 2026 00:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790640514;
	bh=nWBLMtQFpaaDep75SRO7WtluCltpDPIJc0G+kdJh77Y=;
	h=Date:To:From:Subject;
	b=XHnJ5R3icE6oFkPNn1iyOOs7WJD950JMfWO3HULA/ARHCbio9P9wg1skJCKD97V6g
	 /Uv4AOvsXx4VFDNrLGWLI9SLJyQp904o6eN/0v1Riz1fttgai6k02m2HF8PsuK7QkR
	 XQpUFfRl8uJHZ07fsdqBZCnjSSX3HNWe1T5XgOms=
Date: Mon, 28 Sep 2026 17:08:33 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,harry@kernel.org,hebaoquan@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + usb-cdns3-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch added to mm-new branch
Message-Id: <20260929000833.DE7C71F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: usb: cdns3: don't use GFP_DMA when calling dma_alloc_coherent()
has been added to the -mm mm-new branch.  Its filename is
     usb-cdns3-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/usb-cdns3-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Baoquan He <hebaoquan@kylinos.cn>
Subject: usb: cdns3: don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:30 +0800

dma_alloc_coherent() allocates the DMA buffer with the device's addressing
limitation in mind; the DMA core picks the zone from the device's coherent
DMA mask and ignores GFP_DMA passed by the caller.  Use GFP_KERNEL instead
so the allocation may reclaim as usual for probe-time allocations.

Link: https://lore.kernel.org/20260903111836.1777265-8-hebaoquan@kylinos.cn
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>
---

 drivers/usb/cdns3/cdns3-gadget.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/cdns3/cdns3-gadget.c~usb-cdns3-dont-use-gfp_dma-when-calling-dma_alloc_coherent
+++ a/drivers/usb/cdns3/cdns3-gadget.c
@@ -3376,7 +3376,7 @@ static int cdns3_gadget_start(struct cdn
 
 	/* allocate memory for setup packet buffer */
 	priv_dev->setup_buf = dma_alloc_coherent(priv_dev->sysdev, 8,
-						 &priv_dev->setup_dma, GFP_DMA);
+						 &priv_dev->setup_dma, GFP_KERNEL);
 	if (!priv_dev->setup_buf) {
 		ret = -ENOMEM;
 		goto err2;
_

Patches currently in -mm which might be from hebaoquan@kylinos.cn are

mm-zswap-return-enoent-when-the-swap-device-is-gone.patch
gpu-ipu-v3-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch
drm-sti-dont-use-gfp_dma-when-calling-dma_alloc_wc.patch
alsa-n64-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch
spi-spi-ti-qspi-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch
fbdev-fsl-diu-fb-dont-use-gfp_dma-when-calling-dmam_alloc_coherent.patch
usb-gadget-lpc32xx_udc-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch
usb-cdns3-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch
media-staging-imx-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch
spi-atmel-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch
media-imx7-media-csi-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch
media-nxp-imx8-isi-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch
mtd-rawnand-gpmi-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch
usb-cdns2-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

