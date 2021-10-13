Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3219C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 21:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C235661154
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 21:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhJMVJa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Oct 2021 17:09:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229771AbhJMVJa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 Oct 2021 17:09:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55DFD61152;
        Wed, 13 Oct 2021 21:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634159246;
        bh=R81r+6jtQ7dgjGAs7/KFuu7hyrwFyt1l3qgEqtGE9+E=;
        h=Date:From:To:Subject:From;
        b=KT763irlCRHcBtQ4UFMHg0YanauK3e0ncDoPnkgA9/xN9cMhRRJ7alfPfpRODl+7U
         w4CxxR/y23jhUlloCeH73M98ELwrhysd0En1QjgdTO6LbZlO93Ianh2Sf2ob5dSwbb
         G9/ZQsn9eJwwt1LWAt/vFeTJeh/D/dgkRJBTn6oU=
Date:   Wed, 13 Oct 2021 14:07:25 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, ckennelly@google.com, kenchen@google.com,
        kirill@shutemov.name, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  +
 mm-hugepages-add-mremap-support-for-hugepage-backed-vma.patch added to -mm
 tree
Message-ID: <20211013210725.tq7zxEley%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugepages: add mremap() support for hugepage backed vma
has been added to the -mm tree.  Its filename is
     mm-hugepages-add-mremap-support-for-hugepage-backed-vma.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugepages-add-mremap-support-for-hugepage-backed-vma.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugepages-add-mremap-support-for-hugepage-backed-vma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mina Almasry <almasrymina@google.com>
Subject: mm, hugepages: add mremap() support for hugepage backed vma

Support mremap() for hugepage backed vma segment by simply repositioning
page table entries.  The page table entries are repositioned to the new
virtual address on mremap().

Hugetlb mremap() support is of course generic; my motivating use case is a
library (hugepage_text), which reloads the ELF text of executables in
hugepages.  This significantly increases the execution performance of said
executables.

Restricts the mremap operation on hugepages to up to the size of the
original mapping as the underlying hugetlb reservation is not yet capable
of handling remapping to a larger size.

During the mremap() operation we detect pmd_share'd mappings and we
unshare those during the mremap().  On access and fault the sharing is
established again.

Link: https://lkml.kernel.org/r/20211013195825.3058275-1-almasrymina@google.com
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Ken Chen <kenchen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Kirill Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   19 ++++++
 mm/hugetlb.c            |  111 +++++++++++++++++++++++++++++++++++---
 mm/mremap.c             |   36 +++++++++++-
 3 files changed, 157 insertions(+), 9 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugepages-add-mremap-support-for-hugepage-backed-vma
+++ a/include/linux/hugetlb.h
@@ -124,6 +124,7 @@ struct hugepage_subpool *hugepage_new_su
 void hugepage_put_subpool(struct hugepage_subpool *spool);
 
 void reset_vma_resv_huge_pages(struct vm_area_struct *vma);
+void clear_vma_resv_huge_pages(struct vm_area_struct *vma);
 int hugetlb_sysctl_handler(struct ctl_table *, int, void *, size_t *, loff_t *);
 int hugetlb_overcommit_handler(struct ctl_table *, int, void *, size_t *,
 		loff_t *);
@@ -132,6 +133,10 @@ int hugetlb_treat_movable_handler(struct
 int hugetlb_mempolicy_sysctl_handler(struct ctl_table *, int, void *, size_t *,
 		loff_t *);
 
+int move_hugetlb_page_tables(struct vm_area_struct *vma,
+			     struct vm_area_struct *new_vma,
+			     unsigned long old_addr, unsigned long new_addr,
+			     unsigned long len);
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *, struct vm_area_struct *);
 long follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *,
 			 struct page **, struct vm_area_struct **,
@@ -215,6 +220,10 @@ static inline void reset_vma_resv_huge_p
 {
 }
 
