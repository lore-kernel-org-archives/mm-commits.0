From: akpm@linux-foundation.org
Subject: [patch 055/126] mm/compaction: split freepages without holding
 the zone lock
Date: Tue, 26 Jul 2016 15:23:40 -0700
Message-ID: <5797e2ec.m42ZsPbvodlVXqG+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758191AbcGZWXl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:23:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, glider@google.com, hughd@google.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, rientjes@google.com, vbabka@suse.cz

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/compaction: split freepages without holding the zone lock

We don't need to split freepages with holding the zone lock.  It will
cause more contention on zone lock so not desirable.

[rientjes@google.com: if __isolate_free_page() fails, avoid adding to freelist so we don't call map_pages() with it]
  Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1606211447001.43430@chino.kir.corp.google.com
Link: http://lkml.kernel.org/r/1464230275-25791-1-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 
 mm/compaction.c    |   47 ++++++++++++++++++++++++++++++-------------
 mm/page_alloc.c    |   27 ------------------------
 3 files changed, 33 insertions(+), 42 deletions(-)

diff -puN include/linux/mm.h~mm-compaction-split-freepages-without-holding-the-zone-lock include/linux/mm.h
--- a/include/linux/mm.h~mm-compaction-split-freepages-without-holding-the-zone-lock
+++ a/include/linux/mm.h
@@ -537,7 +537,6 @@ void __put_page(struct page *page);
 void put_pages_list(struct list_head *pages);
 
 void split_page(struct page *page, unsigned int order);
-int split_free_page(struct page *page);
 
 /*
  * Compound pages have a destructor function.  Provide a
diff -puN mm/compaction.c~mm-compaction-split-freepages-without-holding-the-zone-lock mm/compaction.c
--- a/mm/compaction.c~mm-compaction-split-freepages-without-holding-the-zone-lock
+++ a/mm/compaction.c
@@ -64,13 +64,31 @@ static unsigned long release_freepages(s
 
 static void map_pages(struct list_head *list)
 {
-	struct page *page;
+	unsigned int i, order, nr_pages;
+	struct page *page, *next;
+	LIST_HEAD(tmp_list);
+
+	list_for_each_entry_safe(page, next, list, lru) {
+		list_del(&page->lru);
+
+		order = page_private(page);
+		nr_pages = 1 << order;
+		set_page_private(page, 0);
+		set_page_refcounted(page);
+
+		arch_alloc_page(page, order);
+		kernel_map_pages(page, nr_pages, 1);
+		kasan_alloc_pages(page, order);
+		if (order)
+			split_page(page, order);
 
-	list_for_each_entry(page, list, lru) {
-		arch_alloc_page(page, 0);
-		kernel_map_pages(page, 1, 1);
-		kasan_alloc_pages(page, 0);
+		for (i = 0; i < nr_pages; i++) {
+			list_add(&page->lru, &tmp_list);
+			page++;
+		}
 	}
+
+	list_splice(&tmp_list, list);
 }
 
 static inline bool migrate_async_suitable(int migratetype)
@@ -405,12 +423,13 @@ static unsigned long isolate_freepages_b
 	unsigned long flags = 0;
 	bool locked = false;
 	unsigned long blockpfn = *start_pfn;
+	unsigned int order;
 
 	cursor = pfn_to_page(blockpfn);
 
 	/* Isolate free pages. */
 	for (; blockpfn < end_pfn; blockpfn++, cursor++) {
-		int isolated, i;
+		int isolated;
 		struct page *page = cursor;
 
 		/*
@@ -476,17 +495,17 @@ static unsigned long isolate_freepages_b
 				goto isolate_fail;
 		}
 
-		/* Found a free page, break it into order-0 pages */
-		isolated = split_free_page(page);
+		/* Found a free page, will break it into order-0 pages */
+		order = page_order(page);
+		isolated = __isolate_free_page(page, order);
 		if (!isolated)
 			break;
+		set_page_private(page, order);
 
 		total_isolated += isolated;
 		cc->nr_freepages += isolated;
-		for (i = 0; i < isolated; i++) {
-			list_add(&page->lru, freelist);
-			page++;
-		}
+		list_add_tail(&page->lru, freelist);
+
 		if (!strict && cc->nr_migratepages <= cc->nr_freepages) {
 			blockpfn += isolated;
 			break;
@@ -605,7 +624,7 @@ isolate_freepages_range(struct compact_c
 		 */
 	}
 
-	/* split_free_page does not map the pages */
+	/* __isolate_free_page() does not map the pages */
 	map_pages(&freelist);
 
 	if (pfn < end_pfn) {
@@ -1102,7 +1121,7 @@ static void isolate_freepages(struct com
 		}
 	}
 
-	/* split_free_page does not map the pages */
+	/* __isolate_free_page() does not map the pages */
 	map_pages(freelist);
 
 	/*
diff -puN mm/page_alloc.c~mm-compaction-split-freepages-without-holding-the-zone-lock mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-split-freepages-without-holding-the-zone-lock
+++ a/mm/page_alloc.c
@@ -2527,33 +2527,6 @@ int __isolate_free_page(struct page *pag
 }
 
 /*
- * Similar to split_page except the page is already free. As this is only
- * being used for migration, the migratetype of the block also changes.
- * As this is called with interrupts disabled, the caller is responsible
- * for calling arch_alloc_page() and kernel_map_page() after interrupts
- * are enabled.
- *
- * Note: this is probably too low level an operation for use in drivers.
- * Please consult with lkml before using this in your driver.
- */
-int split_free_page(struct page *page)
-{
-	unsigned int order;
-	int nr_pages;
-
-	order = page_order(page);
-
-	nr_pages = __isolate_free_page(page, order);
-	if (!nr_pages)
-		return 0;
-
-	/* Split into individual pages */
-	set_page_refcounted(page);
-	split_page(page, order);
-	return nr_pages;
-}
