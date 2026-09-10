Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2E349B5CF
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 21:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789077369; cv=none; b=JtRhkECb86JQSHdgl2S9ySMXdIAM67HL8vnmdEyQMOmpGMV+q8NNRYqffeyVUlKCmH1UTLP/3/AWWrX6W1gfgBkv1OA0RoYUF6zVVCS2Cz+hdGTIeCvC0Xs0ylOui+qZfDCnEoauLamozj2kzYgBLPRaR+rxzt86uH8gaRiYwa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789077369; c=relaxed/simple;
	bh=5zvHWMuE8GLXRV1hu2zltSgW2a6Bp1JI0t4kOcu8p8s=;
	h=Date:To:From:Subject:Message-Id; b=A6xBjxml+LQhwKUw+m5cjtwAha7jWiBxF4hNdRWHww34Q27Egogdix/FIonyMwt+ED4EjZWUdwQ42Y6FYl5jFd/DDeN+7lMdujtNH9b1txA4RoUYpM0C4nM7DSDTwEM++1HoNIreU/moQtJPV6gHrstpR6GXjLzhLIgPe6h/F1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hM8uCUSM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hM8uCUSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A7E1F000FF;
	Thu, 10 Sep 2026 21:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789077367;
	bh=YAkDZ1lf8ex3T4bIXqDEjYdPNPOYK6Zxoo8Zv0EfIeg=;
	h=Date:To:From:Subject;
	b=hM8uCUSM98IX9sTWdEP90a+GGJz5sTy8yElSEIfIzBK+p3LQ04tjCELRPMOTA4AvB
	 i/65rjl3W1gUinEh5CaQZNLpcC+cTDZJwtjKj9WEGAp1U5WwM3k8NRt5obbgeG7PhV
	 S2ERyc0YVZwGZZ8gEmXhkOPyak0IZAs/9DUSDtn8=
Date: Thu, 10 Sep 2026 14:56:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch added to mm-new branch
Message-Id: <20260910215607.B4A7E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/collapse: separate scanning a PTE table from collapsing it
has been added to the -mm mm-new branch.  Its filename is
     mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Date: Thu, 10 Sep 2026 13:02:28 +0100

A collapse is two jobs.  One reads a PTE table under mmap_lock and decides
whether the range is worth collapsing.  The other allocates, isolates,
copies and flushes, and wants the lock given up first.

collapse_single_pmd() did both, so the boundary between them was somewhere
in the middle of a function.

Give each half its own function:

  - collapse_scan_pmd() scans one table and only reads.  The anonymous
    scan that used to carry that name keeps its body as
    collapse_scan_anon_pmd(), and collapse_scan_pmd() is now the entry
    that picks the anonymous or the file side.

  - collapse_run_pmd() does the collapse the scan asked for.
    SCAN_SUCCEED from the scan means there is something to run; anything
    else is why there is not.

collapse_single_pmd() is now the two of them with the mmap_lock drop in
between, so its callers see what they saw before.

What the scan found and the run needs travels in collapse_control.  For an
anonymous table that is the orders and the referenced and swapped-out
counts.  For a file it is the file itself, the offset in it, and whether
the PMD folio is already in the page cache.

The file side moves with the anonymous one.  collapse_scan_file() used to
run with mmap_lock already given up, and called collapse_file() itself
when the page cache looked worth it.  It now runs under the lock like the
anonymous scan and only judges; the run does the collapse.  A file
collapse works on the page cache and never sees a VMA, so the scan takes
the file reference while it still has one and the run gives it back.

That changes what a refused file table costs khugepaged.  Every file table
it scanned used to end its pass over that mm, because the lock had been
dropped to scan it; now only a table it goes on to collapse does.

Two things on the file side stop being rescanned.  When the page cache
already holds the PMD folio, the scan says so and the run goes straight to
retracting the PTE table.  A run that refuses dirty pages and may write
them back retries collapse_file() alone.  The checks the scan makes ahead
of it are ones collapse_file() repeats under the page cache lock.

Tracing changes with it.  mm_khugepaged_scan_pmd and
mm_khugepaged_scan_file used to fire after the collapse, so for an
accepted table their status field carried what the collapse made of it. 
They now fire before it and read SCAN_SUCCEED for an accepted table.  What
the collapse then made of it is for mm_collapse_huge_page and
mm_khugepaged_collapse_file to report.

Assisted-by: LLM
Link: https://lore.kernel.org/20260910120238.2529819-9-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/collapse.h   |   16 +++++
 mm/khugepaged.c |  147 +++++++++++++++++++++++++++++++++++-----------
 2 files changed, 128 insertions(+), 35 deletions(-)

--- a/mm/collapse.h~mm-collapse-separate-scanning-a-pte-table-from-collapsing-it
+++ a/mm/collapse.h
@@ -88,6 +88,22 @@ struct collapse_control {
 
 	/* Each bit marks a PTE the scan accepted as a collapse source */
 	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
+
+	/*
+	 * What a scan found and the run after it needs.  Live only between the
+	 * two, and read by nobody else.
+	 *
+	 * The file side takes a reference while it still has the VMA, since a
+	 * file collapse works on the page cache and never sees one; the run is
+	 * what gives it back.  A scan that found the PMD folio already in the
+	 * cache leaves only the PTE table to retract.
+	 */
+	unsigned long scan_orders;
+	int scan_referenced;
+	int scan_unmapped;
+	struct file *scan_file;
+	pgoff_t scan_pgoff;
+	bool scan_retract_only;
 };
 
 #endif	/* __MM_COLLAPSE_H */
