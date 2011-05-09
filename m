From: akpm@linux-foundation.org
Subject: [wrecked] mm-reuse-__free_pages_exact-in-__alloc_pages_exact.patch removed from -mm tree
Date: Mon, 09 May 2011 16:39:50 -0700
Message-ID: <201105092339.p49NdoNv026414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755845Ab1EIXkE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2011 19:40:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@linux.vnet.ibm.com, ak@linux.intel.com, mel@csn.ul.ie, mina86@mina86.com, rientjes@google.com, timur@freescale.com, mm-commits@vger.kernel.org


The patch titled
     mm: reuse __free_pages_exact() in __alloc_pages_exact()
has been removed from the -mm tree.  Its filename was
     mm-reuse-__free_pages_exact-in-__alloc_pages_exact.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: reuse __free_pages_exact() in __alloc_pages_exact()
From: Dave Hansen <dave@linux.vnet.ibm.com>

Michal Nazarewicz noticed that __alloc_pages_exact()'s __free_page() loop
was really close to something he was using in one of his patches.  That
made me realize that it was actually very similar to __free_pages_exact().

This uses __free_pages_exact() in place of the loop that we had in
__alloc_pages_exact().  Since we had to change the temporary variables
around anyway, I gave them some better names to hopefully address some
other review comments.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Suggested-by: Michal Nazarewicz <mina86@mina86.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Timur Tabi <timur@freescale.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~mm-reuse-__free_pages_exact-in-__alloc_pages_exact mm/page_alloc.c
--- a/mm/page_alloc.c~mm-reuse-__free_pages_exact-in-__alloc_pages_exact
+++ a/mm/page_alloc.c
@@ -2339,14 +2339,11 @@ struct page *__alloc_pages_exact(gfp_t g
 
 	page = alloc_pages(gfp_mask, order);
 	if (page) {
-		struct page *alloc_end = page + (1 << order);
-		struct page *used = page + nr_pages;
+		struct page *unused_start = page + nr_pages;
+		unsigned long nr_unused = (1 << order) - nr_pages;
 
 		split_page(page, order);
-		while (used < alloc_end) {
-			__free_page(used);
-			used++;
-		}
+		__free_pages_exact(unused_start, nr_unused);
 	}
 
 	return page;
_

Patches currently in -mm which might be from dave@linux.vnet.ibm.com are

origin.patch
linux-next.patch
mm-add-alloc_pages_exact_nid.patch
mm-add-alloc_pages_exact_nid-fix.patch
memcg-allocate-memory-cgroup-structures-in-local-nodes.patch
mm-increase-reclaim_distance-to-30.patch
mm-convert-vma-vm_flags-to-64-bit.patch
mm-add-__nocast-attribute-to-vm_flags.patch
fremap-convert-vm_flags-to-unsigned-long-long.patch
procfs-convert-vm_flags-to-unsigned-long-long.patch
include-linux-gfph-work-around-apparent-sparse-confusion.patch
include-linux-gfph-convert-bug_on-into-vm_bug_on.patch
mm-break-out-page-allocation-warning-code.patch
mm-print-vmalloc-state-after-allocation-failures.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve-fix.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve-fix-2.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
mm-remove-dependency-on-config_flatmem-from-online_page.patch
mm-enable-set_page_section-only-if-config_sparsemem-and-config_sparsemem_vmemmap.patch
mm-pfn_to_section_nr-section_nr_to_pfn-is-valid-only-in-config_sparsemem-context.patch
mm-do-not-define-pfn_section_shift-if-config_sparsemem.patch
mm-delete-non-atomic-mm-counter-implementation.patch
sparse-define-dummy-build_bug_on-definition-for-sparse.patch
sparse-define-__must_be_array-for-__checker__.patch
sparse-undef-__compiletime_warningerror-if-__checker__-is-defined.patch
flex_array-avoid-divisions-when-accessing-elements.patch

