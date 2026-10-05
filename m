Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DA937B020
	for <mm-commits@vger.kernel.org>; Mon,  5 Oct 2026 13:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791206220; cv=none; b=UUXpRD/imexZ5tUrjd40cWkfzUbTohAPLWRcqkJGPjsS0vN9qA/bbEY4Ej5pRdwokM7dCOfV9xbA6Hb4myq5Ua/VTjlv961I7s5rXjeWl6Ffo2gGM6URJ4Xe38Q5+ndqF+++j4pi74FjeDuVt+N9i7YbtWjfygkRvY0K7jQ9CNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791206220; c=relaxed/simple;
	bh=mdodjLi0/rm8U22Eg5PFtRr2OWgNIPiTyDDyFsL6SI4=;
	h=Date:To:From:Subject:Message-Id; b=t5UDTNw/e9a4YXwWMxYXyNmrgW+T65G7iI6m/G5THzgt8H7lpX6JomPas+8ad/TFPJH1rhILCICQvKFDPJ3p4t2c4YHY3tjl/+neuS2gYucf+Kdj5+FhOVGpZ+SqQhbKMeEllXvociy2Y8fGpvbp5B16tX3CiP+zgwyNjJOFqZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jilJyuQr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jilJyuQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C3F1F00893;
	Mon,  5 Oct 2026 13:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791206219;
	bh=PtiYXlkfw3QkPKcX3WvZBRQDncCj9XQdvFABEomVkRo=;
	h=Date:To:From:Subject;
	b=jilJyuQrPT+67WvWbnSK8fnuV43Tbr7tJIVcHkFbCBXxGzGE+fWigjui7hk2tl4uc
	 E8t53mRESpvnUJzGnketlQYEpf0c3jTgYDHG1vYw+TalmwUOsQQEUz7atTP+c/Q/V1
	 Zmo7c4xJNXXhzZAFyPNgYnJeMuV7nSsS4iEnuytQ=
Date: Mon, 05 Oct 2026 06:16:58 -0700
To: mm-commits@vger.kernel.org,tiwai@suse.de,hch@lst.de,harry@kernel.org,hebaoquan@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] alsa-n64-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch removed from -mm tree
Message-Id: <20261005131659.31C3F1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ALSA: n64: don't use GFP_DMA when calling dma_alloc_coherent()
has been removed from the -mm tree.  Its filename was
     alsa-n64-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <hebaoquan@kylinos.cn>
Subject: ALSA: n64: don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:26 +0800

dma_alloc_coherent() allocates the DMA buffer with the device's addressing
limitation in mind; the DMA core picks the zone from the device's coherent
DMA mask and ignores GFP_DMA passed by the caller.  Remove the redundant
GFP_DMA flag.

Link: https://lore.kernel.org/20260903111836.1777265-4-hebaoquan@kylinos.cn
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>
---

 sound/mips/snd-n64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/mips/snd-n64.c~alsa-n64-dont-use-gfp_dma-when-calling-dma_alloc_coherent
+++ a/sound/mips/snd-n64.c
@@ -298,7 +298,7 @@ static int __init n64audio_probe(struct
 	priv->card = card;
 
 	priv->ring_base = dma_alloc_coherent(card->dev, 32 * 1024, &priv->ring_base_dma,
-					     GFP_DMA|GFP_KERNEL);
+					     GFP_KERNEL);
 	if (!priv->ring_base) {
 		err = -ENOMEM;
 		goto fail_card;
_

Patches currently in -mm which might be from hebaoquan@kylinos.cn are

mm-zswap-return-enoent-when-the-swap-device-is-gone.patch
gpu-ipu-v3-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch
drm-sti-dont-use-gfp_dma-when-calling-dma_alloc_wc.patch
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

