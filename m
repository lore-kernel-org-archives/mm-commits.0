From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 054/118] mm: remove "count" parameter from
 has_unmovable_pages()
Date: Thu, 30 Jan 2020 22:14:04 -0800
Message-ID: <20200131061404.vx-936iUB%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGOH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:14:07 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com, anshuman.khandual@arm.com, arunks@codeaurora.org, cai@lca.pw, dan.j.williams@intel.com, david@redhat.com, glider@google.com, kernelfans@gmail.com, linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de, pasha.tatashin@soleen.com, richardw.yang@linux.intel.com, rppt@linux.vnet.ibm.com, sfr@canb.auug.org.au, torvalds@linux-foundation.org, vbabka@suse.cz

From: David Hildenbrand <david@redhat.com>
Subject: mm: remove "count" parameter from has_unmovable_pages()

Now that the memory isolate notifier is gone, the parameter is always 0. 
Drop it and cleanup has_unmovable_pages().

Link: http://lkml.kernel.org/r/20191114131911.11783-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Pingfan Liu <kernelfans@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Arun KS <arunks@codeaurora.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-isolation.h |    4 ++--
 mm/memory_hotplug.c            |    2 +-
 mm/page_alloc.c                |   21 +++++++--------------
 mm/page_isolation.c            |    2 +-
 4 files changed, 11 insertions(+), 18 deletions(-)

--- a/include/linux/page-isolation.h~mm-remove-count-parameter-from-has_unmovable_pages
+++ a/include/linux/page-isolation.h
@@ -33,8 +33,8 @@ static inline bool is_migrate_isolate(in
 #define MEMORY_OFFLINE	0x1
 #define REPORT_FAILURE	0x2
 
-bool has_unmovable_pages(struct zone *zone, struct page *page, int count,
-			 int migratetype, int flags);
+bool has_unmovable_pages(struct zone *zone, struct page *page, int migratetype,
+			 int flags);
 void set_pageblock_migratetype(struct page *page, int migratetype);
 int move_freepages_block(struct zone *zone, struct page *page,
 				int migratetype, int *num_movable);
--- a/mm/memory_hotplug.c~mm-remove-count-parameter-from-has_unmovable_pages
+++ a/mm/memory_hotplug.c
@@ -1182,7 +1182,7 @@ static bool is_pageblock_removable_noloc
 	if (!zone_spans_pfn(zone, pfn))
 		return false;
 
-	return !has_unmovable_pages(zone, page, 0, MIGRATE_MOVABLE,
+	return !has_unmovable_pages(zone, page, MIGRATE_MOVABLE,
 				    MEMORY_OFFLINE);
 }
 
--- a/mm/page_alloc.c~mm-remove-count-parameter-from-has_unmovable_pages
+++ a/mm/page_alloc.c
@@ -8180,17 +8180,15 @@ void *__init alloc_large_system_hash(con
 
 /*
  * This function checks whether pageblock includes unmovable pages or not.
- * If @count is not zero, it is okay to include less @count unmovable pages
  *
  * PageLRU check without isolation or lru_lock could race so that
  * MIGRATE_MOVABLE block might include unmovable pages. And __PageMovable
  * check without lock_page also may miss some movable non-lru pages at
  * race condition. So you can't expect this function should be exact.
  */
-bool has_unmovable_pages(struct zone *zone, struct page *page, int count,
-			 int migratetype, int flags)
+bool has_unmovable_pages(struct zone *zone, struct page *page, int migratetype,
+			 int flags)
 {
-	unsigned long found;
 	unsigned long iter = 0;
 	unsigned long pfn = page_to_pfn(page);
 	const char *reason = "unmovable page";
@@ -8216,13 +8214,11 @@ bool has_unmovable_pages(struct zone *zo
 		goto unmovable;
 	}
 
-	for (found = 0; iter < pageblock_nr_pages; iter++) {
-		unsigned long check = pfn + iter;
-
-		if (!pfn_valid_within(check))
+	for (; iter < pageblock_nr_pages; iter++) {
+		if (!pfn_valid_within(pfn + iter))
 			continue;
 
-		page = pfn_to_page(check);
+		page = pfn_to_page(pfn + iter);
 
 		if (PageReserved(page))
 			goto unmovable;
@@ -8271,11 +8267,9 @@ bool has_unmovable_pages(struct zone *zo
 		if ((flags & MEMORY_OFFLINE) && PageHWPoison(page))
 			continue;
 
-		if (__PageMovable(page))
+		if (__PageMovable(page) || PageLRU(page))
 			continue;
 
-		if (!PageLRU(page))
-			found++;
 		/*
 		 * If there are RECLAIMABLE pages, we need to check
 		 * it.  But now, memory offline itself doesn't call
@@ -8289,8 +8283,7 @@ bool has_unmovable_pages(struct zone *zo
 		 * is set to both of a memory hole page and a _used_ kernel
 		 * page at boot.
 		 */
-		if (found > count)
-			goto unmovable;
+		goto unmovable;
 	}
 	return false;
 unmovable:
--- a/mm/page_isolation.c~mm-remove-count-parameter-from-has_unmovable_pages
+++ a/mm/page_isolation.c
@@ -37,7 +37,7 @@ static int set_migratetype_isolate(struc
 	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
 	 * We just check MOVABLE pages.
 	 */
-	if (!has_unmovable_pages(zone, page, 0, migratetype, isol_flags)) {
+	if (!has_unmovable_pages(zone, page, migratetype, isol_flags)) {
 		unsigned long nr_pages;
 		int mt = get_pageblock_migratetype(page);
 
_
