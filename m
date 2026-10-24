Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832310;
	b=2nfcdxkqQkg5RT91V0dvVRgbwHqoLrINd/NGkHLOMjnEu918/NfMIC7PzvqW8c+LPZvi
	 h0OhAq4zQdtJuAQ8JXE6nmanU62FFCGXHvt25Q7Dt+EUSiVI3DsoV6gg+QECcJC/c5OWI
	 o1hyj0h4EyidIPqFnNT9vQK3AqqkdGsLgwGbMLdarXRHZAeZDG3BUGM4DFGSueW59EOCx
	 ZymfIqKMKK3gfrVTQGsJcmy3TEI849x2JCp0xWSQOo6i8vQWzp/mDGhiP6SCBauIx0vCF
	 zQ0qidkLtIwqNofiBqNk7gPFaeLVmtHFn4XCnqr5W9W+mdb5nByPqUuQ5Qy0gZeHoNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832310;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=9WLLs6PlYP9SvUYMuv+oJQl8m0WtUXBrqibW1F/pQ2s=;
	b=FNSmkzaDwzGly4d/zzLhTM3R3sgSrhTvDVZtSJdwECI2sldUdd3hK5iAivZfdsNzjflg
	 mT53sa5cPSKPXhV35NV0cXs8b3hBc0frd/RWSLCjGLy1nvQNY61Y003s4eSRLMy6oeT/x
	 quFQ3lp8rH/gVZYOvtGKoo5cveX1wHI3t82oGHNkQbady/0oe7kdOh4VMMg+kP4iOzlpi
	 sEXE/FrTXIV3qoEuqaWlyl07vplK2JNN4oQEQoOGlBw4IxhAcULpm0neAb/qKcRBvBUiD
	 ajCOmKKQ6Ym+f2N2CdNfMvy3dcu1FwjbiHhzF3LCM35tQE3stLVALjoH7F+thyBQKOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zlZxXqxV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFB8606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zlZxXqxV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B551F01828;
	Sat, 24 Oct 2026 08:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832310;
	bh=9WLLs6PlYP9SvUYMuv+oJQl8m0WtUXBrqibW1F/pQ2s=;
	h=Date:To:From:Subject;
	b=zlZxXqxVKxQuqtOK79TMM0BUkMDPd53emPzOqnPHjjof6vXqMmNTCYolveRUeVD/N
	 fUDcZdcE6BnrIfG8+SWB9VUH0Rilwb2Tn/EiHAF63A8ffSPv/gH936cs5sL74/pyyu
	 zRyYQt6MxaK843AQ/u959CuRHdhnN4BSrRrDT3lA=
Date: Sat, 24 Oct 2026 01:58:29 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,harry@kernel.org,hebaoquan@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] spi-atmel-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch removed from -mm tree
Message-Id: <20261024085830.45B551F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: spi: atmel: don't use GFP_DMA when calling dma_alloc_coherent()
has been removed from the -mm tree.  Its filename was
     spi-atmel-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <hebaoquan@kylinos.cn>
Subject: spi: atmel: don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:32 +0800

dma_alloc_coherent() allocates the DMA buffer with the device's addressing
limitation in mind; the DMA core picks the zone from the device's coherent
DMA mask and ignores GFP_DMA passed by the caller.  Remove the redundant
GFP_DMA flag.

Link: https://lore.kernel.org/20260903111836.1777265-10-hebaoquan@kylinos.cn
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>
---

 drivers/spi/spi-atmel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-atmel.c~spi-atmel-dont-use-gfp_dma-when-calling-dma_alloc_coherent
+++ a/drivers/spi/spi-atmel.c
@@ -624,7 +624,7 @@ static int atmel_spi_configure_dma(struc
 	if (IS_ENABLED(CONFIG_SOC_SAM_V4_V5)) {
 		as->addr_tx_bbuf = dma_alloc_coherent(dev, SPI_MAX_DMA_XFER,
 						      &as->dma_addr_tx_bbuf,
-						      GFP_KERNEL | GFP_DMA);
+						      GFP_KERNEL);
 		if (!as->addr_tx_bbuf) {
 			err = -ENOMEM;
 			goto err_release_dma;
@@ -632,7 +632,7 @@ static int atmel_spi_configure_dma(struc
 
 		as->addr_rx_bbuf = dma_alloc_coherent(dev, SPI_MAX_DMA_XFER,
 						      &as->dma_addr_rx_bbuf,
-						      GFP_KERNEL | GFP_DMA);
+						      GFP_KERNEL);
 		if (!as->addr_rx_bbuf) {
 			err = -ENOMEM;
 			goto err_release_dma;
_

Patches currently in -mm which might be from hebaoquan@kylinos.cn are


