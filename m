From: akpm@linux-foundation.org
Subject: [merged] mm-fewer-underscores-in-____pagevec_lru_add.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:35:46 -0800
Message-ID: <20120113203547.0CFE820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57647 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759078Ab2AMUfs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:35:48 -0500
Received: by mail-ee0-f74.google.com with SMTP id e50so23684eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:35:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fewer underscores in ____pagevec_lru_add
has been removed from the -mm tree.  Its filename was
     mm-fewer-underscores-in-____pagevec_lru_add.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: fewer underscores in ____pagevec_lru_add

What's so special about ____pagevec_lru_add() that it needs four leading
underscores?  Nothing, it just helped to distinguish from
__pagevec_lru_add() in 2.6.28 development.  Cut two leading underscores.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |   10 +++++-----
 mm/swap.c               |   12 ++++++------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff -puN include/linux/pagevec.h~mm-fewer-underscores-in-____pagevec_lru_add include/linux/pagevec.h
--- a/include/linux/pagevec.h~mm-fewer-underscores-in-____pagevec_lru_add
+++ a/include/linux/pagevec.h
@@ -21,7 +21,7 @@ struct pagevec {
 };
 
 void __pagevec_release(struct pagevec *pvec);
-void ____pagevec_lru_add(struct pagevec *pvec, enum lru_list lru);
+void __pagevec_lru_add(struct pagevec *pvec, enum lru_list lru);
 unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
 		pgoff_t start, unsigned nr_pages);
 unsigned pagevec_lookup_tag(struct pagevec *pvec,
@@ -66,22 +66,22 @@ static inline void pagevec_release(struc
 
 static inline void __pagevec_lru_add_anon(struct pagevec *pvec)
 {
-	____pagevec_lru_add(pvec, LRU_INACTIVE_ANON);
+	__pagevec_lru_add(pvec, LRU_INACTIVE_ANON);
 }
 
 static inline void __pagevec_lru_add_active_anon(struct pagevec *pvec)
 {
-	____pagevec_lru_add(pvec, LRU_ACTIVE_ANON);
+	__pagevec_lru_add(pvec, LRU_ACTIVE_ANON);
 }
 
 static inline void __pagevec_lru_add_file(struct pagevec *pvec)
 {
-	____pagevec_lru_add(pvec, LRU_INACTIVE_FILE);
+	__pagevec_lru_add(pvec, LRU_INACTIVE_FILE);
 }
 
 static inline void __pagevec_lru_add_active_file(struct pagevec *pvec)
 {
-	____pagevec_lru_add(pvec, LRU_ACTIVE_FILE);
+	__pagevec_lru_add(pvec, LRU_ACTIVE_FILE);
 }
 
 static inline void pagevec_lru_add_file(struct pagevec *pvec)
diff -puN mm/swap.c~mm-fewer-underscores-in-____pagevec_lru_add mm/swap.c
--- a/mm/swap.c~mm-fewer-underscores-in-____pagevec_lru_add
+++ a/mm/swap.c
@@ -378,7 +378,7 @@ void __lru_cache_add(struct page *page, 
 
 	page_cache_get(page);
 	if (!pagevec_add(pvec, page))
-		____pagevec_lru_add(pvec, lru);
+		__pagevec_lru_add(pvec, lru);
 	put_cpu_var(lru_add_pvecs);
 }
 EXPORT_SYMBOL(__lru_cache_add);
@@ -506,7 +506,7 @@ static void drain_cpu_pagevecs(int cpu)
 	for_each_lru(lru) {
 		pvec = &pvecs[lru - LRU_BASE];
 		if (pagevec_count(pvec))
-			____pagevec_lru_add(pvec, lru);
+			__pagevec_lru_add(pvec, lru);
 	}
 
 	pvec = &per_cpu(lru_rotate_pvecs, cpu);
@@ -698,7 +698,7 @@ void lru_add_page_tail(struct zone* zone
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static void ____pagevec_lru_add_fn(struct page *page, void *arg)
+static void __pagevec_lru_add_fn(struct page *page, void *arg)
 {
 	enum lru_list lru = (enum lru_list)arg;
 	struct zone *zone = page_zone(page);
@@ -720,14 +720,14 @@ static void ____pagevec_lru_add_fn(struc
  * Add the passed pages to the LRU, then drop the caller's refcount
  * on them.  Reinitialises the caller's pagevec.
  */
-void ____pagevec_lru_add(struct pagevec *pvec, enum lru_list lru)
+void __pagevec_lru_add(struct pagevec *pvec, enum lru_list lru)
 {
 	VM_BUG_ON(is_unevictable_lru(lru));
 
-	pagevec_lru_move_fn(pvec, ____pagevec_lru_add_fn, (void *)lru);
+	pagevec_lru_move_fn(pvec, __pagevec_lru_add_fn, (void *)lru);
 }
 
-EXPORT_SYMBOL(____pagevec_lru_add);
+EXPORT_SYMBOL(__pagevec_lru_add);
 
 /**
  * pagevec_lookup - gang pagecache lookup
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
prio_tree-debugging-patch.patch

