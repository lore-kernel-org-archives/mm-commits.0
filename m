From: akpm@linux-foundation.org
Subject: - unevictable-lru-infrastructure-defer-vm-event-counting.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:35:15 -0700
Message-ID: <200810182335.m9INZFqh031899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388AbYJRXgK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:36:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     unevictable lru:  defer vm event counting
has been removed from the -mm tree.  Its filename was
     unevictable-lru-infrastructure-defer-vm-event-counting.patch

This patch was dropped because it was folded into unevictable-lru-infrastructure.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unevictable lru:  defer vm event counting
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Fix to unevictable-lru-infrastructure.patch

NORECL_* events are not defined this early in the series.  Remove the
event counting from this patch and add in with unevictable lru statistics
[subsequent patch].

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN mm/vmscan.c~unevictable-lru-infrastructure-defer-vm-event-counting mm/vmscan.c
--- a/mm/vmscan.c~unevictable-lru-infrastructure-defer-vm-event-counting
+++ a/mm/vmscan.c
@@ -533,7 +533,6 @@ void putback_lru_page(struct page *page)
 {
 	int lru;
 	int active = !!TestClearPageActive(page);
-	int was_unevictable = PageUnevictable(page);
 
 	VM_BUG_ON(PageLRU(page));
 
@@ -575,11 +574,6 @@ redo:
 		 */
 	}
 
- /*	if (was_unevictable && lru != LRU_UNEVICTABLE)
-		count_vm_event(NORECL_PGRESCUED);
-	else if (!was_unevictable && lru == LRU_UNEVICTABLE)
-		count_vm_event(NORECL_PGCULLED);	*/
-
 	put_page(page);		/* drop ref from isolate */
 }
 
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

vmscan-use-an-indexed-array-for-lru-variables.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
pageflag-helpers-for-configed-out-flags.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-defer-vm-event-counting.patch
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

