From: akpm@linux-foundation.org
Subject: + avoid-putting-new-mlocked-anonymous-pages-on-lru.patch added to -mm tree
Date: Thu, 15 Feb 2007 21:18:14 -0800
Message-ID: <200702160518.l1G5IE9h020346@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50135 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423261AbXBPFS2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 00:18:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Avoid putting new mlocked anonymous pages on LRU
has been added to the -mm tree.  Its filename is
     avoid-putting-new-mlocked-anonymous-pages-on-lru.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
fix-mempolicys-check-on-a-system-with-memory-less-node.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages-fix.patch
make-try_to_unmap-return-a-special-exit-code.patch
add-pagemlocked-page-state-bit-and-lru-infrastructure.patch
add-nr_mlock-zvc.patch
logic-to-move-mlocked-pages.patch
consolidate-new-anonymous-page-code-paths.patch
avoid-putting-new-mlocked-anonymous-pages-on-lru.patch
opportunistically-move-mlocked-pages-off-the-lru.patch
a.patch
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
