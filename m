Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6FE217709
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188422; cv=none; b=p3m4fTX+7AGekR9Jq4Cn1nFzx4XXI9vsoxZttkaP/p+oyY2YEbet1IT4wiS7ejCVXLgPcupTyn+/XHvQbWje4/RXl01v1uH85d11gQAYFowRzzcs/OVykb7K9ZcGMF0i4kcFys3WlbAh+ncFmlS4w9IVLfTxqkS+zPUFPEWNGiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188422; c=relaxed/simple;
	bh=jPX6uUcV2sZBXeD/PeDp/2vrxOBXXeME2sPrVJdgLzg=;
	h=Date:To:From:Subject:Message-Id; b=rip9GTANCGrA80ZJ1lc/0cXvgREtujj0bb/lu/Z443Ieti3CJ2S0hjhz0eOz0aAe0CfNRwYREvhfInVxjAHGItOQOJ4Vtc98NXb8PVyfO1Fx+J4ikcxzH81XjQcB8jXC5a/UIQ7jKSHLDYZ0jN2gdnHMiTvdnZRgs/ZOgkEUhGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CRbnIrew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CRbnIrew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D79C4CEEC;
	Mon, 17 Mar 2025 05:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188422;
	bh=jPX6uUcV2sZBXeD/PeDp/2vrxOBXXeME2sPrVJdgLzg=;
	h=Date:To:From:Subject:From;
	b=CRbnIrewxVETn7dtzvi7JwvtlV14ds8et9/QFYVANyFPI4m2lmVxDFdJZrkJjCWps
	 4CdB5JBc6u/NZALr6eqYN3YlARvHwTONQvaUizpncMWojS9Dp5E+PfjS6O+TApph/h
	 qyjGpXA/TNJND9S+doF+zhbAj5TJsCb6R0Bhbh0o=
Date: Sun, 16 Mar 2025 22:13:42 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-rework-recompression-loop.patch removed from -mm tree
Message-Id: <20250317051342.B1D79C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: rework recompression loop
has been removed from the -mm tree.  Its filename was
     zram-rework-recompression-loop.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


