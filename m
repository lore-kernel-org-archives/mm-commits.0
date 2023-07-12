Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFF7C001DD
	for <mm-commits@archiver.kernel.org>; Wed, 12 Jul 2023 17:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbjGLR7N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbjGLR6x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2023 13:58:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B162B213C
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 10:58:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3814F6182C
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 17:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4A6C433C8;
        Wed, 12 Jul 2023 17:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689184724;
        bh=BLadzEBQSAsc34N2A3neHOabOBhz9jctDrkZ24twtT8=;
        h=Date:To:From:Subject:From;
        b=qy6d7w/iiMyXl2QxSp+osIDp5CNz6ff8yVwnGeORQO0F3AuHCTK3qb1AkZOeFXD/i
         t3tcWaJB3Tf2U5pCCk+rPW92sRKM2Vv2OlqCnbe0XiDyv3FRHphZo3uSxfkH8fdQxC
         XCdFsbabMqkDXqVOM8MnQAwYfuvpLlk39QTQw0X0=
Date:   Wed, 12 Jul 2023 10:58:43 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        zhengqi.arch@bytedance.com, zackr@vmware.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, will@kernel.org,
        vishal.moola@gmail.com, vbabka@suse.cz,
        thomas.hellstrom@linux.intel.com, surenb@google.com,
        steven.price@arm.com, song@kernel.org, sj@kernel.org,
        shy828301@gmail.com, rppt@kernel.org, rcampbell@nvidia.com,
        peterz@infradead.org, peterx@redhat.com, pasha.tatashin@soleen.com,
        naoya.horiguchi@nec.com, mpe@ellerman.id.au, minchan@kernel.org,
        mike.kravetz@oracle.com, mgorman@techsingularity.net,
        lstoakes@gmail.com, linux@armlinux.org.uk, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca, jannh@google.com,
        ira.weiny@intel.com, imbrenda@linux.ibm.com, hch@infradead.org,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, david@redhat.com,
        davem@davemloft.net, christophe.leroy@csgroup.eu,
        borntraeger@linux.ibm.com, axelrasmussen@google.com,
        apopple@nvidia.com, anshuman.khandual@arm.com,
        aneesh.kumar@linux.ibm.com, agordeev@linux.ibm.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock.patch added to mm-unstable branch
Message-Id: <20230712175844.7E4A6C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock.patch

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
Subject: mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock()
Date: Tue, 11 Jul 2023 21:42:19 -0700 (PDT)

Bring collapse_and_free_pmd() back into collapse_pte_mapped_thp().  It
does need mmap_read_lock(), but it does not need mmap_write_lock(), nor
vma_start_write() nor i_mmap lock nor anon_vma lock.  All racing paths are
relying on pte_offset_map_lock() and pmd_lock(), so use those.

Follow the pattern in retract_page_tables(); and using pte_free_defer()
removes most of the need for tlb_remove_table_sync_one() here; but call
pmdp_get_lockless_sync() to use it in the PAE case.

First check the VMA, in case page tables are being torn down: from JannH. 
Confirm the preliminary find_pmd_or_thp_or_none() once page lock has been
acquired and the page looks suitable: from then on its state is stable.

However, collapse_pte_mapped_thp() was doing something others don't:
freeing a page table still containing "valid" entries.  i_mmap lock did
stop a racing truncate from double-freeing those pages, but we prefer
collapse_pte_mapped_thp() to clear the entries as usual.  Their TLB flush
can wait until the pmdp_collapse_flush() which follows, but the
mmu_notifier_invalidate_range_start() has to be done earlier.

Do the "step 1" checking loop without mmu_notifier: it wouldn't be good
for khugepaged to keep on repeatedly invalidating a range which is then
found unsuitable e.g.  contains COWs.  "step 2", which does the clearing,
must then be more careful (after dropping ptl to do mmu_notifier), with
abort prepared to correct the accounting like "step 3".  But with those
entries now cleared, "step 4" (after dropping ptl to do pmd_lock) is kept
safe by the huge page lock, which stops new PTEs from being faulted in.

