Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4708C54EE9
	for <mm-commits@archiver.kernel.org>; Fri,  2 Sep 2022 23:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiIBX0v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Sep 2022 19:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiIBX0k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2022 19:26:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C3FB99FD
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 16:26:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F19AA61F87
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 23:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535E7C433D6;
        Fri,  2 Sep 2022 23:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662161195;
        bh=ZLtWCPrRh6KKy7NgxT0LcXPq/11Z+bZ0iln04Mly9yw=;
        h=Date:To:From:Subject:From;
        b=sopZgUYn87rlN4gUs+VQbBoft48mk4boKu6A4QzS17bjdKVLCvp5jVmkkJ94ynapr
         SkkXHgwCq4JAizgXrwxVEFuE0Ttc/+SraJs/x/E/sorxuhjT+QRPiKxwtENBClBgXE
         iTzbzkuhVgAsnREazppHfaNwOlFw+lxuhovDXUm0=
Date:   Fri, 02 Sep 2022 16:26:34 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-convert-put_swap_page-to-put_swap_folio.patch added to mm-unstable branch
Message-Id: <20220902232635.535E7C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: convert put_swap_page() to put_swap_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-convert-put_swap_page-to-put_swap_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-convert-put_swap_page-to-put_swap_folio.patch

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
Subject: mm/swap: convert put_swap_page() to put_swap_folio()
Date: Fri, 2 Sep 2022 20:46:09 +0100

With all callers now using a folio, we can convert this function.

Link: https://lkml.kernel.org/r/20220902194653.1739778-14-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 ++--
 mm/shmem.c           |    2 +-
 mm/swap_slots.c      |    2 +-
 mm/swap_state.c      |    6 +++---
 mm/swapfile.c        |    4 ++--
 mm/vmscan.c          |    2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

--- a/include/linux/swap.h~mm-swap-convert-put_swap_page-to-put_swap_folio
+++ a/include/linux/swap.h
@@ -491,7 +491,7 @@ static inline long get_nr_swap_pages(voi
 extern void si_swapinfo(struct sysinfo *);
 swp_entry_t folio_alloc_swap(struct folio *folio);
 bool folio_free_swap(struct folio *folio);
-extern void put_swap_page(struct page *page, swp_entry_t entry);
+void put_swap_folio(struct folio *folio, swp_entry_t entry);
 extern swp_entry_t get_swap_page_of_type(int);
 extern int get_swap_pages(int n, swp_entry_t swp_entries[], int entry_size);
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
@@ -576,7 +576,7 @@ static inline void swap_free(swp_entry_t
 {
 }
 
-static inline void put_swap_page(struct page *page, swp_entry_t swp)
+static inline void put_swap_folio(struct folio *folio, swp_entry_t swp)
 {
 }
 
--- a/mm/shmem.c~mm-swap-convert-put_swap_page-to-put_swap_folio
+++ a/mm/shmem.c
@@ -1424,7 +1424,7 @@ static int shmem_writepage(struct page *
 	}
 
 	mutex_unlock(&shmem_swaplist_mutex);
-	put_swap_page(&folio->page, swap);
+	put_swap_folio(folio, swap);
 redirty:
 	folio_mark_dirty(folio);
 	if (wbc->for_reclaim)
--- a/mm/swapfile.c~mm-swap-convert-put_swap_page-to-put_swap_folio
+++ a/mm/swapfile.c
@@ -1332,7 +1332,7 @@ void swap_free(swp_entry_t entry)
 /*
  * Called after dropping swapcache to decrease refcnt to swap entries.
  */
-void put_swap_page(struct page *page, swp_entry_t entry)
+void put_swap_folio(struct folio *folio, swp_entry_t entry)
 {
 	unsigned long offset = swp_offset(entry);
 	unsigned long idx = offset / SWAPFILE_CLUSTER;
@@ -1341,7 +1341,7 @@ void put_swap_page(struct page *page, sw
 	unsigned char *map;
 	unsigned int i, free_entries = 0;
 	unsigned char val;
-	int size = swap_entry_size(thp_nr_pages(page));
+	int size = swap_entry_size(folio_nr_pages(folio));
 
 	si = _swap_info_get(entry);
 	if (!si)
--- a/mm/swap_slots.c~mm-swap-convert-put_swap_page-to-put_swap_folio
+++ a/mm/swap_slots.c
@@ -343,7 +343,7 @@ repeat:
 	get_swap_pages(1, &entry, 1);
 out:
 	if (mem_cgroup_try_charge_swap(folio, entry)) {
-		put_swap_page(&folio->page, entry);
+		put_swap_folio(folio, entry);
 		entry.val = 0;
 	}
 	return entry;
--- a/mm/swap_state.c~mm-swap-convert-put_swap_page-to-put_swap_folio
+++ a/mm/swap_state.c
@@ -218,7 +218,7 @@ bool add_to_swap(struct folio *folio)
 	return true;
 
 fail:
-	put_swap_page(&folio->page, entry);
+	put_swap_folio(folio, entry);
 	return false;
 }
 
@@ -237,7 +237,7 @@ void delete_from_swap_cache(struct folio
 	__delete_from_swap_cache(folio, entry, NULL);
 	xa_unlock_irq(&address_space->i_pages);
 
-	put_swap_page(&folio->page, entry);
+	put_swap_folio(folio, entry);
 	folio_ref_sub(folio, folio_nr_pages(folio));
 }
 
@@ -498,7 +498,7 @@ struct page *__read_swap_cache_async(swp
 	return &folio->page;
 
 fail_unlock:
-	put_swap_page(&folio->page, entry);
+	put_swap_folio(folio, entry);
 	folio_unlock(folio);
 	folio_put(folio);
 	return NULL;
--- a/mm/vmscan.c~mm-swap-convert-put_swap_page-to-put_swap_folio
+++ a/mm/vmscan.c
@@ -1353,7 +1353,7 @@ static int __remove_mapping(struct addre
 		mem_cgroup_swapout(folio, swap);
 		__delete_from_swap_cache(folio, swap, shadow);
 		xa_unlock_irq(&mapping->i_pages);
-		put_swap_page(&folio->page, swap);
+		put_swap_folio(folio, swap);
 	} else {
 		void (*free_folio)(struct folio *);
 
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

