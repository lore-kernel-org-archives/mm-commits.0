From: akpm@linux-foundation.org
Subject: + memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch added to -mm tree
Date: Thu, 18 Oct 2012 15:17:00 -0700
Message-ID: <20121018221701.3A8DB20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:62659 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab2JRWRF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 18:17:05 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so385631eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 15:17:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, andi@firstfloor.org, benh@kernel.crashing.org, cl@linux.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, len.brown@intel.com, liuj97@gmail.com, minchan.kim@gmail.com, paulus@samba.org, rientjes@google.com


The patch titled
     Subject: memory-hotplug: skip HWPoisoned page when offlining pages
has been added to the -mm tree.  Its filename is
     memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: memory-hotplug: skip HWPoisoned page when offlining pages

hwpoisoned may be set when we offline a page by the sysfs interface
/sys/devices/system/memory/soft_offline_page or
/sys/devices/system/memory/hard_offline_page. If we don't clear
this flag when onlining pages, this page can't be freed, and will
not in free list. So we can't offline these pages again. So we
should skip such page when offlining pages.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-isolation.h |   10 ++++++----
 mm/memory-failure.c            |    2 +-
 mm/memory_hotplug.c            |    4 ++--
 mm/page_alloc.c                |   27 +++++++++++++++++++++++----
 mm/page_isolation.c            |   27 ++++++++++++++++++++-------
 5 files changed, 52 insertions(+), 18 deletions(-)

diff -puN include/linux/page-isolation.h~memory-hotplug-skip-hwpoisoned-page-when-offlining-pages include/linux/page-isolation.h
--- a/include/linux/page-isolation.h~memory-hotplug-skip-hwpoisoned-page-when-offlining-pages
+++ a/include/linux/page-isolation.h
@@ -2,7 +2,8 @@
 #define __LINUX_PAGEISOLATION_H
 
 
-bool has_unmovable_pages(struct zone *zone, struct page *page, int count);
+bool has_unmovable_pages(struct zone *zone, struct page *page, int count,
+			 bool skip_hwpoisoned_pages);
 void set_pageblock_migratetype(struct page *page, int migratetype);
 int move_freepages_block(struct zone *zone, struct page *page,
 				int migratetype);
@@ -21,7 +22,7 @@ int move_freepages(struct zone *zone,
  */
 int
 start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
-			 unsigned migratetype);
+			 unsigned migratetype, bool skip_hwpoisoned_pages);
 
 /*
  * Changes MIGRATE_ISOLATE to MIGRATE_MOVABLE.
@@ -34,12 +35,13 @@ undo_isolate_page_range(unsigned long st
 /*
  * Test all pages in [start_pfn, end_pfn) are isolated or not.
  */
-int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn);
+int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn,
+			bool skip_hwpoisoned_pages);
 
 /*
  * Internal functions. Changes pageblock's migrate type.
  */
-int set_migratetype_isolate(struct page *page);
+int set_migratetype_isolate(struct page *page, bool skip_hwpoisoned_pages);
 void unset_migratetype_isolate(struct page *page, unsigned migratetype);
 struct page *alloc_migrate_target(struct page *page, unsigned long private,
 				int **resultp);
diff -puN mm/memory-failure.c~memory-hotplug-skip-hwpoisoned-page-when-offlining-pages mm/memory-failure.c
--- a/mm/memory-failure.c~memory-hotplug-skip-hwpoisoned-page-when-offlining-pages
+++ a/mm/memory-failure.c
@@ -1385,7 +1385,7 @@ static int get_any_page(struct page *p, 
 	 * Isolate the page, so that it doesn't get reallocated if it
 	 * was free.
 	 */
-	set_migratetype_isolate(p);
+	set_migratetype_isolate(p, true);
 	/*
 	 * When the target page is a free hugepage, just remove it
 	 * from free hugepage list.
diff -puN mm/memory_hotplug.c~memory-hotplug-skip-hwpoisoned-page-when-offlining-pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-skip-hwpoisoned-page-when-offlining-pages
+++ a/mm/memory_hotplug.c
@@ -854,7 +854,7 @@ check_pages_isolated_cb(unsigned long st
 {
 	int ret;
 	long offlined = *(long *)data;
-	ret = test_pages_isolated(start_pfn, start_pfn + nr_pages);
+	ret = test_pages_isolated(start_pfn, start_pfn + nr_pages, true);
 	offlined = nr_pages;
 	if (!ret)
 		*(long *)data += offlined;
@@ -901,7 +901,7 @@ static int __ref __offline_pages(unsigne
 	nr_pages = end_pfn - start_pfn;
 
 	/* set above range as isolated */
-	ret = start_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
+	ret = start_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE, true);
 	if (ret)
 		goto out;
 
