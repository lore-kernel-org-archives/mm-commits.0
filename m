From: akpm@linux-foundation.org
Subject: + mm-rename-and-move-get-set_freepage_migratetype.patch added to
 -mm tree
Date: Tue, 21 Jul 2015 14:55:18 -0700
Message-ID: <55aebfc6.pIvH+Qhgcq4RdR/s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933511AbbGUVzT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jul 2015 17:55:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, lauraa@codeaurora.org, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, seungho1.park@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename and move get/set_freepage_migratetype
has been added to the -mm tree.  Its filename is
     mm-rename-and-move-get-set_freepage_migratetype.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rename-and-move-get-set_freepage_migratetype.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-and-move-get-set_freepage_migratetype.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: rename and move get/set_freepage_migratetype

The pair of get/set_freepage_migratetype() functions are used to cache
pageblock migratetype for a page put on a pcplist, so that it does not
have to be retrieved again when the page is put on a free list (e.g.  when
pcplists become full).  Historically it was also assumed that the value is
accurate for pages on freelists (as the functions' names unfortunately
suggest), but that cannot be guaranteed without affecting various
allocator fast paths.  It is in fact not needed and all such uses have
been removed.

The last remaining (but pointless) usage related to pages of freelists is
in move_freepages(), which this patch removes.

To prevent further confusion, rename the functions to
get/set_pcppage_migratetype() and expand their description.  Since all the
users are now in mm/page_alloc.c, move the functions there from the shared
header.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Seungho Park <seungho1.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   12 ------------
 mm/page_alloc.c    |   42 +++++++++++++++++++++++++++++-------------
 2 files changed, 29 insertions(+), 25 deletions(-)

diff -puN include/linux/mm.h~mm-rename-and-move-get-set_freepage_migratetype include/linux/mm.h
--- a/include/linux/mm.h~mm-rename-and-move-get-set_freepage_migratetype
+++ a/include/linux/mm.h
@@ -310,18 +310,6 @@ struct inode;
 #define page_private(page)		((page)->private)
 #define set_page_private(page, v)	((page)->private = (v))
 
-/* It's valid only if the page is free path or free_list */
-static inline void set_freepage_migratetype(struct page *page, int migratetype)
-{
-	page->index = migratetype;
-}
-
-/* It's valid only if the page is free path or free_list */
-static inline int get_freepage_migratetype(struct page *page)
-{
-	return page->index;
-}
-
 /*
  * FIXME: take this include out, include page-flags.h in
  * files which need it (119 of them)
diff -puN mm/page_alloc.c~mm-rename-and-move-get-set_freepage_migratetype mm/page_alloc.c
--- a/mm/page_alloc.c~mm-rename-and-move-get-set_freepage_migratetype
+++ a/mm/page_alloc.c
@@ -125,6 +125,24 @@ unsigned long dirty_balance_reserve __re
 int percpu_pagelist_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 
+/*
+ * A cached value of the page's pageblock's migratetype, used when the page is
+ * put on a pcplist. Used to avoid the pageblock migratetype lookup when
+ * freeing from pcplists in most cases, at the cost of possibly becoming stale.
+ * Also the migratetype set in the page does not necessarily match the pcplist
+ * index, e.g. page might have MIGRATE_CMA set but be on a pcplist with any
+ * other index - this ensures that it will be put on the correct CMA freelist.
+ */
+static inline int get_pcppage_migratetype(struct page *page)
+{
+	return page->index;
+}
+
+static inline void set_pcppage_migratetype(struct page *page, int migratetype)
+{
+	page->index = migratetype;
+}
+
 #ifdef CONFIG_PM_SLEEP
 /*
  * The following functions are used by the suspend/hibernate code to temporarily
@@ -788,7 +806,7 @@ static void free_pcppages_bulk(struct zo
 			page = list_entry(list->prev, struct page, lru);
 			/* must delete as __free_one_page list manipulates */
 			list_del(&page->lru);
