Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9AE33EC
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 02:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740450500; cv=none; b=KKFp6zCX6eqwZCkr+MqYacMfaU/dT643SVBZ/dOS54jjavNOcUMOhfEZGkAAFct1W9D5i7brDvbTRQ5CmTMGefDmjX/0xrPI2KDmQHfQOx/lJpddofze0+mKsEal7TnCPIcTe351eHJ3BO1ja6RR4Hze3f6lAVel9IYsDNe8BLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740450500; c=relaxed/simple;
	bh=9d/xKV6r76r1hR7esQ3h4qmc1AuKujcAueApk0efjLg=;
	h=Date:To:From:Subject:Message-Id; b=J6DSHB4jpV00J5NUXGjedfkXOOltxkDzzF/KdAamN3SQ+U5080rNUmcx9NZvJ5CxQ4M+Uqx3pd7fZTNB3YJ3puMeQJ4ibhannQcM9TCsTClusBLu8GkAnF2ZhCeoPl5idJXnYokjnFeh8nbsp7SQJrOFTEyGspJySkFQErifQpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=so7S5u65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="so7S5u65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFCEC4CED6;
	Tue, 25 Feb 2025 02:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740450500;
	bh=9d/xKV6r76r1hR7esQ3h4qmc1AuKujcAueApk0efjLg=;
	h=Date:To:From:Subject:From;
	b=so7S5u65rlVDbQfoSchXMTLObPHjCY31MGsvlprrnsOz45AUnSpNZEDAOJdJn0lHZ
	 yM0nSEGstmOjqLnkMyBc95ZjrFW1HoiHTF3qgQsbahsn++4WFC4Lrg8d8H8eUDLcl5
	 XIDp1Q/hpmrwkXnckkSqoFEsP7LUPQLCr73ip6os=
Date: Mon, 24 Feb 2025 18:28:19 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,jackmanb@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-group-fallback-functions-together.patch added to mm-unstable branch
Message-Id: <20250225022820.4AFCEC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: group fallback functions together
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-group-fallback-functions-together.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-group-fallback-functions-together.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: group fallback functions together
Date: Mon, 24 Feb 2025 19:08:26 -0500

The way the fallback rules are spread out makes them hard to follow.  Move
the functions next to each other at least.

Link: https://lkml.kernel.org/r/20250225001023.1494422-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  394 +++++++++++++++++++++++-----------------------
 1 file changed, 197 insertions(+), 197 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-group-fallback-functions-together
+++ a/mm/page_alloc.c
@@ -1903,6 +1903,43 @@ static void change_pageblock_range(struc
 	}
 }
 
+static inline bool boost_watermark(struct zone *zone)
+{
+	unsigned long max_boost;
+
+	if (!watermark_boost_factor)
+		return false;
+	/*
+	 * Don't bother in zones that are unlikely to produce results.
+	 * On small machines, including kdump capture kernels running
+	 * in a small area, boosting the watermark can cause an out of
+	 * memory situation immediately.
+	 */
+	if ((pageblock_nr_pages * 4) > zone_managed_pages(zone))
+		return false;
+
+	max_boost = mult_frac(zone->_watermark[WMARK_HIGH],
+			watermark_boost_factor, 10000);
+
+	/*
+	 * high watermark may be uninitialised if fragmentation occurs
+	 * very early in boot so do not boost. We do not fall
+	 * through and boost by pageblock_nr_pages as failing
+	 * allocations that early means that reclaim is not going
+	 * to help and it may even be impossible to reclaim the
+	 * boosted watermark resulting in a hang.
+	 */
+	if (!max_boost)
+		return false;
+
+	max_boost = max(pageblock_nr_pages, max_boost);
+
+	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
+		max_boost);
+
+	return true;
+}
+
 /*
  * When we are falling back to another migratetype during allocation, try to
  * steal extra free pages from the same pageblocks to satisfy further
@@ -1944,41 +1981,38 @@ static bool can_steal_fallback(unsigned
 	return false;
 }
 
-static inline bool boost_watermark(struct zone *zone)
+/*
+ * Check whether there is a suitable fallback freepage with requested order.
+ * If only_stealable is true, this function returns fallback_mt only if
+ * we can steal other freepages all together. This would help to reduce
+ * fragmentation due to mixed migratetype pages in one pageblock.
+ */
+int find_suitable_fallback(struct free_area *area, unsigned int order,
+			int migratetype, bool only_stealable, bool *can_steal)
 {
-	unsigned long max_boost;
+	int i;
+	int fallback_mt;
 
-	if (!watermark_boost_factor)
-		return false;
-	/*
-	 * Don't bother in zones that are unlikely to produce results.
-	 * On small machines, including kdump capture kernels running
-	 * in a small area, boosting the watermark can cause an out of
-	 * memory situation immediately.
-	 */
-	if ((pageblock_nr_pages * 4) > zone_managed_pages(zone))
-		return false;
+	if (area->nr_free == 0)
+		return -1;
 
-	max_boost = mult_frac(zone->_watermark[WMARK_HIGH],
-			watermark_boost_factor, 10000);
+	*can_steal = false;
+	for (i = 0; i < MIGRATE_PCPTYPES - 1 ; i++) {
+		fallback_mt = fallbacks[migratetype][i];
+		if (free_area_empty(area, fallback_mt))
+			continue;
 
-	/*
-	 * high watermark may be uninitialised if fragmentation occurs
-	 * very early in boot so do not boost. We do not fall
-	 * through and boost by pageblock_nr_pages as failing
-	 * allocations that early means that reclaim is not going
-	 * to help and it may even be impossible to reclaim the
-	 * boosted watermark resulting in a hang.
-	 */
-	if (!max_boost)
-		return false;
+		if (can_steal_fallback(order, migratetype))
+			*can_steal = true;
 
-	max_boost = max(pageblock_nr_pages, max_boost);
+		if (!only_stealable)
+			return fallback_mt;
 
-	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
-		max_boost);
+		if (*can_steal)
+			return fallback_mt;
+	}
 
