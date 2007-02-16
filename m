From: akpm@linux-foundation.org
Subject: + add-pagemlocked-page-state-bit-and-lru-infrastructure-fix.patch added to -mm tree
Date: Thu, 15 Feb 2007 21:20:28 -0800
Message-ID: <200702160520.l1G5KSS3020391@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50179 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423268AbXBPFUa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 00:20:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     
has been added to the -mm tree.  Its filename is
     add-pagemlocked-page-state-bit-and-lru-infrastructure-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 
From: Christoph Lameter <clameter@sgi.com>

The problem is that in some circumstances a page may be freed that is
mlocked (if one is marking a page as mlocked early). The page allocator
will not touch the PG_mlocked bit and thus a newly allocated page may have
PG_mlocked set. If we then try to put it on the lru then the VM_BUG_ONs
are triggered.

The following patch detects these conditions in the page allocator and
does the proper checks and cleanup.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    1 +
 mm/page_alloc.c            |    7 +++++++
 2 files changed, 8 insertions(+)

diff -puN include/linux/page-flags.h~add-pagemlocked-page-state-bit-and-lru-infrastructure-fix include/linux/page-flags.h
--- a/include/linux/page-flags.h~add-pagemlocked-page-state-bit-and-lru-infrastructure-fix
+++ a/include/linux/page-flags.h
@@ -261,6 +261,7 @@ static inline void SetPageUptodate(struc
 #define PageMlocked(page)	test_bit(PG_mlocked, &(page)->flags)
 #define SetPageMlocked(page)	set_bit(PG_mlocked, &(page)->flags)
 #define ClearPageMlocked(page)	clear_bit(PG_mlocked, &(page)->flags)
+#define __ClearPageMlocked(page) __clear_bit(PG_mlocked, &(page)->flags)
 
 struct page;	/* forward declaration */
 
diff -puN mm/page_alloc.c~add-pagemlocked-page-state-bit-and-lru-infrastructure-fix mm/page_alloc.c
--- a/mm/page_alloc.c~add-pagemlocked-page-state-bit-and-lru-infrastructure-fix
+++ a/mm/page_alloc.c
@@ -203,6 +203,7 @@ static void bad_page(struct page *page)
 			1 << PG_slab    |
 			1 << PG_swapcache |
 			1 << PG_writeback |
+			1 << PG_mlocked |
 			1 << PG_buddy );
 	set_page_count(page, 0);
 	reset_page_mapcount(page);
@@ -442,6 +443,11 @@ static inline int free_pages_check(struc
 		bad_page(page);
 	if (PageDirty(page))
 		__ClearPageDirty(page);
+	if (PageMlocked(page)) {
+		/* Page is unused so no need to take the lru lock */
+		__ClearPageMlocked(page);
+		dec_zone_page_state(page, NR_MLOCK);
+	}
 	/*
 	 * For now, we report if PG_reserved was found set, but do not
 	 * clear it, and do not free the page.  But we shall soon need
@@ -588,6 +594,7 @@ static int prep_new_page(struct page *pa
 			1 << PG_swapcache |
 			1 << PG_writeback |
 			1 << PG_reserved |
+			1 << PG_mlocked |
 			1 << PG_buddy ))))
 		bad_page(page);
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
fix-mempolicys-check-on-a-system-with-memory-less-node.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages-fix.patch
make-try_to_unmap-return-a-special-exit-code.patch
add-nr_mlock-zvc.patch
add-pagemlocked-page-state-bit-and-lru-infrastructure.patch
add-pagemlocked-page-state-bit-and-lru-infrastructure-fix.patch
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
