From: akpm@linux-foundation.org
Subject: + take-anonymous-pages-off-the-lru-if-we-have-no-swap.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:55:35 -0800
Message-ID: <200702272055.l1RKtdpG028283@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51608 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbXB0Uzt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:55:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, hugh@veritas.com, nickpiggin@yahoo.com.au


The patch titled
     Take anonymous pages off the LRU if we have no swap
has been added to the -mm tree.  Its filename is
     take-anonymous-pages-off-the-lru-if-we-have-no-swap.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Take anonymous pages off the LRU if we have no swap
From: Christoph Lameter <clameter@sgi.com>

If the kernel was compiled without support for swapping then we have no
means of evicting anonymous pages and they become like mlocked pages.

Do not add new anonymous pages to the LRU and if we find one on the LRU
then take it off.  This is also going to reduce the overhead of allocating
anonymous pages since the LRU lock must no longer be taken to put pages
onto the active list.  Probably mostly of interest to embedded systems
since normal kernels support swap.

On linux-mm we also discussed taking anonymous pages off the LRU if there
is no swap defined or not enough swap.  However, there is no easy way of
putting the pages back to the LRU since we have no list of mlocked pages. 
We could set up such a list but then list manipulation would complicate the
mlocked page treatment and require taking the lru lock.  I'd rather leave
the mlocked handling as simple as it is right now.

Anonymous pages will be accounted as mlocked pages.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   29 +++++++++++++++++++----------
 mm/vmscan.c |    4 +++-
 2 files changed, 22 insertions(+), 11 deletions(-)

diff -puN mm/memory.c~take-anonymous-pages-off-the-lru-if-we-have-no-swap mm/memory.c
--- a/mm/memory.c~take-anonymous-pages-off-the-lru-if-we-have-no-swap
+++ a/mm/memory.c
@@ -907,17 +907,26 @@ static void add_anon_page(struct vm_area
 				unsigned long address)
 {
 	inc_mm_counter(vma->vm_mm, anon_rss);
-	if (vma->vm_flags & VM_LOCKED) {
-		/*
-		 * Page is new and therefore not on the LRU
-		 * so we can directly mark it as mlocked
-		 */
-		SetPageMlocked(page);
-		ClearPageActive(page);
-		inc_zone_page_state(page, NR_MLOCK);
-	} else
-		lru_cache_add_active(page);
 	page_add_new_anon_rmap(page, vma, address);
+
+#ifdef CONFIG_SWAP
+	/*
+	 * It only makes sense to put anonymous pages on the
+	 * LRU if we have a way of evicting anonymous pages.
+	 */
+	if (!(vma->vm_flags & VM_LOCKED)) {
+		lru_cache_add_active(page);
+		return;
+	}
+#endif
+
+	/*
+	 * Page is new and therefore not on the LRU
+	 * so we can directly mark it as mlocked
+	 */
+	SetPageMlocked(page);
+	ClearPageActive(page);
+	inc_zone_page_state(page, NR_MLOCK);
 }
 
 /*
diff -puN mm/vmscan.c~take-anonymous-pages-off-the-lru-if-we-have-no-swap mm/vmscan.c
--- a/mm/vmscan.c~take-anonymous-pages-off-the-lru-if-we-have-no-swap
+++ a/mm/vmscan.c
@@ -488,14 +488,16 @@ static unsigned long shrink_page_list(st
 		if (referenced && page_mapping_inuse(page))
 			goto activate_locked;
 
-#ifdef CONFIG_SWAP
 		/*
 		 * Anonymous process memory has backing store?
 		 * Try to allocate it some swap space here.
 		 */
 		if (PageAnon(page) && !PageSwapCache(page))
+#ifdef CONFIG_SWAP
 			if (!add_to_swap(page, GFP_ATOMIC))
 				goto activate_locked;
+#else
+			goto mlocked;
 #endif /* CONFIG_SWAP */
 
 		mapping = page_mapping(page);
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-introduce-krealloc.patch
xen-paravirt_ops-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages-fix.patch
make-try_to_unmap-return-a-special-exit-code.patch
slab-ensure-cache_alloc_refill-terminates.patch
slab-remove-colouroff-from-struct-slab.patch
add-nr_mlock-zvc.patch
add-pagemlocked-page-state-bit-and-lru-infrastructure.patch
add-pagemlocked-page-state-bit-and-lru-infrastructure-fix.patch
logic-to-move-mlocked-pages.patch
consolidate-new-anonymous-page-code-paths.patch
avoid-putting-new-mlocked-anonymous-pages-on-lru.patch
opportunistically-move-mlocked-pages-off-the-lru.patch
take-anonymous-pages-off-the-lru-if-we-have-no-swap.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching-vs-zvc-stuff.patch
mm-implement-swap-prefetching-vs-zvc-stuff-2.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-aging-accounting-vs-zvc-changes.patch
