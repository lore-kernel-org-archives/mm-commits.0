Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8FA502575
	for <mm-commits@vger.kernel.org>; Mon, 28 Sep 2026 22:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790632916; cv=none; b=WIpHnZn0BZgN4qbvLWu7DdjBYbUIu1pJMTctOpUutdLvN5aZGUCaq6gvglJKzEpLHcAB4ZIIhOvDO/o8o8OSx8IwWOomG47KxN94F77YWoZ6oK3LcuZdFR7StiKHlX7qJZ14q3ofXiZ7u0UNYdb6nU0ddWE0qyn8P04HvqV+Ldg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790632916; c=relaxed/simple;
	bh=TsK+38lNwdbzqlskf78axMa1t78sTzX/8SwXl0LMyG4=;
	h=Date:To:From:Subject:Message-Id; b=YJcEUYHWtohHyq6Oc4+zrnzpDMTfHrZUB900sD4Y2j4B0q8xNZT/mJ/mb1djLdwZ3s8ycnRIOX44T7a6btF15Z0geuXI5zKwibc6mjBOh43GdH3601lBRCqQkV/f8axqsvjudMT4rRKCDQXqfrmHLj/xuohHm2LpwacGCGPHMdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xy6nLbLr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xy6nLbLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FEC21F00898;
	Mon, 28 Sep 2026 22:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790632913;
	bh=KudNSLWQdTkbA5krb2KDyzeRXHEKKm5YbmY96Tc24tM=;
	h=Date:To:From:Subject;
	b=Xy6nLbLrNH76ivLwC5Ep2PovBxPMZVlid+vVjziva4aKeasVyytjRJLcxIvTapYfw
	 nPnqARHc3TTiyXCURO62TxEKnGhwevGRU5+R8m0QV6smtUcRmEo6qisoa4qAUIlXRN
	 qo1Z8/LGRf7MlguzQvvRkc4SYDFY6NFnK8JmSqEY=
Date: Mon, 28 Sep 2026 15:01:52 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-collapse-declare-the-collapse-interface-in-collapseh.patch added to mm-unstable branch
Message-Id: <20260928220153.0FEC21F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/collapse: declare the collapse interface in collapse.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-collapse-declare-the-collapse-interface-in-collapseh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-collapse-declare-the-collapse-interface-in-collapseh.patch

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
Subject: mm/collapse: declare the collapse interface in collapse.h
Date: Mon, 28 Sep 2026 11:06:26 +0100

A collapse takes three calls:

  - collapse_control_init() - set up the control a caller carries;
  - collapse_scan_pmd() - scan one PTE table, under mmap_lock;
  - collapse_run_pmd() - collapse what the scan found, no mmap_lock.

All three are static in khugepaged.c, as are collapse_possible_orders(),
which says what a VMA allows, and the revalidate a caller needs once a
collapse has given the mmap_lock up.  No other file can ask for a collapse
without them.

Declare them in collapse.h, with a comment stating the order they are
called in and who holds the lock over each step.  Each function gets a
kerneldoc comment where it is defined: what it takes, what it does, and
the lock state on entry and exit.

hugepage_vma_revalidate() becomes collapse_vma_revalidate(): it is part of
what a collapse offers now, not a helper of the daemon.

Preparation for implementing MADV_COLLAPSE in madvise.c.

No functional change.

Link: https://lore.kernel.org/20260928100630.21870-13-kirill@shutemov.name
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

 mm/collapse.h   |   45 ++++++++++++++++++++++++
 mm/khugepaged.c |   86 +++++++++++++++++++++++++++++++++++++---------
 2 files changed, 115 insertions(+), 16 deletions(-)

--- a/mm/collapse.h~mm-collapse-declare-the-collapse-interface-in-collapseh
+++ a/mm/collapse.h
@@ -114,4 +114,49 @@ struct collapse_control {
 	pgoff_t scan_pgoff;
 };
 
+/* Which orders a VMA may collapse to, zero when it may not collapse at all */
+unsigned long collapse_possible_orders(struct vm_area_struct *vma,
+		vm_flags_t vm_flags, enum tva_type tva_flags);
+
+/*
+ * A caller states what it allows in cc->policy and then hands over one PTE
+ * table's worth of a VMA at a time:
+ *
+ *     collapse_control_init(cc)              once, before the first table
+ *     collapse_scan_pmd(vma, addr, ...)      per table
+ *     collapse_run_pmd(mm, addr, result, cc) when a scan found work
+ *
+ * The caller holds mmap_lock for reading over the scan and passes an address
+ * within @vma, aligned to the PTE table to scan.
+ *
+ * The scan returns with that lock still held.  Almost every table it is
+ * offered has nothing to collapse, so a caller walks a whole VMA under the one
+ * lock it took to get there.  SCAN_SUCCEED means there is
+ * something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE means the page cache
+ * already holds the PMD folio and only the PTE table is left to retract.
+ * Both are work for the run, which is handed what the scan returned; anything
+ * else is why there is nothing to do.
+ *
+ * The run is called without the lock and returns without it, taking what it
+ * needs in between: what it does -- allocate, isolate, copy, flush -- is slow
+ * enough that a writer would wait behind it.  The caller gives the lock up
+ * first, and with it @vma and anything derived under it, so a caller carrying
+ * on has to look up again with collapse_vma_revalidate().  The run revalidates
+ * for itself rather than trusting what the scan saw.
+ *
+ * A scan that found something has to be run: the file side takes a reference on
+ * the file while it still has the VMA to take it from, and the run is what
+ * gives it back.
+ */
+void collapse_control_init(struct collapse_control *cc);
+enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
+		unsigned long addr, struct collapse_control *cc,
+		unsigned long orders);
+enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
+		enum scan_result result, struct collapse_control *cc);
+enum scan_result collapse_vma_revalidate(struct mm_struct *mm,
+		unsigned long address, bool expect_anon,
+		struct vm_area_struct **vmap, struct collapse_control *cc,
+		unsigned int order);
+
 #endif	/* __MM_COLLAPSE_H */
