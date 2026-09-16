Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D263336920F
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 22:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789598956; cv=none; b=I1lKlo/BxUZp1W46kyAqAjLqozrzWNojEh0StQWGLKGf+LCqQkI/YwEiJjVggJ/d7MVDDQgU14go26javyawd1bulbI+5ji9GZ6yDdv46MgLTFKHWj4hIdEUqy2o79doxZ07Z4tgwOlUlnJwrtYfG5ixbKqUtnSAuLuT4fRKw9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789598956; c=relaxed/simple;
	bh=o4+lkT1exTLo1caRrZ1Uhdq1XScNm2XFMSlMulQorPM=;
	h=Date:To:From:Subject:Message-Id; b=bAqUGBCwheXHTk/le3BDe9Y3KuKiEp8gBJSJ1sv+LT0n6XyHlM2OOR1GjzX0hSbeokEi8M8ELPMeDcaQg8uDAgfK271EEBxsXwEyv9Hk5UQD9ZeTmTmX1Yxzw3bNOQYxzgwspuIU7qlZtp+S4GQNNHaRO4m5zI11IVr0dEDeKQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ms1Xnko2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ms1Xnko2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8D11F000FF;
	Wed, 16 Sep 2026 22:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789598948;
	bh=h23e///NZmN/EoXl/bXpts26J7OkX7D5iIeUoCuLaE4=;
	h=Date:To:From:Subject;
	b=Ms1Xnko2RuoIRbcHKMaIkcmRFcejLYCzF30XKaQMV9xYvIWU2N/Z9Mu1d34dc4ulf
	 lJm9FUxpviiTP/CFWdJKZs3xEasZmcs5KQhL3Hbq2qRUFEfaZTSnr40V48lE0+bUUR
	 7xE8qYRPNBf3o4/riM5LjYUrTm3a/uJnA2OtQX3w=
Date: Wed, 16 Sep 2026 15:49:08 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-collapse-declare-the-collapse-interface-in-collapseh.patch added to mm-unstable branch
Message-Id: <20260916224908.AB8D11F000FF@smtp.kernel.org>
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
Date: Wed, 16 Sep 2026 10:31:38 +0100

A collapse takes four calls:

  - collapse_control_init() - set up the control a caller carries;
  - collapse_scan_pmd() - scan one PTE table, under mmap_lock;
  - collapse_run_pmd() - collapse what the scan found, no mmap_lock;
  - collapse_control_release() - done with the control.

All four are static in khugepaged.c, as are collapse_possible_orders(),
which says what a VMA allows, and the revalidate a caller needs once a
collapse has given the mmap_lock up.  No other file can ask for a collapse
without them.

Declare them in collapse.h, with a comment stating the order they are
called in and who holds the lock over each step.  Each function says what
it needs and what it does where it is defined.

hugepage_vma_revalidate() becomes collapse_vma_revalidate(): it is part of
what a collapse offers now, not a helper of the daemon.

Preparation for implementing MADV_COLLAPSE in madvise.c.

No functional change.

Assisted-by: LLM
Link: https://lore.kernel.org/20260916093145.4022188-12-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

 mm/collapse.h   |   47 +++++++++++++++++++++++++++++++++++++++
 mm/khugepaged.c |   55 +++++++++++++++++++++++++++++++++++-----------
 2 files changed, 89 insertions(+), 13 deletions(-)

