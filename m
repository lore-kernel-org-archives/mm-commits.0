From: akpm@linux-foundation.org
Subject: - take-anonymous-pages-off-the-lru-if-we-have-no-swap.patch removed from -mm tree
Date: Mon, 05 Mar 2007 16:42:39 -0800
Message-ID: <200703060042.l260gexU006535@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43135 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933681AbXCFAms (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 19:42:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, hugh@veritas.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     Take anonymous pages off the LRU if we have no swap
has been removed from the -mm tree.  Its filename was
     take-anonymous-pages-off-the-lru-if-we-have-no-swap.patch

This patch was dropped because an updated version will be merged

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

origin.patch
slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
make-try_to_unmap-return-a-special-exit-code.patch
slab-ensure-cache_alloc_refill-terminates.patch
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
