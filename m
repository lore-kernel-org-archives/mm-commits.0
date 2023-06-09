Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DDFEC7EE45
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 20:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbjFIULv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 16:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbjFIULs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 16:11:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932AE1A1
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 13:11:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D3C665B4B
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 20:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DDBC433D2;
        Fri,  9 Jun 2023 20:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686341505;
        bh=vU8D9dmBWk//eCjXTX0LIqeDNob9v9gLbONhC3sWSAg=;
        h=Date:To:From:Subject:From;
        b=zGsE4SjZoGoDVDhpEtaqX/iJFkZRW+FfjLITbh7832uvu4X5tawC/+4IoEV18+kQl
         5baOcJqrn0oB65DBd6T4pqehOWoxK7PCvPpgtxE52mE0XBKcxxH9IeqLox3569dMk2
         IdhrSanBszHsttYBDS66in0r9/l7nKae9eF2RCUg=
Date:   Fri, 09 Jun 2023 13:11:44 -0700
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
Subject: + mm-migrate_device-allow-pte_offset_map_lock-to-fail.patch added to mm-unstable branch
Message-Id: <20230609201145.61DDBC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate_device: allow pte_offset_map_lock() to fail
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate_device-allow-pte_offset_map_lock-to-fail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-allow-pte_offset_map_lock-to-fail.patch

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
Subject: mm/migrate_device: allow pte_offset_map_lock() to fail
Date: Thu, 8 Jun 2023 18:38:17 -0700 (PDT)

migrate_vma_collect_pmd(): remove the pmd_trans_unstable() handling after
splitting huge zero pmd, and the pmd_none() handling after successfully
splitting huge page: those are now managed inside pte_offset_map_lock(),
and by "goto again" when it fails.

But the skip after unsuccessful split_huge_page() must stay: it avoids an
endless loop.  The skip when pmd_bad()?  Remove that: it will be treated
as a hole rather than a skip once cleared by pte_offset_map_lock(), but
with different timing that would be so anyway; and it's arguably best to
leave the pmd_bad() handling centralized there.

migrate_vma_insert_page(): remove comment on the old pte_offset_map() and
old locking limitations; remove the pmd_trans_unstable() check and just
proceed to pte_offset_map_lock(), aborting when it fails (page has been
charged to memcg, but as in other cases, it's uncharged when freed).

Link: https://lkml.kernel.org/r/1131be62-2e84-da2f-8f45-807b2cbeeec5@google.com
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

 mm/migrate_device.c |   31 ++++---------------------------
 1 file changed, 4 insertions(+), 27 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-allow-pte_offset_map_lock-to-fail
+++ a/mm/migrate_device.c
@@ -83,9 +83,6 @@ again:
 		if (is_huge_zero_page(page)) {
 			spin_unlock(ptl);
 			split_huge_pmd(vma, pmdp, addr);
-			if (pmd_trans_unstable(pmdp))
-				return migrate_vma_collect_skip(start, end,
-								walk);
 		} else {
 			int ret;
 
@@ -100,16 +97,12 @@ again:
 			if (ret)
 				return migrate_vma_collect_skip(start, end,
 								walk);
-			if (pmd_none(*pmdp))
-				return migrate_vma_collect_hole(start, end, -1,
-								walk);
 		}
 	}
 
-	if (unlikely(pmd_bad(*pmdp)))
-		return migrate_vma_collect_skip(start, end, walk);
-
 	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+	if (!ptep)
+		goto again;
 	arch_enter_lazy_mmu_mode();
 
 	for (; addr < end; addr += PAGE_SIZE, ptep++) {
@@ -595,27 +588,10 @@ static void migrate_vma_insert_page(stru
 	pmdp = pmd_alloc(mm, pudp, addr);
 	if (!pmdp)
 		goto abort;
-
 	if (pmd_trans_huge(*pmdp) || pmd_devmap(*pmdp))
 		goto abort;
-
-	/*
-	 * Use pte_alloc() instead of pte_alloc_map().  We can't run
-	 * pte_offset_map() on pmds where a huge pmd might be created
-	 * from a different thread.
-	 *
-	 * pte_alloc_map() is safe to use under mmap_write_lock(mm) or when
-	 * parallel threads are excluded by other means.
-	 *
-	 * Here we only have mmap_read_lock(mm).
-	 */
 	if (pte_alloc(mm, pmdp))
 		goto abort;
-
-	/* See the comment in pte_alloc_one_map() */
-	if (unlikely(pmd_trans_unstable(pmdp)))
-		goto abort;
-
 	if (unlikely(anon_vma_prepare(vma)))
 		goto abort;
 	if (mem_cgroup_charge(page_folio(page), vma->vm_mm, GFP_KERNEL))
@@ -650,7 +626,8 @@ static void migrate_vma_insert_page(stru
 	}
 
 	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
-
+	if (!ptep)
+		goto abort;
 	if (check_stable_address_space(mm))
 		goto unlock_abort;
 
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

