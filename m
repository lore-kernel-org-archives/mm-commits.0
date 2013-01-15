From: akpm@linux-foundation.org
Subject: + mm-remove-migrate_isolate-check-in-hotpath.patch added to -mm tree
Date: Tue, 15 Jan 2013 15:37:06 -0800
Message-ID: <20130115233706.9EB04100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:48686 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758112Ab3AOXhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jan 2013 18:37:08 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so94365ghb.5
        for <mm-commits@vger.kernel.org>; Tue, 15 Jan 2013 15:37:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, kosaki.motohiro@jp.fujitsu.com, mina86@mina86.com


The patch titled
     Subject: mm: remove MIGRATE_ISOLATE check in hotpath
has been added to the -mm tree.  Its filename is
     mm-remove-migrate_isolate-check-in-hotpath.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: remove MIGRATE_ISOLATE check in hotpath

Several functions test MIGRATE_ISOLATE and some of those are hotpath but
MIGRATE_ISOLATE is used only if we enable CONFIG_MEMORY_ISOLATION(ie, CMA,
memory-hotplug and memory-failure) which are not common config option.  So
let's not add unnecessary overhead and code when we don't enable
CONFIG_MEMORY_ISOLATION.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h         |    2 ++
 include/linux/page-isolation.h |   19 +++++++++++++++++++
 mm/compaction.c                |    6 +++++-
 mm/page_alloc.c                |   16 ++++++++++------
 mm/vmstat.c                    |    2 ++
 5 files changed, 38 insertions(+), 7 deletions(-)

diff -puN include/linux/mmzone.h~mm-remove-migrate_isolate-check-in-hotpath include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-remove-migrate_isolate-check-in-hotpath
+++ a/include/linux/mmzone.h
@@ -57,7 +57,9 @@ enum {
 	 */
 	MIGRATE_CMA,
 #endif
+#ifdef CONFIG_MEMORY_ISOLATION
 	MIGRATE_ISOLATE,	/* can't allocate from here */
+#endif
 	MIGRATE_TYPES
 };
 
diff -puN include/linux/page-isolation.h~mm-remove-migrate_isolate-check-in-hotpath include/linux/page-isolation.h
--- a/include/linux/page-isolation.h~mm-remove-migrate_isolate-check-in-hotpath
+++ a/include/linux/page-isolation.h
@@ -1,6 +1,25 @@
 #ifndef __LINUX_PAGEISOLATION_H
 #define __LINUX_PAGEISOLATION_H
 
+#ifdef CONFIG_MEMORY_ISOLATION
+static inline bool is_migrate_isolate_page(struct page *page)
+{
+	return get_pageblock_migratetype(page) == MIGRATE_ISOLATE;
+}
+static inline bool is_migrate_isolate(int migratetype)
+{
+	return migratetype == MIGRATE_ISOLATE;
+}
+#else
+static inline bool is_migrate_isolate_page(struct page *page)
+{
+	return false;
+}
+static inline bool is_migrate_isolate(int migratetype)
+{
+	return false;
+}
+#endif
 
 bool has_unmovable_pages(struct zone *zone, struct page *page, int count,
 			 bool skip_hwpoisoned_pages);
diff -puN mm/compaction.c~mm-remove-migrate_isolate-check-in-hotpath mm/compaction.c
--- a/mm/compaction.c~mm-remove-migrate_isolate-check-in-hotpath
+++ a/mm/compaction.c
@@ -15,6 +15,7 @@
 #include <linux/sysctl.h>
 #include <linux/sysfs.h>
 #include <linux/balloon_compaction.h>
+#include <linux/page-isolation.h>
 #include "internal.h"
 
 #ifdef CONFIG_COMPACTION
