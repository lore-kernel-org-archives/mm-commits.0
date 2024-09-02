Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A8DEEC0
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725246851; cv=none; b=pKW1LdcUFJfz73U5VupMyo8RmcXl/fHSMj6gKTtvCpLjjsD9uOlJRyEwObIPLIC1GTip0HdIZ1CkY3PdxHJIx2PMrN3+FQ5OLrwrQgo4uSDVwm6BvVZuQ3VLRmgrL4sEgHlm4JvFwh/+MnW/FU+RmSA99RYYfQ3j+W+K9q/zWNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725246851; c=relaxed/simple;
	bh=pmxLWvnZVUc3MZI0DmIz5ftY5J1PN6wl9q1t1OBxMN4=;
	h=Date:To:From:Subject:Message-Id; b=qe6XhQtNZbZ/KaP5nc3TxMkYt0TRA0QFQjW+UIm7p9zH2pBUhkgFRrr25fCcomBhR+nMr7VdsPMr8R+CdhkHQP7HwH37HgrtLZJQoiKmRq6ciS8NnFDfxO7B7iaoxQWGpDfnz99rLVcO2s/W+j2EGC9rY5+Dez/LwyjGuGEfZq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KOQfKRcQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KOQfKRcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F6EC4CEC3;
	Mon,  2 Sep 2024 03:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725246851;
	bh=pmxLWvnZVUc3MZI0DmIz5ftY5J1PN6wl9q1t1OBxMN4=;
	h=Date:To:From:Subject:From;
	b=KOQfKRcQVxMKm0ldWknImPFwD71TmYsuCCJERju4eEPkR6Ws7vMzXrzRIIcyoqVv/
	 srOSp5O2yIBmiGP87y8OGhVMrGV10+hXyni+Fb0VvNX5m/PQthiT0xCZ/rAs8eOWBL
	 NPvjRKYaGP2Y3UF7MnP/Rzranr04dVQpvbhMmsFE=
Date: Sun, 01 Sep 2024 20:14:10 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,hannes@cmpxchg.org,flintglass@gmail.com,chengming.zhou@linux.dev,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zswap-track-swapins-from-disk-more-accurately-fix.patch removed from -mm tree
Message-Id: <20240902031411.41F6EC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zswap: track swapins from disk more accurately (fix)
has been removed from the -mm tree.  Its filename was
     zswap-track-swapins-from-disk-more-accurately-fix.patch

This patch was dropped because it was folded into zswap-track-swapins-from-disk-more-accurately.patch

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: zswap: track swapins from disk more accurately (fix)
Date: Mon, 5 Aug 2024 17:45:18 -0700

Squeeze a comment into a single line.

Link: https://lkml.kernel.org/r/20240806004518.3183562-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Takero Funaki <flintglass@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/page_io.c~zswap-track-swapins-from-disk-more-accurately-fix
+++ a/mm/page_io.c
@@ -524,9 +524,7 @@ void swap_read_folio(struct folio *folio
 		goto finish;
 	}
 
-	/*
-	 * We have to read the page from slower devices. Increase zswap protection.
-	 */
+	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
 
 	if (data_race(sis->flags & SWP_FS_OPS)) {
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zswap-implement-a-second-chance-algorithm-for-dynamic-zswap-shrinker.patch
zswap-track-swapins-from-disk-more-accurately.patch