+static inline void clear_vma_resv_huge_pages(struct vm_area_struct *vma)
+{
+}
+
 static inline unsigned long hugetlb_total_pages(void)
 {
 	return 0;
@@ -260,6 +269,16 @@ static inline int copy_hugetlb_page_rang
 {
 	BUG();
 	return 0;
+}
+
+static inline int move_hugetlb_page_tables(struct vm_area_struct *vma,
+					   struct vm_area_struct *new_vma,
+					   unsigned long old_addr,
+					   unsigned long new_addr,
+					   unsigned long len)
+{
+	BUG();
+	return 0;
 }
 
 static inline void hugetlb_report_meminfo(struct seq_file *m)
--- a/mm/hugetlb.c~mm-hugepages-add-mremap-support-for-hugepage-backed-vma
+++ a/mm/hugetlb.c
@@ -1014,6 +1014,35 @@ void reset_vma_resv_huge_pages(struct vm
 		vma->vm_private_data = (void *)0;
 }
 
+/*
+ * Reset and decrement one ref on hugepage private reservation.
+ * Called with mm->mmap_sem writer semaphore held.
+ * This function should be only used by move_vma() and operate on
+ * same sized vma. It should never come here with last ref on the
+ * reservation.
+ */
+void clear_vma_resv_huge_pages(struct vm_area_struct *vma)
+{
+	/*
+	 * Clear the old hugetlb private page reservation.
+	 * It has already been transferred to new_vma.
+	 *
+	 * During a mremap() operation of a hugetlb vma we call move_vma()
+	 * which copies vma into new_vma and unmaps vma. After the copy
+	 * operation both new_vma and vma share a reference to the resv_map
+	 * struct, and at that point vma is about to be unmapped. We don't
+	 * want to return the reservation to the pool at unmap of vma because
+	 * the reservation still lives on in new_vma, so simply decrement the
+	 * ref here and remove the resv_map reference from this vma.
+	 */
+	struct resv_map *reservations = vma_resv_map(vma);
+
+	if (reservations && is_vma_resv_set(vma, HPAGE_RESV_OWNER))
+		kref_put(&reservations->refs, resv_map_release);
+
+	reset_vma_resv_huge_pages(vma);
+}
+
 /* Returns true if the VMA has associated reserve pages */
 static bool vma_has_reserves(struct vm_area_struct *vma, long chg)
 {
@@ -4718,6 +4747,82 @@ again:
 	return ret;
 }
 
+static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
+			  unsigned long new_addr, pte_t *src_pte)
+{
+	struct hstate *h = hstate_vma(vma);
+	struct mm_struct *mm = vma->vm_mm;
+	pte_t *dst_pte, pte;
+	spinlock_t *src_ptl, *dst_ptl;
+
+	dst_pte = huge_pte_offset(mm, new_addr, huge_page_size(h));
+	dst_ptl = huge_pte_lock(h, mm, dst_pte);
+	src_ptl = huge_pte_lockptr(h, mm, src_pte);
+
+	/*
+	 * We don't have to worry about the ordering of src and dst ptlocks
+	 * because exclusive mmap_sem (or the i_mmap_lock) prevents deadlock.
+	 */
+	if (src_ptl != dst_ptl)
+		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
+
+	pte = huge_ptep_get_and_clear(mm, old_addr, src_pte);
+	set_huge_pte_at(mm, new_addr, dst_pte, pte);
+
+	if (src_ptl != dst_ptl)
+		spin_unlock(src_ptl);
+	spin_unlock(dst_ptl);
+}
+
+int move_hugetlb_page_tables(struct vm_area_struct *vma,
+			     struct vm_area_struct *new_vma,
+			     unsigned long old_addr, unsigned long new_addr,
+			     unsigned long len)
+{
+	struct hstate *h = hstate_vma(vma);
+	struct address_space *mapping = vma->vm_file->f_mapping;
+	unsigned long sz = huge_page_size(h);
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long old_end = old_addr + len;
+	unsigned long old_addr_copy;
+	pte_t *src_pte, *dst_pte;
+	struct mmu_notifier_range range;
+
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, mm, old_addr,
+				old_end);
+	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
+	mmu_notifier_invalidate_range_start(&range);
+	/* Prevent race with file truncation */
+	i_mmap_lock_write(mapping);
+	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
+		src_pte = huge_pte_offset(mm, old_addr, sz);
+		if (!src_pte)
+			continue;
+		if (huge_pte_none(huge_ptep_get(src_pte)))
+			continue;
+
+		/* old_addr arg to huge_pmd_unshare() is a pointer and so the
+		 * arg may be modified. Pass a copy instead to preserve the
+		 * value in old_addr.
+		 */
+		old_addr_copy = old_addr;
+
+		if (huge_pmd_unshare(mm, vma, &old_addr_copy, src_pte))
+			continue;
+
+		dst_pte = huge_pte_alloc(mm, new_vma, new_addr, sz);
+		if (!dst_pte)
+			break;
+
+		move_huge_pte(vma, old_addr, new_addr, src_pte);
+	}
+	i_mmap_unlock_write(mapping);
+	flush_tlb_range(vma, old_end - len, old_end);
+	mmu_notifier_invalidate_range_end(&range);
+
+	return len + old_addr - old_end;
+}
+
 static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end,
 				   struct page *ref_page)
