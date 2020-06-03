From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 118/131] mm: swap: memcg: fix memcg stats for huge
 pages
Date: Wed, 03 Jun 2020 16:03:19 -0700
Message-ID: <20200603230319.autuB2_8q%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726600AbgFCXIl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:08:41 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, shakeelb@google.com, torvalds@linux-foundation.org

From: Shakeel Butt <shakeelb@google.com>
Subject: mm: swap: memcg: fix memcg stats for huge pages

The commit 2262185c5b28 ("mm: per-cgroup memory reclaim stats") added
PGLAZYFREE, PGACTIVATE & PGDEACTIVATE stats for cgroups but missed
couple of places and PGLAZYFREE missed huge page handling. Fix that.
Also for PGLAZYFREE use the irq-unsafe function to update as the irq is
already disabled.

Link: http://lkml.kernel.org/r/20200527182947.251343-1-shakeelb@google.com
Fixes: 2262185c5b28 ("mm: per-cgroup memory reclaim stats")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/mm/swap.c~mm-swap-memcg-fix-memcg-stats-for-huge-pages
+++ a/mm/swap.c
@@ -320,6 +320,7 @@ static void __activate_page(struct page
 {
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 		int lru = page_lru_base_type(page);
+		int nr_pages = hpage_nr_pages(page);
 
 		del_page_from_lru_list(page, lruvec, lru);
 		SetPageActive(page);
@@ -327,7 +328,9 @@ static void __activate_page(struct page
 		add_page_to_lru_list(page, lruvec, lru);
 		trace_mm_lru_activate(page);
 
-		__count_vm_events(PGACTIVATE, hpage_nr_pages(page));
+		__count_vm_events(PGACTIVATE, nr_pages);
+		__count_memcg_events(lruvec_memcg(lruvec), PGACTIVATE,
+				     nr_pages);
 	}
 }
 
@@ -565,8 +568,11 @@ static void lru_deactivate_file_fn(struc
 		__count_vm_events(PGROTATED, nr_pages);
 	}
 
-	if (active)
+	if (active) {
 		__count_vm_events(PGDEACTIVATE, nr_pages);
+		__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE,
+				     nr_pages);
+	}
 }
 
 static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec,
@@ -574,13 +580,16 @@ static void lru_deactivate_fn(struct pag
 {
 	if (PageLRU(page) && PageActive(page) && !PageUnevictable(page)) {
 		int lru = page_lru_base_type(page);
+		int nr_pages = hpage_nr_pages(page);
 
 		del_page_from_lru_list(page, lruvec, lru + LRU_ACTIVE);
 		ClearPageActive(page);
 		ClearPageReferenced(page);
 		add_page_to_lru_list(page, lruvec, lru);
 
-		__count_vm_events(PGDEACTIVATE, hpage_nr_pages(page));
+		__count_vm_events(PGDEACTIVATE, nr_pages);
+		__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE,
+				     nr_pages);
 	}
 }
 
@@ -590,6 +599,7 @@ static void lru_lazyfree_fn(struct page
 	if (PageLRU(page) && PageAnon(page) && PageSwapBacked(page) &&
 	    !PageSwapCache(page) && !PageUnevictable(page)) {
 		bool active = PageActive(page);
+		int nr_pages = hpage_nr_pages(page);
 
 		del_page_from_lru_list(page, lruvec,
 				       LRU_INACTIVE_ANON + active);
@@ -603,8 +613,9 @@ static void lru_lazyfree_fn(struct page
 		ClearPageSwapBacked(page);
 		add_page_to_lru_list(page, lruvec, LRU_INACTIVE_FILE);
 
-		__count_vm_events(PGLAZYFREE, hpage_nr_pages(page));
-		count_memcg_page_event(page, PGLAZYFREE);
+		__count_vm_events(PGLAZYFREE, nr_pages);
+		__count_memcg_events(lruvec_memcg(lruvec), PGLAZYFREE,
+				     nr_pages);
 	}
 }
 
_