Link: https://lkml.kernel.org/r/b53be6a4-7715-51f9-aad-f1347dcb7c4@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zack Rusin <zackr@vmware.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |  174 ++++++++++++++++++++--------------------------
 1 file changed, 78 insertions(+), 96 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock
+++ a/mm/khugepaged.c
@@ -1485,7 +1485,7 @@ static bool khugepaged_add_pte_mapped_th
 	return ret;
 }
 
-/* hpage must be locked, and mmap_lock must be held in write */
+/* hpage must be locked, and mmap_lock must be held */
 static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
 			pmd_t *pmdp, struct page *hpage)
 {
@@ -1497,7 +1497,7 @@ static int set_huge_pmd(struct vm_area_s
 	};
 
 	VM_BUG_ON(!PageTransHuge(hpage));
-	mmap_assert_write_locked(vma->vm_mm);
+	mmap_assert_locked(vma->vm_mm);
 
 	if (do_set_pmd(&vmf, hpage))
 		return SCAN_FAIL;
@@ -1506,48 +1506,6 @@ static int set_huge_pmd(struct vm_area_s
 	return SCAN_SUCCEED;
 }
 
-/*
- * A note about locking:
- * Trying to take the page table spinlocks would be useless here because those
- * are only used to synchronize:
- *
- *  - modifying terminal entries (ones that point to a data page, not to another
- *    page table)
- *  - installing *new* non-terminal entries
- *
- * Instead, we need roughly the same kind of protection as free_pgtables() or
- * mm_take_all_locks() (but only for a single VMA):
- * The mmap lock together with this VMA's rmap locks covers all paths towards
- * the page table entries we're messing with here, except for hardware page
- * table walks and lockless_pages_from_mm().
- */
-static void collapse_and_free_pmd(struct mm_struct *mm, struct vm_area_struct *vma,
-				  unsigned long addr, pmd_t *pmdp)
-{
-	pmd_t pmd;
-	struct mmu_notifier_range range;
-
-	mmap_assert_write_locked(mm);
-	if (vma->vm_file)
-		lockdep_assert_held_write(&vma->vm_file->f_mapping->i_mmap_rwsem);
-	/*
-	 * All anon_vmas attached to the VMA have the same root and are
-	 * therefore locked by the same lock.
-	 */
-	if (vma->anon_vma)
-		lockdep_assert_held_write(&vma->anon_vma->root->rwsem);
-
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, addr,
-				addr + HPAGE_PMD_SIZE);
-	mmu_notifier_invalidate_range_start(&range);
-	pmd = pmdp_collapse_flush(vma, addr, pmdp);
-	tlb_remove_table_sync_one();
-	mmu_notifier_invalidate_range_end(&range);
-	mm_dec_nr_ptes(mm);
-	page_table_check_pte_clear_range(mm, addr, pmd);
-	pte_free(mm, pmd_pgtable(pmd));
-}
-
 /**
  * collapse_pte_mapped_thp - Try to collapse a pte-mapped THP for mm at
  * address haddr.
@@ -1563,26 +1521,29 @@ static void collapse_and_free_pmd(struct
 int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 			    bool install_pmd)
 {
+	struct mmu_notifier_range range;
+	bool notified = false;
 	unsigned long haddr = addr & HPAGE_PMD_MASK;
 	struct vm_area_struct *vma = vma_lookup(mm, haddr);
 	struct page *hpage;
 	pte_t *start_pte, *pte;
-	pmd_t *pmd;
-	spinlock_t *ptl;
-	int count = 0, result = SCAN_FAIL;
+	pmd_t *pmd, pgt_pmd;
+	spinlock_t *pml, *ptl;
+	int nr_ptes = 0, result = SCAN_FAIL;
 	int i;
 
-	mmap_assert_write_locked(mm);
+	mmap_assert_locked(mm);
+
+	/* First check VMA found, in case page tables are being torn down */
+	if (!vma || !vma->vm_file ||
+	    !range_in_vma(vma, haddr, haddr + HPAGE_PMD_SIZE))
+		return SCAN_VMA_CHECK;
 
 	/* Fast check before locking page if already PMD-mapped */
 	result = find_pmd_or_thp_or_none(mm, haddr, &pmd);
 	if (result == SCAN_PMD_MAPPED)
 		return result;
 
