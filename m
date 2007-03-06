From: akpm@linux-foundation.org
Subject: - make-try_to_unmap-return-a-special-exit-code.patch removed from -mm tree
Date: Mon, 05 Mar 2007 20:42:16 -0800
Message-ID: <200703060442.l264gGkV012054@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50620 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227AbXCFEmT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 23:42:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Make try_to_unmap return a special exit code
has been removed from the -mm tree.  Its filename was
     make-try_to_unmap-return-a-special-exit-code.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Make try_to_unmap return a special exit code
From: Christoph Lameter <clameter@sgi.com>

The patchset removes mlocked pages from the LRU and maintains a counter for
the number of discovered mlocked pages.

This is a lazy scheme for accounting for mlocked pages.  The pages may only be
discovered to be mlocked during reclaim.  However, we attempt to detect
mlocked pages at various other opportune moments.  So in general the mlock
counter is not far off the number of actual mlocked pages in the system.



This patch:

Modify try_to_unmap() so that we can distinguish failing to unmap due to a
mlocked page from other causes.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    1 +
 mm/rmap.c            |   21 +++++++++++++++------
 mm/vmscan.c          |    1 +
 3 files changed, 17 insertions(+), 6 deletions(-)

diff -puN include/linux/rmap.h~make-try_to_unmap-return-a-special-exit-code include/linux/rmap.h
--- a/include/linux/rmap.h~make-try_to_unmap-return-a-special-exit-code
+++ a/include/linux/rmap.h
@@ -134,5 +134,6 @@ static inline int page_mkclean(struct pa
 #define SWAP_SUCCESS	0
 #define SWAP_AGAIN	1
 #define SWAP_FAIL	2
+#define SWAP_MLOCK	3
 
 #endif	/* _LINUX_RMAP_H */
diff -puN mm/rmap.c~make-try_to_unmap-return-a-special-exit-code mm/rmap.c
--- a/mm/rmap.c~make-try_to_unmap-return-a-special-exit-code
+++ a/mm/rmap.c
@@ -639,10 +639,16 @@ static int try_to_unmap_one(struct page 
 	 * If it's recently referenced (perhaps page_referenced
 	 * skipped over this mm) then we should reactivate it.
 	 */
-	if (!migration && ((vma->vm_flags & VM_LOCKED) ||
-			(ptep_clear_flush_young(vma, address, pte)))) {
-		ret = SWAP_FAIL;
-		goto out_unmap;
+	if (!migration) {
+		if (vma->vm_flags & VM_LOCKED) {
+			ret = SWAP_MLOCK;
+			goto out_unmap;
+		}
+
+		if (ptep_clear_flush_young(vma, address, pte)) {
+			ret = SWAP_FAIL;
+			goto out_unmap;
+		}
 	}
 
 	/* Nuke the page table entry. */
@@ -807,7 +813,8 @@ static int try_to_unmap_anon(struct page
 
 	list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
 		ret = try_to_unmap_one(page, vma, migration);
-		if (ret == SWAP_FAIL || !page_mapped(page))
+		if (ret == SWAP_FAIL || ret == SWAP_MLOCK ||
+				!page_mapped(page))
 			break;
 	}
 
@@ -839,7 +846,8 @@ static int try_to_unmap_file(struct page
 	spin_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		ret = try_to_unmap_one(page, vma, migration);
-		if (ret == SWAP_FAIL || !page_mapped(page))
+		if (ret == SWAP_FAIL || ret == SWAP_MLOCK ||
+				!page_mapped(page))
 			goto out;
 	}
 
@@ -922,6 +930,7 @@ out:
  * SWAP_SUCCESS	- we succeeded in removing all mappings
  * SWAP_AGAIN	- we missed a mapping, try again later
  * SWAP_FAIL	- the page is unswappable
+ * SWAP_MLOCK	- the page is under mlock()
  */
 int try_to_unmap(struct page *page, int migration)
 {
diff -puN mm/vmscan.c~make-try_to_unmap-return-a-special-exit-code mm/vmscan.c
--- a/mm/vmscan.c~make-try_to_unmap-return-a-special-exit-code
+++ a/mm/vmscan.c
@@ -509,6 +509,7 @@ static unsigned long shrink_page_list(st
 		if (page_mapped(page) && mapping) {
 			switch (try_to_unmap(page, 0)) {
 			case SWAP_FAIL:
+			case SWAP_MLOCK:
 				goto activate_locked;
 			case SWAP_AGAIN:
 				goto keep_locked;
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
make-try_to_unmap-return-a-special-exit-code.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
