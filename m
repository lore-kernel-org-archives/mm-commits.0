Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F1CC001B3
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjFSXXy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjFSXWT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:22:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076F7E74
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD35260FC1
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355A4C433C8;
        Mon, 19 Jun 2023 23:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216925;
        bh=kzD59f6PxG/jKsf53ImFVtzEDQ2mHl0JWX9Ct98ZAi8=;
        h=Date:To:From:Subject:From;
        b=T6Z7BSTkDTeNF3DYMuDOvw8VmtnXA39mlMR1doXuhushfHAsRnfhqw82oQhXzomZf
         EnDu0SlZ23L7lIX+ZR3HFEoq8Abb/xIjf3koDfE67pr5846PbfWm5iTPfpcOyfSNOj
         gU1DE5plU7S/YDZjchXDgsdhhoSKhuU3G2jCzjyM=
Date:   Mon, 19 Jun 2023 16:22:04 -0700
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
Subject: [merged mm-stable] mm-memory-handle_pte_fault-use-pte_offset_map_nolock.patch removed from -mm tree
Message-Id: <20230619232205.355A4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory: handle_pte_fault() use pte_offset_map_nolock()
has been removed from the -mm tree.  Its filename was
     mm-memory-handle_pte_fault-use-pte_offset_map_nolock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/memory: handle_pte_fault() use pte_offset_map_nolock()
Date: Thu, 8 Jun 2023 18:45:05 -0700 (PDT)

handle_pte_fault() use pte_offset_map_nolock() to get the vmf.ptl which
corresponds to vmf.pte, instead of pte_lockptr() being used later, when
there's a chance that the pmd entry might have changed, perhaps to none,
or to a huge pmd, with no split ptlock in its struct page.

Remove its pmd_devmap_trans_unstable() call: pte_offset_map_nolock() will
handle that case by failing.  Update the "morph" comment above, looking
forward to when shmem or file collapse to THP may not take mmap_lock for
write (or not at all).

do_numa_page() use the vmf->ptl from handle_pte_fault() at first, but
refresh it when refreshing vmf->pte.

do_swap_page()'s pte_unmap_same() (the thing that takes ptl to verify a
two-part PAE orig_pte) use the vmf->ptl from handle_pte_fault() too; but
do_swap_page() is also used by anon THP's __collapse_huge_page_swapin(),
so adjust that to set vmf->ptl by pte_offset_map_nolock().

Link: https://lkml.kernel.org/r/c1107654-3929-60ac-223e-6877cbb86065@google.com
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

 mm/khugepaged.c |    6 ++++--
 mm/memory.c     |   38 +++++++++++++-------------------------
 2 files changed, 17 insertions(+), 27 deletions(-)

