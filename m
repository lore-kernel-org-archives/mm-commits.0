Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EBD4F7CB0
	for <mm-commits@vger.kernel.org>; Mon, 28 Sep 2026 22:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790632908; cv=none; b=Wt++dUtr/NHeQLRleCvtAPW2OFLzfRlJmLm552WJtEi2C5Stz4CxJxvQWa/M9oBEWxwSbQk6bLhfRE6D39D/8pS/viO6gvp0/gVxH/ZfLNlbVEjgwZzy4xKnPTZbgQxH++FRTOngt9IhqL9GFWOL2y5TTA63ib3zJP7/6oZ6fvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790632908; c=relaxed/simple;
	bh=BjkY5rI2RGDk+iXIn3M1DVwz2Zg+OLSz7eVzqoVDKM4=;
	h=Date:To:From:Subject:Message-Id; b=tmNFmmfNjzvZeF2cX1RJ3BqqJWJ6AV8sDWh3kRFtblnIi9PIYJLg1ot9PC/81Rg2+oQ0f/sjmyLp2yV6PgWUgZ7WF9C1P5od61zAQXFS8pNdo4Su/WOkxvBgMsdlY6O6EhatI1puOAQi0u6H6szLFIAejN8lZzR/aFnAyHHY7jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EQ5DEWo6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EQ5DEWo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D751F000FF;
	Mon, 28 Sep 2026 22:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790632906;
	bh=PLYigIrcFW3wJtShYuUxffdwfGQC8j9hb/mBrDyJ7FA=;
	h=Date:To:From:Subject;
	b=EQ5DEWo6KSGpyxGaln5FZnjrmQBAgLTQ6vXIE9liLDXRDhEPWzerwMFJYfXZgd2gW
	 0P8Z4Z/qz6yDh0XjcEMF4dE7o3xUZ7Ys9YUmg5dli2/gyoHhsvMpkStSyvsma2yyAK
	 pj2dBII0orOgIYOCMRu656LPw01CMHf3h9VUTYdE=
Date: Mon, 28 Sep 2026 15:01:46 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch added to mm-unstable branch
Message-Id: <20260928220146.90D751F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/collapse: separate scanning a PTE table from collapsing it
has been added to the -mm mm-unstable branch.  Its filename is
     mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch

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
Subject: mm/collapse: separate scanning a PTE table from collapsing it
Date: Mon, 28 Sep 2026 11:06:23 +0100

A collapse is two jobs.  One reads a PTE table under mmap_lock and decides
whether the range is worth collapsing.  The other allocates, isolates,
copies and flushes, and wants the lock given up first.

collapse_single_pmd() did both, so the boundary between them was somewhere
in the middle of a function.

Give each half its own function:

  - collapse_scan_pmd() scans one table.  The anonymous scan that used to
    carry that name keeps its body as collapse_scan_anon_pmd(), and
    collapse_scan_pmd() is now the entry that picks the anonymous or the
    file side.

  - collapse_run_pmd() does the collapse the scan asked for, and is
    handed what the scan returned.  SCAN_SUCCEED means there is
    something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE means the page
    cache already holds the PMD folio and only the PTE table is left to
    retract.  Both are work for the run; anything else is why there is
    nothing to do.

collapse_single_pmd() is now the two of them with the mmap_lock drop in
between, so its callers see what they saw before.  collapse_control_init()
sets a control up before its first scan.

What the scan found and the run needs travels in collapse_control.  For
an anonymous table that is the orders and the referenced and swapped-out
counts, which mthp_collapse() and collapse_huge_page() now read from
there instead of taking as arguments.  For a file it is the file itself
and the offset in it: a file collapse works on the page cache and never
sees a VMA, so the scan takes the reference while it still has one and
the run gives it back.

The file scan moves under mmap_lock with the anonymous one, where before
the lock was given up first.  The lock is now held over the page cache
walk, an RCU walk over one table's worth of slots with no PTL, and taken
fewer times.  collapse_scan_mm_slot() ends its walk whenever the lock was
dropped, so a refused file table used to cost khugepaged an unlock, a
trip back through khugepaged_do_scan(), a relock and a VMA lookup.  Now
only a table that goes on to be collapsed does.

Link: https://lore.kernel.org/20260928100630.21870-10-kirill@shutemov.name
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

 mm/collapse.h   |   14 ++++
 mm/khugepaged.c |  141 ++++++++++++++++++++++++++++++----------------
 2 files changed, 108 insertions(+), 47 deletions(-)

--- a/mm/collapse.h~mm-collapse-separate-scanning-a-pte-table-from-collapsing-it
+++ a/mm/collapse.h
@@ -98,6 +98,20 @@ struct collapse_control {
 
 	/* Each bit marks a PTE the scan accepted as a collapse source */
 	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
+
+	/*
+	 * What a scan found and the run after it needs.  Live only between the
+	 * two, and read by nobody else.
+	 *
+	 * The file side takes a reference while it still has the VMA, since a
+	 * file collapse works on the page cache and never sees one; the run is
+	 * what gives it back.
+	 */
+	unsigned long scan_orders;
+	int scan_referenced;
+	int scan_unmapped;
+	struct file *scan_file;
+	pgoff_t scan_pgoff;
 };
 
 #endif	/* __MM_COLLAPSE_H */
