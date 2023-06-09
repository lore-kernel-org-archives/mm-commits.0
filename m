Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92549C7EE37
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 20:12:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbjFIUMi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 16:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbjFIUMP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 16:12:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AB730DA
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 13:12:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCF4565BAE
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 20:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11808C433EF;
        Fri,  9 Jun 2023 20:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686341519;
        bh=V8txpQ7ckzCnQ8EmSfFUkrwFOD6wXtASbJDMTEpYpMI=;
        h=Date:To:From:Subject:From;
        b=QeNURq2/MO4twnoMNTg51JozhGX/8h0Uys8hA6n+e+PSZnH2YRp6Xefi7vkPrb6te
         lAtv7eX2jVtxvXNopj3jsrzt9mCyBvS4REZHufqYllHz8tKagodwEKBvhLMWPhQBwG
         gZgo9n9Atlr0ggEsBLCneFSyoGtoTBxDqgYgojGk=
Date:   Fri, 09 Jun 2023 13:11:58 -0700
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
Subject: + mm-pgtable-delete-pmd_trans_unstable-and-friends.patch added to mm-unstable branch
Message-Id: <20230609201159.11808C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/pgtable: delete pmd_trans_unstable() and friends
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pgtable-delete-pmd_trans_unstable-and-friends.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-delete-pmd_trans_unstable-and-friends.patch

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
Subject: mm/pgtable: delete pmd_trans_unstable() and friends
Date: Thu, 8 Jun 2023 18:50:37 -0700 (PDT)

Delete pmd_trans_unstable, pmd_none_or_trans_huge_or_clear_bad() and
pmd_devmap_trans_unstable(), all now unused.

With mixed feelings, delete all the comments on pmd_trans_unstable(). 
That was very good documentation of a subtle state, and this series does
not even eliminate that state: but rather, normalizes and extends it,
asking pte_offset_map[_lock]() callers to anticipate failure, without
regard for whether mmap_read_lock() or mmap_write_lock() is held.

Retain pud_trans_unstable(), which has one use in __handle_mm_fault(), but
delete its equivalent pud_none_or_trans_huge_or_dev_or_clear_bad().  While
there, move the default arch_needs_pgtable_deposit() definition up near
where pgtable_trans_huge_deposit() and withdraw() are declared.

Link: https://lkml.kernel.org/r/5abdab3-3136-b42e-274d-9c6281bfb79@google.com
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

 include/linux/pgtable.h |  103 ++------------------------------------
 mm/khugepaged.c         |    4 -
 2 files changed, 7 insertions(+), 100 deletions(-)

