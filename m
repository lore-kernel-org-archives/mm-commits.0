Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 909B7C6FA82
	for <mm-commits@archiver.kernel.org>; Fri,  2 Sep 2022 23:28:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiIBX22 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Sep 2022 19:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiIBX12 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2022 19:27:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C0BCE335
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 16:27:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A5F4B82E0C
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 23:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119C7C433D7;
        Fri,  2 Sep 2022 23:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662161244;
        bh=/tVyvpm1zC4xTc90AWmAz/rbGe6NZ5dev7JgqKx31bE=;
        h=Date:To:From:Subject:From;
        b=QnlMhJ8Nyn8rXJ8Je3dRuiiNQyXWgYeAwVxCVpqBrTtQUgOXbzEDKUHe5A2QyRJFe
         HA39bhCD8xu6onkpmGeOoBQeQFUbmyHlcD4UC8sMlcIhDF1gQGS/RWuEG/EeUd8GaW
         3zfkqVkumFo3S1u7M82pl5Is4YBfMdh+01IDCaqw=
Date:   Fri, 02 Sep 2022 16:27:23 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + swapfile-convert-unuse_pte_range-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20220902232724.119C7C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swapfile: convert unuse_pte_range() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     swapfile-convert-unuse_pte_range-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/swapfile-convert-unuse_pte_range-to-use-a-folio.patch

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
Subject: swapfile: convert unuse_pte_range() to use a folio
Date: Fri, 2 Sep 2022 20:46:32 +0100

Delay fetching the precise page from the folio until we're in unuse_pte().
Saves many calls to compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-37-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

--- a/mm/swapfile.c~swapfile-convert-unuse_pte_range-to-use-a-folio
+++ a/mm/swapfile.c
@@ -1758,8 +1758,9 @@ static inline int pte_same_as_swp(pte_t
  * force COW, vm_page_prot omits write permission from any private vma.
  */
 static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long addr, swp_entry_t entry, struct page *page)
+		unsigned long addr, swp_entry_t entry, struct folio *folio)
 {
+	struct page *page = folio_file_page(folio, swp_offset(entry));
 	struct page *swapcache;
 	spinlock_t *ptl;
 	pte_t *pte, new_pte;
@@ -1831,17 +1832,18 @@ static int unuse_pte_range(struct vm_are
 			unsigned long addr, unsigned long end,
 			unsigned int type)
 {
-	struct page *page;
 	swp_entry_t entry;
 	pte_t *pte;
 	struct swap_info_struct *si;
-	unsigned long offset;
 	int ret = 0;
 	volatile unsigned char *swap_map;
 
 	si = swap_info[type];
 	pte = pte_offset_map(pmd, addr);
 	do {
+		struct folio *folio;
+		unsigned long offset;
+
 		if (!is_swap_pte(*pte))
 			continue;
 
@@ -1852,8 +1854,9 @@ static int unuse_pte_range(struct vm_are
 		offset = swp_offset(entry);
 		pte_unmap(pte);
 		swap_map = &si->swap_map[offset];
-		page = lookup_swap_cache(entry, vma, addr);
-		if (!page) {
+		folio = swap_cache_get_folio(entry, vma, addr);
+		if (!folio) {
+			struct page *page;
 			struct vm_fault vmf = {
 				.vma = vma,
 				.address = addr,
@@ -1863,25 +1866,27 @@ static int unuse_pte_range(struct vm_are
 
 			page = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE,
 						&vmf);
+			if (page)
+				folio = page_folio(page);
 		}
-		if (!page) {
+		if (!folio) {
 			if (*swap_map == 0 || *swap_map == SWAP_MAP_BAD)
 				goto try_next;
 			return -ENOMEM;
 		}
 
-		lock_page(page);
-		wait_on_page_writeback(page);
-		ret = unuse_pte(vma, pmd, addr, entry, page);
+		folio_lock(folio);
+		folio_wait_writeback(folio);
+		ret = unuse_pte(vma, pmd, addr, entry, folio);
 		if (ret < 0) {
-			unlock_page(page);
-			put_page(page);
+			folio_unlock(folio);
+			folio_put(folio);
 			goto out;
 		}
 
-		try_to_free_swap(page);
-		unlock_page(page);
-		put_page(page);
+		folio_free_swap(folio);
+		folio_unlock(folio);
+		folio_put(folio);
 try_next:
 		pte = pte_offset_map(pmd, addr);
 	} while (pte++, addr += PAGE_SIZE, addr != end);
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

