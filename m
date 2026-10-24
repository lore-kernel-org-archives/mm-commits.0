Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832305;
	b=Go1ms3hC3Hepy5ThlaiyNRPB3ZjcKHtKmdVJHHSPjmC7iqTHHaD4rBTZiJMxaSKPT+zG
	 IbWCVgAZaYKcIPYsdhAEhD2qFOxbAvswpDtGEJVX90bjVXZIM/RNWpZNHeSFXDdM5xZGO
	 KRrekMUSoisZeww8W5leqPO3UrXSJKqs50Yv1/SN8mIgK7QAQUFMFkYS5h/nfH55D5dWK
	 HL1gqsZxTpUa8aellum7c8bvqFmUnO6IsIcOmP9BIhI++dNbq8ZHyJz3I6jxezq5h6PVX
	 rnuwtBVYOLkhEIrEst5dTVVBm7WBqOIgRN59CCRmrMjtMHzYrvyzWKUqCjFKcSXtR9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832305;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=7hDmgxj+IsrHU0hBpHfCGG7jYLoxxkaRZd6Ll01sNFc=;
	b=PQqzbKay/7BUhkTkUy/OMj9s58D13UyWVMiVejWIAM9iCof1ADJlHwkWmLAl+wrycoc4
	 W2HPRE7JpFq3/tfGxqICIGjAI1W2CTuVzN9p+9GcbWhauZyFSsx3vvscYwsTl6ccp7MEr
	 fByOTTJfIg2r7FdieX+AiNUyO/mXnNCliKtJOyQskAsNhGVLy2Labu5Pf2uXru9rpjKyi
	 Kl4AobB8fjVxcr+Tqh59m6hls1lrPLn2QkAzdmfc7kkbwPfhsHb8mR0onyVT7sE/Vl8PO
	 I1LHZqZAX2fuOF28VdI3Et64AK7mXmcssmYhxnLR5VlgDABpkQi0q6Jl4f/F6d1+neA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="oe/rgKcE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609B1606A32C
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oe/rgKcE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF9C1F01828;
	Sat, 24 Oct 2026 08:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832305;
	bh=7hDmgxj+IsrHU0hBpHfCGG7jYLoxxkaRZd6Ll01sNFc=;
	h=Date:To:From:Subject;
	b=oe/rgKcE0rposf6s/YcA15VW29yriXhJWhbTwE4NyUxJlktNiLhthVgMHs9djMTnk
	 uw+1DR9PXnXG3JbEOpLjkgjgFQC9BAecaQG/E6sGz6Rkr6cmFiZhdzKYnIzedhH/Dn
	 zK3J4o0qgcDVS+jWjUMpPysJM2eBVzDFz+PdcdIo=
Date: Sat, 24 Oct 2026 01:58:24 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,harry@kernel.org,hebaoquan@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] spi-spi-ti-qspi-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch removed from -mm tree
Message-Id: <20261024085825.2BF9C1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: spi: spi-ti-qspi: don't use GFP_DMA when calling dma_alloc_coherent()
has been removed from the -mm tree.  Its filename was
     spi-spi-ti-qspi-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <hebaoquan@kylinos.cn>
Subject: spi: spi-ti-qspi: don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:27 +0800

dma_alloc_coherent() allocates the DMA buffer with the device's addressing
limitation in mind; the DMA core picks the zone from the device's coherent
DMA mask and ignores GFP_DMA passed by the caller.  Remove the redundant
GFP_DMA flag.

Link: https://lore.kernel.org/20260903111836.1777265-5-hebaoquan@kylinos.cn
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>
---

 drivers/spi/spi-ti-qspi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-ti-qspi.c~spi-spi-ti-qspi-dont-use-gfp_dma-when-calling-dma_alloc_coherent
+++ a/drivers/spi/spi-ti-qspi.c
@@ -855,7 +855,7 @@ static int ti_qspi_probe(struct platform
 	qspi->rx_bb_addr = dma_alloc_coherent(qspi->dev,
 					      QSPI_DMA_BUFFER_SIZE,
 					      &qspi->rx_bb_dma_addr,
-					      GFP_KERNEL | GFP_DMA);
+					      GFP_KERNEL);
 	if (!qspi->rx_bb_addr) {
 		dev_err(qspi->dev,
 			"dma_alloc_coherent failed, using PIO mode\n");
_

Patches currently in -mm which might be from hebaoquan@kylinos.cn are


