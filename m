Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A20F255F28
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744859; cv=none; b=I8Aj3EBxpvfIyrvYbimgos8AwaOCO+ez83oPZxLZajBo3zigEU4oAGzJKDeRCCeM6JbMSdjaSF6OxsvBwL6sQbDngF+87O0hgj6KKnOpPfBTmCXkiMdnEUK0eRw3Wk7EinC4zYC2qY6IWeknutARBAPRACKCVKtnx0YUJxnljFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744859; c=relaxed/simple;
	bh=C5a4aUv3+/JKiRuvV9tChRpQ8MAHBSsimWKbSJnZgs4=;
	h=Date:To:From:Subject:Message-Id; b=ASrBk/8Q1LIXUgf0BuK6zGc6ng44ShLLXozIJLGorPiX1+jcqE/j1IW8W9ohM2wcV2D+SD0Lr0sBeGBDy2adt/utRb05L6fZ8cVpzwK2hmebptIQ6Sx3mGTHtPp3nMdiILD6U6R2GwCA6eC/6bo63SucaCohRjtnX+7OLTC7uyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=maydXgc5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="maydXgc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F1FC4CEF7;
	Sun, 29 Mar 2026 00:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744859;
	bh=C5a4aUv3+/JKiRuvV9tChRpQ8MAHBSsimWKbSJnZgs4=;
	h=Date:To:From:Subject:From;
	b=maydXgc5jcydXr7pSNpN0OTF95dOD2dv0P1EQNi/IuMbEjQGrJQiZf6RQRxLLQqrV
	 L7Lw7xb5QZQTUvHDObnBVkVPaf6BtJF/JEZSkDyWu8wuSgm1P4eNo21PlV0zzYt1tl
	 zs/0f8I88c4+QUIeoBUgQnlYTV9isflHViaPGgVs=
Date: Sat, 28 Mar 2026 17:40:58 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,gaoxu2@honor.com,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-remove-chained-recompression.patch removed from -mm tree
Message-Id: <20260329004058.E7F1FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: remove chained recompression
has been removed from the -mm tree.  Its filename was
     zram-remove-chained-recompression.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: remove chained recompression
Date: Wed, 11 Mar 2026 17:42:48 +0900

Chained recompression has unpredictable behavior and is not useful in
practice.

First, systems usually configure just one alternative recompression
algorithm, which has slower compression/decompression but better
compression ratio.  A single alternative algorithm doesn't need chaining.

Second, even with multiple recompression algorithms, chained recompression
is suboptimal.  If a lower priority algorithm succeeds, the page is never
attempted with a higher priority algorithm, leading to worse memory
savings.  If a lower priority algorithm fails, the page is still attempted
with a higher priority algorithm, wasting resources on the failed lower
priority attempt.

In either case, the system would be better off targeting a specific
priority directly.

Chained recompression also significantly complicates the code.  Remove it.

