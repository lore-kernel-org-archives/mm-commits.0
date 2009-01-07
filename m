From: akpm@linux-foundation.org
Subject: - badpage-vm_normal_page-use-print_bad_pte.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:14:03 -0800
Message-ID: <200901072214.n07ME3nZ014056@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760731AbZAGWOc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, cl@linux-foundation.org, mel@csn.ul.ie, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     badpage: vm_normal_page use print_bad_pte
has been removed from the -mm tree.  Its filename was
     badpage-vm_normal_page-use-print_bad_pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: badpage: vm_normal_page use print_bad_pte
From: Hugh Dickins <hugh@veritas.com>

print_bad_pte() is so far being called only when zap_pte_range() finds
negative page_mapcount, or there's a fault on a pte_file where it does not
belong.  That's weak coverage when we suspect pagetable corruption.

Originally, it was called when vm_normal_page() found an invalid pfn: but
pfn_valid is expensive on some architectures and configurations, so 2.6.24
put that under CONFIG_DEBUG_VM (which doesn't help in the field), then
2.6.26 replaced it by a VM_BUG_ON (likewise).

Reinstate the print_bad_pte() in vm_normal_page(), but use a cheaper test
than pfn_valid(): memmap_init_zone() (used in bootup and hotplug) keep a
__read_mostly note of the highest_memmap_pfn, vm_normal_page() then check
pfn against that.  We could call this pfn_plausible() or pfn_sane(), but I
doubt we'll need it elsewhere: of course it's not reliable, but gives much
stronger pagetable validation on many boxes.

Also use print_bad_pte() when the pte_special bit is found outside a
VM_PFNMAP or VM_MIXEDMAP area, instead of VM_BUG_ON.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    1 +
 mm/memory.c     |   20 ++++++++++----------
 mm/page_alloc.c |    4 ++++
 3 files changed, 15 insertions(+), 10 deletions(-)

diff -puN mm/internal.h~badpage-vm_normal_page-use-print_bad_pte mm/internal.h
--- a/mm/internal.h~badpage-vm_normal_page-use-print_bad_pte
+++ a/mm/internal.h
@@ -49,6 +49,7 @@ extern void putback_lru_page(struct page
 /*
  * in mm/page_alloc.c
  */
+extern unsigned long highest_memmap_pfn;
 extern void __free_pages_bootmem(struct page *page, unsigned int order);
 
 /*
diff -puN mm/memory.c~badpage-vm_normal_page-use-print_bad_pte mm/memory.c
--- a/mm/memory.c~badpage-vm_normal_page-use-print_bad_pte
+++ a/mm/memory.c
@@ -467,21 +467,18 @@ static inline int is_cow_mapping(unsigne
 struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 				pte_t pte)
 {
-	unsigned long pfn;
+	unsigned long pfn = pte_pfn(pte);
 
 	if (HAVE_PTE_SPECIAL) {
-		if (likely(!pte_special(pte))) {
-			VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
-			return pte_page(pte);
-		}
-		VM_BUG_ON(!(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)));
+		if (likely(!pte_special(pte)))
+			goto check_pfn;
+		if (!(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)))
+			print_bad_pte(vma, addr, pte, NULL);
 		return NULL;
 	}
 
 	/* !HAVE_PTE_SPECIAL case follows: */
 
-	pfn = pte_pfn(pte);
-
 	if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
 		if (vma->vm_flags & VM_MIXEDMAP) {
 			if (!pfn_valid(pfn))
@@ -497,11 +494,14 @@ struct page *vm_normal_page(struct vm_ar
 		}
 	}
 
-	VM_BUG_ON(!pfn_valid(pfn));
+check_pfn:
+	if (unlikely(pfn > highest_memmap_pfn)) {
+		print_bad_pte(vma, addr, pte, NULL);
+		return NULL;
+	}
 
 	/*
 	 * NOTE! We still have PageReserved() pages in the page tables.
-	 *
 	 * eg. VDSO mappings can cause them to exist.
 	 */
 out:
diff -puN mm/page_alloc.c~badpage-vm_normal_page-use-print_bad_pte mm/page_alloc.c
--- a/mm/page_alloc.c~badpage-vm_normal_page-use-print_bad_pte
+++ a/mm/page_alloc.c
@@ -69,6 +69,7 @@ EXPORT_SYMBOL(node_states);
 
 unsigned long totalram_pages __read_mostly;
 unsigned long totalreserve_pages __read_mostly;
+unsigned long highest_memmap_pfn __read_mostly;
 int percpu_pagelist_fraction;
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
@@ -2597,6 +2598,9 @@ void __meminit memmap_init_zone(unsigned
 	unsigned long pfn;
 	struct zone *z;
 
+	if (highest_memmap_pfn < end_pfn - 1)
+		highest_memmap_pfn = end_pfn - 1;
+
 	z = &NODE_DATA(nid)->node_zones[zone];
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		/*
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
mark-complex-bitopsh-inlines-as-__always_inline.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch
bio-zero-inlined-bio_vec.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-shmemc-fix-division-by-zero.patch
getrusage-fill-ru_maxrss-value.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
memcg-fix-swap-accounting-leak-v3.patch
memcg-fix-swap-accounting-leak-doc-fix.patch
memcg-fix-shmems-swap-accounting.patch
prio_tree-debugging-patch.patch

