From: akpm@linux-foundation.org
Subject: [merged] mm-simplify-code-of-swapc.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:38:18 -0700
Message-ID: <201103232041.p2NKftkj028695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933444Ab1CWUm4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:42:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, andi@firstfloor.org, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyuki@gmail.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, rie


The patch titled
     mm: simplify code of swap.c
has been removed from the -mm tree.  Its filename was
     mm-simplify-code-of-swapc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: simplify code of swap.c
From: Shaohua Li <shaohua.li@intel.com>

Clean up code and remove duplicate code. Next patch will use
pagevec_lru_move_fn introduced here too.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |  133 ++++++++++++++++++++++------------------------------
 1 file changed, 58 insertions(+), 75 deletions(-)

diff -puN mm/swap.c~mm-simplify-code-of-swapc mm/swap.c
--- a/mm/swap.c~mm-simplify-code-of-swapc
+++ a/mm/swap.c
@@ -179,15 +179,13 @@ void put_pages_list(struct list_head *pa
 }
 EXPORT_SYMBOL(put_pages_list);
 
-/*
- * pagevec_move_tail() must be called with IRQ disabled.
- * Otherwise this may cause nasty races.
- */
-static void pagevec_move_tail(struct pagevec *pvec)
+static void pagevec_lru_move_fn(struct pagevec *pvec,
+				void (*move_fn)(struct page *page, void *arg),
+				void *arg)
 {
 	int i;
-	int pgmoved = 0;
 	struct zone *zone = NULL;
+	unsigned long flags = 0;
 
 	for (i = 0; i < pagevec_count(pvec); i++) {
 		struct page *page = pvec->pages[i];
@@ -195,30 +193,50 @@ static void pagevec_move_tail(struct pag
 
 		if (pagezone != zone) {
 			if (zone)
-				spin_unlock(&zone->lru_lock);
+				spin_unlock_irqrestore(&zone->lru_lock, flags);
 			zone = pagezone;
-			spin_lock(&zone->lru_lock);
-		}
-		if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
-			enum lru_list lru = page_lru_base_type(page);
-			list_move_tail(&page->lru, &zone->lru[lru].list);
-			mem_cgroup_rotate_reclaimable_page(page);
-			pgmoved++;
+			spin_lock_irqsave(&zone->lru_lock, flags);
 		}
+
+		(*move_fn)(page, arg);
 	}
 	if (zone)
-		spin_unlock(&zone->lru_lock);
-	__count_vm_events(PGROTATED, pgmoved);
+		spin_unlock_irqrestore(&zone->lru_lock, flags);
 	release_pages(pvec->pages, pvec->nr, pvec->cold);
 	pagevec_reinit(pvec);
 }
 
+static void pagevec_move_tail_fn(struct page *page, void *arg)
+{
+	int *pgmoved = arg;
+	struct zone *zone = page_zone(page);
+
+	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
+		enum lru_list lru = page_lru_base_type(page);
+		list_move_tail(&page->lru, &zone->lru[lru].list);
+		mem_cgroup_rotate_reclaimable_page(page);
+		(*pgmoved)++;
+	}
+}
+
+/*
+ * pagevec_move_tail() must be called with IRQ disabled.
+ * Otherwise this may cause nasty races.
+ */
+static void pagevec_move_tail(struct pagevec *pvec)
+{
+	int pgmoved = 0;
+
+	pagevec_lru_move_fn(pvec, pagevec_move_tail_fn, &pgmoved);
+	__count_vm_events(PGROTATED, pgmoved);
+}
+
 /*
  * Writeback is about to end against a page which has been marked for immediate
  * reclaim.  If it still appears to be reclaimable, move it to the tail of the
  * inactive list.
  */
