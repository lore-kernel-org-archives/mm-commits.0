Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0946C7EE2E
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 20:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbjFIUMj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 16:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjFIUMP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 16:12:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A573A87
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 13:12:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39E0C655FF
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 20:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806D8C433EF;
        Fri,  9 Jun 2023 20:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686341521;
        bh=+uRQuJ25L6dpUb98tuJWOUIq+ZLQS1PAWw0HXkRh9v0=;
        h=Date:To:From:Subject:From;
        b=PwWFZX5apmWxC+urcHJ8mohk0dwXS0nYCyzrDHl+LldIhEBmeYd64Xm4qQs+eSHQV
         XQk+xwq98p3UB+QtObESLSeunrjo013XDTjElzlWizswl7kWHrP+nrLtVRA4ko/VFT
         9HyDbqwdAd3JUXr/7L5+mi6g8OT3JBPUR3c3yGkg=
Date:   Fri, 09 Jun 2023 13:12:00 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        zackr@vmware.com, yuzhao@google.com, ying.huang@intel.com,
        willy@infradead.org, will@kernel.org,
        thomas.hellstrom@linux.intel.com, surenb@google.com,
        steven.price@arm.com, song@kernel.org, sj@kernel.org,
        shy828301@gmail.com, ryan.roberts@arm.com, rppt@kernel.org,
        rcampbell@nvidia.com, peterz@infradead.org, peterx@redhat.com,
        pasha.tatashin@soleen.com, naoya.horiguchi@nec.com,
        minchan@kernel.org, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, lstoakes@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jgg@ziepe.ca, ira.weiny@intel.com, hch@infradead.org,
        david@redhat.com, christophe.leroy@csgroup.eu,
        axelrasmussen@google.com, apopple@nvidia.com,
        anshuman.khandual@arm.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-swap_vma_readahead-do-the-pte_offset_map.patch added to mm-unstable branch
Message-Id: <20230609201201.806D8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: swap_vma_readahead() do the pte_offset_map()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-swap_vma_readahead-do-the-pte_offset_map.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-swap_vma_readahead-do-the-pte_offset_map.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mm/swap: swap_vma_readahead() do the pte_offset_map()
Date: Thu, 8 Jun 2023 18:52:17 -0700 (PDT)

swap_vma_readahead() has been proceeding in an unconventional way, its
preliminary swap_ra_info() doing the pte_offset_map() and pte_unmap(),
then relying on that pte pointer even after the pte_unmap() - in its
CONFIG_64BIT case (I think !CONFIG_HIGHPTE was intended; whereas 32-bit
copied ptes to stack while they were mapped, but had to limit how many).

Though it would be difficult to construct a failing testcase, accessing
page table after pte_unmap() will become bad practice, even on 64-bit: an
rcu_read_unlock() in pte_unmap() will allow page table to be freed.

Move relevant definitions from include/linux/swap.h to mm/swap_state.c,
nothing else used them.  Delete the CONFIG_64BIT distinction and buffer,
delete all reference to ptes from swap_ra_info(), use pte_offset_map()
repeatedly in swap_vma_readahead(), breaking from the loop if it fails.

(Will the repeated "map" and "unmap" show up as a slowdown anywhere?  If
so, maybe modify __read_swap_cache_async() to do the pte_unmap() only when
it does not find the page already in the swapcache.)

Use ptep_get_lockless(), mainly for its READ_ONCE().  Correctly advance
the address passed down to each call of __read__swap_cache_async().

Link: https://lkml.kernel.org/r/b7c64ab3-9e44-aac0-d2b-c57de578af1c@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zack Rusin <zackr@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   19 -----------------
 mm/swap_state.c      |   45 +++++++++++++++++++++--------------------
 2 files changed, 24 insertions(+), 40 deletions(-)

--- a/include/linux/swap.h~mm-swap-swap_vma_readahead-do-the-pte_offset_map
+++ a/include/linux/swap.h
@@ -337,25 +337,6 @@ struct swap_info_struct {
 					   */
 };
 