-	return true;
+	return -1;
 }
 
 /*
@@ -2055,175 +2089,6 @@ try_to_steal_block(struct zone *zone, st
 }
 
 /*
- * Check whether there is a suitable fallback freepage with requested order.
- * If only_stealable is true, this function returns fallback_mt only if
- * we can steal other freepages all together. This would help to reduce
- * fragmentation due to mixed migratetype pages in one pageblock.
- */
-int find_suitable_fallback(struct free_area *area, unsigned int order,
-			int migratetype, bool only_stealable, bool *can_steal)
-{
-	int i;
-	int fallback_mt;
-
-	if (area->nr_free == 0)
-		return -1;
-
-	*can_steal = false;
-	for (i = 0; i < MIGRATE_PCPTYPES - 1 ; i++) {
-		fallback_mt = fallbacks[migratetype][i];
-		if (free_area_empty(area, fallback_mt))
-			continue;
-
-		if (can_steal_fallback(order, migratetype))
-			*can_steal = true;
-
-		if (!only_stealable)
-			return fallback_mt;
-
-		if (*can_steal)
-			return fallback_mt;
-	}
-
-	return -1;
-}
-
-/*
- * Reserve the pageblock(s) surrounding an allocation request for
- * exclusive use of high-order atomic allocations if there are no
- * empty page blocks that contain a page with a suitable order
- */
-static void reserve_highatomic_pageblock(struct page *page, int order,
-					 struct zone *zone)
-{
-	int mt;
-	unsigned long max_managed, flags;
-
-	/*
-	 * The number reserved as: minimum is 1 pageblock, maximum is
-	 * roughly 1% of a zone. But if 1% of a zone falls below a
-	 * pageblock size, then don't reserve any pageblocks.
-	 * Check is race-prone but harmless.
-	 */
-	if ((zone_managed_pages(zone) / 100) < pageblock_nr_pages)
-		return;
-	max_managed = ALIGN((zone_managed_pages(zone) / 100), pageblock_nr_pages);
-	if (zone->nr_reserved_highatomic >= max_managed)
-		return;
-
-	spin_lock_irqsave(&zone->lock, flags);
-
-	/* Recheck the nr_reserved_highatomic limit under the lock */
-	if (zone->nr_reserved_highatomic >= max_managed)
-		goto out_unlock;
-
-	/* Yoink! */
-	mt = get_pageblock_migratetype(page);
-	/* Only reserve normal pageblocks (i.e., they can merge with others) */
-	if (!migratetype_is_mergeable(mt))
-		goto out_unlock;
-
-	if (order < pageblock_order) {
-		if (move_freepages_block(zone, page, mt, MIGRATE_HIGHATOMIC) == -1)
-			goto out_unlock;
-		zone->nr_reserved_highatomic += pageblock_nr_pages;
-	} else {
-		change_pageblock_range(page, order, MIGRATE_HIGHATOMIC);
-		zone->nr_reserved_highatomic += 1 << order;
-	}
-
-out_unlock:
-	spin_unlock_irqrestore(&zone->lock, flags);
-}
-
-/*
- * Used when an allocation is about to fail under memory pressure. This
- * potentially hurts the reliability of high-order allocations when under
- * intense memory pressure but failed atomic allocations should be easier
- * to recover from than an OOM.
- *
- * If @force is true, try to unreserve pageblocks even though highatomic
- * pageblock is exhausted.
- */
-static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
-						bool force)
-{
-	struct zonelist *zonelist = ac->zonelist;
-	unsigned long flags;
-	struct zoneref *z;
-	struct zone *zone;
-	struct page *page;
-	int order;
-	int ret;
-
-	for_each_zone_zonelist_nodemask(zone, z, zonelist, ac->highest_zoneidx,
-								ac->nodemask) {
-		/*
-		 * Preserve at least one pageblock unless memory pressure
-		 * is really high.
-		 */
-		if (!force && zone->nr_reserved_highatomic <=
-					pageblock_nr_pages)
-			continue;
-
-		spin_lock_irqsave(&zone->lock, flags);
-		for (order = 0; order < NR_PAGE_ORDERS; order++) {
-			struct free_area *area = &(zone->free_area[order]);
-			unsigned long size;
-
-			page = get_page_from_free_area(area, MIGRATE_HIGHATOMIC);
-			if (!page)
-				continue;
-
-			/*
-			 * It should never happen but changes to
-			 * locking could inadvertently allow a per-cpu
-			 * drain to add pages to MIGRATE_HIGHATOMIC
-			 * while unreserving so be safe and watch for
-			 * underflows.
-			 */
-			size = max(pageblock_nr_pages, 1UL << order);
-			size = min(size, zone->nr_reserved_highatomic);
-			zone->nr_reserved_highatomic -= size;
-
-			/*
-			 * Convert to ac->migratetype and avoid the normal
-			 * pageblock stealing heuristics. Minimally, the caller
-			 * is doing the work and needs the pages. More
-			 * importantly, if the block was always converted to
-			 * MIGRATE_UNMOVABLE or another type then the number
-			 * of pageblocks that cannot be completely freed
-			 * may increase.
-			 */
-			if (order < pageblock_order)
-				ret = move_freepages_block(zone, page,
-							   MIGRATE_HIGHATOMIC,
-							   ac->migratetype);
-			else {
-				move_to_free_list(page, zone, order,
-						  MIGRATE_HIGHATOMIC,
-						  ac->migratetype);
-				change_pageblock_range(page, order,
-						       ac->migratetype);
-				ret = 1;
-			}
-			/*
-			 * Reserving the block(s) already succeeded,
-			 * so this should not fail on zone boundaries.
-			 */
-			WARN_ON_ONCE(ret == -1);
-			if (ret > 0) {
-				spin_unlock_irqrestore(&zone->lock, flags);
-				return ret;
-			}
-		}
-		spin_unlock_irqrestore(&zone->lock, flags);
-	}
-
-	return false;
-}
-
-/*
  * Try finding a free buddy page on the fallback list.
  *
  * This will attempt to steal a whole pageblock for the requested type
@@ -3143,6 +3008,141 @@ out:
 	return page;
 }
 
+/*
+ * Reserve the pageblock(s) surrounding an allocation request for
+ * exclusive use of high-order atomic allocations if there are no
+ * empty page blocks that contain a page with a suitable order
+ */
+static void reserve_highatomic_pageblock(struct page *page, int order,
+					 struct zone *zone)
+{
+	int mt;
+	unsigned long max_managed, flags;
+
+	/*
+	 * The number reserved as: minimum is 1 pageblock, maximum is
+	 * roughly 1% of a zone. But if 1% of a zone falls below a
+	 * pageblock size, then don't reserve any pageblocks.
+	 * Check is race-prone but harmless.
+	 */
+	if ((zone_managed_pages(zone) / 100) < pageblock_nr_pages)
+		return;
+	max_managed = ALIGN((zone_managed_pages(zone) / 100), pageblock_nr_pages);
+	if (zone->nr_reserved_highatomic >= max_managed)
+		return;
+
+	spin_lock_irqsave(&zone->lock, flags);
+
+	/* Recheck the nr_reserved_highatomic limit under the lock */
+	if (zone->nr_reserved_highatomic >= max_managed)
+		goto out_unlock;
+
+	/* Yoink! */
+	mt = get_pageblock_migratetype(page);
+	/* Only reserve normal pageblocks (i.e., they can merge with others) */
+	if (!migratetype_is_mergeable(mt))
+		goto out_unlock;
+
+	if (order < pageblock_order) {
+		if (move_freepages_block(zone, page, mt, MIGRATE_HIGHATOMIC) == -1)
+			goto out_unlock;
+		zone->nr_reserved_highatomic += pageblock_nr_pages;
+	} else {
+		change_pageblock_range(page, order, MIGRATE_HIGHATOMIC);
+		zone->nr_reserved_highatomic += 1 << order;
+	}
+
+out_unlock:
+	spin_unlock_irqrestore(&zone->lock, flags);
+}
+
+/*
+ * Used when an allocation is about to fail under memory pressure. This
+ * potentially hurts the reliability of high-order allocations when under
+ * intense memory pressure but failed atomic allocations should be easier
+ * to recover from than an OOM.
+ *
+ * If @force is true, try to unreserve pageblocks even though highatomic
+ * pageblock is exhausted.
+ */
+static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
+						bool force)
+{
+	struct zonelist *zonelist = ac->zonelist;
+	unsigned long flags;
+	struct zoneref *z;
+	struct zone *zone;
+	struct page *page;
+	int order;
+	int ret;
+
+	for_each_zone_zonelist_nodemask(zone, z, zonelist, ac->highest_zoneidx,
+								ac->nodemask) {
+		/*
+		 * Preserve at least one pageblock unless memory pressure
+		 * is really high.
+		 */
+		if (!force && zone->nr_reserved_highatomic <=
+					pageblock_nr_pages)
+			continue;
+
+		spin_lock_irqsave(&zone->lock, flags);
+		for (order = 0; order < NR_PAGE_ORDERS; order++) {
+			struct free_area *area = &(zone->free_area[order]);
+			unsigned long size;
+
+			page = get_page_from_free_area(area, MIGRATE_HIGHATOMIC);
+			if (!page)
+				continue;
+
+			/*
+			 * It should never happen but changes to
+			 * locking could inadvertently allow a per-cpu
+			 * drain to add pages to MIGRATE_HIGHATOMIC
+			 * while unreserving so be safe and watch for
+			 * underflows.
+			 */
+			size = max(pageblock_nr_pages, 1UL << order);
+			size = min(size, zone->nr_reserved_highatomic);
+			zone->nr_reserved_highatomic -= size;
+
+			/*
+			 * Convert to ac->migratetype and avoid the normal
+			 * pageblock stealing heuristics. Minimally, the caller
+			 * is doing the work and needs the pages. More
+			 * importantly, if the block was always converted to
+			 * MIGRATE_UNMOVABLE or another type then the number
+			 * of pageblocks that cannot be completely freed
+			 * may increase.
+			 */
+			if (order < pageblock_order)
+				ret = move_freepages_block(zone, page,
+							   MIGRATE_HIGHATOMIC,
+							   ac->migratetype);
+			else {
+				move_to_free_list(page, zone, order,
+						  MIGRATE_HIGHATOMIC,
+						  ac->migratetype);
+				change_pageblock_range(page, order,
+						       ac->migratetype);
+				ret = 1;
+			}
+			/*
+			 * Reserving the block(s) already succeeded,
+			 * so this should not fail on zone boundaries.
+			 */
+			WARN_ON_ONCE(ret == -1);
+			if (ret > 0) {
+				spin_unlock_irqrestore(&zone->lock, flags);
+				return ret;
+			}
+		}
+		spin_unlock_irqrestore(&zone->lock, flags);
+	}
+
+	return false;
+}
+
 static inline long __zone_watermark_unusable_free(struct zone *z,
 				unsigned int order, unsigned int alloc_flags)
 {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-unshare-v2-only-charge-api-bits-again.patch
mm-memcontrol-move-stray-ratelimit-bits-to-v1.patch
mm-memcontrol-move-memsw-charge-callbacks-to-v1.patch
mm-page_alloc-dont-steal-single-pages-from-biggest-buddy.patch
mm-page_alloc-remove-remnants-of-unlocked-migratetype-updates.patch
mm-page_alloc-group-fallback-functions-together.patch

