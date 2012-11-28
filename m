From: akpm@linux-foundation.org
Subject: + mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch added to -mm tree
Date: Wed, 28 Nov 2012 15:52:32 -0800
Message-ID: <20121128235233.6A58620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:39316 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351Ab2K1Xwi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Nov 2012 18:52:38 -0500
Received: by mail-lb0-f202.google.com with SMTP id i15so979574lbo.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Nov 2012 15:52:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, chris2553@googlemail.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, maciej.rutecki@gmail.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, rientjes@google.com, rjw@sisk.pl, wency@cn.fujitsu.com, wujianguo@huawei.com


The patch titled
     Subject: mm: provide more accurate estimation of pages occupied by memmap
has been added to the -mm tree.  Its filename is
     mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm: provide more accurate estimation of pages occupied by memmap

If SPARSEMEM is enabled, it won't build page structures for non-existing
pages (holes) within a zone, so provide a more accurate estimation of
pages occupied by memmap if there are bigger holes within the zone.

And pages for highmem zones' memmap will be allocated from lowmem, so
charge nr_kernel_pages for that.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Chris Clayton <chris2553@googlemail.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap mm/page_alloc.c
--- a/mm/page_alloc.c~mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap
+++ a/mm/page_alloc.c
@@ -4526,6 +4526,26 @@ void __init set_pageblock_order(void)
 
 #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 
+static unsigned long calc_memmap_size(unsigned long spanned_pages,
+				      unsigned long present_pages)
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
@@ -4560,8 +4580,7 @@ static void __paginginit free_area_init_
 		 * is used by this zone for memmap. This affects the watermark
 		 * and per-cpu initialisations
 		 */
-		memmap_pages =
-			PAGE_ALIGN(size * sizeof(struct page)) >> PAGE_SHIFT;
+		memmap_pages = calc_memmap_size(size, realsize);
 		if (freesize >= memmap_pages) {
 			freesize -= memmap_pages;
 			if (memmap_pages)
@@ -4582,6 +4601,9 @@ static void __paginginit free_area_init_
 
 		if (!is_highmem_idx(j))
 			nr_kernel_pages += freesize;
+		/* Charge for highmem memmap if there are enough kernel pages */
+		else if (nr_kernel_pages > memmap_pages * 2)
+			nr_kernel_pages -= memmap_pages;
 		nr_all_pages += freesize;
 
 		zone->spanned_pages = size;
_

Patches currently in -mm which might be from liuj97@gmail.com are

linux-next.patch
x86-fix-the-argument-passed-to-sync_global_pgds.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-introduce-new-field-managed_pages-to-struct-zone-fix.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch

