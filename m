Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D0C2D060B
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 20:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772309070; cv=none; b=nHNfXv+bCStVHNYpLw3Gje/Yh8Ea0cm47gQBN1BFtfe520dWR5zsf1NtuwRwxA8OyjisKOpc/EOkgWuW41vqNIkeYTB/2ZPyxVGUfRMoOfAo55kN17er/aC3lTmzZnFWvgHBiC6mCYOct3boJV7TfCNogOdx9oxW3olgMha4sjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772309070; c=relaxed/simple;
	bh=9+bCAlYqtvHmhM6pLePdAPn1iWfeOk2nxq2nxxYOP6c=;
	h=Date:To:From:Subject:Message-Id; b=Su3YQWWCzD/OXHmAOfFBxpASjqLrt8xTYFyyiH75wm3HWDp0ha6yEAZ71r/j6L/4/H8SIRnb/ABMkr+AMMp2Hx9LMwbYKKCF7nW+wFK0NAdObAMLO+st7K8tZz47SpH3kXrM7iG6elk0ozZ4LMk/7CoEvGIN56QhPsTwL/K6x7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lUDQ93+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lUDQ93+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6379C116D0;
	Sat, 28 Feb 2026 20:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772309069;
	bh=9+bCAlYqtvHmhM6pLePdAPn1iWfeOk2nxq2nxxYOP6c=;
	h=Date:To:From:Subject:From;
	b=lUDQ93+YT38lxC3QYYvHw83kmyhIq1FO3foIUHtFhI8q/TzFumUXfQwh42uM0Aem+
	 Ayk928dxfIN+1vzsnQDsnbZzn0Be/5x9fzbvr9gOFDoQGehujZJEXV+m/8o3HZReNj
	 kAo0kaIda1qTTjYLyr95vOq+kvcaZQL6QsApkmQo=
Date: Sat, 28 Feb 2026 12:04:29 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,philipp.reisner@linbit.com,minchan@kernel.org,lars.ellenberg@linbit.com,corbet@lwn.net,christoph.boehmwalder@linbit.com,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-remove-chained-recompression.patch added to mm-new branch
Message-Id: <20260228200429.C6379C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: remove chained recompression
has been added to the -mm mm-new branch.  Its filename is
     zram-remove-chained-recompression.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-remove-chained-recompression.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: remove chained recompression
Date: Fri, 27 Feb 2026 17:21:11 +0900

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

Link: https://lkml.kernel.org/r/cf100b13afb62641d7f3bc10fd77068833f56af0.1772180459.git.senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: "Christoph Böhmwalder" <christoph.boehmwalder@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |    9 -
 drivers/block/zram/zram_drv.c               |   83 +++++-------------
 2 files changed, 24 insertions(+), 68 deletions(-)

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
@@ -2331,7 +2331,7 @@ static int zram_bvec_write(struct zram *
 #define RECOMPRESS_IDLE		(1 << 0)
 #define RECOMPRESS_HUGE		(1 << 1)
 
-static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio_max,
+static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio,
 				     struct zram_pp_ctl *ctl)
 {
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
@@ -2357,8 +2357,8 @@ static int scan_slots_for_recompress(str
 		    test_slot_flag(zram, index, ZRAM_INCOMPRESSIBLE))
 			goto next;
 
-		/* Already compressed with same of higher priority */
-		if (get_slot_comp_priority(zram, index) + 1 >= prio_max)
+		/* Already compressed with same or higher priority */
+		if (get_slot_comp_priority(zram, index) >= prio)
 			goto next;
 
 		ok = place_pp_slot(zram, ctl, index);
@@ -2391,8 +2391,7 @@ static bool highest_priority_algorithm(s
  * Corresponding ZRAM slot should be locked.
  */
 static int recompress_slot(struct zram *zram, u32 index, struct page *page,
-			   u64 *num_recomp_pages, u32 threshold, u32 prio,
-			   u32 prio_max)
+			   u64 *num_recomp_pages, u32 threshold, u32 prio)
 {
 	struct zcomp_strm *zstrm = NULL;
 	unsigned long handle_old;
@@ -2404,6 +2403,9 @@ static int recompress_slot(struct zram *
 	void *src;
 	int ret = 0;
 
+	if (!zram->comps[prio])
+		return -EINVAL;
+
 	handle_old = get_slot_handle(zram, index);
 	if (!handle_old)
 		return -EINVAL;
@@ -2426,51 +2428,10 @@ static int recompress_slot(struct zram *
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
@@ -2481,11 +2442,18 @@ static int recompress_slot(struct zram *
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
@@ -2535,11 +2503,11 @@ static ssize_t recompress_store(struct d
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
@@ -2604,7 +2572,6 @@ static ssize_t recompress_store(struct d
 			 * "algorithm" name lookup is ambiguous.
 			 */
 			algo = NULL;
-			prio_max = min(prio + 1, ZRAM_MAX_COMPS);
 			continue;
 		}
 	}
@@ -2624,7 +2591,6 @@ static ssize_t recompress_store(struct d
 				continue;
 
 			if (!strcmp(zram->comp_algs[prio], algo)) {
-				prio_max = min(prio + 1, ZRAM_MAX_COMPS);
 				found = true;
 				break;
 			}
@@ -2653,7 +2619,7 @@ static ssize_t recompress_store(struct d
 		goto out;
 	}
 
-	scan_slots_for_recompress(zram, mode, prio_max, ctl);
+	scan_slots_for_recompress(zram, mode, prio, ctl);
 
 	ret = len;
 	while ((pps = select_pp_slot(ctl))) {
@@ -2667,8 +2633,7 @@ static ssize_t recompress_store(struct d
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

zram-rename-writeback_compressed-device-attr.patch
zram-do-not-autocorrect-bad-recompression-parameters.patch
zram-drop-num_active_comps.patch
zram-recompression-priority-param-should-override-algo.patch
zram-update-recompression-documentation.patch
zram-remove-chained-recompression.patch

