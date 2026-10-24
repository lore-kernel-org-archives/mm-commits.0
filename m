Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832314;
	b=FlS2weqlnL+ym3J0E6mBKGa+Vn3I9X0ae8DWV3YK4HywTjnZFZsQr5Dp7MxfF3nGRNz4
	 7eod5jZNyYjOHsE5FcHds1YfuwfOClMhChqEfMqfTwAbOFp/oX2MCxdgrmQ2WQTSlW8/i
	 Yp2mY3g/QD51BK/1DswYumBi4xnJnz53Y9EdjuPl1C0L/An82+T7+L376HTDlqBi8Yf33
	 6lQkeheC6+VcohckEnN5oSvARxyAfcAYqlkbUiNnX6JIJSCEQC63+/A78+I97rAGyuQc4
	 wtNvIDUxDpwmzt3W4BP3IfAOOBrB1Qx7KSZxWTmdyTjawZfrN6tGcwLz0Ujqh0A3+6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832314;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=9u3vrJ5ojh2P3v6oTyK+hhyu3MVeduOlS6uLMCqTXVY=;
	b=eRxmTUqfimRIj49JGTSTlqY2ikgVB+EsNSyYRxCuGQ8MedgeGGHZnEZG7t/cFXkgG5WW
	 0imJdBN/UYgaqoOzTt4MSaP88aiuaYjyGgVtL+z9qg9bUMnFy1P6cHWSB0j2MWTLdkxtQ
	 VpX/Faqh2lzhg/xgvDBSIhAOaFyf3+2/OHcKk9noJZURkwt3YGDz9RiELmU1xsEG1GBih
	 dg1G0IJMLgRq3DlmLw6n/SjAwohuUoq7U2MYQuAxSiWOWI3pG30V+mfowWupKkjInFJRb
	 HFLOz0vOI8vBnfnU3z3gz2dFhsrRjJSZRv8ErCrPLO9Jiv6IFWj//hmeata2VbJdizg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=w89k9JnP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AE5606A31F
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=w89k9JnP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0031F031E4;
	Sat, 24 Oct 2026 08:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832314;
	bh=9u3vrJ5ojh2P3v6oTyK+hhyu3MVeduOlS6uLMCqTXVY=;
	h=Date:To:From:Subject;
	b=w89k9JnPo2bvRpnaokD/TCVo1jOOTUEETuz6p1Up2Ai2lobP6R0NaPRc9Svtn5lcI
	 UDeTop0YiyfhgdH2u1nklds+ZuvA9s81nlnzc+QET9V5cCu5uTbwD8johgSBiRkitM
	 oNb+g4TPeilV08rxWKY/mt3PeYSIGRo2GH0sIqqI=
Date: Sat, 24 Oct 2026 01:58:34 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,harry@kernel.org,hebaoquan@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] usb-cdns2-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch removed from -mm tree
Message-Id: <20261024085834.6E0031F031E4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: usb: cdns2: don't use GFP_DMA when calling dma_alloc_coherent()
has been removed from the -mm tree.  Its filename was
     usb-cdns2-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <hebaoquan@kylinos.cn>
Subject: usb: cdns2: don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:36 +0800

dma_alloc_coherent() allocates the DMA buffer with the device's
addressing limitation in mind; the DMA core picks the zone from the
device's coherent DMA mask and ignores GFP_DMA passed by the caller.
Use GFP_KERNEL instead so the allocation may reclaim as usual for
probe-time allocations.

Link: https://lore.kernel.org/20260903111836.1777265-14-hebaoquan@kylinos.cn
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>
---

 drivers/usb/gadget/udc/cdns2/cdns2-gadget.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/cdns2/cdns2-gadget.c~usb-cdns2-dont-use-gfp_dma-when-calling-dma_alloc_coherent
+++ a/drivers/usb/gadget/udc/cdns2/cdns2-gadget.c
@@ -2341,7 +2341,7 @@ static int cdns2_gadget_start(struct cdn
 
 	/* Allocate memory for setup packet buffer. */
 	buf = dma_alloc_coherent(pdev->dev, 8, &pdev->ep0_preq.request.dma,
-				 GFP_DMA);
+				 GFP_KERNEL);
 	pdev->ep0_preq.request.buf = buf;
 
 	if (!pdev->ep0_preq.request.buf) {
_

Patches currently in -mm which might be from hebaoquan@kylinos.cn are


