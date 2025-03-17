Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2F3217673
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188416; cv=none; b=sCQuy58XD0Z9Ue6MeLPE25UgqwueGZ6ghpZ8k2GJwsB8gBdEsju5KwdpuWjqPzFgW+dl9DQeeeIhRvDE7imSteknqupYK41F/73KksXYpOaU/fDLRe7jN/Ok/Kf7FLtC5aSTiFQiMl4itbzhCNcjaym2MAMzhfzEJlkLQJ8yEaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188416; c=relaxed/simple;
	bh=MDaHWarqfN/apLmMOLvsgsmX0b70HCnzZWOXkpXw19A=;
	h=Date:To:From:Subject:Message-Id; b=Kr3lWFxCAtYdhkNbgCpb4pUUObtJsrUCSUFPsZ/nPuAl9ez/ZSXh8ArVTlZ4hyvtSDU7lywpnB9sScAOiKpN6TWeO4lPqcORKjgiIekS+dBAt/yAmer7UXWTXgGiEZWsTPKHMdew4bLKG3VKtommLnjNetdUVql9uFQl2a3oU50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e6/069uI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e6/069uI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D75C4CEEC;
	Mon, 17 Mar 2025 05:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188416;
	bh=MDaHWarqfN/apLmMOLvsgsmX0b70HCnzZWOXkpXw19A=;
	h=Date:To:From:Subject:From;
	b=e6/069uItKVUGFdHd9Ljc1KKNWt36+x83gD2tfk7NZFvXZDdWEvcXAz9B2iu3xYLe
	 PQ5ZOcLhlC2/RLCPvOIdhwYXdqBz9TR6qmBtWlco+eJDUf8wSKcHVAxf9Ng0dwZXVB
	 hiT/moEUek6ew4cFJvM3Jvuz18MxBJ+lJLlQLJ7s=
Date: Sun, 16 Mar 2025 22:13:35 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-remove-second-stage-of-handle-allocation.patch removed from -mm tree
Message-Id: <20250317051336.12D75C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: remove second stage of handle allocation
has been removed from the -mm tree.  Its filename was
     zram-remove-second-stage-of-handle-allocation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: remove second stage of handle allocation
Date: Mon, 3 Mar 2025 11:03:14 +0900

Previously zram write() was atomic which required us to pass
__GFP_KSWAPD_RECLAIM to zsmalloc handle allocation on a fast path and
attempt a slow path allocation (with recompression) if the fast path
failed.

Since we are not in atomic context anymore we can permit direct reclaim
during handle allocation, and hence can have a single allocation path. 
There is no slow path anymore so we don't unlock per-CPU stream (and don't
lose compressed data) which means that there is no need to do
recompression now (which should reduce CPU and battery usage).

Link: https://lkml.kernel.org/r/20250303022425.285971-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   39 +++++---------------------------
 1 file changed, 7 insertions(+), 32 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-remove-second-stage-of-handle-allocation
+++ a/drivers/block/zram/zram_drv.c
@@ -1723,11 +1723,11 @@ static int write_incompressible_page(str
 static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 {
 	int ret = 0;
-	unsigned long handle = -ENOMEM;
-	unsigned int comp_len = 0;
+	unsigned long handle;
+	unsigned int comp_len;
 	void *dst, *mem;
 	struct zcomp_strm *zstrm;
-	unsigned long element = 0;
+	unsigned long element;
 	bool same_filled;
 
 	/* First, free memory allocated to this slot (if any) */
@@ -1741,7 +1741,6 @@ static int zram_write_page(struct zram *
 	if (same_filled)
 		return write_same_filled_page(zram, element, index);
 
-compress_again:
 	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
 	mem = kmap_local_page(page);
 	ret = zcomp_compress(zram->comps[ZRAM_PRIMARY_COMP], zstrm,
@@ -1751,7 +1750,6 @@ compress_again:
 	if (unlikely(ret)) {
 		zcomp_stream_put(zstrm);
 		pr_err("Compression failed! err=%d\n", ret);
-		zs_free(zram->mem_pool, handle);
 		return ret;
 	}
 
@@ -1760,35 +1758,12 @@ compress_again:
 		return write_incompressible_page(zram, page, index);
 	}
 
-	/*
-	 * handle allocation has 2 paths:
-	 * a) fast path is executed with preemption disabled (for
-	 *  per-cpu streams) and has __GFP_DIRECT_RECLAIM bit clear,
-	 *  since we can't sleep;
-	 * b) slow path enables preemption and attempts to allocate
-	 *  the page with __GFP_DIRECT_RECLAIM bit set. we have to
-	 *  put per-cpu compression stream and, thus, to re-do
-	 *  the compression once handle is allocated.
-	 *
-	 * if we have a 'non-null' handle here then we are coming
-	 * from the slow path and handle has already been allocated.
-	 */
-	if (IS_ERR_VALUE(handle))
-		handle = zs_malloc(zram->mem_pool, comp_len,
-				   __GFP_KSWAPD_RECLAIM |
-				   __GFP_NOWARN |
-				   __GFP_HIGHMEM |
-				   __GFP_MOVABLE);
+	handle = zs_malloc(zram->mem_pool, comp_len,
+			   GFP_NOIO | __GFP_NOWARN |
+			   __GFP_HIGHMEM | __GFP_MOVABLE);
 	if (IS_ERR_VALUE(handle)) {
 		zcomp_stream_put(zstrm);
-		atomic64_inc(&zram->stats.writestall);
-		handle = zs_malloc(zram->mem_pool, comp_len,
-				   GFP_NOIO | __GFP_HIGHMEM |
-				   __GFP_MOVABLE);
-		if (IS_ERR_VALUE(handle))
-			return PTR_ERR((void *)handle);
-
-		goto compress_again;
+		return PTR_ERR((void *)handle);
 	}
 
 	if (!zram_can_store_page(zram)) {
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