-	if (!vma || !vma->vm_file ||
-	    !range_in_vma(vma, haddr, haddr + HPAGE_PMD_SIZE))
-		return SCAN_VMA_CHECK;
-
 	/*
 	 * If we are here, we've succeeded in replacing all the native pages
 	 * in the page cache with a single hugepage. If a mm were to fault-in
@@ -1612,6 +1573,7 @@ int collapse_pte_mapped_thp(struct mm_st
 		goto drop_hpage;
 	}
 
+	result = find_pmd_or_thp_or_none(mm, haddr, &pmd);
 	switch (result) {
 	case SCAN_SUCCEED:
 		break;
@@ -1625,27 +1587,10 @@ int collapse_pte_mapped_thp(struct mm_st
 		goto drop_hpage;
 	}
 
-	/* Lock the vma before taking i_mmap and page table locks */
-	vma_start_write(vma);
-
-	/*
-	 * We need to lock the mapping so that from here on, only GUP-fast and
-	 * hardware page walks can access the parts of the page tables that
-	 * we're operating on.
-	 * See collapse_and_free_pmd().
-	 */
-	i_mmap_lock_write(vma->vm_file->f_mapping);
-
-	/*
-	 * This spinlock should be unnecessary: Nobody else should be accessing
-	 * the page tables under spinlock protection here, only
-	 * lockless_pages_from_mm() and the hardware page walker can access page
-	 * tables while all the high-level locks are held in write mode.
-	 */
 	result = SCAN_FAIL;
 	start_pte = pte_offset_map_lock(mm, pmd, haddr, &ptl);
