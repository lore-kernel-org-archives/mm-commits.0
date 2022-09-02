Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C2FC6FA82
	for <mm-commits@archiver.kernel.org>; Fri,  2 Sep 2022 23:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiIBX0x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Sep 2022 19:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiIBX0r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2022 19:26:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59279C00D4
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 16:26:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08533B82E07
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 23:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6612C433C1;
        Fri,  2 Sep 2022 23:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662161198;
        bh=64Z6tLfA0A9ewEqtPWAy1Dhyt6Lj6PeDt6cDDx83eXE=;
        h=Date:To:From:Subject:From;
        b=ygF+//usiq3+/rbtoDJGThsNXblk03bnGwjjdU4RSNHqh9Dh+NI6XZ/tunQQU9jC6
         obnuXFo/PzGJ3E/r6MgBja4MEXNyqvHSh6JEP30k19V43NYJiapEwJhhx5DsYaYVdj
         awO8H0tV4akYnfnxcz+4PqohlD8KAM3FcyqEXc4M=
Date:   Fri, 02 Sep 2022 16:26:38 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-do_swap_page-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20220902232638.B6612C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert do_swap_page() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-do_swap_page-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-do_swap_page-to-use-a-folio.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert do_swap_page() to use a folio
Date: Fri, 2 Sep 2022 20:46:10 +0100

Removes quite a lot of calls to compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-15-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   57 ++++++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 24 deletions(-)

--- a/mm/memory.c~mm-convert-do_swap_page-to-use-a-folio
+++ a/mm/memory.c
@@ -3726,6 +3726,7 @@ static vm_fault_t handle_pte_marker(stru
 vm_fault_t do_swap_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	struct folio *folio;
 	struct page *page = NULL, *swapcache;
 	struct swap_info_struct *si = NULL;
 	rmap_t rmap_flags = RMAP_NONE;
@@ -3770,19 +3771,23 @@ vm_fault_t do_swap_page(struct vm_fault
 
 	page = lookup_swap_cache(entry, vma, vmf->address);
 	swapcache = page;
+	if (page)
+		folio = page_folio(page);
 
 	if (!page) {
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO) &&
 		    __swap_count(entry) == 1) {
 			/* skip swapcache */
-			page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma,
-							vmf->address);
-			if (page) {
-				__SetPageLocked(page);
-				__SetPageSwapBacked(page);
+			folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0,
+						vma, vmf->address, false);
+			page = &folio->page;
+			if (folio) {
+				__folio_set_locked(folio);
+				__folio_set_swapbacked(folio);
 
 				if (mem_cgroup_swapin_charge_page(page,
-					vma->vm_mm, GFP_KERNEL, entry)) {
+							vma->vm_mm, GFP_KERNEL,
+							entry)) {
 					ret = VM_FAULT_OOM;
 					goto out_page;
 				}
@@ -3790,20 +3795,21 @@ vm_fault_t do_swap_page(struct vm_fault
 
 				shadow = get_shadow_from_swap_cache(entry);
 				if (shadow)
-					workingset_refault(page_folio(page),
-								shadow);
+					workingset_refault(folio, shadow);
 
-				lru_cache_add(page);
+				folio_add_lru(folio);
 
 				/* To provide entry to swap_readpage() */
-				set_page_private(page, entry.val);
+				folio_set_swap_entry(folio, entry);
 				swap_readpage(page, true, NULL);
-				set_page_private(page, 0);
+				folio->private = NULL;
 			}
 		} else {
 			page = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE,
 						vmf);
 			swapcache = page;
