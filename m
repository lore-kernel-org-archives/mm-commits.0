Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FC6156C6A
	for <mm-commits@vger.kernel.org>; Tue, 29 Sep 2026 00:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790640505; cv=none; b=GLKFKo57gBXcgK1e+dbRpRn1+JQ2vcFGDi03IcwEBALrtefkhkTi/dqaUG+73tSlsMQpe2lyYqeRkPh3rZdKRfqTratKt/bIGPilGwZx6DBFHmOu/efM4r6s9q7f1IZXM3Krf64/ERHeHlbJtxFcuj4Apw032rP6SaTfCRC2B1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790640505; c=relaxed/simple;
	bh=6f7XE7tlY5F0UpIFobTHycgP8Kb85JFgwc/9rue2vac=;
	h=Date:To:From:Subject:Message-Id; b=fTR4f8iZ+fmNsL1lLgWJHIMBRh7Ltkg9PIIaVrgfiJQh2/bDbc27uJdWTsdvMCeJ2RZRqsFs5xVRYkNmq1D1xPy/c1XPs3X9MB4FL9wBecAIgDIPJW8a6GQ9Q5bBrwIxbDBNUFgLV6BVyfXojPGe7DWQercHmQhN+LkqB1TfdII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n8yED6RA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n8yED6RA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453351F00893;
	Tue, 29 Sep 2026 00:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790640504;
	bh=7IHU8MssRH+IJWhHfQwV7O+34HWU3jjF2gfOhKlOG/Y=;
	h=Date:To:From:Subject;
	b=n8yED6RAB/IRjLz8dQp1Eyp4u6/ATgEWolYg56wh8t8rBWACgHKFrDkKS75Qk3o0U
	 kc12VfX2Lm8eY6pCqqH1jE7XQ4bFcl8l0cv3jjxcHbqMl5wR5en+U9nRE0YGpwlrqq
	 d1Eu00s30VCAuOAokgm8QShYLWUw4mwqJEIfxyts=
Date: Mon, 28 Sep 2026 17:08:23 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,harry@kernel.org,hebaoquan@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-sti-dont-use-gfp_dma-when-calling-dma_alloc_wc.patch added to mm-new branch
Message-Id: <20260929000824.453351F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drm/sti: don't use GFP_DMA when calling dma_alloc_wc()
has been added to the -mm mm-new branch.  Its filename is
     drm-sti-dont-use-gfp_dma-when-calling-dma_alloc_wc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-sti-dont-use-gfp_dma-when-calling-dma_alloc_wc.patch

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
Subject: drm/sti: don't use GFP_DMA when calling dma_alloc_wc()
Date: Thu,  3 Sep 2026 19:18:25 +0800

dma_alloc_wc() allocates the DMA buffer with the device's addressing
limitation in mind; the DMA core picks the zone from the device's coherent
DMA mask and ignores GFP_DMA passed by the caller.  Remove the redundant
GFP_DMA flag.

Link: https://lore.kernel.org/20260903111836.1777265-3-hebaoquan@kylinos.cn
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>
---

 drivers/gpu/drm/sti/sti_cursor.c |    4 ++--
 drivers/gpu/drm/sti/sti_hqvdp.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/sti/sti_cursor.c~drm-sti-dont-use-gfp_dma-when-calling-dma_alloc_wc
+++ a/drivers/gpu/drm/sti/sti_cursor.c
@@ -240,7 +240,7 @@ static int sti_cursor_atomic_check(struc
 		cursor->pixmap.base = dma_alloc_wc(cursor->dev,
 						   cursor->pixmap.size,
 						   &cursor->pixmap.paddr,
-						   GFP_KERNEL | GFP_DMA);
+						   GFP_KERNEL);
 		if (!cursor->pixmap.base) {
 			DRM_ERROR("Failed to allocate memory for pixmap\n");
 			return -EINVAL;
@@ -380,7 +380,7 @@ struct drm_plane *sti_cursor_create(stru
 	/* Allocate clut buffer */
 	size = 0x100 * sizeof(unsigned short);
 	cursor->clut = dma_alloc_wc(dev, size, &cursor->clut_paddr,
-				    GFP_KERNEL | GFP_DMA);
+				    GFP_KERNEL);
 
 	if (!cursor->clut) {
 		DRM_ERROR("Failed to allocate memory for cursor clut\n");
--- a/drivers/gpu/drm/sti/sti_hqvdp.c~drm-sti-dont-use-gfp_dma-when-calling-dma_alloc_wc
+++ a/drivers/gpu/drm/sti/sti_hqvdp.c
@@ -860,7 +860,7 @@ static void sti_hqvdp_init(struct sti_hq
 	size = NB_VDP_CMD * sizeof(struct sti_hqvdp_cmd);
 	hqvdp->hqvdp_cmd = dma_alloc_wc(hqvdp->dev, size,
 					&dma_addr,
-					GFP_KERNEL | GFP_DMA);
+					GFP_KERNEL);
 	if (!hqvdp->hqvdp_cmd) {
 		DRM_ERROR("Failed to allocate memory for VDP cmd\n");
 		return;
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

