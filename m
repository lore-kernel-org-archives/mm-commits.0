Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7375127CB08
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 22:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741299491; cv=none; b=Xl0sr/Nnx44GyEmBHCzg4tWQVW/6LWVwfRoaNUnO+CPPHL6e/8rfZ4hBYsqTA622Gt0aPeevA3tSzhob6H4UesKacHg+WtaD50lvG561VyyQxVaH0WXsByuh98v5KEKbNvvEGP0Kq81pDasyuwE1Z2Z8hJPqQHPjYLHYb1EQWRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741299491; c=relaxed/simple;
	bh=QSVnYtyLwICKL4btvmrS7vflMWfqCjg0GWQ2x47mFmA=;
	h=Date:To:From:Subject:Message-Id; b=O321CbTQLeHrIjFHRmh6hSqFWY5UaIkgDz48Rnh4W3DA5ZjVBLMv3CCWt1WD1yX0hYxPSSU+YnX2COlgkL25n6kUzTHDBqBZ47k/0Hnz2Uv827NSt81x+rS1O8PLA5hpwanYimsMcwKTyHSpLVnqBgQahuA4B0yv+4RmEDZjWN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZdoRirmI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZdoRirmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E5BC4CEE0;
	Thu,  6 Mar 2025 22:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741299490;
	bh=QSVnYtyLwICKL4btvmrS7vflMWfqCjg0GWQ2x47mFmA=;
	h=Date:To:From:Subject:From;
	b=ZdoRirmIUqQRJyzYlkl7pvSpMpBC7Qh7/RRwvDIUWBLyLKqzNUrrq7+utF+ojo5tO
	 qmHDHdc5FTnVcLzi/EdHsTGnM555RuXO/QoUuLSi2vVlHOsMd6Ss8ikeKZxRAGt/tY
	 Uvo7AjvnoKIU3UfqpBNYes8ljnQBBKFZvuM8wcBg=
Date: Thu, 06 Mar 2025 14:18:10 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-refactor-move_page_tables-abstracting-state.patch added to mm-unstable branch
Message-Id: <20250306221810.C2E5BC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: refactor move_page_tables(), abstracting state
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-refactor-move_page_tables-abstracting-state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-refactor-move_page_tables-abstracting-state.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mremap: refactor move_page_tables(), abstracting state
Date: Thu, 6 Mar 2025 10:34:02 +0000

A lot of state is threaded throughout the page table moving logic within
the mremap code, including boolean values which control behaviour
specifically in regard to whether rmap locks need be held over the
operation and whether the VMA belongs to a temporary stack being moved by
move_arg_pages() (and consequently, relocate_vma_down()).

As we already transmit state throughout this operation, it is neater and
more readable to maintain a small state object.  We do so in the form of
pagetable_move_control.

In addition, this allows us to update parameters within the state as we
manipulate things, for instance with regard to the page table realignment
logic.

In future I want to add additional functionality to the page table logic,
so this is an additional motivation for making it easier to do so.

This patch changes move_page_tables() to accept a pointer to a
pagetable_move_control struct, and performs changes at this level only.
Further page table logic will be updated in a subsequent patch.

We additionally also take the opportunity to add significant comments
describing the address realignment logic to make it abundantly clear what
is going on in this code.

Link: https://lkml.kernel.org/r/89f2446f70acd41172dadbb3404db9d95415c78c.1741256580.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   46 +++++++++++-
 mm/mmap.c     |    5 -
 mm/mremap.c   |  172 +++++++++++++++++++++++++++++++++++-------------
 3 files changed, 171 insertions(+), 52 deletions(-)

