Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832303;
	b=djvy/BptMYvW390hNuMx1y6drGKQ98dOd7qP0+T+1IwYVepzPSLWQBVoYLYOgAyIJmWm
	 dL0jzyRRPFxwxjc9GFNcInPSIbx/FoLH4FQTXAUj1rcqkkfqlbxhRelhLVY2VbhCR1BxX
	 WKm4Gu9oT0i1DNgCym4xLZF9d8JXZHpkRNgwpNTj96fIqh/IMnohLWin6cPe5ZaYBWYmn
	 PL3ChIP0KemVBIhNOWZ4cWUVjoQIPs0sKULTltmGuwvOcfLDsO3H6XV8ZOkxHuNu4bNmO
	 G/Gl3aeYP3ChW5fR5zYbEUucUO7btvuYcYTEueCXJ1Bsexga4/jIXGaJhRspo7WHJqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832303;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=GZSz3hpOCFIzcEZQUnj2YpRtpA/7m3L44o2cFViXmsA=;
	b=hcNY3+yUG2n9fs9tIh1DK/uG9iRG7hZgJjKQcC0SK9JGg/lwQ0ncc9ENFoqJLVCz/XBu
	 s5JqFbsFnIbvokFjHCrnymBtL50ngLhtY0iNg9DFaSberAuklXuQEm42rd5IF9HVpm3nS
	 GacW3xByHocZUxH589W2pcZvkwr264UkX2TXe20qnRE/5AFH8nG7d35OjqdVU3xmgVMHI
	 LWOk7Btgv/IioX+3zYqh6KNIo4fjPlHym+3UbA5YfgztHYa0CYHKt1zp9xHBKhnNlziI9
	 49ZRAbLzpTEO2Fri4e7zurbg8FLjyHjpY6kOHVOkP0P2LabUfT76L5MQegBHxvv6jzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LT4kg8DC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938D8606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LT4kg8DC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEC01F01825;
	Sat, 24 Oct 2026 08:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832303;
	bh=GZSz3hpOCFIzcEZQUnj2YpRtpA/7m3L44o2cFViXmsA=;
	h=Date:To:From:Subject;
	b=LT4kg8DCh2iuUmXA8ewks4Cjxq3CZTUtt6o4gGlM+9bPBkZVjkMJSVfmcqWFJCQUk
	 XBAU1vh78EcQF5nLTojQhVftfYSLBWdLQQZ0vLfDOfCPy/1S1aztjJ4w8ORZmk1Ub3
	 ARw6hJdQb3XKdZrYzoshwQDZ5W4flzjJTsLVASac=
Date: Sat, 24 Oct 2026 01:58:22 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,harry@kernel.org,hebaoquan@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] gpu-ipu-v3-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch removed from -mm tree
Message-Id: <20261024085823.1EEC01F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: gpu: ipu-v3: don't use GFP_DMA when calling dma_alloc_coherent()
has been removed from the -mm tree.  Its filename was
     gpu-ipu-v3-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


This patch (of 12):

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


