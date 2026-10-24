Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832307;
	b=iX7huwyY0NV4uzUAyZ0hIJXkNb2mkmLMDU4hPwB6ApZMTbG93qRY3zrZq8snvQVTcyk9
	 H0u4hfWU3CXYjwR7t8YvRG0sAz06gaKXwq1VJKbWTqdErVkUW7wIqPrtSLGsno7zw/TMP
	 Eoa6+tsD6V5GMxailtPOz16l3kM6VW3Js8XW57GbElqIZjIZM7relHlCNrG9Ls/TIpGg3
	 kQPZiW3TS5wIG2nkE8NPjLgKKBnisKzgeqwqF/R0cRzwvSO4CNJe7AoJee7/oN5phiian
	 oR+QuHecpW0QacXSikHD4UTfR3r8eXbL/zsPYvwoGVh8ImIJLQhdmXpCX1vxd2WmyOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832307;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=M3ek/Kv35hnQ6TWy4L7lIZn46w1kqhiq01C9/bV+vE0=;
	b=z4Nj6OFIs+kcu9cteVCrbm+ej1QujFjMg+EPyJmJQAuVrInt3KauwN4kaDKg0e0RyHGo
	 TM43/5q5K0b2ZQ2RG3USdmjUtNJQVksx01Owbtb4Bj1y/zPR/6E4XOxqsDha6WJJ3PDrX
	 8v7Hef3M4OSGt2w33I/j21pDs1b+yBisEaYvQTkrCbkv7e1Y5+rWXikMfjJyFPqL21bqZ
	 KY976ooZZYFzirXb7GGiAPBDVl+5x3uwjxmtlWEX3t9+9L9YsdymPCZpz0DdqHyF7POPM
	 6pp9W2SkTTZ+lmwM9Lj0J5pV+G3BkqY0wqKtfnNGdUtPdVDUeS4tteCLr/y/ktsnopQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hddBMpbl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668AC606A31B
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hddBMpbl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3258D1F01828;
	Sat, 24 Oct 2026 08:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832307;
	bh=M3ek/Kv35hnQ6TWy4L7lIZn46w1kqhiq01C9/bV+vE0=;
	h=Date:To:From:Subject;
	b=hddBMpblVLVkNcq0z4lsiX+ffL956Qsy4nwsUIYQD2GEz5PvlD5hvSBpUyMq4rgnG
	 whDeB1L7zof1XM917zegAbGe0O8uQ3FMMHESK0Ml1AhaOnTLajtLMYHBV/uEO3DGgw
	 8uN6jR+7J7wzInCA4AP77EeXdY70f8qAiqs5l+H8=
Date: Sat, 24 Oct 2026 01:58:26 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,harry@kernel.org,hebaoquan@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] usb-gadget-lpc32xx_udc-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch removed from -mm tree
Message-Id: <20261024085827.3258D1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: usb: gadget: lpc32xx_udc: don't use GFP_DMA when calling dma_alloc_coherent()
has been removed from the -mm tree.  Its filename was
     usb-gadget-lpc32xx_udc-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <hebaoquan@kylinos.cn>
Subject: usb: gadget: lpc32xx_udc: don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:29 +0800

dma_alloc_coherent() allocates the DMA buffer with the device's addressing
limitation in mind; the DMA core picks the zone from the device's coherent
DMA mask and ignores GFP_DMA passed by the caller.  Remove the redundant
GFP_DMA flag.

Link: https://lore.kernel.org/20260903111836.1777265-7-hebaoquan@kylinos.cn
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>
---

 drivers/usb/gadget/udc/lpc32xx_udc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/lpc32xx_udc.c~usb-gadget-lpc32xx_udc-dont-use-gfp_dma-when-calling-dma_alloc_coherent
+++ a/drivers/usb/gadget/udc/lpc32xx_udc.c
@@ -3080,7 +3080,7 @@ static int lpc32xx_udc_probe(struct plat
 	/* Allocate memory for the UDCA */
 	udc->udca_v_base = dma_alloc_coherent(&pdev->dev, UDCA_BUFF_SIZE,
 					      &dma_handle,
-					      (GFP_KERNEL | GFP_DMA));
+					      GFP_KERNEL);
 	if (!udc->udca_v_base) {
 		dev_err(udc->dev, "error getting UDCA region\n");
 		retval = -ENOMEM;
_

Patches currently in -mm which might be from hebaoquan@kylinos.cn are


