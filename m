Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24D541B354
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525572; cv=none; b=aJqdd4L5hojor8jmtCFCENX2wVcsIuKrevVbiufAlGNkaflfwbTzxfhdWt2tWOSzb6ViDShakOhgvLoBWS3Nj6ehHZcONaCJDi/ksT3YrNkpCTdnWjCtcuhrXrguQfBb67dvzkj1x1T9O1N0JVWKZnkLDBDKX1QdopBa0/JRAro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525572; c=relaxed/simple;
	bh=BsGihtJH6T/jninKQJk0Lclm1YvokmD07MQsgrwha/g=;
	h=Date:To:From:Subject:Message-Id; b=L72+RjKOOnKpvSJhixX2ReqWakERCGDRI9ESENhxsomHPyHJdXcppIL7sk6vf6+ICM/lW/dhMYdOFpBrsoUFs4vg8JdHLPTQQq6ywhr7PS0Rem1EX/IzgUGiPmwL/YkWryZ5Q5u1VCg1G3+mfcYtlSvA7+bq1v3dAJadGc7UDlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0RQPS7a9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0RQPS7a9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AFB1F00898;
	Fri,  9 Oct 2026 05:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525570;
	bh=BSg8Ib182YP3C5xXEBqCSHvJj+a69bm+ucEKd/y/jiQ=;
	h=Date:To:From:Subject;
	b=0RQPS7a9rrt2acDrq6zEU9VqXt2aZ1zL+i81QUNr5WHwo3Yxo3CNcnC7QuxUth3KJ
	 KFqBMURDAY3/+EvQOMYkrcRUim31KED3jiMwqgh9qky+KMnZdkjh+OwZHyohS8sM8M
	 +oEqyqweMoayZqZ1kFU1cx4dSSkc6vwF9jTG1b2w=
Date: Thu, 08 Oct 2026 22:59:30 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,chrisl@kernel.org,chengming.zhou@linux.dev,hebaoquan@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-return-enoent-when-the-swap-device-is-gone.patch removed from -mm tree
Message-Id: <20261009055930.91AFB1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: return -ENOENT when the swap device is gone
has been removed from the -mm tree.  Its filename was
     mm-zswap-return-enoent-when-the-swap-device-is-gone.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <hebaoquan@kylinos.cn>
Subject: mm: zswap: return -ENOENT when the swap device is gone
Date: Sun, 13 Sep 2026 14:30:31 +0800

zswap_writeback_entry() returns -EEXIST when get_swap_device() finds no
device.  -EEXIST is the shrinker's "page already in swap cache" signal,
which makes zswap_shrinker_scan() stop shrinking entirely.  A NULL
get_swap_device() instead means the device is being swapped off, so the
entry is simply stale.

Return -ENOENT so the shrinker skips the stale entry and keeps
scanning.  It affects all swap devices.

Link: https://lore.kernel.org/20260913063031.1689420-1-hebaoquan@kylinos.cn
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-return-enoent-when-the-swap-device-is-gone
+++ a/mm/zswap.c
@@ -1016,7 +1016,7 @@ static int zswap_writeback_entry(struct
 	/* try to allocate swap cache folio */
 	si = get_swap_device(swpentry);
 	if (IS_ERR_OR_NULL(si))
-		return -EEXIST;
+		return -ENOENT;
 
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
_

Patches currently in -mm which might be from hebaoquan@kylinos.cn are

gpu-ipu-v3-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch
drm-sti-dont-use-gfp_dma-when-calling-dma_alloc_wc.patch
spi-spi-ti-qspi-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch
fbdev-fsl-diu-fb-dont-use-gfp_dma-when-calling-dmam_alloc_coherent.patch
usb-gadget-lpc32xx_udc-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch
usb-cdns3-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch
media-staging-imx-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch
spi-atmel-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch
media-imx7-media-csi-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch
media-nxp-imx8-isi-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch
mtd-rawnand-gpmi-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch
usb-cdns2-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

