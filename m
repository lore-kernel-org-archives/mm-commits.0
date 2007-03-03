From: akpm@linux-foundation.org
Subject: + free-swap-space-of-reactivated-pages.patch added to -mm tree
Date: Fri, 02 Mar 2007 17:17:18 -0800
Message-ID: <200703030117.l231HIR8024740@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50718 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992863AbXCCBRd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 20:17:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, hugh@veritas.com


The patch titled
     free swap space of (re)activated pages
has been added to the -mm tree.  Its filename is
     free-swap-space-of-reactivated-pages.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: free swap space of (re)activated pages
From: Rik van Riel <riel@redhat.com>

Free the swap space of already resident pages when swap space starts
getting tight, instead of only freeing up the swap space taken up by newly
swapped in pages.

This should result in the swap space of pages that remain resident in
memory being freed, allowing kswapd more chances to actually swap a page
out (instead of rotating it back onto the active list).

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    1 +
 mm/swap.c               |   18 ++++++++++++++++++
 mm/vmscan.c             |    7 +++++++
 3 files changed, 26 insertions(+)

diff -puN include/linux/pagevec.h~free-swap-space-of-reactivated-pages include/linux/pagevec.h
--- a/include/linux/pagevec.h~free-swap-space-of-reactivated-pages
+++ a/include/linux/pagevec.h
@@ -27,6 +27,7 @@ void __pagevec_lru_add(struct pagevec *p
 void __pagevec_lru_add_active(struct pagevec *pvec);
 void __pagevec_lru_add_mlock(struct pagevec *pvec);
 void pagevec_strip(struct pagevec *pvec);
+void pagevec_swap_free(struct pagevec *pvec);
 unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
 		pgoff_t start, unsigned nr_pages);
 unsigned pagevec_lookup_tag(struct pagevec *pvec,
diff -puN mm/swap.c~free-swap-space-of-reactivated-pages mm/swap.c
--- a/mm/swap.c~free-swap-space-of-reactivated-pages
+++ a/mm/swap.c
@@ -467,6 +467,24 @@ void pagevec_strip(struct pagevec *pvec)
 	}
 }
 
+/*
+ * Try to free swap space from the pages in a pagevec
+ */
+void pagevec_swap_free(struct pagevec *pvec)
+{
+	int i;
+
+	for (i = 0; i < pagevec_count(pvec); i++) {
+		struct page *page = pvec->pages[i];
+
+		if (PageSwapCache(page) && !TestSetPageLocked(page)) {
+			if (PageSwapCache(page))
+				remove_exclusive_swap_page(page);
+			unlock_page(page);
+		}
+	}
+}
+
 /**
  * pagevec_lookup - gang pagecache lookup
  * @pvec:	Where the resulting pages are placed
diff -puN mm/vmscan.c~free-swap-space-of-reactivated-pages mm/vmscan.c
--- a/mm/vmscan.c~free-swap-space-of-reactivated-pages
+++ a/mm/vmscan.c
@@ -598,6 +598,9 @@ mlocked:
 		continue;
 
 activate_locked:
+		/* Not a candidate for swapping, so reclaim swap space. */
+		if (PageSwapCache(page) && vm_swap_full())
+			remove_exclusive_swap_page(page);
 		SetPageActive(page);
 		pgactivate++;
 keep_locked:
@@ -900,6 +903,8 @@ force_reclaim_mapped:
 			__mod_zone_page_state(zone, NR_ACTIVE, pgmoved);
 			pgmoved = 0;
 			spin_unlock_irq(&zone->lru_lock);
+			if (vm_swap_full())
+				pagevec_swap_free(&pvec);
 			__pagevec_release(&pvec);
 			spin_lock_irq(&zone->lru_lock);
 		}
@@ -910,6 +915,8 @@ force_reclaim_mapped:
 	__count_vm_events(PGDEACTIVATE, pgdeactivate);
 	spin_unlock_irq(&zone->lru_lock);
 
+	if (vm_swap_full())
+		pagevec_swap_free(&pvec);
 	pagevec_release(&pvec);
 }
 
_

Patches currently in -mm which might be from riel@redhat.com are

free-swap-space-of-reactivated-pages.patch
