From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 044/127] mm/memory_hotplug: remove
 is_mem_section_removable()
Date: Thu, 04 Jun 2020 16:48:31 -0700
Message-ID: <20200604234831.S2-3ZOmHE%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXse (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:48:34 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, bhe@redhat.com, david@redhat.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de, richard.weiyang@gmail.com, torvalds@linux-foundation.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: remove is_mem_section_removable()

Fortunately, all users of is_mem_section_removable() are gone.  Get rid of
it, including some now unnecessary functions.

Link: http://lkml.kernel.org/r/20200407135416.24093-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    7 --
 mm/memory_hotplug.c            |   75 -------------------------------
 2 files changed, 82 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-remove-is_mem_section_removable
+++ a/include/linux/memory_hotplug.h
@@ -314,19 +314,12 @@ static inline void pgdat_resize_init(str
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
 
-extern bool is_mem_section_removable(unsigned long pfn, unsigned long nr_pages);
 extern void try_offline_node(int nid);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
 extern int remove_memory(int nid, u64 start, u64 size);
 extern void __remove_memory(int nid, u64 start, u64 size);
 
 #else
-static inline bool is_mem_section_removable(unsigned long pfn,
-					unsigned long nr_pages)
-{
-	return false;
-}
-
 static inline void try_offline_node(int nid) {}
 
 static inline int offline_pages(unsigned long start_pfn, unsigned long nr_pages)
--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-is_mem_section_removable
+++ a/mm/memory_hotplug.c
@@ -1114,81 +1114,6 @@ EXPORT_SYMBOL_GPL(add_memory);
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
 /*
- * A free page on the buddy free lists (not the per-cpu lists) has PageBuddy
- * set and the size of the free page is given by page_order(). Using this,
- * the function determines if the pageblock contains only free pages.
- * Due to buddy contraints, a free page at least the size of a pageblock will
- * be located at the start of the pageblock
- */
-static inline int pageblock_free(struct page *page)
-{
-	return PageBuddy(page) && page_order(page) >= pageblock_order;
-}
-
-/* Return the pfn of the start of the next active pageblock after a given pfn */
-static unsigned long next_active_pageblock(unsigned long pfn)
-{
-	struct page *page = pfn_to_page(pfn);
-
-	/* Ensure the starting page is pageblock-aligned */
-	BUG_ON(pfn & (pageblock_nr_pages - 1));
-
-	/* If the entire pageblock is free, move to the end of free page */
-	if (pageblock_free(page)) {
-		int order;
-		/* be careful. we don't have locks, page_order can be changed.*/
-		order = page_order(page);
-		if ((order < MAX_ORDER) && (order >= pageblock_order))
-			return pfn + (1 << order);
-	}
-
-	return pfn + pageblock_nr_pages;
-}
-
-static bool is_pageblock_removable_nolock(unsigned long pfn)
-{
-	struct page *page = pfn_to_page(pfn);
-	struct zone *zone;
-
-	/*
-	 * We have to be careful here because we are iterating over memory
-	 * sections which are not zone aware so we might end up outside of
-	 * the zone but still within the section.
-	 * We have to take care about the node as well. If the node is offline
-	 * its NODE_DATA will be NULL - see page_zone.
-	 */
-	if (!node_online(page_to_nid(page)))
-		return false;
-
-	zone = page_zone(page);
-	pfn = page_to_pfn(page);
-	if (!zone_spans_pfn(zone, pfn))
-		return false;
-
-	return !has_unmovable_pages(zone, page, MIGRATE_MOVABLE,
-				    MEMORY_OFFLINE);
-}
-
-/* Checks if this range of memory is likely to be hot-removable. */
-bool is_mem_section_removable(unsigned long start_pfn, unsigned long nr_pages)
-{
-	unsigned long end_pfn, pfn;
-
-	end_pfn = min(start_pfn + nr_pages,
-			zone_end_pfn(page_zone(pfn_to_page(start_pfn))));
-
-	/* Check the starting page of each pageblock within the range */
-	for (pfn = start_pfn; pfn < end_pfn; pfn = next_active_pageblock(pfn)) {
-		if (!is_pageblock_removable_nolock(pfn))
-			return false;
-		cond_resched();
-	}
-
-	/* All pageblocks in the memory block are likely to be hot-removable */
-	return true;
-}
