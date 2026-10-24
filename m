Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832306;
	b=q0oFXcRjrrgYT382WyqOFsFC31P1Vvan9HxEPC935XPsUzMgm14eScrpiRmPvfWfsmEO
	 GQTtzZayyX/AApJx836uZ6/YT1fFkiV8eegvlhaXxDcEAHnJ5IVU8w/FC1KajAqj3Igrj
	 PeTPNSJKxN8P1N/ajLCgAs3+KXmCKSgCaJxRf0sSS47NS31NYS16vBzrSwvCzVpn51CEr
	 4xP8cGo211mXKR4I6RMPleQzrSz+avoLOnsED//jS6rfsWzRxw9cUC/Bu5LAGW27h68Zr
	 mdCo0D+ePM/qFUnFc09PAGGAQCznbjORUP7JwHtaA88qJV9UfbWSFRsyeh/TgsdBEjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832306;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=qZfvqlhHukquvkkEaQrdRw1/weuJZFWhOqZ2kSUhqt0=;
	b=aOO+Lg51Pv4CHd+cqebubhGPs1ZtVcZcJ+Aly1LrDSZhZgOYoNPfW8zIS5zQTV2aigI/
	 +lmLm8y2/Ui+aI1l1qc8vhJkRLhMWbJHU0VzbzhfM/enHpBT3o0PE4txelDE8+XVwSm4e
	 Lx9N0v9PARs21rYoF6z7nwe/0ocGNUTCKBXjkgs0HE5s9GhXpBoDhRtRPrOI87Z3OKSnE
	 UKcIyZmIrZATUBEbUQpULyXfBVQXPp7n7ClSJak6nc5/n05ValdFLIbUaVqOwc4JD4K4b
	 2naJSmTPm/tLNXsE84NftJP8604uGkz6Gwjwl1lMhCLoUYH5+jMETE+f4A/UK0Iro3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=X6seR5zK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D06606A31B
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=X6seR5zK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD4D1F01828;
	Sat, 24 Oct 2026 08:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832306;
	bh=qZfvqlhHukquvkkEaQrdRw1/weuJZFWhOqZ2kSUhqt0=;
	h=Date:To:From:Subject;
	b=X6seR5zKMUl2vIMwmzGwXoBNx8XtmGV97WhjL/w8F+MQaZhww6AIf77hiMJsP4mEv
	 8xK3/c/Zj/COdgxj9HCp++mWIAQRQH22mMonLQ34ACghUNr+9904wldkG93QByBqsZ
	 AkV5jvn13wOA6PMYLXtOu9vQJHzayQuPZMIZmjqY=
Date: Sat, 24 Oct 2026 01:58:25 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,harry@kernel.org,hebaoquan@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fbdev-fsl-diu-fb-dont-use-gfp_dma-when-calling-dmam_alloc_coherent.patch removed from -mm tree
Message-Id: <20261024085826.2FD4D1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: fbdev: fsl-diu-fb: don't use GFP_DMA when calling dmam_alloc_coherent()
has been removed from the -mm tree.  Its filename was
     fbdev-fsl-diu-fb-dont-use-gfp_dma-when-calling-dmam_alloc_coherent.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <hebaoquan@kylinos.cn>
Subject: fbdev: fsl-diu-fb: don't use GFP_DMA when calling dmam_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:28 +0800

dmam_alloc_coherent() allocates the DMA buffer with the device's
addressing limitation in mind; the DMA core picks the zone from the
device's coherent DMA mask and ignores GFP_DMA passed by the caller. 
Remove the redundant GFP_DMA flag.

Link: https://lore.kernel.org/20260903111836.1777265-6-hebaoquan@kylinos.cn
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>
---

 drivers/video/fbdev/fsl-diu-fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/fsl-diu-fb.c~fbdev-fsl-diu-fb-dont-use-gfp_dma-when-calling-dmam_alloc_coherent
+++ a/drivers/video/fbdev/fsl-diu-fb.c
@@ -1690,7 +1690,7 @@ static int fsl_diu_probe(struct platform
 	int ret;
 
 	data = dmam_alloc_coherent(&pdev->dev, sizeof(struct fsl_diu_data),
-				   &dma_addr, GFP_DMA | __GFP_ZERO);
+				   &dma_addr, __GFP_ZERO);
 	if (!data)
 		return -ENOMEM;
 	data->dma_addr = dma_addr;
_

Patches currently in -mm which might be from hebaoquan@kylinos.cn are


