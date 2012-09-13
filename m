From: akpm@linux-foundation.org
Subject: + mm-fix-up-zone-present-pages.patch added to -mm tree
Date: Thu, 13 Sep 2012 16:14:21 -0700
Message-ID: <20120913231422.4602820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:46139 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab2IMXOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 19:14:25 -0400
Received: by fass10 with SMTP id s10so218683fas.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 16:14:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wujianguo@huawei.com, hannes@cmpxchg.org, jiang.liu@huawei.com, mel@csn.ul.ie, minchan.kim@gmail.com, ptesarik@suse.cz, rientjes@google.com, tony.luck@intel.com, yinghai@kernel.org


The patch titled
     Subject: mm: fix-up zone present pages
has been added to the -mm tree.  Its filename is
     mm-fix-up-zone-present-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: mm: fix-up zone present pages

I think zone->present_pages indicates pages that buddy system can management,
it should be:

	zone->present_pages = spanned pages - absent pages - bootmem pages,

but is now:
	zone->present_pages = spanned pages - absent pages - memmap pages.

spanned pages: total size, including holes.
absent pages: holes.
bootmem pages: pages used in system boot, managed by bootmem allocator.
memmap pages: pages used by page structs.

This may cause zone->present_pages less than it should be.  For example,
numa node 1 has ZONE_NORMAL and ZONE_MOVABLE, it's memmap and other
bootmem will be allocated from ZONE_MOVABLE, so ZONE_NORMAL's
present_pages should be spanned pages - absent pages, but now it also
minus memmap pages(free_area_init_core), which are actually allocated from
ZONE_MOVABLE.  When offlining all memory of a zone, this will cause
zone->present_pages less than 0, because present_pages is unsigned long
type, it is actually a very large integer, it indirectly caused
zone->watermark[WMARK_MIN] becomes a large
integer(setup_per_zone_wmarks()), than cause totalreserve_pages become a
large integer(calculate_totalreserve_pages()), and finally cause memory
allocating failure when fork process(__vm_enough_memory()).

[root@localhost ~]# dmesg
-bash: fork: Cannot allocate memory

I think the bug described in
http://marc.info/?l=linux-mm&m=134502182714186&w=2 is also caused by wrong
zone present pages.

This patch intends to fix-up zone->present_pages when memory are freed to
buddy system on x86_64 and IA64 platforms.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Reported-by: Petr Tesarik <ptesarik@suse.cz>
Tested-by: Petr Tesarik <ptesarik@suse.cz>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c |    1 +
 include/linux/mm.h  |    4 ++++
 mm/bootmem.c        |    9 ++++++++-
 mm/memory_hotplug.c |    7 +++++++
 mm/nobootmem.c      |    3 +++
 mm/page_alloc.c     |   34 ++++++++++++++++++++++++++++++++++
 6 files changed, 57 insertions(+), 1 deletion(-)

diff -puN arch/ia64/mm/init.c~mm-fix-up-zone-present-pages arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~mm-fix-up-zone-present-pages
+++ a/arch/ia64/mm/init.c
@@ -637,6 +637,7 @@ mem_init (void)
 
 	high_memory = __va(max_low_pfn * PAGE_SIZE);
 
+	reset_zone_present_pages();
 	for_each_online_pgdat(pgdat)
 		if (pgdat->bdata->node_bootmem_map)
 			totalram_pages += free_all_bootmem_node(pgdat);
diff -puN include/linux/mm.h~mm-fix-up-zone-present-pages include/linux/mm.h
--- a/include/linux/mm.h~mm-fix-up-zone-present-pages
+++ a/include/linux/mm.h
@@ -1684,5 +1684,9 @@ static inline unsigned int debug_guardpa
 static inline bool page_is_guard(struct page *page) { return false; }
 #endif /* CONFIG_DEBUG_PAGEALLOC */
 
+extern void reset_zone_present_pages(void);
+extern void fixup_zone_present_pages(int nid, unsigned long start_pfn,
+				unsigned long end_pfn);
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff -puN mm/bootmem.c~mm-fix-up-zone-present-pages mm/bootmem.c
--- a/mm/bootmem.c~mm-fix-up-zone-present-pages
+++ a/mm/bootmem.c
@@ -198,6 +198,8 @@ static unsigned long __init free_all_boo
 			int order = ilog2(BITS_PER_LONG);
 
 			__free_pages_bootmem(pfn_to_page(start), order);
