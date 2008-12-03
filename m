From: akpm@linux-foundation.org
Subject: + badpage-remove-vma-from-page_remove_rmap.patch added to -mm tree
Date: Tue, 02 Dec 2008 16:57:21 -0800
Message-ID: <200812030057.mB30vLqp024495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754677AbYLCA7g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 19:59:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, cl@linux-foundation.org, mel@csn.ul.ie, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     badpage: remove vma from page_remove_rmap
has been added to the -mm tree.  Its filename is
     badpage-remove-vma-from-page_remove_rmap.patch

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
Subject: badpage: remove vma from page_remove_rmap
From: Hugh Dickins <hugh@veritas.com>

Remove page_remove_rmap()'s vma arg, which was only for the Eeek message. 
And remove the BUG_ON(page_mapcount(page) == 0) from CONFIG_DEBUG_VM's
page_dup_rmap(): we're trying to be more resilient about that than BUGs.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +-
 mm/filemap_xip.c     |    2 +-
 mm/fremap.c          |    2 +-
 mm/memory.c          |    4 ++--
 mm/rmap.c            |    8 +++-----
 5 files changed, 8 insertions(+), 10 deletions(-)

diff -puN include/linux/rmap.h~badpage-remove-vma-from-page_remove_rmap include/linux/rmap.h
--- a/include/linux/rmap.h~badpage-remove-vma-from-page_remove_rmap
+++ a/include/linux/rmap.h
@@ -69,7 +69,7 @@ void __anon_vma_link(struct vm_area_stru
 void page_add_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
 void page_add_new_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
 void page_add_file_rmap(struct page *);
-void page_remove_rmap(struct page *, struct vm_area_struct *);
+void page_remove_rmap(struct page *);
 
 #ifdef CONFIG_DEBUG_VM
 void page_dup_rmap(struct page *page, struct vm_area_struct *vma, unsigned long address);
diff -puN mm/filemap_xip.c~badpage-remove-vma-from-page_remove_rmap mm/filemap_xip.c
--- a/mm/filemap_xip.c~badpage-remove-vma-from-page_remove_rmap
+++ a/mm/filemap_xip.c
@@ -193,7 +193,7 @@ retry:
 			/* Nuke the page table entry. */
 			flush_cache_page(vma, address, pte_pfn(*pte));
 			pteval = ptep_clear_flush_notify(vma, address, pte);
-			page_remove_rmap(page, vma);
+			page_remove_rmap(page);
 			dec_mm_counter(mm, file_rss);
 			BUG_ON(pte_dirty(pteval));
 			pte_unmap_unlock(pte, ptl);
diff -puN mm/fremap.c~badpage-remove-vma-from-page_remove_rmap mm/fremap.c
--- a/mm/fremap.c~badpage-remove-vma-from-page_remove_rmap
+++ a/mm/fremap.c
@@ -37,7 +37,7 @@ static void zap_pte(struct mm_struct *mm
 		if (page) {
 			if (pte_dirty(pte))
 				set_page_dirty(page);
-			page_remove_rmap(page, vma);
+			page_remove_rmap(page);
 			page_cache_release(page);
 			update_hiwater_rss(mm);
 			dec_mm_counter(mm, file_rss);
diff -puN mm/memory.c~badpage-remove-vma-from-page_remove_rmap mm/memory.c
--- a/mm/memory.c~badpage-remove-vma-from-page_remove_rmap
+++ a/mm/memory.c
@@ -788,7 +788,7 @@ static unsigned long zap_pte_range(struc
 					mark_page_accessed(page);
 				file_rss--;
 			}
-			page_remove_rmap(page, vma);
+			page_remove_rmap(page);
 			if (unlikely(page_mapcount(page) < 0))
 				print_bad_pte(vma, addr, ptent, page);
 			tlb_remove_page(tlb, page);
@@ -1994,7 +1994,7 @@ gotten:
 			 * mapcount is visible. So transitively, TLBs to
 			 * old page will be flushed before it can be reused.
 			 */
-			page_remove_rmap(old_page, vma);
+			page_remove_rmap(old_page);
 		}
 
 		/* Free the old page.. */
diff -puN mm/rmap.c~badpage-remove-vma-from-page_remove_rmap mm/rmap.c
--- a/mm/rmap.c~badpage-remove-vma-from-page_remove_rmap
+++ a/mm/rmap.c
@@ -707,7 +707,6 @@ void page_add_file_rmap(struct page *pag
  */
 void page_dup_rmap(struct page *page, struct vm_area_struct *vma, unsigned long address)
 {
-	BUG_ON(page_mapcount(page) == 0);
 	if (PageAnon(page))
 		__page_check_anon_rmap(page, vma, address);
 	atomic_inc(&page->_mapcount);
@@ -717,11 +716,10 @@ void page_dup_rmap(struct page *page, st
 /**
  * page_remove_rmap - take down pte mapping from a page
  * @page: page to remove mapping from
- * @vma: the vm area in which the mapping is removed
  *
  * The caller needs to hold the pte lock.
  */
-void page_remove_rmap(struct page *page, struct vm_area_struct *vma)
+void page_remove_rmap(struct page *page)
 {
 	if (atomic_add_negative(-1, &page->_mapcount)) {
 		/*
@@ -837,7 +835,7 @@ static int try_to_unmap_one(struct page 
 		dec_mm_counter(mm, file_rss);
 
 
-	page_remove_rmap(page, vma);
+	page_remove_rmap(page);
 	page_cache_release(page);
 
 out_unmap:
@@ -952,7 +950,7 @@ static int try_to_unmap_cluster(unsigned
 		if (pte_dirty(pteval))
 			set_page_dirty(page);
 
-		page_remove_rmap(page, vma);
+		page_remove_rmap(page);
 		page_cache_release(page);
 		dec_mm_counter(mm, file_rss);
 		(*mapcount)--;
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

