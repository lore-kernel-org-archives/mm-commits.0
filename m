Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA84282F34
	for <mm-commits@vger.kernel.org>; Tue, 29 Sep 2026 00:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790640523; cv=none; b=uo+BzI8VUHwOdQSXkkUppHumw4nxcv/YosBguWQVUS1NhyiNizATHlSZd6hHOKjGphqVXUySgP/tlOBR+VEJC7iXeUCk66MRyLoVGDoyecQSzB8ofT9hSSuMAATQk5XOyI7AbR9drW+JdPJwa4ffTo4dqgpcuqO2HUglND52T/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790640523; c=relaxed/simple;
	bh=UTCHxdZwgwhHP9KV/1/eF1XDkOYxddYYad11q7muoZo=;
	h=Date:To:From:Subject:Message-Id; b=B82U5dQ+NXOQxBYxuV+RiBWTH2jJxfL1rzF5xBP1fyHvtVLm1UrTOdXLlYEzwFW/SDvWOBsJXv604e7wwOCH8FyOzNKu8HjSjpcjMZlHyDJ/GXuBAzXbAP3969WZgepod/eDTlNC8jQ+HUOXXbpsCCOuupIzwaMiFH7HvkLmzv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p2gmDNTU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p2gmDNTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DAA91F000FF;
	Tue, 29 Sep 2026 00:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790640521;
	bh=la0nSCrqF8quGUmwZ/NXHeOAuRUE6lSCC3U8EHnANeI=;
	h=Date:To:From:Subject;
	b=p2gmDNTUPzGHJRlDrZSgcFT1LnmzRnxw+VJnATLai9LsNLpmHWWldNHPne5nuMZNE
	 Zy2GN+G4cCpDJgDnWt5DSp3k+n4SKKA2wextE5w2V7ojHXdx14OqlMYNUW44TQ3Ncu
	 33H6toOlL3EOP8zM6koWZTrnazZHJUjIqt7lKpQ8=
Date: Mon, 28 Sep 2026 17:08:40 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,harry@kernel.org,Frank.Li@nxp.com,hebaoquan@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + media-nxp-imx8-isi-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch added to mm-new branch
Message-Id: <20260929000841.2DAA91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: media: nxp: imx8-isi: don't use GFP_DMA when calling dma_alloc_coherent()
has been added to the -mm mm-new branch.  Its filename is
     media-nxp-imx8-isi-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/media-nxp-imx8-isi-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

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
Subject: media: nxp: imx8-isi: don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:34 +0800

dma_alloc_coherent() allocates the DMA buffer with the device's addressing
limitation in mind; the DMA core picks the zone from the device's coherent
DMA mask and ignores GFP_DMA passed by the caller.  Remove the redundant
GFP_DMA flag.

Link: https://lore.kernel.org/20260903111836.1777265-12-hebaoquan@kylinos.cn
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>
---

 drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c~media-nxp-imx8-isi-dont-use-gfp_dma-when-calling-dma_alloc_coherent
+++ a/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c
@@ -773,7 +773,7 @@ static int mxc_isi_video_alloc_discard_b
 
 		buf->size = PAGE_ALIGN(video->pix.plane_fmt[i].sizeimage);
 		buf->addr = dma_alloc_coherent(video->pipe->isi->dev, buf->size,
-					       &buf->dma, GFP_DMA | GFP_KERNEL);
+					       &buf->dma, GFP_KERNEL);
 		if (!buf->addr) {
 			mxc_isi_video_free_discard_buffers(video);
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

