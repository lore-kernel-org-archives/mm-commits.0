From: akpm@linux-foundation.org
Subject: - unevictable-infrastructure-lru-add-event-counting-with-statistics.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:35:22 -0700
Message-ID: <200810182335.m9INZN8q031938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751054AbYJRXgJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:36:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     unevictable lru:  add event counting with statistics
has been removed from the -mm tree.  Its filename was
     unevictable-infrastructure-lru-add-event-counting-with-statistics.patch

This patch was dropped because it was folded into unevictable-lru-infrastructure.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unevictable lru:  add event counting with statistics
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Fix to unevictable-lru-page-statistics.patch

Add unevictable lru infrastructure vm events to the statistics patch.
Rename the "NORECL_" and "noreclaim_" symbols and text strings to
"UNEVICTABLE_" and "unevictable_", respectively.

Currently, both the infrastructure and the mlocked pages event are
added by a single patch later in the series.  This makes it difficult
to add or rework the incremental patches.  The events actually "belong"
with the stats, so pull them up to here.

Also, restore the event counting to putback_lru_page().  This was removed
from previous patch in series where it was "misplaced".  The actual events
weren't defined that early.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    5 +++++
 mm/vmscan.c            |    6 ++++++
 mm/vmstat.c            |    5 +++++
 3 files changed, 16 insertions(+)

diff -puN include/linux/vmstat.h~unevictable-infrastructure-lru-add-event-counting-with-statistics include/linux/vmstat.h
--- a/include/linux/vmstat.h~unevictable-infrastructure-lru-add-event-counting-with-statistics
+++ a/include/linux/vmstat.h
@@ -41,6 +41,11 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 #ifdef CONFIG_HUGETLB_PAGE
 		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
 #endif
+#ifdef CONFIG_UNEVICTABLE_LRU
+		UNEVICTABLE_PGCULLED,	/* culled to noreclaim list */
+		UNEVICTABLE_PGSCANNED,	/* scanned for reclaimability */
+		UNEVICTABLE_PGRESCUED,	/* rescued from noreclaim list */
+#endif
 		NR_VM_EVENT_ITEMS
 };
 
diff -puN mm/vmscan.c~unevictable-infrastructure-lru-add-event-counting-with-statistics mm/vmscan.c
--- a/mm/vmscan.c~unevictable-infrastructure-lru-add-event-counting-with-statistics
+++ a/mm/vmscan.c
@@ -533,6 +533,7 @@ void putback_lru_page(struct page *page)
 {
 	int lru;
 	int active = !!TestClearPageActive(page);
+	int was_unevictable = PageUnevictable(page);
 
 	VM_BUG_ON(PageLRU(page));
 
@@ -574,6 +575,11 @@ redo:
 		 */
 	}
 
+	if (was_unevictable && lru != LRU_UNEVICTABLE)
+		count_vm_event(UNEVICTABLE_PGRESCUED);
+	else if (!was_unevictable && lru == LRU_UNEVICTABLE)
+		count_vm_event(UNEVICTABLE_PGCULLED);
+
 	put_page(page);		/* drop ref from isolate */
 }
 
diff -puN mm/vmstat.c~unevictable-infrastructure-lru-add-event-counting-with-statistics mm/vmstat.c
--- a/mm/vmstat.c~unevictable-infrastructure-lru-add-event-counting-with-statistics
+++ a/mm/vmstat.c
@@ -677,6 +677,11 @@ static const char * const vmstat_text[] 
 	"htlb_buddy_alloc_success",
 	"htlb_buddy_alloc_fail",
 #endif
+#ifdef CONFIG_UNEVICTABLE_LRU
+	"unevictable_pgs_culled",
+	"unevictable_pgs_scanned",
+	"unevictable_pgs_rescued",
+#endif
 #endif
 };
 
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

vmscan-use-an-indexed-array-for-lru-variables.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
pageflag-helpers-for-configed-out-flags.patch
unevictable-lru-infrastructure.patch
unevictable-infrastructure-lru-add-event-counting-with-statistics.patch
unevictable-lru-page-statistics.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-add-event-counts-to-list-scan.patch
mlock-mlocked-pages-are-unevictable.patch
doc-unevictable-lru-and-mlocked-pages-documentation.patch
doc-unevictable-lru-and-mlocked-pages-documentation-update.patch
doc-unevictable-lru-and-mlocked-pages-documentation-update-2.patch
mlock-downgrade-mmap-sem-while-populating-mlocked-regions.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-__mlock_vma_pages_range-comment-block.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-backout-locked_vm-adjustment-during-mmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-return-value-for-munmap-mlock-vma-race.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-update-locked_vm-on-munmap-of-mlocked-region.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-mlocked-pages-add-event-counting-with-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-count-attempts-to-free-mlocked-page-2.patch
mlock-revert-mainline-handling-of-mlock-error-return.patch
mlock-make-mlock-error-return-posixly-correct.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch

