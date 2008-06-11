From: akpm@linux-foundation.org
Subject: + swap-use-an-array-for-the-lru-pagevecs.patch added to -mm tree
Date: Wed, 11 Jun 2008 12:59:24 -0700
Message-ID: <200806111959.m5BJxOqE015172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752808AbYFKT7t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 15:59:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     swap: use an array for the LRU pagevecs
has been added to the -mm tree.  Its filename is
     swap-use-an-array-for-the-lru-pagevecs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swap: use an array for the LRU pagevecs
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Turn the pagevecs into an array just like the LRUs.  This significantly
cleans up the source code and reduces the size of the kernel by about 13kB
after all the LRU lists have been created further down in the split VM
patch series.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |   13 +++++-
 include/linux/swap.h    |   18 +++++++-
 mm/migrate.c            |   11 -----
 mm/swap.c               |   79 ++++++++++++--------------------------
 4 files changed, 55 insertions(+), 66 deletions(-)

diff -puN include/linux/pagevec.h~swap-use-an-array-for-the-lru-pagevecs include/linux/pagevec.h
--- a/include/linux/pagevec.h~swap-use-an-array-for-the-lru-pagevecs
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
diff -puN include/linux/swap.h~swap-use-an-array-for-the-lru-pagevecs include/linux/swap.h
--- a/include/linux/swap.h~swap-use-an-array-for-the-lru-pagevecs
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
diff -puN mm/migrate.c~swap-use-an-array-for-the-lru-pagevecs mm/migrate.c
--- a/mm/migrate.c~swap-use-an-array-for-the-lru-pagevecs
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
 
diff -puN mm/swap.c~swap-use-an-array-for-the-lru-pagevecs mm/swap.c
--- a/mm/swap.c~swap-use-an-array-for-the-lru-pagevecs
+++ a/mm/swap.c
@@ -34,8 +34,7 @@
 /* How many pages do we try to swap or page in/out together? */
 int page_cluster;
 
-static DEFINE_PER_CPU(struct pagevec, lru_add_pvecs) = { 0, };
-static DEFINE_PER_CPU(struct pagevec, lru_add_active_pvecs) = { 0, };
+static DEFINE_PER_CPU(struct pagevec[NR_LRU_LISTS], lru_add_pvecs) = { {0,}, };
 static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs) = { 0, };
 
 /*
@@ -186,28 +185,29 @@ void mark_page_accessed(struct page *pag
 
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
@@ -217,15 +217,15 @@ void lru_cache_add_active(struct page *p
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
@@ -379,7 +379,7 @@ void __pagevec_release_nonlru(struct pag
  * Add the passed pages to the LRU, then drop the caller's refcount
  * on them.  Reinitialises the caller's pagevec.
  */
-void __pagevec_lru_add(struct pagevec *pvec)
+void ____pagevec_lru_add(struct pagevec *pvec, enum lru_list lru)
 {
 	int i;
 	struct zone *zone = NULL;
@@ -396,7 +396,9 @@ void __pagevec_lru_add(struct pagevec *p
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
@@ -404,34 +406,7 @@ void __pagevec_lru_add(struct pagevec *p
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
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
shm_locked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
vmscan-unevictable-lru-scan-sysctl.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch

