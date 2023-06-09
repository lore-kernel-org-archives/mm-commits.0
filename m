Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD559C7EE37
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 20:11:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjFIULc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 16:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbjFIUL3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 16:11:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2141B9
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 13:11:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46C5D65B96
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 20:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93130C433D2;
        Fri,  9 Jun 2023 20:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686341486;
        bh=OW6mP8toVbUlqrD4Y09g8QABHW/UjxlZ+c6KfVVCMls=;
        h=Date:To:From:Subject:From;
        b=NmL9XNKGv/cyUVBfq3Od2B9HxONeg7sNkdkXAZqQVEKaVaW2uvq/Js6qOMshGFlS+
         pdY687nxVJ1k1HPIADJFG7rPeKCzCbkiIIngI6ULJ714jp7LFcDull2LjdShMo6Gvt
         fnX0hRuykZwJxSDq6A4xWOxvxGQR0vUIoqvF9/ug=
Date:   Fri, 09 Jun 2023 13:11:26 -0700
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
Subject: + mm-mremap-retry-if-either-pte_offset_map_lock-fails.patch added to mm-unstable branch
Message-Id: <20230609201126.93130C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: retry if either pte_offset_map_*lock() fails
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-retry-if-either-pte_offset_map_lock-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-retry-if-either-pte_offset_map_lock-fails.patch

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
Subject: mm/mremap: retry if either pte_offset_map_*lock() fails
Date: Thu, 8 Jun 2023 18:32:47 -0700 (PDT)

move_ptes() return -EAGAIN if pte_offset_map_lock() of old fails, or if
pte_offset_map_nolock() of new fails: move_page_tables() retry if so.

But that does need a pmd_none() check inside, to stop endless loop when
huge shmem is truncated (thank you to syzbot); and move_huge_pmd() must
tolerate that a page table might have been allocated there just before (of
course it would be more satisfying to remove the empty page table, but
this is not a path worth optimizing).

Link: https://lkml.kernel.org/r/65e5e84a-f04-947-23f2-b97d3462e1e@google.com
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

 mm/huge_memory.c |    5 +++--
 mm/mremap.c      |   28 ++++++++++++++++++++--------
 2 files changed, 23 insertions(+), 10 deletions(-)

--- a/mm/huge_memory.c~mm-mremap-retry-if-either-pte_offset_map_lock-fails
+++ a/mm/huge_memory.c
@@ -1760,9 +1760,10 @@ bool move_huge_pmd(struct vm_area_struct
 
 	/*
 	 * The destination pmd shouldn't be established, free_pgtables()
-	 * should have release it.
+	 * should have released it; but move_page_tables() might have already
+	 * inserted a page table, if racing against shmem/file collapse.
 	 */
-	if (WARN_ON(!pmd_none(*new_pmd))) {
+	if (!pmd_none(*new_pmd)) {
 		VM_BUG_ON(pmd_trans_huge(*new_pmd));
 		return false;
 	}
--- a/mm/mremap.c~mm-mremap-retry-if-either-pte_offset_map_lock-fails
+++ a/mm/mremap.c
@@ -133,7 +133,7 @@ static pte_t move_soft_dirty_pte(pte_t p
 	return pte;
 }
 
-static void move_ptes(struct vm_area_struct *vma, pmd_t *old_pmd,
+static int move_ptes(struct vm_area_struct *vma, pmd_t *old_pmd,
 		unsigned long old_addr, unsigned long old_end,
 		struct vm_area_struct *new_vma, pmd_t *new_pmd,
 		unsigned long new_addr, bool need_rmap_locks)
@@ -143,6 +143,7 @@ static void move_ptes(struct vm_area_str
 	spinlock_t *old_ptl, *new_ptl;
 	bool force_flush = false;
 	unsigned long len = old_end - old_addr;
+	int err = 0;
 
 	/*
 	 * When need_rmap_locks is true, we take the i_mmap_rwsem and anon_vma
@@ -170,8 +171,16 @@ static void move_ptes(struct vm_area_str
 	 * pte locks because exclusive mmap_lock prevents deadlock.
 	 */
 	old_pte = pte_offset_map_lock(mm, old_pmd, old_addr, &old_ptl);
-	new_pte = pte_offset_map(new_pmd, new_addr);
-	new_ptl = pte_lockptr(mm, new_pmd);
+	if (!old_pte) {
+		err = -EAGAIN;
+		goto out;
+	}
+	new_pte = pte_offset_map_nolock(mm, new_pmd, new_addr, &new_ptl);
+	if (!new_pte) {
+		pte_unmap_unlock(old_pte, old_ptl);
+		err = -EAGAIN;
+		goto out;
+	}
 	if (new_ptl != old_ptl)
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 	flush_tlb_batched_pending(vma->vm_mm);
@@ -208,8 +217,10 @@ static void move_ptes(struct vm_area_str
 		spin_unlock(new_ptl);
 	pte_unmap(new_pte - 1);
 	pte_unmap_unlock(old_pte - 1, old_ptl);
+out:
 	if (need_rmap_locks)
 		drop_rmap_locks(vma);
+	return err;
 }
 
 #ifndef arch_supports_page_table_move
@@ -537,6 +548,7 @@ unsigned long move_page_tables(struct vm
 		new_pmd = alloc_new_pmd(vma->vm_mm, vma, new_addr);
 		if (!new_pmd)
 			break;
+again:
 		if (is_swap_pmd(*old_pmd) || pmd_trans_huge(*old_pmd) ||
 		    pmd_devmap(*old_pmd)) {
 			if (extent == HPAGE_PMD_SIZE &&
@@ -544,8 +556,6 @@ unsigned long move_page_tables(struct vm
 					   old_pmd, new_pmd, need_rmap_locks))
 				continue;
 			split_huge_pmd(vma, old_pmd, old_addr);
-			if (pmd_trans_unstable(old_pmd))
-				continue;
 		} else if (IS_ENABLED(CONFIG_HAVE_MOVE_PMD) &&
 			   extent == PMD_SIZE) {
 			/*
@@ -556,11 +566,13 @@ unsigned long move_page_tables(struct vm
 					   old_pmd, new_pmd, true))
 				continue;
 		}
-
+		if (pmd_none(*old_pmd))
+			continue;
 		if (pte_alloc(new_vma->vm_mm, new_pmd))
 			break;
-		move_ptes(vma, old_pmd, old_addr, old_addr + extent, new_vma,
-			  new_pmd, new_addr, need_rmap_locks);
+		if (move_ptes(vma, old_pmd, old_addr, old_addr + extent,
+			      new_vma, new_pmd, new_addr, need_rmap_locks) < 0)
+			goto again;
 	}
 
 	mmu_notifier_invalidate_range_end(&range);
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