@@ -215,7 +216,10 @@ static bool suitable_migration_target(st
 	int migratetype = get_pageblock_migratetype(page);
 
 	/* Don't interfere with memory hot-remove or the min_free_kbytes blocks */
-	if (migratetype == MIGRATE_ISOLATE || migratetype == MIGRATE_RESERVE)
+	if (migratetype == MIGRATE_RESERVE)
+		return false;
+
+	if (is_migrate_isolate(migratetype))
 		return false;
 
 	/* If the page is a large free page, then allow migration */
diff -puN mm/page_alloc.c~mm-remove-migrate_isolate-check-in-hotpath mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-migrate_isolate-check-in-hotpath
+++ a/mm/page_alloc.c
@@ -669,7 +669,7 @@ static void free_pcppages_bulk(struct zo
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
 			__free_one_page(page, zone, 0, mt);
 			trace_mm_page_pcpu_drain(page, 0, mt);
-			if (likely(get_pageblock_migratetype(page) != MIGRATE_ISOLATE)) {
+			if (likely(!is_migrate_isolate_page(page))) {
 				__mod_zone_page_state(zone, NR_FREE_PAGES, 1);
 				if (is_migrate_cma(mt))
 					__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, 1);
@@ -687,7 +687,7 @@ static void free_one_page(struct zone *z
 	zone->pages_scanned = 0;
 
 	__free_one_page(page, zone, order, migratetype);
-	if (unlikely(migratetype != MIGRATE_ISOLATE))
+	if (unlikely(!is_migrate_isolate(migratetype)))
 		__mod_zone_freepage_state(zone, 1 << order, migratetype);
 	spin_unlock(&zone->lock);
 }
@@ -915,7 +915,9 @@ static int fallbacks[MIGRATE_TYPES][4] =
 	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE,   MIGRATE_RESERVE },
 #endif
 	[MIGRATE_RESERVE]     = { MIGRATE_RESERVE }, /* Never used */
+#ifdef CONFIG_MEMORY_ISOLATION
 	[MIGRATE_ISOLATE]     = { MIGRATE_RESERVE }, /* Never used */
+#endif
 };
 
 /*
@@ -1141,7 +1143,7 @@ static int rmqueue_bulk(struct zone *zon
 			list_add_tail(&page->lru, list);
 		if (IS_ENABLED(CONFIG_CMA)) {
 			mt = get_pageblock_migratetype(page);
-			if (!is_migrate_cma(mt) && mt != MIGRATE_ISOLATE)
+			if (!is_migrate_cma(mt) && !is_migrate_isolate(mt))
 				mt = migratetype;
 		}
 		set_freepage_migratetype(page, mt);
@@ -1325,7 +1327,7 @@ void free_hot_cold_page(struct page *pag
 	 * excessively into the page allocator
 	 */
 	if (migratetype >= MIGRATE_PCPTYPES) {
-		if (unlikely(migratetype == MIGRATE_ISOLATE)) {
+		if (unlikely(is_migrate_isolate(migratetype))) {
 			free_one_page(zone, page, 0, migratetype);
 			goto out;
 		}
@@ -1399,7 +1401,7 @@ static int __isolate_free_page(struct pa
 	zone = page_zone(page);
 	mt = get_pageblock_migratetype(page);
 
-	if (mt != MIGRATE_ISOLATE) {
+	if (!is_migrate_isolate(mt)) {
 		/* Obey watermarks as if the page was being allocated */
 		watermark = low_wmark_pages(zone) + (1 << order);
 		if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
@@ -1418,7 +1420,7 @@ static int __isolate_free_page(struct pa
 		struct page *endpage = page + (1 << order) - 1;
 		for (; page < endpage; page += pageblock_nr_pages) {
 			int mt = get_pageblock_migratetype(page);
-			if (mt != MIGRATE_ISOLATE && !is_migrate_cma(mt))
+			if (!is_migrate_isolate(mt) && !is_migrate_cma(mt))
 				set_pageblock_migratetype(page,
 							  MIGRATE_MOVABLE);
 		}
@@ -2896,7 +2898,9 @@ static void show_migration_types(unsigne
 #ifdef CONFIG_CMA
 		[MIGRATE_CMA]		= 'C',
 #endif
+#ifdef CONFIG_MEMORY_ISOLATION
 		[MIGRATE_ISOLATE]	= 'I',
+#endif
 	};
 	char tmp[MIGRATE_TYPES + 1];
 	char *p = tmp;
diff -puN mm/vmstat.c~mm-remove-migrate_isolate-check-in-hotpath mm/vmstat.c
--- a/mm/vmstat.c~mm-remove-migrate_isolate-check-in-hotpath
+++ a/mm/vmstat.c
@@ -628,7 +628,9 @@ static char * const migratetype_names[MI
 #ifdef CONFIG_CMA
 	"CMA",
 #endif
+#ifdef CONFIG_MEMORY_ISOLATION
 	"Isolate",
+#endif
 };
 
 static void *frag_start(struct seq_file *m, loff_t *pos)
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate.patch
mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone.patch
mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator.patch
mm-remove-migrate_isolate-check-in-hotpath.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch
mm-prevent-addition-of-pages-to-swap-if-may_writepage-is-unset.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix.patch

