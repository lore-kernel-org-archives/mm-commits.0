Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F013DAC11
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 19:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711568567; cv=none; b=EB6eLKwWQ052zKQewqXjIYN3Mgmb4B3CP40EcAJRFut0jNjV+dCrBekUBfJlZ51KsRklt41AqnXGNAL+8LYeookEimFLTohfRReEA4g9pXHqnPDConVBlJiS1UIx/3WUTPS5gl67shfWx5napCZKF6CITvb8Msm+MddrQd1fZwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711568567; c=relaxed/simple;
	bh=Fttj7fN3Wv1qp8gfg3hwzwo1X0ilHxLRo6AAwuB6Bm0=;
	h=Date:To:From:Subject:Message-Id; b=aL/zhoWiedEkng6K+0XDMJBXLPhJ9tbqkGQaLJYV1I48blAsW+9Q9z1CHUm00rzXIP+6mpZgeppYSEC8B8wOI/qy0UKVvTdv7ZvMofDLt0AXMX4zEqTNpn81+wni2xq8W1VBw9T54gbdpnYtKJaa7ehxR/Ns+pLFA8wAMJD7fOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r0xGlnfF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r0xGlnfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CD1C433F1;
	Wed, 27 Mar 2024 19:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711568566;
	bh=Fttj7fN3Wv1qp8gfg3hwzwo1X0ilHxLRo6AAwuB6Bm0=;
	h=Date:To:From:Subject:From;
	b=r0xGlnfFV4l/pVm576PTz2qRtXS3uS/SWLG6ZES1+ZVSVJhPtc53z8yIiChJnIMms
	 arMtdImGN+ch/SybBoFaGohmiEZ0+dGifONICwbK57QfoHDPnAhUETnO4iOWn4ZQ8N
	 jT5a1jCIb3TKM4RuWCP+uqqzSyOpoUqdakc2l+h4=
Date: Wed, 27 Mar 2024 12:42:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,vbabka@suse.cz,mgorman@techsingularity.net,david@redhat.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-consolidate-free-page-accounting-fix-2.patch added to mm-unstable branch
Message-Id: <20240327194246.98CD1C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: consolidate free page accounting fix 2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-consolidate-free-page-accounting-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-consolidate-free-page-accounting-fix-2.patch

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
@@ -6930,7 +6930,7 @@ static bool try_to_accept_memory_one(str
 	list_del(&page->lru);
 	last = list_empty(&zone->unaccepted_pages);
 
-	account_freepages(page, zone, -MAX_ORDER_NR_PAGES, MIGRATE_MOVABLE);
+	account_freepages(zone, -MAX_ORDER_NR_PAGES, MIGRATE_MOVABLE);
 	__mod_zone_page_state(zone, NR_UNACCEPTED, -MAX_ORDER_NR_PAGES);
 	spin_unlock_irqrestore(&zone->lock, flags);
 
@@ -6982,7 +6982,7 @@ static bool __free_unaccepted(struct pag
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
mm-page_isolation-prepare-for-hygienic-freelists-fix.patch
mm-page_alloc-consolidate-free-page-accounting.patch
mm-page_alloc-consolidate-free-page-accounting-fix.patch
mm-page_alloc-consolidate-free-page-accounting-fix-2.patch

