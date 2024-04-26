Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB4F7D08D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103961; cv=none; b=qBEA5moF/Q6pXgj4t0EwQWYQiOriBDNiozlY2zW88wQUhG7FE/GhBCo7y5fBu+rkXI7yHKkVQJ58CeLcNAzq87fppO4DdclKAOlScu5QhEgK76QR5YPK8ZxoEm1dlIKm0gaHiHf/lMrCs+12YJh7c7hu/uO2UYhHpug+Sn+I9x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103961; c=relaxed/simple;
	bh=40aDRIr85RfJ5cY5i9sP3/UzLFfxAv7cbdiMBSkB9jo=;
	h=Date:To:From:Subject:Message-Id; b=ICVy+7B4yKBB7Fv1ob2v23eQckvGEjLMmD6qCz3fuhsjKw1K+BZSHTA1Cx7wz+SId1Zp/ttMg1pNE/QCd8dIfxUoRQ2e/IJwXlt4oktiO0uEcNU7IQxw5QxTisP8jJDo/ZCx53uwDalm0ZpwE96bRQ5ai5gFiUdwb1G0xj7uDM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bSPv4Ujs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bSPv4Ujs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B78C113CD;
	Fri, 26 Apr 2024 03:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103960;
	bh=40aDRIr85RfJ5cY5i9sP3/UzLFfxAv7cbdiMBSkB9jo=;
	h=Date:To:From:Subject:From;
	b=bSPv4UjsqJy7FN/Y3K681mUiY0qTUs/WYub2zjGBPokEH7XS16oKRbgrD7i6VQpzj
	 Mn/wFGGYVnw/VH2wk6eszN+4FV+7bjOfQdQaZ3J/uLyROTBqA+SUhR4/G8ea6/uD4C
	 Y1yCUnQg36VbHYhHKb0o2Kr0zzuQYK9U1220/uMo=
Date: Thu, 25 Apr 2024 20:59:20 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,vbabka@suse.cz,mgorman@techsingularity.net,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-set-migratetype-inside-move_freepages.patch removed from -mm tree
Message-Id: <20240426035920.D7B78C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: set migratetype inside move_freepages()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-set-migratetype-inside-move_freepages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: page_alloc: set migratetype inside move_freepages()
Date: Wed, 20 Mar 2024 14:02:13 -0400

This avoids changing migratetype after move_freepages() or
move_freepages_block(), which is error prone.  It also prepares for
upcoming changes to fix move_freepages() not moving free pages partially
in the range.

Link: https://lkml.kernel.org/r/20240320180429.678181-9-hannes@cmpxchg.org
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c     |   27 +++++++++++++--------------
 mm/page_isolation.c |    7 +++----
 2 files changed, 16 insertions(+), 18 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-set-migratetype-inside-move_freepages
+++ a/mm/page_alloc.c
@@ -1586,9 +1586,8 @@ static inline struct page *__rmqueue_cma
 #endif
 
 /*
- * Move the free pages in a range to the freelist tail of the requested type.
- * Note that start_page and end_pages are not aligned on a pageblock
- * boundary. If alignment is required, use move_freepages_block()
+ * Change the type of a block and move all its free pages to that
+ * type's freelist.
  */
 static int move_freepages(struct zone *zone, unsigned long start_pfn,
 			  unsigned long end_pfn, int migratetype)
@@ -1598,6 +1597,9 @@ static int move_freepages(struct zone *z
 	unsigned int order;
 	int pages_moved = 0;
 
+	VM_WARN_ON(start_pfn & (pageblock_nr_pages - 1));
+	VM_WARN_ON(start_pfn + pageblock_nr_pages - 1 != end_pfn);
+
 	for (pfn = start_pfn; pfn <= end_pfn;) {
 		page = pfn_to_page(pfn);
 		if (!PageBuddy(page)) {
@@ -1615,6 +1617,8 @@ static int move_freepages(struct zone *z
 		pages_moved += 1 << order;
 	}
 
+	set_pageblock_migratetype(pfn_to_page(start_pfn), migratetype);
+
 	return pages_moved;
 }
 
@@ -1842,7 +1846,6 @@ steal_suitable_fallback(struct zone *zon
 	if (free_pages + alike_pages >= (1 << (pageblock_order-1)) ||
 			page_group_by_mobility_disabled) {
 		move_freepages(zone, start_pfn, end_pfn, start_type);
-		set_pageblock_migratetype(page, start_type);
 		return __rmqueue_smallest(zone, order, start_type);
 	}
 
@@ -1916,12 +1919,10 @@ static void reserve_highatomic_pageblock
 	/* Yoink! */
 	mt = get_pageblock_migratetype(page);
 	/* Only reserve normal pageblocks (i.e., they can merge with others) */
-	if (migratetype_is_mergeable(mt)) {
-		if (move_freepages_block(zone, page, MIGRATE_HIGHATOMIC) != -1) {
-			set_pageblock_migratetype(page, MIGRATE_HIGHATOMIC);
+	if (migratetype_is_mergeable(mt))
+		if (move_freepages_block(zone, page,
+					 MIGRATE_HIGHATOMIC) != -1)
 			zone->nr_reserved_highatomic += pageblock_nr_pages;
-		}
-	}
 
 out_unlock:
 	spin_unlock_irqrestore(&zone->lock, flags);
@@ -2000,7 +2001,6 @@ static bool unreserve_highatomic_pageblo
 			 * not fail on zone boundaries.
 			 */
 			WARN_ON_ONCE(ret == -1);
-			set_pageblock_migratetype(page, ac->migratetype);
 			if (ret > 0) {
 				spin_unlock_irqrestore(&zone->lock, flags);
 				return ret;
@@ -2682,10 +2682,9 @@ int __isolate_free_page(struct page *pag
 			 * Only change normal pageblocks (i.e., they can merge
 			 * with others)
 			 */
-			if (migratetype_is_mergeable(mt) &&
-			    move_freepages_block(zone, page,
-						 MIGRATE_MOVABLE) != -1)
-				set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+			if (migratetype_is_mergeable(mt))
+				move_freepages_block(zone, page,
+						     MIGRATE_MOVABLE);
 		}
 	}
 
--- a/mm/page_isolation.c~mm-page_alloc-set-migratetype-inside-move_freepages
+++ a/mm/page_isolation.c
@@ -188,7 +188,6 @@ static int set_migratetype_isolate(struc
 			return -EBUSY;
 		}
 		__mod_zone_freepage_state(zone, -nr_pages, mt);
-		set_pageblock_migratetype(page, MIGRATE_ISOLATE);
 		zone->nr_isolate_pageblock++;
 		spin_unlock_irqrestore(&zone->lock, flags);
 		return 0;
@@ -262,10 +261,10 @@ static void unset_migratetype_isolate(st
 		 */
 		WARN_ON_ONCE(nr_pages == -1);
 		__mod_zone_freepage_state(zone, nr_pages, migratetype);
-	}
-	set_pageblock_migratetype(page, migratetype);
-	if (isolated_page)
+	} else {
+		set_pageblock_migratetype(page, migratetype);
 		__putback_isolated_page(page, order, migratetype);
+	}
 	zone->nr_isolate_pageblock--;
 out:
 	spin_unlock_irqrestore(&zone->lock, flags);
_

Patches currently in -mm which might be from ziy@nvidia.com are