-			mt = get_freepage_migratetype(page);
+			mt = get_pcppage_migratetype(page);
 			if (unlikely(has_isolate_pageblock(zone)))
 				mt = get_pageblock_migratetype(page);
 
@@ -952,7 +970,7 @@ static void __free_pages_ok(struct page
 	migratetype = get_pfnblock_migratetype(page, pfn);
 	local_irq_save(flags);
 	__count_vm_events(PGFREE, 1 << order);
-	set_freepage_migratetype(page, migratetype);
+	set_pcppage_migratetype(page, migratetype);
 	free_one_page(page_zone(page), page, pfn, order, migratetype);
 	local_irq_restore(flags);
 }
@@ -1373,7 +1391,7 @@ struct page *__rmqueue_smallest(struct z
 		rmv_page_order(page);
 		area->nr_free--;
 		expand(zone, page, order, current_order, area, migratetype);
-		set_freepage_migratetype(page, migratetype);
+		set_pcppage_migratetype(page, migratetype);
 		return page;
 	}
 
@@ -1450,7 +1468,6 @@ int move_freepages(struct zone *zone,
 		order = page_order(page);
 		list_move(&page->lru,
 			  &zone->free_area[order].free_list[migratetype]);
-		set_freepage_migratetype(page, migratetype);
 		page += 1 << order;
 		pages_moved += 1 << order;
 	}
@@ -1620,14 +1637,13 @@ __rmqueue_fallback(struct zone *zone, un
 		expand(zone, page, order, current_order, area,
 					start_migratetype);
 		/*
-		 * The freepage_migratetype may differ from pageblock's
+		 * The pcppage_migratetype may differ from pageblock's
 		 * migratetype depending on the decisions in
-		 * try_to_steal_freepages(). This is OK as long as it
-		 * does not differ for MIGRATE_CMA pageblocks. For CMA
-		 * we need to make sure unallocated pages flushed from
-		 * pcp lists are returned to the correct freelist.
+		 * find_suitable_fallback(). This is OK as long as it does not
+		 * differ for MIGRATE_CMA pageblocks. Those can be used as
+		 * fallback only via special __rmqueue_cma_fallback() function
 		 */
-		set_freepage_migratetype(page, start_migratetype);
+		set_pcppage_migratetype(page, start_migratetype);
 
 		trace_mm_page_alloc_extfrag(page, order, current_order,
 			start_migratetype, fallback_mt);
@@ -1703,7 +1719,7 @@ static int rmqueue_bulk(struct zone *zon
 		else
 			list_add_tail(&page->lru, list);
 		list = &page->lru;
-		if (is_migrate_cma(get_freepage_migratetype(page)))
+		if (is_migrate_cma(get_pcppage_migratetype(page)))
 			__mod_zone_page_state(zone, NR_FREE_CMA_PAGES,
 					      -(1 << order));
 	}
@@ -1900,7 +1916,7 @@ void free_hot_cold_page(struct page *pag
 		return;
 
 	migratetype = get_pfnblock_migratetype(page, pfn);
-	set_freepage_migratetype(page, migratetype);
+	set_pcppage_migratetype(page, migratetype);
 	local_irq_save(flags);
 	__count_vm_event(PGFREE);
 
@@ -2105,7 +2121,7 @@ struct page *buffered_rmqueue(struct zon
 		if (!page)
 			goto failed;
 		__mod_zone_freepage_state(zone, -(1 << order),
-					  get_freepage_migratetype(page));
+					  get_pcppage_migratetype(page));
 	}
 
 	__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4.patch
mm-gup-add-mm_lock_present.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4.patch
selftests-vm-add-tests-for-lock-on-fault.patch
selftests-vm-add-tests-for-lock-on-fault-v4.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
mm-rename-and-move-get-set_freepage_migratetype.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix-fix.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch

