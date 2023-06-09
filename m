Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15DD8C7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 20:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjFIUK4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 16:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjFIUKs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 16:10:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0543F3A85
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 13:10:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C5BF65B61
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 20:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6230C433D2;
        Fri,  9 Jun 2023 20:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686341445;
        bh=hkJo6/3RPmSkjjP/lcUXGOdCu8ADriYt2l7xCjGkn9M=;
        h=Date:To:From:Subject:From;
        b=a0AF2x7K1vrRmlXUxK6R5vOS350O6qeMzXEQDcVXQWXR4t/HZ4s26lA2E/nfnzvNM
         uf/ngqAB97k3+Ne0BHeviuuTktVZu/VWdkBNBRjxPjNOBXG8ggUKQLymfIOmldnout
         dJcl4pQ5MROkhZHF454J44sWVeLzW3zS+zi4Ud7Q=
Date:   Fri, 09 Jun 2023 13:10:44 -0700
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
Subject: + mm-migrate-remove-cruft-from-migration_entry_waits.patch added to mm-unstable branch
Message-Id: <20230609201044.D6230C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: remove cruft from migration_entry_wait()s
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-remove-cruft-from-migration_entry_waits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-remove-cruft-from-migration_entry_waits.patch

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
Subject: mm/migrate: remove cruft from migration_entry_wait()s
Date: Thu, 8 Jun 2023 18:08:20 -0700 (PDT)

migration_entry_wait_on_locked() does not need to take a mapped pte
pointer, its callers can do the unmap first.  Annotate it with
__releases(ptl) to reduce sparse warnings.

Fold __migration_entry_wait_huge() into migration_entry_wait_huge().  Fold
__migration_entry_wait() into migration_entry_wait(), preferring the
tighter pte_offset_map_lock() to pte_offset_map() and pte_lockptr().

Link: https://lkml.kernel.org/r/b0e2a532-cdf2-561b-e999-f3b13b8d6d3@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
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

 include/linux/migrate.h |    4 ++--
 include/linux/swapops.h |   17 +++--------------
 mm/filemap.c            |   13 ++++---------
 mm/migrate.c            |   37 +++++++++++++------------------------
 4 files changed, 22 insertions(+), 49 deletions(-)

--- a/include/linux/migrate.h~mm-migrate-remove-cruft-from-migration_entry_waits
+++ a/include/linux/migrate.h
@@ -75,8 +75,8 @@ bool isolate_movable_page(struct page *p
 
 int migrate_huge_page_move_mapping(struct address_space *mapping,
 		struct folio *dst, struct folio *src);
-void migration_entry_wait_on_locked(swp_entry_t entry, pte_t *ptep,
-				spinlock_t *ptl);
+void migration_entry_wait_on_locked(swp_entry_t entry, spinlock_t *ptl)
+		__releases(ptl);
 void folio_migrate_flags(struct folio *newfolio, struct folio *folio);
 void folio_migrate_copy(struct folio *newfolio, struct folio *folio);
 int folio_migrate_mapping(struct address_space *mapping,
--- a/include/linux/swapops.h~mm-migrate-remove-cruft-from-migration_entry_waits
+++ a/include/linux/swapops.h
@@ -332,15 +332,9 @@ static inline bool is_migration_entry_di
 	return false;
 }
 
-extern void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
-					spinlock_t *ptl);
 extern void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					unsigned long address);
-#ifdef CONFIG_HUGETLB_PAGE
-extern void __migration_entry_wait_huge(struct vm_area_struct *vma,
-					pte_t *ptep, spinlock_t *ptl);
 extern void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *pte);
-#endif	/* CONFIG_HUGETLB_PAGE */
 #else  /* CONFIG_MIGRATION */
 static inline swp_entry_t make_readable_migration_entry(pgoff_t offset)
 {
@@ -362,15 +356,10 @@ static inline int is_migration_entry(swp
 	return 0;
 }
 
-static inline void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
-					spinlock_t *ptl) { }
 static inline void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
