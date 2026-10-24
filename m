Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832309;
	b=XPmrCZfDkJLzfIGJJY6Zbh4U8fUEl0vFIHcFNv7fsR/If82fiW5cgcCM4/CIIVnakCV+
	 Um4ZZpttfgdQ/G/MtzAmCmJqmaCCf06Kcgczt4bfvuWBBGxibvUqztujG+oHfM5wdJR9n
	 zmBKupcMxHsyS7gf8orRQGv8A47nOoOsN/N2CzneAOSZbP6Fs5GiqKMXkaPYLHXd6C2pg
	 b/6zXZ0jTieE6Bd1HsOrnkGQi5b3LbKGtqIv3p6E5plxDbVZWdDD0F7lwNzJrjrTSy44S
	 0zlC7r2icnjnxmmurzk9tb1D0ZtfH0Ro7lpvoCEGkATnJbEZeKWh9HbWuid54ETFEJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832309;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=HhkxNg2jbGMiRj6KNkldoTdMWtKo5/awHMR9kqofmbc=;
	b=l8q9ad0hMEyuqvrMOKOq99ITdkTWmDRYbnr3541eo5d/6JBF/mnbIAPMDCUwgHOGIeRl
	 vlHduL13AXE/wAHJxs4D5J5lAIYZOkkuY7XdcDzOGW2qcgitGqWw2XbkHlQiNXW+H8Adh
	 mQf0fo4pb43Zurjo324VdH/N5TlJwuOykv58v1oIaKQok7VtjEXBdBSZVxVchbM/h4ckk
	 30XPLu+b2XfoOBMmvcBOs6YNhuASN2h+Y1Cu7TfVJf1bnOvSjhLJptbzwR4ZhxDxaSGeQ
	 vQ/qFC21vsUNdoaVxCtomPDrL/a18beD0gmC35w2jXSefhWy986lVL+3pzFTHKbQ6/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KHJ2cWsV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B880C606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KHJ2cWsV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377981F01828;
	Sat, 24 Oct 2026 08:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832308;
	bh=HhkxNg2jbGMiRj6KNkldoTdMWtKo5/awHMR9kqofmbc=;
	h=Date:To:From:Subject;
	b=KHJ2cWsV+Ysx0r6gPkFFtoKLFCUIczFgdZqvLqkVwCj04gfg9sC75uZ4JefE6+R5z
	 UbdI7nlY7xgSL9K8HBOSrJFL7LgOoFOV70Z7YC0e4CAfGkXcHzcjk3GxsiGSZcS9PP
	 gv1qI1IUNqINyoKPlXBC39cgkDk9G6vB+XRV9hS8=
Date: Sat, 24 Oct 2026 01:58:27 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,harry@kernel.org,hebaoquan@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] usb-cdns3-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch removed from -mm tree
Message-Id: <20261024085828.377981F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: usb: cdns3: don't use GFP_DMA when calling dma_alloc_coherent()
has been removed from the -mm tree.  Its filename was
     usb-cdns3-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <hebaoquan@kylinos.cn>
Subject: usb: cdns3: don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:30 +0800

dma_alloc_coherent() allocates the DMA buffer with the device's addressing
limitation in mind; the DMA core picks the zone from the device's coherent
DMA mask and ignores GFP_DMA passed by the caller.  Use GFP_KERNEL instead
so the allocation may reclaim as usual for probe-time allocations.

Link: https://lore.kernel.org/20260903111836.1777265-8-hebaoquan@kylinos.cn
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>
---

 drivers/usb/cdns3/cdns3-gadget.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/cdns3/cdns3-gadget.c~usb-cdns3-dont-use-gfp_dma-when-calling-dma_alloc_coherent
+++ a/drivers/usb/cdns3/cdns3-gadget.c
@@ -3376,7 +3376,7 @@ static int cdns3_gadget_start(struct cdn
 
 	/* allocate memory for setup packet buffer */
 	priv_dev->setup_buf = dma_alloc_coherent(priv_dev->sysdev, 8,
-						 &priv_dev->setup_dma, GFP_DMA);
+						 &priv_dev->setup_dma, GFP_KERNEL);
 	if (!priv_dev->setup_buf) {
 		ret = -ENOMEM;
 		goto err2;
_

Patches currently in -mm which might be from hebaoquan@kylinos.cn are


