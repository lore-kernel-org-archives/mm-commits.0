Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4878779F5
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 04:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741062711; cv=none; b=GXSmzUi4hBO0sAxkCetGM0SDpYi6LlBAIS42sr3Z3g+fZ2qXC4PeskGZXP0XvjlmRdmIYOpPsW2AOpbwGHMASFGH6jHFbE46nx/YbFhLPX0XlLxus1yV9/rvcRYkU3Qh0K0FzUgZaTeb+oUcM6/xlVou07OWrqjCTGl1OWHPCyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741062711; c=relaxed/simple;
	bh=1U8b/SUHfiBVVLZ5u+0DWE4XYTBPUrpOS5HGrQKmFBY=;
	h=Date:To:From:Subject:Message-Id; b=ROanjhsB4G2dPPeyCABgc2yUoL6bCggK5uLTTPD6rRM5/fozK5mdfwUrShnXRj5fTAUG+deg1RdtZpe+4BJycsKchMRAZ6+Jc9nM5T4W2ZneGRnj8hWyDO3tAdCRDt3D+pFJnKagFb4Q3ye1ZX21xBh82ZqSO65zHbTTrGoTNgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rtWsByjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rtWsByjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C30C4CEE5;
	Tue,  4 Mar 2025 04:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741062710;
	bh=1U8b/SUHfiBVVLZ5u+0DWE4XYTBPUrpOS5HGrQKmFBY=;
	h=Date:To:From:Subject:From;
	b=rtWsByjNTCVtHUh8gsDmikMW/4olsDIiqQ1/Ra45+bAdReuPO15vByf+gB/oFTB90
	 I599pfRU4PpxrAqx1PixDWDTYZuCnUPOL+jBaKmYPCVn38MbvC5/KQw9hXZnYEnv9q
	 DiVpxbH7mAnNiEeWm3RjJXiRK4haAuw2tG69DEBA=
Date: Mon, 03 Mar 2025 20:31:49 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,vbabka@suse.cz,mhocko@kernel.org,mgorman@techsingularity.net,hannes@cmpxchg.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-clarify-terminology-in-migratetype-fallback-code.patch added to mm-unstable branch
Message-Id: <20250304043150.A3C30C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: clarify terminology in migratetype fallback code
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-clarify-terminology-in-migratetype-fallback-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-clarify-terminology-in-migratetype-fallback-code.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: clarify terminology in migratetype fallback code
Date: Fri, 28 Feb 2025 09:52:17 +0000

Patch series "mm/page_alloc: Some clarifications for migratetype
fallback", v4.

A couple of patches to try and make the code easier to follow.


This patch (of 2):

This code is rather confusing because:

 1. "Steal" is sometimes used to refer to the general concept of
    allocating from a from a block of a fallback migratetype
    (steal_suitable_fallback()) but sometimes it refers specifically to
    converting a whole block's migratetype (can_steal_fallback()).

 2. can_steal_fallback() sounds as though it's answering the question "am
    I functionally permitted to allocate from that other type" but in
    fact it is encoding a heuristic preference.

 3. The same piece of data has different names in different places:
    can_steal vs whole_block. This reinforces point 2 because it looks
    like the different names reflect a shift in intent from "am I
    allowed to steal" to "do I want to steal", but no such shift exists.

Fix 1. by avoiding the term "steal" in ambiguous contexts. Start using
the term "claim" to refer to the special case of stealing the entire
block.

Fix 2. by using "should" instead of "can", and also rename its
parameters and add some commentary to make it more explicit what they
mean.

Fix 3. by adopting the new "claim" terminology universally for this
set of variables.

Link: https://lkml.kernel.org/r/20250228-clarify-steal-v4-0-cb2ef1a4e610@google.com
Link: https://lkml.kernel.org/r/20250228-clarify-steal-v4-1-cb2ef1a4e610@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 +-
 mm/internal.h   |    2 -
 mm/page_alloc.c |   72 +++++++++++++++++++++++-----------------------
 3 files changed, 39 insertions(+), 39 deletions(-)

