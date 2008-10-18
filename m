From: akpm@linux-foundation.org
Subject: - shm_locked-pages-are-unevictable-add-event-counts-to-list-scan.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:36:43 -0700
Message-ID: <200810182336.m9INahq2032097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355AbYJRXgz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:36:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     unevictable lru: add event counts to list scan
has been removed from the -mm tree.  Its filename was
     shm_locked-pages-are-unevictable-add-event-counts-to-list-scan.patch

This patch was dropped because it was folded into shm_locked-pages-are-unevictable.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unevictable lru: add event counts to list scan
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Fix to shm_locked-pages-are-unevictable.patch

More breaking up of the single unevictable lru/mlocked pages vm events
patch.

Add the vm events counting to the unevictable lru list scanning for
shm_unlock().

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/vmscan.c~shm_locked-pages-are-unevictable-add-event-counts-to-list-scan mm/vmscan.c
--- a/mm/vmscan.c~shm_locked-pages-are-unevictable-add-event-counts-to-list-scan
+++ a/mm/vmscan.c
@@ -2458,6 +2458,7 @@ retry:
 		__dec_zone_state(zone, NR_UNEVICTABLE);
 		list_move(&page->lru, &zone->lru[l].list);
 		__inc_zone_state(zone, NR_INACTIVE_ANON + l);
+		__count_vm_event(UNEVICTABLE_PGRESCUED);
 	} else {
 		/*
 		 * rotate unevictable list
@@ -2491,6 +2492,7 @@ void scan_mapping_unevictable_pages(stru
 	while (next < end &&
 		pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)) {
 		int i;
+		int pg_scanned = 0;
 
 		zone = NULL;
 
@@ -2499,6 +2501,7 @@ void scan_mapping_unevictable_pages(stru
 			pgoff_t page_index = page->index;
 			struct zone *pagezone = page_zone(page);
 
+			pg_scanned++;
 			if (page_index > next)
 				next = page_index;
 			next++;
@@ -2516,6 +2519,8 @@ void scan_mapping_unevictable_pages(stru
 		if (zone)
 			spin_unlock_irq(&zone->lru_lock);
 		pagevec_release(&pvec);
+
+		count_vm_events(UNEVICTABLE_PGSCANNED, pg_scanned);
 	}
 
 }
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