+			fixup_zone_present_pages(page_to_nid(pfn_to_page(start)),
+					start, start + BITS_PER_LONG);
 			count += BITS_PER_LONG;
 			start += BITS_PER_LONG;
 		} else {
@@ -208,6 +210,8 @@ static unsigned long __init free_all_boo
 				if (vec & 1) {
 					page = pfn_to_page(start + off);
 					__free_pages_bootmem(page, 0);
+					fixup_zone_present_pages(page_to_nid(page),
+							start + off, start + off + 1);
 					count++;
 				}
 				vec >>= 1;
@@ -221,8 +225,11 @@ static unsigned long __init free_all_boo
 	pages = bdata->node_low_pfn - bdata->node_min_pfn;
 	pages = bootmem_bootmap_pages(pages);
 	count += pages;
-	while (pages--)
+	while (pages--) {
+		fixup_zone_present_pages(page_to_nid(page),
+				page_to_pfn(page), page_to_pfn(page) + 1);
 		__free_pages_bootmem(page++, 0);
+	}
 
 	bdebug("nid=%td released=%lx\n", bdata - bootmem_node_data, count);
 
diff -puN mm/memory_hotplug.c~mm-fix-up-zone-present-pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-fix-up-zone-present-pages
+++ a/mm/memory_hotplug.c
@@ -106,6 +106,7 @@ static void get_page_bootmem(unsigned lo
 void __ref put_page_bootmem(struct page *page)
 {
 	unsigned long type;
+	struct zone *zone;
 
 	type = (unsigned long) page->lru.next;
 	BUG_ON(type < MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE ||
@@ -116,6 +117,12 @@ void __ref put_page_bootmem(struct page 
 		set_page_private(page, 0);
 		INIT_LIST_HEAD(&page->lru);
 		__free_pages_bootmem(page, 0);
+
+		zone = page_zone(page);
+		zone_span_writelock(zone);
+		zone->present_pages++;
+		zone_span_writeunlock(zone);
+		totalram_pages++;
 	}
 
 }
diff -puN mm/nobootmem.c~mm-fix-up-zone-present-pages mm/nobootmem.c
--- a/mm/nobootmem.c~mm-fix-up-zone-present-pages
+++ a/mm/nobootmem.c
@@ -116,6 +116,8 @@ static unsigned long __init __free_memor
 		return 0;
 
 	__free_pages_memory(start_pfn, end_pfn);
+	fixup_zone_present_pages(pfn_to_nid(start >> PAGE_SHIFT),
+			start_pfn, end_pfn);
 
 	return end_pfn - start_pfn;
 }
@@ -126,6 +128,7 @@ unsigned long __init free_low_memory_cor
 	phys_addr_t start, end, size;
 	u64 i;
 
+	reset_zone_present_pages();
 	for_each_free_mem_range(i, MAX_NUMNODES, &start, &end, NULL)
 		count += __free_memory_core(start, end);
 
diff -puN mm/page_alloc.c~mm-fix-up-zone-present-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-up-zone-present-pages
+++ a/mm/page_alloc.c
@@ -6071,3 +6071,37 @@ void dump_page(struct page *page)
 	dump_page_flags(page->flags);
 	mem_cgroup_print_bad_page(page);
 }
+
+/* reset zone->present_pages */
+void reset_zone_present_pages(void)
+{
+	struct zone *z;
+	int i, nid;
+
+	for_each_node_state(nid, N_HIGH_MEMORY) {
+		for (i = 0; i < MAX_NR_ZONES; i++) {
+			z = NODE_DATA(nid)->node_zones + i;
+			z->present_pages = 0;
+		}
+	}
+}
+
+/* calculate zone's present pages in buddy system */
+void fixup_zone_present_pages(int nid, unsigned long start_pfn,
+				unsigned long end_pfn)
+{
+	struct zone *z;
+	unsigned long zone_start_pfn, zone_end_pfn;
+	int i;
+
+	for (i = 0; i < MAX_NR_ZONES; i++) {
+		z = NODE_DATA(nid)->node_zones + i;
+		zone_start_pfn = z->zone_start_pfn;
+		zone_end_pfn = zone_start_pfn + z->spanned_pages;
+
+		/* if the two regions intersect */
+		if (!(zone_start_pfn >= end_pfn	|| zone_end_pfn <= start_pfn))
+			z->present_pages += min(end_pfn, zone_end_pfn) -
+								max(start_pfn, zone_start_pfn);
+	}
+}
_

Patches currently in -mm which might be from wujianguo@huawei.com are

mm-ia64-fix-a-memory-block-size-bug.patch
linux-next.patch
mm-fix-up-zone-present-pages.patch

