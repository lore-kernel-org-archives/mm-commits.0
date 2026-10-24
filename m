Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832309;
	b=Tcdsx3+D+yrC+6I8fzVm1gG+/OmLZUYQ0mQVmSc2oUunN0o2pJmCcvlJdoO+u8p22uuN
	 T02HQ0VYNtxfYSEuj1LVOOHk3yE/LDBR+PS/85cGAaCH17QC4XhJr993gxTY4mH68/lrE
	 9K8TwXuVzAhNHid0AV93WDQ/nJz8FWbSQxhWvtf9CVglBIqzhkbPMKMTv5SZ4Rt7ypCaG
	 Len1N+1YavCbkZiszQ5uP+U/Ls8HcNnOB9fq8WwJyFSJE4Zakn0N3rX2b/wV+XpQLFxv5
	 AeG42v2C2tGvVSa3UeJaEEJfoOu02h0xp8irm3wz9lxjpaBJglY+cY47voXNtFtkcSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832309;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=3viCXHp8vXyTaXifA6BGvKa1zAU4OznJv+kITuipu30=;
	b=CR3ef/7yDKq7Lcf/uhbmE2KOMPKYo6auflrrhBWycxnTIMm5BzECdUb0/yokrcMLPPS4
	 QdISth7JYWsmKP0Qk1aFHMQ85bToT60Z2AeVxtC5lM2pCdbB4ow4bcfpZak1NpSS/YpAC
	 KWHTM35CwaFQAzCkfzVsX+vdVi9q0rp/3LxP4NTJXju6vGdL3HwSa+TpbjDUplrlEVvzt
	 JDk/vnnkVRbhMT9wgPoJd6XmFvUYVUyTSQznKuqDKmGKQyLhvgttFe2ftP8Yt/p30LIMK
	 yGMb02qxod0WQO43upz8oMG1H51/0bH6wLH1TIYpoXuuRXo0rY68M0iUrikg3FtPlRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="DO/0LYu0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72127606A321
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DO/0LYu0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7DD1F01825;
	Sat, 24 Oct 2026 08:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832309;
	bh=3viCXHp8vXyTaXifA6BGvKa1zAU4OznJv+kITuipu30=;
	h=Date:To:From:Subject;
	b=DO/0LYu0gUnVwFcy/zAfdQRmpROUYoYyJTCUcoWxeIDWyYEv3ffbA1Tsi2YEUPmvd
	 ZdE3aKUAkcEIjoKBNTgP0i7Ej7AM2uzMTu1oHmlvVRpccq+5/RlQntNpjoJP/t75gl
	 JtbAGHI8U2sV9n6NsxB+mMcJiQrDLlpg8Dop1Kdo=
Date: Sat, 24 Oct 2026 01:58:28 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,harry@kernel.org,hebaoquan@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] media-staging-imx-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch removed from -mm tree
Message-Id: <20261024085829.3D7DD1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: media: staging: imx: don't use GFP_DMA when calling dma_alloc_coherent()
has been removed from the -mm tree.  Its filename was
     media-staging-imx-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <hebaoquan@kylinos.cn>
Subject: media: staging: imx: don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:31 +0800

dma_alloc_coherent() allocates the DMA buffer with the device's addressing
limitation in mind; the DMA core picks the zone from the device's coherent
DMA mask and ignores GFP_DMA passed by the caller.  Remove the redundant
GFP_DMA flag.

Link: https://lore.kernel.org/20260903111836.1777265-9-hebaoquan@kylinos.cn
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>
---

 drivers/staging/media/imx/imx-media-utils.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/media/imx/imx-media-utils.c~media-staging-imx-dont-use-gfp_dma-when-calling-dma_alloc_coherent
+++ a/drivers/staging/media/imx/imx-media-utils.c
@@ -588,7 +588,7 @@ int imx_media_alloc_dma_buf(struct devic
 
 	buf->len = PAGE_ALIGN(size);
 	buf->virt = dma_alloc_coherent(dev, buf->len, &buf->phys,
-				       GFP_DMA | GFP_KERNEL);
+				       GFP_KERNEL);
 	if (!buf->virt)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from hebaoquan@kylinos.cn are


