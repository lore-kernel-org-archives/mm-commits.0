Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2636E15ADA6
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 00:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741048732; cv=none; b=EUpMdRn3QBgxPPPhMTK9VS4cyjv6WVY2gaOyFjIBMVc46dch0v9cxPfV5Qme97cy1AMiTcBPGI7dLr961vGA9StE0CJpOQGOdhVUOpnHEGqgIMfAyCanrrX4+49PLJOXwSWjIEOdu7NNf1LYAbbK5AF/En2oO4S2V7SsbJQhQ2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741048732; c=relaxed/simple;
	bh=qPd9P3f1dwVhbyKvVOqIkvLPs4RHfMSZBQX4tSCdNU0=;
	h=Date:To:From:Subject:Message-Id; b=Gn3hqhdP4X9j2dWFT59MwJHw+uv21Vo3Ykkr4l2hgpSRLrS30k+A0YdgVa/c8dv2a1TrU+kY4HLMeQQpBYQ2G7zY3hdNFpovcheKdniKLdk9NBW9TSvKEb8HVnbdX3Ke4RZO51WvVetxPVKGiEMnztgtFV5Luhr2uzgOa6VjeZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=addgeYOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="addgeYOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9516FC4CEE8;
	Tue,  4 Mar 2025 00:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741048731;
	bh=qPd9P3f1dwVhbyKvVOqIkvLPs4RHfMSZBQX4tSCdNU0=;
	h=Date:To:From:Subject:From;
	b=addgeYOKZl7Ay+RuW7uLSHYrfJvbzS9t0kGp1KbHxwwpuuMVBgpRmfBYSD2ZO6lDe
	 pfGTE7CP8peAUZGsfwgPcq9icPfXQ529Jf0ZJ/CfZoXZkamc9umO2Q2mz7wPcmLSwC
	 gZ8P/agVnDK0LlBLayADNqxNN1gYivQF2t3cmLg0=
Date: Mon, 03 Mar 2025 16:38:51 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-rework-recompression-loop.patch added to mm-unstable branch
Message-Id: <20250304003851.9516FC4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: rework recompression loop
has been added to the -mm mm-unstable branch.  Its filename is
     zram-rework-recompression-loop.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-rework-recompression-loop.patch

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
Subject: zram: rework recompression loop
Date: Mon, 3 Mar 2025 11:03:19 +0900

This reworks recompression loop handling:

- set a rule that stream-put NULLs the stream pointer If the loop
  returns with a non-NULL stream then it's a successful recompression,
  otherwise the stream should always be NULL.

- do not count the number of recompressions Mark object as
  incompressible as soon as the algorithm with the highest priority failed
  to compress that object.

- count compression errors as resource usage Even if compression has
  failed, we still need to bump num_recomp_pages counter.

Link: https://lkml.kernel.org/r/20250303022425.285971-11-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   54 +++++++++++---------------------
 1 file changed, 20 insertions(+), 34 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-rework-recompression-loop