--- a/mm/compaction.c~mm-page_alloc-clarify-terminology-in-migratetype-fallback-code
+++ a/mm/compaction.c
@@ -2333,7 +2333,7 @@ static enum compact_result __compact_fin
 	ret = COMPACT_NO_SUITABLE_PAGE;
 	for (order = cc->order; order < NR_PAGE_ORDERS; order++) {
 		struct free_area *area = &cc->zone->free_area[order];
-		bool can_steal;
+		bool claim_block;
 
 		/* Job done if page is free of the right migratetype */
 		if (!free_area_empty(area, migratetype))
@@ -2350,7 +2350,7 @@ static enum compact_result __compact_fin
 		 * other migratetype buddy lists.
 		 */
 		if (find_suitable_fallback(area, order, migratetype,
-						true, &can_steal) != -1)
+						true, &claim_block) != -1)
 			/*
 			 * Movable pages are OK in any pageblock. If we are
 			 * stealing for a non-movable allocation, make sure
--- a/mm/internal.h~mm-page_alloc-clarify-terminology-in-migratetype-fallback-code
+++ a/mm/internal.h
@@ -917,7 +917,7 @@ static inline void init_cma_pageblock(st
 
 
 int find_suitable_fallback(struct free_area *area, unsigned int order,
-			int migratetype, bool only_stealable, bool *can_steal);
+			int migratetype, bool claim_only, bool *claim_block);
 
 static inline bool free_area_empty(struct free_area *area, int migratetype)
 {
--- a/mm/page_alloc.c~mm-page_alloc-clarify-terminology-in-migratetype-fallback-code
+++ a/mm/page_alloc.c
@@ -1974,22 +1974,22 @@ static inline bool boost_watermark(struc
 
 /*
  * When we are falling back to another migratetype during allocation, try to
- * steal extra free pages from the same pageblocks to satisfy further
- * allocations, instead of polluting multiple pageblocks.
+ * claim entire blocks to satisfy further allocations, instead of polluting
+ * multiple pageblocks.
  *
- * If we are stealing a relatively large buddy page, it is likely there will
- * be more free pages in the pageblock, so try to steal them all. For
- * reclaimable and unmovable allocations, we steal regardless of page size,
- * as fragmentation caused by those allocations polluting movable pageblocks
- * is worse than movable allocations stealing from unmovable and reclaimable
- * pageblocks.
+ * If we are stealing a relatively large buddy page, it is likely there will be
+ * more free pages in the pageblock, so try to claim the whole block. For
+ * reclaimable and unmovable allocations, we try to claim the whole block
+ * regardless of page size, as fragmentation caused by those allocations
+ * polluting movable pageblocks is worse than movable allocations stealing from
+ * unmovable and reclaimable pageblocks.
  */
