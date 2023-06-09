Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBCC5C7EE37
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 20:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjFIUK5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 16:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbjFIUKz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 16:10:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6583C3A99
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 13:10:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1E5765B58
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 20:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB5DC433EF;
        Fri,  9 Jun 2023 20:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686341450;
        bh=rotOoM/zTG/f5DRjCZ2aXbK6tUtaK2OwEMX9LYo1mOE=;
        h=Date:To:From:Subject:From;
        b=gy88JMyN2kJBe07HZhJr7eyqd4I/3wqHJqqPHwlolMUjOaQ2J/EFYGBCejsGKLhhm
         WB7OLdw/nPsnrG1x+fJbh0pLOqyv2KmfZQ73Sd4yEJ7ybMi/gya7S/rrqQggEo+5rg
         Gky+3LXlmH1nE7WwBJXSTxD9BAn3kVkCMmxcypTw=
Date:   Fri, 09 Jun 2023 13:10:49 -0700
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
Subject: + mm-pgtable-allow-pte_offset_map-to-fail.patch added to mm-unstable branch
Message-Id: <20230609201050.3BB5DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/pgtable: allow pte_offset_map[_lock]() to fail
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pgtable-allow-pte_offset_map-to-fail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-allow-pte_offset_map-to-fail.patch

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
Subject: mm/pgtable: allow pte_offset_map[_lock]() to fail
Date: Thu, 8 Jun 2023 18:10:32 -0700 (PDT)

Make pte_offset_map() a wrapper for __pte_offset_map() (optionally outputs
pmdval), pte_offset_map_lock() a sparse __cond_lock wrapper for
__pte_offset_map_lock(): those __funcs added in mm/pgtable-generic.c.

__pte_offset_map() do pmdval validation (including pmd_clear_bad() when
pmd_bad()), returning NULL if pmdval is not for a page table. 
__pte_offset_map_lock() verify pmdval unchanged after getting the lock,
trying again if it changed.

No #ifdef CONFIG_TRANSPARENT_HUGEPAGE around them: that could be done to
cover the imminent case, but we expect to generalize it later, and it
makes a mess of where to do the pmd_bad() clearing.

Add pte_offset_map_nolock(): outputs ptl like pte_offset_map_lock(),
without actually taking the lock.  This will be preferred to open uses of
pte_lockptr(), because (when split ptlock is in page table's struct page)
it points to the right lock for the returned pte pointer, even if *pmd
gets changed racily afterwards.

Update corresponding Documentation.

Do not add the anticipated rcu_read_lock() and rcu_read_unlock()s yet:
they have to wait until all architectures are balancing pte_offset_map()s
with pte_unmap()s (as in the arch series posted earlier).  But comment
where they will go, so that it's easy to add them for experiments.  And
only when those are in place can transient racy failure cases be enabled. 
Add more safety for the PAE mismatched pmd_low pmd_high case at that time.

Link: https://lkml.kernel.org/r/2929bfd-9893-a374-e463-4c3127ff9b9d@google.com
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

 Documentation/mm/split_page_table_lock.rst |   17 +++--
 include/linux/mm.h                         |   27 ++++++---
 include/linux/pgtable.h                    |   22 +++++--
 mm/pgtable-generic.c                       |   56 +++++++++++++++++++
 4 files changed, 101 insertions(+), 21 deletions(-)

--- a/Documentation/mm/split_page_table_lock.rst~mm-pgtable-allow-pte_offset_map-to-fail
+++ a/Documentation/mm/split_page_table_lock.rst
@@ -14,15 +14,20 @@ tables. Access to higher level tables pr
 There are helpers to lock/unlock a table and other accessor functions:
 
  - pte_offset_map_lock()
-	maps pte and takes PTE table lock, returns pointer to the taken
-	lock;
+	maps PTE and takes PTE table lock, returns pointer to PTE with
+	pointer to its PTE table lock, or returns NULL if no PTE table;
+ - pte_offset_map_nolock()
+	maps PTE, returns pointer to PTE with pointer to its PTE table
+	lock (not taken), or returns NULL if no PTE table;
+ - pte_offset_map()
+	maps PTE, returns pointer to PTE, or returns NULL if no PTE table;
+ - pte_unmap()
+	unmaps PTE table;
  - pte_unmap_unlock()
 	unlocks and unmaps PTE table;
  - pte_alloc_map_lock()
-	allocates PTE table if needed and take the lock, returns pointer
-	to taken lock or NULL if allocation failed;
- - pte_lockptr()
-	returns pointer to PTE table lock;
+	allocates PTE table if needed and takes its lock, returns pointer to
+	PTE with pointer to its lock, or returns NULL if allocation failed;
  - pmd_lock()
 	takes PMD table lock, returns pointer to taken lock;
  - pmd_lockptr()
--- a/include/linux/mm.h~mm-pgtable-allow-pte_offset_map-to-fail
+++ a/include/linux/mm.h
@@ -2823,14 +2823,25 @@ static inline void pgtable_pte_page_dtor
 	dec_lruvec_page_state(page, NR_PAGETABLE);
 }
 