--- a/mm/khugepaged.c~mm-collapse-separate-scanning-a-pte-table-from-collapsing-it
+++ a/mm/khugepaged.c
@@ -1550,14 +1550,14 @@ done:
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
@@ -1737,12 +1737,9 @@ static enum scan_result collapse_scan_pm
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
@@ -2739,45 +2736,95 @@ static enum scan_result collapse_scan_fi
 	else
 		cc->progress += HPAGE_PMD_NR;
 
-	if (result == SCAN_SUCCEED) {
-		if (present < HPAGE_PMD_NR - max_ptes_none) {
-			result = SCAN_EXCEED_NONE_PTE;
-			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-		} else {
-			result = collapse_file(mm, addr, file, start, cc);
-		}
+	if (result == SCAN_SUCCEED && present < HPAGE_PMD_NR - max_ptes_none) {
+		result = SCAN_EXCEED_NONE_PTE;
+		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
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
+static void collapse_control_release(struct collapse_control *cc)
+{
+	/* A scan that took a file reference should have been run */
+	if (WARN_ON_ONCE(cc->scan_file)) {
+		fput(cc->scan_file);
+		cc->scan_file = NULL;
+	}
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
+	result = collapse_scan_file(vma->vm_mm, addr, vma->vm_file, pgoff, cc);
+	switch (result) {
+	case SCAN_SUCCEED:
+		cc->scan_retract_only = false;
+		break;
+	case SCAN_PTE_MAPPED_HUGEPAGE:
+		/*
+		 * The page cache already holds the PMD folio; what is left is
+		 * to retract the PTE table, which is the run's job.
+		 */
+		cc->scan_retract_only = true;
+		result = SCAN_SUCCEED;
+		break;
+	default:
+		return result;
+	}
 
-	mmap_read_unlock(mm);
-	*lock_dropped = true;
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
+		unsigned long addr, struct collapse_control *cc)
+{
+	struct file *file = cc->scan_file;
+	bool triggered_wb = false;
+	enum scan_result result;
+	pgoff_t pgoff;
+
+	if (!file)
+		return mthp_collapse(mm, addr, cc->scan_referenced,
+				     cc->scan_unmapped, cc, cc->scan_orders);
+
+	cc->scan_file = NULL;
+	pgoff = cc->scan_pgoff;
+
+	if (cc->scan_retract_only) {
+		result = SCAN_PTE_MAPPED_HUGEPAGE;
+		goto retract;
+	}
 retry:
-	result = collapse_scan_file(mm, addr, file, pgoff, cc);
+	result = collapse_file(mm, addr, file, pgoff, cc);
 
 	/* Dirty pages are worth a writeback and one more try, if asked for */
 	if (cc->policy.writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
@@ -2789,8 +2836,13 @@ retry:
 		triggered_wb = true;
 		goto retry;
 	}
+retract:
 	fput(file);
 
+	/*
+	 * A PMD folio is in the page cache, whether the collapse just put it
+	 * there or found it: retract the PTE table, and map the PMD if asked.
+	 */
 	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
 		mmap_read_lock(mm);
 		if (collapse_test_exit_or_disable(mm))
@@ -2805,6 +2857,28 @@ retry:
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
+	if (result != SCAN_SUCCEED)
+		return result;
+
+	/* The collapse takes its own locks, so give this up */
+	mmap_read_unlock(mm);
+	*lock_dropped = true;
+
+	return collapse_run_pmd(mm, addr, cc);
+}
+
 static void collapse_scan_mm_slot(unsigned int progress_max,
 		enum scan_result *result, struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
@@ -2947,10 +3021,10 @@ static void khugepaged_do_scan(struct co
 
 	lru_add_drain_all();
 
+	collapse_control_init(cc);
 	/* One policy for the whole pass, so every table is judged the same */
 	collapse_policy_khugepaged(&cc->policy);
 
-	cc->progress = 0;
 	while (true) {
 		cond_resched();
 
@@ -2981,6 +3055,8 @@ static void khugepaged_do_scan(struct co
 			khugepaged_alloc_sleep();
 		}
 	}
+
+	collapse_control_release(cc);
 }
 
 static bool khugepaged_should_wakeup(void)
@@ -3177,8 +3253,8 @@ int madvise_collapse(struct vm_area_stru
 	cc = kmalloc_obj(*cc);
 	if (!cc)
 		return -ENOMEM;
+	collapse_control_init(cc);
 	collapse_policy_forced(&cc->policy);
-	cc->progress = 0;
 
 	lru_add_drain_all();
 
@@ -3235,6 +3311,7 @@ out_maybelock:
 	}
 out_nolock:
 	mmap_assert_locked(mm);
+	collapse_control_release(cc);
 	kfree(cc);
 
 	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
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
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch

