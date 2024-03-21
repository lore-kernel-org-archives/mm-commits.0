Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C4FB669
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 23:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711062773; cv=none; b=IeiotW6DdMRm0GBLWl58+EPDek1y/Vd5HY+gRwQFtdLYRagFfvjIhIlBDMJHOB1wjXo5MIQCp7ceFuKQcO2LJF5sSQAR0UaGlZHpamjp1gi07z4HrbTl94KL5OVQLbg6pmF9oS+OtPWB/TR6+O0hDLwOl42xHZBQAbuhUkv6VlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711062773; c=relaxed/simple;
	bh=gzOVJU2qtUcVLXf0Z3DTPvqJ7/ETY5p7mTcP4GT0kxI=;
	h=Date:To:From:Subject:Message-Id; b=gLevwLhEhheXbWgN/ZLTyQL1xKTgPt4sw6tubQhsVFIUNRkCPU3/BeMBKBjGw67JSN7fGnxKbLpowj3Ky/+wC2Ob3qOEfGqI1olbEFN2DbXp4yXWcnNdAwrf2XhXPh+ISOo/rVyZ7uPBLqObtbUEbzhZjylEBTL1VqgshDRALBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qLM/PFwG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qLM/PFwG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA447C433C7;
	Thu, 21 Mar 2024 23:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711062773;
	bh=gzOVJU2qtUcVLXf0Z3DTPvqJ7/ETY5p7mTcP4GT0kxI=;
	h=Date:To:From:Subject:From;
	b=qLM/PFwGrbm1i81U0KHY4l2o019eXFouuGfPsiqvKmjneH96mRRVvPRaZ0gwCEAYC
	 qSfkV9+9LQyaZud10v8E1VX/AY6BF85ydDNxQenvUaGi7CnciJE/AyeCKEveHQ4SVy
	 1dY49+50ZE5ucLXLFslV8RRyYPx2r6hpEwAdNqMs=
Date: Thu, 21 Mar 2024 16:12:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,vbabka@suse.cz,mgorman@techsingularity.net,david@redhat.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-close-migratetype-race-between-freeing-and-stealing.patch added to mm-unstable branch
Message-Id: <20240321231253.AA447C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: close migratetype race between freeing and stealing
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-close-migratetype-race-between-freeing-and-stealing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-close-migratetype-race-between-freeing-and-stealing.patch

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
@@ -2502,7 +2491,7 @@ void free_unref_page(struct page *page,
 	struct per_cpu_pages *pcp;
 	struct zone *zone;
 	unsigned long pfn = page_to_pfn(page);
-	int migratetype, pcpmigratetype;
+	int migratetype;
 
 	if (!free_pages_prepare(page, order))
 		return;
@@ -2514,23 +2503,23 @@ void free_unref_page(struct page *page,
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
@@ -2560,12 +2549,8 @@ void free_unref_folios(struct folio_batc
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
@@ -2601,7 +2586,7 @@ void free_unref_folios(struct folio_batc
 			 */
 			if (is_migrate_isolate(migratetype)) {
 				free_one_page(zone, &folio->page, pfn,
-					      order, migratetype, FPI_NONE);
+					      order, FPI_NONE);
 				continue;
 			}
 
@@ -2614,7 +2599,7 @@ void free_unref_folios(struct folio_batc
 			if (unlikely(!pcp)) {
 				pcp_trylock_finish(UP_flags);
 				free_one_page(zone, &folio->page, pfn,
-					      order, migratetype, FPI_NONE);
+					      order, FPI_NONE);
 				continue;
 			}
 			locked_zone = zone;
@@ -6797,13 +6782,14 @@ bool take_page_off_buddy(struct page *pa
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

mm-cachestat-fix-two-shmem-bugs.patch
mm-zswap-fix-writeback-shinker-gfp_noio-gfp_nofs-recursion.patch
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
mm-page_isolation-prepare-for-hygienic-freelists-fix.patch
mm-page_alloc-consolidate-free-page-accounting.patch