-#define pte_offset_map_lock(mm, pmd, address, ptlp)	\
-({							\
-	spinlock_t *__ptl = pte_lockptr(mm, pmd);	\
-	pte_t *__pte = pte_offset_map(pmd, address);	\
-	*(ptlp) = __ptl;				\
-	spin_lock(__ptl);				\
-	__pte;						\
-})
+pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp);
+static inline pte_t *pte_offset_map(pmd_t *pmd, unsigned long addr)
+{
+	return __pte_offset_map(pmd, addr, NULL);
+}
+
+pte_t *__pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
+			unsigned long addr, spinlock_t **ptlp);
+static inline pte_t *pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
+			unsigned long addr, spinlock_t **ptlp)
+{
+	pte_t *pte;
+
+	__cond_lock(*ptlp, pte = __pte_offset_map_lock(mm, pmd, addr, ptlp));
+	return pte;
+}
+
+pte_t *pte_offset_map_nolock(struct mm_struct *mm, pmd_t *pmd,
+			unsigned long addr, spinlock_t **ptlp);
 
 #define pte_unmap_unlock(pte, ptl)	do {		\
 	spin_unlock(ptl);				\
--- a/include/linux/pgtable.h~mm-pgtable-allow-pte_offset_map-to-fail
+++ a/include/linux/pgtable.h
@@ -94,14 +94,22 @@ static inline pte_t *pte_offset_kernel(p
 #define pte_offset_kernel pte_offset_kernel
 #endif
 
-#if defined(CONFIG_HIGHPTE)
-#define pte_offset_map(dir, address)				\
-	((pte_t *)kmap_local_page(pmd_page(*(dir))) +		\
-	 pte_index((address)))
-#define pte_unmap(pte) kunmap_local((pte))
+#ifdef CONFIG_HIGHPTE
+#define __pte_map(pmd, address) \
+	((pte_t *)kmap_local_page(pmd_page(*(pmd))) + pte_index((address)))
+#define pte_unmap(pte)	do {	\
+	kunmap_local((pte));	\
+	/* rcu_read_unlock() to be added later */	\
+} while (0)
 #else
-#define pte_offset_map(dir, address)	pte_offset_kernel((dir), (address))
-#define pte_unmap(pte) ((void)(pte))	/* NOP */
+static inline pte_t *__pte_map(pmd_t *pmd, unsigned long address)
+{
+	return pte_offset_kernel(pmd, address);
+}
+static inline void pte_unmap(pte_t *pte)
+{
+	/* rcu_read_unlock() to be added later */
+}
 #endif
 
 /* Find an entry in the second-level page table.. */
--- a/mm/pgtable-generic.c~mm-pgtable-allow-pte_offset_map-to-fail
+++ a/mm/pgtable-generic.c
@@ -10,6 +10,8 @@
 #include <linux/pagemap.h>
 #include <linux/hugetlb.h>
 #include <linux/pgtable.h>
+#include <linux/swap.h>
+#include <linux/swapops.h>
 #include <linux/mm_inline.h>
 #include <asm/tlb.h>
 
@@ -229,3 +231,57 @@ pmd_t pmdp_collapse_flush(struct vm_area
 }
 #endif
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
+pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
+{
+	pmd_t pmdval;
+
+	/* rcu_read_lock() to be added later */
+	pmdval = pmdp_get_lockless(pmd);
+	if (pmdvalp)
+		*pmdvalp = pmdval;
+	if (unlikely(pmd_none(pmdval) || is_pmd_migration_entry(pmdval)))
+		goto nomap;
+	if (unlikely(pmd_trans_huge(pmdval) || pmd_devmap(pmdval)))
+		goto nomap;
+	if (unlikely(pmd_bad(pmdval))) {
+		pmd_clear_bad(pmd);
+		goto nomap;
+	}
+	return __pte_map(&pmdval, addr);
+nomap:
+	/* rcu_read_unlock() to be added later */
+	return NULL;
+}
+
+pte_t *pte_offset_map_nolock(struct mm_struct *mm, pmd_t *pmd,
+			     unsigned long addr, spinlock_t **ptlp)
+{
+	pmd_t pmdval;
+	pte_t *pte;
+
+	pte = __pte_offset_map(pmd, addr, &pmdval);
+	if (likely(pte))
+		*ptlp = pte_lockptr(mm, &pmdval);
+	return pte;
+}
+
+pte_t *__pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
+			     unsigned long addr, spinlock_t **ptlp)
+{
+	spinlock_t *ptl;
+	pmd_t pmdval;
+	pte_t *pte;
+again:
+	pte = __pte_offset_map(pmd, addr, &pmdval);
+	if (unlikely(!pte))
+		return pte;
+	ptl = pte_lockptr(mm, &pmdval);
+	spin_lock(ptl);
+	if (likely(pmd_same(pmdval, pmdp_get_lockless(pmd)))) {
+		*ptlp = ptl;
+		return pte;
+	}
+	pte_unmap_unlock(pte, ptl);
+	goto again;
+}
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