@@ -6257,12 +6362,6 @@ void adjust_range_if_pmd_sharing_possibl
  * sharing is possible.  For hugetlbfs, this prevents removal of any page
  * table entries associated with the address space.  This is important as we
  * are setting up sharing based on existing page table entries (mappings).
- *
- * NOTE: This routine is only called from huge_pte_alloc.  Some callers of
- * huge_pte_alloc know that sharing is not possible and do not take
- * i_mmap_rwsem as a performance optimization.  This is handled by the
- * if !vma_shareable check at the beginning of the routine. i_mmap_rwsem is
- * only required for subsequent processing.
  */
 pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, pud_t *pud)
--- a/mm/mremap.c~mm-hugepages-add-mremap-support-for-hugepage-backed-vma
+++ a/mm/mremap.c
@@ -489,6 +489,10 @@ unsigned long move_page_tables(struct vm
 	old_end = old_addr + len;
 	flush_cache_range(vma, old_addr, old_end);
 
+	if (is_vm_hugetlb_page(vma))
+		return move_hugetlb_page_tables(vma, new_vma, old_addr,
+						new_addr, len);
+
 	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
 				old_addr, old_end);
 	mmu_notifier_invalidate_range_start(&range);
@@ -646,6 +650,10 @@ static unsigned long move_vma(struct vm_
 		mremap_userfaultfd_prep(new_vma, uf);
 	}
 
+	if (is_vm_hugetlb_page(vma)) {
+		clear_vma_resv_huge_pages(vma);
+	}
+
 	/* Conceal VM_ACCOUNT so old reservation is not undone */
 	if (vm_flags & VM_ACCOUNT && !(flags & MREMAP_DONTUNMAP)) {
 		vma->vm_flags &= ~VM_ACCOUNT;
@@ -739,9 +747,6 @@ static struct vm_area_struct *vma_to_res
 			(vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP)))
 		return ERR_PTR(-EINVAL);
 
-	if (is_vm_hugetlb_page(vma))
-		return ERR_PTR(-EINVAL);
-
 	/* We can't remap across vm area boundaries */
 	if (old_len > vma->vm_end - addr)
 		return ERR_PTR(-EFAULT);
@@ -937,6 +942,31 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 
 	if (mmap_write_lock_killable(current->mm))
 		return -EINTR;
+	vma = find_vma(mm, addr);
+	if (!vma || vma->vm_start > addr) {
+		ret = EFAULT;
+		goto out;
+	}
+
+	if (is_vm_hugetlb_page(vma)) {
+		struct hstate *h __maybe_unused = hstate_vma(vma);
+
+		old_len = ALIGN(old_len, huge_page_size(h));
+		new_len = ALIGN(new_len, huge_page_size(h));
+
+		/* addrs must be huge page aligned */
+		if (addr & ~huge_page_mask(h))
+			goto out;
+		if (new_addr & ~huge_page_mask(h))
+			goto out;
+
+		/*
+		 * Don't allow remap expansion, because the underlying hugetlb
+		 * reservation is not yet capable to handle split reservation.
+		 */
+		if (new_len > old_len)
+			goto out;
+	}
 
 	if (flags & (MREMAP_FIXED | MREMAP_DONTUNMAP)) {
 		ret = mremap_to(addr, old_len, new_addr, new_len,
_

Patches currently in -mm which might be from almasrymina@google.com are

mm-hugepages-add-mremap-support-for-hugepage-backed-vma.patch
mm-hugepages-add-hugetlb-vma-mremap-test.patch

