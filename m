From: akpm@linux-foundation.org
Subject: + vmscan-noreclaim-and-mlocked-pages-vm-events.patch added to -mm tree
Date: Sun, 08 Jun 2008 23:18:47 -0700
Message-ID: <200806090618.m596Ilvx006655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755526AbYFIGTP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 02:19:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     vmscan: noreclaim and mlocked pages vm events
has been added to the -mm tree.  Its filename is
     vmscan-noreclaim-and-mlocked-pages-vm-events.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: noreclaim and mlocked pages vm events
From: Lee Schermerhorn <lee.schermerhorn@hp.com>


Against:  2.6.26-rc2-mm1

Add some event counters to vmstats for testing noreclaim/mlock.
Some of these might be interesting enough to keep around.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>

---

Index: linux-2.6.26-rc2-mm1/include/linux/vmstat.h
===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |   11 +++++++++++
 mm/internal.h          |    4 +++-
 mm/mlock.c             |   33 +++++++++++++++++++++++++--------
 mm/vmscan.c            |   16 +++++++++++++++-
 mm/vmstat.c            |   12 ++++++++++++
 5 files changed, 66 insertions(+), 10 deletions(-)

diff -puN include/linux/vmstat.h~noreclaim-and-mlocked-pages-vm-events include/linux/vmstat.h
--- a/include/linux/vmstat.h~noreclaim-and-mlocked-pages-vm-events
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
 
diff -puN mm/internal.h~noreclaim-and-mlocked-pages-vm-events mm/internal.h
--- a/mm/internal.h~noreclaim-and-mlocked-pages-vm-events
+++ a/mm/internal.h
@@ -110,8 +110,10 @@ static inline int is_mlocked_vma(struct 
 	if (likely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) != VM_LOCKED))
 		return 0;
 
-	if (!TestSetPageMlocked(page))
+	if (!TestSetPageMlocked(page)) {
 		inc_zone_page_state(page, NR_MLOCK);
+		count_vm_event(NORECL_PGMLOCKED);
+	}
 	return 1;
 }
 
diff -puN mm/mlock.c~noreclaim-and-mlocked-pages-vm-events mm/mlock.c
--- a/mm/mlock.c~noreclaim-and-mlocked-pages-vm-events
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
 
diff -puN mm/vmscan.c~noreclaim-and-mlocked-pages-vm-events mm/vmscan.c
--- a/mm/vmscan.c~noreclaim-and-mlocked-pages-vm-events
+++ a/mm/vmscan.c
@@ -462,12 +462,13 @@ int putback_lru_page(struct page *page)
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
@@ -487,6 +488,10 @@ int putback_lru_page(struct page *page)
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
@@ -494,6 +499,10 @@ int putback_lru_page(struct page *page)
 		 */
 		add_page_to_noreclaim_list(page);
 		mem_cgroup_move_lists(page, LRU_NORECLAIM);
+#ifdef CONFIG_NORECLAIM_LRU
+		if (!was_nonreclaimable)
+			count_vm_event(NORECL_PGCULLED);
+#endif
 	}
 
 	put_page(page);		/* drop ref from isolate */
@@ -2384,6 +2393,7 @@ static void check_move_noreclaim_page(st
 		__dec_zone_state(zone, NR_NORECLAIM);
 		list_move(&page->lru, &zone->list[l]);
 		__inc_zone_state(zone, NR_INACTIVE_ANON + l);
+		__count_vm_event(NORECL_PGRESCUED);
 	} else {
 		/*
 		 * rotate noreclaim list
@@ -2415,6 +2425,7 @@ void scan_mapping_noreclaim_pages(struct
 	while (next < end &&
 		pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)) {
 		int i;
+		int pg_scanned = 0;
 
 		zone = NULL;
 
@@ -2423,6 +2434,7 @@ void scan_mapping_noreclaim_pages(struct
 			pgoff_t page_index = page->index;
 			struct zone *pagezone = page_zone(page);
 
+			pg_scanned++;
 			if (page_index > next)
 				next = page_index;
 			next++;
@@ -2453,6 +2465,8 @@ void scan_mapping_noreclaim_pages(struct
 		if (zone)
 			spin_unlock_irq(&zone->lru_lock);
 		pagevec_release(&pvec);
+
+		count_vm_events(NORECL_PGSCANNED, pg_scanned);
 	}
 
 }
diff -puN mm/vmstat.c~noreclaim-and-mlocked-pages-vm-events mm/vmstat.c
--- a/mm/vmstat.c~noreclaim-and-mlocked-pages-vm-events
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
vmscan-use-an-indexed-array-for-lru-variables.patch
vmscan-define-page_file_cache-function.patch
vmscan-pageflag-helpers-for-configed-out-flags.patch
vmscan-noreclaim-lru-infrastructure.patch
vmscan-noreclaim-lru-page-statistics.patch
vmscan-ramfs-and-ram-disk-pages-are-non-reclaimable.patch
vmscan-shm_locked-pages-are-non-reclaimable.patch
vmscan-mlocked-pages-are-non-reclaimable.patch
vmscan-downgrade-mmap-sem-while-populating-mlocked-regions.patch
vmscan-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-mlocked-pages-statistics.patch
vmscan-cull-non-reclaimable-pages-in-fault-path.patch
vmscan-noreclaim-and-mlocked-pages-vm-events.patch
mm-only-vmscan-noreclaim-lru-scan-sysctl.patch
vmscan-mlocked-pages-count-attempts-to-free-mlocked-page.patch
vmscan-noreclaim-lru-and-mlocked-pages-documentation.patch

