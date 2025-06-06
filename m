Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15091FAA;
	Fri,  6 Jun 2025 05:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749186179; cv=none; b=KTdB9szMROrzNTU+MnC5XXKIUbg3kRNJSGld4xZTSIkzhUbbCY0pa66B9o8WtaZlcwFsEbkQ/uReHwFvPyVHQkkA1aMImPkvFT1P+fuMicoCFhA72AYfS8tSd3TL9FhSmFyq6AhyMiErrTl6PjWjbB7a3gl4YHjcShNRgfhTClQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749186179; c=relaxed/simple;
	bh=yw3e5DOHvMZoKnKsVPPyTqWc/xDDAKVattAT8qjYE00=;
	h=Date:To:From:Subject:Message-Id; b=tzwKHJjv07gKoyRE7C2YdF4QHG/ZQNgWf0w3MaaZ1QNyLXU0+qt1ci3xWq23U6ufhiD3UO3Ze78RBjyS8UeJUePgZ4aNmfdKveySorBBrQjNlB4BRWd1D34+DPlGsivXmTHsB6cfTD4DiiDxYw5bXbP6twUhZi8hWt0vm5/ICuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oknxHDRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oknxHDRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CAEC4CEEB;
	Fri,  6 Jun 2025 05:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749186179;
	bh=yw3e5DOHvMZoKnKsVPPyTqWc/xDDAKVattAT8qjYE00=;
	h=Date:To:From:Subject:From;
	b=oknxHDRb4KikMfsBgNeczze260ENaUeIh3lFBzl/q5ZOSrLaDwd5ozmpBr5OToQEC
	 RA6QVdJqL7OvM7OKpMegw5MdEwJ9Z3LV4DZCUZ/h/QADx5knyhN9SKsE8uEHv4BuI8
	 F6vut3unDJ2fQlwFfmWU6kIi0BYudRfNlDQlSdjM=
Date: Thu, 05 Jun 2025 22:02:58 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,osalvador@suse.de,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-unshare-page-tables-during-vma-split-not-before.patch removed from -mm tree
Message-Id: <20250606050259.71CAEC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: unshare page tables during VMA split, not before
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-unshare-page-tables-during-vma-split-not-before.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm/hugetlb: unshare page tables during VMA split, not before
Date: Tue, 27 May 2025 23:23:53 +0200

Currently, __split_vma() triggers hugetlb page table unsharing through
vm_ops->may_split().  This happens before the VMA lock and rmap locks are
taken - which is too early, it allows racing VMA-locked page faults in our
process and racing rmap walks from other processes to cause page tables to
be shared again before we actually perform the split.

Fix it by explicitly calling into the hugetlb unshare logic from
__split_vma() in the same place where THP splitting also happens.  At that
point, both the VMA and the rmap(s) are write-locked.

An annoying detail is that we can now call into the helper
hugetlb_unshare_pmds() from two different locking contexts:

1. from hugetlb_split(), holding:
    - mmap lock (exclusively)
    - VMA lock
    - file rmap lock (exclusively)
2. hugetlb_unshare_all_pmds(), which I think is designed to be able to
   call us with only the mmap lock held (in shared mode), but currently
   only runs while holding mmap lock (exclusively) and VMA lock

Backporting note:
This commit fixes a racy protection that was introduced in commit
b30c14cd6102 ("hugetlb: unshare some PMDs when splitting VMAs"); that
commit claimed to fix an issue introduced in 5.13, but it should actually
also go all the way back.

[jannh@google.com: v2]
  Link: https://lkml.kernel.org/r/20250528-hugetlb-fixes-splitrace-v2-1-1329349bad1a@google.com
Link: https://lkml.kernel.org/r/20250528-hugetlb-fixes-splitrace-v2-0-1329349bad1a@google.com
Link: https://lkml.kernel.org/r/20250527-hugetlb-fixes-splitrace-v1-1-f4136f5ec58a@google.com
Fixes: 39dde65c9940 ("[PATCH] shared page table for hugetlb page")
Signed-off-by: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[b30c14cd6102: hugetlb: unshare some PMDs when splitting VMAs]
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h          |    3 +
 mm/hugetlb.c                     |   60 +++++++++++++++++++++--------
 mm/vma.c                         |    7 +++
 tools/testing/vma/vma_internal.h |    2 
 4 files changed, 56 insertions(+), 16 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-unshare-page-tables-during-vma-split-not-before
+++ a/include/linux/hugetlb.h
@@ -279,6 +279,7 @@ bool is_hugetlb_entry_migration(pte_t pt
 bool is_hugetlb_entry_hwpoisoned(pte_t pte);
 void hugetlb_unshare_all_pmds(struct vm_area_struct *vma);
 void fixup_hugetlb_reservations(struct vm_area_struct *vma);
+void hugetlb_split(struct vm_area_struct *vma, unsigned long addr);
 
 #else /* !CONFIG_HUGETLB_PAGE */
 
@@ -476,6 +477,8 @@ static inline void fixup_hugetlb_reserva
 {
 }
 
+static inline void hugetlb_split(struct vm_area_struct *vma, unsigned long addr) {}
+
 #endif /* !CONFIG_HUGETLB_PAGE */
 
 #ifndef pgd_write
--- a/mm/hugetlb.c~mm-hugetlb-unshare-page-tables-during-vma-split-not-before
+++ a/mm/hugetlb.c
@@ -121,7 +121,7 @@ static void hugetlb_vma_lock_free(struct
 static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma);
 static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma);
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
-		unsigned long start, unsigned long end);
+		unsigned long start, unsigned long end, bool take_locks);
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
 
 static void hugetlb_free_folio(struct folio *folio)
