Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4409CC7EE45
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 20:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjFIULK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 16:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbjFIULE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 16:11:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544BF3A85
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 13:11:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D828461E7E
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 20:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D89DC433D2;
        Fri,  9 Jun 2023 20:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686341462;
        bh=PyqTUoOJFJqfVQtGZLEOop4msBX14t7ZH16CSongymA=;
        h=Date:To:From:Subject:From;
        b=N8FkSdE7jsSPyK+pwrsgrQGNNv3mcJ2uMKJJFHUp7BavzFGfLROjLjqk26R8Xhndi
         92kJcjHSp5O1bEkRRGIR2DsUwLyYd1L7UrY96OItx3mW3N9VPHXevYvfAaphVSAMyu
         zGAzlAa92pg95LUuVBPxj6aoDgt2InIIgouCJjG4=
Date:   Fri, 09 Jun 2023 13:11:01 -0700
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
Subject: + mm-pagewalkers-action_again-if-pte_offset_map_lock-fails.patch added to mm-unstable branch
Message-Id: <20230609201102.2D89DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/pagewalkers: ACTION_AGAIN if pte_offset_map_lock() fails
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pagewalkers-action_again-if-pte_offset_map_lock-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagewalkers-action_again-if-pte_offset_map_lock-fails.patch

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
Subject: mm/pagewalkers: ACTION_AGAIN if pte_offset_map_lock() fails
Date: Thu, 8 Jun 2023 18:17:26 -0700 (PDT)

Simple walk_page_range() users should set ACTION_AGAIN to retry when
pte_offset_map_lock() fails.

No need to check pmd_trans_unstable(): that was precisely to avoid the
possiblity of calling pte_offset_map() on a racily removed or inserted THP
entry, but such cases are now safely handled inside it.  Likewise there is
no need to check pmd_none() or pmd_bad() before calling it.

Link: https://lkml.kernel.org/r/c77d9d10-3aad-e3ce-4896-99e91c7947f3@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: SeongJae Park <sj@kernel.org> for mm/damon part
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

 fs/proc/task_mmu.c |   32 ++++++++++++++++----------------
 mm/damon/vaddr.c   |   12 ++++++++----
 mm/mempolicy.c     |    7 ++++---
 mm/mincore.c       |    9 ++++-----
 mm/mlock.c         |    4 ++++
 5 files changed, 36 insertions(+), 28 deletions(-)

--- a/fs/proc/task_mmu.c~mm-pagewalkers-action_again-if-pte_offset_map_lock-fails
+++ a/fs/proc/task_mmu.c
@@ -631,14 +631,11 @@ static int smaps_pte_range(pmd_t *pmd, u
 		goto out;
 	}
 
-	if (pmd_trans_unstable(pmd))
-		goto out;
-	/*
-	 * The mmap_lock held all the way back in m_start() is what
-	 * keeps khugepaged out of here and from collapsing things
-	 * in here.
-	 */
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	if (!pte) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
 	for (; addr != end; pte++, addr += PAGE_SIZE)
 		smaps_pte_entry(pte, addr, walk);
 	pte_unmap_unlock(pte - 1, ptl);
@@ -1191,10 +1188,11 @@ out:
 		return 0;
 	}
 
-	if (pmd_trans_unstable(pmd))
-		return 0;
-
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	if (!pte) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		ptent = *pte;
 
@@ -1538,9 +1536,6 @@ static int pagemap_pmd_range(pmd_t *pmdp
 		spin_unlock(ptl);
 		return err;
 	}
-
-	if (pmd_trans_unstable(pmdp))
-		return 0;
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 	/*
@@ -1548,6 +1543,10 @@ static int pagemap_pmd_range(pmd_t *pmdp
 	 * goes beyond vma->vm_end.
 	 */
 	orig_pte = pte = pte_offset_map_lock(walk->mm, pmdp, addr, &ptl);
+	if (!pte) {
+		walk->action = ACTION_AGAIN;
+		return err;
+	}
 	for (; addr < end; pte++, addr += PAGE_SIZE) {
 		pagemap_entry_t pme;
 
@@ -1887,11 +1886,12 @@ static int gather_pte_stats(pmd_t *pmd,
 		spin_unlock(ptl);
 		return 0;
 	}
-
-	if (pmd_trans_unstable(pmd))
-		return 0;
 #endif
 	orig_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!pte) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
 	do {
 		struct page *page = can_gather_numa_stats(*pte, vma, addr);
 		if (!page)
--- a/mm/damon/vaddr.c~mm-pagewalkers-action_again-if-pte_offset_map_lock-fails
+++ a/mm/damon/vaddr.c
@@ -318,9 +318,11 @@ static int damon_mkold_pmd_entry(pmd_t *
 		spin_unlock(ptl);
 	}
 
-	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
-		return 0;
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!pte) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
 	if (!pte_present(*pte))
 		goto out;
 	damon_ptep_mkold(pte, walk->vma, addr);
@@ -464,9 +466,11 @@ huge_out:
 regular_page:
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
-	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
-		return -EINVAL;
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!pte) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
 	if (!pte_present(*pte))
 		goto out;
 	folio = damon_get_folio(pte_pfn(*pte));
--- a/mm/mempolicy.c~mm-pagewalkers-action_again-if-pte_offset_map_lock-fails
+++ a/mm/mempolicy.c
@@ -514,10 +514,11 @@ static int queue_folios_pte_range(pmd_t
 	if (ptl)
 		return queue_folios_pmd(pmd, ptl, addr, end, walk);
 
-	if (pmd_trans_unstable(pmd))
-		return 0;
-
 	mapped_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!pte) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		if (!pte_present(*pte))
 			continue;
--- a/mm/mincore.c~mm-pagewalkers-action_again-if-pte_offset_map_lock-fails
+++ a/mm/mincore.c
@@ -113,12 +113,11 @@ static int mincore_pte_range(pmd_t *pmd,
 		goto out;
 	}
 
-	if (pmd_trans_unstable(pmd)) {
-		__mincore_unmapped_range(addr, end, vma, vec);
-		goto out;
-	}
-
 	ptep = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!ptep) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
 	for (; addr != end; ptep++, addr += PAGE_SIZE) {
 		pte_t pte = *ptep;
 
--- a/mm/mlock.c~mm-pagewalkers-action_again-if-pte_offset_map_lock-fails
+++ a/mm/mlock.c
@@ -329,6 +329,10 @@ static int mlock_pte_range(pmd_t *pmd, u
 	}
 
 	start_pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	if (!start_pte) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
 	for (pte = start_pte; addr != end; pte++, addr += PAGE_SIZE) {
 		if (!pte_present(*pte))
 			continue;
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

