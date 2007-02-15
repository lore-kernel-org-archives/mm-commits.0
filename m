From: akpm@linux-foundation.org
Subject: + make-try_to_unmap-return-a-special-exit-code.patch added to -mm tree
Date: Wed, 14 Feb 2007 21:42:27 -0800
Message-ID: <200702150542.l1F5gRja021096@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35563 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932237AbXBOFmc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 00:42:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Make try_to_unmap return a special exit code
has been added to the -mm tree.  Its filename is
     make-try_to_unmap-return-a-special-exit-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -631,10 +631,16 @@ static int try_to_unmap_one(struct page 
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
@@ -799,7 +805,8 @@ static int try_to_unmap_anon(struct page
 
 	list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
 		ret = try_to_unmap_one(page, vma, migration);
-		if (ret == SWAP_FAIL || !page_mapped(page))
+		if (ret == SWAP_FAIL || ret == SWAP_MLOCK ||
+				!page_mapped(page))
 			break;
 	}
 	spin_unlock(&anon_vma->lock);
@@ -830,7 +837,8 @@ static int try_to_unmap_file(struct page
 	spin_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		ret = try_to_unmap_one(page, vma, migration);
-		if (ret == SWAP_FAIL || !page_mapped(page))
+		if (ret == SWAP_FAIL || ret == SWAP_MLOCK ||
+				!page_mapped(page))
 			goto out;
 	}
 
@@ -913,6 +921,7 @@ out:
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
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages-fix.patch
make-try_to_unmap-return-a-special-exit-code.patch
add-pagemlocked-page-state-bit-and-lru-infrastructure.patch
add-nr_mlock-zvc.patch
logic-to-move-mlocked-pages.patch
consolidate-new-anonymous-page-code-paths.patch
avoid-putting-new-mlocked-anonymous-pages-on-lru.patch
opportunistically-move-mlocked-pages-off-the-lru.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids-fix.patch
slab-reduce-size-of-alien-cache-to-cover-only-possible-nodes.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
mm-implement-swap-prefetching-vs-zvc-stuff.patch
mm-implement-swap-prefetching-vs-zvc-stuff-2.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-aging-accounting-vs-zvc-changes.patch
