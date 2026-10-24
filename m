Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832311;
	b=wkIlGqLnJR4lufx9FGpuWDofg+yIoBW9pIlTH9RRtdrfeidqZygQ0OAeRYDgFrbJdKwk
	 owD4CMIWwluUETtkb5oBm4s30LUlCBDRTyEHX4UK1+7N8dQU/Kc+a0/45nKWko+m7hgFR
	 nKQzD1dEq6E2Bz/od4JZMvtneO8iyrPPyfP1X0OUphXyxNT59+zd1gkf6gQHfDqifak11
	 bUgIsYQ24deMgf9tsHNpJORB/2Y67FuHe0qwHuKxkZC88Or6VR5Jdx11OHKL26fi2EUsu
	 8aI4yWnGy/eYUBVDeiF56umMN4lKl4e9H18GcjBTElxXuo7cHXcCgzS0XzkaNrgGYIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832311;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=qEEJscO5q5PEZ5Bu2O43MQEr6HU2HWFTRdJkmyjhZ2U=;
	b=fF5nhtiiLnd+jj4JQ4p4QLbE6KV+EgzBuXDXOzIcKWc1aUvNgd7heZtoyKR5Ql9SbvEq
	 BdrEA7gPDQMeuyGciWBjpd14gmImMYQeG/i2TnCEA+agsk3QGWUHRLgUNioZeRxbjh5IF
	 VXSFzfPMoJJyniwHwVPeyTy8D2T1B0S8nZGlmoRjeEpMhqp9RVpN+qrMm0kGcx5nofybi
	 ikM4R9aB2DZmhcPuCSIlZiKdmlFQ0EzyUc9VwyQfewC8oZrTurLvOCP1P6RqN5Ovtl+Vg
	 F5bpMCPgWkHtJ9PBuNLKERbiJvOEF+pn+lafRcTNdO7oMlQBi23CHoySoJBIf4ajI2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=S8CUebCD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81887606A323
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=S8CUebCD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDAE1F031E2;
	Sat, 24 Oct 2026 08:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832311;
	bh=qEEJscO5q5PEZ5Bu2O43MQEr6HU2HWFTRdJkmyjhZ2U=;
	h=Date:To:From:Subject;
	b=S8CUebCD/tUjeEQGndtEirF9qpUMIRBAUmd19A4AhNqJ9MuOpI4hek8dBGaQ9gcxt
	 tEEAnJxG7fIUa2TNmeqbmcQ/DFOTDoDqYQkDAbuJkyaaEeRe715rWUzWsreF6NhnPF
	 5NzrN675ev4I/zbsLLz1QJp3BbBtjzjnUO9HRkto=
Date: Sat, 24 Oct 2026 01:58:30 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,harry@kernel.org,Frank.Li@nxp.com,hebaoquan@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] media-imx7-media-csi-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch removed from -mm tree
Message-Id: <20261024085831.4CDAE1F031E2@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: media: imx7-media-csi: don't use GFP_DMA when calling dma_alloc_coherent()
has been removed from the -mm tree.  Its filename was
     media-imx7-media-csi-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <hebaoquan@kylinos.cn>
Subject: media: imx7-media-csi: don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:33 +0800

dma_alloc_coherent() allocates the DMA buffer with the device's addressing
limitation in mind; the DMA core picks the zone from the device's coherent
DMA mask and ignores GFP_DMA passed by the caller.  Remove the redundant
GFP_DMA flag.

Link: https://lore.kernel.org/20260903111836.1777265-11-hebaoquan@kylinos.cn
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>
---

 drivers/media/platform/nxp/imx7-media-csi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/nxp/imx7-media-csi.c~media-imx7-media-csi-dont-use-gfp_dma-when-calling-dma_alloc_coherent
+++ a/drivers/media/platform/nxp/imx7-media-csi.c
@@ -466,7 +466,7 @@ static int imx7_csi_alloc_dma_buf(struct
 
 	buf->len = PAGE_ALIGN(size);
 	buf->virt = dma_alloc_coherent(csi->dev, buf->len, &buf->dma_addr,
-				       GFP_DMA | GFP_KERNEL);
+				       GFP_KERNEL);
 	if (!buf->virt)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from hebaoquan@kylinos.cn are