+			if (page)
+				folio = page_folio(page);
 		}
 
 		if (!page) {
@@ -3846,7 +3852,7 @@ vm_fault_t do_swap_page(struct vm_fault
 		 * swapcache, we need to check that the page's swap has not
 		 * changed.
 		 */
-		if (unlikely(!PageSwapCache(page) ||
+		if (unlikely(!folio_test_swapcache(folio) ||
 			     page_private(page) != entry.val))
 			goto out_page;
 
@@ -3861,6 +3867,7 @@ vm_fault_t do_swap_page(struct vm_fault
 			page = swapcache;
 			goto out_page;
 		}
+		folio = page_folio(page);
 
 		/*
 		 * If we want to map a page that's in the swapcache writable, we
@@ -3869,7 +3876,7 @@ vm_fault_t do_swap_page(struct vm_fault
 		 * pagevecs if required.
 		 */
 		if ((vmf->flags & FAULT_FLAG_WRITE) && page == swapcache &&
-		    !PageKsm(page) && !PageLRU(page))
+		    !folio_test_ksm(folio) && !folio_test_lru(folio))
 			lru_add_drain();
 	}
 
@@ -3883,7 +3890,7 @@ vm_fault_t do_swap_page(struct vm_fault
 	if (unlikely(!pte_same(*vmf->pte, vmf->orig_pte)))
 		goto out_nomap;
 
-	if (unlikely(!PageUptodate(page))) {
+	if (unlikely(!folio_test_uptodate(folio))) {
 		ret = VM_FAULT_SIGBUS;
 		goto out_nomap;
 	}
@@ -3896,14 +3903,14 @@ vm_fault_t do_swap_page(struct vm_fault
 	 * check after taking the PT lock and making sure that nobody
 	 * concurrently faulted in this page and set PG_anon_exclusive.
 	 */
-	BUG_ON(!PageAnon(page) && PageMappedToDisk(page));
-	BUG_ON(PageAnon(page) && PageAnonExclusive(page));
+	BUG_ON(!folio_test_anon(folio) && folio_test_mappedtodisk(folio));
+	BUG_ON(folio_test_anon(folio) && PageAnonExclusive(page));
 
 	/*
 	 * Check under PT lock (to protect against concurrent fork() sharing
 	 * the swap entry concurrently) for certainly exclusive pages.
 	 */
-	if (!PageKsm(page)) {
+	if (!folio_test_ksm(folio)) {
 		/*
 		 * Note that pte_swp_exclusive() == false for architectures
 		 * without __HAVE_ARCH_PTE_SWP_EXCLUSIVE.
@@ -3915,7 +3922,7 @@ vm_fault_t do_swap_page(struct vm_fault
 			 * swapcache -> certainly exclusive.
 			 */
 			exclusive = true;
-		} else if (exclusive && PageWriteback(page) &&
+		} else if (exclusive && folio_test_writeback(folio) &&
 			  data_race(si->flags & SWP_STABLE_WRITES)) {
 			/*
 			 * This is tricky: not all swap backends support
@@ -3958,7 +3965,8 @@ vm_fault_t do_swap_page(struct vm_fault
 	 * exposing them to the swapcache or because the swap entry indicates
 	 * exclusivity.
 	 */
-	if (!PageKsm(page) && (exclusive || page_count(page) == 1)) {
+	if (!folio_test_ksm(folio) &&
+	    (exclusive || folio_ref_count(folio) == 1)) {
 		if (vmf->flags & FAULT_FLAG_WRITE) {
 			pte = maybe_mkwrite(pte_mkdirty(pte), vma);
 			vmf->flags &= ~FAULT_FLAG_WRITE;
@@ -3978,16 +3986,17 @@ vm_fault_t do_swap_page(struct vm_fault
 	/* ksm created a completely new copy */
 	if (unlikely(page != swapcache && swapcache)) {
 		page_add_new_anon_rmap(page, vma, vmf->address);
-		lru_cache_add_inactive_or_unevictable(page, vma);
+		folio_add_lru_vma(folio, vma);
 	} else {
 		page_add_anon_rmap(page, vma, vmf->address, rmap_flags);
 	}
 
-	VM_BUG_ON(!PageAnon(page) || (pte_write(pte) && !PageAnonExclusive(page)));
+	VM_BUG_ON(!folio_test_anon(folio) ||
+			(pte_write(pte) && !PageAnonExclusive(page)));
 	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
 	arch_do_swap_page(vma->vm_mm, vma, vmf->address, pte, vmf->orig_pte);
 
-	unlock_page(page);
+	folio_unlock(folio);
 	if (page != swapcache && swapcache) {
 		/*
 		 * Hold the lock to avoid the swap entry to be reused
@@ -4019,9 +4028,9 @@ out:
 out_nomap:
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 out_page:
-	unlock_page(page);
+	folio_unlock(folio);
 out_release:
-	put_page(page);
+	folio_put(folio);
 	if (page != swapcache && swapcache) {
 		unlock_page(swapcache);
 		put_page(swapcache);
_

Patches currently in -mm which might be from willy@infradead.org are

tools-fix-compilation-after-gfp_typesh-split.patch
mm-fix-vm_bug_on-in-__delete_from_swap_cache.patch
vmscan-check-folio_test_private-not-folio_get_private.patch
support-highmem-pages-in-vmap_pages_range_noflush.patch
mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch
mm-vmscan-fix-a-lot-of-comments.patch
mm-add-the-first-tail-page-to-struct-folio.patch
mm-reimplement-folio_order-and-folio_nr_pages.patch
mm-add-split_folio.patch
mm-add-folio_add_lru_vma.patch
shmem-convert-shmem_writepage-to-use-a-folio-throughout.patch
shmem-convert-shmem_delete_from_page_cache-to-take-a-folio.patch
shmem-convert-shmem_replace_page-to-use-folios-throughout.patch
mm-swapfile-remove-page_swapcount.patch
mm-swapfile-convert-try_to_free_swap-to-folio_free_swap.patch
mm-swap-convert-__read_swap_cache_async-to-use-a-folio.patch
mm-swap-convert-add_to_swap_cache-to-take-a-folio.patch
mm-swap-convert-put_swap_page-to-put_swap_folio.patch
mm-convert-do_swap_page-to-use-a-folio.patch
mm-convert-do_swap_pages-swapcache-variable-to-a-folio.patch
memcg-convert-mem_cgroup_swapin_charge_page-to-mem_cgroup_swapin_charge_folio.patch
shmem-convert-shmem_mfill_atomic_pte-to-use-a-folio.patch
shmem-convert-shmem_replace_page-to-shmem_replace_folio.patch
swap-add-swap_cache_get_folio.patch
shmem-eliminate-struct-page-from-shmem_swapin_folio.patch
shmem-convert-shmem_getpage_gfp-to-shmem_get_folio_gfp.patch
shmem-convert-shmem_fault-to-use-shmem_get_folio_gfp.patch
shmem-convert-shmem_read_mapping_page_gfp-to-use-shmem_get_folio_gfp.patch
shmem-add-shmem_get_folio.patch
shmem-convert-shmem_get_partial_folio-to-use-shmem_get_folio.patch
shmem-convert-shmem_write_begin-to-use-shmem_get_folio.patch
shmem-convert-shmem_file_read_iter-to-use-shmem_get_folio.patch
shmem-convert-shmem_fallocate-to-use-a-folio.patch
shmem-convert-shmem_symlink-to-use-a-folio.patch
shmem-convert-shmem_get_link-to-use-a-folio.patch
khugepaged-call-shmem_get_folio.patch
userfaultfd-convert-mcontinue_atomic_pte-to-use-a-folio.patch
shmem-remove-shmem_getpage.patch
swapfile-convert-try_to_unuse-to-use-a-folio.patch
swapfile-convert-__try_to_reclaim_swap-to-use-a-folio.patch
swapfile-convert-unuse_pte_range-to-use-a-folio.patch
mm-convert-do_swap_page-to-use-swap_cache_get_folio.patch
mm-remove-lookup_swap_cache.patch
swap_state-convert-free_swap_cache-to-use-a-folio.patch
swap-convert-swap_writepage-to-use-a-folio.patch
mm-convert-do_wp_page-to-use-a-folio.patch
huge_memory-convert-do_huge_pmd_wp_page-to-use-a-folio.patch
madvise-convert-madvise_free_pte_range-to-use-a-folio.patch
uprobes-use-folios-more-widely-in-__replace_page.patch
ksm-use-a-folio-in-replace_page.patch
mm-convert-do_swap_page-to-use-folio_free_swap.patch
memcg-convert-mem_cgroup_swap_full-to-take-a-folio.patch
mm-remove-try_to_free_swap.patch
rmap-convert-page_move_anon_rmap-to-use-a-folio.patch
migrate-convert-__unmap_and_move-to-use-folios.patch
migrate-convert-unmap_and_move_huge_page-to-use-folios.patch
huge_memory-convert-split_huge_page_to_list-to-use-a-folio.patch
huge_memory-convert-unmap_page-to-unmap_folio.patch
mm-convert-page_get_anon_vma-to-folio_get_anon_vma.patch
rmap-remove-page_unlock_anon_vma_read.patch
uprobes-use-new_folio-in-__replace_page.patch
mm-convert-lock_page_or_retry-to-folio_lock_or_retry.patch

