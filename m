From: akpm@linux-foundation.org
Subject: [merged] mm-remove-pagevec_swap_free.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:38:20 -0700
Message-ID: <200904011838.n31IcKt6008233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758282AbZDASmw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:42:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, hannes@cmpxchg.org, hugh@veritas.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove pagevec_swap_free()
has been removed from the -mm tree.  Its filename was
     mm-remove-pagevec_swap_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -457,29 +457,6 @@ void pagevec_strip(struct pagevec *pvec)
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
