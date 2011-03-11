From: akpm@linux-foundation.org
Subject: + mm-batch-activate_page-to-reduce-lock-contention.patch added to -mm tree
Date: Fri, 11 Mar 2011 15:07:02 -0800
Message-ID: <201103112307.p2BN72Og001279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751533Ab1CKXH4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Mar 2011 18:07:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, andi@firstfloor.org, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyuki@gmail.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com


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

Andrew Morton suggested activate_page() and putback_lru_pages() should
follow the same path to active pages, but this is hard to implement (see
commit 7a608572a282a ("Revert "mm: batch activate_page() to reduce lock
contention")).  On the other hand, do we really need putback_lru_pages()
to follow the same path?  I tested several FIO/FFSB benchmark (about 20
scripts for each benchmark) in 3 machines here from 2 sockets to 4
sockets.  My test doesn't show anything significant with/without below
patch (there is slight difference but mostly some noise which we found
even without below patch before).  Below patch basically returns to the
same as my first post.

I tested some microbenchmarks:
case-anon-cow-rand-mt               0.58%
case-anon-cow-rand          -3.30%
case-anon-cow-seq-mt                -0.51%
case-anon-cow-seq           -5.68%
case-anon-r-rand-mt         0.23%
case-anon-r-rand            0.81%
case-anon-r-seq-mt          -0.71%
case-anon-r-seq                     -1.99%
case-anon-rx-rand-mt                2.11%
case-anon-rx-seq-mt         3.46%
case-anon-w-rand-mt         -0.03%
case-anon-w-rand            -0.50%
case-anon-w-seq-mt          -1.08%
case-anon-w-seq                     -0.12%
case-anon-wx-rand-mt                -5.02%
case-anon-wx-seq-mt         -1.43%
case-fork                   1.65%
case-fork-sleep                     -0.07%
case-fork-withmem           1.39%
case-hugetlb                        -0.59%
case-lru-file-mmap-read-mt  -0.54%
case-lru-file-mmap-read             0.61%
case-lru-file-mmap-read-rand        -2.24%
case-lru-file-readonce              -0.64%
case-lru-file-readtwice             -11.69%
case-lru-memcg                      -1.35%
case-mmap-pread-rand-mt             1.88%
case-mmap-pread-rand                -15.26%
case-mmap-pread-seq-mt              0.89%
case-mmap-pread-seq         -69.72%
case-mmap-xread-rand-mt             0.71%
case-mmap-xread-seq-mt              0.38%

The most significent are:
case-lru-file-readtwice             -11.69%
case-mmap-pread-rand                -15.26%
case-mmap-pread-seq         -69.72%

which use activate_page a lot.  others are basically variations because
each run has slightly difference.

In UP case, 'size mm/swap.o'
before the two patches:
   text    data     bss     dec     hex filename
   6466     896       4    7366    1cc6 mm/swap.o
after the two patches:
   text    data     bss     dec     hex filename
   6343     896       4    7243    1c4b mm/swap.o

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   45 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 5 deletions(-)

diff -puN mm/swap.c~mm-batch-activate_page-to-reduce-lock-contention mm/swap.c
--- a/mm/swap.c~mm-batch-activate_page-to-reduce-lock-contention
+++ a/mm/swap.c
@@ -272,14 +272,10 @@ static void update_page_reclaim_stat(str
 		memcg_reclaim_stat->recent_rotated[file]++;
 }
 
-/*
- * FIXME: speed this up?
- */
-void activate_page(struct page *page)
+static void __activate_page(struct page *page, void *arg)
 {
 	struct zone *zone = page_zone(page);
 
-	spin_lock_irq(&zone->lru_lock);
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 		int file = page_is_file_cache(page);
 		int lru = page_lru_base_type(page);
@@ -292,8 +288,45 @@ void activate_page(struct page *page)
 
 		update_page_reclaim_stat(zone, page, file, 1);
 	}
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
+
+		page_cache_get(page);
+		if (!pagevec_add(pvec, page))
+			pagevec_lru_move_fn(pvec, __activate_page, NULL);
+		put_cpu_var(activate_page_pvecs);
+	}
+}
+
+#else
+static inline void activate_page_drain(int cpu)
+{
+}
+
+void activate_page(struct page *page)
+{
+	struct zone *zone = page_zone(page);
+
+	spin_lock_irq(&zone->lru_lock);
+	__activate_page(page, NULL);
 	spin_unlock_irq(&zone->lru_lock);
 }
+#endif
 
 /*
  * Mark a page as having seen activity.
@@ -461,6 +494,8 @@ static void drain_cpu_pagevecs(int cpu)
 	pvec = &per_cpu(lru_deactivate_pvecs, cpu);
 	if (pagevec_count(pvec))
 		pagevec_lru_move_fn(pvec, lru_deactivate_fn, NULL);
+
+	activate_page_drain(cpu);
 }
 
 /**
_

Patches currently in -mm which might be from shaohua.li@intel.com are

linux-next.patch
mm-vmscan-kswapd-should-not-free-an-excessive-number-of-pages-when-balancing-small-zones.patch
mm-simplify-code-of-swapc.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
fs-ioctlc-remove-unnecessary-variable.patch

