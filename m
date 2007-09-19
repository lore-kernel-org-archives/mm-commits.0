From: akpm@linux-foundation.org
Subject: + mm-use-pagevec-to-rotate-reclaimable-page.patch added to -mm tree
Date: Wed, 19 Sep 2007 15:13:03 -0700
Message-ID: <200709192213.l8JMD4Gp013797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48827 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968AbXISWNl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Sep 2007 18:13:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hifumi.hisashi@oss.ntt.co.jp


The patch titled
     mm: use pagevec to rotate reclaimable page
has been added to the -mm tree.  Its filename is
     mm-use-pagevec-to-rotate-reclaimable-page.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 
 mm/swap.c            |   88 +++++++++++++++++++++++++++++++++--------
 mm/vmscan.c          |    1 
 3 files changed, 74 insertions(+), 16 deletions(-)

diff -puN include/linux/swap.h~mm-use-pagevec-to-rotate-reclaimable-page include/linux/swap.h
--- a/include/linux/swap.h~mm-use-pagevec-to-rotate-reclaimable-page
+++ a/include/linux/swap.h
@@ -185,6 +185,7 @@ extern void FASTCALL(mark_page_accessed(
 extern void lru_add_drain(void);
 extern int lru_add_drain_all(void);
 extern int rotate_reclaimable_page(struct page *page);
+extern void move_tail_pages(void);
 extern void swap_setup(void);
 
 /* linux/mm/vmscan.c */
diff -puN mm/swap.c~mm-use-pagevec-to-rotate-reclaimable-page mm/swap.c
--- a/mm/swap.c~mm-use-pagevec-to-rotate-reclaimable-page
+++ a/mm/swap.c
@@ -92,24 +92,62 @@ void put_pages_list(struct list_head *pa
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
+	unsigned long flags = 0;
+
+	for (i = 0; i < pagevec_count(pvec); i++) {
+		struct page *page = pvec->pages[i];
+		struct zone *pagezone = page_zone(page);
+
+		if (pagezone != zone) {
+			if (zone)
+				spin_unlock_irqrestore(&zone->lru_lock, flags);
+			zone = pagezone;
+			spin_lock_irqsave(&zone->lru_lock, flags);
+		}
+		if (PageLRU(page) && !PageActive(page)) {
+			list_move_tail(&page->lru, &zone->inactive_list);
+			pgmoved++;
+		}
+	}
+	if (zone)
+		spin_unlock_irqrestore(&zone->lru_lock, flags);
+	__count_vm_events(PGROTATED, pgmoved);
+	release_pages(pvec->pages, pvec->nr, pvec->cold);
+	pagevec_reinit(pvec);
+}
+
+static DEFINE_PER_CPU(struct pagevec, rotate_pvecs) = { 0, };
+
+void move_tail_pages()
+{
+	unsigned long flags;
+	struct pagevec *pvec;
+
+	local_irq_save(flags);
+	pvec = &__get_cpu_var(rotate_pvecs);
+	if (pagevec_count(pvec))
+		pagevec_move_tail(pvec);
+	local_irq_restore(flags);
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
-	unsigned long flags;
+	struct pagevec *pvec;
 
 	if (PageLocked(page))
 		return 1;
@@ -120,15 +158,15 @@ int rotate_reclaimable_page(struct page 
 	if (!PageLRU(page))
 		return 1;
 
-	zone = page_zone(page);
-	spin_lock_irqsave(&zone->lru_lock, flags);
 	if (PageLRU(page) && !PageActive(page)) {
-		list_move_tail(&page->lru, &zone->inactive_list);
-		__count_vm_event(PGROTATED);
+		page_cache_get(page);
+		pvec = &__get_cpu_var(rotate_pvecs);
+		if (!pagevec_add(pvec, page))
+			pagevec_move_tail(pvec);
 	}
 	if (!test_clear_page_writeback(page))
 		BUG();
-	spin_unlock_irqrestore(&zone->lru_lock, flags);
+
 	return 0;
 }
 
@@ -493,6 +531,23 @@ static int cpu_swap_callback(struct noti
 	}
 	return NOTIFY_OK;
 }
+
+static int cpu_movetail_callback(struct notifier_block *nfb,
+				 unsigned long action, void *hcpu)
+{
+	unsigned long flags;
+	struct pagevec *pvec;
+
+	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
+		local_irq_save(flags);
+		pvec = &per_cpu(rotate_pvecs, (long)hcpu);
+		if (pagevec_count(pvec))
+			pagevec_move_tail(pvec);
+		local_irq_restore(flags);
+	}
+
+	return NOTIFY_OK;
+}
 #endif /* CONFIG_HOTPLUG_CPU */
 #endif /* CONFIG_SMP */
 
@@ -514,5 +569,6 @@ void __init swap_setup(void)
 	 */
 #ifdef CONFIG_HOTPLUG_CPU
 	hotcpu_notifier(cpu_swap_callback, 0);
+	hotcpu_notifier(cpu_movetail_callback, 0);
 #endif
 }
diff -puN mm/vmscan.c~mm-use-pagevec-to-rotate-reclaimable-page mm/vmscan.c
--- a/mm/vmscan.c~mm-use-pagevec-to-rotate-reclaimable-page
+++ a/mm/vmscan.c
@@ -792,6 +792,7 @@ static unsigned long shrink_inactive_lis
 
 	pagevec_init(&pvec, 1);
 
+	move_tail_pages();
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
 	do {
_

Patches currently in -mm which might be from hifumi.hisashi@oss.ntt.co.jp are

mm-use-pagevec-to-rotate-reclaimable-page.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix.patch