--- a/include/linux/pgtable.h~mm-pgtable-delete-pmd_trans_unstable-and-friends
+++ a/include/linux/pgtable.h
@@ -599,6 +599,10 @@ extern void pgtable_trans_huge_deposit(s
 extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
 #endif
 
+#ifndef arch_needs_pgtable_deposit
+#define arch_needs_pgtable_deposit() (false)
+#endif
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
  * This is an implementation of pmdp_establish() that is only suitable for an
@@ -1300,9 +1304,10 @@ static inline int pud_trans_huge(pud_t p
 }
 #endif
 
-/* See pmd_none_or_trans_huge_or_clear_bad for discussion. */
-static inline int pud_none_or_trans_huge_or_dev_or_clear_bad(pud_t *pud)
+static inline int pud_trans_unstable(pud_t *pud)
 {
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
+	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
 	pud_t pudval = READ_ONCE(*pud);
 
 	if (pud_none(pudval) || pud_trans_huge(pudval) || pud_devmap(pudval))
@@ -1311,104 +1316,10 @@ static inline int pud_none_or_trans_huge
 		pud_clear_bad(pud);
 		return 1;
 	}
-	return 0;
-}
-
-/* See pmd_trans_unstable for discussion. */
-static inline int pud_trans_unstable(pud_t *pud)
-{
-#if defined(CONFIG_TRANSPARENT_HUGEPAGE) &&			\
-	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
-	return pud_none_or_trans_huge_or_dev_or_clear_bad(pud);
-#else
-	return 0;
 #endif
-}
-
-#ifndef arch_needs_pgtable_deposit
-#define arch_needs_pgtable_deposit() (false)
-#endif
-/*
- * This function is meant to be used by sites walking pagetables with
- * the mmap_lock held in read mode to protect against MADV_DONTNEED and
- * transhuge page faults. MADV_DONTNEED can convert a transhuge pmd
- * into a null pmd and the transhuge page fault can convert a null pmd
- * into an hugepmd or into a regular pmd (if the hugepage allocation
- * fails). While holding the mmap_lock in read mode the pmd becomes
- * stable and stops changing under us only if it's not null and not a
- * transhuge pmd. When those races occurs and this function makes a
- * difference vs the standard pmd_none_or_clear_bad, the result is
- * undefined so behaving like if the pmd was none is safe (because it
- * can return none anyway). The compiler level barrier() is critically
- * important to compute the two checks atomically on the same pmdval.
- *
- * For 32bit kernels with a 64bit large pmd_t this automatically takes
- * care of reading the pmd atomically to avoid SMP race conditions
- * against pmd_populate() when the mmap_lock is hold for reading by the
- * caller (a special atomic read not done by "gcc" as in the generic
- * version above, is also needed when THP is disabled because the page
- * fault can populate the pmd from under us).
- */
-static inline int pmd_none_or_trans_huge_or_clear_bad(pmd_t *pmd)
-{
-	pmd_t pmdval = pmdp_get_lockless(pmd);
-	/*
-	 * !pmd_present() checks for pmd migration entries
-	 *
-	 * The complete check uses is_pmd_migration_entry() in linux/swapops.h
-	 * But using that requires moving current function and pmd_trans_unstable()
-	 * to linux/swapops.h to resolve dependency, which is too much code move.
-	 *
-	 * !pmd_present() is equivalent to is_pmd_migration_entry() currently,
-	 * because !pmd_present() pages can only be under migration not swapped
-	 * out.
-	 *
-	 * pmd_none() is preserved for future condition checks on pmd migration
-	 * entries and not confusing with this function name, although it is
-	 * redundant with !pmd_present().
-	 */
-	if (pmd_none(pmdval) || pmd_trans_huge(pmdval) ||
-		(IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION) && !pmd_present(pmdval)))
-		return 1;
-	if (unlikely(pmd_bad(pmdval))) {
-		pmd_clear_bad(pmd);
-		return 1;
-	}
 	return 0;
 }
 
-/*
- * This is a noop if Transparent Hugepage Support is not built into
- * the kernel. Otherwise it is equivalent to
- * pmd_none_or_trans_huge_or_clear_bad(), and shall only be called in
- * places that already verified the pmd is not none and they want to
- * walk ptes while holding the mmap sem in read mode (write mode don't
- * need this). If THP is not enabled, the pmd can't go away under the
- * code even if MADV_DONTNEED runs, but if THP is enabled we need to
- * run a pmd_trans_unstable before walking the ptes after
- * split_huge_pmd returns (because it may have run when the pmd become
- * null, but then a page fault can map in a THP and not a regular page).
- */
-static inline int pmd_trans_unstable(pmd_t *pmd)
-{
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	return pmd_none_or_trans_huge_or_clear_bad(pmd);
-#else
-	return 0;
-#endif
-}
-
-/*
- * the ordering of these checks is important for pmds with _page_devmap set.
- * if we check pmd_trans_unstable() first we will trip the bad_pmd() check
- * inside of pmd_none_or_trans_huge_or_clear_bad(). this will end up correctly
- * returning 1 but not before it spams dmesg with the pmd_clear_bad() output.
- */
-static inline int pmd_devmap_trans_unstable(pmd_t *pmd)
-{
-	return pmd_devmap(*pmd) || pmd_trans_unstable(pmd);
-}
-
 #ifndef CONFIG_NUMA_BALANCING
 /*
  * Technically a PTE can be PROTNONE even when not doing NUMA balancing but
--- a/mm/khugepaged.c~mm-pgtable-delete-pmd_trans_unstable-and-friends
+++ a/mm/khugepaged.c
@@ -944,10 +944,6 @@ static int hugepage_vma_revalidate(struc
 	return SCAN_SUCCEED;
 }
 
-/*
- * See pmd_trans_unstable() for how the result may change out from
- * underneath us, even if we hold mmap_lock in read.
- */
 static int find_pmd_or_thp_or_none(struct mm_struct *mm,
 				   unsigned long address,
 				   pmd_t **pmd)
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

