Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD00EC7EE2E
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 20:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbjFIULh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 16:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbjFIULc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 16:11:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFD12D5F
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 13:11:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C83EC65B8F
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 20:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F41EC433EF;
        Fri,  9 Jun 2023 20:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686341489;
        bh=JtKpN6xqwzJ3fvJ0btDqAb1ug3qdHcWfs+z692zDFZM=;
        h=Date:To:From:Subject:From;
        b=clYib4XHZUkA372MQYv4ijHBaqF79sFV8quiH34SaJ2nD8peZQEkOh3LG0YxmF/Bg
         11H2GXicgh2tyov1kZajvCWNHv+RHaZL2XYmUZVXuH1u7+biZbLqbyYLA7aGYEJOyo
         3SAb56iDSG3JrfZVlL3M/2M+GTRje1mU4ANrM1g0=
Date:   Fri, 09 Jun 2023 13:11:28 -0700
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
Subject: + mm-madvise-clean-up-pte_offset_map_lock-scans.patch added to mm-unstable branch
Message-Id: <20230609201129.1F41EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: clean up pte_offset_map_lock() scans
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-clean-up-pte_offset_map_lock-scans.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-clean-up-pte_offset_map_lock-scans.patch

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
Subject: mm/madvise: clean up pte_offset_map_lock() scans
Date: Thu, 8 Jun 2023 18:34:03 -0700 (PDT)

Came here to make madvise's several pte_offset_map_lock() scans advance to
next extent on failure, and remove superfluous pmd_trans_unstable() and
pmd_none_or_trans_huge_or_clear_bad() calls.  But also did some nearby
cleanup.

swapin_walk_pmd_entry(): don't name an address "index"; don't drop the
lock after every pte, only when calling out to read_swap_cache_async().

madvise_cold_or_pageout_pte_range() and madvise_free_pte_range(): prefer
"start_pte" for pointer, orig_pte usually denotes a saved pte value; leave
lazy MMU mode before unlocking; merge the success and failure paths after
split_folio().

Link: https://lkml.kernel.org/r/cc4d9a88-9da6-362-50d9-6735c2b125c6@google.com
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

 mm/madvise.c |  122 +++++++++++++++++++++++++++----------------------
 1 file changed, 68 insertions(+), 54 deletions(-)

--- a/mm/madvise.c~mm-madvise-clean-up-pte_offset_map_lock-scans
+++ a/mm/madvise.c
@@ -188,37 +188,43 @@ success:
 
 #ifdef CONFIG_SWAP
 static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
-	unsigned long end, struct mm_walk *walk)
+		unsigned long end, struct mm_walk *walk)
 {
 	struct vm_area_struct *vma = walk->private;
-	unsigned long index;
 	struct swap_iocb *splug = NULL;
+	pte_t *ptep = NULL;
+	spinlock_t *ptl;
+	unsigned long addr;
 
-	if (pmd_none_or_trans_huge_or_clear_bad(pmd))
-		return 0;
-
-	for (index = start; index != end; index += PAGE_SIZE) {
+	for (addr = start; addr < end; addr += PAGE_SIZE) {
 		pte_t pte;
 		swp_entry_t entry;
 		struct page *page;
-		spinlock_t *ptl;
-		pte_t *ptep;
 
-		ptep = pte_offset_map_lock(vma->vm_mm, pmd, index, &ptl);
-		pte = *ptep;
-		pte_unmap_unlock(ptep, ptl);
+		if (!ptep++) {
+			ptep = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+			if (!ptep)
+				break;
+		}
 
+		pte = *ptep;
 		if (!is_swap_pte(pte))
 			continue;
 		entry = pte_to_swp_entry(pte);
 		if (unlikely(non_swap_entry(entry)))
 			continue;
 
+		pte_unmap_unlock(ptep, ptl);
+		ptep = NULL;
+
 		page = read_swap_cache_async(entry, GFP_HIGHUSER_MOVABLE,
-					     vma, index, false, &splug);
+					     vma, addr, false, &splug);
 		if (page)
 			put_page(page);
 	}
+
+	if (ptep)
+		pte_unmap_unlock(ptep, ptl);
 	swap_read_unplug(splug);
 	cond_resched();
 
@@ -340,7 +346,7 @@ static int madvise_cold_or_pageout_pte_r
 	bool pageout = private->pageout;
 	struct mm_struct *mm = tlb->mm;
 	struct vm_area_struct *vma = walk->vma;
-	pte_t *orig_pte, *pte, ptent;
+	pte_t *start_pte, *pte, ptent;
 	spinlock_t *ptl;
 	struct folio *folio = NULL;
 	LIST_HEAD(folio_list);
@@ -424,11 +430,11 @@ huge_unlock:
 	}
 
 regular_folio:
-	if (pmd_trans_unstable(pmd))
-		return 0;
 #endif
 	tlb_change_page_size(tlb, PAGE_SIZE);
