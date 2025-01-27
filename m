Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAFB195811
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 20:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738011501; cv=none; b=n7SmA2sGzVkS9ufRLNQfmH9hwDA701Wp4f6OiCo6nxS6uysDe4HxYsKvN2RwLRQmvmwKGTW8WU5/04/GdrHXo19MkyJnbhQN0DAT+NUnc0YgglK9TXg5jJ/HLzcX6s5EQY+TkMflBMwNI0cCLKJ9XBKJYprjwCH/msLyPynmC2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738011501; c=relaxed/simple;
	bh=8PQlXa37rp/quDW3r7zh0qxm83HrF472C1DW/wac788=;
	h=Date:To:From:Subject:Message-Id; b=u0Oy1potKT72cWPDuRQgCrdg3CJOyMIrW5ZQijX2lghyn+Avarv0ZXhXAS4udUO8Cr24BsoLY7tNGwypSl8XPiO14I5h42Xj5ZfnBRzWXar1ofPVoXOFhYU0zRvSbIZlTSdwZpwDdVZd4qR5nIRI9JjTkdVOutZxgWjAef6Xu8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vaNKEZws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vaNKEZws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE872C4CED2;
	Mon, 27 Jan 2025 20:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738011501;
	bh=8PQlXa37rp/quDW3r7zh0qxm83HrF472C1DW/wac788=;
	h=Date:To:From:Subject:From;
	b=vaNKEZwsxhqX4FFEMbNvBt+URubz5hFeRMEHDRdXQMFRRUg64WEBgUSl/3UyE3yX5
	 GMulozFBdqqJljaFhAP/rdPo65GhoDvmoPn5AE0FmbzESpPXqM7Dq183+yEeaD3PB8
	 OZhbEFoOO2946dPtRmZkYB1mnZvv4d2PTZEdlQ/k=
Date: Mon, 27 Jan 2025 12:58:20 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-remove-two-staged-handle-allocation.patch added to mm-unstable branch
Message-Id: <20250127205820.DE872C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: remove two-staged handle allocation
has been added to the -mm mm-unstable branch.  Its filename is
     zram-remove-two-staged-handle-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-remove-two-staged-handle-allocation.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: remove two-staged handle allocation
Date: Mon, 27 Jan 2025 16:29:16 +0900

Previously zram write() was atomic which required us to pass
__GFP_KSWAPD_RECLAIM to zsmalloc handle allocation on a fast path and
attempt a slow path allocation (with recompression) when the fast path
failed.

Since it's not atomic anymore we can permit direct reclaim during
allocation, and remove fast allocation path and, also, drop the
recompression path (which should reduce CPU/battery usage).

Link: https://lkml.kernel.org/r/20250127072932.1289973-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   41 ++++----------------------------
 1 file changed, 6 insertions(+), 35 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-remove-two-staged-handle-allocation
+++ a/drivers/block/zram/zram_drv.c
@@ -1725,11 +1725,11 @@ static int write_incompressible_page(str
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
@@ -1743,7 +1743,6 @@ static int zram_write_page(struct zram *
 	if (same_filled)
 		return write_same_filled_page(zram, element, index);
 
-compress_again:
 	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
 	mem = kmap_local_page(page);
 	ret = zcomp_compress(zram->comps[ZRAM_PRIMARY_COMP], zstrm,
@@ -1752,8 +1751,6 @@ compress_again:
 
 	if (unlikely(ret)) {
 		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP], zstrm);
-		pr_err("Compression failed! err=%d\n", ret);
-		zs_free(zram->mem_pool, handle);
 		return ret;
 	}
 
@@ -1762,36 +1759,10 @@ compress_again:
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
+	handle = zs_malloc(zram->mem_pool, comp_len,
+			   GFP_NOIO | __GFP_HIGHMEM | __GFP_MOVABLE);
 	if (IS_ERR_VALUE(handle))
-		handle = zs_malloc(zram->mem_pool, comp_len,
-				   __GFP_KSWAPD_RECLAIM |
-				   __GFP_NOWARN |
-				   __GFP_HIGHMEM |
-				   __GFP_MOVABLE);
-	if (IS_ERR_VALUE(handle)) {
-		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP], zstrm);
-		atomic64_inc(&zram->stats.writestall);
-		handle = zs_malloc(zram->mem_pool, comp_len,
-				   GFP_NOIO | __GFP_HIGHMEM |
-				   __GFP_MOVABLE);
-		if (IS_ERR_VALUE(handle))
-			return PTR_ERR((void *)handle);
-
-		goto compress_again;
-	}
+		return PTR_ERR((void *)handle);
 
 	if (!zram_can_store_page(zram)) {
 		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP], zstrm);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-switch-to-non-atomic-entry-locking.patch
zram-do-not-use-per-cpu-compression-streams.patch
zram-remove-crypto-include.patch
zram-remove-max_comp_streams-device-attr.patch
zram-remove-two-staged-handle-allocation.patch
zram-permit-reclaim-in-zstd-custom-allocator.patch
zram-permit-reclaim-in-recompression-handle-allocation.patch
zram-remove-writestall-zram_stats-member.patch
zram-unlock-slot-during-recompression.patch