-	if (!start_pte)
-		goto drop_immap;
+	if (!start_pte)		/* mmap_lock + page lock should prevent this */
+		goto drop_hpage;
 
 	/* step 1: check all mapped PTEs are to the right huge page */
 	for (i = 0, addr = haddr, pte = start_pte;
@@ -1672,10 +1617,18 @@ int collapse_pte_mapped_thp(struct mm_st
 		 */
 		if (hpage + i != page)
 			goto abort;
-		count++;
 	}
 
-	/* step 2: adjust rmap */
+	pte_unmap_unlock(start_pte, ptl);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
+				haddr, haddr + HPAGE_PMD_SIZE);
+	mmu_notifier_invalidate_range_start(&range);
+	notified = true;
+	start_pte = pte_offset_map_lock(mm, pmd, haddr, &ptl);
+	if (!start_pte)		/* mmap_lock + page lock should prevent this */
+		goto abort;
+
+	/* step 2: clear page table and adjust rmap */
 	for (i = 0, addr = haddr, pte = start_pte;
 	     i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE, pte++) {
 		struct page *page;
@@ -1683,47 +1636,76 @@ int collapse_pte_mapped_thp(struct mm_st
 
 		if (pte_none(ptent))
 			continue;
+		/*
+		 * We dropped ptl after the first scan, to do the mmu_notifier:
+		 * page lock stops more PTEs of the hpage being faulted in, but
+		 * does not stop write faults COWing anon copies from existing
+		 * PTEs; and does not stop those being swapped out or migrated.
+		 */
+		if (!pte_present(ptent)) {
+			result = SCAN_PTE_NON_PRESENT;
+			goto abort;
+		}
 		page = vm_normal_page(vma, addr, ptent);
-		if (WARN_ON_ONCE(page && is_zone_device_page(page)))
+		if (hpage + i != page)
 			goto abort;
+
+		/*
+		 * Must clear entry, or a racing truncate may re-remove it.
+		 * TLB flush can be left until pmdp_collapse_flush() does it.
+		 * PTE dirty? Shmem page is already dirty; file is read-only.
+		 */
+		pte_clear(mm, addr, pte);
 		page_remove_rmap(page, vma, false);
+		nr_ptes++;
 	}
 
 	pte_unmap_unlock(start_pte, ptl);
 
 	/* step 3: set proper refcount and mm_counters. */
-	if (count) {
-		page_ref_sub(hpage, count);
-		add_mm_counter(vma->vm_mm, mm_counter_file(hpage), -count);
-	}
+	if (nr_ptes) {
+		page_ref_sub(hpage, nr_ptes);
+		add_mm_counter(mm, mm_counter_file(hpage), -nr_ptes);
+	}
+
+	/* step 4: remove page table */
+
+	/* Huge page lock is still held, so page table must remain empty */
+	pml = pmd_lock(mm, pmd);
+	if (ptl != pml)
+		spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
+	pgt_pmd = pmdp_collapse_flush(vma, haddr, pmd);
+	pmdp_get_lockless_sync();
+	if (ptl != pml)
+		spin_unlock(ptl);
+	spin_unlock(pml);
 
-	/* step 4: remove pte entries */
-	/* we make no change to anon, but protect concurrent anon page lookup */
-	if (vma->anon_vma)
-		anon_vma_lock_write(vma->anon_vma);
-
-	collapse_and_free_pmd(mm, vma, haddr, pmd);
+	mmu_notifier_invalidate_range_end(&range);
 
-	if (vma->anon_vma)
-		anon_vma_unlock_write(vma->anon_vma);
-	i_mmap_unlock_write(vma->vm_file->f_mapping);
+	mm_dec_nr_ptes(mm);
+	page_table_check_pte_clear_range(mm, haddr, pgt_pmd);
+	pte_free_defer(mm, pmd_pgtable(pgt_pmd));
 
 maybe_install_pmd:
 	/* step 5: install pmd entry */
 	result = install_pmd
 			? set_huge_pmd(vma, haddr, pmd, hpage)
 			: SCAN_SUCCEED;
-
+	goto drop_hpage;
+abort:
+	if (nr_ptes) {
+		flush_tlb_mm(mm);
+		page_ref_sub(hpage, nr_ptes);
+		add_mm_counter(mm, mm_counter_file(hpage), -nr_ptes);
+	}
+	if (start_pte)
+		pte_unmap_unlock(start_pte, ptl);
+	if (notified)
+		mmu_notifier_invalidate_range_end(&range);
 drop_hpage:
 	unlock_page(hpage);
 	put_page(hpage);
 	return result;
-
-abort:
-	pte_unmap_unlock(start_pte, ptl);
-drop_immap:
-	i_mmap_unlock_write(vma->vm_file->f_mapping);
-	goto drop_hpage;
 }
 
 static void khugepaged_collapse_pte_mapped_thps(struct khugepaged_mm_slot *mm_slot)
@@ -2856,9 +2838,9 @@ handle_result:
 		case SCAN_PTE_MAPPED_HUGEPAGE:
 			BUG_ON(mmap_locked);
 			BUG_ON(*prev);
-			mmap_write_lock(mm);
+			mmap_read_lock(mm);
 			result = collapse_pte_mapped_thp(mm, addr, true);
-			mmap_write_unlock(mm);
+			mmap_locked = true;
 			goto handle_result;
 		/* Whitelisted set of results where continuing OK */
 		case SCAN_PMD_NULL:
_

Patches currently in -mm which might be from hughd@google.com are

mm-userfaultfd-add-new-uffdio_poison-ioctl-fix.patch
mm-pgtable-add-rcu_read_lock-and-rcu_read_unlocks.patch
mm-pgtable-add-pae-safety-to-__pte_offset_map.patch
arm-adjust_pte-use-pte_offset_map_nolock.patch
powerpc-assert_pte_locked-use-pte_offset_map_nolock.patch
powerpc-add-pte_free_defer-for-pgtables-sharing-page.patch
sparc-add-pte_free_defer-for-pte_t-pgtable_t.patch
s390-add-pte_free_defer-for-pgtables-sharing-page.patch
mm-pgtable-add-pte_free_defer-for-pgtable-as-page.patch
mm-khugepaged-retract_page_tables-without-mmap-or-vma-lock.patch
mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock.patch
mm-khugepaged-delete-khugepaged_collapse_pte_mapped_thps.patch
mm-delete-mmap_write_trylock-and-vma_try_start_write.patch
mm-pgtable-notes-on-pte_offset_map.patch