--- a/mm/khugepaged.c~mm-collapse-separate-scanning-a-pte-table-from-collapsing-it
+++ a/mm/khugepaged.c
@@ -1252,8 +1252,8 @@ static pgtable_t alloc_deposit_pte_table
  * while allocating a THP, as that could trigger direct reclaim/compaction.
  * Note that the VMA must be rechecked after grabbing the mmap_lock again.
  */
-static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
-		int referenced, int unmapped, struct collapse_control *cc,
+static enum scan_result collapse_huge_page(struct mm_struct *mm,
+		unsigned long start_addr, struct collapse_control *cc,
 		unsigned int order)
 {
 	const unsigned long pmd_addr = start_addr & HPAGE_PMD_MASK;
@@ -1300,14 +1300,14 @@ static enum scan_result collapse_huge_pa
 		goto out_nolock;
 	}
 
-	if (unmapped) {
+	if (cc->scan_unmapped) {
 		/*
 		 * __collapse_huge_page_swapin() will return with mmap_lock
 		 * released when it fails. So we jump out_nolock directly in
 		 * that case.  Continuing to collapse causes inconsistency.
 		 */
 		result = __collapse_huge_page_swapin(mm, vma, start_addr, pmd,
-						     referenced, order);
+						     cc->scan_referenced, order);
 		if (result != SCAN_SUCCEED)
 			goto out_nolock;
 	}
@@ -1476,9 +1476,8 @@ static unsigned int max_order_from_offse
  * If a collapse is permitted, we attempt to collapse the PTE range into a
  * mTHP.
  */
-static enum scan_result mthp_collapse(struct mm_struct *mm,
-		unsigned long address, int referenced, int unmapped,
-		struct collapse_control *cc, unsigned long enabled_orders)
+static enum scan_result mthp_collapse(struct mm_struct *mm, unsigned long address,
+		struct collapse_control *cc)
 {
 	unsigned int nr_eligible_ptes, nr_ptes, max_ptes_none;
 	enum scan_result last_result = SCAN_FAIL;
@@ -1491,7 +1490,7 @@ static enum scan_result mthp_collapse(st
 	while (offset < HPAGE_PMD_NR) {
 		nr_ptes = 1UL << order;
 
-		if (!test_bit(order, &enabled_orders))
+		if (!test_bit(order, &cc->scan_orders))
 			goto next_order;
 
 		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
@@ -1499,19 +1498,18 @@ static enum scan_result mthp_collapse(st
 						      offset + nr_ptes);
 
 		/*
-		 * Swap PTEs accepted during the scan are counted in @unmapped,
-		 * not in cc->eligible_ptes. Account them for the PMD-order
-		 * candidate.
+		 * Swap PTEs accepted during the scan are counted in
+		 * cc->scan_unmapped, not in cc->eligible_ptes. Account them for
+		 * the PMD-order candidate.
 		 */
 		if (is_pmd_order(order))
-			nr_eligible_ptes += unmapped;
+			nr_eligible_ptes += cc->scan_unmapped;
 
 		if (nr_eligible_ptes >= nr_ptes - max_ptes_none) {
 			enum scan_result ret;
 
 			collapse_address = address + offset * PAGE_SIZE;
-			ret = collapse_huge_page(mm, collapse_address, referenced,
-						 unmapped, cc, order);
+			ret = collapse_huge_page(mm, collapse_address, cc, order);
 
 			switch (ret) {
 			/* Cases where we continue to next collapse candidate */
@@ -1553,7 +1551,7 @@ next_order:
 		 * we must always move to the next offset.
 		 */
 		if (order > COLLAPSE_MIN_MTHP_ORDER &&
-		    (enabled_orders & GENMASK(order - 1, 0))) {
+		    (cc->scan_orders & GENMASK(order - 1, 0))) {
 			order--;
 			continue;
 		}
@@ -1578,14 +1576,14 @@ done:
 	return last_result;
 }
 
-static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long start_addr,
-		bool *lock_dropped, struct collapse_control *cc)
+static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
+		unsigned long start_addr, struct collapse_control *cc)
 {
 	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
 	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
 	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
 	enum tva_type tva_flags = cc->policy.tva_type;
+	struct mm_struct *mm = vma->vm_mm;
 	pmd_t *pmd;
 	pte_t *pte, *_pte, pteval;
 	int i;
@@ -1765,12 +1763,9 @@ static enum scan_result collapse_scan_pm
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
-		/* collapse_huge_page() expects the lock to be dropped before calling */
-		mmap_read_unlock(mm);
-		result = mthp_collapse(mm, start_addr, referenced,
-				       unmapped, cc, enabled_orders);
-		/* mmap_lock was released above, set lock_dropped */
-		*lock_dropped = true;
+		cc->scan_orders = enabled_orders;
+		cc->scan_referenced = referenced;
+		cc->scan_unmapped = unmapped;
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, failed_pfn, referenced,
@@ -2765,41 +2760,67 @@ static enum scan_result collapse_scan_fi
 		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 	}
 
-	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present, swap, result);
+	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present, swap,
+				      result);
 	return result;
 }
 
