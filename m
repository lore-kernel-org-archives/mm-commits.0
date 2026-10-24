Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832312;
	b=nfLLwzuZy0yz3wbKhti3S3ogEKGfEXVtV8TZaw/LfLsKfgye/WsU5i2FnNgigZ6rtWwx
	 dKEUx8JyqpyaXThfv1+0WZw8i4J13gV9+pAmH9E+5w7NIq0nKaiPJLQ43zmvdk9ZmrVQK
	 1rOaDIhXUQZvQp+TCPlt202cV9jTPBaiwHW5g9M9+t0EQpDvOgHqr4moK/FVAjANrme5W
	 usTDQnIPFU4Z6DtlJbInVL09pZsTElYPxM449COh4QTgGu2ijhbycKSiajPQ6O1aax1RQ
	 wBJZpuiZAa5O6NWmEUbyYZXDJlDGTjjB1xUFa/fL/EAA4WdfgK0hsWh62eAt7V1Leyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832312;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=DaptToiAuasm+CdBZ+Ng1NbE8W2z9eHaLjBRXwQhLk4=;
	b=Sza8CHmQmPYYn32WKnyVRuzTVdHLm4OJ5NkBUehdgUa20O3s3ujvsBGlCl7l7KRBCW/B
	 fmhk1B4RkfLJXR2uzgyPAxiT5CH/sYn3j+zPS2SgpynXLkEFxegERFba6VMq5V+cVrc1f
	 I6Fi6yyxz1333Luc7WrGL4k6uTn99U/qfznuD4WgT6PGols0r67QeYvp7+6H7VuFrd2nE
	 vkorRKnZ7odHYR5O5KmXriKqSBUy2zl8OzJsaTPxPCf7oGKdQ3O0P302LeblSthngcgdR
	 O2bZU9LtNySBa0gwPn4dtaCDlGIeirig7WyDLBY7Bjw1WxckfCyyr/mIAFmSbN5yzEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pVK88LIT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE56606A322
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pVK88LIT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E1D1F031E3;
	Sat, 24 Oct 2026 08:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832312;
	bh=DaptToiAuasm+CdBZ+Ng1NbE8W2z9eHaLjBRXwQhLk4=;
	h=Date:To:From:Subject;
	b=pVK88LITQWyvO4kNMQw+uh0gqJsb462sVHC9a3v7oXIW4EHpvktaXPuwOyW6p4wTn
	 +km6HggMA8XzaYQ4LfDVNtkEWbkZJZP/Uc6TcL7J8AyPa71XifJHnU/sqYf4lU5WHT
	 RI77jXK7970qiIXzVcDjRvoHzfaRMjuDd3yBteEI=
Date: Sat, 24 Oct 2026 01:58:31 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,harry@kernel.org,Frank.Li@nxp.com,hebaoquan@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] media-nxp-imx8-isi-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch removed from -mm tree
Message-Id: <20261024085832.58E1D1F031E3@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: media: nxp: imx8-isi: don't use GFP_DMA when calling dma_alloc_coherent()
has been removed from the -mm tree.  Its filename was
     media-nxp-imx8-isi-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


