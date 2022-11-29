Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48034C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 29 Nov 2022 21:23:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237058AbiK2VXa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237092AbiK2VXX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2022 16:23:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93A31C403
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 13:23:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0617A617AC
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 21:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61469C433D6;
        Tue, 29 Nov 2022 21:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669756992;
        bh=pUpnUFRyiEahOsd5oimUfzRGKc4kXIJF6dWcujaewhU=;
        h=Date:To:From:Subject:From;
        b=K04WHhUHgvHPf6m9w1Hkmtz9EUbnBsvyRDYUKo0X4Ra8AgS/sBX45BXnqyMrdMS9D
         Q5MOKlbW+pONbOshiYQpclAy3NuBH5hHe+2ZP5ZjwfXgA3D3TBM0HwRzMvDPcYeadw
         dJJ9c44xIS9TwQJWCnKmuykjfFDFq/ITJtKhTrM0=
Date:   Tue, 29 Nov 2022 13:23:11 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        riel@surriel.com, nadav.amit@gmail.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jthoughton@google.com, jannh@google.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-introduce-hugetlb_walk.patch added to mm-unstable branch
Message-Id: <20221129212312.61469C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: introduce hugetlb_walk()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-introduce-hugetlb_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-introduce-hugetlb_walk.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: introduce hugetlb_walk()
Date: Tue, 29 Nov 2022 14:35:26 -0500

huge_pte_offset() is the main walker function for hugetlb pgtables.  The
name is not really representing what it does, though.

Instead of renaming it, introduce a wrapper function called hugetlb_walk()
which will use huge_pte_offset() inside.  Assert on the locks when walking
the pgtable.

Note that the vma lock assertion will be a no-op for private mappings.

Link: https://lkml.kernel.org/r/20221129193526.3588187-11-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |    4 +---
 fs/userfaultfd.c        |    6 ++----
 include/linux/hugetlb.h |   37 +++++++++++++++++++++++++++++++++++++
 mm/hugetlb.c            |   34 ++++++++++++++--------------------
 mm/page_vma_mapped.c    |    2 +-
 mm/pagewalk.c           |    4 +---
 6 files changed, 56 insertions(+), 31 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-hugetlb-introduce-hugetlb_walk
