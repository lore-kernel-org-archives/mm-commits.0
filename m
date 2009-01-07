From: akpm@linux-foundation.org
Subject: - mm-get-rid-of-pagevec_release_nonlru.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:11:52 -0800
Message-ID: <200901072211.n07MBqY1012157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754891AbZAGWL6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:11:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: get rid of pagevec_release_nonlru()
has been removed from the -mm tree.  Its filename was
     mm-get-rid-of-pagevec_release_nonlru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: get rid of pagevec_release_nonlru()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

speculative page references patch (commit:
e286781d5f2e9c846e012a39653a166e9d31777d) removed last
pagevec_release_nonlru() caller.

So this function can be removed now.

This patch doesn't have any functional change.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    7 -------
 mm/swap.c               |   22 ----------------------
 2 files changed, 29 deletions(-)

diff -puN include/linux/pagevec.h~mm-get-rid-of-pagevec_release_nonlru include/linux/pagevec.h
--- a/include/linux/pagevec.h~mm-get-rid-of-pagevec_release_nonlru
+++ a/include/linux/pagevec.h
@@ -21,7 +21,6 @@ struct pagevec {
 };
 
 void __pagevec_release(struct pagevec *pvec);
-void __pagevec_release_nonlru(struct pagevec *pvec);
 void __pagevec_free(struct pagevec *pvec);
 void ____pagevec_lru_add(struct pagevec *pvec, enum lru_list lru);
 void pagevec_strip(struct pagevec *pvec);
@@ -69,12 +68,6 @@ static inline void pagevec_release(struc
 		__pagevec_release(pvec);
 }
 
-static inline void pagevec_release_nonlru(struct pagevec *pvec)
-{
-	if (pagevec_count(pvec))
-		__pagevec_release_nonlru(pvec);
-}
-
 static inline void pagevec_free(struct pagevec *pvec)
 {
 	if (pagevec_count(pvec))
diff -puN mm/swap.c~mm-get-rid-of-pagevec_release_nonlru mm/swap.c
--- a/mm/swap.c~mm-get-rid-of-pagevec_release_nonlru
+++ a/mm/swap.c
@@ -398,28 +398,6 @@ void __pagevec_release(struct pagevec *p
 EXPORT_SYMBOL(__pagevec_release);
 
 /*
- * pagevec_release() for pages which are known to not be on the LRU
- *
- * This function reinitialises the caller's pagevec.
- */
-void __pagevec_release_nonlru(struct pagevec *pvec)
-{
-	int i;
-	struct pagevec pages_to_free;
-
-	pagevec_init(&pages_to_free, pvec->cold);
-	for (i = 0; i < pagevec_count(pvec); i++) {
-		struct page *page = pvec->pages[i];
-
-		VM_BUG_ON(PageLRU(page));
-		if (put_page_testzero(page))
-			pagevec_add(&pages_to_free, page);
-	}
-	pagevec_free(&pages_to_free);
-	pagevec_reinit(pvec);
-}
-
-/*
  * Add the passed pages to the LRU, then drop the caller's refcount
  * on them.  Reinitialises the caller's pagevec.
  */
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
devices-cgroup-allow-mkfifo.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-inactive_anon_is_low-vmscan-style-cleanup.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-fix-calclation-of-active_ratio.patch
memcg-fix-calclation-of-active_ratio-build-error-fix.patch
memcg-show-real-limit-under-hierarchy-mode.patch
memcg-explain-details-and-test-document.patch
ia64-implement-interrupt-enabling-rwlocks-fix.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