-void  rotate_reclaimable_page(struct page *page)
+void rotate_reclaimable_page(struct page *page)
 {
 	if (!PageLocked(page) && !PageDirty(page) && !PageActive(page) &&
 	    !PageUnevictable(page) && PageLRU(page)) {
@@ -369,10 +387,11 @@ void add_page_to_unevictable_list(struct
  * be write it out by flusher threads as this is much more effective
  * than the single-page writeout from reclaim.
  */
-static void lru_deactivate(struct page *page, struct zone *zone)
+static void lru_deactivate_fn(struct page *page, void *arg)
 {
 	int lru, file;
 	bool active;
+	struct zone *zone = page_zone(page);
 
 	if (!PageLRU(page))
 		return;
@@ -412,31 +431,6 @@ static void lru_deactivate(struct page *
 	update_page_reclaim_stat(zone, page, file, 0);
 }
 
-static void ____pagevec_lru_deactivate(struct pagevec *pvec)
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
-		lru_deactivate(page, zone);
-	}
-	if (zone)
-		spin_unlock_irq(&zone->lru_lock);
-
-	release_pages(pvec->pages, pvec->nr, pvec->cold);
-	pagevec_reinit(pvec);
-}
-
-
 /*
  * Drain pages out of the cpu's pagevecs.
  * Either "cpu" is the current CPU, and preemption has already been
@@ -466,7 +460,7 @@ static void drain_cpu_pagevecs(int cpu)
 
 	pvec = &per_cpu(lru_deactivate_pvecs, cpu);
 	if (pagevec_count(pvec))
-		____pagevec_lru_deactivate(pvec);
+		pagevec_lru_move_fn(pvec, lru_deactivate_fn, NULL);
 }
 
 /**
@@ -483,7 +477,7 @@ void deactivate_page(struct page *page)
 		struct pagevec *pvec = &get_cpu_var(lru_deactivate_pvecs);
 
 		if (!pagevec_add(pvec, page))
-			____pagevec_lru_deactivate(pvec);
+			pagevec_lru_move_fn(pvec, lru_deactivate_fn, NULL);
 		put_cpu_var(lru_deactivate_pvecs);
 	}
 }
@@ -630,44 +624,33 @@ void lru_add_page_tail(struct zone* zone
 	}
 }
 
+static void ____pagevec_lru_add_fn(struct page *page, void *arg)
+{
+	enum lru_list lru = (enum lru_list)arg;
+	struct zone *zone = page_zone(page);
+	int file = is_file_lru(lru);
+	int active = is_active_lru(lru);
+
+	VM_BUG_ON(PageActive(page));
+	VM_BUG_ON(PageUnevictable(page));
+	VM_BUG_ON(PageLRU(page));
+
+	SetPageLRU(page);
+	if (active)
+		SetPageActive(page);
+	update_page_reclaim_stat(zone, page, file, active);
+	add_page_to_lru_list(zone, page, lru);
+}
+
 /*
  * Add the passed pages to the LRU, then drop the caller's refcount
  * on them.  Reinitialises the caller's pagevec.
  */
 void ____pagevec_lru_add(struct pagevec *pvec, enum lru_list lru)
 {
-	int i;
-	struct zone *zone = NULL;
-
 	VM_BUG_ON(is_unevictable_lru(lru));
 
-	for (i = 0; i < pagevec_count(pvec); i++) {
-		struct page *page = pvec->pages[i];
-		struct zone *pagezone = page_zone(page);
-		int file;
-		int active;
-
-		if (pagezone != zone) {
-			if (zone)
-				spin_unlock_irq(&zone->lru_lock);
-			zone = pagezone;
-			spin_lock_irq(&zone->lru_lock);
-		}
-		VM_BUG_ON(PageActive(page));
-		VM_BUG_ON(PageUnevictable(page));
-		VM_BUG_ON(PageLRU(page));
-		SetPageLRU(page);
-		active = is_active_lru(lru);
-		file = is_file_lru(lru);
-		if (active)
-			SetPageActive(page);
-		update_page_reclaim_stat(zone, page, file, active);
-		add_page_to_lru_list(zone, page, lru);
-	}
-	if (zone)
-		spin_unlock_irq(&zone->lru_lock);
-	release_pages(pvec->pages, pvec->nr, pvec->cold);
-	pagevec_reinit(pvec);
+	pagevec_lru_move_fn(pvec, ____pagevec_lru_add_fn, (void *)lru);
 }
 
 EXPORT_SYMBOL(____pagevec_lru_add);
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch
mm-batch-activate_page-to-reduce-lock-contention.patch

