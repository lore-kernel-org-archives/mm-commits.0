Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C4FBC6FA82
	for <mm-commits@archiver.kernel.org>; Fri,  2 Sep 2022 23:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbiIBX2h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Sep 2022 19:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiIBX1q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2022 19:27:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80943FC12B
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 16:27:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1018860EAD
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 23:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DA7C433D7;
        Fri,  2 Sep 2022 23:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662161256;
        bh=3wjHzrb6Mkdg3oM22jrQvhjRtvSC1dAxL7XNtdwSABA=;
        h=Date:To:From:Subject:From;
        b=T5SXPZA6YZq1dLU0HhoUx6U7eVnY6HdWynppMSSMmKYYcB8UgVnjchwb/OGX6fnjT
         iqn+ji+kraZiSpRIYgvy5QV0Nv2QLSAfBOrYeEQFs4rRBgjdlRnWptszQfX9dKFILr
         WD2q3bHuwWQydcHURnm+INaRZEa+S2lqUSa1lWUE=
Date:   Fri, 02 Sep 2022 16:27:35 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + huge_memory-convert-do_huge_pmd_wp_page-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20220902232736.69DA7C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: huge_memory: convert do_huge_pmd_wp_page() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     huge_memory-convert-do_huge_pmd_wp_page-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/huge_memory-convert-do_huge_pmd_wp_page-to-use-a-folio.patch

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
Subject: huge_memory: convert do_huge_pmd_wp_page() to use a folio
Date: Fri, 2 Sep 2022 20:46:38 +0100

Removes many calls to compound_head().  Does not remove the assumption
that a folio may not be larger than a PMD.

Link: https://lkml.kernel.org/r/20220902194653.1739778-43-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

--- a/mm/huge_memory.c~huge_memory-convert-do_huge_pmd_wp_page-to-use-a-folio
+++ a/mm/huge_memory.c
@@ -1305,6 +1305,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm
 {
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
 	struct vm_area_struct *vma = vmf->vma;
+	struct folio *folio;
 	struct page *page;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	pmd_t orig_pmd = vmf->orig_pmd;
@@ -1326,46 +1327,48 @@ vm_fault_t do_huge_pmd_wp_page(struct vm
 	}
 
 	page = pmd_page(orig_pmd);
+	folio = page_folio(page);
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 
 	/* Early check when only holding the PT lock. */
 	if (PageAnonExclusive(page))
 		goto reuse;
 
-	if (!trylock_page(page)) {
-		get_page(page);
+	if (!folio_trylock(folio)) {
+		folio_get(folio);
 		spin_unlock(vmf->ptl);
-		lock_page(page);
+		folio_lock(folio);
 		spin_lock(vmf->ptl);
 		if (unlikely(!pmd_same(*vmf->pmd, orig_pmd))) {
 			spin_unlock(vmf->ptl);
-			unlock_page(page);
-			put_page(page);
+			folio_unlock(folio);
+			folio_put(folio);
 			return 0;
 		}
-		put_page(page);
+		folio_put(folio);
 	}
 
 	/* Recheck after temporarily dropping the PT lock. */
 	if (PageAnonExclusive(page)) {
-		unlock_page(page);
+		folio_unlock(folio);
 		goto reuse;
 	}
 
 	/*
-	 * See do_wp_page(): we can only reuse the page exclusively if there are
-	 * no additional references. Note that we always drain the LRU
-	 * pagevecs immediately after adding a THP.
+	 * See do_wp_page(): we can only reuse the folio exclusively if
+	 * there are no additional references. Note that we always drain
+	 * the LRU pagevecs immediately after adding a THP.
 	 */
-	if (page_count(page) > 1 + PageSwapCache(page) * thp_nr_pages(page))
+	if (folio_ref_count(folio) >
+			1 + folio_test_swapcache(folio) * folio_nr_pages(folio))
 		goto unlock_fallback;
-	if (PageSwapCache(page))
-		try_to_free_swap(page);
-	if (page_count(page) == 1) {
+	if (folio_test_swapcache(folio))
+		folio_free_swap(folio);
+	if (folio_ref_count(folio) == 1) {
 		pmd_t entry;
 
 		page_move_anon_rmap(page, vma);
-		unlock_page(page);
+		folio_unlock(folio);
 reuse:
 		if (unlikely(unshare)) {
 			spin_unlock(vmf->ptl);
@@ -1380,7 +1383,7 @@ reuse:
 	}
 
 unlock_fallback:
-	unlock_page(page);
+	folio_unlock(folio);
 	spin_unlock(vmf->ptl);
 fallback:
 	__split_huge_pmd(vma, vmf->pmd, vmf->address, false, NULL);
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

