Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52712ECAAA1
	for <mm-commits@archiver.kernel.org>; Fri,  2 Sep 2022 23:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiIBX0t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Sep 2022 19:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiIBX0f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2022 19:26:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C491AAF4B8
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 16:26:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4037261F92
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 23:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976A5C433C1;
        Fri,  2 Sep 2022 23:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662161192;
        bh=uNQjSaLgu+xMhDEqvNwZUpEHrxVA1aTdx/NVH5lfDZI=;
        h=Date:To:From:Subject:From;
        b=q1XLL3NJFuy3Kss7Pque3UBK2bo4Fn9lmI63/LKABEmBxhcdNorKWZZIBK+g5cKXt
         CEBuKj/6HnmI1xLW7hXoClBkkfw8Sw2mm2tw2MKPlDYCG5kAm4E38vwXSqzYWeunSx
         GujHj2NlwEfBblMw4dcRjUPKHrMCaq0pYQrNHB5I=
Date:   Fri, 02 Sep 2022 16:26:31 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-convert-add_to_swap_cache-to-take-a-folio.patch added to mm-unstable branch
Message-Id: <20220902232632.976A5C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: convert add_to_swap_cache() to take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-convert-add_to_swap_cache-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-convert-add_to_swap_cache-to-take-a-folio.patch

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
Subject: mm/swap: convert add_to_swap_cache() to take a folio
Date: Fri, 2 Sep 2022 20:46:08 +0100

With all callers using folios, we can convert add_to_swap_cache() to take
a folio and use it throughout.

Link: https://lkml.kernel.org/r/20220902194653.1739778-13-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c      |    2 +-
 mm/swap.h       |    4 ++--
 mm/swap_state.c |   34 +++++++++++++++++-----------------
 3 files changed, 20 insertions(+), 20 deletions(-)

--- a/mm/shmem.c~mm-swap-convert-add_to_swap_cache-to-take-a-folio
+++ a/mm/shmem.c
@@ -1406,7 +1406,7 @@ static int shmem_writepage(struct page *
 	if (list_empty(&info->swaplist))
 		list_add(&info->swaplist, &shmem_swaplist);
 
-	if (add_to_swap_cache(&folio->page, swap,
+	if (add_to_swap_cache(folio, swap,
 			__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN,
 			NULL) == 0) {
 		spin_lock_irq(&info->lock);
--- a/mm/swap.h~mm-swap-convert-add_to_swap_cache-to-take-a-folio
+++ a/mm/swap.h
@@ -32,7 +32,7 @@ extern struct address_space *swapper_spa
 void show_swap_cache_info(void);
 bool add_to_swap(struct folio *folio);
 void *get_shadow_from_swap_cache(swp_entry_t entry);
-int add_to_swap_cache(struct page *page, swp_entry_t entry,
+int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
 		      gfp_t gfp, void **shadowp);
 void __delete_from_swap_cache(struct folio *folio,
 			      swp_entry_t entry, void *shadow);
@@ -122,7 +122,7 @@ static inline void *get_shadow_from_swap
 	return NULL;
 }
 
-static inline int add_to_swap_cache(struct page *page, swp_entry_t entry,
+static inline int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
 					gfp_t gfp_mask, void **shadowp)
 {
 	return -1;
--- a/mm/swap_state.c~mm-swap-convert-add_to_swap_cache-to-take-a-folio
+++ a/mm/swap_state.c
@@ -85,21 +85,21 @@ void *get_shadow_from_swap_cache(swp_ent
  * add_to_swap_cache resembles filemap_add_folio on swapper_space,
  * but sets SwapCache flag and private instead of mapping and index.
  */
-int add_to_swap_cache(struct page *page, swp_entry_t entry,
+int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
 			gfp_t gfp, void **shadowp)
 {
 	struct address_space *address_space = swap_address_space(entry);
 	pgoff_t idx = swp_offset(entry);
-	XA_STATE_ORDER(xas, &address_space->i_pages, idx, compound_order(page));
-	unsigned long i, nr = thp_nr_pages(page);
+	XA_STATE_ORDER(xas, &address_space->i_pages, idx, folio_order(folio));
+	unsigned long i, nr = folio_nr_pages(folio);
 	void *old;
 
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(PageSwapCache(page), page);
-	VM_BUG_ON_PAGE(!PageSwapBacked(page), page);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
+	VM_BUG_ON_FOLIO(!folio_test_swapbacked(folio), folio);
 
-	page_ref_add(page, nr);
-	SetPageSwapCache(page);
+	folio_ref_add(folio, nr);
+	folio_set_swapcache(folio);
 
 	do {
 		xas_lock_irq(&xas);
@@ -107,19 +107,19 @@ int add_to_swap_cache(struct page *page,
 		if (xas_error(&xas))
 			goto unlock;
 		for (i = 0; i < nr; i++) {
-			VM_BUG_ON_PAGE(xas.xa_index != idx + i, page);
+			VM_BUG_ON_FOLIO(xas.xa_index != idx + i, folio);
 			old = xas_load(&xas);
 			if (xa_is_value(old)) {
 				if (shadowp)
 					*shadowp = old;
 			}
-			set_page_private(page + i, entry.val + i);
-			xas_store(&xas, page);
+			set_page_private(folio_page(folio, i), entry.val + i);
+			xas_store(&xas, folio);
 			xas_next(&xas);
 		}
 		address_space->nrpages += nr;
-		__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, nr);
-		__mod_lruvec_page_state(page, NR_SWAPCACHE, nr);
+		__node_stat_mod_folio(folio, NR_FILE_PAGES, nr);
+		__lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr);
 unlock:
 		xas_unlock_irq(&xas);
 	} while (xas_nomem(&xas, gfp));
@@ -127,8 +127,8 @@ unlock:
 	if (!xas_error(&xas))
 		return 0;
 
-	ClearPageSwapCache(page);
-	page_ref_sub(page, nr);
+	folio_clear_swapcache(folio);
+	folio_ref_sub(folio, nr);
 	return xas_error(&xas);
 }
 
@@ -194,7 +194,7 @@ bool add_to_swap(struct folio *folio)
 	/*
 	 * Add it to the swap cache.
 	 */
-	err = add_to_swap_cache(&folio->page, entry,
+	err = add_to_swap_cache(folio, entry,
 			__GFP_HIGH|__GFP_NOMEMALLOC|__GFP_NOWARN, NULL);
 	if (err)
 		/*
@@ -484,7 +484,7 @@ struct page *__read_swap_cache_async(swp
 		goto fail_unlock;
 
 	/* May fail (-ENOMEM) if XArray node allocation failed. */
-	if (add_to_swap_cache(&folio->page, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow))
+	if (add_to_swap_cache(folio, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow))
 		goto fail_unlock;
 
 	mem_cgroup_swapin_uncharge_swap(entry);
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