--- a/mm/collapse.h~mm-collapse-declare-the-collapse-interface-in-collapseh
+++ a/mm/collapse.h
@@ -104,4 +104,51 @@ struct collapse_control {
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
+ *     collapse_control_release(cc)           once, when done with the control
+ *
+ * The caller holds mmap_lock for reading over the scan and passes an address
+ * within @vma, aligned to the PTE table to scan.
+ *
+ * The scan returns with that lock still held.  It only reads, and almost every
+ * table it is offered has nothing to collapse, so a caller walks a whole VMA
+ * under the one lock it took to get there.  SCAN_SUCCEED means there is
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
+void collapse_control_release(struct collapse_control *cc);
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
@@ -498,7 +498,7 @@ void __khugepaged_enter(struct mm_struct
  * Check what orders are possible based on the vma and collapse type.
  * This is used to determine if mTHP collapse is a viable option.
  */
-static unsigned long collapse_possible_orders(struct vm_area_struct *vma,
+unsigned long collapse_possible_orders(struct vm_area_struct *vma,
 		vm_flags_t vm_flags, enum tva_type tva_flags)
 {
 	unsigned long orders;
@@ -1011,12 +1011,12 @@ static int collapse_find_target_node(str
 #endif
 
 /*
- * If mmap_lock temporarily dropped, revalidate vma
- * after taking the mmap_lock again.
- * Returns enum scan_result value.
+ * Find the VMA at @address again once mmap_lock has been given up and taken
+ * back, and check it still allows a collapse of @order there.  The VMA has to
+ * span the whole PMD whatever @order is; with @expect_anon it also has to be
+ * anonymous and have an anon_vma.  *@vmap is the VMA found, if any.
  */
-
-static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
+enum scan_result collapse_vma_revalidate(struct mm_struct *mm, unsigned long address,
 		bool expect_anon, struct vm_area_struct **vmap,
 		struct collapse_control *cc, unsigned int order)
 {
@@ -1264,7 +1264,7 @@ static enum scan_result collapse_huge_pa
 	}
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
+	result = collapse_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
 					 &vma, cc, order);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
@@ -1299,7 +1299,7 @@ static enum scan_result collapse_huge_pa
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
+	result = collapse_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
 					 &vma, cc, order);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
@@ -2734,7 +2734,8 @@ static enum scan_result collapse_scan_fi
 	return result;
 }
 
-static void collapse_control_init(struct collapse_control *cc)
+/* Set up a control before its first scan; cc->policy is the caller's to fill */
+void collapse_control_init(struct collapse_control *cc)
 {
 	cc->progress = 0;
 	cc->scan_file = NULL;
@@ -2749,12 +2750,30 @@ static void collapse_put_scan_file(struc
 	}
 }
 
-static void collapse_control_release(struct collapse_control *cc)
+/*
+ * Done with a control.  A scan that found something has to have been run by
+ * then: the file side takes a reference on the file while it still has the
+ * VMA to take it from, and the run is what gives it back.
+ */
+void collapse_control_release(struct collapse_control *cc)
 {
 	collapse_put_scan_file(cc);
 }
 
-static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
+/*
+ * Scan the PTE table of @vma at @addr for a collapse candidate.  @addr is
+ * aligned to the table; @orders is what the caller allows there.
+ *
+ * Called with mmap_lock held for reading and returns with it still held.  It
+ * only reads, and almost every table it is offered has nothing to collapse,
+ * so a caller walks a whole VMA under the one lock it took to get there.
+ *
+ * SCAN_SUCCEED means there is something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE
+ * means the page cache already holds the PMD folio and only the PTE table is
+ * left to retract.  Both are work for collapse_run_pmd(), which is handed
+ * what the scan returned; anything else is why there is nothing to do.
+ */
+enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 		unsigned long addr, struct collapse_control *cc,
 		unsigned long orders)
 {
@@ -2786,7 +2805,17 @@ static enum scan_result collapse_scan_pm
 	return result;
 }
 
-static enum scan_result collapse_run_pmd(struct mm_struct *mm,
+/*
+ * Collapse the table a scan found work in.  @result is what the scan
+ * returned.
+ *
+ * Called without mmap_lock and returns without it, taking what it needs in
+ * between: what it does -- allocate, isolate, copy, flush -- is slow enough
+ * that a writer would wait behind it.  The caller gives the lock up first,
+ * and with it the VMA and anything derived under it.  The run revalidates for
+ * itself rather than trusting what the scan saw.
+ */
+enum scan_result collapse_run_pmd(struct mm_struct *mm,
 		unsigned long addr, enum scan_result result,
 		struct collapse_control *cc)
 {
@@ -3239,7 +3268,7 @@ int madvise_collapse(struct vm_area_stru
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
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch

