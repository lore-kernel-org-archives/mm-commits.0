From: akpm@linux-foundation.org
Subject: - vmscan-noreclaim-and-mlocked-pages-vm-events.patch removed from -mm tree
Date: Wed, 11 Jun 2008 12:46:45 -0700
Message-ID: <200806111946.m5BJkjIr014614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750700AbYFKTrX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 15:47:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: noreclaim and mlocked pages vm events
has been removed from the -mm tree.  Its filename was
     vmscan-noreclaim-and-mlocked-pages-vm-events.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: noreclaim and mlocked pages vm events
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Add some event counters to vmstats for testing noreclaim/mlock.  Some of
these might be interesting enough to keep around.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |   11 +++++++++++
 mm/internal.h          |    4 +++-
 mm/mlock.c             |   33 +++++++++++++++++++++++++--------
 mm/vmscan.c            |   16 +++++++++++++++-
 mm/vmstat.c            |   12 ++++++++++++
 5 files changed, 66 insertions(+), 10 deletions(-)

diff -puN include/linux/vmstat.h~vmscan-noreclaim-and-mlocked-pages-vm-events include/linux/vmstat.h
--- a/include/linux/vmstat.h~vmscan-noreclaim-and-mlocked-pages-vm-events
+++ a/include/linux/vmstat.h
@@ -41,6 +41,17 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 #ifdef CONFIG_HUGETLB_PAGE
 		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
 #endif
+#ifdef CONFIG_NORECLAIM_LRU
+		NORECL_PGCULLED,	/* culled to noreclaim list */
+		NORECL_PGSCANNED,	/* scanned for reclaimability */
+		NORECL_PGRESCUED,	/* rescued from noreclaim list */
+#ifdef CONFIG_NORECLAIM_MLOCK
+		NORECL_PGMLOCKED,
+		NORECL_PGMUNLOCKED,
+		NORECL_PGCLEARED,
+		NORECL_PGSTRANDED,	/* unable to isolate on unlock */
+#endif
+#endif
 		NR_VM_EVENT_ITEMS
 };
 
diff -puN mm/internal.h~vmscan-noreclaim-and-mlocked-pages-vm-events mm/internal.h
--- a/mm/internal.h~vmscan-noreclaim-and-mlocked-pages-vm-events
+++ a/mm/internal.h
@@ -112,8 +112,10 @@ static inline int is_mlocked_vma(struct 
 	if (likely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) != VM_LOCKED))
 		return 0;
 
-	if (!TestSetPageMlocked(page))
+	if (!TestSetPageMlocked(page)) {
 		inc_zone_page_state(page, NR_MLOCK);
+		count_vm_event(NORECL_PGMLOCKED);
+	}
 	return 1;
 }
 
diff -puN mm/mlock.c~vmscan-noreclaim-and-mlocked-pages-vm-events mm/mlock.c
--- a/mm/mlock.c~vmscan-noreclaim-and-mlocked-pages-vm-events
+++ a/mm/mlock.c
@@ -18,6 +18,7 @@
 #include <linux/rmap.h>
 #include <linux/mmzone.h>
 #include <linux/hugetlb.h>
+#include <linux/vmstat.h>
 
 #include "internal.h"
 
