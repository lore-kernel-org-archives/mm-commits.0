From: akpm@linux-foundation.org
Subject: [patch 036/131] mm: distinguish CMA and MOVABLE isolation
 in has_unmovable_pages()
Date: Wed, 15 Nov 2017 17:33:26 -0800
Message-ID: <20171116013326.F8ZXAcWV4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38870 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932597AbdKPBd2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:33:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arbab@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com, imammedo@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, qiuxishi@huawei.com, ran.wang_1@nxp.com, stefan.wahren@i2se.com, torvalds@linux-foundation.org, vbabka@suse.cz, vkuznets@redhat.com, yasu.isimatu@gmail.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm: distinguish CMA and MOVABLE isolation in has_unmovable_pages()

Joonsoo has noticed that "mm: drop migrate type checks from
has_unmovable_pages" would break CMA allocator because it relies on
has_unmovable_pages returning false even for CMA pageblocks which in fact
don't have to be movable:

alloc_contig_range
  start_isolate_page_range
    set_migratetype_isolate
      has_unmovable_pages

This is a result of the code sharing between CMA and memory hotplug while
each one has a different idea of what has_unmovable_pages should return. 
This is unfortunate but fixing it properly would require a lot of code
duplication.

Fix the issue by introducing the requested migrate type argument and
special case MIGRATE_CMA case where CMA page blocks are handled properly. 
This will work for memory hotplug because it requires MIGRATE_MOVABLE.

Link: http://lkml.kernel.org/r/20171019122118.y6cndierwl2vnguj@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Tested-by: Ran Wang <ran.wang_1@nxp.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <yasu.isimatu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-isolation.h |    2 +-
 mm/page_alloc.c                |   12 +++++++++++-
 mm/page_isolation.c            |   10 +++++-----
 3 files changed, 17 insertions(+), 7 deletions(-)

diff -puN include/linux/page-isolation.h~mm-distinguish-cma-and-movable-isolation-in-has_unmovable_pages include/linux/page-isolation.h
--- a/include/linux/page-isolation.h~mm-distinguish-cma-and-movable-isolation-in-has_unmovable_pages
+++ a/include/linux/page-isolation.h
@@ -31,7 +31,7 @@ static inline bool is_migrate_isolate(in
 #endif
 
 bool has_unmovable_pages(struct zone *zone, struct page *page, int count,
-			 bool skip_hwpoisoned_pages);
+			 int migratetype, bool skip_hwpoisoned_pages);
 void set_pageblock_migratetype(struct page *page, int migratetype);
 int move_freepages_block(struct zone *zone, struct page *page,
 				int migratetype, int *num_movable);
diff -puN mm/page_alloc.c~mm-distinguish-cma-and-movable-isolation-in-has_unmovable_pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-distinguish-cma-and-movable-isolation-in-has_unmovable_pages
+++ a/mm/page_alloc.c
@@ -7353,6 +7353,7 @@ void *__init alloc_large_system_hash(con
  * race condition. So you can't expect this function should be exact.
  */
 bool has_unmovable_pages(struct zone *zone, struct page *page, int count,
+			 int migratetype,
 			 bool skip_hwpoisoned_pages)
 {
 	unsigned long pfn, iter, found;
@@ -7364,6 +7365,15 @@ bool has_unmovable_pages(struct zone *zo
 	if (zone_idx(zone) == ZONE_MOVABLE)
 		return false;
 
+	/*
+	 * CMA allocations (alloc_contig_range) really need to mark isolate
+	 * CMA pageblocks even when they are not movable in fact so consider
+	 * them movable here.
+	 */
+	if (is_migrate_cma(migratetype) &&
+			is_migrate_cma(get_pageblock_migratetype(page)))
+		return false;
+
 	pfn = page_to_pfn(page);
 	for (found = 0, iter = 0; iter < pageblock_nr_pages; iter++) {
 		unsigned long check = pfn + iter;
@@ -7446,7 +7456,7 @@ bool is_pageblock_removable_nolock(struc
 	if (!zone_spans_pfn(zone, pfn))
 		return false;
 
-	return !has_unmovable_pages(zone, page, 0, true);
+	return !has_unmovable_pages(zone, page, 0, MIGRATE_MOVABLE, true);
 }
 
 #if (defined(CONFIG_MEMORY_ISOLATION) && defined(CONFIG_COMPACTION)) || defined(CONFIG_CMA)
diff -puN mm/page_isolation.c~mm-distinguish-cma-and-movable-isolation-in-has_unmovable_pages mm/page_isolation.c
--- a/mm/page_isolation.c~mm-distinguish-cma-and-movable-isolation-in-has_unmovable_pages
+++ a/mm/page_isolation.c
@@ -15,7 +15,7 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/page_isolation.h>
 
-static int set_migratetype_isolate(struct page *page,
+static int set_migratetype_isolate(struct page *page, int migratetype,
 				bool skip_hwpoisoned_pages)
 {
 	struct zone *zone;
@@ -52,7 +52,7 @@ static int set_migratetype_isolate(struc
 	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
 	 * We just check MOVABLE pages.
 	 */
-	if (!has_unmovable_pages(zone, page, arg.pages_found,
+	if (!has_unmovable_pages(zone, page, arg.pages_found, migratetype,
 				 skip_hwpoisoned_pages))
 		ret = 0;
 
@@ -64,14 +64,14 @@ static int set_migratetype_isolate(struc
 out:
 	if (!ret) {
 		unsigned long nr_pages;
-		int migratetype = get_pageblock_migratetype(page);
+		int mt = get_pageblock_migratetype(page);
 
 		set_pageblock_migratetype(page, MIGRATE_ISOLATE);
 		zone->nr_isolate_pageblock++;
 		nr_pages = move_freepages_block(zone, page, MIGRATE_ISOLATE,
 									NULL);
 
-		__mod_zone_freepage_state(zone, -nr_pages, migratetype);
+		__mod_zone_freepage_state(zone, -nr_pages, mt);
 	}
 
 	spin_unlock_irqrestore(&zone->lock, flags);
@@ -183,7 +183,7 @@ int start_isolate_page_range(unsigned lo
 	     pfn += pageblock_nr_pages) {
 		page = __first_valid_page(pfn, pageblock_nr_pages);
 		if (page &&
-		    set_migratetype_isolate(page, skip_hwpoisoned_pages)) {
+		    set_migratetype_isolate(page, migratetype, skip_hwpoisoned_pages)) {
 			undo_pfn = pfn;
 			goto undo;
 		}
_
