Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132741F9A8B
	for <mm-commits@vger.kernel.org>; Tue, 27 May 2025 22:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748383880; cv=none; b=co6EgeKxUgcX05PXNYaKrVYOzk7Y0pCkWEzx19YX2D2CWLkpOkX41RHfFOJ7t9LeOK5DCvdLJx0hD6sDTcJO8XWfKrkXNJpYUlyIhiaFTqfDuJThQhJBnvcDkIoH5Ox18Jviznh4uhJSW3TIA30H6bMHIWa9OWfvJRY08Pnwgxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748383880; c=relaxed/simple;
	bh=nXg3wmv3YcFiBYHvYi92v5H2ox6spgvYaiGiKnedVoM=;
	h=Date:To:From:Subject:Message-Id; b=UP1Vqgz/70POvcBVu25b+j3CKWW7hKc0/RWwEStvzur/c8ThlfAlXIz9JhlsGn4Z5QUdeIh+WtYRFqlX1wIIjUUJY6IbZgCbY/rL3N0U8yCTNM1PuajgxjIR2MyPNx4OpyzbLtt5a8szEt6FBSI6Bv1b+E40TDK5PE5u7jjVWOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PKGfgvWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PKGfgvWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66552C4CEE9;
	Tue, 27 May 2025 22:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748383879;
	bh=nXg3wmv3YcFiBYHvYi92v5H2ox6spgvYaiGiKnedVoM=;
	h=Date:To:From:Subject:From;
	b=PKGfgvWQ65O8Y1b37V9Em/sxkoSy+7nTOME+HIwxZsZy2Jn8Ib7S9gYehFboLRwIl
	 iiICUDN3HSoWip6izKCsohWlMyf35qfO63CpGbeFPpSpG9TnbpEc9ccf8XMShFfrVJ
	 JGOeap9UJtuFw7DLFrKCQDhWrP5S9YtCnEOaBYWk=
Date: Tue, 27 May 2025 15:11:18 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@kernel.org,osalvador@suse.de,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-unshare-page-tables-during-vma-split-not-before.patch added to mm-hotfixes-unstable branch
Message-Id: <20250527221119.66552C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: unshare page tables during VMA split, not before
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-unshare-page-tables-during-vma-split-not-before.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-unshare-page-tables-during-vma-split-not-before.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
hugetlb_unshare_pmds() from two different locking contexts.

Backporting note:
This commit fixes a racy protection that was introduced in commit
b30c14cd6102 ("hugetlb: unshare some PMDs when splitting VMAs"); that
commit claimed to fix an issue introduced in 5.13, but it should actually
also go all the way back.

Link: https://lkml.kernel.org/r/20250527-hugetlb-fixes-splitrace-v1-1-f4136f5ec58a@google.com
Fixes: 39dde65c9940 ("[PATCH] shared page table for hugetlb page")
Signed-off-by: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@kernel.org>	[b30c14cd6102: hugetlb: unshare some PMDs when splitting VMAs]
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h          |    3 +
 mm/hugetlb.c                     |   56 ++++++++++++++++++++---------
 mm/vma.c                         |    7 +++
 tools/testing/vma/vma_internal.h |    2 +
 4 files changed, 52 insertions(+), 16 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-unshare-page-tables-during-vma-split-not-before
+++ a/include/linux/hugetlb.h
@@ -276,6 +276,7 @@ bool is_hugetlb_entry_migration(pte_t pt
 bool is_hugetlb_entry_hwpoisoned(pte_t pte);
 void hugetlb_unshare_all_pmds(struct vm_area_struct *vma);
 void fixup_hugetlb_reservations(struct vm_area_struct *vma);
+void hugetlb_split(struct vm_area_struct *vma, unsigned long addr);
 
 #else /* !CONFIG_HUGETLB_PAGE */
 
@@ -473,6 +474,8 @@ static inline void fixup_hugetlb_reserva
 {
 }
 
+static inline void hugetlb_split(struct vm_area_struct *vma, unsigned long addr) {}
+
 #endif /* !CONFIG_HUGETLB_PAGE */
 
 #ifndef pgd_write
--- a/mm/hugetlb.c~mm-hugetlb-unshare-page-tables-during-vma-split-not-before
+++ a/mm/hugetlb.c
@@ -120,7 +120,7 @@ static void hugetlb_vma_lock_free(struct
 static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma);
 static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma);
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
-		unsigned long start, unsigned long end);
+		unsigned long start, unsigned long end, bool take_locks);
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
 
 static void hugetlb_free_folio(struct folio *folio)
@@ -5426,26 +5426,39 @@ static int hugetlb_vm_op_split(struct vm
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
+			hugetlb_unshare_pmds(vma, floor, ceil, false);
+		}
 	}
-
-	return 0;
 }
 
 static unsigned long hugetlb_vm_op_pagesize(struct vm_area_struct *vma)
@@ -7884,9 +7897,14 @@ void move_hugetlb_state(struct folio *ol
 	spin_unlock_irq(&hugetlb_lock);
 }
 
+/*
+ * If @take_locks is false, the caller must ensure that no concurrent page table
+ * access can happen (except for gup_fast() and hardware page walks).
+ */
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 				   unsigned long start,
-				   unsigned long end)
+				   unsigned long end,
+				   bool take_locks)
 {
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
@@ -7910,8 +7928,12 @@ static void hugetlb_unshare_pmds(struct
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
@@ -7921,8 +7943,10 @@ static void hugetlb_unshare_pmds(struct
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
@@ -7937,7 +7961,7 @@ static void hugetlb_unshare_pmds(struct
 void hugetlb_unshare_all_pmds(struct vm_area_struct *vma)
 {
 	hugetlb_unshare_pmds(vma, ALIGN(vma->vm_start, PUD_SIZE),
-			ALIGN_DOWN(vma->vm_end, PUD_SIZE));
+			ALIGN_DOWN(vma->vm_end, PUD_SIZE), true);
 }
 
 /*
--- a/mm/vma.c~mm-hugetlb-unshare-page-tables-during-vma-split-not-before
+++ a/mm/vma.c
@@ -510,7 +510,14 @@ __split_vma(struct vma_iterator *vmi, st
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
@@ -793,6 +793,8 @@ static inline void vma_adjust_trans_huge
 	(void)next;
 }
 
+static inline void hugetlb_split(struct vm_area_struct *, unsigned long) {}
+
 static inline void vma_iter_free(struct vma_iterator *vmi)
 {
 	mas_destroy(&vmi->mas);
_

Patches currently in -mm which might be from jannh@google.com are

mm-hugetlb-unshare-page-tables-during-vma-split-not-before.patch
mm-hugetlb-fix-huge_pmd_unshare-vs-gup-fast-race.patch

