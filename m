From: akpm@linux-foundation.org
Subject: - vmscan-use-an-array-for-the-lru-pagevecs.patch removed from -mm tree
Date: Wed, 11 Jun 2008 12:45:56 -0700
Message-ID: <200806111945.m5BJjui5014533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832AbYFKTqR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 15:46:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: use an array for the LRU pagevecs
has been removed from the -mm tree.  Its filename was
     vmscan-use-an-array-for-the-lru-pagevecs.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: use an array for the LRU pagevecs
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Turn the pagevecs into an array just like the LRUs.  This significantly
cleans up the source code and reduces the size of the kernel by about 13kB
after all the LRU lists have been created further down in the split VM
patch series.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h  |   13 ++++-
 include/linux/pagevec.h |   13 ++++-
 include/linux/swap.h    |   18 ++++++-
 mm/migrate.c            |   11 ----
 mm/swap.c               |   96 +++++++++++++++++---------------------
 5 files changed, 83 insertions(+), 68 deletions(-)

diff -puN include/linux/mmzone.h~vmscan-use-an-array-for-the-lru-pagevecs include/linux/mmzone.h
--- a/include/linux/mmzone.h~vmscan-use-an-array-for-the-lru-pagevecs
+++ a/include/linux/mmzone.h
@@ -107,13 +107,22 @@ enum zone_stat_item {
 #endif
 	NR_VM_ZONE_STAT_ITEMS };
 
+#define LRU_BASE 0
+
 enum lru_list {
-	LRU_INACTIVE,	/* must match order of NR_[IN]ACTIVE */
-	LRU_ACTIVE,	/*  "     "     "   "       "        */
+	LRU_INACTIVE = LRU_BASE,	/* must match order of NR_[IN]ACTIVE */
+	LRU_ACTIVE,			/*  "     "     "   "       "        */
 	NR_LRU_LISTS };
 
 #define for_each_lru(l) for (l = 0; l < NR_LRU_LISTS; l++)
 
