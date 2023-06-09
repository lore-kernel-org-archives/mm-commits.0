Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB6BC7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 20:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjFIUKr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 16:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjFIUKq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 16:10:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC261B9
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 13:10:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A2EC65B7B
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 20:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6FFC433EF;
        Fri,  9 Jun 2023 20:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686341440;
        bh=x+bLAf1zArDSbgl52RT27MHUuqoWikU4vBxGizj+6Tc=;
        h=Date:To:From:Subject:From;
        b=d+5qYCsRwmFzXZS9+LGEzAiU/jhrPStR1cz69pL2/ZxhzcXe69PsCZon07617uRCQ
         VVeDpG04G5MzdHMwlnoZJOR0CEC/UIYUMCqSLYZ7ZMBH+mJ7YNJ4vuTEf0cXZW+ohu
         vSF6yidBFvWwmixsNCuqnADCcLDgEzD5wR7lnVeM=
Date:   Fri, 09 Jun 2023 13:10:39 -0700
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
Subject: + mm-use-pmdp_get_lockless-without-surplus-barrier.patch added to mm-unstable branch
Message-Id: <20230609201040.6F6FFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use pmdp_get_lockless() without surplus barrier()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-pmdp_get_lockless-without-surplus-barrier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-pmdp_get_lockless-without-surplus-barrier.patch

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
Subject: mm: use pmdp_get_lockless() without surplus barrier()
Date: Thu, 8 Jun 2023 18:06:53 -0700 (PDT)

Patch series "mm: allow pte_offset_map[_lock]() to fail", v2.

What is it all about?  Some mmap_lock avoidance i.e.  latency reduction. 
Initially just for the case of collapsing shmem or file pages to THPs; but
likely to be relied upon later in other contexts e.g.  freeing of empty
page tables (but that's not work I'm doing).  mmap_write_lock avoidance
when collapsing to anon THPs?  Perhaps, but again that's not work I've
done: a quick attempt was not as easy as the shmem/file case.

I would much prefer not to have to make these small but wide-ranging
changes for such a niche case; but failed to find another way, and have
heard that shmem MADV_COLLAPSE's usefulness is being limited by that
mmap_write_lock it currently requires.

These changes (though of course not these exact patches) have been in
Google's data centre kernel for three years now: we do rely upon them.

What is this preparatory series about?

The current mmap locking will not be enough to guard against that tricky
transition between pmd entry pointing to page table, and empty pmd entry,
and pmd entry pointing to huge page: pte_offset_map() will have to
validate the pmd entry for itself, returning NULL if no page table is
there.  What to do about that varies: sometimes nearby error handling
indicates just to skip it; but in many cases an ACTION_AGAIN or "goto
again" is appropriate (and if that risks an infinite loop, then there must
have been an oops, or pfn 0 mistaken for page table, before).

Given the likely extension to freeing empty page tables, I have not
limited this set of changes to a THP config; and it has been easier, and
sets a better example, if each site is given appropriate handling: even
where deeper study might prove that failure could only happen if the pmd
table were corrupted.

Several of the patches are, or include, cleanup on the way; and by the
end, pmd_trans_unstable() and suchlike are deleted: pte_offset_map() and
pte_offset_map_lock() then handle those original races and more.  Most
uses of pte_lockptr() are deprecated, with pte_offset_map_nolock() taking
its place.


This patch (of 32):

Use pmdp_get_lockless() in preference to READ_ONCE(*pmdp), to get a more
reliable result with PAE (or READ_ONCE as before without PAE); and remove
the unnecessary extra barrier()s which got left behind in its callers.

HOWEVER: Note the small print in linux/pgtable.h, where it was designed
specifically for fast GUP, and depends on interrupts being disabled for
its full guarantee: most callers which have been added (here and before)
do NOT have interrupts disabled, so there is still some need for caution.

Link: https://lkml.kernel.org/r/f35279a9-9ac0-de22-d245-591afbfb4dc@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Yu Zhao <yuzhao@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
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
Cc: Zack Rusin <zackr@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c        |   10 +---------
 include/linux/pgtable.h |   17 -----------------
 mm/gup.c                |    6 +-----
 mm/hmm.c                |    2 +-
 mm/khugepaged.c         |    5 -----
 mm/ksm.c                |    3 +--
 mm/memory.c             |   14 ++------------
 mm/mprotect.c           |    5 -----
 mm/page_vma_mapped.c    |    2 +-
 9 files changed, 7 insertions(+), 57 deletions(-)

--- a/fs/userfaultfd.c~mm-use-pmdp_get_lockless-without-surplus-barrier
+++ a/fs/userfaultfd.c
@@ -349,15 +349,7 @@ static inline bool userfaultfd_must_wait
 	if (!pud_present(*pud))
 		goto out;
 	pmd = pmd_offset(pud, address);
-	/*
-	 * READ_ONCE must function as a barrier with narrower scope
-	 * and it must be equivalent to:
-	 *	_pmd = *pmd; barrier();
-	 *
-	 * This is to deal with the instability (as in
-	 * pmd_trans_unstable) of the pmd.
-	 */
-	_pmd = READ_ONCE(*pmd);
+	_pmd = pmdp_get_lockless(pmd);
 	if (pmd_none(_pmd))
 		goto out;
 