--- a/mm/internal.h~mm-mremap-refactor-move_page_tables-abstracting-state
+++ a/mm/internal.h
@@ -25,6 +25,47 @@
 struct folio_batch;
 
 /*
+ * Maintains state across a page table move. The operation assumes both source
+ * and destination VMAs already exist and are specified by the user.
+ *
+ * Partial moves are permitted, but:
+ *      from_vma->vm_start <= from_addr < from_vma->vm_end - len
+ *      to_vma->vm_start <= to_addr < to_vma->vm_end - len
+ *
+ * Must be maintained.
+ *
+ * mmap lock must be held in write and VMA write locks must be held on any VMA
+ * that is visible.
+ *
+ * Use the PAGETABLE_MOVE() macro to initialise this struct.
+ *
+ * NOTE: The page table move is affected by reading from [old_addr, old_end),
+ * and old_addr may be updated for better page table alignment, so len_in
+ * represents the length of the range being copied as specified by the user.
+ */
+struct pagetable_move_control {
+	struct vm_area_struct *old; /* Source VMA. */
+	struct vm_area_struct *new; /* Destination VMA. */
+	unsigned long old_addr; /* Address from which the move begins. */
+	unsigned long old_end; /* Exclusive address at which old range ends. */
+	unsigned long new_addr; /* Address to move page tables to. */
+	unsigned long len_in; /* Bytes to remap specified by user. */
+
+	bool need_rmap_locks; /* Do rmap locks need to be taken? */
+	bool for_stack; /* Is this an early temp stack being moved? */
+};
+
+#define PAGETABLE_MOVE(name, old_, new_, old_addr_, new_addr_, len_)	\
+	struct pagetable_move_control name = {				\
+		.old = old_,						\
+		.new = new_,						\
+		.old_addr = old_addr_,					\
+		.old_end = (old_addr_) + (len_),			\
+		.new_addr = new_addr_,					\
+		.len_in = len_,						\
+	}
+
+/*
  * The set of flags that only affect watermark checking and reclaim
  * behaviour. This is used by the MM to obey the caller constraints
  * about IO, FS and watermark checking while ignoring placement
@@ -1537,10 +1578,7 @@ extern struct list_lru shadow_nodes;
 } while (0)
 
 /* mremap.c */
-unsigned long move_page_tables(struct vm_area_struct *vma,
-	unsigned long old_addr, struct vm_area_struct *new_vma,
-	unsigned long new_addr, unsigned long len,
-	bool need_rmap_locks, bool for_stack);
+unsigned long move_page_tables(struct pagetable_move_control *pmc);
 
 #ifdef CONFIG_UNACCEPTED_MEMORY
 void accept_page(struct page *page);