@@ -57,6 +58,7 @@ void __clear_page_mlock(struct page *pag
 	VM_BUG_ON(!PageLocked(page));	/* for LRU islolate/putback */
 
 	dec_zone_page_state(page, NR_MLOCK);
+	count_vm_event(NORECL_PGCLEARED);
 	if (!isolate_lru_page(page)) {
 		putback_lru_page(page);
 	} else {
@@ -66,6 +68,8 @@ void __clear_page_mlock(struct page *pag
 		lru_add_drain_all();
 		if (!isolate_lru_page(page))
 			putback_lru_page(page);
+		else if (PageNoreclaim(page))
+			count_vm_event(NORECL_PGSTRANDED);
 	}
 }
 
@@ -79,6 +83,7 @@ void mlock_vma_page(struct page *page)
 
 	if (!TestSetPageMlocked(page)) {
 		inc_zone_page_state(page, NR_MLOCK);
+		count_vm_event(NORECL_PGMLOCKED);
 		if (!isolate_lru_page(page))
 			putback_lru_page(page);
 	}
@@ -109,16 +114,28 @@ static void munlock_vma_page(struct page
 	if (TestClearPageMlocked(page)) {
 		dec_zone_page_state(page, NR_MLOCK);
 		if (!isolate_lru_page(page)) {
-			try_to_unlock(page);	/* maybe relock the page */
+			int ret = try_to_unlock(page);
+			/*
+			 * did try_to_unlock() succeed or punt?
+			 */
+			if (ret == SWAP_SUCCESS || ret == SWAP_AGAIN)
+				count_vm_event(NORECL_PGMUNLOCKED);
+
 			putback_lru_page(page);
+		} else {
+			/*
+			 * We lost the race.  let try_to_unmap() deal
+			 * with it.  At least we get the page state and
+			 * mlock stats right.  However, page is still on
+			 * the noreclaim list.  We'll fix that up when
+			 * the page is eventually freed or we scan the
+			 * noreclaim list.
+			 */
+			if (PageNoreclaim(page))
+				count_vm_event(NORECL_PGSTRANDED);
+			else
+				count_vm_event(NORECL_PGMUNLOCKED);
 		}
-		/*
-		 * Else we lost the race.  let try_to_unmap() deal with it.
-		 * At least we get the page state and mlock stats right.
-		 * However, page is still on the noreclaim list.  We'll fix
-		 * that up when the page is eventually freed or we scan the
-		 * noreclaim list.
-		 */
 	}
 }
 
diff -puN mm/vmscan.c~vmscan-noreclaim-and-mlocked-pages-vm-events mm/vmscan.c
--- a/mm/vmscan.c~vmscan-noreclaim-and-mlocked-pages-vm-events
+++ a/mm/vmscan.c
@@ -463,12 +463,13 @@ int putback_lru_page(struct page *page)
 {
 	int lru;
 	int ret = 1;
+	int was_nonreclaimable;
 
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(PageLRU(page));
 
 	lru = !!TestClearPageActive(page);
-	ClearPageNoreclaim(page);	/* for page_reclaimable() */
+	was_nonreclaimable = TestClearPageNoreclaim(page);
 
 	if (unlikely(!page->mapping)) {
 		/*
@@ -488,6 +489,10 @@ int putback_lru_page(struct page *page)
 		lru += page_file_cache(page);
 		lru_cache_add_lru(page, lru);
 		mem_cgroup_move_lists(page, lru);
+#ifdef CONFIG_NORECLAIM_LRU
+		if (was_nonreclaimable)
+			count_vm_event(NORECL_PGRESCUED);
+#endif
 	} else {
 		/*
 		 * Put non-reclaimable pages directly on zone's noreclaim
@@ -495,6 +500,10 @@ int putback_lru_page(struct page *page)
 		 */
 		add_page_to_noreclaim_list(page);
 		mem_cgroup_move_lists(page, LRU_NORECLAIM);
+#ifdef CONFIG_NORECLAIM_LRU
+		if (!was_nonreclaimable)
+			count_vm_event(NORECL_PGCULLED);
+#endif
 	}
 
 	put_page(page);		/* drop ref from isolate */
@@ -2396,6 +2405,7 @@ static void check_move_noreclaim_page(st
 		__dec_zone_state(zone, NR_NORECLAIM);
 		list_move(&page->lru, &zone->list[l]);
 		__inc_zone_state(zone, NR_INACTIVE_ANON + l);
+		__count_vm_event(NORECL_PGRESCUED);
 	} else {
 		/*
 		 * rotate noreclaim list
@@ -2427,6 +2437,7 @@ void scan_mapping_noreclaim_pages(struct
 	while (next < end &&
 		pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)) {
 		int i;
+		int pg_scanned = 0;
 
 		zone = NULL;
 
@@ -2435,6 +2446,7 @@ void scan_mapping_noreclaim_pages(struct
 			pgoff_t page_index = page->index;
 			struct zone *pagezone = page_zone(page);
 
+			pg_scanned++;
 			if (page_index > next)
 				next = page_index;
 			next++;
@@ -2465,6 +2477,8 @@ void scan_mapping_noreclaim_pages(struct
 		if (zone)
 			spin_unlock_irq(&zone->lru_lock);
 		pagevec_release(&pvec);
+
+		count_vm_events(NORECL_PGSCANNED, pg_scanned);
 	}
 
 }
diff -puN mm/vmstat.c~vmscan-noreclaim-and-mlocked-pages-vm-events mm/vmstat.c
--- a/mm/vmstat.c~vmscan-noreclaim-and-mlocked-pages-vm-events
+++ a/mm/vmstat.c
@@ -666,6 +666,18 @@ static const char * const vmstat_text[] 
 	"htlb_buddy_alloc_success",
 	"htlb_buddy_alloc_fail",
 #endif
+
+#ifdef CONFIG_NORECLAIM_LRU
+	"noreclaim_pgs_culled",
+	"noreclaim_pgs_scanned",
+	"noreclaim_pgs_rescued",
+#ifdef CONFIG_NORECLAIM_MLOCK
+	"noreclaim_pgs_mlocked",
+	"noreclaim_pgs_munlocked",
+	"noreclaim_pgs_cleared",
+	"noreclaim_pgs_stranded",
+#endif
+#endif
 #endif
 };
 
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
vmscan-noreclaim-and-mlocked-pages-vm-events.patch
mm-only-vmscan-noreclaim-lru-scan-sysctl.patch
mm-only-vmscan-noreclaim-lru-scan-sysctl-fix.patch
vmscan-mlocked-pages-count-attempts-to-free-mlocked-page.patch
vmscan-noreclaim-lru-and-mlocked-pages-documentation.patch