--- a/include/linux/pgtable.h~mm-use-pmdp_get_lockless-without-surplus-barrier
+++ a/include/linux/pgtable.h
@@ -1345,23 +1345,6 @@ static inline int pmd_none_or_trans_huge
 {
 	pmd_t pmdval = pmdp_get_lockless(pmd);
 	/*
-	 * The barrier will stabilize the pmdval in a register or on
-	 * the stack so that it will stop changing under the code.
-	 *
-	 * When CONFIG_TRANSPARENT_HUGEPAGE=y on x86 32bit PAE,
-	 * pmdp_get_lockless is allowed to return a not atomic pmdval
-	 * (for example pointing to an hugepage that has never been
-	 * mapped in the pmd). The below checks will only care about
-	 * the low part of the pmd with 32bit PAE x86 anyway, with the
-	 * exception of pmd_none(). So the important thing is that if
-	 * the low part of the pmd is found null, the high part will
-	 * be also null or the pmd_none() check below would be
-	 * confused.
-	 */
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	barrier();
-#endif
-	/*
 	 * !pmd_present() checks for pmd migration entries
 	 *
 	 * The complete check uses is_pmd_migration_entry() in linux/swapops.h
--- a/mm/gup.c~mm-use-pmdp_get_lockless-without-surplus-barrier
+++ a/mm/gup.c
@@ -654,11 +654,7 @@ static struct page *follow_pmd_mask(stru
 	struct mm_struct *mm = vma->vm_mm;
 
 	pmd = pmd_offset(pudp, address);
-	/*
-	 * The READ_ONCE() will stabilize the pmdval in a register or
-	 * on the stack so that it will stop changing under the code.
-	 */
-	pmdval = READ_ONCE(*pmd);
+	pmdval = pmdp_get_lockless(pmd);
 	if (pmd_none(pmdval))
 		return no_page_table(vma, flags);
 	if (!pmd_present(pmdval))
--- a/mm/hmm.c~mm-use-pmdp_get_lockless-without-surplus-barrier
+++ a/mm/hmm.c
@@ -332,7 +332,7 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 	pmd_t pmd;
 
 again:
-	pmd = READ_ONCE(*pmdp);
+	pmd = pmdp_get_lockless(pmdp);
 	if (pmd_none(pmd))
 		return hmm_vma_walk_hole(start, end, -1, walk);
 
--- a/mm/khugepaged.c~mm-use-pmdp_get_lockless-without-surplus-barrier
+++ a/mm/khugepaged.c
@@ -959,11 +959,6 @@ static int find_pmd_or_thp_or_none(struc
 		return SCAN_PMD_NULL;
 
 	pmde = pmdp_get_lockless(*pmd);
-
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	/* See comments in pmd_none_or_trans_huge_or_clear_bad() */
-	barrier();
-#endif
 	if (pmd_none(pmde))
 		return SCAN_PMD_NONE;
 	if (!pmd_present(pmde))
--- a/mm/ksm.c~mm-use-pmdp_get_lockless-without-surplus-barrier
+++ a/mm/ksm.c
@@ -1194,8 +1194,7 @@ static int replace_page(struct vm_area_s
 	 * without holding anon_vma lock for write.  So when looking for a
 	 * genuine pmde (in which to find pte), test present and !THP together.
 	 */
-	pmde = *pmd;
-	barrier();
+	pmde = pmdp_get_lockless(pmd);
 	if (!pmd_present(pmde) || pmd_trans_huge(pmde))
 		goto out;
 
--- a/mm/memory.c~mm-use-pmdp_get_lockless-without-surplus-barrier
+++ a/mm/memory.c
@@ -4924,18 +4924,9 @@ static vm_fault_t handle_pte_fault(struc
 		 * So now it's safe to run pte_offset_map().
 		 */
 		vmf->pte = pte_offset_map(vmf->pmd, vmf->address);
-		vmf->orig_pte = *vmf->pte;
+		vmf->orig_pte = ptep_get_lockless(vmf->pte);
 		vmf->flags |= FAULT_FLAG_ORIG_PTE_VALID;
 
-		/*
-		 * some architectures can have larger ptes than wordsize,
-		 * e.g.ppc44x-defconfig has CONFIG_PTE_64BIT=y and
-		 * CONFIG_32BIT=y, so READ_ONCE cannot guarantee atomic
-		 * accesses.  The code below just needs a consistent view
-		 * for the ifs and we later double check anyway with the
-		 * ptl lock held. So here a barrier will do.
-		 */
-		barrier();
 		if (pte_none(vmf->orig_pte)) {
 			pte_unmap(vmf->pte);
 			vmf->pte = NULL;
@@ -5059,9 +5050,8 @@ retry_pud:
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
 	} else {
-		vmf.orig_pmd = *vmf.pmd;
+		vmf.orig_pmd = pmdp_get_lockless(vmf.pmd);
 
-		barrier();
 		if (unlikely(is_swap_pmd(vmf.orig_pmd))) {
 			VM_BUG_ON(thp_migration_supported() &&
 					  !is_pmd_migration_entry(vmf.orig_pmd));
--- a/mm/mprotect.c~mm-use-pmdp_get_lockless-without-surplus-barrier
+++ a/mm/mprotect.c
@@ -309,11 +309,6 @@ static inline int pmd_none_or_clear_bad_
 {
 	pmd_t pmdval = pmdp_get_lockless(pmd);
 
-	/* See pmd_none_or_trans_huge_or_clear_bad for info on barrier */
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	barrier();
-#endif
-
 	if (pmd_none(pmdval))
 		return 1;
 	if (pmd_trans_huge(pmdval))
--- a/mm/page_vma_mapped.c~mm-use-pmdp_get_lockless-without-surplus-barrier
+++ a/mm/page_vma_mapped.c
@@ -210,7 +210,7 @@ restart:
 		 * compiler and used as a stale value after we've observed a
 		 * subsequent update.
 		 */
-		pmde = READ_ONCE(*pvmw->pmd);
+		pmde = pmdp_get_lockless(pvmw->pmd);
 
 		if (pmd_trans_huge(pmde) || is_pmd_migration_entry(pmde) ||
 		    (pmd_present(pmde) && pmd_devmap(pmde))) {
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