+++ a/fs/hugetlbfs/inode.c
@@ -388,9 +388,7 @@ static bool hugetlb_vma_maps_page(struct
 {
 	pte_t *ptep, pte;
 
-	ptep = huge_pte_offset(vma->vm_mm, addr,
-			huge_page_size(hstate_vma(vma)));
-
+	ptep = hugetlb_walk(vma, addr, huge_page_size(hstate_vma(vma)));
 	if (!ptep)
 		return false;
 
--- a/fs/userfaultfd.c~mm-hugetlb-introduce-hugetlb_walk
+++ a/fs/userfaultfd.c
@@ -237,14 +237,12 @@ static inline bool userfaultfd_huge_must
 					 unsigned long flags,
 					 unsigned long reason)
 {
-	struct mm_struct *mm = ctx->mm;
 	pte_t *ptep, pte;
 	bool ret = true;
 
-	mmap_assert_locked(mm);
-
-	ptep = huge_pte_offset(mm, address, vma_mmu_pagesize(vma));
+	mmap_assert_locked(ctx->mm);
 
+	ptep = hugetlb_walk(vma, address, vma_mmu_pagesize(vma));
 	if (!ptep)
 		goto out;
 
--- a/include/linux/hugetlb.h~mm-hugetlb-introduce-hugetlb_walk
+++ a/include/linux/hugetlb.h
@@ -196,6 +196,11 @@ pte_t *huge_pte_alloc(struct mm_struct *
  * huge_pte_offset(): Walk the hugetlb pgtable until the last level PTE.
  * Returns the pte_t* if found, or NULL if the address is not mapped.
  *
+ * IMPORTANT: we should normally not directly call this function, instead
+ * this is only a common interface to implement arch-specific walker.
+ * Please consider using the hugetlb_walk() helper to make sure of the
+ * correct locking is satisfied.
+ *
  * Since this function will walk all the pgtable pages (including not only
  * high-level pgtable page, but also PUD entry that can be unshared
  * concurrently for VM_SHARED), the caller of this function should be
@@ -1229,4 +1234,36 @@ bool want_pmd_share(struct vm_area_struc
 #define flush_hugetlb_tlb_range(vma, addr, end)	flush_tlb_range(vma, addr, end)
 #endif
 
+static inline bool
+__vma_shareable_flags_pmd(struct vm_area_struct *vma)
+{
+	return vma->vm_flags & (VM_MAYSHARE | VM_SHARED) &&
+		vma->vm_private_data;
+}
+
+/*
+ * Safe version of huge_pte_offset() to check the locks.  See comments
+ * above huge_pte_offset().
+ */
+static inline pte_t *
+hugetlb_walk(struct vm_area_struct *vma, unsigned long addr, unsigned long sz)
+{
+#if defined(CONFIG_ARCH_WANT_HUGE_PMD_SHARE) && defined(CONFIG_LOCKDEP)
+	struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+	/*
+	 * If pmd sharing possible, locking needed to safely walk the
+	 * hugetlb pgtables.  More information can be found at the comment
+	 * above huge_pte_offset() in the same file.
+	 *
+	 * NOTE: lockdep_is_held() is only defined with CONFIG_LOCKDEP.
+	 */
+	if (__vma_shareable_flags_pmd(vma))
+		WARN_ON_ONCE(!lockdep_is_held(&vma_lock->rw_sema) &&
+			     !lockdep_is_held(
+				 &vma->vm_file->f_mapping->i_mmap_rwsem));
+#endif
+	return huge_pte_offset(vma->vm_mm, addr, sz);
+}
+
 #endif /* _LINUX_HUGETLB_H */
--- a/mm/hugetlb.c~mm-hugetlb-introduce-hugetlb_walk
+++ a/mm/hugetlb.c
@@ -4816,7 +4816,7 @@ int copy_hugetlb_page_range(struct mm_st
 	} else {
 		/*
 		 * For shared mappings the vma lock must be held before
-		 * calling huge_pte_offset in the src vma. Otherwise, the
+		 * calling hugetlb_walk() in the src vma. Otherwise, the
 		 * returned ptep could go away if part of a shared pmd and
 		 * another thread calls huge_pmd_unshare.
 		 */
@@ -4826,7 +4826,7 @@ int copy_hugetlb_page_range(struct mm_st
 	last_addr_mask = hugetlb_mask_last_page(h);
 	for (addr = src_vma->vm_start; addr < src_vma->vm_end; addr += sz) {
 		spinlock_t *src_ptl, *dst_ptl;
-		src_pte = huge_pte_offset(src, addr, sz);
+		src_pte = hugetlb_walk(src_vma, addr, sz);
 		if (!src_pte) {
 			addr |= last_addr_mask;
 			continue;
@@ -5030,7 +5030,7 @@ int move_hugetlb_page_tables(struct vm_a
 	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(mapping);
 	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
-		src_pte = huge_pte_offset(mm, old_addr, sz);
+		src_pte = hugetlb_walk(vma, old_addr, sz);
 		if (!src_pte) {
 			old_addr |= last_addr_mask;
 			new_addr |= last_addr_mask;
@@ -5093,7 +5093,7 @@ static void __unmap_hugepage_range(struc
 	last_addr_mask = hugetlb_mask_last_page(h);
 	address = start;
 	for (; address < end; address += sz) {
-		ptep = huge_pte_offset(mm, address, sz);
+		ptep = hugetlb_walk(vma, address, sz);
 		if (!ptep) {
 			address |= last_addr_mask;
 			continue;
@@ -5406,7 +5406,7 @@ retry_avoidcopy:
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 			hugetlb_vma_lock_read(vma);
 			spin_lock(ptl);
-			ptep = huge_pte_offset(mm, haddr, huge_page_size(h));
+			ptep = hugetlb_walk(vma, haddr, huge_page_size(h));
 			if (likely(ptep &&
 				   pte_same(huge_ptep_get(ptep), pte)))
 				goto retry_avoidcopy;
@@ -5444,7 +5444,7 @@ retry_avoidcopy:
 	 * before the page tables are altered
 	 */
 	spin_lock(ptl);
-	ptep = huge_pte_offset(mm, haddr, huge_page_size(h));
+	ptep = hugetlb_walk(vma, haddr, huge_page_size(h));
 	if (likely(ptep && pte_same(huge_ptep_get(ptep), pte))) {
 		/* Break COW or unshare */
 		huge_ptep_clear_flush(vma, haddr, ptep);
@@ -5841,7 +5841,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	 * until finished with ptep.  This prevents huge_pmd_unshare from
 	 * being called elsewhere and making the ptep no longer valid.
 	 *
-	 * ptep could have already be assigned via huge_pte_offset.  That
+	 * ptep could have already be assigned via hugetlb_walk().  That
 	 * is OK, as huge_pte_alloc will return the same value unless
 	 * something has changed.
 	 */
@@ -6233,7 +6233,7 @@ struct page *hugetlb_follow_page_mask(st
 		return NULL;
 
 	hugetlb_vma_lock_read(vma);
-	pte = huge_pte_offset(mm, haddr, huge_page_size(h));
+	pte = hugetlb_walk(vma, haddr, huge_page_size(h));
 	if (!pte)
 		goto out_unlock;
 
@@ -6298,8 +6298,8 @@ long follow_hugetlb_page(struct mm_struc
 		 *
 		 * Note that page table lock is not held when pte is null.
 		 */
-		pte = huge_pte_offset(mm, vaddr & huge_page_mask(h),
-				      huge_page_size(h));
+		pte = hugetlb_walk(vma, vaddr & huge_page_mask(h),
+				   huge_page_size(h));
 		if (pte)
 			ptl = huge_pte_lock(h, mm, pte);
 		absent = !pte || huge_pte_none(huge_ptep_get(pte));
@@ -6485,7 +6485,7 @@ unsigned long hugetlb_change_protection(
 	last_addr_mask = hugetlb_mask_last_page(h);
 	for (; address < end; address += psize) {
 		spinlock_t *ptl;
-		ptep = huge_pte_offset(mm, address, psize);
+		ptep = hugetlb_walk(vma, address, psize);
 		if (!ptep) {
 			address |= last_addr_mask;
 			continue;
@@ -6863,12 +6863,6 @@ void adjust_range_if_pmd_sharing_possibl
 		*end = ALIGN(*end, PUD_SIZE);
 }
 
-static bool __vma_shareable_flags_pmd(struct vm_area_struct *vma)
-{
-	return vma->vm_flags & (VM_MAYSHARE | VM_SHARED) &&
-		vma->vm_private_data;
-}
-
 void hugetlb_vma_lock_read(struct vm_area_struct *vma)
 {
 	if (__vma_shareable_flags_pmd(vma)) {
@@ -7034,8 +7028,8 @@ pte_t *huge_pmd_share(struct mm_struct *
 
 		saddr = page_table_shareable(svma, vma, addr, idx);
 		if (saddr) {
-			spte = huge_pte_offset(svma->vm_mm, saddr,
-					       vma_mmu_pagesize(svma));
+			spte = hugetlb_walk(svma, saddr,
+					    vma_mmu_pagesize(svma));
 			if (spte) {
 				get_page(virt_to_page(spte));
 				break;
@@ -7394,7 +7388,7 @@ void hugetlb_unshare_all_pmds(struct vm_
 	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(vma->vm_file->f_mapping);
 	for (address = start; address < end; address += PUD_SIZE) {
-		ptep = huge_pte_offset(mm, address, sz);
+		ptep = hugetlb_walk(vma, address, sz);
 		if (!ptep)
 			continue;
 		ptl = huge_pte_lock(h, mm, ptep);
--- a/mm/page_vma_mapped.c~mm-hugetlb-introduce-hugetlb_walk
+++ a/mm/page_vma_mapped.c
@@ -171,7 +171,7 @@ bool page_vma_mapped_walk(struct page_vm
 
 		hugetlb_vma_lock_read(vma);
 		/* when pud is not present, pte will be NULL */
-		pvmw->pte = huge_pte_offset(mm, pvmw->address, size);
+		pvmw->pte = hugetlb_walk(vma, pvmw->address, size);
 		if (!pvmw->pte) {
 			hugetlb_vma_unlock_read(vma);
 			return false;
--- a/mm/pagewalk.c~mm-hugetlb-introduce-hugetlb_walk
+++ a/mm/pagewalk.c
@@ -305,13 +305,11 @@ static int walk_hugetlb_range(unsigned l
 	hugetlb_vma_lock_read(vma);
 	do {
 		next = hugetlb_entry_end(h, addr, end);
-		pte = huge_pte_offset(walk->mm, addr & hmask, sz);
-
+		pte = hugetlb_walk(vma, addr & hmask, sz);
 		if (pte)
 			err = ops->hugetlb_entry(pte, hmask, addr, next, walk);
 		else if (ops->pte_hole)
 			err = ops->pte_hole(addr, next, -1, walk);
-
 		if (err)
 			break;
 	} while (addr = next, addr != end);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-migrate-fix-read-only-page-got-writable-when-recover-pte.patch
mm-always-compile-in-pte-markers.patch
mm-use-pte-markers-for-swap-errors.patch
mm-uffd-sanity-check-write-bit-for-uffd-wp-protected-ptes.patch
selftests-vm-use-memfd-for-hugepage-mmap-test.patch
mm-thp-re-apply-mkdirty-for-small-pages-after-split.patch
mm-hugetlb-let-vma_offset_start-to-return-start.patch
mm-hugetlb-dont-wait-for-migration-entry-during-follow-page.patch
mm-hugetlb-document-huge_pte_offset-usage.patch
mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted.patch
mm-hugetlb-make-userfaultfd_huge_must_wait-safe-to-pmd-unshare.patch
mm-hugetlb-make-hugetlb_follow_page_mask-safe-to-pmd-unshare.patch
mm-hugetlb-make-follow_hugetlb_page-safe-to-pmd-unshare.patch
mm-hugetlb-make-walk_hugetlb_range-safe-to-pmd-unshare.patch
mm-hugetlb-make-page_vma_mapped_walk-safe-to-pmd-unshare.patch
mm-hugetlb-introduce-hugetlb_walk.patch