-	orig_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	if (!start_pte)
+		return 0;
 	flush_tlb_batched_pending(mm);
 	arch_enter_lazy_mmu_mode();
 	for (; addr < end; pte++, addr += PAGE_SIZE) {
@@ -449,25 +455,28 @@ regular_folio:
 		 * are sure it's worth. Split it if we are only owner.
 		 */
 		if (folio_test_large(folio)) {
+			int err;
+
 			if (folio_mapcount(folio) != 1)
 				break;
 			if (pageout_anon_only_filter && !folio_test_anon(folio))
 				break;
-			folio_get(folio);
-			if (!folio_trylock(folio)) {
-				folio_put(folio);
-				break;
-			}
-			pte_unmap_unlock(orig_pte, ptl);
-			if (split_folio(folio)) {
-				folio_unlock(folio);
-				folio_put(folio);
-				orig_pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+			if (!folio_trylock(folio))
 				break;
-			}
+			folio_get(folio);
+			arch_leave_lazy_mmu_mode();
+			pte_unmap_unlock(start_pte, ptl);
+			start_pte = NULL;
+			err = split_folio(folio);
 			folio_unlock(folio);
 			folio_put(folio);
-			orig_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+			if (err)
+				break;
+			start_pte = pte =
+				pte_offset_map_lock(mm, pmd, addr, &ptl);
+			if (!start_pte)
+				break;
+			arch_enter_lazy_mmu_mode();
 			pte--;
 			addr -= PAGE_SIZE;
 			continue;
@@ -514,8 +523,10 @@ regular_folio:
 			folio_deactivate(folio);
 	}
 
-	arch_leave_lazy_mmu_mode();
-	pte_unmap_unlock(orig_pte, ptl);
+	if (start_pte) {
+		arch_leave_lazy_mmu_mode();
+		pte_unmap_unlock(start_pte, ptl);
+	}
 	if (pageout)
 		reclaim_pages(&folio_list);
 	cond_resched();
@@ -616,7 +627,7 @@ static int madvise_free_pte_range(pmd_t
 	struct mm_struct *mm = tlb->mm;
 	struct vm_area_struct *vma = walk->vma;
 	spinlock_t *ptl;
-	pte_t *orig_pte, *pte, ptent;
+	pte_t *start_pte, *pte, ptent;
 	struct folio *folio;
 	int nr_swap = 0;
 	unsigned long next;
@@ -624,13 +635,12 @@ static int madvise_free_pte_range(pmd_t
 	next = pmd_addr_end(addr, end);
 	if (pmd_trans_huge(*pmd))
 		if (madvise_free_huge_pmd(tlb, vma, pmd, addr, next))
-			goto next;
-
-	if (pmd_trans_unstable(pmd))
-		return 0;
+			return 0;
 
 	tlb_change_page_size(tlb, PAGE_SIZE);
-	orig_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	start_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	if (!start_pte)
+		return 0;
 	flush_tlb_batched_pending(mm);
 	arch_enter_lazy_mmu_mode();
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
@@ -668,23 +678,26 @@ static int madvise_free_pte_range(pmd_t
 		 * deactivate all pages.
 		 */
 		if (folio_test_large(folio)) {
+			int err;
+
 			if (folio_mapcount(folio) != 1)
-				goto out;
+				break;
+			if (!folio_trylock(folio))
+				break;
 			folio_get(folio);
-			if (!folio_trylock(folio)) {
-				folio_put(folio);
-				goto out;
-			}
-			pte_unmap_unlock(orig_pte, ptl);
-			if (split_folio(folio)) {
-				folio_unlock(folio);
-				folio_put(folio);
-				orig_pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
-				goto out;
-			}
+			arch_leave_lazy_mmu_mode();
+			pte_unmap_unlock(start_pte, ptl);
+			start_pte = NULL;
+			err = split_folio(folio);
 			folio_unlock(folio);
 			folio_put(folio);
-			orig_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+			if (err)
+				break;
+			start_pte = pte =
+				pte_offset_map_lock(mm, pmd, addr, &ptl);
+			if (!start_pte)
+				break;
+			arch_enter_lazy_mmu_mode();
 			pte--;
 			addr -= PAGE_SIZE;
 			continue;
@@ -729,17 +742,18 @@ static int madvise_free_pte_range(pmd_t
 		}
 		folio_mark_lazyfree(folio);
 	}
-out:
+
 	if (nr_swap) {
 		if (current->mm == mm)
 			sync_mm_rss(mm);
-
 		add_mm_counter(mm, MM_SWAPENTS, nr_swap);
 	}
-	arch_leave_lazy_mmu_mode();
-	pte_unmap_unlock(orig_pte, ptl);
+	if (start_pte) {
+		arch_leave_lazy_mmu_mode();
+		pte_unmap_unlock(start_pte, ptl);
+	}
 	cond_resched();
-next:
+
 	return 0;
 }
 
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