@@ -5426,26 +5426,40 @@ static int hugetlb_vm_op_split(struct vm
 {
 	if (addr & ~(huge_page_mask(hstate_vma(vma))))
 		return -EINVAL;
+	return 0;
+}
 
+void hugetlb_split(struct vm_area_struct *vma, unsigned long addr)
+{
 	/*
 	 * PMD sharing is only possible for PUD_SIZE-aligned address ranges
 	 * in HugeTLB VMAs. If we will lose PUD_SIZE alignment due to this
 	 * split, unshare PMDs in the PUD_SIZE interval surrounding addr now.
+	 * This function is called in the middle of a VMA split operation, with
+	 * MM, VMA and rmap all write-locked to prevent concurrent page table
+	 * walks (except hardware and gup_fast()).
 	 */
+	vma_assert_write_locked(vma);
+	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
+
 	if (addr & ~PUD_MASK) {
-		/*
-		 * hugetlb_vm_op_split is called right before we attempt to
-		 * split the VMA. We will need to unshare PMDs in the old and
-		 * new VMAs, so let's unshare before we split.
-		 */
 		unsigned long floor = addr & PUD_MASK;
 		unsigned long ceil = floor + PUD_SIZE;
 
-		if (floor >= vma->vm_start && ceil <= vma->vm_end)
-			hugetlb_unshare_pmds(vma, floor, ceil);
+		if (floor >= vma->vm_start && ceil <= vma->vm_end) {
+			/*
+			 * Locking:
+			 * Use take_locks=false here.
+			 * The file rmap lock is already held.
+			 * The hugetlb VMA lock can't be taken when we already
+			 * hold the file rmap lock, and we don't need it because
+			 * its purpose is to synchronize against concurrent page
+			 * table walks, which are not possible thanks to the
+			 * locks held by our caller.
+			 */
+			hugetlb_unshare_pmds(vma, floor, ceil, /* take_locks = */ false);
+		}
 	}
-
-	return 0;
 }
 
 static unsigned long hugetlb_vm_op_pagesize(struct vm_area_struct *vma)
@@ -7885,9 +7899,16 @@ void move_hugetlb_state(struct folio *ol
 	spin_unlock_irq(&hugetlb_lock);
 }
 
+/*
+ * If @take_locks is false, the caller must ensure that no concurrent page table
+ * access can happen (except for gup_fast() and hardware page walks).
+ * If @take_locks is true, we take the hugetlb VMA lock (to lock out things like
+ * concurrent page fault handling) and the file rmap lock.
+ */
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 				   unsigned long start,
-				   unsigned long end)
+				   unsigned long end,
+				   bool take_locks)
 {
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
@@ -7911,8 +7932,12 @@ static void hugetlb_unshare_pmds(struct
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
 				start, end);
 	mmu_notifier_invalidate_range_start(&range);
-	hugetlb_vma_lock_write(vma);
-	i_mmap_lock_write(vma->vm_file->f_mapping);
+	if (take_locks) {
+		hugetlb_vma_lock_write(vma);
+		i_mmap_lock_write(vma->vm_file->f_mapping);
+	} else {
+		i_mmap_assert_write_locked(vma->vm_file->f_mapping);
+	}
 	for (address = start; address < end; address += PUD_SIZE) {
 		ptep = hugetlb_walk(vma, address, sz);
 		if (!ptep)
@@ -7922,8 +7947,10 @@ static void hugetlb_unshare_pmds(struct
 		spin_unlock(ptl);
 	}
 	flush_hugetlb_tlb_range(vma, start, end);
-	i_mmap_unlock_write(vma->vm_file->f_mapping);
-	hugetlb_vma_unlock_write(vma);
+	if (take_locks) {
+		i_mmap_unlock_write(vma->vm_file->f_mapping);
+		hugetlb_vma_unlock_write(vma);
+	}
 	/*
 	 * No need to call mmu_notifier_arch_invalidate_secondary_tlbs(), see
 	 * Documentation/mm/mmu_notifier.rst.
@@ -7938,7 +7965,8 @@ static void hugetlb_unshare_pmds(struct
 void hugetlb_unshare_all_pmds(struct vm_area_struct *vma)
 {
 	hugetlb_unshare_pmds(vma, ALIGN(vma->vm_start, PUD_SIZE),
-			ALIGN_DOWN(vma->vm_end, PUD_SIZE));
+			ALIGN_DOWN(vma->vm_end, PUD_SIZE),
+			/* take_locks = */ true);
 }
 
 /*
--- a/mm/vma.c~mm-hugetlb-unshare-page-tables-during-vma-split-not-before
+++ a/mm/vma.c
@@ -539,7 +539,14 @@ __split_vma(struct vma_iterator *vmi, st
 	init_vma_prep(&vp, vma);
 	vp.insert = new;
 	vma_prepare(&vp);
+
+	/*
+	 * Get rid of huge pages and shared page tables straddling the split
+	 * boundary.
+	 */
 	vma_adjust_trans_huge(vma, vma->vm_start, addr, NULL);
+	if (is_vm_hugetlb_page(vma))
+		hugetlb_split(vma, addr);
 
 	if (new_below) {
 		vma->vm_start = addr;
--- a/tools/testing/vma/vma_internal.h~mm-hugetlb-unshare-page-tables-during-vma-split-not-before
+++ a/tools/testing/vma/vma_internal.h
@@ -932,6 +932,8 @@ static inline void vma_adjust_trans_huge
 	(void)next;
 }
 
+static inline void hugetlb_split(struct vm_area_struct *, unsigned long) {}
+
 static inline void vma_iter_free(struct vma_iterator *vmi)
 {
 	mas_destroy(&vmi->mas);
_

Patches currently in -mm which might be from jannh@google.com are

hugetlb-block-hugetlb-file-creation-if-hugetlb-is-not-set-up.patch

