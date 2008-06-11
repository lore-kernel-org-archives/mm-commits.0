From: akpm@linux-foundation.org
Subject: + vmstat-unevictable-and-mlocked-pages-vm-events.patch added to -mm tree
Date: Wed, 11 Jun 2008 13:00:10 -0700
Message-ID: <200806112000.m5BK0AA6015261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757217AbYFKUAf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 16:00:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     vmstat: unevictable and mlocked pages vm events
has been added to the -mm tree.  Its filename is
     vmstat-unevictable-and-mlocked-pages-vm-events.patch

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
Subject: vmstat: unevictable and mlocked pages vm events
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Add some event counters to vmstats for testing unevictable/mlock.  Some of
these might be interesting enough to keep around.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    9 +++++++++
 mm/internal.h          |    4 +++-
 mm/mlock.c             |   33 +++++++++++++++++++++++++--------
 mm/vmscan.c            |   16 +++++++++++++++-
 mm/vmstat.c            |   10 ++++++++++
 5 files changed, 62 insertions(+), 10 deletions(-)

diff -puN include/linux/vmstat.h~vmstat-unevictable-and-mlocked-pages-vm-events include/linux/vmstat.h
--- a/include/linux/vmstat.h~vmstat-unevictable-and-mlocked-pages-vm-events
+++ a/include/linux/vmstat.h
@@ -41,6 +41,15 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 #ifdef CONFIG_HUGETLB_PAGE
 		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
 #endif
+#ifdef CONFIG_UNEVICTABLE_LRU
+		NORECL_PGCULLED,	/* culled to noreclaim list */
+		NORECL_PGSCANNED,	/* scanned for reclaimability */
+		NORECL_PGRESCUED,	/* rescued from noreclaim list */
+		NORECL_PGMLOCKED,
+		NORECL_PGMUNLOCKED,
+		NORECL_PGCLEARED,
+		NORECL_PGSTRANDED,	/* unable to isolate on unlock */
+#endif
 		NR_VM_EVENT_ITEMS
 };
 
diff -puN mm/internal.h~vmstat-unevictable-and-mlocked-pages-vm-events mm/internal.h
--- a/mm/internal.h~vmstat-unevictable-and-mlocked-pages-vm-events
+++ a/mm/internal.h
@@ -101,8 +101,10 @@ static inline int is_mlocked_vma(struct 
 	if (likely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) != VM_LOCKED))
 		return 0;
 
-	if (!TestSetPageMlocked(page))
+	if (!TestSetPageMlocked(page)) {
 		inc_zone_page_state(page, NR_MLOCK);
+		count_vm_event(NORECL_PGMLOCKED);
+	}
 	return 1;
 }
 
diff -puN mm/mlock.c~vmstat-unevictable-and-mlocked-pages-vm-events mm/mlock.c
--- a/mm/mlock.c~vmstat-unevictable-and-mlocked-pages-vm-events
+++ a/mm/mlock.c
@@ -18,6 +18,7 @@
 #include <linux/rmap.h>
 #include <linux/mmzone.h>
 #include <linux/hugetlb.h>
+#include <linux/vmstat.h>
 
 #include "internal.h"
 
