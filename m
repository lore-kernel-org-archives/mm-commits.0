Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793814266;
	b=p7aw8l56pLb6mncOpmGBBpwGaYkNgZBHarM8po3OtAz3VeFSvetFiArjjYRmAIWEfsZw
	 aN2G5npS3VGn+MVORFvwgSadlHMdj2qgPCaijsuigbgh7zaLL63teVnmAK/2DRwpdaxHB
	 PcKiqViLXFIgpT6bA0BzpFW6lRrGrA/l305MG9zUpm2ryU7LfaycI7cBoEYdv6sDR1pWM
	 nlvMN7KcMzd/CdZ+Np1LNwI9X+Pwb+w0gonsF2u64nP/Bptmg+5swO0w3xmxo3QxZyt7W
	 nBU7kGgQ3t6Pcg0bqgNDGHvjKZahyY0AVDBFF2shM6cfBYpx4N/bPYIq2QMkrCPg7uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793814266;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=4u7yojq4C1piyWEYM+yThKRcbhPJxFCab8WOg6awpn0=;
	b=z38qVXgk3kLlxDXnZ27oPdMZD7YWpuKAyDyeo7755Dh5LPl4j8Zy0t2ldHMs7BAp32Vi
	 uK3Yz3zbzICHfnS2+PvOtR4i3wIuuhxrqqFqzIsmMG8AY1ct8a/8KT4sTsqmcYOjU0iuP
	 VUVUhbesX2OTKLTeqwKQ5jlhbgURNnZWUV9E9ykLFXjjesg9S1obTrv4VQ4IzUHBtIMJ6
	 bhKvd+aU9pKoc++gcmQu9+gLWPR7nXKJeJTYdewx2aCCcAKgYbIwLCWEwU+2+P9O3oOM+
	 VvEQtsolS/W5v4wLEX183EMby5ZMw18sn3joCkjSbqkhGDYkx6upiPhHd2EmAaZebrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ehcuh4eV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39408606A31B
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 17:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ehcuh4eV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6231F000C1;
	Wed,  4 Nov 2026 17:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793814265;
	bh=4u7yojq4C1piyWEYM+yThKRcbhPJxFCab8WOg6awpn0=;
	h=Date:To:From:Subject;
	b=Ehcuh4eVYmdmjC3YXnt/F+sqK15bIgH5mMo/el9FL0Fqopk5tDA2CDbjOCD2HHGL/
	 1kcfoQVA+/V93zy0ByDDmci9TN+Hd3A4mFkvhtsCYzlaouPTuPfZkxPiaGeHlxWi0U
	 LZ8uvHGJQdwpszGQRBjxeYCcXXd5zlT1Ks+Vi16E=
Date: Wed, 04 Nov 2026 09:44:25 -0800
To: mm-commits@vger.kernel.org,mporter@kernel.crashing.org,
	james010kim@gmail.com,error27@gmail.com,alex.bou9@gmail.com,
	akpm@linux-foundation.org,Frank.Li@nxp.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rapidio-use-dmaengine_desc_set_callback.patch added to mm-nonmm-unstable branch
Message-Id: <20261104174425.AA6231F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: rapidio: use dmaengine_desc_set_callback()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rapidio-use-dmaengine_desc_set_callback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rapidio-use-dmaengine_desc_set_callback.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Frank Li <Frank.Li@nxp.com>
Subject: rapidio: use dmaengine_desc_set_callback()
Date: Tue,  3 Nov 2026 09:37:56 -0500

Replace open-coded assignments to callback and callback_param fields of
struct dma_async_tx_descriptor with calls to the
dmaengine_desc_set_callback() helper in rio_mport_cdev driver.

No functional change intended. Prepare to make struct
dma_async_tx_descriptor private to the DMA engine.

Link: https://lore.kernel.org/20261103143759.1168880-1-Frank.Li@oss.nxp.com
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: James Kim <james010kim@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-use-dmaengine_desc_set_callback
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -717,8 +717,7 @@ static int do_dma_request(struct mport_d
 		goto err_out;
 	}
 
-	tx->callback = dma_xfer_callback;
-	tx->callback_param = req;
+	dmaengine_desc_set_callback(tx, dma_xfer_callback, NULL, req);
 
 	req->status = DMA_IN_PROGRESS;
 	kref_get(&req->refcount);
_

Patches currently in -mm which might be from Frank.Li@nxp.com are

rapidio-use-dmaengine_desc_set_callback.patch