--- a/mm/mmap.c~mm-mremap-refactor-move_page_tables-abstracting-state
+++ a/mm/mmap.c
@@ -1694,6 +1694,7 @@ int relocate_vma_down(struct vm_area_str
 	VMG_STATE(vmg, mm, &vmi, new_start, old_end, 0, vma->vm_pgoff);
 	struct vm_area_struct *next;
 	struct mmu_gather tlb;
+	PAGETABLE_MOVE(pmc, vma, vma, old_start, new_start, length);
 
 	BUG_ON(new_start > new_end);
 
@@ -1716,8 +1717,8 @@ int relocate_vma_down(struct vm_area_str
 	 * move the page tables downwards, on failure we rely on
 	 * process cleanup to remove whatever mess we made.
 	 */
-	if (length != move_page_tables(vma, old_start,
-				       vma, new_start, length, false, true))
+	pmc.for_stack = true;
+	if (length != move_page_tables(&pmc))
 		return -ENOMEM;
 
 	tlb_gather_mmu(&tlb, mm);
--- a/mm/mremap.c~mm-mremap-refactor-move_page_tables-abstracting-state
+++ a/mm/mremap.c
@@ -580,8 +580,9 @@ static bool move_pgt_entry(enum pgt_entr
  * the VMA that is created to span the source and destination of the move,
  * so we make an exception for it.
  */
-static bool can_align_down(struct vm_area_struct *vma, unsigned long addr_to_align,
-			    unsigned long mask, bool for_stack)
+static bool can_align_down(struct pagetable_move_control *pmc,
+			   struct vm_area_struct *vma, unsigned long addr_to_align,
+			   unsigned long mask)
 {
 	unsigned long addr_masked = addr_to_align & mask;
 
@@ -590,11 +591,11 @@ static bool can_align_down(struct vm_are
 	 * of the corresponding VMA, we can't align down or we will destroy part
 	 * of the current mapping.
 	 */
-	if (!for_stack && vma->vm_start != addr_to_align)
+	if (!pmc->for_stack && vma->vm_start != addr_to_align)
 		return false;
 
 	/* In the stack case we explicitly permit in-VMA alignment. */
-	if (for_stack && addr_masked >= vma->vm_start)
+	if (pmc->for_stack && addr_masked >= vma->vm_start)
 		return true;
 
 	/*
@@ -604,54 +605,131 @@ static bool can_align_down(struct vm_are
 	return find_vma_intersection(vma->vm_mm, addr_masked, vma->vm_start) == NULL;
 }
 
-/* Opportunistically realign to specified boundary for faster copy. */
-static void try_realign_addr(unsigned long *old_addr, struct vm_area_struct *old_vma,
-			     unsigned long *new_addr, struct vm_area_struct *new_vma,
-			     unsigned long mask, bool for_stack)
+/*
+ * Determine if are in fact able to realign for efficiency to a higher page
+ * table boundary.
+ */
+static bool can_realign_addr(struct pagetable_move_control *pmc,
+			     unsigned long pagetable_mask)
 {
+	unsigned long align_mask = ~pagetable_mask;
+	unsigned long old_align = pmc->old_addr & align_mask;
+	unsigned long new_align = pmc->new_addr & align_mask;
+	unsigned long pagetable_size = align_mask + 1;
+	unsigned long old_align_next = pagetable_size - old_align;
+
+	/*
+	 * We don't want to have to go hunting for VMAs from the end of the old
+	 * VMA to the next page table boundary, also we want to make sure the
+	 * operation is wortwhile.
+	 *
+	 * So ensure that we only perform this realignment if the end of the
+	 * range being copied from is at least page table aligned:
+	 *
+	 * boundary                        boundary
+	 *    .<- old_align ->                .
+	 *    .              |----------------.-----------|
+	 *    .              |          vma   .           |
+	 *    .              |----------------.-----------|
+	 *    .              <----------------.----------->
+	 *    .                          len_in
+	 *    <------------------------------->
+	 *    .         pagetable_size        .
+	 *    .              <---------------->
+	 *    .                old_align_next .
+	 */
+	if (pmc->len_in < old_align_next)
+		return false;
+
 	/* Skip if the addresses are already aligned. */
-	if ((*old_addr & ~mask) == 0)
-		return;
+	if (old_align == 0)
+		return false;
 
 	/* Only realign if the new and old addresses are mutually aligned. */
-	if ((*old_addr & ~mask) != (*new_addr & ~mask))
-		return;
+	if (old_align != new_align)
+		return false;
 
 	/* Ensure realignment doesn't cause overlap with existing mappings. */
-	if (!can_align_down(old_vma, *old_addr, mask, for_stack) ||
-	    !can_align_down(new_vma, *new_addr, mask, for_stack))
+	if (!can_align_down(pmc, pmc->old, pmc->old_addr, pagetable_mask) ||
+	    !can_align_down(pmc, pmc->new, pmc->new_addr, pagetable_mask))
+		return false;
+
+	return true;
+}
+
+/*
+ * Opportunistically realign to specified boundary for faster copy.
+ *
+ * Consider an mremap() of a VMA with page table boundaries as below, and no
+ * preceding VMAs from the lower page table boundary to the start of the VMA,
+ * with the end of the range being at least page table aligned:
+ *
+ *   boundary                        boundary
+ *      .              |----------------.-----------|
+ *      .              |          vma   .           |
+ *      .              |----------------.-----------|
+ *      .         pmc->old_addr         .      pmc->old_end
+ *      .              <---------------------------->
+ *      .                  move these page tables
+ *
+ * If we proceed with moving page tables in this scenario, we will have a lot of
+ * work to do traversing old page tables and establishing new ones in the
+ * destination across multiple lower level page tables.
+ *
+ * The idea here is simply to align pmc->old_addr, pmc->new_addr down to the
+ * page table boundary, so we can simply copy a single page table entry for the
+ * aligned portion of the VMA instead:
+ *
+ *   boundary                        boundary
+ *      .              |----------------.-----------|
+ *      .              |          vma   .           |
+ *      .              |----------------.-----------|
+ * pmc->old_addr                        .      pmc->old_end
+ *      <------------------------------------------->
+ *      .           move these page tables
+ */
+static void try_realign_addr(struct pagetable_move_control *pmc,
+			     unsigned long pagetable_mask)
+{
+
+	if (!can_realign_addr(pmc, pagetable_mask))
 		return;
 
-	*old_addr = *old_addr & mask;
-	*new_addr = *new_addr & mask;
+	/*
+	 * Simply align to page table boundaries. Note that we do NOT update the
+	 * pmc->old_end value, and since the move_page_tables() operation spans
+	 * from [old_addr, old_end) (offsetting new_addr as it is performed),
+	 * this simply changes the start of the copy, not the end.
+	 */
+	pmc->old_addr &= pagetable_mask;
+	pmc->new_addr &= pagetable_mask;
 }
 
-unsigned long move_page_tables(struct vm_area_struct *vma,
-		unsigned long old_addr, struct vm_area_struct *new_vma,
-		unsigned long new_addr, unsigned long len,
-		bool need_rmap_locks, bool for_stack)
+unsigned long move_page_tables(struct pagetable_move_control *pmc)
 {
 	unsigned long extent, old_end;
 	struct mmu_notifier_range range;
 	pmd_t *old_pmd, *new_pmd;
 	pud_t *old_pud, *new_pud;
+	unsigned long old_addr, new_addr;
+	struct vm_area_struct *vma = pmc->old;
 
-	if (!len)
+	if (!pmc->len_in)
 		return 0;
 
-	old_end = old_addr + len;
-
 	if (is_vm_hugetlb_page(vma))
-		return move_hugetlb_page_tables(vma, new_vma, old_addr,
-						new_addr, len);
+		return move_hugetlb_page_tables(pmc->old, pmc->new, pmc->old_addr,
+						pmc->new_addr, pmc->len_in);
 
 	/*
 	 * If possible, realign addresses to PMD boundary for faster copy.
 	 * Only realign if the mremap copying hits a PMD boundary.
 	 */
-	if (len >= PMD_SIZE - (old_addr & ~PMD_MASK))
-		try_realign_addr(&old_addr, vma, &new_addr, new_vma, PMD_MASK,
-				 for_stack);
+	try_realign_addr(pmc, PMD_MASK);
+	/* These may have been changed. */
+	old_addr = pmc->old_addr;
+	new_addr = pmc->new_addr;
+	old_end = pmc->old_end;
 
 	flush_cache_range(vma, old_addr, old_end);
 	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma->vm_mm,
@@ -675,12 +753,11 @@ unsigned long move_page_tables(struct vm
 		if (pud_trans_huge(*old_pud) || pud_devmap(*old_pud)) {
 			if (extent == HPAGE_PUD_SIZE) {
 				move_pgt_entry(HPAGE_PUD, vma, old_addr, new_addr,
-					       old_pud, new_pud, need_rmap_locks);
+					       old_pud, new_pud, pmc->need_rmap_locks);
 				/* We ignore and continue on error? */
 				continue;
 			}
 		} else if (IS_ENABLED(CONFIG_HAVE_MOVE_PUD) && extent == PUD_SIZE) {
-
 			if (move_pgt_entry(NORMAL_PUD, vma, old_addr, new_addr,
 					   old_pud, new_pud, true))
 				continue;
@@ -698,7 +775,7 @@ again:
 		    pmd_devmap(*old_pmd)) {
 			if (extent == HPAGE_PMD_SIZE &&
 			    move_pgt_entry(HPAGE_PMD, vma, old_addr, new_addr,
-					   old_pmd, new_pmd, need_rmap_locks))
+					   old_pmd, new_pmd, pmc->need_rmap_locks))
 				continue;
 			split_huge_pmd(vma, old_pmd, old_addr);
 		} else if (IS_ENABLED(CONFIG_HAVE_MOVE_PMD) &&
@@ -713,10 +790,10 @@ again:
 		}
 		if (pmd_none(*old_pmd))
 			continue;
-		if (pte_alloc(new_vma->vm_mm, new_pmd))
+		if (pte_alloc(pmc->new->vm_mm, new_pmd))
 			break;
 		if (move_ptes(vma, old_pmd, old_addr, old_addr + extent,
-			      new_vma, new_pmd, new_addr, need_rmap_locks) < 0)
+			      pmc->new, new_pmd, new_addr, pmc->need_rmap_locks) < 0)
 			goto again;
 	}
 
@@ -726,10 +803,10 @@ again:
 	 * Prevent negative return values when {old,new}_addr was realigned
 	 * but we broke out of the above loop for the first PMD itself.
 	 */
-	if (old_addr < old_end - len)
+	if (old_addr < old_end - pmc->len_in)
 		return 0;
 
-	return len + old_addr - old_end;	/* how much done */
+	return pmc->len_in + old_addr - old_end;	/* how much done */
 }
 
 /* Set vrm->delta to the difference in VMA size specified by user. */