@@ -57,6 +58,7 @@ void __clear_page_mlock(struct page *pag
 	VM_BUG_ON(!PageLocked(page));	/* for LRU isolate/putback */
 
 	dec_zone_page_state(page, NR_MLOCK);
+	count_vm_event(NORECL_PGCLEARED);
 	if (!isolate_lru_page(page)) {
 		putback_lru_page(page);
 	} else {
@@ -66,6 +68,8 @@ void __clear_page_mlock(struct page *pag
 		lru_add_drain_all();
 		if (!isolate_lru_page(page))
 			putback_lru_page(page);
+		else if (PageUnevictable(page))
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
-			try_to_munlock(page);	/* maybe relock the page */
+			int ret = try_to_munlock(page);
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
+			if (PageUnevictable(page))
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
 
diff -puN mm/vmscan.c~vmstat-unevictable-and-mlocked-pages-vm-events mm/vmscan.c
--- a/mm/vmscan.c~vmstat-unevictable-and-mlocked-pages-vm-events
+++ a/mm/vmscan.c
@@ -486,12 +486,13 @@ int putback_lru_page(struct page *page)
 {
 	int lru;
 	int ret = 1;
+	int was_unevictable;
 
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(PageLRU(page));
 
 	lru = !!TestClearPageActive(page);
-	ClearPageUnevictable(page);	/* for page_evictable() */
+	was_unevictable = TestClearPageUnevictable(page); /* for page_evictable() */
 
 	if (unlikely(!page->mapping)) {
 		/*
@@ -511,6 +512,10 @@ int putback_lru_page(struct page *page)
 		lru += page_is_file_cache(page);
 		lru_cache_add_lru(page, lru);
 		mem_cgroup_move_lists(page, lru);
+#ifdef CONFIG_UNEVICTABLE_LRU
+		if (was_unevictable)
+			count_vm_event(NORECL_PGRESCUED);
+#endif
 	} else {
 		/*
 		 * Put unevictable pages directly on zone's unevictable
@@ -518,6 +523,10 @@ int putback_lru_page(struct page *page)
 		 */
 		add_page_to_unevictable_list(page);
 		mem_cgroup_move_lists(page, LRU_UNEVICTABLE);
+#ifdef CONFIG_UNEVICTABLE_LRU
+		if (!was_unevictable)
+			count_vm_event(NORECL_PGCULLED);
+#endif
 	}
 
 	put_page(page);		/* drop ref from isolate */
@@ -2407,6 +2416,7 @@ static void check_move_unevictable_page(
 		__dec_zone_state(zone, NR_UNEVICTABLE);
 		list_move(&page->lru, &zone->lru[l].list);
 		__inc_zone_state(zone, NR_INACTIVE_ANON + l);
+		__count_vm_event(NORECL_PGRESCUED);
 	} else {
 		/*
 		 * rotate unevictable list
@@ -2438,6 +2448,7 @@ void scan_mapping_unevictable_pages(stru
 	while (next < end &&
 		pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)) {
 		int i;
+		int pg_scanned = 0;
 
 		zone = NULL;
 
@@ -2446,6 +2457,7 @@ void scan_mapping_unevictable_pages(stru
 			pgoff_t page_index = page->index;
 			struct zone *pagezone = page_zone(page);
 
+			pg_scanned++;
 			if (page_index > next)
 				next = page_index;
 			next++;
@@ -2476,6 +2488,8 @@ void scan_mapping_unevictable_pages(stru
 		if (zone)
 			spin_unlock_irq(&zone->lru_lock);
 		pagevec_release(&pvec);
+
+		count_vm_events(NORECL_PGSCANNED, pg_scanned);
 	}
 
 }
diff -puN mm/vmstat.c~vmstat-unevictable-and-mlocked-pages-vm-events mm/vmstat.c
--- a/mm/vmstat.c~vmstat-unevictable-and-mlocked-pages-vm-events
+++ a/mm/vmstat.c
@@ -664,6 +664,16 @@ static const char * const vmstat_text[] 
 	"htlb_buddy_alloc_success",
 	"htlb_buddy_alloc_fail",
 #endif
+
+#ifdef CONFIG_UNEVICTABLE_LRU
+	"noreclaim_pgs_culled",
+	"noreclaim_pgs_scanned",
+	"noreclaim_pgs_rescued",
+	"noreclaim_pgs_mlocked",
+	"noreclaim_pgs_munlocked",
+	"noreclaim_pgs_cleared",
+	"noreclaim_pgs_stranded",
+#endif
 #endif
 };
 
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
define-page_file_cache-function.patch
pageflag-helpers-for-configed-out-flags.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
shm_locked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-downgrade-mmap-sem-while-populating-mlocked-regions.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-count-attempts-to-free-mlocked-page.patch
doc-unevictable-lru-and-mlocked-pages-documentation.patch

