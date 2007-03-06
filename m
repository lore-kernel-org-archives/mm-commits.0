From: akpm@linux-foundation.org
Subject: - avoid-putting-new-mlocked-anonymous-pages-on-lru.patch removed from -mm tree
Date: Mon, 05 Mar 2007 16:42:26 -0800
Message-ID: <200703060042.l260gRtV006526@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43118 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933677AbXCFAme (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 19:42:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Avoid putting new mlocked anonymous pages on LRU
has been removed from the -mm tree.  Its filename was
     avoid-putting-new-mlocked-anonymous-pages-on-lru.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Avoid putting new mlocked anonymous pages on LRU
From: Christoph Lameter <clameter@sgi.com>

Mark new anonymous pages mlocked if they are in a mlocked VMA.

Avoid putting pages onto the LRU that are allocated in a VMA with VM_LOCKED
set.  NR_MLOCK will be more accurate.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~avoid-putting-new-mlocked-anonymous-pages-on-lru mm/memory.c
--- a/mm/memory.c~avoid-putting-new-mlocked-anonymous-pages-on-lru
+++ a/mm/memory.c
@@ -906,7 +906,16 @@ static void add_anon_page(struct vm_area
 				unsigned long address)
 {
 	inc_mm_counter(vma->vm_mm, anon_rss);
-	lru_cache_add_active(page);
+	if (vma->vm_flags & VM_LOCKED) {
+		/*
+		 * Page is new and therefore not on the LRU
+		 * so we can directly mark it as mlocked
+		 */
+		SetPageMlocked(page);
+		ClearPageActive(page);
+		inc_zone_page_state(page, NR_MLOCK);
+	} else
+		lru_cache_add_active(page);
 	page_add_new_anon_rmap(page, vma, address);
 }
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
make-try_to_unmap-return-a-special-exit-code.patch
slab-ensure-cache_alloc_refill-terminates.patch
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