+static inline int is_active_lru(enum lru_list l)
+{
+	return (l == LRU_ACTIVE);
+}
+
+enum lru_list page_lru(struct page *page);
+
 struct per_cpu_pages {
 	int count;		/* number of pages in the list */
 	int high;		/* high watermark, emptying needed */
diff -puN include/linux/pagevec.h~vmscan-use-an-array-for-the-lru-pagevecs include/linux/pagevec.h
--- a/include/linux/pagevec.h~vmscan-use-an-array-for-the-lru-pagevecs
+++ a/include/linux/pagevec.h
@@ -23,8 +23,7 @@ struct pagevec {
 void __pagevec_release(struct pagevec *pvec);
 void __pagevec_release_nonlru(struct pagevec *pvec);
 void __pagevec_free(struct pagevec *pvec);
-void __pagevec_lru_add(struct pagevec *pvec);
-void __pagevec_lru_add_active(struct pagevec *pvec);
+void ____pagevec_lru_add(struct pagevec *pvec, enum lru_list lru);
 void pagevec_strip(struct pagevec *pvec);
 unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
 		pgoff_t start, unsigned nr_pages);
@@ -81,6 +80,16 @@ static inline void pagevec_free(struct p
 		__pagevec_free(pvec);
 }
 
+static inline void __pagevec_lru_add(struct pagevec *pvec)
+{
+	____pagevec_lru_add(pvec, LRU_INACTIVE);
+}
+
+static inline void __pagevec_lru_add_active(struct pagevec *pvec)
+{
+	____pagevec_lru_add(pvec, LRU_ACTIVE);
+}
+
 static inline void pagevec_lru_add(struct pagevec *pvec)
 {
 	if (pagevec_count(pvec))
diff -puN include/linux/swap.h~vmscan-use-an-array-for-the-lru-pagevecs include/linux/swap.h
--- a/include/linux/swap.h~vmscan-use-an-array-for-the-lru-pagevecs
+++ a/include/linux/swap.h
@@ -171,8 +171,8 @@ extern unsigned int nr_free_pagecache_pa
 
 
 /* linux/mm/swap.c */
-extern void lru_cache_add(struct page *);
-extern void lru_cache_add_active(struct page *);
+extern void __lru_cache_add(struct page *, enum lru_list lru);
+extern void lru_cache_add_lru(struct page *, enum lru_list lru);
 extern void activate_page(struct page *);
 extern void mark_page_accessed(struct page *);
 extern void lru_add_drain(void);
@@ -180,6 +180,20 @@ extern int lru_add_drain_all(void);
 extern void rotate_reclaimable_page(struct page *page);
 extern void swap_setup(void);
 
+/**
+ * lru_cache_add: add a page to the page lists
+ * @page: the page to add
+ */
+static inline void lru_cache_add(struct page *page)
+{
+	__lru_cache_add(page, LRU_INACTIVE);
+}
+
+static inline void lru_cache_add_active(struct page *page)
+{
+	__lru_cache_add(page, LRU_ACTIVE);
+}
+
 /* linux/mm/vmscan.c */
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask);
diff -puN mm/migrate.c~vmscan-use-an-array-for-the-lru-pagevecs mm/migrate.c
--- a/mm/migrate.c~vmscan-use-an-array-for-the-lru-pagevecs
+++ a/mm/migrate.c
@@ -55,16 +55,7 @@ int migrate_prep(void)
 
 static inline void move_to_lru(struct page *page)
 {
-	if (PageActive(page)) {
-		/*
-		 * lru_cache_add_active checks that
-		 * the PG_active bit is off.
-		 */
-		ClearPageActive(page);
-		lru_cache_add_active(page);
-	} else {
-		lru_cache_add(page);
-	}
+	lru_cache_add_lru(page, page_lru(page));
 	put_page(page);
 }
 
diff -puN mm/swap.c~vmscan-use-an-array-for-the-lru-pagevecs mm/swap.c
--- a/mm/swap.c~vmscan-use-an-array-for-the-lru-pagevecs
+++ a/mm/swap.c
@@ -34,8 +34,7 @@
 /* How many pages do we try to swap or page in/out together? */
 int page_cluster;
 
-static DEFINE_PER_CPU(struct pagevec, lru_add_pvecs) = { 0, };
-static DEFINE_PER_CPU(struct pagevec, lru_add_active_pvecs) = { 0, };
+static DEFINE_PER_CPU(struct pagevec[NR_LRU_LISTS], lru_add_pvecs) = { {0,}, };
 static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs) = { 0, };
 
 /*
@@ -96,6 +95,23 @@ void put_pages_list(struct list_head *pa
 }
 EXPORT_SYMBOL(put_pages_list);
 
+/**
+ * page_lru - which LRU list should a page be on?
+ * @page: the page to test
+ *
+ * Returns the LRU list a page should be on, as an index
+ * into the array of LRU lists.
+ */
+enum lru_list page_lru(struct page *page)
+{
+	enum lru_list lru = LRU_BASE;
+
+	if (PageActive(page))
+		lru += LRU_ACTIVE;
+
+	return lru;
+}
+
 /*
  * pagevec_move_tail() must be called with IRQ disabled.
  * Otherwise this may cause nasty races.
@@ -186,28 +202,29 @@ void mark_page_accessed(struct page *pag
 
 EXPORT_SYMBOL(mark_page_accessed);
 
-/**
- * lru_cache_add: add a page to the page lists
- * @page: the page to add
- */
-void lru_cache_add(struct page *page)
+void __lru_cache_add(struct page *page, enum lru_list lru)
 {
-	struct pagevec *pvec = &get_cpu_var(lru_add_pvecs);
+	struct pagevec *pvec = &get_cpu_var(lru_add_pvecs)[lru];
 
 	page_cache_get(page);
 	if (!pagevec_add(pvec, page))
-		__pagevec_lru_add(pvec);
+		____pagevec_lru_add(pvec, lru);
 	put_cpu_var(lru_add_pvecs);
 }
 