diff -puN mm/page_alloc.c~memory-hotplug-skip-hwpoisoned-page-when-offlining-pages mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-skip-hwpoisoned-page-when-offlining-pages
+++ a/mm/page_alloc.c
@@ -5614,7 +5614,8 @@ void set_pageblock_flags_group(struct pa
  * MIGRATE_MOVABLE block might include unmovable pages. It means you can't
  * expect this function should be exact.
  */
-bool has_unmovable_pages(struct zone *zone, struct page *page, int count)
+bool has_unmovable_pages(struct zone *zone, struct page *page, int count,
+			 bool skip_hwpoisoned_pages)
 {
 	unsigned long pfn, iter, found;
 	int mt;
@@ -5649,6 +5650,13 @@ bool has_unmovable_pages(struct zone *zo
 			continue;
 		}
 
+		/*
+		 * The HWPoisoned page may be not in buddy system, and
+		 * page_count() is not 0.
+		 */
+		if (skip_hwpoisoned_pages && PageHWPoison(page))
+			continue;
+
 		if (!PageLRU(page))
 			found++;
 		/*
@@ -5691,7 +5699,7 @@ bool is_pageblock_removable_nolock(struc
 			zone->zone_start_pfn + zone->spanned_pages <= pfn)
 		return false;
 
-	return !has_unmovable_pages(zone, page, 0);
+	return !has_unmovable_pages(zone, page, 0, true);
 }
 
 #ifdef CONFIG_CMA
@@ -5862,7 +5870,8 @@ int alloc_contig_range(unsigned long sta
 	 */
 
 	ret = start_isolate_page_range(pfn_max_align_down(start),
-				       pfn_max_align_up(end), migratetype);
+				       pfn_max_align_up(end), migratetype,
+				       false);
 	if (ret)
 		goto done;
 
@@ -5901,7 +5910,7 @@ int alloc_contig_range(unsigned long sta
 	}
 
 	/* Make sure the range is really isolated. */
-	if (test_pages_isolated(outer_start, end)) {
+	if (test_pages_isolated(outer_start, end, false)) {
 		pr_warn("alloc_contig_range test_pages_isolated(%lx, %lx) failed\n",
 		       outer_start, end);
 		ret = -EBUSY;
@@ -6016,6 +6025,16 @@ __offline_isolated_pages(unsigned long s
 			continue;
 		}
 		page = pfn_to_page(pfn);
+		/*
+		 * The HWPoisoned page may be not in buddy system, and
+		 * page_count() is not 0.
+		 */
+		if (unlikely(!PageBuddy(page) && PageHWPoison(page))) {
+			pfn++;
+			SetPageReserved(page);
+			continue;
+		}
+
 		BUG_ON(page_count(page));
 		BUG_ON(!PageBuddy(page));
 		order = page_order(page);
diff -puN mm/page_isolation.c~memory-hotplug-skip-hwpoisoned-page-when-offlining-pages mm/page_isolation.c
--- a/mm/page_isolation.c~memory-hotplug-skip-hwpoisoned-page-when-offlining-pages
+++ a/mm/page_isolation.c
@@ -30,7 +30,7 @@ static void restore_pageblock_isolate(st
 	zone->nr_pageblock_isolate--;
 }
 
-int set_migratetype_isolate(struct page *page)
+int set_migratetype_isolate(struct page *page, bool skip_hwpoisoned_pages)
 {
 	struct zone *zone;
 	unsigned long flags, pfn;
@@ -66,7 +66,8 @@ int set_migratetype_isolate(struct page 
 	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
 	 * We just check MOVABLE pages.
 	 */
-	if (!has_unmovable_pages(zone, page, arg.pages_found))
+	if (!has_unmovable_pages(zone, page, arg.pages_found,
+				 skip_hwpoisoned_pages))
 		ret = 0;
 
 	/*
@@ -134,7 +135,7 @@ __first_valid_page(unsigned long pfn, un
  * Returns 0 on success and -EBUSY if any part of range cannot be isolated.
  */
 int start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
-			     unsigned migratetype)
+			     unsigned migratetype, bool skip_hwpoisoned_pages)
 {
 	unsigned long pfn;
 	unsigned long undo_pfn;
@@ -147,7 +148,8 @@ int start_isolate_page_range(unsigned lo
 	     pfn < end_pfn;
 	     pfn += pageblock_nr_pages) {
 		page = __first_valid_page(pfn, pageblock_nr_pages);
-		if (page && set_migratetype_isolate(page)) {
+		if (page &&
+		    set_migratetype_isolate(page, skip_hwpoisoned_pages)) {
 			undo_pfn = pfn;
 			goto undo;
 		}
@@ -190,7 +192,8 @@ int undo_isolate_page_range(unsigned lon
  * Returns 1 if all pages in the range are isolated.
  */
 static int
-__test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn)
+__test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn,
+				  bool skip_hwpoisoned_pages)
 {
 	struct page *page;
 
@@ -220,6 +223,14 @@ __test_page_isolated_in_pageblock(unsign
 		else if (page_count(page) == 0 &&
 			get_freepage_migratetype(page) == MIGRATE_ISOLATE)
 			pfn += 1;
+		else if (skip_hwpoisoned_pages && PageHWPoison(page)) {
+			/*
+			 * The HWPoisoned page may be not in buddy
+			 * system, and page_count() is not 0.
+			 */
+			pfn++;
+			continue;
+		}
 		else
 			break;
 	}
@@ -228,7 +239,8 @@ __test_page_isolated_in_pageblock(unsign
 	return 1;
 }
 
-int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn)
+int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn,
+			bool skip_hwpoisoned_pages)
 {
 	unsigned long pfn, flags;
 	struct page *page;
@@ -251,7 +263,8 @@ int test_pages_isolated(unsigned long st
 	/* Check all pages are free or Marked as ISOLATED */
 	zone = page_zone(page);
 	spin_lock_irqsave(&zone->lock, flags);
-	ret = __test_page_isolated_in_pageblock(start_pfn, end_pfn);
+	ret = __test_page_isolated_in_pageblock(start_pfn, end_pfn,
+						skip_hwpoisoned_pages);
 	spin_unlock_irqrestore(&zone->lock, flags);
 	return ret ? 0 : -EBUSY;
 }
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch

