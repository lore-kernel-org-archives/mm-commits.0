Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6104A502783
	for <mm-commits@vger.kernel.org>; Mon, 28 Sep 2026 22:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790632920; cv=none; b=Gb2R4hCB0DDhgO/Klis53XZdbTAdpAk/tsND1RduB1F81498x3MqLqLq21wsRjxMvlW+VQb53rC9I2RSCxC7ZwJeJuBBxJhyxzj2753S04U7Fn+te803KX6WVvXMlzYCMmbMEmLn36S8eg9gKryHOhV3eZCOCTsrLdnkmksqguA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790632920; c=relaxed/simple;
	bh=fh0B+Br5ggTtRnkgLIyHT68jyODyvS4yM5yNaFA+uHM=;
	h=Date:To:From:Subject:Message-Id; b=ZjY3qZpWgqrMGjQlq7zGDj9zI8tYuFQV+db2gMgMhXszkXnHisVES4HluwtQhywaRW4tNuPpAOogEjHf5RbLLy2qz5nmavmpk8M+OgIMJvlCaGhU5SIdDlmhCgFOevgicG7uHJSez5pjaYQTyz2ms0kC6HEHxLyE4TfJFETCluU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G+vKKCOw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G+vKKCOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EA91F000FF;
	Mon, 28 Sep 2026 22:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790632915;
	bh=ckSpyjsxMXyOYx4Oe0tUPuOf8syAEq+XHYNpZxELGMo=;
	h=Date:To:From:Subject;
	b=G+vKKCOwyWIhWhdUhVHzypp2Rc2+LpNKMY5xous5vtMwmhniYWqCqR4vpMbkqsbLx
	 DV0wv5LgkKE7DCpNdDU0aV8UoDKgzcsUTrhza0O4FvYPnEMtllyUYb9LrsusgdjJV5
	 HIY9++xm+7W4B1mrmP7HntM0C54vkKBXdUltnzks=
Date: Mon, 28 Sep 2026 15:01:55 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-collapse-implement-madv_collapse-in-madvisec.patch added to mm-unstable branch
Message-Id: <20260928220155.99EA91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/collapse: implement MADV_COLLAPSE in madvise.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-collapse-implement-madv_collapse-in-madvisec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-collapse-implement-madv_collapse-in-madvisec.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/collapse: implement MADV_COLLAPSE in madvise.c
Date: Mon, 28 Sep 2026 11:06:27 +0100

MADV_COLLAPSE is a madvise operation, but its implementation sat in
khugepaged.c.  The daemon's file therefore also held a syscall's worth of
code that has nothing to do with the daemon: the walk over the user's
range, the per-PMD loop, and the errno translation.

Move it to madvise.c, among the operations it belongs with, along with the
errno map and the policy it states for itself.  It takes a struct
madvise_behavior like every one of those operations, which is where the
range, the VMA and the lock-dropped flag it used to be handed separately
already live.

It stays a caller of the interface khugepaged uses, so nothing about the
collapse changes.

The !CONFIG_TRANSPARENT_HUGEPAGE stub moves in with it.

Link: https://lore.kernel.org/20260928100630.21870-14-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
---

 include/linux/huge_mm.h |    9 --
 mm/khugepaged.c         |  159 -----------------------------------
 mm/madvise.c            |  170 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 170 insertions(+), 168 deletions(-)

--- a/include/linux/huge_mm.h~mm-collapse-implement-madv_collapse-in-madvisec
+++ a/include/linux/huge_mm.h
@@ -510,8 +510,6 @@ change_huge_pud(struct mmu_gather *tlb,
 
 int hugepage_madvise(struct vm_area_struct *vma, vm_flags_t *vm_flags,
 		     int advice);
-int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
-		     unsigned long end, bool *lock_dropped);
 void vma_adjust_trans_huge(struct vm_area_struct *vma, unsigned long start,
 			   unsigned long end, struct vm_area_struct *next);
 spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma);
