From: akpm@linux-foundation.org
Subject: - mm-use-pagevec-to-rotate-reclaimable-page.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:31:51 -0700
Message-ID: <200710162031.l9GKVpqr014536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33594 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965828AbXJPVkc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:40:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hifumi.hisashi@oss.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     mm: use pagevec to rotate reclaimable page
has been removed from the -mm tree.  Its filename was
     mm-use-pagevec-to-rotate-reclaimable-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: use pagevec to rotate reclaimable page
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

While running some memory intensive load, system response deteriorated just
after swap-out started.

The cause of this problem is that when a PG_reclaim page is moved to the tail
of the inactive LRU list in rotate_reclaimable_page(), lru_lock spin lock is
acquired every page writeback .  This deteriorates system performance and
makes interrupt hold off time longer when swap-out started.

Following patch solves this problem.  I use pagevec in rotating reclaimable
pages to mitigate LRU spin lock contention and reduce interrupt hold off time.

I did a test that allocating and touching pages in multiple processes, and
pinging to the test machine in flooding mode to measure response under memory
intensive load.

The test result is:

	-2.6.23-rc5
	--- testmachine ping statistics ---
	3000 packets transmitted, 3000 received, 0% packet loss, time 53222ms
	rtt min/avg/max/mdev = 0.074/0.652/172.228/7.176 ms, pipe 11, ipg/ewma 
17.746/0.092 ms

	-2.6.23-rc5-patched
	--- testmachine ping statistics ---
	3000 packets transmitted, 3000 received, 0% packet loss, time 51924ms
	rtt min/avg/max/mdev = 0.072/0.108/3.884/0.114 ms, pipe 2, ipg/ewma 
17.314/0.091 ms

Max round-trip-time was improved.

The test machine spec is that 4CPU(3.16GHz, Hyper-threading enabled)
8GB memory , 8GB swap.


I did ping test again to observe performance deterioration caused by taking 
a ref.

	-2.6.23-rc6-with-modifiedpatch
	--- testmachine ping statistics ---
	3000 packets transmitted, 3000 received, 0% packet loss, time 53386ms
	rtt min/avg/max/mdev = 0.074/0.110/4.716/0.147 ms, pipe 2, ipg/ewma 17.801/0.129 ms

The result for my original patch is as follows.

	-2.6.23-rc5-with-originalpatch
	--- testmachine ping statistics ---
	3000 packets transmitted, 3000 received, 0% packet loss, time 51924ms
	rtt min/avg/max/mdev = 0.072/0.108/3.884/0.114 ms, pipe 2, ipg/ewma 17.314/0.091 ms

The influence to response was small.

[akpm@linux-foundation.org: fix uninitalised var warning]
[hugh@veritas.com: fix locking]
[randy.dunlap@oracle.com: fix function declaration]
[hugh@veritas.com: fix BUG at include/linux/mm.h:220!]
[hugh@veritas.com: kill redundancy in rotate_reclaimable_page]
[hugh@veritas.com: move_tail_pages into lru_add_drain]
Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |  104 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 74 insertions(+), 30 deletions(-)

diff -puN mm/swap.c~mm-use-pagevec-to-rotate-reclaimable-page mm/swap.c
--- a/mm/swap.c~mm-use-pagevec-to-rotate-reclaimable-page
+++ a/mm/swap.c
@@ -32,6 +32,10 @@
 /* How many pages do we try to swap or page in/out together? */
 int page_cluster;
 
