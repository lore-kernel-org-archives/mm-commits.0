From: akpm@linux-foundation.org
Subject: +
 mm-compaction-split-freepages-without-holding-the-zone-lock.patch added to
 -mm tree
Date: Thu, 02 Jun 2016 12:49:25 -0700
Message-ID: <57508dc5.5ymFdt1ujkONsccs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbcFBTt1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 15:49:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, glider@google.com, hughd@google.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: split freepages without holding the zone lock
has been added to the -mm tree.  Its filename is
     mm-compaction-split-freepages-without-holding-the-zone-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-split-freepages-without-holding-the-zone-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-split-freepages-without-holding-the-zone-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/compaction: split freepages without holding the zone lock

We don't need to split freepages with holding the zone lock.  It will
cause more contention on zone lock so not desirable.

Link: http://lkml.kernel.org/r/1464230275-25791-1-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 mm/compaction.c    |   42 ++++++++++++++++++++++++++++++------------
 mm/page_alloc.c    |   27 ---------------------------
 3 files changed, 30 insertions(+), 40 deletions(-)

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
@@ -476,13 +495,12 @@ static unsigned long isolate_freepages_b
 				goto isolate_fail;
 		}
 
-		/* Found a free page, break it into order-0 pages */
-		isolated = split_free_page(page);
+		/* Found a free page, will break it into order-0 pages */
+		order = page_order(page);
+		isolated = __isolate_free_page(page, page_order(page));
+		set_page_private(page, order);
 		total_isolated += isolated;
-		for (i = 0; i < isolated; i++) {
-			list_add(&page->lru, freelist);
-			page++;
-		}
+		list_add_tail(&page->lru, freelist);
 
 		/* If a page was split, advance to the end of it */
 		if (isolated) {
diff -puN mm/page_alloc.c~mm-compaction-split-freepages-without-holding-the-zone-lock mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-split-freepages-without-holding-the-zone-lock
+++ a/mm/page_alloc.c
@@ -2525,33 +2525,6 @@ int __isolate_free_page(struct page *pag
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