@@ -714,13 +712,6 @@ static inline int hugepage_madvise(struc
 {
 	return -EINVAL;
 }
-
-static inline int madvise_collapse(struct vm_area_struct *vma,
-				   unsigned long start,
-				   unsigned long end, bool *lock_dropped)
-{
-	return -EINVAL;
-}
 
 static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
 					 unsigned long start,
--- a/mm/khugepaged.c~mm-collapse-implement-madv_collapse-in-madvisec
+++ a/mm/khugepaged.c
@@ -972,23 +972,6 @@ static void collapse_policy_khugepaged(s
 	p->tva_type = TVA_KHUGEPAGED;
 }
 
-/* MADV_COLLAPSE was asked for explicitly, so it is not held to those */
-static void collapse_policy_madvise(struct collapse_policy *p)
-{
-	p->pmd.max_ptes_none = HPAGE_PMD_NR;
-	p->pmd.max_ptes_swap = HPAGE_PMD_NR;
-	p->pmd.max_ptes_shared = HPAGE_PMD_NR;
-	/* Never read: MADV_COLLAPSE collapses to PMD order only */
-	p->sub_pmd = p->pmd;
-
-	p->anon_skip_lazyfree = false;
-	p->anon_require_referenced = false;
-	p->file_install_pmd = true;
-	p->file_writeback_dirty = true;
-	p->gfp = GFP_TRANSHUGE;
-	p->tva_type = TVA_FORCED_COLLAPSE;
-}
-
 #ifdef CONFIG_NUMA
 static int collapse_find_target_node(struct collapse_control *cc)
 {
@@ -2857,9 +2840,8 @@ enum scan_result collapse_scan_pmd(struc
  *
  * Return: what the collapse made of the table.
  */
-enum scan_result collapse_run_pmd(struct mm_struct *mm,
-		unsigned long addr, enum scan_result result,
-		struct collapse_control *cc)
+enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
+		enum scan_result result, struct collapse_control *cc)
 {
 	struct file *file = cc->scan_file;
 	bool triggered_wb = false;
@@ -3230,140 +3212,3 @@ bool current_is_khugepaged(void)
 {
 	return kthread_func(current) == khugepaged;
 }
-
-static int madvise_collapse_errno(enum scan_result r)
-{
-	/*
-	 * MADV_COLLAPSE breaks from existing madvise(2) conventions to provide
-	 * actionable feedback to caller, so they may take an appropriate
-	 * fallback measure depending on the nature of the failure.
-	 */
-	switch (r) {
-	case SCAN_ALLOC_HUGE_PAGE_FAIL:
-		return -ENOMEM;
-	case SCAN_CGROUP_CHARGE_FAIL:
-	case SCAN_EXCEED_NONE_PTE:
-		return -EBUSY;
-	/* Resource temporary unavailable - trying again might succeed */
-	case SCAN_PAGE_COUNT:
-	case SCAN_PAGE_LOCK:
-	case SCAN_PAGE_LRU:
-	case SCAN_DEL_PAGE_LRU:
-	case SCAN_PAGE_FILLED:
-	case SCAN_PAGE_HAS_PRIVATE:
-	case SCAN_PAGE_DIRTY_OR_WRITEBACK:
-		return -EAGAIN;
-	/*
-	 * Other: Trying again likely not to succeed / error intrinsic to
-	 * specified memory range. khugepaged likely won't be able to collapse
-	 * either.
-	 */
-	default:
-		return -EINVAL;
-	}
-}
-
-int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
-		     unsigned long end, bool *lock_dropped)
-{
-	struct collapse_control *cc;
-	struct mm_struct *mm = vma->vm_mm;
-	unsigned long hstart, hend, addr, orders;
-	enum scan_result last_fail = SCAN_FAIL;
-	int thps = 0;
-
-	BUG_ON(vma->vm_start > start);
-	BUG_ON(vma->vm_end < end);
-
-	orders = collapse_possible_orders(vma, vma->vm_flags,
-					  TVA_FORCED_COLLAPSE);
-	if (!orders)
-		return -EINVAL;
-
-	hstart = ALIGN(start, HPAGE_PMD_SIZE);
-	hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);
-
-	if (hstart >= hend)
-		return 0;
-
-	cc = kmalloc_obj(*cc);
-	if (!cc)
-		return -ENOMEM;
-	collapse_control_init(cc);
-	collapse_policy_madvise(&cc->policy);
-
-	lru_add_drain_all();
-
-	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
-		struct vm_area_struct *found;
-		enum scan_result result;
-
-		/*
-		 * A collapse gives the lock up, so the VMA has to be found
-		 * again after one: it can shrink while nothing is held.  A scan
-		 * that finds nothing to collapse leaves the lock alone, so a
-		 * range that is already collapsed walks on without relocking.
-		 */
-		if (!vma) {
-			cond_resched();
-			mmap_read_lock(mm);
-			result = collapse_vma_revalidate(mm, addr, false, &found,
-							 cc, HPAGE_PMD_ORDER);
-			if (result != SCAN_SUCCEED) {
-				last_fail = result;
-				goto out_locked;
-			}
-			vma = found;
-			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
-			orders = collapse_possible_orders(vma, vma->vm_flags,
-							  TVA_FORCED_COLLAPSE);
-		}
-
-		result = collapse_scan_pmd(vma, addr, cc, orders);
-		/* Nothing to do here, and the lock is still ours */
-		if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
-			goto tally;
-
-		/* The collapse takes its own locks, so give this up */
-		mmap_read_unlock(mm);
-		*lock_dropped = true;
-		vma = NULL;
-
-		result = collapse_run_pmd(mm, addr, result, cc);
-tally:
-		switch (result) {
-		case SCAN_SUCCEED:
-		case SCAN_PMD_MAPPED:
-			++thps;
-			break;
-		/* Whitelisted set of results where continuing OK */
-		case SCAN_NO_PTE_TABLE:
-		case SCAN_PTE_NON_PRESENT:
-		case SCAN_PTE_UFFD:
-		case SCAN_LACK_REFERENCED_PAGE:
-		case SCAN_PAGE_NULL:
-		case SCAN_PAGE_COUNT:
-		case SCAN_PAGE_LOCK:
-		case SCAN_PAGE_COMPOUND:
-		case SCAN_PAGE_LRU:
-		case SCAN_DEL_PAGE_LRU:
-			last_fail = result;
-			break;
-		default:
-			last_fail = result;
-			/* Other error, exit */
-			goto out;
-		}
-	}
-
-out:
-	/* Caller expects us to hold mmap_lock on return */
-	if (!vma)
-		mmap_read_lock(mm);
-out_locked:
-	mmap_assert_locked(mm);
-	kfree(cc);
-
-	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
-			: madvise_collapse_errno(last_fail);
-}
--- a/mm/madvise.c~mm-collapse-implement-madv_collapse-in-madvisec
+++ a/mm/madvise.c
@@ -38,6 +38,7 @@
 
 #include "internal.h"
 #include "swap.h"
