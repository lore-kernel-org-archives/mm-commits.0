Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8F121254B
	for <mm-commits@vger.kernel.org>; Tue, 29 Sep 2026 00:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790640524; cv=none; b=sRwK8rpQM8+i5pzQ6EuHQU1N5tPYFO/+6IRpXqK3jAT51zmUQsKCrGJoMwgC3bqKYHZ0h8eeQRuBNKphRnSP/SneuDAvCWkC4/yY20lrcnolBAMyW3FizyqqqMBvF/+PHlOuZouJu6qzC09MX69ddVNGI8EpLjYqf3b1CurX2kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790640524; c=relaxed/simple;
	bh=euYe+Tzj7isJY0McP+9hq7qjIVe82d3asd9Xfvegsj0=;
	h=Date:To:From:Subject:Message-Id; b=M1g8xmwQQpbAHSwnWQ6rnmxkt6tn2GXbL5Q+abyncRF7zeeDCBQpQn2yle0J3J5H8nVTBGc424Kigq+dB0/UmSYAIf9gllg4Ojm4DgO1w/31X+fbpqy1QcGiS+Dm+eRzev99pCdXk2L+3g9uPn3fsbX5GeJE947C3MqTZW4AYLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0ovxuuD4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0ovxuuD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097F31F00893;
	Tue, 29 Sep 2026 00:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790640523;
	bh=Tk1iq+TyR/LLPY/czDqSmmSLvTp6wwQ9p0LVrhCfYis=;
	h=Date:To:From:Subject;
	b=0ovxuuD42ZgYmJtfzOUVjVeQKl4T1J7cco3jCqydxYC1UYVpGsuajO4WDvWjOZGce
	 5mWDL1BfdBtaCP0d3rpHaKNTeHBNabQaML6OrFJoWwYUV8CYnU6I4F5tCK7o0srVDU
	 OPPHgEi6dFDaRhH3/Vukq+Zp8kZZjvz0QNKAqdI4=
Date: Mon, 28 Sep 2026 17:08:42 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,harry@kernel.org,hebaoquan@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mtd-rawnand-gpmi-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch added to mm-new branch
Message-Id: <20260929000843.097F31F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mtd: rawnand: gpmi: don't use GFP_DMA when calling dma_alloc_coherent()
has been added to the -mm mm-new branch.  Its filename is
     mtd-rawnand-gpmi-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mtd-rawnand-gpmi-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

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
Subject: mtd: rawnand: gpmi: don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:35 +0800

dma_alloc_coherent() allocates the DMA buffer with the device's addressing
limitation in mind; the DMA core picks the zone from the device's coherent
DMA mask and ignores GFP_DMA passed by the caller.  Use GFP_KERNEL instead
so the allocation may reclaim as usual for probe-time allocations.

Link: https://lore.kernel.org/20260903111836.1777265-13-hebaoquan@kylinos.cn
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>
---

 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c~mtd-rawnand-gpmi-dont-use-gfp_dma-when-calling-dma_alloc_coherent
+++ a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -1387,7 +1387,7 @@ static int gpmi_alloc_dma_buffer(struct
 		goto error_alloc;
 
 	this->auxiliary_virt = dma_alloc_coherent(dev, geo->auxiliary_size,
-					&this->auxiliary_phys, GFP_DMA);
+					&this->auxiliary_phys, GFP_KERNEL);
 	if (!this->auxiliary_virt)
 		goto error_alloc;
 
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