Link: https://lkml.kernel.org/r/20260311084312.1766036-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: gao xu <gaoxu2@honor.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |    9 -
 drivers/block/zram/zram_drv.c               |   84 +++++-------------
 2 files changed, 24 insertions(+), 69 deletions(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~zram-remove-chained-recompression
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -533,15 +533,6 @@ unexpected results when the same algorit
 priorities (e.g. different parameters).  `priority` is the only way to
 guarantee that the expected algorithm will be used.
 
-During re-compression for every page, that matches re-compression criteria,
-ZRAM iterates the list of registered alternative compression algorithms in
-order of their priorities. ZRAM stops either when re-compression was
-successful (re-compressed object is smaller in size than the original one)
-and matches re-compression criteria (e.g. size threshold) or when there are
-no secondary algorithms left to try. If none of the secondary algorithms can
-successfully re-compressed the page such a page is marked as incompressible,
-so ZRAM will not attempt to re-compress it in the future.
-
 memory tracking
 ===============
 
--- a/drivers/block/zram/zram_drv.c~zram-remove-chained-recompression
+++ a/drivers/block/zram/zram_drv.c
@@ -2336,7 +2336,7 @@ static bool highest_priority_algorithm(s
 	return true;
 }
 
-static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio_max,
+static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio,
 				     struct zram_pp_ctl *ctl)
 {
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
@@ -2362,8 +2362,8 @@ static int scan_slots_for_recompress(str
 		    test_slot_flag(zram, index, ZRAM_INCOMPRESSIBLE))
 			goto next;
 
-		/* Already compressed with same of higher priority */
-		if (get_slot_comp_priority(zram, index) + 1 >= prio_max)
+		/* Already compressed with same or higher priority */
+		if (get_slot_comp_priority(zram, index) >= prio)
 			goto next;
 
 		ok = place_pp_slot(zram, ctl, index);
@@ -2384,8 +2384,7 @@ next:
  * Corresponding ZRAM slot should be locked.
  */
 static int recompress_slot(struct zram *zram, u32 index, struct page *page,
-			   u64 *num_recomp_pages, u32 threshold, u32 prio,
-			   u32 prio_max)
+			   u64 *num_recomp_pages, u32 threshold, u32 prio)
 {
 	struct zcomp_strm *zstrm = NULL;
 	unsigned long handle_old;
@@ -2397,6 +2396,9 @@ static int recompress_slot(struct zram *
 	void *src;
 	int ret = 0;
 
+	if (!zram->comps[prio])
+		return -EINVAL;
+
 	handle_old = get_slot_handle(zram, index);
 	if (!handle_old)
 		return -EINVAL;
@@ -2419,51 +2421,10 @@ static int recompress_slot(struct zram *
 	 */
 	clear_slot_flag(zram, index, ZRAM_IDLE);
 
-	class_index_old = zs_lookup_class_index(zram->mem_pool, comp_len_old);
-
-	prio = max(prio, get_slot_comp_priority(zram, index) + 1);
-	/*
-	 * Recompression slots scan should not select slots that are
-	 * already compressed with a higher priority algorithm, but
-	 * just in case
-	 */
-	if (prio >= prio_max)
-		return 0;
-
-	/*
-	 * Iterate the secondary comp algorithms list (in order of priority)
-	 * and try to recompress the page.
-	 */
-	for (; prio < prio_max; prio++) {
-		if (!zram->comps[prio])
-			continue;
-
-		zstrm = zcomp_stream_get(zram->comps[prio]);
-		src = kmap_local_page(page);
-		ret = zcomp_compress(zram->comps[prio], zstrm,
-				     src, &comp_len_new);
-		kunmap_local(src);
-
-		if (ret) {
-			zcomp_stream_put(zstrm);
-			zstrm = NULL;
-			break;
-		}
-
-		class_index_new = zs_lookup_class_index(zram->mem_pool,
-							comp_len_new);
-
-		/* Continue until we make progress */
-		if (class_index_new >= class_index_old ||
-		    (threshold && comp_len_new >= threshold)) {
-			zcomp_stream_put(zstrm);
-			zstrm = NULL;
-			continue;
-		}
-
-		/* Recompression was successful so break out */
-		break;
-	}
+	zstrm = zcomp_stream_get(zram->comps[prio]);
+	src = kmap_local_page(page);
+	ret = zcomp_compress(zram->comps[prio], zstrm, src, &comp_len_new);
+	kunmap_local(src);
 
 	/*
 	 * Decrement the limit (if set) on pages we can recompress, even
@@ -2474,11 +2435,18 @@ static int recompress_slot(struct zram *
 	if (*num_recomp_pages)
 		*num_recomp_pages -= 1;
 
-	/* Compression error */
-	if (ret)
+	if (ret) {
+		zcomp_stream_put(zstrm);
 		return ret;
+	}
+
+	class_index_old = zs_lookup_class_index(zram->mem_pool, comp_len_old);
+	class_index_new = zs_lookup_class_index(zram->mem_pool, comp_len_new);
+
+	if (class_index_new >= class_index_old ||
+	    (threshold && comp_len_new >= threshold)) {
+		zcomp_stream_put(zstrm);
 
-	if (!zstrm) {
 		/*
 		 * Secondary algorithms failed to re-compress the page
 		 * in a way that would save memory.
@@ -2528,11 +2496,11 @@ static ssize_t recompress_store(struct d
 				struct device_attribute *attr,
 				const char *buf, size_t len)
 {
-	u32 prio = ZRAM_SECONDARY_COMP, prio_max = ZRAM_MAX_COMPS;
 	struct zram *zram = dev_to_zram(dev);
 	char *args, *param, *val, *algo = NULL;
 	u64 num_recomp_pages = ULLONG_MAX;
 	struct zram_pp_ctl *ctl = NULL;
+	u32 prio = ZRAM_SECONDARY_COMP;
 	struct zram_pp_slot *pps;
 	u32 mode = 0, threshold = 0;
 	struct page *page = NULL;
@@ -2586,8 +2554,6 @@ static ssize_t recompress_store(struct d
 			ret = kstrtouint(val, 10, &prio);
 			if (ret)
 				return ret;
-
-			prio_max = min(prio + 1, ZRAM_MAX_COMPS);
 			continue;
 		}
 	}
@@ -2607,7 +2573,6 @@ static ssize_t recompress_store(struct d
 				continue;
 
 			if (!strcmp(zram->comp_algs[prio], algo)) {
-				prio_max = min(prio + 1, ZRAM_MAX_COMPS);
 				found = true;
 				break;
 			}
@@ -2636,7 +2601,7 @@ static ssize_t recompress_store(struct d
 		goto out;
 	}
 
-	scan_slots_for_recompress(zram, mode, prio_max, ctl);
+	scan_slots_for_recompress(zram, mode, prio, ctl);
 
 	ret = len;
 	while ((pps = select_pp_slot(ctl))) {
@@ -2650,8 +2615,7 @@ static ssize_t recompress_store(struct d
 			goto next;
 
 		err = recompress_slot(zram, pps->index, page,
-				      &num_recomp_pages, threshold,
-				      prio, prio_max);
+				      &num_recomp_pages, threshold, prio);
 next:
 		slot_unlock(zram, pps->index);
 		release_pp_slot(zram, pps);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


