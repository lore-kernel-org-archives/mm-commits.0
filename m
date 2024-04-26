Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C1E7604D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103960; cv=none; b=dk5LFd1ZNbdpDOzp4ZOhPP4GhllBT02daCa+IdVG2NXf61vX5hkQfHaeHoiI1tjVSX5iiyZx9Nte1wZZgfEehVSWPosEbuy6RLfszRcMFPma8bGrpZniO4Npr+h6iC/huiiboi4RLrvAOicadVZelYCJ9LndyAO8tnTADHEDXAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103960; c=relaxed/simple;
	bh=SgaeiD9nbc102/e0oLPo82xjV/p09maGX4mObrX0qC8=;
	h=Date:To:From:Subject:Message-Id; b=llk+X+OClWgVtM/Zbw8yNegbDW5oxiklt2vuMvI2YxOlzNOk6LArcWi6VYosjaskzeGZWu7CseZwMeOWubDw/KZvviJI3f007shZngezpq16VWVdx15qOxc2iVI1ZqyjbgBvFnOZUJ/UB9IomOJMYIO0ahlVK9+PJTXVHyeTwjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=weFbqmCL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="weFbqmCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC46C113CD;
	Fri, 26 Apr 2024 03:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103959;
	bh=SgaeiD9nbc102/e0oLPo82xjV/p09maGX4mObrX0qC8=;
	h=Date:To:From:Subject:From;
	b=weFbqmCLJT6R6jdCLJLlxFEUxkg16di9rGigmu/OC8D6h809XHGBwNqyP8F/lu6Q1
	 JGwNuWxO/INKGVx5agp1uUaXtwt0ZqmIFT7UXG9aBg50XV1hX1FjctPslwTO5zclpJ
	 wqVrfp579DfPygUB70JhLsuUfLL9+X26eriSX/5Y=
Date: Thu, 25 Apr 2024 20:59:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,vbabka@suse.cz,mgorman@techsingularity.net,david@redhat.com,baolin.wang@linux.alibaba.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-close-migratetype-race-between-freeing-and-stealing.patch removed from -mm tree
Message-Id: <20240426035919.CAC46C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: close migratetype race between freeing and stealing
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-close-migratetype-race-between-freeing-and-stealing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: close migratetype race between freeing and stealing
Date: Wed, 20 Mar 2024 14:02:12 -0400

There are three freeing paths that read the page's migratetype
optimistically before grabbing the zone lock.  When this races with block
stealing, those pages go on the wrong freelist.

The paths in question are:
- when freeing >costly orders that aren't THP
- when freeing pages to the buddy upon pcp lock contention
- when freeing pages that are isolated
- when freeing pages initially during boot
- when freeing the remainder in alloc_pages_exact()
- when "accepting" unaccepted VM host memory before first use
- when freeing pages during unpoisoning

None of these are so hot that they would need this optimization at the
cost of hampering defrag efforts.  Especially when contrasted with the
fact that the most common buddy freeing path - free_pcppages_bulk - is
checking the migratetype under the zone->lock just fine.

In addition, isolated pages need to look up the migratetype under the lock
anyway, which adds branches to the locked section, and results in a double
lookup when the pages are in fact isolated.

Move the lookups into the lock.

Link: https://lkml.kernel.org/r/20240320180429.678181-8-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   52 ++++++++++++++++------------------------------
 1 file changed, 19 insertions(+), 33 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-close-migratetype-race-between-freeing-and-stealing