+++ a/drivers/block/zram/zram_drv.c
@@ -1888,9 +1888,8 @@ static int recompress_slot(struct zram *
 	unsigned int comp_len_new;
 	unsigned int class_index_old;
 	unsigned int class_index_new;
-	u32 num_recomps = 0;
 	void *src, *dst;
-	int ret;
+	int ret = 0;
 
 	handle_old = zram_get_handle(zram, index);
 	if (!handle_old)
@@ -1933,7 +1932,6 @@ static int recompress_slot(struct zram *
 		if (!zram->comps[prio])
 			continue;
 
-		num_recomps++;
 		zstrm = zcomp_stream_get(zram->comps[prio]);
 		src = kmap_local_page(page);
 		ret = zcomp_compress(zram->comps[prio], zstrm,
@@ -1942,7 +1940,8 @@ static int recompress_slot(struct zram *
 
 		if (ret) {
 			zcomp_stream_put(zstrm);
-			return ret;
+			zstrm = NULL;
+			break;
 		}
 
 		class_index_new = zs_lookup_class_index(zram->mem_pool,
@@ -1952,6 +1951,7 @@ static int recompress_slot(struct zram *
 		if (class_index_new >= class_index_old ||
 		    (threshold && comp_len_new >= threshold)) {
 			zcomp_stream_put(zstrm);
+			zstrm = NULL;
 			continue;
 		}
 
@@ -1960,14 +1960,6 @@ static int recompress_slot(struct zram *
 	}
 
 	/*
-	 * We did not try to recompress, e.g. when we have only one
-	 * secondary algorithm and the page is already recompressed
-	 * using that algorithm
-	 */
-	if (!zstrm)
-		return 0;
-
-	/*
 	 * Decrement the limit (if set) on pages we can recompress, even
 	 * when current recompression was unsuccessful or did not compress
 	 * the page below the threshold, because we still spent resources
@@ -1976,38 +1968,32 @@ static int recompress_slot(struct zram *
 	if (*num_recomp_pages)
 		*num_recomp_pages -= 1;
 
-	if (class_index_new >= class_index_old) {
+	/* Compression error */
+	if (ret)
+		return ret;
+
+	if (!zstrm) {
 		/*
 		 * Secondary algorithms failed to re-compress the page
-		 * in a way that would save memory, mark the object as
-		 * incompressible so that we will not try to compress
-		 * it again.
+		 * in a way that would save memory.
 		 *
-		 * We need to make sure that all secondary algorithms have
-		 * failed, so we test if the number of recompressions matches
-		 * the number of active secondary algorithms.
+		 * Mark the object incompressible if the max-priority
+		 * algorithm couldn't re-compress it.
 		 */
-		if (num_recomps == zram->num_active_comps - 1)
-			zram_set_flag(zram, index, ZRAM_INCOMPRESSIBLE);
+		if (prio < zram->num_active_comps)
+			return 0;
+		zram_set_flag(zram, index, ZRAM_INCOMPRESSIBLE);
 		return 0;
 	}
 
-	/* Successful recompression but above threshold */
-	if (threshold && comp_len_new >= threshold)
-		return 0;
-
 	/*
-	 * No direct reclaim (slow path) for handle allocation and no
-	 * re-compression attempt (unlike in zram_write_bvec()) since
-	 * we already have stored that object in zsmalloc. If we cannot
-	 * alloc memory for recompressed object then we bail out and
-	 * simply keep the old (existing) object in zsmalloc.
+	 * We are holding per-CPU stream mutex and entry lock so better
+	 * avoid direct reclaim.  Allocation error is not fatal since
+	 * we still have the old object in the mem_pool.
 	 */
 	handle_new = zs_malloc(zram->mem_pool, comp_len_new,
-			       __GFP_KSWAPD_RECLAIM |
-			       __GFP_NOWARN |
-			       __GFP_HIGHMEM |
-			       __GFP_MOVABLE);
+			       GFP_NOIO | __GFP_NOWARN |
+			       __GFP_HIGHMEM | __GFP_MOVABLE);
 	if (IS_ERR_VALUE(handle_new)) {
 		zcomp_stream_put(zstrm);
 		return PTR_ERR((void *)handle_new);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-sleepable-entry-locking.patch
zram-permit-preemption-with-active-compression-stream.patch
zram-remove-unused-crypto-include.patch
zram-remove-max_comp_streams-device-attr.patch
zram-remove-second-stage-of-handle-allocation.patch
zram-add-gfp_nowarn-to-incompressible-zsmalloc-handle-allocation.patch
zram-remove-writestall-zram_stats-member.patch
zram-limit-max-recompress-prio-to-num_active_comps.patch
zram-filter-out-recomp-targets-based-on-priority.patch
zram-rework-recompression-loop.patch
zram-move-post-processing-target-allocation.patch
zsmalloc-rename-pool-lock.patch
zsmalloc-sleepable-zspage-reader-lock.patch
zsmalloc-introduce-new-object-mapping-api.patch
zram-switch-to-new-zsmalloc-object-mapping-api.patch
zram-permit-reclaim-in-zstd-custom-allocator.patch
zram-do-not-leak-page-on-recompress_store-error-path.patch
zram-do-not-leak-page-on-writeback_store-error-path.patch
zram-add-might_sleep-to-zcomp-api.patch

