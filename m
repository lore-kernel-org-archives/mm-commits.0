From: akpm@linux-foundation.org
Subject: [merged] mm-introduce-page_lru_base_type.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:41:42 -0700
Message-ID: <200909222041.n8MKfgla008077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752639AbZIVUlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:41:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: introduce page_lru_base_type()
has been removed from the -mm tree.  Its filename was
     mm-introduce-page_lru_base_type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: introduce page_lru_base_type()
From: Johannes Weiner <hannes@cmpxchg.org>

Instead of abusing page_is_file_cache() for LRU list index arithmetic, add
another helper with a more appropriate name and convert the non-boolean
users of page_is_file_cache() accordingly.

This new helper gives the LRU base type a page is supposed to live on,
inactive anon or inactive file.

[hugh.dickins@tiscali.co.uk: convert del_page_from_lru() also]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   23 +++++++++++++++++++----
 mm/swap.c                 |    4 ++--
 mm/vmscan.c               |    6 +++---
 3 files changed, 24 insertions(+), 9 deletions(-)

diff -puN include/linux/mm_inline.h~mm-introduce-page_lru_base_type include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-introduce-page_lru_base_type
+++ a/include/linux/mm_inline.h
@@ -39,21 +39,36 @@ del_page_from_lru_list(struct zone *zone
 	mem_cgroup_del_lru_list(page, l);
 }
 
+/**
+ * page_lru_base_type - which LRU list type should a page be on?
+ * @page: the page to test
+ *
+ * Used for LRU list index arithmetic.
+ *
+ * Returns the base LRU type - file or anon - @page should be on.
+ */
+static inline enum lru_list page_lru_base_type(struct page *page)
+{
+	if (page_is_file_cache(page))
+		return LRU_INACTIVE_FILE;
+	return LRU_INACTIVE_ANON;
+}
+
 static inline void
 del_page_from_lru(struct zone *zone, struct page *page)
 {
-	enum lru_list l = LRU_BASE;
+	enum lru_list l;
 
 	list_del(&page->lru);
 	if (PageUnevictable(page)) {
 		__ClearPageUnevictable(page);
 		l = LRU_UNEVICTABLE;
 	} else {
+		l = page_lru_base_type(page);
 		if (PageActive(page)) {
 			__ClearPageActive(page);
 			l += LRU_ACTIVE;
 		}
-		l += page_is_file_cache(page);
 	}
 	__dec_zone_state(zone, NR_LRU_BASE + l);
 	mem_cgroup_del_lru_list(page, l);
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
@@ -986,7 +986,7 @@ static unsigned long clear_active_flags(
 	struct page *page;
 
 	list_for_each_entry(page, page_list, lru) {
-		lru = page_is_file_cache(page);
+		lru = page_lru_base_type(page);
 		if (PageActive(page)) {
 			lru += LRU_ACTIVE;
 			ClearPageActive(page);
@@ -2652,7 +2652,7 @@ static void check_move_unevictable_page(
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
linux-next.patch
vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch

