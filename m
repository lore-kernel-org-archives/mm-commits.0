From: akpm@linux-foundation.org
Subject: + mm-remove-pagevec_swap_free.patch added to -mm tree
Date: Mon, 02 Mar 2009 13:18:43 -0800
Message-ID: <200903022118.n22LIiDb023335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941AbZCBVTU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 16:19:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, hannes@cmpxchg.org, hugh@veritas.com, riel@redhat.com


The patch titled
     mm: remove pagevec_swap_free()
has been added to the -mm tree.  Its filename is
     mm-remove-pagevec_swap_free.patch

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
Subject: mm: remove pagevec_swap_free()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

pagevec_swap_free() is now unused.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    1 -
 mm/swap.c               |   23 -----------------------
 2 files changed, 24 deletions(-)

diff -puN include/linux/pagevec.h~mm-remove-pagevec_swap_free include/linux/pagevec.h
--- a/include/linux/pagevec.h~mm-remove-pagevec_swap_free
+++ a/include/linux/pagevec.h
@@ -24,7 +24,6 @@ void __pagevec_release(struct pagevec *p
 void __pagevec_free(struct pagevec *pvec);
 void ____pagevec_lru_add(struct pagevec *pvec, enum lru_list lru);
 void pagevec_strip(struct pagevec *pvec);
-void pagevec_swap_free(struct pagevec *pvec);
 unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
 		pgoff_t start, unsigned nr_pages);
 unsigned pagevec_lookup_tag(struct pagevec *pvec,
diff -puN mm/swap.c~mm-remove-pagevec_swap_free mm/swap.c
--- a/mm/swap.c~mm-remove-pagevec_swap_free
+++ a/mm/swap.c
@@ -471,29 +471,6 @@ void pagevec_strip(struct pagevec *pvec)
 }
 
 /**
- * pagevec_swap_free - try to free swap space from the pages in a pagevec
- * @pvec: pagevec with swapcache pages to free the swap space of
- *
- * The caller needs to hold an extra reference to each page and
- * not hold the page lock on the pages.  This function uses a
- * trylock on the page lock so it may not always free the swap
- * space associated with a page.
- */
-void pagevec_swap_free(struct pagevec *pvec)
-{
-	int i;
-
-	for (i = 0; i < pagevec_count(pvec); i++) {
-		struct page *page = pvec->pages[i];
-
-		if (PageSwapCache(page) && trylock_page(page)) {
-			try_to_free_swap(page);
-			unlock_page(page);
-		}
-	}
-}
-
-/**
  * pagevec_lookup - gang pagecache lookup
  * @pvec:	Where the resulting pages are placed
  * @mapping:	The address_space to search
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-dont-call-mark_page_accessed-in-do_swap_page.patch
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch
mm-shrink_all_memory-use-scnr_reclaimed.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
vmscan-clip-swap_cluster_max-in-shrink_all_memory.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page-fix.patch
vmscan-respect-higher-order-in-zone_reclaim.patch
mm-remove-pagevec_swap_free.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch
memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch
ia64-implement-interrupt-enabling-rwlocks.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