-/*
- * Try to collapse a single PMD starting at a PMD aligned addr, and return
- * the results.
- */
-static enum scan_result collapse_single_pmd(unsigned long addr,
-		struct vm_area_struct *vma, bool *lock_dropped,
-		struct collapse_control *cc)
+static void collapse_control_init(struct collapse_control *cc)
+{
+	cc->progress = 0;
+	cc->scan_file = NULL;
+}
+
+static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
+		unsigned long addr, struct collapse_control *cc)
 {
-	struct mm_struct *mm = vma->vm_mm;
-	bool triggered_wb = false;
 	enum scan_result result;
-	struct file *file;
 	pgoff_t pgoff;
 
-	mmap_assert_locked(mm);
+	mmap_assert_locked(vma->vm_mm);
+	/* Whatever the last scan found has to have been run by now */
+	if (WARN_ON_ONCE(cc->scan_file)) {
+		fput(cc->scan_file);
+		cc->scan_file = NULL;
+	}
 
 	if (vma_is_anonymous(vma))
-		return collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
+		return collapse_scan_anon_pmd(vma, addr, cc);
 
-	file = get_file(vma->vm_file);
 	pgoff = linear_page_index(vma, addr);
-
-	mmap_read_unlock(mm);
-	*lock_dropped = true;
-
+	result = collapse_scan_file(vma->vm_mm, addr, vma->vm_file, pgoff, cc);
 	/*
 	 * SCAN_PTE_MAPPED_HUGEPAGE is work too: the page cache already holds
-	 * the PMD folio, and only the PTE table is left to retract.
+	 * the PMD folio, and retracting the PTE table is the run's job.
 	 */
-	result = collapse_scan_file(mm, addr, file, pgoff, cc);
-	if (result != SCAN_SUCCEED)
+	if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
+		return result;
+
+	/*
+	 * A file collapse works on the page cache and never sees a VMA, so take
+	 * what it needs from this one while it is still here.
+	 */
+	cc->scan_file = get_file(vma->vm_file);
+	cc->scan_pgoff = pgoff;
+	return result;
+}
+
+static enum scan_result collapse_run_pmd(struct mm_struct *mm,
+		unsigned long addr, enum scan_result result,
+		struct collapse_control *cc)
+{
+	struct file *file = cc->scan_file;
+	bool triggered_wb = false;
+	pgoff_t pgoff;
+
+	if (!file)
+		return mthp_collapse(mm, addr, cc);
+
+	cc->scan_file = NULL;
+	pgoff = cc->scan_pgoff;
+
+	/* The scan found the PMD folio in place: nothing to collapse */
+	if (result == SCAN_PTE_MAPPED_HUGEPAGE)
 		goto put;
 retry:
 	result = collapse_file(mm, addr, file, pgoff, cc);
@@ -2817,6 +2838,10 @@ retry:
 put:
 	fput(file);
 
+	/*
+	 * A PMD folio is in the page cache, whether the collapse just put it
+	 * there or found it: retract the PTE table, and map the PMD if asked.
+	 */
 	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
 		mmap_read_lock(mm);
 		if (collapse_test_exit_or_disable(mm))
@@ -2831,6 +2856,28 @@ put:
 	return result;
 }
 
+/*
+ * Try to collapse a single PMD starting at a PMD aligned addr, and return
+ * the results.
+ */
+static enum scan_result collapse_single_pmd(unsigned long addr,
+		struct vm_area_struct *vma, bool *lock_dropped,
+		struct collapse_control *cc)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	enum scan_result result;
+
+	result = collapse_scan_pmd(vma, addr, cc);
+	if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
+		return result;
+
+	/* The collapse takes its own locks, so give this up */
+	mmap_read_unlock(mm);
+	*lock_dropped = true;
+
+	return collapse_run_pmd(mm, addr, result, cc);
+}
+
 static void collapse_scan_mm_slot(unsigned int progress_max,
 		enum scan_result *result, struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
@@ -2973,9 +3020,9 @@ static void khugepaged_do_scan(struct co
 
 	lru_add_drain_all();
 
+	collapse_control_init(cc);
 	collapse_policy_khugepaged(&cc->policy);
 
-	cc->progress = 0;
 	while (true) {
 		cond_resched();
 
@@ -3202,8 +3249,8 @@ int madvise_collapse(struct vm_area_stru
 	cc = kmalloc_obj(*cc);
 	if (!cc)
 		return -ENOMEM;
+	collapse_control_init(cc);
 	collapse_policy_madvise(&cc->policy);
-	cc->progress = 0;
 
 	lru_add_drain_all();
 
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

