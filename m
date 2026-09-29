Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FFA156C6A
	for <mm-commits@vger.kernel.org>; Tue, 29 Sep 2026 00:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790640504; cv=none; b=Z2aUGfeJTZCYVAjJCa582mCAW0KmPQ76uhzSwVWIYUaRCfVlS5Bbv2yuN1DuqKC56byvyubI9nsBBGgHjT9YAz36ekiiSuGMnDfPZ+2yFQggoSJlPAj18M2TTWheUXhsvls94LioyYfE6dqh1XvhxO0iOxtnygAZ2ENLLCCZ8p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790640504; c=relaxed/simple;
	bh=wjtEf7/V1EC15weyEL+ILcNCjJYFBqpW/G7QzqDrxyQ=;
	h=Date:To:From:Subject:Message-Id; b=e9+LPVTDJgfhSLPcvvIG8gvReZZIGLXoTmkM9p0fP/hgs5///uPj3+20uBhgBlmpL08vrHxh/JrgZE7m2vKF1jkgChxeJXLkj6eavs/cuzZ4tlAzu+fTfauhCOlHqpXHzbv26pJ2uz6Wk2v39FeQgRcXeyi6ia2wwBPWl/rBMqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pUDus8bC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pUDus8bC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69BE11F000FF;
	Tue, 29 Sep 2026 00:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790640502;
	bh=7U3sQywgPwid07Rj0vZOmJh28orUTLsB0zv91ircQp8=;
	h=Date:To:From:Subject;
	b=pUDus8bC+m4r0AI6Z6f+NwhvX3p1VPYrOwEurVNxfB8gRwdihV0XuRp6bUQY4x5Qc
	 JkXqsWFtiUoY4MQkT9m+FeAmD2iLE5CMDcxr/usi5F9tTNkPxV7QyZ3+kxl78KCkKv
	 EABuScRs9vzkml9Cs9DEuXYUVAnak/gYB4DvGI7w=
Date: Mon, 28 Sep 2026 17:08:22 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,harry@kernel.org,hebaoquan@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + gpu-ipu-v3-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch added to mm-new branch
Message-Id: <20260929000822.69BE11F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: gpu: ipu-v3: don't use GFP_DMA when calling dma_alloc_coherent()
has been added to the -mm mm-new branch.  Its filename is
     gpu-ipu-v3-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gpu-ipu-v3-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

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
Subject: gpu: ipu-v3: don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:24 +0800

Patch series "Don't use GFP_DMA when calling dma_alloc_coherent".

This series picks up the first part of an earlier cleanup series [1] that
was prepared back in the year of 2022, but for various reasons never made
it merged and has been sitting in a local tree since then.  This subset
only touches the call sites where GFP_DMA is passed to
dma_alloc_coherent() (and its dma_alloc_wc()/dmam_alloc_coherent()
variants), which is the most self-contained and least risky slice of that
work.

That GFP_DMA is simply redundant here: the DMA API derives the allocation
zone from the device's coherent_dma_mask (together with bus_dma_limit) and
ignores the GFP_DMA flag passed by the caller.  

Removing the redundant GFP_DMA won't harm anything, while keeps it from
being blindly copied into new code.


This patch (of 13):

dma_alloc_coherent() allocates the DMA buffer with the device's addressing
limitation in mind; the DMA core picks the zone from the device's coherent
DMA mask and ignores GFP_DMA passed by the caller.  Remove the redundant
GFP_DMA flag.

Link: https://lore.kernel.org/20260903111836.1777265-1-hebaoquan@kylinos.cn
Link: https://lore.kernel.org/20260903111836.1777265-2-hebaoquan@kylinos.cn
Link: https://lore.kernel.org/all/20220219005221.634-1-bhe@redhat.com/T/#u [1]
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>
---

 drivers/gpu/ipu-v3/ipu-image-convert.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/ipu-v3/ipu-image-convert.c~gpu-ipu-v3-dont-use-gfp_dma-when-calling-dma_alloc_coherent
+++ a/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -371,7 +371,7 @@ static int alloc_dma_buf(struct ipu_imag
 {
 	buf->len = PAGE_ALIGN(size);
 	buf->virt = dma_alloc_coherent(priv->ipu->dev, buf->len, &buf->phys,
-				       GFP_DMA | GFP_KERNEL);
+				       GFP_KERNEL);
 	if (!buf->virt) {
 		dev_err(priv->ipu->dev, "failed to alloc dma buffer\n");
 		return -ENOMEM;
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

