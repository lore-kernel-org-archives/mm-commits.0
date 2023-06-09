Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A27C7EE2E
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 20:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbjFIUML (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 16:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbjFIULy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 16:11:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BD4E47
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 13:11:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79D4465BB1
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 20:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9808C433EF;
        Fri,  9 Jun 2023 20:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686341511;
        bh=CinHWLpTdKjKuaZ0KTTivatTunUWVa5hHPAkKnCJJzE=;
        h=Date:To:From:Subject:From;
        b=z9WgSC/VmxyiKGD7wCg3rQMu5w7Yy34Q0JQEMuKDTw+UFWoOo9Eb0AURIRL6m2lo8
         V+qEbo4aAssZPch0yM7iotvF9krLl/ouwWk+n4DXSpK4OcK1dbctZpe9BuavAXuGrt
         2iFnkReGzdoXEkQbN5ZoTAygfskH4jDKbxQbVJMw=
Date:   Fri, 09 Jun 2023 13:11:51 -0700
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
Subject: + mm-khugepaged-allow-pte_offset_map-to-fail.patch added to mm-unstable branch
Message-Id: <20230609201151.C9808C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: allow pte_offset_map[_lock]() to fail
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-allow-pte_offset_map-to-fail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-allow-pte_offset_map-to-fail.patch

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
Subject: mm/khugepaged: allow pte_offset_map[_lock]() to fail
Date: Thu, 8 Jun 2023 18:42:40 -0700 (PDT)

__collapse_huge_page_swapin(): don't drop the map after every pte, it only
has to be dropped by do_swap_page(); give up if pte_offset_map() fails;
trace_mm_collapse_huge_page_swapin() at the end, with result; fix comment
on returned result; fix vmf.pgoff, though it's not used.

collapse_huge_page(): use pte_offset_map_lock() on the _pmd returned from
clearing; allow failure, but it should be impossible there. 
hpage_collapse_scan_pmd() and collapse_pte_mapped_thp() allow for
pte_offset_map_lock() failure.

Link: https://lkml.kernel.org/r/6513e85-d798-34ec-3762-7c24ffb9329@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
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
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zack Rusin <zackr@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   72 +++++++++++++++++++++++++++++++---------------
 1 file changed, 49 insertions(+), 23 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-allow-pte_offset_map-to-fail
+++ a/mm/khugepaged.c
@@ -991,9 +991,8 @@ static int check_pmd_still_valid(struct
  * Only done if hpage_collapse_scan_pmd believes it is worthwhile.
  *
  * Called and returns without pte mapped or spinlocks held.
- * Note that if false is returned, mmap_lock will be released.
+ * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
  */
-
 static int __collapse_huge_page_swapin(struct mm_struct *mm,
 				       struct vm_area_struct *vma,
 				       unsigned long haddr, pmd_t *pmd,
@@ -1002,23 +1001,35 @@ static int __collapse_huge_page_swapin(s
 	int swapped_in = 0;
 	vm_fault_t ret = 0;
 	unsigned long address, end = haddr + (HPAGE_PMD_NR * PAGE_SIZE);
+	int result;
+	pte_t *pte = NULL;
 
 	for (address = haddr; address < end; address += PAGE_SIZE) {
 		struct vm_fault vmf = {
 			.vma = vma,
 			.address = address,
-			.pgoff = linear_page_index(vma, haddr),
+			.pgoff = linear_page_index(vma, address),
 			.flags = FAULT_FLAG_ALLOW_RETRY,
 			.pmd = pmd,
 		};
 
-		vmf.pte = pte_offset_map(pmd, address);
-		vmf.orig_pte = *vmf.pte;
-		if (!is_swap_pte(vmf.orig_pte)) {
-			pte_unmap(vmf.pte);
-			continue;
+		if (!pte++) {
+			pte = pte_offset_map(pmd, address);
+			if (!pte) {
+				mmap_read_unlock(mm);
+				result = SCAN_PMD_NULL;
+				goto out;
+			}
 		}
+
+		vmf.orig_pte = *pte;
+		if (!is_swap_pte(vmf.orig_pte))
+			continue;
+
+		vmf.pte = pte;
 		ret = do_swap_page(&vmf);
+		/* Which unmaps pte (after perhaps re-checking the entry) */
+		pte = NULL;
 
 		/*
 		 * do_swap_page returns VM_FAULT_RETRY with released mmap_lock.
@@ -1027,24 +1038,29 @@ static int __collapse_huge_page_swapin(s
 		 * resulting in later failure.
 		 */
 		if (ret & VM_FAULT_RETRY) {
-			trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 0);
 			/* Likely, but not guaranteed, that page lock failed */
-			return SCAN_PAGE_LOCK;
+			result = SCAN_PAGE_LOCK;
+			goto out;
 		}
 		if (ret & VM_FAULT_ERROR) {
 			mmap_read_unlock(mm);
-			trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 0);
-			return SCAN_FAIL;
+			result = SCAN_FAIL;
+			goto out;
 		}
 		swapped_in++;
 	}
 
+	if (pte)
+		pte_unmap(pte);
+
 	/* Drain LRU add pagevec to remove extra pin on the swapped in pages */
 	if (swapped_in)
 		lru_add_drain();
 
-	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 1);
-	return SCAN_SUCCEED;
+	result = SCAN_SUCCEED;
+out:
+	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result);
+	return result;
 }
 
 static int alloc_charge_hpage(struct page **hpage, struct mm_struct *mm,
@@ -1144,9 +1160,6 @@ static int collapse_huge_page(struct mm_
 				address + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 
-	pte = pte_offset_map(pmd, address);
-	pte_ptl = pte_lockptr(mm, pmd);
-
 	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
 	/*
 	 * This removes any huge TLB entry from the CPU so we won't allow
@@ -1161,13 +1174,18 @@ static int collapse_huge_page(struct mm_
 	mmu_notifier_invalidate_range_end(&range);
 	tlb_remove_table_sync_one();
 
-	spin_lock(pte_ptl);
-	result =  __collapse_huge_page_isolate(vma, address, pte, cc,
-					       &compound_pagelist);
-	spin_unlock(pte_ptl);
+	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
+	if (pte) {
+		result = __collapse_huge_page_isolate(vma, address, pte, cc,
+						      &compound_pagelist);
+		spin_unlock(pte_ptl);
+	} else {
+		result = SCAN_PMD_NULL;
+	}
 
 	if (unlikely(result != SCAN_SUCCEED)) {
-		pte_unmap(pte);
+		if (pte)
+			pte_unmap(pte);
 		spin_lock(pmd_ptl);
 		BUG_ON(!pmd_none(*pmd));
 		/*
@@ -1251,6 +1269,11 @@ static int hpage_collapse_scan_pmd(struc
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
 	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
+	if (!pte) {
+		result = SCAN_PMD_NULL;
+		goto out;
+	}
+
 	for (_address = address, _pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, _address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
@@ -1620,8 +1643,10 @@ int collapse_pte_mapped_thp(struct mm_st
 	 * lockless_pages_from_mm() and the hardware page walker can access page
 	 * tables while all the high-level locks are held in write mode.
 	 */
-	start_pte = pte_offset_map_lock(mm, pmd, haddr, &ptl);
 	result = SCAN_FAIL;
+	start_pte = pte_offset_map_lock(mm, pmd, haddr, &ptl);
+	if (!start_pte)
+		goto drop_immap;
 
 	/* step 1: check all mapped PTEs are to the right huge page */
 	for (i = 0, addr = haddr, pte = start_pte;
@@ -1695,6 +1720,7 @@ drop_hpage:
 
 abort:
 	pte_unmap_unlock(start_pte, ptl);
+drop_immap:
 	i_mmap_unlock_write(vma->vm_file->f_mapping);
 	goto drop_hpage;
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

