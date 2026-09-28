Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137215013CF
	for <mm-commits@vger.kernel.org>; Mon, 28 Sep 2026 21:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790632273; cv=none; b=DRbAyau9MnRUMZ8y2hmNzNdWXiRlP+hWJNAsG/JuBAvnk0YVgRQmw5WJHSeR1xrdCQux9yaEkYv0Wma7jODO6HTTQ6I2d3kAurC6ixf1QfiHtUxH6IV4x888evrPDC9sQ74vhnf1v1fhyrq+a5G/XzjqV/StP49QUkIaWG8qNlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790632273; c=relaxed/simple;
	bh=qrltCFZR2lQkzcXqdDE+M6X9lcvlLZaRvcZFxlT2a28=;
	h=Date:To:From:Subject:Message-Id; b=VcWkpmD9YN6HeATNTPUdWGLzz2aoQ8XWf6L4uLq+b8BjN4SPZNb4MnrDFcmswKElMO52XgiGK3/qgK9fQwCAOSRvzeWw7IeXBL2tJDQGC22mTZYZe/HYocbvv4uVx4AcTW0fH4pCvsKgi48rD7NpqfkcEnV56JJOg6/4IUdcDDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uM5vUNWi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uM5vUNWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1FF1F00899;
	Mon, 28 Sep 2026 21:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790632271;
	bh=5VIU7wpyS0k4UdwTL44Mn7jirVsbBY5Gbus1O9RT3gc=;
	h=Date:To:From:Subject;
	b=uM5vUNWiVp9Pkz1oSWXD3wTKDup5lxBEQdRHjNdbRFF2hWoD2QSbn4oy3fFDVKAVn
	 CNYWub+RPaJOaOem7GwtVQl9sw/JsVT7ydrhBT90xp3pIEn1JZciRnUMOc2JBA++X7
	 ShovNxUVvdd2Nlm8ggIAlgpTRRmmbtA5T6yyRJ+w=
Date: Mon, 28 Sep 2026 14:51:11 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-collapse-implement-madv_collapse-in-madvisec.patch removed from -mm tree
Message-Id: <20260928215111.AF1FF1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/collapse: implement MADV_COLLAPSE in madvise.c
has been removed from the -mm tree.  Its filename was
     mm-collapse-implement-madv_collapse-in-madvisec.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/collapse: implement MADV_COLLAPSE in madvise.c
Date: Wed, 16 Sep 2026 10:31:39 +0100

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

Link: https://lore.kernel.org/20260916093145.4022188-13-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 include/linux/huge_mm.h |    9 --
 mm/khugepaged.c         |  158 -----------------------------------
 mm/madvise.c            |  169 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 169 insertions(+), 167 deletions(-)

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
@@ -969,21 +969,6 @@ static void collapse_policy_khugepaged(s
 	p->tva_type = TVA_KHUGEPAGED;
 }
 
-/* MADV_COLLAPSE was asked for explicitly, so it is not held to those */
-static void collapse_policy_forced(struct collapse_policy *p)
-{
-	p->max_ptes_none = HPAGE_PMD_NR;
-	p->max_ptes_swap = HPAGE_PMD_NR;
-	p->max_ptes_shared = HPAGE_PMD_NR;
-	p->strict_sub_pmd = false;
-	p->skip_lazyfree = false;
-	p->require_referenced = false;
-	p->install_pmd = true;
-	p->writeback_dirty = true;
-	p->gfp = GFP_TRANSHUGE;
-	p->tva_type = TVA_FORCED_COLLAPSE;
-}
-
 #ifdef CONFIG_NUMA
 static int collapse_find_target_node(struct collapse_control *cc)
 {
@@ -2845,9 +2830,8 @@ enum scan_result collapse_scan_pmd(struc
  * and with it the VMA and anything derived under it.  The run revalidates for
  * itself rather than trusting what the scan saw.
  */
-enum scan_result collapse_run_pmd(struct mm_struct *mm,
-		unsigned long addr, enum scan_result result,
-		struct collapse_control *cc)
+enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
+		enum scan_result result, struct collapse_control *cc)
 {
 	struct file *file = cc->scan_file;
 	bool triggered_wb = false;
@@ -3221,141 +3205,3 @@ bool current_is_khugepaged(void)
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
-	collapse_policy_forced(&cc->policy);
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
-							  cc->policy.tva_type);
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
-	collapse_control_release(cc);
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
 
@@ -906,6 +907,171 @@ bool madvise_dontneed_free_valid_vma(str
 	return true;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+
+/* MADV_COLLAPSE was asked for explicitly, so it is not held to those */
+static void collapse_policy_forced(struct collapse_policy *p)
+{
+	p->max_ptes_none = HPAGE_PMD_NR;
+	p->max_ptes_swap = HPAGE_PMD_NR;
+	p->max_ptes_shared = HPAGE_PMD_NR;
+	p->strict_sub_pmd = false;
+	p->skip_lazyfree = false;
+	p->require_referenced = false;
+	p->install_pmd = true;
+	p->writeback_dirty = true;
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
+	collapse_policy_forced(&cc->policy);
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
+							  cc->policy.tva_type);
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
+	collapse_control_release(cc);
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
@@ -1373,8 +1539,7 @@ static int madvise_vma_behavior(struct m
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

