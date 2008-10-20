From: akpm@linux-foundation.org
Subject: - vmscan-free-swap-space-on-swap-in-activation.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:32:34 -0700
Message-ID: <200810202032.m9KKWYkp010429@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753994AbYJTUiZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:38:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, Lee.Schermerhorn@hp.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: free swap space on swap-in/activation
has been removed from the -mm tree.  Its filename was
     vmscan-free-swap-space-on-swap-in-activation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: free swap space on swap-in/activation
From: Rik van Riel <riel@redhat.com>

If vm_swap_full() (swap space more than 50% full), the system will free
swap space at swapin time.  With this patch, the system will also free the
swap space in the pageout code, when we decide that the page is not a
candidate for swapout (and just wasting swap space).

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    1 +
 include/linux/swap.h    |    6 ++++++
 mm/swap.c               |   24 ++++++++++++++++++++++++
 mm/swapfile.c           |   25 ++++++++++++++++++++++---
 mm/vmscan.c             |    7 +++++++
 5 files changed, 60 insertions(+), 3 deletions(-)

diff -puN include/linux/pagevec.h~vmscan-free-swap-space-on-swap-in-activation include/linux/pagevec.h
--- a/include/linux/pagevec.h~vmscan-free-swap-space-on-swap-in-activation
+++ a/include/linux/pagevec.h
@@ -25,6 +25,7 @@ void __pagevec_release_nonlru(struct pag
 void __pagevec_free(struct pagevec *pvec);
 void ____pagevec_lru_add(struct pagevec *pvec, enum lru_list lru);
 void pagevec_strip(struct pagevec *pvec);
+void pagevec_swap_free(struct pagevec *pvec);
 unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
 		pgoff_t start, unsigned nr_pages);
 unsigned pagevec_lookup_tag(struct pagevec *pvec,
diff -puN include/linux/swap.h~vmscan-free-swap-space-on-swap-in-activation include/linux/swap.h
--- a/include/linux/swap.h~vmscan-free-swap-space-on-swap-in-activation
+++ a/include/linux/swap.h
@@ -265,6 +265,7 @@ extern sector_t swapdev_block(int, pgoff
 extern struct swap_info_struct *get_swap_info_struct(unsigned);
 extern int can_share_swap_page(struct page *);
 extern int remove_exclusive_swap_page(struct page *);
+extern int remove_exclusive_swap_page_ref(struct page *);
 struct backing_dev_info;
 
 /* linux/mm/thrash.c */
@@ -353,6 +354,11 @@ static inline int remove_exclusive_swap_
 	return 0;
 }
 
+static inline int remove_exclusive_swap_page_ref(struct page *page)
+{
+	return 0;
+}
+
 static inline swp_entry_t get_swap_page(void)
 {
 	swp_entry_t entry;
diff -puN mm/swap.c~vmscan-free-swap-space-on-swap-in-activation mm/swap.c
--- a/mm/swap.c~vmscan-free-swap-space-on-swap-in-activation
+++ a/mm/swap.c
@@ -428,6 +428,30 @@ void pagevec_strip(struct pagevec *pvec)
 }
 
 /**
+ * pagevec_swap_free - try to free swap space from the pages in a pagevec
+ * @pvec: pagevec with swapcache pages to free the swap space of
+ *
+ * The caller needs to hold an extra reference to each page and
+ * not hold the page lock on the pages.  This function uses a
+ * trylock on the page lock so it may not always free the swap
+ * space associated with a page.
+ */
+void pagevec_swap_free(struct pagevec *pvec)
+{
+	int i;
+
+	for (i = 0; i < pagevec_count(pvec); i++) {
+		struct page *page = pvec->pages[i];
+
+		if (PageSwapCache(page) && trylock_page(page)) {
+			if (PageSwapCache(page))
+				remove_exclusive_swap_page_ref(page);
+			unlock_page(page);
+		}
+	}
+}
+
+/**
  * pagevec_lookup - gang pagecache lookup
  * @pvec:	Where the resulting pages are placed
  * @mapping:	The address_space to search
diff -puN mm/swapfile.c~vmscan-free-swap-space-on-swap-in-activation mm/swapfile.c
--- a/mm/swapfile.c~vmscan-free-swap-space-on-swap-in-activation
+++ a/mm/swapfile.c
@@ -344,7 +344,7 @@ int can_share_swap_page(struct page *pag
  * Work out if there are any other processes sharing this
  * swap cache page. Free it if you can. Return success.
  */
-int remove_exclusive_swap_page(struct page *page)
+static int remove_exclusive_swap_page_count(struct page *page, int count)
 {
 	int retval;
 	struct swap_info_struct * p;
@@ -357,7 +357,7 @@ int remove_exclusive_swap_page(struct pa
 		return 0;
 	if (PageWriteback(page))
 		return 0;
-	if (page_count(page) != 2) /* 2: us + cache */
+	if (page_count(page) != count) /* us + cache + ptes */
 		return 0;
 
 	entry.val = page_private(page);
@@ -370,7 +370,7 @@ int remove_exclusive_swap_page(struct pa
 	if (p->swap_map[swp_offset(entry)] == 1) {
 		/* Recheck the page count with the swapcache lock held.. */
 		spin_lock_irq(&swapper_space.tree_lock);
-		if ((page_count(page) == 2) && !PageWriteback(page)) {
+		if ((page_count(page) == count) && !PageWriteback(page)) {
 			__delete_from_swap_cache(page);
 			SetPageDirty(page);
 			retval = 1;
@@ -388,6 +388,25 @@ int remove_exclusive_swap_page(struct pa
 }
 
 /*
+ * Most of the time the page should have two references: one for the
+ * process and one for the swap cache.
+ */
+int remove_exclusive_swap_page(struct page *page)
+{
+	return remove_exclusive_swap_page_count(page, 2);
+}
+
+/*
+ * The pageout code holds an extra reference to the page.  That raises
+ * the reference count to test for to 2 for a page that is only in the
+ * swap cache plus 1 for each process that maps the page.
+ */
+int remove_exclusive_swap_page_ref(struct page *page)
+{
+	return remove_exclusive_swap_page_count(page, 2 + page_mapcount(page));
+}
+
+/*
  * Free the swap entry like above, but also try to
  * free the page cache entry if it is the last user.
  */
diff -puN mm/vmscan.c~vmscan-free-swap-space-on-swap-in-activation mm/vmscan.c
--- a/mm/vmscan.c~vmscan-free-swap-space-on-swap-in-activation
+++ a/mm/vmscan.c
@@ -647,6 +647,9 @@ free_it:
 		continue;
 
 activate_locked:
+		/* Not a candidate for swapping, so reclaim swap space. */
+		if (PageSwapCache(page) && vm_swap_full())
+			remove_exclusive_swap_page_ref(page);
 		SetPageActive(page);
 		pgactivate++;
 keep_locked:
@@ -1228,6 +1231,8 @@ static void shrink_active_list(unsigned 
 			__mod_zone_page_state(zone, NR_ACTIVE, pgmoved);
 			pgmoved = 0;
 			spin_unlock_irq(&zone->lru_lock);
+			if (vm_swap_full())
+				pagevec_swap_free(&pvec);
 			__pagevec_release(&pvec);
 			spin_lock_irq(&zone->lru_lock);
 		}
@@ -1237,6 +1242,8 @@ static void shrink_active_list(unsigned 
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
 	__count_vm_events(PGDEACTIVATE, pgdeactivate);
 	spin_unlock_irq(&zone->lru_lock);
+	if (vm_swap_full())
+		pagevec_swap_free(&pvec);
 
 	pagevec_release(&pvec);
 }
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
linux-next.patch