@@ -1039,37 +1116,40 @@ static int copy_vma_and_data(struct vma_
 	unsigned long internal_pgoff = internal_offset >> PAGE_SHIFT;
 	unsigned long new_pgoff = vrm->vma->vm_pgoff + internal_pgoff;
 	unsigned long moved_len;
-	bool need_rmap_locks;
-	struct vm_area_struct *vma;
+	struct vm_area_struct *vma = vrm->vma;
 	struct vm_area_struct *new_vma;
 	int err = 0;
+	PAGETABLE_MOVE(pmc, NULL, NULL, vrm->addr, vrm->new_addr, vrm->old_len);
 
-	new_vma = copy_vma(&vrm->vma, vrm->new_addr, vrm->new_len, new_pgoff,
-			   &need_rmap_locks);
+	new_vma = copy_vma(&vma, vrm->new_addr, vrm->new_len, new_pgoff,
+			   &pmc.need_rmap_locks);
 	if (!new_vma) {
 		vrm_uncharge(vrm);
 		*new_vma_ptr = NULL;
 		return -ENOMEM;
 	}
-	vma = vrm->vma;
+	vrm->vma = vma;
+	pmc.old = vma;
+	pmc.new = new_vma;
 
-	moved_len = move_page_tables(vma, vrm->addr, new_vma,
-				     vrm->new_addr, vrm->old_len,
-				     need_rmap_locks, /* for_stack= */false);
+	moved_len = move_page_tables(&pmc);
 	if (moved_len < vrm->old_len)
 		err = -ENOMEM;
 	else if (vma->vm_ops && vma->vm_ops->mremap)
 		err = vma->vm_ops->mremap(new_vma);
 
 	if (unlikely(err)) {
+		PAGETABLE_MOVE(pmc_revert, new_vma, vma, vrm->new_addr,
+			       vrm->addr, moved_len);
+
 		/*
 		 * On error, move entries back from new area to old,
 		 * which will succeed since page tables still there,
 		 * and then proceed to unmap new area instead of old.
 		 */
-		move_page_tables(new_vma, vrm->new_addr, vma, vrm->addr,
-				 moved_len, /* need_rmap_locks = */true,
-				 /* for_stack= */false);
+		pmc_revert.need_rmap_locks = true;
+		move_page_tables(&pmc_revert);
+
 		vrm->vma = new_vma;
 		vrm->old_len = vrm->new_len;
 		vrm->addr = vrm->new_addr;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-simplify-vma-merge-structure-and-expand-comments.patch
mm-further-refactor-commit_merge.patch
mm-eliminate-adj_start-parameter-from-commit_merge.patch
mm-make-vmg-target-consistent-and-further-simplify-commit_merge.patch
mm-completely-abstract-unnecessary-adj_start-calculation.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix.patch
mm-use-read-write_once-for-vma-vm_flags-on-migrate-mprotect.patch
mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch
mm-provide-mapping_wrprotect_range-function.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch
mm-allow-guard-regions-in-file-backed-and-read-only-mappings.patch
selftests-mm-rename-guard-pages-to-guard-regions.patch
selftests-mm-rename-guard-pages-to-guard-regions-fix.patch
tools-selftests-expand-all-guard-region-tests-to-file-backed.patch
tools-selftests-add-file-shmem-backed-mapping-guard-region-tests.patch
fs-proc-task_mmu-add-guard-region-bit-to-pagemap.patch
tools-selftests-add-guard-region-test-for-proc-pid-pagemap.patch
tools-selftests-add-guard-region-test-for-proc-pid-pagemap-fix.patch
mm-mremap-correctly-handle-partial-mremap-of-vma-starting-at-0.patch
mm-mremap-refactor-mremap-system-call-implementation.patch
mm-mremap-introduce-and-use-vma_remap_struct-threaded-state.patch
mm-mremap-initial-refactor-of-move_vma.patch
mm-mremap-complete-refactor-of-move_vma.patch
mm-mremap-refactor-move_page_tables-abstracting-state.patch
mm-mremap-thread-state-through-move-page-table-operation.patch

