From: akpm@linux-foundation.org
Subject: - opportunistically-move-mlocked-pages-off-the-lru.patch removed from -mm tree
Date: Mon, 05 Mar 2007 16:42:33 -0800
Message-ID: <200703060042.l260gYep006532@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43126 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933679AbXCFAml (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 19:42:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Opportunistically move mlocked pages off the LRU
has been removed from the -mm tree.  Its filename was
     opportunistically-move-mlocked-pages-off-the-lru.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Opportunistically move mlocked pages off the LRU
From: Christoph Lameter <clameter@sgi.com>

Opportunistically move mlocked pages off the LRU

Add a new function try_to_mlock() that attempts to move a page off the LRU and
marks it mlocked.

This function can then be used in various code paths to move pages off the LRU
immediately.  Early discovery will make NR_MLOCK track the actual number of
mlocked pages in the system more closely.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff -puN mm/memory.c~opportunistically-move-mlocked-pages-off-the-lru mm/memory.c
--- a/mm/memory.c~opportunistically-move-mlocked-pages-off-the-lru
+++ a/mm/memory.c
@@ -59,6 +59,7 @@
 
 #include <linux/swapops.h>
 #include <linux/elf.h>
+#include <linux/mm_inline.h>
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 /* use the per-pgdat data instead for discontigmem - mbligh */
@@ -920,6 +921,34 @@ static void add_anon_page(struct vm_area
 }
 
 /*
+ * Opportunistically move the page off the LRU
+ * if possible. If we do not succeed then the LRU
+ * scans will take the page off.
+ */
+static void try_to_set_mlocked(struct page *page)
+{
+	struct zone *zone;
+	unsigned long flags;
+
+	if (!PageLRU(page) || PageMlocked(page))
+		return;
+
+	zone = page_zone(page);
+	if (spin_trylock_irqsave(&zone->lru_lock, flags)) {
+		if (PageLRU(page) && !PageMlocked(page)) {
+			ClearPageLRU(page);
+			if (PageActive(page))
+				del_page_from_active_list(zone, page);
+			else
+				del_page_from_inactive_list(zone, page);
+			ClearPageActive(page);
+			SetPageMlocked(page);
+			__inc_zone_page_state(page, NR_MLOCK);
+		}
+		spin_unlock_irqrestore(&zone->lru_lock, flags);
+	}
+}
+/*
  * Do a quick page-table lookup for a single page.
  */
 struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
@@ -979,6 +1008,8 @@ struct page *follow_page(struct vm_area_
 			set_page_dirty(page);
 		mark_page_accessed(page);
 	}
+	if (vma->vm_flags & VM_LOCKED)
+		try_to_set_mlocked(page);
 unlock:
 	pte_unmap_unlock(ptep, ptl);
 out:
@@ -2317,6 +2348,8 @@ retry:
 		else {
 			inc_mm_counter(mm, file_rss);
 			page_add_file_rmap(new_page);
+			if (vma->vm_flags & VM_LOCKED)
+				try_to_set_mlocked(new_page);
 			if (write_access) {
 				dirty_page = new_page;
 				get_page(dirty_page);
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
make-try_to_unmap-return-a-special-exit-code.patch
slab-ensure-cache_alloc_refill-terminates.patch
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
