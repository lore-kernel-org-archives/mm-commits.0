From: akpm@linux-foundation.org
Subject: + mm-batch-activate_page-to-reduce-lock-contention.patch added to -mm tree
Date: Tue, 11 Jan 2011 15:22:06 -0800
Message-ID: <201101112322.p0BNM7tU012658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753841Ab1AKXWx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Jan 2011 18:22:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, andi@firstfloor.org, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: batch activate_page() to reduce lock contention
has been added to the -mm tree.  Its filename is
     mm-batch-activate_page-to-reduce-lock-contention.patch

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
Subject: mm: batch activate_page() to reduce lock contention
From: Shaohua Li <shaohua.li@intel.com>

The zone->lru_lock is heavily contented in workload where activate_page()
is frequently used.  We could do batch activate_page() to reduce the lock
contention.  The batched pages will be added into zone list when the pool
is full or page reclaim is trying to drain them.

For example, in a 4 socket 64 CPU system, create a sparse file and 64
processes, processes shared map to the file.  Each process read access the
whole file and then exit.  The process exit will do unmap_vmas() and cause
a lot of activate_page() call.  In such workload, we saw about 58% total
time reduction with below patch.  Other workloads with a lot of
activate_page also benefits a lot too.

I tested some microbenchmarks:
case-anon-cow-rand-mt		0.58%
case-anon-cow-rand		-3.30%
case-anon-cow-seq-mt		-0.51%
case-anon-cow-seq		-5.68%
case-anon-r-rand-mt		0.23%
case-anon-r-rand		0.81%
case-anon-r-seq-mt		-0.71%
case-anon-r-seq			-1.99%
case-anon-rx-rand-mt		2.11%
case-anon-rx-seq-mt		3.46%
case-anon-w-rand-mt		-0.03%
case-anon-w-rand		-0.50%
case-anon-w-seq-mt		-1.08%
case-anon-w-seq			-0.12%
case-anon-wx-rand-mt		-5.02%
case-anon-wx-seq-mt		-1.43%
case-fork			1.65%
case-fork-sleep			-0.07%
case-fork-withmem		1.39%
case-hugetlb			-0.59%
case-lru-file-mmap-read-mt	-0.54%
case-lru-file-mmap-read		0.61%
case-lru-file-mmap-read-rand	-2.24%
case-lru-file-readonce		-0.64%
case-lru-file-readtwice		-11.69%
case-lru-memcg			-1.35%
case-mmap-pread-rand-mt		1.88%
case-mmap-pread-rand		-15.26%
case-mmap-pread-seq-mt		0.89%
case-mmap-pread-seq		-69.72%
case-mmap-xread-rand-mt		0.71%
case-mmap-xread-seq-mt		0.38%

The most significent are:
case-lru-file-readtwice		-11.69%
case-mmap-pread-rand		-15.26%
case-mmap-pread-seq		-69.72%

which use activate_page a lot.  others are basically variations because
each run has slightly difference.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    9 ++++
 mm/swap.c     |   90 ++++++++++++++++++++++++++++++++++++++++++------
 mm/vmscan.c   |    6 ++-
 3 files changed, 92 insertions(+), 13 deletions(-)

