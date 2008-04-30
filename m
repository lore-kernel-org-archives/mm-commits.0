From: akpm@linux-foundation.org
Subject: - mm-fix-usemap-initialization.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:38:25 -0700
Message-ID: <200804300538.m3U5cP8a028750@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424AbYD3Fj2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:39:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, hugh@veritas.com, mel@csn.ul.ie, shiwh@cn.fujitsu.com, stable@kernel.org, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     mm: fix usemap initialization
has been removed from the -mm tree.  Its filename was
     mm-fix-usemap-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix usemap initialization
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

usemap must be initialized only when pfn is within zone.  If not, it corrupts
memory.

And this patch also reduces the number of calls to set_pageblock_migratetype()
from
	(pfn & (pageblock_nr_pages -1)
to
	!(pfn & (pageblock_nr_pages-1)
it should be called once per pageblock.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Shi Weihua <shiwh@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-fix-usemap-initialization mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-usemap-initialization
+++ a/mm/page_alloc.c
@@ -2524,7 +2524,9 @@ void __meminit memmap_init_zone(unsigned
 	struct page *page;
 	unsigned long end_pfn = start_pfn + size;
 	unsigned long pfn;
+	struct zone *z;
 
+	z = &NODE_DATA(nid)->node_zones[zone];
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		/*
 		 * There can be holes in boot-time mem_map[]s
@@ -2542,7 +2544,6 @@ void __meminit memmap_init_zone(unsigned
 		init_page_count(page);
 		reset_page_mapcount(page);
 		SetPageReserved(page);
-
 		/*
 		 * Mark the block movable so that blocks are reserved for
 		 * movable at startup. This will force kernel allocations
@@ -2551,8 +2552,15 @@ void __meminit memmap_init_zone(unsigned
 		 * kernel allocations are made. Later some blocks near
 		 * the start are marked MIGRATE_RESERVE by
 		 * setup_zone_migrate_reserve()
+		 *
+		 * bitmap is created for zone's valid pfn range. but memmap
+		 * can be created for invalid pages (for alignment)
+		 * check here not to call set_pageblock_migratetype() against
+		 * pfn out of zone.
 		 */
-		if ((pfn & (pageblock_nr_pages-1)))
+		if ((z->zone_start_pfn <= pfn)
+		    && (pfn < z->zone_start_pfn + z->spanned_pages)
+		    && !(pfn & (pageblock_nr_pages - 1)))
 			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 
 		INIT_LIST_HEAD(&page->lru);
@@ -4464,6 +4472,8 @@ void set_pageblock_flags_group(struct pa
 	pfn = page_to_pfn(page);
 	bitmap = get_pageblock_bitmap(zone, pfn);
 	bitidx = pfn_to_bitidx(zone, pfn);
+	VM_BUG_ON(pfn < zone->zone_start_pfn);
+	VM_BUG_ON(pfn >= zone->zone_start_pfn + zone->spanned_pages);
 
 	for (; start_bitidx <= end_bitidx; start_bitidx++, value <<= 1)
 		if (flags & value)
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
disable-the-memory-controller-by-default-v3.patch
proc-pagetypeinfo-fix-output-for-memoryless-nodes.patch