+#include "collapse.h"
 
 #define __MADV_SET_ANON_VMA_NAME (-1)
 
@@ -906,6 +907,172 @@ bool madvise_dontneed_free_valid_vma(str
 	return true;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+
+/* MADV_COLLAPSE was asked for explicitly, so it is not held to those */
+static void collapse_policy_madvise(struct collapse_policy *p)
+{
+	p->pmd.max_ptes_none = HPAGE_PMD_NR;
+	p->pmd.max_ptes_swap = HPAGE_PMD_NR;
+	p->pmd.max_ptes_shared = HPAGE_PMD_NR;
+	/* Never read: MADV_COLLAPSE collapses to PMD order only */
+	p->sub_pmd = p->pmd;
+
+	p->anon_skip_lazyfree = false;
+	p->anon_require_referenced = false;
+	p->file_install_pmd = true;
+	p->file_writeback_dirty = true;
+	p->gfp = GFP_TRANSHUGE;
+	p->tva_type = TVA_FORCED_COLLAPSE;
+}
+
+static int madvise_collapse_errno(enum scan_result r)
+{
+	/*
+	 * MADV_COLLAPSE breaks from existing madvise(2) conventions to provide
+	 * actionable feedback to caller, so they may take an appropriate
+	 * fallback measure depending on the nature of the failure.
+	 */
+	switch (r) {
+	case SCAN_ALLOC_HUGE_PAGE_FAIL:
+		return -ENOMEM;
+	case SCAN_CGROUP_CHARGE_FAIL:
+	case SCAN_EXCEED_NONE_PTE:
+		return -EBUSY;
+	/* Resource temporary unavailable - trying again might succeed */
+	case SCAN_PAGE_COUNT:
+	case SCAN_PAGE_LOCK:
+	case SCAN_PAGE_LRU:
+	case SCAN_DEL_PAGE_LRU:
+	case SCAN_PAGE_FILLED:
+	case SCAN_PAGE_HAS_PRIVATE:
+	case SCAN_PAGE_DIRTY_OR_WRITEBACK:
+		return -EAGAIN;
+	/*
+	 * Other: Trying again likely not to succeed / error intrinsic to
+	 * specified memory range. khugepaged likely won't be able to collapse
+	 * either.
+	 */
+	default:
+		return -EINVAL;
+	}
+}
+
+static int madvise_collapse(struct madvise_behavior *madv_behavior)
+{
+	struct madvise_behavior_range *range = &madv_behavior->range;
+	struct vm_area_struct *vma = madv_behavior->vma;
+	struct mm_struct *mm = madv_behavior->mm;
+	struct collapse_control *cc;
+	unsigned long hstart, hend, addr, orders;
+	enum scan_result last_fail = SCAN_FAIL;
+	int thps = 0;
+
+	BUG_ON(vma->vm_start > range->start);
+	BUG_ON(vma->vm_end < range->end);
+
+	orders = collapse_possible_orders(vma, vma->vm_flags,
+					  TVA_FORCED_COLLAPSE);
+	if (!orders)
+		return -EINVAL;
+
+	hstart = ALIGN(range->start, HPAGE_PMD_SIZE);
+	hend = ALIGN_DOWN(range->end, HPAGE_PMD_SIZE);
+
+	if (hstart >= hend)
+		return 0;
+
+	cc = kmalloc_obj(*cc);
+	if (!cc)
+		return -ENOMEM;
+	collapse_control_init(cc);
+	collapse_policy_madvise(&cc->policy);
+
+	lru_add_drain_all();
+
+	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
+		struct vm_area_struct *found;
+		enum scan_result result;
+
+		/*
+		 * A collapse gives the lock up, so the VMA has to be found
+		 * again after one: it can shrink while nothing is held.  A scan
+		 * that finds nothing to collapse leaves the lock alone, so a
+		 * range that is already collapsed walks on without relocking.
+		 */
+		if (!vma) {
+			cond_resched();
+			mmap_read_lock(mm);
+			result = collapse_vma_revalidate(mm, addr, false, &found,
+							 cc, HPAGE_PMD_ORDER);
+			if (result != SCAN_SUCCEED) {
+				last_fail = result;
+				goto out_locked;
+			}
+			vma = found;
+			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
+			orders = collapse_possible_orders(vma, vma->vm_flags,
+							  TVA_FORCED_COLLAPSE);
+		}
+
+		result = collapse_scan_pmd(vma, addr, cc, orders);
+		/* Nothing to do here, and the lock is still ours */
+		if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
+			goto tally;
+
+		/* The collapse takes its own locks, so give this up */
+		mmap_read_unlock(mm);
+		mark_mmap_lock_dropped(madv_behavior);
+		vma = NULL;
+
+		result = collapse_run_pmd(mm, addr, result, cc);
+tally:
+		switch (result) {
+		case SCAN_SUCCEED:
+		case SCAN_PMD_MAPPED:
+			++thps;
+			break;
+		/* Whitelisted set of results where continuing OK */
+		case SCAN_NO_PTE_TABLE:
+		case SCAN_PTE_NON_PRESENT:
+		case SCAN_PTE_UFFD:
+		case SCAN_LACK_REFERENCED_PAGE:
+		case SCAN_PAGE_NULL:
+		case SCAN_PAGE_COUNT:
+		case SCAN_PAGE_LOCK:
+		case SCAN_PAGE_COMPOUND:
+		case SCAN_PAGE_LRU:
+		case SCAN_DEL_PAGE_LRU:
+			last_fail = result;
+			break;
+		default:
+			last_fail = result;
+			/* Other error, exit */
+			goto out;
+		}
+	}
+
+out:
+	/* Caller expects us to hold mmap_lock on return */
+	if (!vma)
+		mmap_read_lock(mm);
+out_locked:
+	mmap_assert_locked(mm);
+	kfree(cc);
+
+	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
+			: madvise_collapse_errno(last_fail);
+}
+
+#else	/* CONFIG_TRANSPARENT_HUGEPAGE */
+
+static int madvise_collapse(struct madvise_behavior *madv_behavior)
+{
+	return -EINVAL;
+}
+
+#endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
+
 static long madvise_dontneed_free(struct madvise_behavior *madv_behavior)
 {
 	struct mm_struct *mm = madv_behavior->mm;
@@ -1373,8 +1540,7 @@ static int madvise_vma_behavior(struct m
 	case MADV_DONTNEED_LOCKED:
 		return madvise_dontneed_free(madv_behavior);
 	case MADV_COLLAPSE:
-		return madvise_collapse(vma, range->start, range->end,
-			&madv_behavior->lock_dropped);
+		return madvise_collapse(madv_behavior);
 	case MADV_GUARD_INSTALL:
 		return madvise_guard_install(madv_behavior);
 	case MADV_GUARD_REMOVE:
_

Patches currently in -mm which might be from kas@kernel.org are

mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch
mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze.patch
mm-huge_memory-add-folio_reset_partially_mapped.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-call-collapse_file-from-collapse_single_pmd.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch
selftests-mm-raise-the-khugepaged-test-case-cap.patch
selftests-mm-skip-collapse_compound_extreme-where-the-pmd-is-too-large.patch
selftests-mm-scale-khugepageds-collapse-wait-with-the-pmd-size.patch
selftests-mm-skip-khugepaged-page-cache-cases-without-a-pmd-folio.patch
selftests-mm-make-the-swap-cases-swapout-reliable.patch
selftests-mm-stop-khugepaged-during-the-madv_collapse-cases.patch
selftests-mm-move-is_backed_by_folio-into-vm_util.patch
selftests-mm-add-folio-order-check-for-address-ranges.patch
selftests-mm-add-folio-order-detection-self-check.patch
selftests-mm-add-khugepaged-completion-barrier-helper.patch
selftests-mm-add-order-parameterized-khugepaged-collapse-cases.patch
selftests-mm-parameterize-the-mixed-source-collapse-case-by-source-order.patch
selftests-mm-cover-a-shared-source-collapse-write-race.patch
selftests-mm-run-every-supported-collapse-order-by-default.patch
selftests-mm-check-that-one-khugepaged-pass-collapses-one-window.patch
selftests-mm-add-khugepaged-race-harness.patch
selftests-mm-race-the-collapse-of-windows-with-holes.patch
selftests-mm-add-memory-pressure-threads-to-the-khugepaged-race-harness.patch
selftests-mm-zap-whole-pte-tables-in-the-khugepaged-race-harness.patch

