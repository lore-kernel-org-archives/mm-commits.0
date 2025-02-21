Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4178F42A95
	for <mm-commits@vger.kernel.org>; Fri, 21 Feb 2025 23:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740181359; cv=none; b=qFDmGI0b/3ghFm6yZnydbG4DYgau1TJdF33V+5CxYRIVpUvkwG9Pzp8zuesx8Qfp+wfEdJiWeyCarQstT8cvXhUecXTsf914cqDUidUZEWLIAZzt/gIeYfDutTnAUaDz97e+aZXSvBdfRsfVBEGdR8jlPbfIxB8h1cnsuD917WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740181359; c=relaxed/simple;
	bh=3IOnc5Kbwd6V/hz5naUKse18XLbXMWyKeJ31my4CE84=;
	h=Date:To:From:Subject:Message-Id; b=tnrkJkvt37uQlib/zbhFM0OyN8587ANln3IqvKXoarxmSaf1Ce2qjvbmzG0d7jq02EW7Dy5LwxbBQdDT0WcJQm0jgJyLxQeU9UhDcyHuw83AiinwChcjJO+UIWGS9LSQUsIosqMPKSkaXuhiCac2lJSNoOwnjX7wrY/JUw/OXow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hnmpdyyk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hnmpdyyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD53C4CED6;
	Fri, 21 Feb 2025 23:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740181358;
	bh=3IOnc5Kbwd6V/hz5naUKse18XLbXMWyKeJ31my4CE84=;
	h=Date:To:From:Subject:From;
	b=HnmpdyykNNBTqMsctT/ZYXP93z/jja69RR+6mnP+JYoa4thC40UljmZ7XTDMMFhQu
	 UL27ZwWFMZX6iIN80Hb8VjmDrtKVQMhRQgvzPxy5OeIgJYQphlj0spPjEBTBA2fmZ4
	 BhdbEZknwePJnvW19E8D25Ygkb95yC1dfaQf+Ang=
Date: Fri, 21 Feb 2025 15:42:38 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-remove-second-stage-of-handle-allocation.patch added to mm-unstable branch
Message-Id: <20250221234238.9AD53C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: remove second stage of handle allocation
has been added to the -mm mm-unstable branch.  Its filename is
     zram-remove-second-stage-of-handle-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-remove-second-stage-of-handle-allocation.patch

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
Subject: zram: remove second stage of handle allocation
Date: Sat, 22 Feb 2025 07:25:36 +0900

Previously zram write() was atomic which required us to pass
__GFP_KSWAPD_RECLAIM to zsmalloc handle allocation on a fast path and
attempt a slow path allocation (with recompression) if the fast path
failed.

Since we are not in atomic context anymore we can permit direct reclaim
during handle allocation, and hence can have a single allocation path. 
There is no slow path anymore so we don't unlock per-CPU stream (and don't
lose compressed data) which means that there is no need to do
recompression now (which should reduce CPU and battery usage).

Link: https://lkml.kernel.org/r/20250221222958.2225035-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   38 +++++---------------------------
 1 file changed, 6 insertions(+), 32 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-remove-second-stage-of-handle-allocation
+++ a/drivers/block/zram/zram_drv.c
@@ -1729,11 +1729,11 @@ static int write_incompressible_page(str
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
@@ -1747,7 +1747,6 @@ static int zram_write_page(struct zram *
 	if (same_filled)
 		return write_same_filled_page(zram, element, index);
 
-compress_again:
 	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
 	mem = kmap_local_page(page);
 	ret = zcomp_compress(zram->comps[ZRAM_PRIMARY_COMP], zstrm,
@@ -1757,7 +1756,6 @@ compress_again:
 	if (unlikely(ret)) {
 		zcomp_stream_put(zstrm);
 		pr_err("Compression failed! err=%d\n", ret);
-		zs_free(zram->mem_pool, handle);
 		return ret;
 	}
 
@@ -1766,35 +1764,11 @@ compress_again:
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
+			   GFP_NOIO | __GFP_HIGHMEM | __GFP_MOVABLE);
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

zram-sleepable-entry-locking.patch
zram-permit-preemption-with-active-compression-stream.patch
zram-remove-unused-crypto-include.patch
zram-remove-max_comp_streams-device-attr.patch
zram-remove-second-stage-of-handle-allocation.patch
zram-remove-writestall-zram_stats-member.patch
zram-limit-max-recompress-prio-to-num_active_comps.patch
zram-filter-out-recomp-targets-based-on-priority.patch
zram-rework-recompression-loop.patch
zsmalloc-rename-pool-lock.patch
zsmalloc-make-zspage-lock-preemptible.patch
zsmalloc-introduce-new-object-mapping-api.patch
zram-switch-to-new-zsmalloc-object-mapping-api.patch
zram-permit-reclaim-in-zstd-custom-allocator.patch
zram-do-not-leak-page-on-recompress_store-error-path.patch
zram-do-not-leak-page-on-writeback_store-error-path.patch
zram-add-might_sleep-to-zcomp-api.patch
zsmalloc-zram-there-be-preemption.patch

