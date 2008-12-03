From: akpm@linux-foundation.org
Subject: + badpage-zap-print_bad_pte-on-swap-and-file.patch added to -mm tree
Date: Tue, 02 Dec 2008 16:57:19 -0800
Message-ID: <200812030057.mB30vKvh024480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755407AbYLCA7k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 19:59:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, cl@linux-foundation.org, mel@csn.ul.ie, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     badpage: zap print_bad_pte on swap and file
has been added to the -mm tree.  Its filename is
     badpage-zap-print_bad_pte-on-swap-and-file.patch

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
Subject: badpage: zap print_bad_pte on swap and file
From: Hugh Dickins <hugh@veritas.com>

Complete zap_pte_range()'s coverage of bad pagetable entries by calling
print_bad_pte() on a pte_file in a linear vma and on a bad swap entry. 
That needs free_swap_and_cache() to tell it, which will also have shown
one of those "swap_free" errors (but with much less information).

Similar checks in fork's copy_one_pte()?  No, that would be more noisy
than helpful: we'll see them when parent and child exec or exit.

Where do_nonlinear_fault() calls print_bad_pte(): omit !VM_CAN_NONLINEAR
case, that could only be a bug in sys_remap_file_pages(), not a bad pte. 
VM_FAULT_OOM rather than VM_FAULT_SIGBUS?  Well, okay, that is consistent
with what happens if do_swap_page() operates a bad swap entry; but don't
we have patches to be more careful about killing when VM_FAULT_OOM?

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   12 +++---------
 mm/memory.c          |   11 +++++++----
 mm/swapfile.c        |    7 ++++---
 3 files changed, 14 insertions(+), 16 deletions(-)

diff -puN include/linux/swap.h~badpage-zap-print_bad_pte-on-swap-and-file include/linux/swap.h
--- a/include/linux/swap.h~badpage-zap-print_bad_pte-on-swap-and-file
+++ a/include/linux/swap.h
@@ -305,7 +305,7 @@ extern swp_entry_t get_swap_page_of_type
 extern int swap_duplicate(swp_entry_t);
 extern int valid_swaphandles(swp_entry_t, unsigned long *);
 extern void swap_free(swp_entry_t);
-extern void free_swap_and_cache(swp_entry_t);
+extern int free_swap_and_cache(swp_entry_t);
 extern int swap_type_of(dev_t, sector_t, struct block_device **);
 extern unsigned int count_swap_pages(int, int);
 extern sector_t map_swap_page(struct swap_info_struct *, pgoff_t);
@@ -355,14 +355,8 @@ static inline void show_swap_cache_info(
 {
 }
 
-static inline void free_swap_and_cache(swp_entry_t swp)
-{
-}
-
-static inline int swap_duplicate(swp_entry_t swp)
-{
-	return 0;
-}
+#define free_swap_and_cache(swp)	is_migration_entry(swp)
+#define swap_duplicate(swp)		is_migration_entry(swp)
 
 static inline void swap_free(swp_entry_t swp)
 {
diff -puN mm/memory.c~badpage-zap-print_bad_pte-on-swap-and-file mm/memory.c
--- a/mm/memory.c~badpage-zap-print_bad_pte-on-swap-and-file
+++ a/mm/memory.c
@@ -800,8 +800,12 @@ static unsigned long zap_pte_range(struc
 		 */
 		if (unlikely(details))
 			continue;
-		if (!pte_file(ptent))
-			free_swap_and_cache(pte_to_swp_entry(ptent));
+		if (pte_file(ptent)) {
+			if (unlikely(!(vma->vm_flags & VM_NONLINEAR)))
+				print_bad_pte(vma, addr, ptent, NULL);
+		} else if
+		  (unlikely(!free_swap_and_cache(pte_to_swp_entry(ptent))))
+			print_bad_pte(vma, addr, ptent, NULL);
 		pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
 	} while (pte++, addr += PAGE_SIZE, (addr != end && *zap_work > 0));
 
@@ -2678,8 +2682,7 @@ static int do_nonlinear_fault(struct mm_
 	if (!pte_unmap_same(mm, pmd, page_table, orig_pte))
 		return 0;
 
-	if (unlikely(!(vma->vm_flags & VM_NONLINEAR) ||
-			!(vma->vm_flags & VM_CAN_NONLINEAR))) {
+	if (unlikely(!(vma->vm_flags & VM_NONLINEAR))) {
 		/*
 		 * Page table corrupted: show pte and kill process.
 		 */
diff -puN mm/swapfile.c~badpage-zap-print_bad_pte-on-swap-and-file mm/swapfile.c
--- a/mm/swapfile.c~badpage-zap-print_bad_pte-on-swap-and-file
+++ a/mm/swapfile.c
@@ -571,13 +571,13 @@ int try_to_free_swap(struct page *page)
  * Free the swap entry like above, but also try to
  * free the page cache entry if it is the last user.
  */
-void free_swap_and_cache(swp_entry_t entry)
+int free_swap_and_cache(swp_entry_t entry)
 {
-	struct swap_info_struct * p;
+	struct swap_info_struct *p;
 	struct page *page = NULL;
 
 	if (is_migration_entry(entry))
-		return;
+		return 1;
 
 	p = swap_info_get(entry);
 	if (p) {
@@ -603,6 +603,7 @@ void free_swap_and_cache(swp_entry_t ent
 		unlock_page(page);
 		page_cache_release(page);
 	}
+	return p != NULL;
 }
 
 #ifdef CONFIG_HIBERNATION
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