-#ifdef CONFIG_64BIT
-#define SWAP_RA_ORDER_CEILING	5
-#else
-/* Avoid stack overflow, because we need to save part of page table */
-#define SWAP_RA_ORDER_CEILING	3
-#define SWAP_RA_PTE_CACHE_SIZE	(1 << SWAP_RA_ORDER_CEILING)
-#endif
-
-struct vma_swap_readahead {
-	unsigned short win;
-	unsigned short offset;
-	unsigned short nr_pte;
-#ifdef CONFIG_64BIT
-	pte_t *ptes;
-#else
-	pte_t ptes[SWAP_RA_PTE_CACHE_SIZE];
-#endif
-};
-
 static inline swp_entry_t folio_swap_entry(struct folio *folio)
 {
 	swp_entry_t entry = { .val = page_private(&folio->page) };
--- a/mm/swap_state.c~mm-swap-swap_vma_readahead-do-the-pte_offset_map
+++ a/mm/swap_state.c
@@ -709,6 +709,14 @@ void exit_swap_address_space(unsigned in
 	swapper_spaces[type] = NULL;
 }
 
+#define SWAP_RA_ORDER_CEILING	5
+
+struct vma_swap_readahead {
+	unsigned short win;
+	unsigned short offset;
+	unsigned short nr_pte;
+};
+
 static void swap_ra_info(struct vm_fault *vmf,
 			 struct vma_swap_readahead *ra_info)
 {
@@ -716,11 +724,7 @@ static void swap_ra_info(struct vm_fault
 	unsigned long ra_val;
 	unsigned long faddr, pfn, fpfn, lpfn, rpfn;
 	unsigned long start, end;
-	pte_t *pte, *orig_pte;
 	unsigned int max_win, hits, prev_win, win;
-#ifndef CONFIG_64BIT
-	pte_t *tpte;
-#endif
 
 	max_win = 1 << min_t(unsigned int, READ_ONCE(page_cluster),
 			     SWAP_RA_ORDER_CEILING);
@@ -739,12 +743,9 @@ static void swap_ra_info(struct vm_fault
 					       max_win, prev_win);
 	atomic_long_set(&vma->swap_readahead_info,
 			SWAP_RA_VAL(faddr, win, 0));
-
 	if (win == 1)
 		return;
 
-	/* Copy the PTEs because the page table may be unmapped */
-	orig_pte = pte = pte_offset_map(vmf->pmd, faddr);
 	if (fpfn == pfn + 1) {
 		lpfn = fpfn;
 		rpfn = fpfn + win;
@@ -764,15 +765,6 @@ static void swap_ra_info(struct vm_fault
 
 	ra_info->nr_pte = end - start;
 	ra_info->offset = fpfn - start;
-	pte -= ra_info->offset;
-#ifdef CONFIG_64BIT
-	ra_info->ptes = pte;
-#else
-	tpte = ra_info->ptes;
-	for (pfn = start; pfn != end; pfn++)
-		*tpte++ = *pte++;
-#endif
-	pte_unmap(orig_pte);
 }
 
 /**
@@ -796,7 +788,8 @@ static struct page *swap_vma_readahead(s
 	struct swap_iocb *splug = NULL;
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *page;
-	pte_t *pte, pentry;
+	pte_t *pte = NULL, pentry;
+	unsigned long addr;
 	swp_entry_t entry;
 	unsigned int i;
 	bool page_allocated;
@@ -808,17 +801,25 @@ static struct page *swap_vma_readahead(s
 	if (ra_info.win == 1)
 		goto skip;
 
+	addr = vmf->address - (ra_info.offset * PAGE_SIZE);
+
 	blk_start_plug(&plug);
-	for (i = 0, pte = ra_info.ptes; i < ra_info.nr_pte;
-	     i++, pte++) {
-		pentry = *pte;
+	for (i = 0; i < ra_info.nr_pte; i++, addr += PAGE_SIZE) {
+		if (!pte++) {
+			pte = pte_offset_map(vmf->pmd, addr);
+			if (!pte)
+				break;
+		}
+		pentry = ptep_get_lockless(pte);
 		if (!is_swap_pte(pentry))
 			continue;
 		entry = pte_to_swp_entry(pentry);
 		if (unlikely(non_swap_entry(entry)))
 			continue;
+		pte_unmap(pte);
+		pte = NULL;
 		page = __read_swap_cache_async(entry, gfp_mask, vma,
-					       vmf->address, &page_allocated);
+					       addr, &page_allocated);
 		if (!page)
 			continue;
 		if (page_allocated) {
@@ -830,6 +831,8 @@ static struct page *swap_vma_readahead(s
 		}
 		put_page(page);
 	}
+	if (pte)
+		pte_unmap(pte);
 	blk_finish_plug(&plug);
 	swap_read_unplug(splug);
 	lru_add_drain();
_

Patches currently in -mm which might be from hughd@google.com are

arm-allow-pte_offset_map-to-fail.patch
arm64-allow-pte_offset_map-to-fail.patch
arm64-hugetlb-pte_alloc_huge-pte_offset_huge.patch
ia64-hugetlb-pte_alloc_huge-pte_offset_huge.patch
m68k-allow-pte_offset_map-to-fail.patch
microblaze-allow-pte_offset_map-to-fail.patch
mips-update_mmu_cache-can-replace-__update_tlb.patch
mips-update_mmu_cache-can-replace-__update_tlb-fix.patch
parisc-add-pte_unmap-to-balance-get_ptep.patch
parisc-unmap_uncached_pte-use-pte_offset_kernel.patch
parisc-hugetlb-pte_alloc_huge-pte_offset_huge.patch
powerpc-kvmppc_unmap_free_pmd-pte_offset_kernel.patch
powerpc-allow-pte_offset_map-to-fail.patch
powerpc-hugetlb-pte_alloc_huge.patch
riscv-hugetlb-pte_alloc_huge-pte_offset_huge.patch
s390-allow-pte_offset_map_lock-to-fail.patch
s390-gmap-use-pte_unmap_unlock-not-spin_unlock.patch
sh-hugetlb-pte_alloc_huge-pte_offset_huge.patch
sparc-hugetlb-pte_alloc_huge-pte_offset_huge.patch
sparc-allow-pte_offset_map-to-fail.patch
sparc-iounit-and-iommu-use-pte_offset_kernel.patch
x86-allow-get_locked_pte-to-fail.patch
x86-sme_populate_pgd-use-pte_offset_kernel.patch
xtensa-add-pte_unmap-to-balance-pte_offset_map.patch
mm-use-pmdp_get_lockless-without-surplus-barrier.patch
mm-migrate-remove-cruft-from-migration_entry_waits.patch
mm-pgtable-kmap_local_page-instead-of-kmap_atomic.patch
mm-pgtable-allow-pte_offset_map-to-fail.patch
mm-filemap-allow-pte_offset_map_lock-to-fail.patch
mm-page_vma_mapped-delete-bogosity-in-page_vma_mapped_walk.patch
mm-page_vma_mapped-reformat-map_pte-with-less-indentation.patch
mm-page_vma_mapped-pte_offset_map_nolock-not-pte_lockptr.patch
mm-pagewalkers-action_again-if-pte_offset_map_lock-fails.patch
mm-pagewalk-walk_pte_range-allow-for-pte_offset_map.patch
mm-vmwgfx-simplify-pmd-pud-mapping-dirty-helpers.patch
mm-vmalloc-vmalloc_to_page-use-pte_offset_kernel.patch
mm-hmm-retry-if-pte_offset_map-fails.patch
mm-userfaultfd-retry-if-pte_offset_map-fails.patch
mm-userfaultfd-allow-pte_offset_map_lock-to-fail.patch
mm-debug_vm_pgtablepage_table_check-warn-pte-map-fails.patch
mm-various-give-up-if-pte_offset_map-fails.patch
mm-mprotect-delete-pmd_none_or_clear_bad_unless_trans_huge.patch
mm-mremap-retry-if-either-pte_offset_map_lock-fails.patch
mm-madvise-clean-up-pte_offset_map_lock-scans.patch
mm-madvise-clean-up-force_shm_swapin_readahead.patch
mm-swapoff-allow-pte_offset_map-to-fail.patch
mm-mglru-allow-pte_offset_map_nolock-to-fail.patch
mm-migrate_device-allow-pte_offset_map_lock-to-fail.patch
mm-gup-remove-foll_split_pmd-use-of-pmd_trans_unstable.patch
mm-huge_memory-split-huge-pmd-under-one-pte_offset_map.patch
mm-khugepaged-allow-pte_offset_map-to-fail.patch
mm-memory-allow-pte_offset_map-to-fail.patch
mm-memory-handle_pte_fault-use-pte_offset_map_nolock.patch
mm-pgtable-delete-pmd_trans_unstable-and-friends.patch
mm-swap-swap_vma_readahead-do-the-pte_offset_map.patch
perf-core-allow-pte_offset_map-to-fail.patch