--- a/mm/khugepaged.c~mm-collapse-declare-the-collapse-interface-in-collapseh
+++ a/mm/khugepaged.c
@@ -476,11 +476,18 @@ void __khugepaged_enter(struct mm_struct
 		wake_up_interruptible(&khugepaged_wait);
 }
 
-/*
- * Check what orders are possible based on the vma and collapse type.
- * This is used to determine if mTHP collapse is a viable option.
+/**
+ * collapse_possible_orders - which orders a VMA may collapse to
+ * @vma: the VMA
+ * @vm_flags: its flags, passed separately where they are about to change
+ * @tva_flags: who is asking, as thp_vma_allowable_orders() spells it
+ *
+ * khugepaged may collapse anonymous memory to any enabled order; everything
+ * else collapses to PMD order only.
+ *
+ * Return: the orders as a bitmask, zero when the VMA may not collapse at all.
  */
-static unsigned long collapse_possible_orders(struct vm_area_struct *vma,
+unsigned long collapse_possible_orders(struct vm_area_struct *vma,
 		vm_flags_t vm_flags, enum tva_type tva_flags)
 {
 	unsigned long orders;
@@ -1008,13 +1015,22 @@ static int collapse_find_target_node(str
 }
 #endif
 
-/*
- * If mmap_lock temporarily dropped, revalidate vma
- * after taking the mmap_lock again.
- * Returns enum scan_result value.
+/**
+ * collapse_vma_revalidate - look a VMA up again after mmap_lock was dropped
+ * @mm: the mm
+ * @address: an address within the PTE table being collapsed
+ * @expect_anon: the collapse started on an anonymous VMA
+ * @vmap: the VMA found, if any
+ * @cc: the control, for the policy that says who is asking
+ * @order: the order the collapse is going for
+ *
+ * Called with mmap_lock held, for reading or writing, once it has been given up
+ * and taken back.  The VMA has to span the whole PMD whatever @order is; with
+ * @expect_anon it also has to be anonymous and have an anon_vma.
+ *
+ * Return: SCAN_SUCCEED, or why a collapse of @order at @address is off.
  */
-
-static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
+enum scan_result collapse_vma_revalidate(struct mm_struct *mm, unsigned long address,
 		bool expect_anon, struct vm_area_struct **vmap,
 		struct collapse_control *cc, unsigned int order)
 {
@@ -1287,7 +1303,7 @@ static enum scan_result collapse_huge_pa
 	}
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
+	result = collapse_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
 					 &vma, cc, order);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
@@ -1322,7 +1338,7 @@ static enum scan_result collapse_huge_pa
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
+	result = collapse_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
 					 &vma, cc, order);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
@@ -2762,13 +2778,36 @@ static enum scan_result collapse_scan_fi
 	return result;
 }
 
-static void collapse_control_init(struct collapse_control *cc)
+/**
+ * collapse_control_init - set up a control before its first scan
+ * @cc: the control the caller carries across its scans
+ *
+ * cc->policy is the caller's to fill.
+ */
+void collapse_control_init(struct collapse_control *cc)
 {
 	cc->progress = 0;
 	cc->scan_file = NULL;
 }
 
-static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
+/**
+ * collapse_scan_pmd - scan one PTE table for a collapse candidate
+ * @vma: the VMA the table belongs to
+ * @addr: start of the table, PMD aligned
+ * @cc: the caller's control
+ * @orders: the orders the caller allows for @vma
+ *
+ * Called with mmap_lock held for reading and returns with it still held.
+ * Almost every table it is offered has nothing to collapse, so a caller walks
+ * a whole VMA under the one lock it took to get there.
+ *
+ * Return: SCAN_SUCCEED when there is something to collapse;
+ * SCAN_PTE_MAPPED_HUGEPAGE when the page cache already holds the PMD folio and
+ * only the PTE table is left to retract.  Both are work for collapse_run_pmd(),
+ * which is handed what the scan returned.  Anything else is why there is
+ * nothing to do.
+ */
+enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 		unsigned long addr, struct collapse_control *cc,
 		unsigned long orders)
 {
@@ -2803,7 +2842,22 @@ static enum scan_result collapse_scan_pm
 	return result;
 }
 
-static enum scan_result collapse_run_pmd(struct mm_struct *mm,
+/**
+ * collapse_run_pmd - collapse the table a scan found work in
+ * @mm: the mm
+ * @addr: start of the table, as given to the scan
+ * @result: what the scan returned
+ * @cc: the control the scan ran with
+ *
+ * Called without mmap_lock and returns without it, taking what it needs in
+ * between: what it does -- allocate, isolate, copy, flush -- is slow enough
+ * that a writer would wait behind it.  The caller gives the lock up first,
+ * and with it the VMA and anything derived under it.  The run revalidates for
+ * itself rather than trusting what the scan saw.
+ *
+ * Return: what the collapse made of the table.
+ */
+enum scan_result collapse_run_pmd(struct mm_struct *mm,
 		unsigned long addr, enum scan_result result,
 		struct collapse_control *cc)
 {
@@ -3253,7 +3307,7 @@ int madvise_collapse(struct vm_area_stru
 		if (!vma) {
 			cond_resched();
 			mmap_read_lock(mm);
-			result = hugepage_vma_revalidate(mm, addr, false, &found,
+			result = collapse_vma_revalidate(mm, addr, false, &found,
 							 cc, HPAGE_PMD_ORDER);
 			if (result != SCAN_SUCCEED) {
 				last_fail = result;
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