+static DEFINE_PER_CPU(struct pagevec, lru_add_pvecs) = { 0, };
+static DEFINE_PER_CPU(struct pagevec, lru_add_active_pvecs) = { 0, };
+static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs) = { 0, };
+
 /*
  * This path almost never happens for VM activity - pages are normally
  * freed via pagevecs.  But it gets used by networking.
@@ -92,23 +96,47 @@ void put_pages_list(struct list_head *pa
 EXPORT_SYMBOL(put_pages_list);
 
 /*
+ * pagevec_move_tail() must be called with IRQ disabled.
+ * Otherwise this may cause nasty races.
+ */
+static void pagevec_move_tail(struct pagevec *pvec)
+{
+	int i;
+	int pgmoved = 0;
+	struct zone *zone = NULL;
+
+	for (i = 0; i < pagevec_count(pvec); i++) {
+		struct page *page = pvec->pages[i];
+		struct zone *pagezone = page_zone(page);
+
+		if (pagezone != zone) {
+			if (zone)
+				spin_unlock(&zone->lru_lock);
+			zone = pagezone;
+			spin_lock(&zone->lru_lock);
+		}
+		if (PageLRU(page) && !PageActive(page)) {
+			list_move_tail(&page->lru, &zone->inactive_list);
+			pgmoved++;
+		}
+	}
+	if (zone)
+		spin_unlock(&zone->lru_lock);
+	__count_vm_events(PGROTATED, pgmoved);
+	release_pages(pvec->pages, pvec->nr, pvec->cold);
+	pagevec_reinit(pvec);
+}
+
+/*
  * Writeback is about to end against a page which has been marked for immediate
  * reclaim.  If it still appears to be reclaimable, move it to the tail of the
- * inactive list.  The page still has PageWriteback set, which will pin it.
- *
- * We don't expect many pages to come through here, so don't bother batching
- * things up.
- *
- * To avoid placing the page at the tail of the LRU while PG_writeback is still
- * set, this function will clear PG_writeback before performing the page
- * motion.  Do that inside the lru lock because once PG_writeback is cleared
- * we may not touch the page.
+ * inactive list.
  *
  * Returns zero if it cleared PG_writeback.
  */
 int rotate_reclaimable_page(struct page *page)
 {
-	struct zone *zone;
+	struct pagevec *pvec;
 	unsigned long flags;
 
 	if (PageLocked(page))
@@ -120,15 +148,16 @@ int rotate_reclaimable_page(struct page 
 	if (!PageLRU(page))
 		return 1;
 
-	zone = page_zone(page);
-	spin_lock_irqsave(&zone->lru_lock, flags);
-	if (PageLRU(page) && !PageActive(page)) {
-		list_move_tail(&page->lru, &zone->inactive_list);
-		__count_vm_event(PGROTATED);
-	}
+	page_cache_get(page);
+	local_irq_save(flags);
+	pvec = &__get_cpu_var(lru_rotate_pvecs);
+	if (!pagevec_add(pvec, page))
+		pagevec_move_tail(pvec);
+	local_irq_restore(flags);
+
 	if (!test_clear_page_writeback(page))
 		BUG();
-	spin_unlock_irqrestore(&zone->lru_lock, flags);
+
 	return 0;
 }
 
@@ -172,9 +201,6 @@ EXPORT_SYMBOL(mark_page_accessed);
  * lru_cache_add: add a page to the page lists
  * @page: the page to add
  */
-static DEFINE_PER_CPU(struct pagevec, lru_add_pvecs) = { 0, };
-static DEFINE_PER_CPU(struct pagevec, lru_add_active_pvecs) = { 0, };
-
 void fastcall lru_cache_add(struct page *page)
 {
 	struct pagevec *pvec = &get_cpu_var(lru_add_pvecs);
@@ -195,21 +221,37 @@ void fastcall lru_cache_add_active(struc
 	put_cpu_var(lru_add_active_pvecs);
 }
 
-static void __lru_add_drain(int cpu)
+/*
+ * Drain pages out of the cpu's pagevecs.
+ * Either "cpu" is the current CPU, and preemption has already been
+ * disabled; or "cpu" is being hot-unplugged, and is already dead.
+ */
+static void drain_cpu_pagevecs(int cpu)
 {
-	struct pagevec *pvec = &per_cpu(lru_add_pvecs, cpu);
+	struct pagevec *pvec;
 
-	/* CPU is dead, so no locking needed. */
+	pvec = &per_cpu(lru_add_pvecs, cpu);
 	if (pagevec_count(pvec))
 		__pagevec_lru_add(pvec);
+
 	pvec = &per_cpu(lru_add_active_pvecs, cpu);
 	if (pagevec_count(pvec))
 		__pagevec_lru_add_active(pvec);
+
+	pvec = &per_cpu(lru_rotate_pvecs, cpu);
+	if (pagevec_count(pvec)) {
+		unsigned long flags;
+
+		/* No harm done if a racing interrupt already did this */
+		local_irq_save(flags);
+		pagevec_move_tail(pvec);
+		local_irq_restore(flags);
+	}
 }
 
 void lru_add_drain(void)
 {
-	__lru_add_drain(get_cpu());
+	drain_cpu_pagevecs(get_cpu());
 	put_cpu();
 }
 
@@ -256,6 +298,7 @@ void release_pages(struct page **pages, 
 	int i;
 	struct pagevec pages_to_free;
 	struct zone *zone = NULL;
+	unsigned long uninitialized_var(flags);
 
 	pagevec_init(&pages_to_free, cold);
 	for (i = 0; i < nr; i++) {
@@ -263,7 +306,7 @@ void release_pages(struct page **pages, 
 
 		if (unlikely(PageCompound(page))) {
 			if (zone) {
-				spin_unlock_irq(&zone->lru_lock);
+				spin_unlock_irqrestore(&zone->lru_lock, flags);
 				zone = NULL;
 			}
 			put_compound_page(page);
@@ -277,9 +320,10 @@ void release_pages(struct page **pages, 
 			struct zone *pagezone = page_zone(page);
 			if (pagezone != zone) {
 				if (zone)
-					spin_unlock_irq(&zone->lru_lock);
+					spin_unlock_irqrestore(&zone->lru_lock,
+									flags);
 				zone = pagezone;
-				spin_lock_irq(&zone->lru_lock);
+				spin_lock_irqsave(&zone->lru_lock, flags);
 			}
 			VM_BUG_ON(!PageLRU(page));
 			__ClearPageLRU(page);
@@ -288,7 +332,7 @@ void release_pages(struct page **pages, 
 
 		if (!pagevec_add(&pages_to_free, page)) {
 			if (zone) {
-				spin_unlock_irq(&zone->lru_lock);
+				spin_unlock_irqrestore(&zone->lru_lock, flags);
 				zone = NULL;
 			}
 			__pagevec_free(&pages_to_free);
@@ -296,7 +340,7 @@ void release_pages(struct page **pages, 
   		}
 	}
 	if (zone)
-		spin_unlock_irq(&zone->lru_lock);
+		spin_unlock_irqrestore(&zone->lru_lock, flags);
 
 	pagevec_free(&pages_to_free);
 }
@@ -489,7 +533,7 @@ static int cpu_swap_callback(struct noti
 	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
 		atomic_add(*committed, &vm_committed_space);
 		*committed = 0;
-		__lru_add_drain((long)hcpu);
+		drain_cpu_pagevecs((long)hcpu);
 	}
 	return NOTIFY_OK;
 }
_

Patches currently in -mm which might be from hifumi.hisashi@oss.ntt.co.jp are

origin.patch