+++ a/mm/page_alloc.c
@@ -1231,18 +1231,15 @@ static void free_pcppages_bulk(struct zo
 	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
-static void free_one_page(struct zone *zone,
-				struct page *page, unsigned long pfn,
-				unsigned int order,
-				int migratetype, fpi_t fpi_flags)
+static void free_one_page(struct zone *zone, struct page *page,
+			  unsigned long pfn, unsigned int order,
+			  fpi_t fpi_flags)
 {
 	unsigned long flags;
+	int migratetype;
 
 	spin_lock_irqsave(&zone->lock, flags);
-	if (unlikely(has_isolate_pageblock(zone) ||
-		is_migrate_isolate(migratetype))) {
-		migratetype = get_pfnblock_migratetype(page, pfn);
-	}
+	migratetype = get_pfnblock_migratetype(page, pfn);
 	__free_one_page(page, pfn, zone, order, migratetype, fpi_flags);
 	spin_unlock_irqrestore(&zone->lock, flags);
 }
@@ -1250,21 +1247,13 @@ static void free_one_page(struct zone *z
 static void __free_pages_ok(struct page *page, unsigned int order,
 			    fpi_t fpi_flags)
 {
-	int migratetype;
 	unsigned long pfn = page_to_pfn(page);
 	struct zone *zone = page_zone(page);
 
 	if (!free_pages_prepare(page, order))
 		return;
 
-	/*
-	 * Calling get_pfnblock_migratetype() without spin_lock_irqsave() here
-	 * is used to avoid calling get_pfnblock_migratetype() under the lock.
-	 * This will reduce the lock holding time.
-	 */
-	migratetype = get_pfnblock_migratetype(page, pfn);
-
-	free_one_page(zone, page, pfn, order, migratetype, fpi_flags);
+	free_one_page(zone, page, pfn, order, fpi_flags);
 
 	__count_vm_events(PGFREE, 1 << order);
 }
@@ -2503,7 +2492,7 @@ void free_unref_page(struct page *page,
 	struct per_cpu_pages *pcp;
 	struct zone *zone;
 	unsigned long pfn = page_to_pfn(page);
-	int migratetype, pcpmigratetype;
+	int migratetype;
 
 	if (!free_pages_prepare(page, order))
 		return;
@@ -2515,23 +2504,23 @@ void free_unref_page(struct page *page,
 	 * get those areas back if necessary. Otherwise, we may have to free
 	 * excessively into the page allocator
 	 */
-	migratetype = pcpmigratetype = get_pfnblock_migratetype(page, pfn);
+	migratetype = get_pfnblock_migratetype(page, pfn);
 	if (unlikely(migratetype >= MIGRATE_PCPTYPES)) {
 		if (unlikely(is_migrate_isolate(migratetype))) {
-			free_one_page(page_zone(page), page, pfn, order, migratetype, FPI_NONE);
+			free_one_page(page_zone(page), page, pfn, order, FPI_NONE);
 			return;
 		}
-		pcpmigratetype = MIGRATE_MOVABLE;
+		migratetype = MIGRATE_MOVABLE;
 	}
 
 	zone = page_zone(page);
 	pcp_trylock_prepare(UP_flags);
 	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (pcp) {
-		free_unref_page_commit(zone, pcp, page, pcpmigratetype, order);
+		free_unref_page_commit(zone, pcp, page, migratetype, order);
 		pcp_spin_unlock(pcp);
 	} else {
-		free_one_page(zone, page, pfn, order, migratetype, FPI_NONE);
+		free_one_page(zone, page, pfn, order, FPI_NONE);
 	}
 	pcp_trylock_finish(UP_flags);
 }
@@ -2561,12 +2550,8 @@ void free_unref_folios(struct folio_batc
 		 * allocator.
 		 */
 		if (!pcp_allowed_order(order)) {
-			int migratetype;
-
-			migratetype = get_pfnblock_migratetype(&folio->page,
-							       pfn);
-			free_one_page(folio_zone(folio), &folio->page, pfn,
-					order, migratetype, FPI_NONE);
+			free_one_page(folio_zone(folio), &folio->page,
+				      pfn, order, FPI_NONE);
 			continue;
 		}
 		folio->private = (void *)(unsigned long)order;
@@ -2602,7 +2587,7 @@ void free_unref_folios(struct folio_batc
 			 */
 			if (is_migrate_isolate(migratetype)) {
 				free_one_page(zone, &folio->page, pfn,
-					      order, migratetype, FPI_NONE);
+					      order, FPI_NONE);
 				continue;
 			}
 
@@ -2615,7 +2600,7 @@ void free_unref_folios(struct folio_batc
 			if (unlikely(!pcp)) {
 				pcp_trylock_finish(UP_flags);
 				free_one_page(zone, &folio->page, pfn,
-					      order, migratetype, FPI_NONE);
+					      order, FPI_NONE);
 				continue;
 			}
 			locked_zone = zone;
@@ -6798,13 +6783,14 @@ bool take_page_off_buddy(struct page *pa
 bool put_page_back_buddy(struct page *page)
 {
 	struct zone *zone = page_zone(page);
-	unsigned long pfn = page_to_pfn(page);
 	unsigned long flags;
-	int migratetype = get_pfnblock_migratetype(page, pfn);
 	bool ret = false;
 
 	spin_lock_irqsave(&zone->lock, flags);
 	if (put_page_testzero(page)) {
+		unsigned long pfn = page_to_pfn(page);
+		int migratetype = get_pfnblock_migratetype(page, pfn);
+
 		ClearPageHWPoisonTakenOff(page);
 		__free_one_page(page, pfn, zone, 0, migratetype, FPI_NONE);
 		if (TestClearPageHWPoison(page)) {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


