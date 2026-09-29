Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3884423393F
	for <mm-commits@vger.kernel.org>; Tue, 29 Sep 2026 00:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790640520; cv=none; b=arfhxZID5xnr1Bi6/Iv2QF0SEbnhTewziCP77abD4v5M6IJ/Jn0dHeU5+dQ1Ui+gSUuuD6tJ5A27dJb5KkvkkybbXSPbdly5sqFOZX538ylCPnmX73D6dkJnplZma4JkS9AWRbj+mlxAl9xAntxPC53hbeRV+4aBRvCIZM3HvNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790640520; c=relaxed/simple;
	bh=AbbhcyHXn6qFP0mUZP1rW0/QH6dCqCXIjZlPyy/0KeI=;
	h=Date:To:From:Subject:Message-Id; b=YleXX2avtxfDV/AtV2y1JLTufPlNc0oMBcpT4p02PQjy5cRPG39041lNbePJFkBzGjKiQWnHH0FyqtU57oKLSbdZ2TSPYOP4FhJmNvMmurL0duvDQ+Bnv9bsOvOCMVT6j6Ov/vXwRZgVq7XJsFAaL1GtWMycHbyDcjL9k3sGhPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c3piJlNB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c3piJlNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE171F000FF;
	Tue, 29 Sep 2026 00:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790640517;
	bh=PO+y2uXaNONyng3SROadJn7huI1RxETmsIYxayJ4eqA=;
	h=Date:To:From:Subject;
	b=c3piJlNBkJIZhyn8KnF0kuqhtvxOTFD9S2Co6RmIOSgsN10xP1+9tns/CLjsALqSs
	 BlrSpdLNhFlhaqRcG74URzjM1X/oPGpdRfWUtSFH9dEBOughhR5vehlhukqYUlMbUp
	 pfXAwOKjqfRyQJcHKLFuyT+i5nsByqr+mL99Ettc=
Date: Mon, 28 Sep 2026 17:08:37 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,harry@kernel.org,hebaoquan@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + spi-atmel-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch added to mm-new branch
Message-Id: <20260929000837.8AE171F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: spi: atmel: don't use GFP_DMA when calling dma_alloc_coherent()
has been added to the -mm mm-new branch.  Its filename is
     spi-atmel-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/spi-atmel-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

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
Subject: spi: atmel: don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:32 +0800

dma_alloc_coherent() allocates the DMA buffer with the device's addressing
limitation in mind; the DMA core picks the zone from the device's coherent
DMA mask and ignores GFP_DMA passed by the caller.  Remove the redundant
GFP_DMA flag.

Link: https://lore.kernel.org/20260903111836.1777265-10-hebaoquan@kylinos.cn
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>
---

 drivers/spi/spi-atmel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-atmel.c~spi-atmel-dont-use-gfp_dma-when-calling-dma_alloc_coherent
+++ a/drivers/spi/spi-atmel.c
@@ -624,7 +624,7 @@ static int atmel_spi_configure_dma(struc
 	if (IS_ENABLED(CONFIG_SOC_SAM_V4_V5)) {
 		as->addr_tx_bbuf = dma_alloc_coherent(dev, SPI_MAX_DMA_XFER,
 						      &as->dma_addr_tx_bbuf,
-						      GFP_KERNEL | GFP_DMA);
+						      GFP_KERNEL);
 		if (!as->addr_tx_bbuf) {
 			err = -ENOMEM;
 			goto err_release_dma;
@@ -632,7 +632,7 @@ static int atmel_spi_configure_dma(struc
 
 		as->addr_rx_bbuf = dma_alloc_coherent(dev, SPI_MAX_DMA_XFER,
 						      &as->dma_addr_rx_bbuf,
-						      GFP_KERNEL | GFP_DMA);
+						      GFP_KERNEL);
 		if (!as->addr_rx_bbuf) {
 			err = -ENOMEM;
 			goto err_release_dma;
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

