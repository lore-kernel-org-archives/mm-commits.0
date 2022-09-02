Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E376ECAAA1
	for <mm-commits@archiver.kernel.org>; Fri,  2 Sep 2022 23:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiIBX1D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Sep 2022 19:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiIBX0r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2022 19:26:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E05D2E86
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 16:26:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71B7C61F92
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 23:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F6AC433D6;
        Fri,  2 Sep 2022 23:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662161202;
        bh=gK/xaTtFG9NYug+REaOUyzD9DV9F/Igqxxx5oUCMyz4=;
        h=Date:To:From:Subject:From;
        b=J0r8gC8MCcD4hFi9naTBdIvnzvHN7qhmTGu+cp6hS3tFti8pxgb3njoiiMJXtUrwE
         X1fxIkhv/LgUY/CZp7/1IfHW5RgUyZx7NWyu3m0H7Vfkks5Yqko5uLTO+7wT53PPoc
         UjPKEyjpR1JqfAf5epIRZWvOcG1xjXcgDYNlfCWU=
Date:   Fri, 02 Sep 2022 16:26:42 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-convert-mem_cgroup_swapin_charge_page-to-mem_cgroup_swapin_charge_folio.patch added to mm-unstable branch
Message-Id: <20220902232642.C6F6AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: convert mem_cgroup_swapin_charge_page() to mem_cgroup_swapin_charge_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-convert-mem_cgroup_swapin_charge_page-to-mem_cgroup_swapin_charge_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-convert-mem_cgroup_swapin_charge_page-to-mem_cgroup_swapin_charge_folio.patch

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
Subject: memcg: convert mem_cgroup_swapin_charge_page() to mem_cgroup_swapin_charge_folio()
Date: Fri, 2 Sep 2022 20:46:12 +0100

All callers now have a folio, so pass it in here and remove an unnecessary
call to page_folio().

Link: https://lkml.kernel.org/r/20220902194653.1739778-17-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |   13 ++++++-------
 mm/memory.c                |    2 +-
 mm/swap_state.c            |    2 +-
 4 files changed, 10 insertions(+), 11 deletions(-)

--- a/include/linux/memcontrol.h~memcg-convert-mem_cgroup_swapin_charge_page-to-mem_cgroup_swapin_charge_folio
+++ a/include/linux/memcontrol.h
@@ -688,7 +688,7 @@ static inline int mem_cgroup_charge(stru
 	return __mem_cgroup_charge(folio, mm, gfp);
 }
 
-int mem_cgroup_swapin_charge_page(struct page *page, struct mm_struct *mm,
+int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
 				  gfp_t gfp, swp_entry_t entry);
 void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry);
 
@@ -1254,7 +1254,7 @@ static inline int mem_cgroup_charge(stru
 	return 0;
 }
 
-static inline int mem_cgroup_swapin_charge_page(struct page *page,
+static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
 			struct mm_struct *mm, gfp_t gfp, swp_entry_t entry)
 {
 	return 0;
--- a/mm/memcontrol.c~memcg-convert-mem_cgroup_swapin_charge_page-to-mem_cgroup_swapin_charge_folio
+++ a/mm/memcontrol.c
@@ -6844,21 +6844,20 @@ int __mem_cgroup_charge(struct folio *fo
 }
 
 /**
- * mem_cgroup_swapin_charge_page - charge a newly allocated page for swapin
- * @page: page to charge
+ * mem_cgroup_swapin_charge_folio - Charge a newly allocated folio for swapin.
+ * @folio: folio to charge.
  * @mm: mm context of the victim
  * @gfp: reclaim mode
- * @entry: swap entry for which the page is allocated
+ * @entry: swap entry for which the folio is allocated
  *
- * This function charges a page allocated for swapin. Please call this before
- * adding the page to the swapcache.
+ * This function charges a folio allocated for swapin. Please call this before
+ * adding the folio to the swapcache.
  *
  * Returns 0 on success. Otherwise, an error code is returned.
  */
-int mem_cgroup_swapin_charge_page(struct page *page, struct mm_struct *mm,
+int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
 				  gfp_t gfp, swp_entry_t entry)
 {
-	struct folio *folio = page_folio(page);
 	struct mem_cgroup *memcg;
 	unsigned short id;
 	int ret;
--- a/mm/memory.c~memcg-convert-mem_cgroup_swapin_charge_page-to-mem_cgroup_swapin_charge_folio
+++ a/mm/memory.c
@@ -3785,7 +3785,7 @@ vm_fault_t do_swap_page(struct vm_fault
 				__folio_set_locked(folio);
 				__folio_set_swapbacked(folio);
 
-				if (mem_cgroup_swapin_charge_page(page,
+				if (mem_cgroup_swapin_charge_folio(folio,
 							vma->vm_mm, GFP_KERNEL,
 							entry)) {
 					ret = VM_FAULT_OOM;
--- a/mm/swap_state.c~memcg-convert-mem_cgroup_swapin_charge_page-to-mem_cgroup_swapin_charge_folio
+++ a/mm/swap_state.c
@@ -480,7 +480,7 @@ struct page *__read_swap_cache_async(swp
 	__folio_set_locked(folio);
 	__folio_set_swapbacked(folio);
 
-	if (mem_cgroup_swapin_charge_page(&folio->page, NULL, gfp_mask, entry))
+	if (mem_cgroup_swapin_charge_folio(folio, NULL, gfp_mask, entry))
 		goto fail_unlock;
 
 	/* May fail (-ENOMEM) if XArray node allocation failed. */
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