diff -puN mm/internal.h~mm-batch-activate_page-to-reduce-lock-contention mm/internal.h
--- a/mm/internal.h~mm-batch-activate_page-to-reduce-lock-contention
+++ a/mm/internal.h
@@ -39,6 +39,15 @@ static inline void __put_page(struct pag
 
 extern unsigned long highest_memmap_pfn;
 
+#ifdef CONFIG_SMP
+extern int putback_active_lru_page(struct zone *zone, struct page *page);
+#else
+static inline int putback_active_lru_page(struct zone *zone, struct page *page)
+{
+	return 0;
+}
+#endif
+
 /*
  * in mm/vmscan.c:
  */
diff -puN mm/swap.c~mm-batch-activate_page-to-reduce-lock-contention mm/swap.c
--- a/mm/swap.c~mm-batch-activate_page-to-reduce-lock-contention
+++ a/mm/swap.c
@@ -273,27 +273,94 @@ static void update_page_reclaim_stat(str
 }
 
 /*
- * FIXME: speed this up?
+ * A page will go to active list either by activate_page or putback_lru_page.
+ * In the activate_page case, the page hasn't active bit set. The page might
+ * not in LRU list because it's isolated before it gets a chance to be moved to
+ * active list. The window is small because pagevec just stores several pages.
+ * For such case, we do nothing for such page.
+ * In the putback_lru_page case, the page isn't in lru list but has active
+ * bit set
  */
-void activate_page(struct page *page)
+static void __activate_page(struct page *page, void *arg)
 {
 	struct zone *zone = page_zone(page);
+	int file = page_is_file_cache(page);
+	int lru = page_lru_base_type(page);
+	bool putback = !PageLRU(page);
+
+	/* The page is isolated before it's moved to active list */
+	if (!PageLRU(page) && !PageActive(page))
+		return;
+	if ((PageLRU(page) && PageActive(page)) || PageUnevictable(page))
+		return;
 
-	spin_lock_irq(&zone->lru_lock);
-	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
-		int file = page_is_file_cache(page);
-		int lru = page_lru_base_type(page);
+	if (!putback)
 		del_page_from_lru_list(zone, page, lru);
+	else
+		SetPageLRU(page);
 
-		SetPageActive(page);
-		lru += LRU_ACTIVE;
-		add_page_to_lru_list(zone, page, lru);
-		__count_vm_event(PGACTIVATE);
+	SetPageActive(page);
+	lru += LRU_ACTIVE;
+	add_page_to_lru_list(zone, page, lru);
+
+	if (putback)
+		return;
+	__count_vm_event(PGACTIVATE);
+	update_page_reclaim_stat(zone, page, file, 1);
+}
+
+#ifdef CONFIG_SMP
+static DEFINE_PER_CPU(struct pagevec, activate_page_pvecs);
+
+static void activate_page_drain(int cpu)
+{
+	struct pagevec *pvec = &per_cpu(activate_page_pvecs, cpu);
+
+	if (pagevec_count(pvec))
+		pagevec_lru_move_fn(pvec, __activate_page, NULL);
+}
+
+void activate_page(struct page *page)
+{
+	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
+		struct pagevec *pvec = &get_cpu_var(activate_page_pvecs);
 
-		update_page_reclaim_stat(zone, page, file, 1);
+		page_cache_get(page);
+		if (!pagevec_add(pvec, page))
+			pagevec_lru_move_fn(pvec, __activate_page, NULL);
+		put_cpu_var(activate_page_pvecs);
 	}
+}
+
+/* Caller should hold zone->lru_lock */
+int putback_active_lru_page(struct zone *zone, struct page *page)
+{
+	struct pagevec *pvec = &get_cpu_var(activate_page_pvecs);
+
+	if (!pagevec_add(pvec, page)) {
+		spin_unlock_irq(&zone->lru_lock);
+		pagevec_lru_move_fn(pvec, __activate_page, NULL);
+		spin_lock_irq(&zone->lru_lock);
+	}
+	put_cpu_var(activate_page_pvecs);
+	return 1;
+}
+
+#else
+static void inline activate_page_drain(int cpu)
+{
+}
+
+void activate_page(struct page *page)
+{
+	struct zone *zone = page_zone(page);
+
+	spin_lock_irq(&zone->lru_lock);
+	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page))
+		__activate_page(page, NULL);
 	spin_unlock_irq(&zone->lru_lock);
 }
+#endif
 
 /*
  * Mark a page as having seen activity.
@@ -435,6 +502,7 @@ static void drain_cpu_pagevecs(int cpu)
 	pvec = &per_cpu(lru_deactivate_pvecs, cpu);
 	if (pagevec_count(pvec))
 		__pagevec_lru_deactive(pvec);
+	activate_page_drain(cpu);
 }
 
 /*
diff -puN mm/vmscan.c~mm-batch-activate_page-to-reduce-lock-contention mm/vmscan.c
--- a/mm/vmscan.c~mm-batch-activate_page-to-reduce-lock-contention
+++ a/mm/vmscan.c
@@ -1271,14 +1271,16 @@ putback_lru_pages(struct zone *zone, str
 			spin_lock_irq(&zone->lru_lock);
 			continue;
 		}
-		SetPageLRU(page);
 		lru = page_lru(page);
-		add_page_to_lru_list(zone, page, lru);
 		if (is_active_lru(lru)) {
 			int file = is_file_lru(lru);
 			int numpages = hpage_nr_pages(page);
 			reclaim_stat->recent_rotated[file] += numpages;
+			if (putback_active_lru_page(zone, page))
+				continue;
 		}
+		SetPageLRU(page);
+		add_page_to_lru_list(zone, page, lru);
 		if (!pagevec_add(&pvec, page)) {
 			spin_unlock_irq(&zone->lru_lock);
 			__pagevec_release(&pvec);
_

Patches currently in -mm which might be from shaohua.li@intel.com are

linux-next.patch
intel_idle-open-broadcast-clock-event-resend.patch
mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-bdi-write-bandwidth-estimation-fix.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
mm-kswapd-stop-high-order-balancing-when-any-suitable-zone-is-balanced.patch
mm-kswapd-keep-kswapd-awake-for-high-order-allocations-until-a-percentage-of-the-node-is-balanced.patch
mm-kswapd-use-the-order-that-kswapd-was-reclaiming-at-for-sleeping_prematurely.patch
mm-kswapd-reset-kswapd_max_order-and-classzone_idx-after-reading.patch
mm-kswapd-treat-zone-all_unreclaimable-in-sleeping_prematurely-similar-to-balance_pgdat.patch
mm-kswapd-use-the-classzone-idx-that-kswapd-was-using-for-sleeping_prematurely.patch
mm-simplify-code-of-swapc.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
include-asm-generic-vmlinuxldsh-make-readmostly-section-correctly-align.patch

