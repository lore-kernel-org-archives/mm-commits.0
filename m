Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83BFDC6FA86
	for <mm-commits@archiver.kernel.org>; Fri,  2 Sep 2022 23:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiIBX0a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Sep 2022 19:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiIBX02 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2022 19:26:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 589CEAE9E7
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 16:26:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBE2861EC0
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 23:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC72C433C1;
        Fri,  2 Sep 2022 23:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662161179;
        bh=tKrUiA4OxHBkAZJiIs2052X2431WfannKsEVucu4G6g=;
        h=Date:To:From:Subject:From;
        b=MXkrJ6KoBBTemrnhpKwpKuzhnFRcDvbX7y9ITyoaaI3I+Yx6h3UGg5gfG78gQEiWz
         cah2feQ2NDRLKw6AHBMUSN/35RNKvUHDvQo6BkCpIAtTYJs2z4DBcOyjXH4X8o/nZO
         4pAAv9dWDSCoyFeIKvv6kM87iQaj4WwfXAABcj6A=
Date:   Fri, 02 Sep 2022 16:26:18 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-convert-shmem_writepage-to-use-a-folio-throughout.patch added to mm-unstable branch
Message-Id: <20220902232619.4BC72C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: convert shmem_writepage() to use a folio throughout
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-convert-shmem_writepage-to-use-a-folio-throughout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-convert-shmem_writepage-to-use-a-folio-throughout.patch

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
Subject: shmem: convert shmem_writepage() to use a folio throughout
Date: Fri, 2 Sep 2022 20:46:02 +0100

Even though we will split any large folio that comes in, write the code to
handle large folios so as to not leave a trap for whoever tries to handle
large folios in the swap cache.

Link: https://lkml.kernel.org/r/20220902194653.1739778-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

--- a/mm/shmem.c~shmem-convert-shmem_writepage-to-use-a-folio-throughout
+++ a/mm/shmem.c
@@ -1328,17 +1328,18 @@ static int shmem_writepage(struct page *
 	 * "force", drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
 	 * and its shmem_writeback() needs them to be split when swapping.
 	 */
-	if (PageTransCompound(page)) {
+	if (folio_test_large(folio)) {
 		/* Ensure the subpages are still dirty */
-		SetPageDirty(page);
+		folio_test_set_dirty(folio);
 		if (split_huge_page(page) < 0)
 			goto redirty;
-		ClearPageDirty(page);
+		folio = page_folio(page);
+		folio_clear_dirty(folio);
 	}
 
-	BUG_ON(!PageLocked(page));
-	mapping = page->mapping;
-	index = page->index;
+	BUG_ON(!folio_test_locked(folio));
+	mapping = folio->mapping;
+	index = folio->index;
 	inode = mapping->host;
 	info = SHMEM_I(inode);
 	if (info->flags & VM_LOCKED)
@@ -1361,15 +1362,15 @@ static int shmem_writepage(struct page *
 	/*
 	 * This is somewhat ridiculous, but without plumbing a SWAP_MAP_FALLOC
 	 * value into swapfile.c, the only way we can correctly account for a
-	 * fallocated page arriving here is now to initialize it and write it.
+	 * fallocated folio arriving here is now to initialize it and write it.
 	 *
-	 * That's okay for a page already fallocated earlier, but if we have
+	 * That's okay for a folio already fallocated earlier, but if we have
 	 * not yet completed the fallocation, then (a) we want to keep track
-	 * of this page in case we have to undo it, and (b) it may not be a
+	 * of this folio in case we have to undo it, and (b) it may not be a
 	 * good idea to continue anyway, once we're pushing into swap.  So
-	 * reactivate the page, and let shmem_fallocate() quit when too many.
+	 * reactivate the folio, and let shmem_fallocate() quit when too many.
 	 */
-	if (!PageUptodate(page)) {
+	if (!folio_test_uptodate(folio)) {
 		if (inode->i_private) {
 			struct shmem_falloc *shmem_falloc;
 			spin_lock(&inode->i_lock);
@@ -1385,9 +1386,9 @@ static int shmem_writepage(struct page *
 			if (shmem_falloc)
 				goto redirty;
 		}
-		clear_highpage(page);
-		flush_dcache_page(page);
-		SetPageUptodate(page);
+		folio_zero_range(folio, 0, folio_size(folio));
+		flush_dcache_folio(folio);
+		folio_mark_uptodate(folio);
 	}
 
 	swap = folio_alloc_swap(folio);
@@ -1396,7 +1397,7 @@ static int shmem_writepage(struct page *
 
 	/*
 	 * Add inode to shmem_unuse()'s list of swapped-out inodes,
-	 * if it's not already there.  Do it now before the page is
+	 * if it's not already there.  Do it now before the folio is
 	 * moved to swap cache, when its pagelock no longer protects
 	 * the inode from eviction.  But don't unlock the mutex until
 	 * we've incremented swapped, because shmem_unuse_inode() will
@@ -1406,7 +1407,7 @@ static int shmem_writepage(struct page *
 	if (list_empty(&info->swaplist))
 		list_add(&info->swaplist, &shmem_swaplist);
 
-	if (add_to_swap_cache(page, swap,
+	if (add_to_swap_cache(&folio->page, swap,
 			__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN,
 			NULL) == 0) {
 		spin_lock_irq(&info->lock);
@@ -1415,21 +1416,21 @@ static int shmem_writepage(struct page *
 		spin_unlock_irq(&info->lock);
 
 		swap_shmem_alloc(swap);
-		shmem_delete_from_page_cache(page, swp_to_radix_entry(swap));
+		shmem_delete_from_page_cache(&folio->page, swp_to_radix_entry(swap));
 
 		mutex_unlock(&shmem_swaplist_mutex);
-		BUG_ON(page_mapped(page));
-		swap_writepage(page, wbc);
+		BUG_ON(folio_mapped(folio));
+		swap_writepage(&folio->page, wbc);
 		return 0;
 	}
 
 	mutex_unlock(&shmem_swaplist_mutex);
-	put_swap_page(page, swap);
+	put_swap_page(&folio->page, swap);
 redirty:
-	set_page_dirty(page);
+	folio_mark_dirty(folio);
 	if (wbc->for_reclaim)
-		return AOP_WRITEPAGE_ACTIVATE;	/* Return with page locked */
-	unlock_page(page);
+		return AOP_WRITEPAGE_ACTIVATE;	/* Return with folio locked */
+	folio_unlock(folio);
 	return 0;
 }
 
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

