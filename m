Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F6E4AEE0
	for <mm-commits@vger.kernel.org>; Sat, 15 Feb 2025 00:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739578696; cv=none; b=sBQHag/ZGvb4fZquZW6RUt4SW4mBpvQV/isSftbVuBs6l+mFIQmIJdIxOP0TR3nbwTzPgVBkHhVlvADWXdpCVWJM1QeWJ5jlnT6v5dIRwwSWE75TgdVZNdwAico7JXvS/I3kUn+kNKk+Ds5bK63FCfdoW0zFwr9AezdIIATNOj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739578696; c=relaxed/simple;
	bh=RR8MvPNdtE63AMfo9gm8L6LFKExy22+tuLeNtkkqWbQ=;
	h=Date:To:From:Subject:Message-Id; b=uy8Bo0C1MAo2PWCIXAQYuM4+jUn8nGEPzQMqej6rKnv6AXMx4goVpDkotFLmKioxcwjOnwK6YFmxcfvGPlCK8gtdVBhOxzBDMA/ayA4be3aiSXUp0Zn1KUuLWL/ZSFXjj4WU1dSLjAsU3ZjITR4+vJ/GHu2saRPpovxbRGwWk3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M2pNgFcN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M2pNgFcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26963C4CED1;
	Sat, 15 Feb 2025 00:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739578695;
	bh=RR8MvPNdtE63AMfo9gm8L6LFKExy22+tuLeNtkkqWbQ=;
	h=Date:To:From:Subject:From;
	b=M2pNgFcN+q4MtrrsBkwbV1HSq/F3V1wpgcutLGBS5emCl6jInNIkgIX7+fNpfBajT
	 0Wp3r+sXnmWVCSZc0pQAR9eyZ3u8lpdqT4iZt/9uEZg7S3Xm64R4Fia9FhltFqWgm8
	 QltUQkzxQhAGguq5mu2dZad0paGHu8VLDsUQXKRs=
Date: Fri, 14 Feb 2025 16:18:14 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-remove-two-staged-handle-allocation.patch added to mm-unstable branch
Message-Id: <20250215001815.26963C4CED1@smtp.kernel.org>
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
Date: Fri, 14 Feb 2025 13:50:17 +0900

Previously zram write() was atomic which required us to pass
__GFP_KSWAPD_RECLAIM to zsmalloc handle allocation on a fast path and
attempt a slow path allocation (with recompression) when the fast path
failed.

Since it's not atomic anymore we can permit direct reclaim during
allocation, and remove fast allocation path and, also, drop the
recompression path (which should reduce CPU/battery usage).

Link: https://lkml.kernel.org/r/20250214045208.1388854-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   38 +++++---------------------------
 1 file changed, 6 insertions(+), 32 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-remove-two-staged-handle-allocation
+++ a/drivers/block/zram/zram_drv.c
@@ -1766,11 +1766,11 @@ static int write_incompressible_page(str
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
@@ -1784,7 +1784,6 @@ static int zram_write_page(struct zram *
 	if (same_filled)
 		return write_same_filled_page(zram, element, index);
 
-compress_again:
 	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
 	mem = kmap_local_page(page);
 	ret = zcomp_compress(zram->comps[ZRAM_PRIMARY_COMP], zstrm,
@@ -1794,7 +1793,6 @@ compress_again:
 	if (unlikely(ret)) {
 		zcomp_stream_put(zstrm);
 		pr_err("Compression failed! err=%d\n", ret);
-		zs_free(zram->mem_pool, handle);
 		return ret;
 	}
 
@@ -1803,35 +1801,11 @@ compress_again:
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
zram-remove-two-staged-handle-allocation.patch
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

