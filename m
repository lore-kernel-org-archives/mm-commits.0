Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC774217F26
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188459; cv=none; b=edts4/U7KYYGYUKYFGMUcFMEsEZX6AtMUyLkn5tS9T1tZ8DnuyZnp4OKTAgjBeFlPQZ9nFqTVjonX4gaDm5QdqNNH8PS4uYhO5h6LGBglabWMlQmY3nUpNYhuoErAX5OiMaZI4M8yFYMHi11Tx7LAnU0V0CkKK1fdgJy48sqogo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188459; c=relaxed/simple;
	bh=1REIUiO+3ajeKHa7fO1vU11pLuHl7ljI/D58o7dmt2c=;
	h=Date:To:From:Subject:Message-Id; b=LTHHzn5KpN8aONYb6zmFtiCbhGLR04OfVW82lF4mhZoyZKCRgjQIj0Paf2fzYEliCpbCrN6SjOxqBhtNZN0dslIEQy4OFP7fsJr+TpEv0AEjl9bHKeFY2cv1RKKCTOg/z9xQsNufLEnwz53p2fhv9DQuU0zf5yLIEmDLnpz22TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yfgArBUw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yfgArBUw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A246DC4CEEC;
	Mon, 17 Mar 2025 05:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188459;
	bh=1REIUiO+3ajeKHa7fO1vU11pLuHl7ljI/D58o7dmt2c=;
	h=Date:To:From:Subject:From;
	b=yfgArBUwBxzgXiQq1EBP+ZqbPS+MlW3tvryZDVWqCb9ZKbjnQHQPvh5lIjuaQjDOi
	 VSdEvsJKEiUmu14me9hXRdrWhMMo2WxtE3X6ziZn96B3cquNx4i8/9YuAXYmBrIQQA
	 q3SWLl1RbhLM/sdfbewJHQhT1OuTo8btD0olbx0k=
Date: Sun, 16 Mar 2025 22:14:19 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,jackmanb@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-remnants-of-unlocked-migratetype-updates.patch removed from -mm tree
Message-Id: <20250317051419.A246DC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: remove remnants of unlocked migratetype updates
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-remnants-of-unlocked-migratetype-updates.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: remove remnants of unlocked migratetype updates
Date: Mon, 24 Feb 2025 19:08:25 -0500

The freelist hygiene patches made migratetype accesses fully protected
under the zone->lock.  Remove remnants of handling the race conditions
that existed before from the MIGRATE_HIGHATOMIC code.

Link: https://lkml.kernel.org/r/20250225001023.1494422-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   50 ++++++++++++++--------------------------------
 1 file changed, 16 insertions(+), 34 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-remnants-of-unlocked-migratetype-updates
+++ a/mm/page_alloc.c
@@ -1991,20 +1991,10 @@ static inline bool boost_watermark(struc
 static struct page *
 try_to_steal_block(struct zone *zone, struct page *page,
 		   int current_order, int order, int start_type,
-		   unsigned int alloc_flags)
+		   int block_type, unsigned int alloc_flags)
 {
 	int free_pages, movable_pages, alike_pages;
 	unsigned long start_pfn;
-	int block_type;
-
-	block_type = get_pageblock_migratetype(page);
-
-	/*
-	 * This can happen due to races and we want to prevent broken
-	 * highatomic accounting.
-	 */
-	if (is_migrate_highatomic(block_type))
-		return NULL;
 
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order) {
@@ -2179,33 +2169,22 @@ static bool unreserve_highatomic_pageblo
 		spin_lock_irqsave(&zone->lock, flags);
 		for (order = 0; order < NR_PAGE_ORDERS; order++) {
 			struct free_area *area = &(zone->free_area[order]);
-			int mt;
+			unsigned long size;
 
 			page = get_page_from_free_area(area, MIGRATE_HIGHATOMIC);
 			if (!page)
 				continue;
 
-			mt = get_pageblock_migratetype(page);
 			/*
-			 * In page freeing path, migratetype change is racy so
-			 * we can counter several free pages in a pageblock
-			 * in this loop although we changed the pageblock type
-			 * from highatomic to ac->migratetype. So we should
-			 * adjust the count once.
+			 * It should never happen but changes to
+			 * locking could inadvertently allow a per-cpu
+			 * drain to add pages to MIGRATE_HIGHATOMIC
+			 * while unreserving so be safe and watch for
+			 * underflows.
 			 */
-			if (is_migrate_highatomic(mt)) {
-				unsigned long size;
-				/*
-				 * It should never happen but changes to
-				 * locking could inadvertently allow a per-cpu
-				 * drain to add pages to MIGRATE_HIGHATOMIC
-				 * while unreserving so be safe and watch for
-				 * underflows.
-				 */
-				size = max(pageblock_nr_pages, 1UL << order);
-				size = min(size, zone->nr_reserved_highatomic);
-				zone->nr_reserved_highatomic -= size;
-			}
+			size = max(pageblock_nr_pages, 1UL << order);
+			size = min(size, zone->nr_reserved_highatomic);
+			zone->nr_reserved_highatomic -= size;
 
 			/*
 			 * Convert to ac->migratetype and avoid the normal
@@ -2217,10 +2196,12 @@ static bool unreserve_highatomic_pageblo
 			 * may increase.
 			 */
 			if (order < pageblock_order)
-				ret = move_freepages_block(zone, page, mt,
+				ret = move_freepages_block(zone, page,
+							   MIGRATE_HIGHATOMIC,
 							   ac->migratetype);
 			else {
-				move_to_free_list(page, zone, order, mt,
+				move_to_free_list(page, zone, order,
+						  MIGRATE_HIGHATOMIC,
 						  ac->migratetype);
 				change_pageblock_range(page, order,
 						       ac->migratetype);
@@ -2294,7 +2275,8 @@ __rmqueue_fallback(struct zone *zone, in
 
 		page = get_page_from_free_area(area, fallback_mt);
 		page = try_to_steal_block(zone, page, current_order, order,
-					  start_migratetype, alloc_flags);
+					  start_migratetype, fallback_mt,
+					  alloc_flags);
 		if (page)
 			goto got_one;
 	}
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-swap_cgroup-remove-double-initialization-of-locals.patch
mm-compaction-push-watermark-into-compaction_suitable-callers.patch
mm-page_alloc-trace-type-pollution-from-compaction-capturing.patch
mm-page_alloc-defrag_mode.patch
mm-page_alloc-defrag_mode-kswapd-kcompactd-assistance.patch
mm-page_alloc-defrag_mode-kswapd-kcompactd-watermarks.patch
mm-page_alloc-defrag_mode-kswapd-kcompactd-watermarks-fix.patch