-void lru_cache_add_active(struct page *page)
+/**
+ * lru_cache_add_lru - add a page to a page list
+ * @page: the page to be added to the LRU.
+ * @lru: the LRU list to which the page is added.
+ */
+void lru_cache_add_lru(struct page *page, enum lru_list lru)
 {
-	struct pagevec *pvec = &get_cpu_var(lru_add_active_pvecs);
+	if (PageActive(page)) {
+		ClearPageActive(page);
+	}
 
-	page_cache_get(page);
-	if (!pagevec_add(pvec, page))
-		__pagevec_lru_add_active(pvec);
-	put_cpu_var(lru_add_active_pvecs);
+	VM_BUG_ON(PageLRU(page) || PageActive(page));
+	__lru_cache_add(page, lru);
 }
 
 /*
@@ -217,15 +234,15 @@ void lru_cache_add_active(struct page *p
  */
 static void drain_cpu_pagevecs(int cpu)
 {
+	struct pagevec *pvecs = per_cpu(lru_add_pvecs, cpu);
 	struct pagevec *pvec;
+	int lru;
 
-	pvec = &per_cpu(lru_add_pvecs, cpu);
-	if (pagevec_count(pvec))
-		__pagevec_lru_add(pvec);
-
-	pvec = &per_cpu(lru_add_active_pvecs, cpu);
-	if (pagevec_count(pvec))
-		__pagevec_lru_add_active(pvec);
+	for_each_lru(lru) {
+		pvec = &pvecs[lru - LRU_BASE];
+		if (pagevec_count(pvec))
+			____pagevec_lru_add(pvec, lru);
+	}
 
 	pvec = &per_cpu(lru_rotate_pvecs, cpu);
 	if (pagevec_count(pvec)) {
@@ -379,7 +396,7 @@ void __pagevec_release_nonlru(struct pag
  * Add the passed pages to the LRU, then drop the caller's refcount
  * on them.  Reinitialises the caller's pagevec.
  */
-void __pagevec_lru_add(struct pagevec *pvec)
+void ____pagevec_lru_add(struct pagevec *pvec, enum lru_list lru)
 {
 	int i;
 	struct zone *zone = NULL;
@@ -396,7 +413,9 @@ void __pagevec_lru_add(struct pagevec *p
 		}
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
-		add_page_to_inactive_list(zone, page);
+		if (is_active_lru(lru))
+			SetPageActive(page);
+		add_page_to_lru_list(zone, page, lru);
 	}
 	if (zone)
 		spin_unlock_irq(&zone->lru_lock);
@@ -404,34 +423,7 @@ void __pagevec_lru_add(struct pagevec *p
 	pagevec_reinit(pvec);
 }
 
-EXPORT_SYMBOL(__pagevec_lru_add);
-
-void __pagevec_lru_add_active(struct pagevec *pvec)
-{
-	int i;
-	struct zone *zone = NULL;
-
-	for (i = 0; i < pagevec_count(pvec); i++) {
-		struct page *page = pvec->pages[i];
-		struct zone *pagezone = page_zone(page);
-
-		if (pagezone != zone) {
-			if (zone)
-				spin_unlock_irq(&zone->lru_lock);
-			zone = pagezone;
-			spin_lock_irq(&zone->lru_lock);
-		}
-		VM_BUG_ON(PageLRU(page));
-		SetPageLRU(page);
-		VM_BUG_ON(PageActive(page));
-		SetPageActive(page);
-		add_page_to_active_list(zone, page);
-	}
-	if (zone)
-		spin_unlock_irq(&zone->lru_lock);
-	release_pages(pvec->pages, pvec->nr, pvec->cold);
-	pagevec_reinit(pvec);
-}
+EXPORT_SYMBOL(____pagevec_lru_add);
 
 /*
  * Try to drop buffers from the pages in a pagevec
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mm-fix-incorrect-variable-type-in-do_try_to_free_pages.patch
page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
mm-hugetlbc-fix-duplicate-variable.patch
page-flags-record-page-flag-overlays-explicitly.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
call_usermodehelper-increase-reliability.patch
cgroup-list_for_each-cleanup-v2.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim.patch
vmscan-use-an-array-for-the-lru-pagevecs.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
vmscan-noreclaim-lru-infrastructure.patch
vmscan-noreclaim-lru-page-statistics.patch
vmscan-shm_locked-pages-are-non-reclaimable.patch
vmscan-mlocked-pages-are-non-reclaimable.patch
vmscan-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-mlocked-pages-statistics.patch
vmscan-noreclaim-and-mlocked-pages-vm-events.patch
mm-only-vmscan-noreclaim-lru-scan-sysctl.patch
mm-only-vmscan-noreclaim-lru-scan-sysctl-fix.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch

