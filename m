From: akpm@linux-foundation.org
Subject: + mm-remove-count-parameter-from-has_unmovable_pages.patch
 added to -mm tree
Date: Mon, 13 Jan 2020 14:05:25 -0800
Message-ID: <20200113220525.YyM0E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728982AbgAMWF2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jan 2020 17:05:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, sfr@canb.auug.org.au, rppt@linux.vnet.ibm.com, richardw.yang@linux.intel.com, pasha.tatashin@soleen.com, osalvador@suse.de, mpe@ellerman.id.au, mhocko@suse.com, mgorman@techsingularity.net, kernelfans@gmail.com, glider@google.com, dan.j.williams@intel.com, cai@lca.pw, arunks@codeaurora.org, anshuman.khandual@arm.com, alexander.h.duyck@linux.intel.com, david@redhat.com


The patch titled
     Subject: mm: remove "count" parameter from has_unmovable_pages()
has been added to the -mm tree.  Its filename is
     mm-remove-count-parameter-from-has_unmovable_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-count-parameter-from-has_unmovable_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-count-parameter-from-has_unmovable_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -1157,7 +1157,7 @@ static bool is_pageblock_removable_noloc
 	if (!zone_spans_pfn(zone, pfn))
 		return false;
 
-	return !has_unmovable_pages(zone, page, 0, MIGRATE_MOVABLE,
+	return !has_unmovable_pages(zone, page, MIGRATE_MOVABLE,
 				    MEMORY_OFFLINE);
 }
 
--- a/mm/page_alloc.c~mm-remove-count-parameter-from-has_unmovable_pages
+++ a/mm/page_alloc.c
@@ -8197,17 +8197,15 @@ void *__init alloc_large_system_hash(con
 
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
@@ -8233,13 +8231,11 @@ bool has_unmovable_pages(struct zone *zo
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
@@ -8288,11 +8284,9 @@ bool has_unmovable_pages(struct zone *zo
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
@@ -8306,8 +8300,7 @@ bool has_unmovable_pages(struct zone *zo
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

Patches currently in -mm which might be from david@redhat.com are

mm-fix-uninitialized-memmaps-on-a-partially-populated-last-section.patch
fs-proc-pagec-allow-inspection-of-last-section-and-fix-end-detection.patch
mm-initialize-memmap-of-unavailable-memory-directly.patch
mm-memory_hotplug-dont-free-usage-map-when-removing-a-re-added-early-section.patch
drivers-base-memoryc-cache-blocks-in-radix-tree-to-accelerate-lookup-fix-2.patch
mm-memory_hotplug-poison-memmap-in-remove_pfn_range_from_zone.patch
mm-memory_hotplug-we-always-have-a-zone-in-find_smallestbiggest_section_pfn.patch
mm-memory_hotplug-dont-check-for-all-holes-in-shrink_zone_span.patch
mm-memory_hotplug-drop-local-variables-in-shrink_zone_span.patch
mm-memory_hotplug-cleanup-__remove_pages.patch
mm-memory_hotplug-drop-valid_start-valid_end-from-test_pages_in_a_zone.patch
mm-page_alloc-fix-and-rework-pfn-handling-in-memmap_init_zone.patch
mm-factor-out-next_present_section_nr.patch
mm-remove-the-memory-isolate-notifier.patch
mm-remove-count-parameter-from-has_unmovable_pages.patch
