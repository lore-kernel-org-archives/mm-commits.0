From: akpm@linux-foundation.org
Subject: [merged] mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:29:48 -0800
Message-ID: <20121214232949.A5DA5200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:44703 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab2LNX3y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:29:54 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so209731lbc.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:29:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, chris2553@googlemail.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, maciej.rutecki@gmail.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, rientjes@google.com, rjw@sisk.pl, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: provide more accurate estimation of pages occupied by memmap
has been removed from the -mm tree.  Its filename was
     mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm: provide more accurate estimation of pages occupied by memmap

If SPARSEMEM is enabled, it won't build page structures for non-existing
pages (holes) within a zone, so provide a more accurate estimation of
pages occupied by memmap if there are bigger holes within the zone.

And pages for highmem zones' memmap will be allocated from lowmem, so
charge nr_kernel_pages for that.

[akpm@linux-foundation.org: mark calc_memmap_size __paging_init]
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Chris Clayton <chris2553@googlemail.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Tested-by: Jianguo Wu <wujianguo@huawei.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap mm/page_alloc.c
--- a/mm/page_alloc.c~mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap
+++ a/mm/page_alloc.c
@@ -4489,6 +4489,26 @@ void __init set_pageblock_order(void)
 
 #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 
+static unsigned long __paginginit calc_memmap_size(unsigned long spanned_pages,
+						   unsigned long present_pages)
+{
+	unsigned long pages = spanned_pages;
+
+	/*
+	 * Provide a more accurate estimation if there are holes within
+	 * the zone and SPARSEMEM is in use. If there are holes within the
+	 * zone, each populated memory region may cost us one or two extra
+	 * memmap pages due to alignment because memmap pages for each
+	 * populated regions may not naturally algined on page boundary.
+	 * So the (present_pages >> 4) heuristic is a tradeoff for that.
+	 */
+	if (spanned_pages > present_pages + (present_pages >> 4) &&
+	    IS_ENABLED(CONFIG_SPARSEMEM))
+		pages = present_pages;
+
+	return PAGE_ALIGN(pages * sizeof(struct page)) >> PAGE_SHIFT;
+}
+
 /*
  * Set up the zone data structures:
  *   - mark all pages reserved
@@ -4523,8 +4543,7 @@ static void __paginginit free_area_init_
 		 * is used by this zone for memmap. This affects the watermark
 		 * and per-cpu initialisations
 		 */
-		memmap_pages =
-			PAGE_ALIGN(size * sizeof(struct page)) >> PAGE_SHIFT;
+		memmap_pages = calc_memmap_size(size, realsize);
 		if (freesize >= memmap_pages) {
 			freesize -= memmap_pages;
 			if (memmap_pages)
@@ -4545,6 +4564,9 @@ static void __paginginit free_area_init_
 
 		if (!is_highmem_idx(j))
 			nr_kernel_pages += freesize;
+		/* Charge for highmem memmap if there are enough kernel pages */
+		else if (nr_kernel_pages > memmap_pages * 2)
+			nr_kernel_pages -= memmap_pages;
 		nr_all_pages += freesize;
 
 		zone->spanned_pages = size;
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
linux-next.patch
x86-fix-the-argument-passed-to-sync_global_pgds.patch