-static bool can_steal_fallback(unsigned int order, int start_mt)
+static bool should_try_claim_block(unsigned int order, int start_mt)
 {
 	/*
 	 * Leaving this order check is intended, although there is
 	 * relaxed order check in next check. The reason is that
-	 * we can actually steal whole pageblock if this condition met,
+	 * we can actually claim the whole pageblock if this condition met,
 	 * but, below check doesn't guarantee it and that is just heuristic
 	 * so could be changed anytime.
 	 */
@@ -2002,7 +2002,7 @@ static bool can_steal_fallback(unsigned
 	 * reclaimable pages that are closest to the request size.  After a
 	 * while, memory compaction may occur to form large contiguous pages,
 	 * and the next movable allocation may not need to steal.  Unmovable and
-	 * reclaimable allocations need to actually steal pages.
+	 * reclaimable allocations need to actually claim the whole block.
 	 */
 	if (order >= pageblock_order / 2 ||
 		start_mt == MIGRATE_RECLAIMABLE ||
@@ -2015,12 +2015,14 @@ static bool can_steal_fallback(unsigned
 
 /*
  * Check whether there is a suitable fallback freepage with requested order.
- * If only_stealable is true, this function returns fallback_mt only if
- * we can steal other freepages all together. This would help to reduce
+ * Sets *claim_block to instruct the caller whether it should convert a whole
+ * pageblock to the returned migratetype.
+ * If only_claim is true, this function returns fallback_mt only if
+ * we would do this whole-block claiming. This would help to reduce
  * fragmentation due to mixed migratetype pages in one pageblock.
  */
 int find_suitable_fallback(struct free_area *area, unsigned int order,
-			int migratetype, bool only_stealable, bool *can_steal)
+			int migratetype, bool only_claim, bool *claim_block)
 {
 	int i;
 	int fallback_mt;
@@ -2028,19 +2030,16 @@ int find_suitable_fallback(struct free_a
 	if (area->nr_free == 0)
 		return -1;
 
-	*can_steal = false;
+	*claim_block = false;
 	for (i = 0; i < MIGRATE_PCPTYPES - 1 ; i++) {
 		fallback_mt = fallbacks[migratetype][i];
 		if (free_area_empty(area, fallback_mt))
 			continue;
 
-		if (can_steal_fallback(order, migratetype))
-			*can_steal = true;
+		if (should_try_claim_block(order, migratetype))
+			*claim_block = true;
 
-		if (!only_stealable)
-			return fallback_mt;
-
-		if (*can_steal)
+		if (*claim_block || !only_claim)
 			return fallback_mt;
 	}
 
@@ -2048,14 +2047,14 @@ int find_suitable_fallback(struct free_a
 }
 
 /*
- * This function implements actual steal behaviour. If order is large enough, we
- * can claim the whole pageblock for the requested migratetype. If not, we check
- * the pageblock for constituent pages; if at least half of the pages are free
- * or compatible, we can still claim the whole block, so pages freed in the
- * future will be put on the correct free list.
+ * This function implements actual block claiming behaviour. If order is large
+ * enough, we can claim the whole pageblock for the requested migratetype. If
+ * not, we check the pageblock for constituent pages; if at least half of the
+ * pages are free or compatible, we can still claim the whole block, so pages
+ * freed in the future will be put on the correct free list.
  */
 static struct page *
-try_to_steal_block(struct zone *zone, struct page *page,
+try_to_claim_block(struct zone *zone, struct page *page,
 		   int current_order, int order, int start_type,
 		   int block_type, unsigned int alloc_flags)
 {
@@ -2123,11 +2122,12 @@ try_to_steal_block(struct zone *zone, st
 /*
  * Try finding a free buddy page on the fallback list.
  *
- * This will attempt to steal a whole pageblock for the requested type
+ * This will attempt to claim a whole pageblock for the requested type
  * to ensure grouping of such requests in the future.
  *
- * If a whole block cannot be stolen, regress to __rmqueue_smallest()
- * logic to at least break up as little contiguity as possible.
+ * If a whole block cannot be claimed, steal an individual page, regressing to
+ * __rmqueue_smallest() logic to at least break up as little contiguity as
+ * possible.
  *
  * The use of signed ints for order and current_order is a deliberate
  * deviation from the rest of this file, to make the for loop
@@ -2144,7 +2144,7 @@ __rmqueue_fallback(struct zone *zone, in
 	int min_order = order;
 	struct page *page;
 	int fallback_mt;
-	bool can_steal;
+	bool claim_block;
 
 	/*
 	 * Do not steal pages from freelists belonging to other pageblocks
@@ -2163,15 +2163,15 @@ __rmqueue_fallback(struct zone *zone, in
 				--current_order) {
 		area = &(zone->free_area[current_order]);
 		fallback_mt = find_suitable_fallback(area, current_order,
-				start_migratetype, false, &can_steal);
+				start_migratetype, false, &claim_block);
 		if (fallback_mt == -1)
 			continue;
 
-		if (!can_steal)
+		if (!claim_block)
 			break;
 
 		page = get_page_from_free_area(area, fallback_mt);
-		page = try_to_steal_block(zone, page, current_order, order,
+		page = try_to_claim_block(zone, page, current_order, order,
 					  start_migratetype, fallback_mt,
 					  alloc_flags);
 		if (page)
@@ -2181,11 +2181,11 @@ __rmqueue_fallback(struct zone *zone, in
 	if (alloc_flags & ALLOC_NOFRAGMENT)
 		return NULL;
 
-	/* No luck stealing blocks. Find the smallest fallback page */
+	/* No luck claiming pageblock. Find the smallest fallback page */
 	for (current_order = order; current_order < NR_PAGE_ORDERS; current_order++) {
 		area = &(zone->free_area[current_order]);
 		fallback_mt = find_suitable_fallback(area, current_order,
-				start_migratetype, false, &can_steal);
+				start_migratetype, false, &claim_block);
 		if (fallback_mt == -1)
 			continue;
 
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-mmu_gather-update-comment-on-rcu-freeing.patch
selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch
selftests-mm-fix-assumption-that-sudo-is-present.patch
selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch
selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch
selftests-mm-uffd-rename-nr_cpus-nr_threads.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch
selftests-mm-skip-map_populate-on-weird-filesystems.patch
selftests-mm-skip-gup_longerm-tests-on-weird-filesystems.patch
mm-page_alloc-warn-on-nr_reserved_highatomic-underflow.patch
mm-page_alloc-clarify-terminology-in-migratetype-fallback-code.patch
mm-page_alloc-clarify-should_claim_block-commentary.patch
scripts-gdb-add-lx_per_cpu_ptr.patch