-					 unsigned long address) { }
-#ifdef CONFIG_HUGETLB_PAGE
-static inline void __migration_entry_wait_huge(struct vm_area_struct *vma,
-					       pte_t *ptep, spinlock_t *ptl) { }
-static inline void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *pte) { }
-#endif	/* CONFIG_HUGETLB_PAGE */
+					unsigned long address) { }
+static inline void migration_entry_wait_huge(struct vm_area_struct *vma,
+					pte_t *pte) { }
 static inline int is_writable_migration_entry(swp_entry_t entry)
 {
 	return 0;
--- a/mm/filemap.c~mm-migrate-remove-cruft-from-migration_entry_waits
+++ a/mm/filemap.c
@@ -1362,8 +1362,6 @@ repeat:
 /**
  * migration_entry_wait_on_locked - Wait for a migration entry to be removed
  * @entry: migration swap entry.
- * @ptep: mapped pte pointer. Will return with the ptep unmapped. Only required
- *        for pte entries, pass NULL for pmd entries.
  * @ptl: already locked ptl. This function will drop the lock.
  *
  * Wait for a migration entry referencing the given page to be removed. This is
@@ -1372,13 +1370,13 @@ repeat:
  * should be called while holding the ptl for the migration entry referencing
  * the page.
  *
- * Returns after unmapping and unlocking the pte/ptl with pte_unmap_unlock().
+ * Returns after unlocking the ptl.
  *
  * This follows the same logic as folio_wait_bit_common() so see the comments
  * there.
  */
-void migration_entry_wait_on_locked(swp_entry_t entry, pte_t *ptep,
-				spinlock_t *ptl)
+void migration_entry_wait_on_locked(swp_entry_t entry, spinlock_t *ptl)
+	__releases(ptl)
 {
 	struct wait_page_queue wait_page;
 	wait_queue_entry_t *wait = &wait_page.wait;
@@ -1412,10 +1410,7 @@ void migration_entry_wait_on_locked(swp_
 	 * a valid reference to the page, and it must take the ptl to remove the
 	 * migration entry. So the page is valid until the ptl is dropped.
 	 */
-	if (ptep)
-		pte_unmap_unlock(ptep, ptl);
-	else
-		spin_unlock(ptl);
+	spin_unlock(ptl);
 
 	for (;;) {
 		unsigned int flags;
--- a/mm/migrate.c~mm-migrate-remove-cruft-from-migration_entry_waits
+++ a/mm/migrate.c
@@ -296,14 +296,18 @@ void remove_migration_ptes(struct folio
  * get to the page and wait until migration is finished.
  * When we return from this function the fault will be retried.
  */
-void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
-				spinlock_t *ptl)
+void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
+			  unsigned long address)
 {
+	spinlock_t *ptl;
+	pte_t *ptep;
 	pte_t pte;
 	swp_entry_t entry;
 
-	spin_lock(ptl);
+	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
 	pte = *ptep;
+	pte_unmap(ptep);
+
 	if (!is_swap_pte(pte))
 		goto out;
 
@@ -311,18 +315,10 @@ void __migration_entry_wait(struct mm_st
 	if (!is_migration_entry(entry))
 		goto out;
 
-	migration_entry_wait_on_locked(entry, ptep, ptl);
+	migration_entry_wait_on_locked(entry, ptl);
 	return;
 out:
-	pte_unmap_unlock(ptep, ptl);
-}
-
-void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
-				unsigned long address)
-{
-	spinlock_t *ptl = pte_lockptr(mm, pmd);
-	pte_t *ptep = pte_offset_map(pmd, address);
-	__migration_entry_wait(mm, ptep, ptl);
+	spin_unlock(ptl);
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
@@ -332,9 +328,9 @@ void migration_entry_wait(struct mm_stru
  *
  * This function will release the vma lock before returning.
  */
-void __migration_entry_wait_huge(struct vm_area_struct *vma,
-				 pte_t *ptep, spinlock_t *ptl)
+void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *ptep)
 {
+	spinlock_t *ptl = huge_pte_lockptr(hstate_vma(vma), vma->vm_mm, ptep);
 	pte_t pte;
 
 	hugetlb_vma_assert_locked(vma);
@@ -352,16 +348,9 @@ void __migration_entry_wait_huge(struct
 		 * lock release in migration_entry_wait_on_locked().
 		 */
 		hugetlb_vma_unlock_read(vma);
-		migration_entry_wait_on_locked(pte_to_swp_entry(pte), NULL, ptl);
+		migration_entry_wait_on_locked(pte_to_swp_entry(pte), ptl);
 	}
 }
-
-void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *pte)
-{
-	spinlock_t *ptl = huge_pte_lockptr(hstate_vma(vma), vma->vm_mm, pte);
-
-	__migration_entry_wait_huge(vma, pte, ptl);
-}
 #endif
 
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
@@ -372,7 +361,7 @@ void pmd_migration_entry_wait(struct mm_
 	ptl = pmd_lock(mm, pmd);
 	if (!is_pmd_migration_entry(*pmd))
 		goto unlock;
-	migration_entry_wait_on_locked(pmd_to_swp_entry(*pmd), NULL, ptl);
+	migration_entry_wait_on_locked(pmd_to_swp_entry(*pmd), ptl);
 	return;
 unlock:
 	spin_unlock(ptl);
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

