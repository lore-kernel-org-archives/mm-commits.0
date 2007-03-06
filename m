From: akpm@linux-foundation.org
Subject: - consolidate-new-anonymous-page-code-paths.patch removed from -mm tree
Date: Mon, 05 Mar 2007 16:42:21 -0800
Message-ID: <200703060042.l260gLHH006520@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43112 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933676AbXCFAm2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 19:42:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Consolidate new anonymous page code paths
has been removed from the -mm tree.  Its filename was
     consolidate-new-anonymous-page-code-paths.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Consolidate new anonymous page code paths
From: Christoph Lameter <clameter@sgi.com>

Consolidate code to add an anonymous page in memory.c

There are two location in which we add anonymous pages.  Both implement the
same logic.  Create a new function add_anon_page() to have a common code path.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff -puN mm/memory.c~consolidate-new-anonymous-page-code-paths mm/memory.c
--- a/mm/memory.c~consolidate-new-anonymous-page-code-paths
+++ a/mm/memory.c
@@ -900,6 +900,17 @@ unsigned long zap_page_range(struct vm_a
 }
 
 /*
+ * Add a new anonymous page
+ */
+static void add_anon_page(struct vm_area_struct *vma, struct page *page,
+				unsigned long address)
+{
+	inc_mm_counter(vma->vm_mm, anon_rss);
+	lru_cache_add_active(page);
+	page_add_new_anon_rmap(page, vma, address);
+}
+
+/*
  * Do a quick page-table lookup for a single page.
  */
 struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
@@ -2148,9 +2159,7 @@ static int do_anonymous_page(struct mm_s
 		page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 		if (!pte_none(*page_table))
 			goto release;
-		inc_mm_counter(mm, anon_rss);
-		lru_cache_add_active(page);
-		page_add_new_anon_rmap(page, vma, address);
+		add_anon_page(vma, page, address);
 	} else {
 		/* Map the ZERO_PAGE - vm_page_prot is readonly */
 		page = ZERO_PAGE(address);
@@ -2294,11 +2303,9 @@ retry:
 		if (write_access)
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 		set_pte_at(mm, address, page_table, entry);
-		if (anon) {
-			inc_mm_counter(mm, anon_rss);
-			lru_cache_add_active(new_page);
-			page_add_new_anon_rmap(new_page, vma, address);
-		} else {
+		if (anon)
+			add_anon_page(vma, new_page, address);
+		else {
 			inc_mm_counter(mm, file_rss);
 			page_add_file_rmap(new_page);
 			if (write_access) {
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
make-try_to_unmap-return-a-special-exit-code.patch
slab-ensure-cache_alloc_refill-terminates.patch
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
