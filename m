From: akpm@linux-foundation.org
Subject: + mm-introduce-page_lru_base_type.patch added to -mm tree
Date: Wed, 12 Aug 2009 15:57:04 -0700
Message-ID: <200908122257.n7CMv4XP021472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752725AbZHLW50 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Aug 2009 18:57:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: introduce page_lru_base_type()
has been added to the -mm tree.  Its filename is
     mm-introduce-page_lru_base_type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: introduce page_lru_base_type()
From: Johannes Weiner <hannes@cmpxchg.org>

Instead of abusing page_is_file_cache() for LRU list index arithmetic, add
another helper with a more appropriate name and convert the non-boolean
users of page_is_file_cache() accordingly.

This new helper gives the LRU base type a page is supposed to live on,
inactive anon or inactive file.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   19 +++++++++++++++++--
 mm/swap.c                 |    4 ++--
 mm/vmscan.c               |    6 +++---
 3 files changed, 22 insertions(+), 7 deletions(-)

diff -puN include/linux/mm_inline.h~mm-introduce-page_lru_base_type include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-introduce-page_lru_base_type
+++ a/include/linux/mm_inline.h
@@ -60,6 +60,21 @@ del_page_from_lru(struct zone *zone, str
 }
 
 /**
+ * page_lru_base_type - which LRU list type should a page be on?
+ * @page: the page to test
+ *
+ * Used for LRU list index arithmetic.
+ *
+ * Returns the base LRU type - file or anon - @page should be on.
+ */
+static enum lru_list page_lru_base_type(struct page *page)
+{
+	if (page_is_file_cache(page))
+		return LRU_INACTIVE_FILE;
+	return LRU_INACTIVE_ANON;
+}
+
+/**
  * page_lru - which LRU list should a page be on?
  * @page: the page to test
  *
@@ -68,14 +83,14 @@ del_page_from_lru(struct zone *zone, str
  */
 static inline enum lru_list page_lru(struct page *page)
 {
-	enum lru_list lru = LRU_BASE;
+	enum lru_list lru;
 
 	if (PageUnevictable(page))
 		lru = LRU_UNEVICTABLE;
 	else {
+		lru = page_lru_base_type(page);
 		if (PageActive(page))
 			lru += LRU_ACTIVE;
-		lru += page_is_file_cache(page);
 	}
 
 	return lru;
diff -puN mm/swap.c~mm-introduce-page_lru_base_type mm/swap.c
--- a/mm/swap.c~mm-introduce-page_lru_base_type
+++ a/mm/swap.c
@@ -118,7 +118,7 @@ static void pagevec_move_tail(struct pag
 			spin_lock(&zone->lru_lock);
 		}
 		if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
-			int lru = page_is_file_cache(page);
+			int lru = page_lru_base_type(page);
 			list_move_tail(&page->lru, &zone->lru[lru].list);
 			pgmoved++;
 		}
@@ -181,7 +181,7 @@ void activate_page(struct page *page)
 	spin_lock_irq(&zone->lru_lock);
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 		int file = page_is_file_cache(page);
-		int lru = LRU_BASE + file;
+		int lru = page_lru_base_type(page);
 		del_page_from_lru_list(zone, page, lru);
 
 		SetPageActive(page);
diff -puN mm/vmscan.c~mm-introduce-page_lru_base_type mm/vmscan.c
--- a/mm/vmscan.c~mm-introduce-page_lru_base_type
+++ a/mm/vmscan.c
@@ -531,7 +531,7 @@ redo:
 		 * unevictable page on [in]active list.
 		 * We know how to handle that.
 		 */
-		lru = active + page_is_file_cache(page);
+		lru = active + page_lru_base_type(page);
 		lru_cache_add_lru(page, lru);
 	} else {
 		/*
@@ -981,7 +981,7 @@ static unsigned long clear_active_flags(
 	struct page *page;
 
 	list_for_each_entry(page, page_list, lru) {
-		lru = page_is_file_cache(page);
+		lru = page_lru_base_type(page);
 		if (PageActive(page)) {
 			lru += LRU_ACTIVE;
 			ClearPageActive(page);
@@ -2647,7 +2647,7 @@ static void check_move_unevictable_page(
 retry:
 	ClearPageUnevictable(page);
 	if (page_evictable(page, NULL)) {
-		enum lru_list l = LRU_INACTIVE_ANON + page_is_file_cache(page);
+		enum lru_list l = page_lru_base_type(page);
 
 		__dec_zone_state(zone, NR_UNEVICTABLE);
 		list_move(&page->lru, &zone->lru[l].list);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
vfs-make-get_sb_pseudo-set-s_maxbytes-to-value-that-can-be-cast-to-signed.patch
linux-next.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch
mm-make-swap-token-dummies-static-inlines.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
mm-count-only-reclaimable-lru-pages-v2.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
mm-drop-unneeded-double-negations.patch
mm-introduce-page_lru_base_type.patch
mm-return-boolean-from-page_is_file_cache.patch
mm-return-boolean-from-page_has_private.patch
mm-document-is_page_cache_freeable.patch

