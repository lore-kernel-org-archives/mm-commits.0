Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A6A21FF23
	for <mm-commits@vger.kernel.org>; Tue, 29 Sep 2026 00:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790640513; cv=none; b=fTSGxHrVD7dofWOBDY7BE7/8K61APZDJ4O3D1965rH8g1LPBlAWGuCgvWqI/GHjBsHqxBy8dt5CSutKJiCBzeMfys3KzOxG4DFUMwItZrlLHX6yPnA5ZZ9YL0C2tYXrTqOtTlXPEZZRtWveItpiSMhL00WBOYjdNeaDAAw6hbpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790640513; c=relaxed/simple;
	bh=SboNm80diKP/6/NDXnmUSTIhUrorv0o4+RaWMU+gECM=;
	h=Date:To:From:Subject:Message-Id; b=f2qPBlkZlR9E62slm7H2I8VcsU05vZJ3nCl5pqekDIGevmHctDHGjHA02V2dPhIepwmnLAc8b4l5aMG2HxDa77i8J470HOXmU0yKP4DHj5R2bPVgkBOBTDgb9UQAL3ocRc+tg1nSH7qAl1NZ6b4zCX7ZTDfk7A2APNl5Z4Rexec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SjL7eweG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SjL7eweG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1414E1F000FF;
	Tue, 29 Sep 2026 00:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790640512;
	bh=Ks9fFKWMet1ns/Iuwn5csoxPAVA08JzhBVUGiU9LnK4=;
	h=Date:To:From:Subject;
	b=SjL7eweGvYnCe3SGMlOGrnlFfXRea51V4tKZ7o1plDPqrKSi2x/tbQjQWNHGFJa5I
	 00TK5ETz0TMRjiBxCHSlyUZmWTyUuyU7X+QYz+jPXVIFNwpnLugh2qBT82tKptf+Og
	 +2DQSWGWgngzKJPcK7j3dpMUyxauE3U6Ir/RyLrI=
Date: Mon, 28 Sep 2026 17:08:31 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,harry@kernel.org,hebaoquan@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + usb-gadget-lpc32xx_udc-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch added to mm-new branch
Message-Id: <20260929000832.1414E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: usb: gadget: lpc32xx_udc: don't use GFP_DMA when calling dma_alloc_coherent()
has been added to the -mm mm-new branch.  Its filename is
     usb-gadget-lpc32xx_udc-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/usb-gadget-lpc32xx_udc-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

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
Subject: usb: gadget: lpc32xx_udc: don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:29 +0800

dma_alloc_coherent() allocates the DMA buffer with the device's addressing
limitation in mind; the DMA core picks the zone from the device's coherent
DMA mask and ignores GFP_DMA passed by the caller.  Remove the redundant
GFP_DMA flag.

Link: https://lore.kernel.org/20260903111836.1777265-7-hebaoquan@kylinos.cn
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>
---

 drivers/usb/gadget/udc/lpc32xx_udc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/lpc32xx_udc.c~usb-gadget-lpc32xx_udc-dont-use-gfp_dma-when-calling-dma_alloc_coherent
+++ a/drivers/usb/gadget/udc/lpc32xx_udc.c
@@ -3080,7 +3080,7 @@ static int lpc32xx_udc_probe(struct plat
 	/* Allocate memory for the UDCA */
 	udc->udca_v_base = dma_alloc_coherent(&pdev->dev, UDCA_BUFF_SIZE,
 					      &dma_handle,
-					      (GFP_KERNEL | GFP_DMA));
+					      GFP_KERNEL);
 	if (!udc->udca_v_base) {
 		dev_err(udc->dev, "error getting UDCA region\n");
 		retval = -ENOMEM;
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

