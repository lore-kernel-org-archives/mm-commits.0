Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658E4C6FA82
	for <mm-commits@archiver.kernel.org>; Fri,  2 Sep 2022 23:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiIBX0a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Sep 2022 19:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiIBX02 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2022 19:26:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C67A6C3E
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 16:26:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 018F4B82E0B
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 23:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6D7C433C1;
        Fri,  2 Sep 2022 23:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662161176;
        bh=gJIEnm4IcsYcCK5qrHYQLqLEKZSEFNMmixPqeeVSwFo=;
        h=Date:To:From:Subject:From;
        b=I1rnXMiECuq5eU5QLwpFoxrXCRoKJaXc/YzYCLUplHxdXa72ma4RNmZuL/cCFv3bf
         UU6a9Q5N0r7CfGYFGAt1DdiSwsCzxw94xknmSBYPMfKMvu1Fwgw1teA81o/GGoAOGw
         VGDBW2fg8xSR3EAyBlUoezpQzg99wEYuMfxrKFMI=
Date:   Fri, 02 Sep 2022 16:26:15 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-folio_add_lru_vma.patch added to mm-unstable branch
Message-Id: <20220902232616.AE6D7C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add folio_add_lru_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-folio_add_lru_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-folio_add_lru_vma.patch

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
Subject: mm: add folio_add_lru_vma()
Date: Fri, 2 Sep 2022 20:46:01 +0100

Convert lru_cache_add_inactive_or_unevictable() to folio_add_lru_vma()
and add a compatibility wrapper.

Link: https://lkml.kernel.org/r/20220902194653.1739778-6-willy@infradead.org

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   10 +++++-----
 mm/folio-compat.c    |    6 ++++++
 mm/swap.c            |   19 +++++++++----------
 3 files changed, 20 insertions(+), 15 deletions(-)

--- a/include/linux/swap.h~mm-add-folio_add_lru_vma
+++ a/include/linux/swap.h
@@ -379,11 +379,11 @@ extern unsigned long totalreserve_pages;
 
 
 /* linux/mm/swap.c */
-extern void lru_note_cost(struct lruvec *lruvec, bool file,
-			  unsigned int nr_pages);
-extern void lru_note_cost_folio(struct folio *);
-extern void folio_add_lru(struct folio *);
-extern void lru_cache_add(struct page *);
+void lru_note_cost(struct lruvec *lruvec, bool file, unsigned int nr_pages);
+void lru_note_cost_folio(struct folio *);
+void folio_add_lru(struct folio *);
+void folio_add_lru_vma(struct folio *, struct vm_area_struct *);
+void lru_cache_add(struct page *);
 void mark_page_accessed(struct page *);
 void folio_mark_accessed(struct folio *);
 
--- a/mm/folio-compat.c~mm-add-folio_add_lru_vma
+++ a/mm/folio-compat.c
@@ -88,6 +88,12 @@ void lru_cache_add(struct page *page)
 }
 EXPORT_SYMBOL(lru_cache_add);
 
+void lru_cache_add_inactive_or_unevictable(struct page *page,
+		struct vm_area_struct *vma)
+{
+	folio_add_lru_vma(page_folio(page), vma);
+}
+
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 		pgoff_t index, gfp_t gfp)
 {
--- a/mm/swap.c~mm-add-folio_add_lru_vma
+++ a/mm/swap.c
@@ -537,22 +537,21 @@ void folio_add_lru(struct folio *folio)
 EXPORT_SYMBOL(folio_add_lru);
 
 /**
- * lru_cache_add_inactive_or_unevictable
- * @page:  the page to be added to LRU
- * @vma:   vma in which page is mapped for determining reclaimability
+ * folio_add_lru_vma() - Add a folio to the appropate LRU list for this VMA.
+ * @folio: The folio to be added to the LRU.
+ * @vma: VMA in which the folio is mapped.
  *
- * Place @page on the inactive or unevictable LRU list, depending on its
- * evictability.
+ * If the VMA is mlocked, @folio is added to the unevictable list.
+ * Otherwise, it is treated the same way as folio_add_lru().
  */
-void lru_cache_add_inactive_or_unevictable(struct page *page,
-					 struct vm_area_struct *vma)
+void folio_add_lru_vma(struct folio *folio, struct vm_area_struct *vma)
 {
-	VM_BUG_ON_PAGE(PageLRU(page), page);
+	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
 	if (unlikely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) == VM_LOCKED))
-		mlock_new_page(page);
+		mlock_new_page(&folio->page);
 	else
-		lru_cache_add(page);
+		folio_add_lru(folio);
 }
 
 /*
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