--- a/mm/khugepaged.c~mm-memory-handle_pte_fault-use-pte_offset_map_nolock
+++ a/mm/khugepaged.c
@@ -1003,6 +1003,7 @@ static int __collapse_huge_page_swapin(s
 	unsigned long address, end = haddr + (HPAGE_PMD_NR * PAGE_SIZE);
 	int result;
 	pte_t *pte = NULL;
+	spinlock_t *ptl;
 
 	for (address = haddr; address < end; address += PAGE_SIZE) {
 		struct vm_fault vmf = {
@@ -1014,7 +1015,7 @@ static int __collapse_huge_page_swapin(s
 		};
 
 		if (!pte++) {
-			pte = pte_offset_map(pmd, address);
+			pte = pte_offset_map_nolock(mm, pmd, address, &ptl);
 			if (!pte) {
 				mmap_read_unlock(mm);
 				result = SCAN_PMD_NULL;
@@ -1022,11 +1023,12 @@ static int __collapse_huge_page_swapin(s
 			}
 		}
 
-		vmf.orig_pte = *pte;
+		vmf.orig_pte = ptep_get_lockless(pte);
 		if (!is_swap_pte(vmf.orig_pte))
 			continue;
 
 		vmf.pte = pte;
+		vmf.ptl = ptl;
 		ret = do_swap_page(&vmf);
 		/* Which unmaps pte (after perhaps re-checking the entry) */
 		pte = NULL;
--- a/mm/memory.c~mm-memory-handle_pte_fault-use-pte_offset_map_nolock
+++ a/mm/memory.c
@@ -2786,10 +2786,9 @@ static inline int pte_unmap_same(struct
 	int same = 1;
 #if defined(CONFIG_SMP) || defined(CONFIG_PREEMPTION)
 	if (sizeof(pte_t) > sizeof(unsigned long)) {
-		spinlock_t *ptl = pte_lockptr(vmf->vma->vm_mm, vmf->pmd);
-		spin_lock(ptl);
+		spin_lock(vmf->ptl);
 		same = pte_same(*vmf->pte, vmf->orig_pte);
-		spin_unlock(ptl);
+		spin_unlock(vmf->ptl);
 	}
 #endif
 	pte_unmap(vmf->pte);
@@ -4697,7 +4696,6 @@ static vm_fault_t do_numa_page(struct vm
 	 * validation through pte_unmap_same(). It's of NUMA type but
 	 * the pfn may be screwed if the read is non atomic.
 	 */
-	vmf->ptl = pte_lockptr(vma->vm_mm, vmf->pmd);
 	spin_lock(vmf->ptl);
 	if (unlikely(!pte_same(*vmf->pte, vmf->orig_pte))) {
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
@@ -4768,8 +4766,10 @@ static vm_fault_t do_numa_page(struct vm
 		flags |= TNF_MIGRATED;
 	} else {
 		flags |= TNF_MIGRATE_FAIL;
-		vmf->pte = pte_offset_map(vmf->pmd, vmf->address);
-		spin_lock(vmf->ptl);
+		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
+					       vmf->address, &vmf->ptl);
+		if (unlikely(!vmf->pte))
+			goto out;
 		if (unlikely(!pte_same(*vmf->pte, vmf->orig_pte))) {
 			pte_unmap_unlock(vmf->pte, vmf->ptl);
 			goto out;
@@ -4899,26 +4899,15 @@ static vm_fault_t handle_pte_fault(struc
 		vmf->flags &= ~FAULT_FLAG_ORIG_PTE_VALID;
 	} else {
 		/*
-		 * If a huge pmd materialized under us just retry later.  Use
-		 * pmd_trans_unstable() via pmd_devmap_trans_unstable() instead
-		 * of pmd_trans_huge() to ensure the pmd didn't become
-		 * pmd_trans_huge under us and then back to pmd_none, as a
-		 * result of MADV_DONTNEED running immediately after a huge pmd
-		 * fault in a different thread of this mm, in turn leading to a
-		 * misleading pmd_trans_huge() retval. All we have to ensure is
-		 * that it is a regular pmd that we can walk with
-		 * pte_offset_map() and we can do that through an atomic read
-		 * in C, which is what pmd_trans_unstable() provides.
-		 */
-		if (pmd_devmap_trans_unstable(vmf->pmd))
-			return 0;
-		/*
 		 * A regular pmd is established and it can't morph into a huge
-		 * pmd from under us anymore at this point because we hold the
-		 * mmap_lock read mode and khugepaged takes it in write mode.
-		 * So now it's safe to run pte_offset_map().
+		 * pmd by anon khugepaged, since that takes mmap_lock in write
+		 * mode; but shmem or file collapse to THP could still morph
+		 * it into a huge pmd: just retry later if so.
 		 */
-		vmf->pte = pte_offset_map(vmf->pmd, vmf->address);
+		vmf->pte = pte_offset_map_nolock(vmf->vma->vm_mm, vmf->pmd,
+						 vmf->address, &vmf->ptl);
+		if (unlikely(!vmf->pte))
+			return 0;
 		vmf->orig_pte = ptep_get_lockless(vmf->pte);
 		vmf->flags |= FAULT_FLAG_ORIG_PTE_VALID;
 
@@ -4937,7 +4926,6 @@ static vm_fault_t handle_pte_fault(struc
 	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma))
 		return do_numa_page(vmf);
 
-	vmf->ptl = pte_lockptr(vmf->vma->vm_mm, vmf->pmd);
 	spin_lock(vmf->ptl);
 	entry = vmf->orig_pte;
 	if (unlikely(!pte_same(*vmf->pte, entry))) {
_

Patches currently in -mm which might be from hughd@google.com are


