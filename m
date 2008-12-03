From: akpm@linux-foundation.org
Subject: + badpage-vm_normal_page-use-print_bad_pte.patch added to -mm tree
Date: Tue, 02 Dec 2008 16:57:17 -0800
Message-ID: <200812030057.mB30vHLi024450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754688AbYLCA7g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 19:59:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, cl@linux-foundation.org, mel@csn.ul.ie, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     badpage: vm_normal_page use print_bad_pte
has been added to the -mm tree.  Its filename is
     badpage-vm_normal_page-use-print_bad_pte.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

ksym_symbol_len-fixes.patch
linux-next.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remove-cgroup_mm_owner_callbacks.patch
mm-remove-aop_writepage_activate.patch
mm-remove-gfp_highuser_pagecache.patch
mm-add-setclearpageswapcache-stubs.patch
mm-replace-some-bug_ons-by-vm_bug_ons.patch
mm-add_active_or_unevictable-into-rmap.patch
mm-make-page_lock_anon_vma-static.patch
mm-further-cleanup-page_add_new_anon_rmap.patch
mm-gup-persist-for-write-permission.patch
mm-wp-lock-page-before-deciding-cow.patch
mm-reuse_swap_page-replaces-can_share_swap_page.patch
mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch
mm-try_to_unuse-check-removing-right-swap.patch
mm-remove-try_to_munlock-from-vmscan.patch
mm-remove-gfp_mask-from-add_to_swap.patch
mm-add-add_to_swap-stub.patch
mm-optimize-get_scan_ratio-for-no-swap.patch
swapfile-swapon-needs-larger-size-type.patch
swapfile-remove-swp_active-mask.patch
swapfile-remove-surplus-whitespace.patch
swapfile-remove-v0-swap-space-message.patch
swapfile-rearrange-scan-and-swap_info.patch
swapfile-swapon-use-discard-trim.patch
swapfile-swap-allocation-use-discard.patch
swapfile-swapon-randomize-if-nonrot.patch
swapfile-swap-allocation-cycle-if-nonrot.patch
swapfile-change-discard-pgoff_t-to-sector_t.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
swapfile-let-others-seed-random.patch
badpage-simplify-page_alloc-flag-checkclear.patch
badpage-keep-any-bad-page-out-of-circulation.patch
badpage-replace-page_remove_rmap-eeek-and-bug.patch
badpage-vm_normal_page-use-print_bad_pte.patch
badpage-zap-print_bad_pte-on-swap-and-file.patch
badpage-remove-vma-from-page_remove_rmap.patch
badpage-ratelimit-print_bad_pte-and-bad_page.patch
badpage-kern_alert-bug-instead-of-kern_emerg.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
prio_tree-debugging-patch.patch

