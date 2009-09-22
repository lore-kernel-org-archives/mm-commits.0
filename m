From: akpm@linux-foundation.org
Subject: [merged] mm-return-boolean-from-page_is_file_cache.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:41:45 -0700
Message-ID: <200909222041.n8MKfjFK008224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782AbZIVUlr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:41:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: return boolean from page_is_file_cache()
has been removed from the -mm tree.  Its filename was
     mm-return-boolean-from-page_is_file_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: return boolean from page_is_file_cache()
From: Johannes Weiner <hannes@cmpxchg.org>

page_is_file_cache() has been used for both boolean checks and LRU
arithmetic, which was always a bit weird.

Now that page_lru_base_type() exists for LRU arithmetic, make
page_is_file_cache() a real predicate function and adjust the
boolean-using callsites to drop those pesky double negations.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    8 ++------
 mm/migrate.c              |    6 +++---
 mm/swap.c                 |    2 +-
 mm/vmscan.c               |    2 +-
 4 files changed, 7 insertions(+), 11 deletions(-)

diff -puN include/linux/mm_inline.h~mm-return-boolean-from-page_is_file_cache include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-return-boolean-from-page_is_file_cache
+++ a/include/linux/mm_inline.h
@@ -5,7 +5,7 @@
  * page_is_file_cache - should the page be on a file LRU or anon LRU?
  * @page: the page to test
  *
- * Returns LRU_FILE if @page is page cache page backed by a regular filesystem,
+ * Returns 1 if @page is page cache page backed by a regular filesystem,
  * or 0 if @page is anonymous, tmpfs or otherwise ram or swap backed.
  * Used by functions that manipulate the LRU lists, to sort a page
  * onto the right LRU list.
@@ -16,11 +16,7 @@
  */
 static inline int page_is_file_cache(struct page *page)
 {
-	if (PageSwapBacked(page))
-		return 0;
-
-	/* The page is page cache backed by a normal filesystem. */
-	return LRU_FILE;
+	return !PageSwapBacked(page);
 }
 
 static inline void
diff -puN mm/migrate.c~mm-return-boolean-from-page_is_file_cache mm/migrate.c
--- a/mm/migrate.c~mm-return-boolean-from-page_is_file_cache
+++ a/mm/migrate.c
@@ -68,7 +68,7 @@ int putback_lru_pages(struct list_head *
 	list_for_each_entry_safe(page, page2, l, lru) {
 		list_del(&page->lru);
 		dec_zone_page_state(page, NR_ISOLATED_ANON +
-				    !!page_is_file_cache(page));
+				page_is_file_cache(page));
 		putback_lru_page(page);
 		count++;
 	}
@@ -701,7 +701,7 @@ unlock:
  		 */
  		list_del(&page->lru);
 		dec_zone_page_state(page, NR_ISOLATED_ANON +
-				    !!page_is_file_cache(page));
+				page_is_file_cache(page));
 		putback_lru_page(page);
 	}
 
@@ -751,7 +751,7 @@ int migrate_pages(struct list_head *from
 	local_irq_save(flags);
 	list_for_each_entry(page, from, lru)
 		__inc_zone_page_state(page, NR_ISOLATED_ANON +
-				      !!page_is_file_cache(page));
+				page_is_file_cache(page));
 	local_irq_restore(flags);
 
 	if (!swapwrite)
diff -puN mm/swap.c~mm-return-boolean-from-page_is_file_cache mm/swap.c
--- a/mm/swap.c~mm-return-boolean-from-page_is_file_cache
+++ a/mm/swap.c
@@ -189,7 +189,7 @@ void activate_page(struct page *page)
 		add_page_to_lru_list(zone, page, lru);
 		__count_vm_event(PGACTIVATE);
 
-		update_page_reclaim_stat(zone, page, !!file, 1);
+		update_page_reclaim_stat(zone, page, file, 1);
 	}
 	spin_unlock_irq(&zone->lru_lock);
 }
diff -puN mm/vmscan.c~mm-return-boolean-from-page_is_file_cache mm/vmscan.c
--- a/mm/vmscan.c~mm-return-boolean-from-page_is_file_cache
+++ a/mm/vmscan.c
@@ -821,7 +821,7 @@ int __isolate_lru_page(struct page *page
 	if (mode != ISOLATE_BOTH && (!PageActive(page) != !mode))
 		return ret;
 
-	if (mode != ISOLATE_BOTH && (!page_is_file_cache(page) != !file))
+	if (mode != ISOLATE_BOTH && page_is_file_cache(page) != file)
 		return ret;
 
 	/*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch

