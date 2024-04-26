Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCE32F36
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101560; cv=none; b=SSQ/l85DbJna0q7Wk/jZFDgZZSipCIujmOW1TFjWp+HswLtPslaQydKrEHrErKAid2yilspiG7ZVCiZrCAaqqtwufIIT4UR6q6JIHJZts3dkwnQrN7rUuSN2o8HZYQj3Y/Va8p5c6V7NEFJ9dXqNP1+M1V08JZaG+7drXccoZNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101560; c=relaxed/simple;
	bh=puipuRgFVUiAgOsMOebY5447KWPA5RGj+J7WW1QOFvs=;
	h=Date:To:From:Subject:Message-Id; b=DolBSSs70u7qGEkWc7jcQVdGIqmyFV/PiaR15sOfXGDpRp008hF52tprJVRoHtt411XC9BsQ5+TlOxtnWUPpsGiwNRo8PvHjXUK5Dg4LD4CoSURtrx54TJBuM2R0FzSsz6p0whaUtwianNAEvalAQxm98Zy0CXD27O3eCH9IJQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e7hjMK4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e7hjMK4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F3CC113CD;
	Fri, 26 Apr 2024 03:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101559;
	bh=puipuRgFVUiAgOsMOebY5447KWPA5RGj+J7WW1QOFvs=;
	h=Date:To:From:Subject:From;
	b=e7hjMK4UTBF27mjepRwB2loT8bVyJ/197qjRuyOYw0eYk5Hzqny7zAlC6jLP/EgCI
	 l/bPsuZfjD6MvzNhaD2IoWxgGV/xLpvJ95w1hpAJDdNTewOERoM9UoMU2YWcX8Ez78
	 5QmpngKCqULFH8sAbb++zJiQrD9BJf7Q0SmvaD0Q=
Date: Thu, 25 Apr 2024 20:19:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,vbabka@suse.cz,mgorman@techsingularity.net,david@redhat.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-consolidate-free-page-accounting-fix-2.patch removed from -mm tree
Message-Id: <20240426031919.79F3CC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: consolidate free page accounting fix 2
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-consolidate-free-page-accounting-fix-2.patch

This patch was dropped because it was folded into mm-page_alloc-consolidate-free-page-accounting.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: consolidate free page accounting fix 2
Date: Wed, 27 Mar 2024 12:28:41 -0400

remove unused page parameter from account_freepages()

Link: https://lkml.kernel.org/r/20240327185831.GB7597@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-consolidate-free-page-accounting-fix-2
+++ a/mm/page_alloc.c
@@ -643,8 +643,8 @@ compaction_capture(struct capture_contro
 }
 #endif /* CONFIG_COMPACTION */
 
-static inline void account_freepages(struct page *page, struct zone *zone,
-				     int nr_pages, int migratetype)
+static inline void account_freepages(struct zone *zone, int nr_pages,
+				     int migratetype)
 {
 	if (is_migrate_isolate(migratetype))
 		return;
@@ -678,7 +678,7 @@ static inline void add_to_free_list(stru
 				    bool tail)
 {
 	__add_to_free_list(page, zone, order, migratetype, tail);
-	account_freepages(page, zone, 1 << order, migratetype);
+	account_freepages(zone, 1 << order, migratetype);
 }
 
 /*
@@ -698,8 +698,8 @@ static inline void move_to_free_list(str
 
 	list_move_tail(&page->buddy_list, &area->free_list[new_mt]);
 
-	account_freepages(page, zone, -(1 << order), old_mt);
-	account_freepages(page, zone, 1 << order, new_mt);
+	account_freepages(zone, -(1 << order), old_mt);
+	account_freepages(zone, 1 << order, new_mt);
 }
 
 static inline void __del_page_from_free_list(struct page *page, struct zone *zone,
@@ -723,7 +723,7 @@ static inline void del_page_from_free_li
 					   unsigned int order, int migratetype)
 {
 	__del_page_from_free_list(page, zone, order, migratetype);
-	account_freepages(page, zone, -(1 << order), migratetype);
+	account_freepages(zone, -(1 << order), migratetype);
 }
 
 static inline struct page *get_page_from_free_area(struct free_area *area,
@@ -800,7 +800,7 @@ static inline void __free_one_page(struc
 	VM_BUG_ON_PAGE(pfn & ((1 << order) - 1), page);
 	VM_BUG_ON_PAGE(bad_range(zone, page), page);
 
-	account_freepages(page, zone, 1 << order, migratetype);
+	account_freepages(zone, 1 << order, migratetype);
 
 	while (order < MAX_PAGE_ORDER) {
 		int buddy_mt = migratetype;
@@ -6931,7 +6931,7 @@ static bool try_to_accept_memory_one(str
 	list_del(&page->lru);
 	last = list_empty(&zone->unaccepted_pages);
 
-	account_freepages(page, zone, -MAX_ORDER_NR_PAGES, MIGRATE_MOVABLE);
+	account_freepages(zone, -MAX_ORDER_NR_PAGES, MIGRATE_MOVABLE);
 	__mod_zone_page_state(zone, NR_UNACCEPTED, -MAX_ORDER_NR_PAGES);
 	spin_unlock_irqrestore(&zone->lock, flags);
 
@@ -6983,7 +6983,7 @@ static bool __free_unaccepted(struct pag
 	spin_lock_irqsave(&zone->lock, flags);
 	first = list_empty(&zone->unaccepted_pages);
 	list_add_tail(&page->lru, &zone->unaccepted_pages);
-	account_freepages(page, zone, MAX_ORDER_NR_PAGES, MIGRATE_MOVABLE);
+	account_freepages(zone, MAX_ORDER_NR_PAGES, MIGRATE_MOVABLE);
 	__mod_zone_page_state(zone, NR_UNACCEPTED, MAX_ORDER_NR_PAGES);
 	spin_unlock_irqrestore(&zone->lock, flags);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-zswap-optimize-zswap-pool-size-tracking.patch
mm-zpool-return-pool-size-in-pages.patch
mm-page_alloc-remove-pcppage-migratetype-caching.patch
mm-page_alloc-optimize-free_unref_folios.patch
mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks.patch
mm-page_alloc-move-free-pages-when-converting-block-during-isolation.patch
mm-page_alloc-fix-move_freepages_block-range-error.patch
mm-page_alloc-fix-freelist-movement-during-block-conversion.patch
mm-page_alloc-close-migratetype-race-between-freeing-and-stealing.patch
mm-page_isolation-prepare-for-hygienic-freelists.patch
mm-page_alloc-consolidate-free-page-accounting.patch
mm-page_alloc-batch-vmstat-updates-in-expand.patch

