Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA3A6C54EE9
	for <mm-commits@archiver.kernel.org>; Fri,  2 Sep 2022 23:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbiIBX3b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Sep 2022 19:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiIBX2L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2022 19:28:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124E5BCCE4
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 16:28:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A363961F9A
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 23:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8BAC433D7;
        Fri,  2 Sep 2022 23:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662161289;
        bh=uQmDa0D00cO1gGF7LmC2HRt/VsY73NhhiRhDBDEmXeY=;
        h=Date:To:From:Subject:From;
        b=0s5iNB/zCVaVvSe61EJcs2TG2LLPYSlI5eWI2INa9rlTcAxw9MH2SFXIS1CdTpfxs
         AR9PBrCGEJrNnn1Vj4lYfh9+yUa8imAmW8l5Yg4kyglsRLAbw5OmfbTujsv96GLJYn
         NoK1X55PYcAEoMIysRuiWPAYO3XdN3YmUh+YQdoU=
Date:   Fri, 02 Sep 2022 16:28:08 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-lock_page_or_retry-to-folio_lock_or_retry.patch added to mm-unstable branch
Message-Id: <20220902232808.EA8BAC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert lock_page_or_retry() to folio_lock_or_retry()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-lock_page_or_retry-to-folio_lock_or_retry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-lock_page_or_retry-to-folio_lock_or_retry.patch

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
Subject: mm: convert lock_page_or_retry() to folio_lock_or_retry()
Date: Fri, 2 Sep 2022 20:46:53 +0100

Remove a call to compound_head() in each of the two callers.

Link: https://lkml.kernel.org/r/20220902194653.1739778-58-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    9 +++------
 mm/memory.c             |   10 +++++-----
 2 files changed, 8 insertions(+), 11 deletions(-)

--- a/include/linux/pagemap.h~mm-convert-lock_page_or_retry-to-folio_lock_or_retry
+++ a/include/linux/pagemap.h
@@ -989,19 +989,16 @@ static inline int lock_page_killable(str
 }
 
 /*
- * lock_page_or_retry - Lock the page, unless this would block and the
+ * folio_lock_or_retry - Lock the folio, unless this would block and the
  * caller indicated that it can handle a retry.
  *
  * Return value and mmap_lock implications depend on flags; see
  * __folio_lock_or_retry().
  */
-static inline bool lock_page_or_retry(struct page *page, struct mm_struct *mm,
-				     unsigned int flags)
+static inline bool folio_lock_or_retry(struct folio *folio,
+		struct mm_struct *mm, unsigned int flags)
 {
-	struct folio *folio;
 	might_sleep();
-
-	folio = page_folio(page);
 	return folio_trylock(folio) || __folio_lock_or_retry(folio, mm, flags);
 }
 
--- a/mm/memory.c~mm-convert-lock_page_or_retry-to-folio_lock_or_retry
+++ a/mm/memory.c
@@ -3620,11 +3620,11 @@ EXPORT_SYMBOL(unmap_mapping_range);
  */
 static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 {
-	struct page *page = vmf->page;
+	struct folio *folio = page_folio(vmf->page);
 	struct vm_area_struct *vma = vmf->vma;
 	struct mmu_notifier_range range;
 
-	if (!lock_page_or_retry(page, vma->vm_mm, vmf->flags))
+	if (!folio_lock_or_retry(folio, vma->vm_mm, vmf->flags))
 		return VM_FAULT_RETRY;
 	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_EXCLUSIVE, 0, vma,
 				vma->vm_mm, vmf->address & PAGE_MASK,
@@ -3634,10 +3634,10 @@ static vm_fault_t remove_device_exclusiv
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
 				&vmf->ptl);
 	if (likely(pte_same(*vmf->pte, vmf->orig_pte)))
-		restore_exclusive_pte(vma, page, vmf->address, vmf->pte);
+		restore_exclusive_pte(vma, vmf->page, vmf->address, vmf->pte);
 
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
-	unlock_page(page);
+	folio_unlock(folio);
 
 	mmu_notifier_invalidate_range_end(&range);
 	return 0;
@@ -3837,7 +3837,7 @@ vm_fault_t do_swap_page(struct vm_fault
 		goto out_release;
 	}
 
-	locked = lock_page_or_retry(page, vma->vm_mm, vmf->flags);
+	locked = folio_lock_or_retry(folio, vma->vm_mm, vmf->flags);
 
 	if (!locked) {
 		ret |= VM_FAULT_RETRY;
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

