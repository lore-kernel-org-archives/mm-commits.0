Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862E037DAAA
	for <mm-commits@vger.kernel.org>; Tue, 11 Aug 2026 18:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786472672; cv=none; b=R02/U78xrL8laOnYHJNXsH13JXbDjzWzoU9kkxNZrztlNBGzqoFHKtMZIgCY5vLZtPPU5NOeBbOCWPw5vr0C+aTaexuMY3NZUPmufHVPKldK82ClmE4UsrbKVBLGr6zZ6Nm+DPADwp9Ri/3K2QHPHGWIc+AWjeL4J0fT7soqfHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786472672; c=relaxed/simple;
	bh=emnbV6/Vx2Eg7d2ae7DyJEo71kPMj/Vgjxz1ChSHPzk=;
	h=Date:To:From:Subject:Message-Id; b=jVPxhRFNXkjZM/siVt70koEsmRdxxXfRfpRQZq3zAcm1vojraHjy3H2Q3971m8V4urJ34rLSDYmKmASrfojAAD1EeVF3zQManedUlkM7L6+MSH5Eyc3+LpyYM0aazdgCXjY2PGWHap209nw1UoRvASob1eNUk6QwOZZlfeZEbyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S3wKIOL5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S3wKIOL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209431F000E9;
	Tue, 11 Aug 2026 18:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786472670;
	bh=sZHwsPvyDf6v72M1C2FAasiZDKyQCmarPxxwrIfFDHA=;
	h=Date:To:From:Subject;
	b=S3wKIOL5l5XxGRXnlT6RCKQCyAXdwYSUvJhwodY4BABYyU9fZmvyz7mnH7hG8hDsM
	 VzMwuFmJeAI8r5omz8yqKBcg+ZlShPoHdwl2j9rrZEYP0vZNlIJZGEp/5/18uc0lp6
	 UsH07E46Uu00+CGK9WoTdEue3K/izI9ZFplBHaIQ=
Date: Tue, 11 Aug 2026 11:24:29 -0700
To: mm-commits@vger.kernel.org,nico.pache@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-refactor-the-pte-state-checks-into-a-helper.patch added to mm-unstable branch
Message-Id: <20260811182430.209431F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: refactor the PTE state checks into a helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-refactor-the-pte-state-checks-into-a-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-refactor-the-pte-state-checks-into-a-helper.patch

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
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Subject: mm/khugepaged: refactor the PTE state checks into a helper
Date: Tue, 11 Aug 2026 06:48:37 -0600

For anonymous collapse, the collapse_scan_pmd() and
__collapse_huge_page_isolate() functions share a large portion of their
logic.  These functions both check the state of the PTEs and verify the
following:

	- max_pte_* values are not exceeded
	- uffd is not active
	- lazyfree properties
	- non-anonymous

Merge these checks into a helper collapse_check_pte() to reduce code
duplication.  We also add a helper struct for this function called
pte_check_context which allows us to pass the required parameters in a
clean and elegant manner.

A helper function is also introduced pte_check_fail() to provide a clean
interface to set the pte_check_context failure results and return
PTE_CHECK_FAIL state.  This helps reduce code duplications across the new
collapse_check_pte function.

Two slight modifications are done to the original functionality.  We now
warn (instead of crash) if the anon test fails, and we leverage the
vm_normal_folio function instead of page->folio, this should be
functionally equivalent.

No other functional changes intended.

This patch is heavily based off work done by Lance Yang, but modified to
deal with conflicts and feedback received during the review cycle [1].

Link: https://lore.kernel.org/20260811-khugepaged_pte_refactor-v4-5-ddac39d61c4a@linux.dev
Link: https://lore.kernel.org/linux-mm/20251008043748.45554-1-lance.yang@linux.dev/ [1]
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Suggested-by: David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |  298 ++++++++++++++++++++++++----------------------
 1 file changed, 157 insertions(+), 141 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-refactor-the-pte-state-checks-into-a-helper
+++ a/mm/khugepaged.c
@@ -65,6 +65,12 @@ enum scan_result {
 	SCAN_PAGE_DIRTY_OR_WRITEBACK,
 };
 
+enum pte_check_result {
+	PTE_CHECK_SUCCEED,
+	PTE_CHECK_FAIL,
+	PTE_CHECK_CONTINUE,
+};
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/huge_memory.h>
 
@@ -119,6 +125,20 @@ struct collapse_control {
 	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
 };
 
+struct pte_check_context {
+	struct collapse_control *cc;
+	struct vm_area_struct *vma;
+	unsigned int order;
+	struct folio *folio;
+	int none_or_zero;
+	int shared;
+	int unmapped;
+	enum scan_result result;
+	unsigned int max_ptes_none;
+	unsigned int max_ptes_swap;
+	unsigned int max_ptes_shared;
+};
+
 /**
  * struct khugepaged_scan - cursor for scanning
  * @mm_head: the head of the mm list to scan
@@ -696,75 +716,132 @@ static void count_collapse_event(unsigne
 	count_mthp_stat(order, mthp_event);
 }
 
+/*
+ * pte_check_fail() - A simple helper to set the pte_check_context result and
+ * return PTE_CHECK_FAIL.
+ */
+static enum pte_check_result pte_check_fail(struct pte_check_context *ctx,
+		enum scan_result result)
+{
+	ctx->result = result;
+	return PTE_CHECK_FAIL;
+}
+
+/*
+ * collapse_check_pte() - Check if a PTE is suitable for collapse
+ *
+ * Check if a PTE is suitable for collapse based on the following criteria:
+ * - max_pte_* values are not exceeded
+ * - uffd is not active
+ * - lazyfree properties are not present
+ * - only anonymous pages are present
+ *
+ * a helper struct pte_check_context is used to pass and store relevant
+ * information between the collapse_check_pte() function and the caller.
+ *
+ * Return: PTE_CHECK_SUCCEED if the PTE is suitable for collapse,
+ *         PTE_CHECK_FAIL if the PTE is not suitable for collapse,
+ *         PTE_CHECK_CONTINUE if the scan should continue to check the next PTE.
+ */
+static enum pte_check_result collapse_check_pte(pte_t pteval,
+		unsigned long addr, struct pte_check_context *ctx)
+{
+	if (pte_none_or_zero(pteval)) {
+		if (++ctx->none_or_zero > ctx->max_ptes_none) {
+			count_collapse_event(ctx->order, THP_SCAN_EXCEED_NONE_PTE,
+					     MTHP_STAT_COLLAPSE_EXCEED_NONE);
+			return pte_check_fail(ctx, SCAN_EXCEED_NONE_PTE);
+		}
+		return PTE_CHECK_CONTINUE;
+	}
+	if (!pte_present(pteval)) {
+		if (ctx->unmapped == -1)
+			return pte_check_fail(ctx, SCAN_PTE_NON_PRESENT);
+		if (++ctx->unmapped > ctx->max_ptes_swap) {
+			count_collapse_event(ctx->order, THP_SCAN_EXCEED_SWAP_PTE,
+					     MTHP_STAT_COLLAPSE_EXCEED_SWAP);
+			return pte_check_fail(ctx, SCAN_EXCEED_SWAP_PTE);
+		}
+		if (pte_swp_uffd_any(pteval))
+			return pte_check_fail(ctx, SCAN_PTE_UFFD);
+		return PTE_CHECK_CONTINUE;
+	}
+	/*
+	 * Don't collapse if any of the small PTEs are armed with uffd
+	 * write protection. Marking the new huge pmd as write protected
+	 * could bring userfault messages that fall outside of the
+	 * registered range.
+	 */
+	if (pte_uffd(pteval))
+		return pte_check_fail(ctx, SCAN_PTE_UFFD);
+
+	ctx->folio = vm_normal_folio(ctx->vma, addr, pteval);
+	if (unlikely(!ctx->folio) || unlikely(folio_is_zone_device(ctx->folio)))
+		return pte_check_fail(ctx, SCAN_PAGE_NULL);
+
+	/*
+	 * If the vma has the VM_DROPPABLE flag, the collapse will
+	 * preserve the lazyfree property without needing to skip.
+	 */
+	if (ctx->cc->is_khugepaged && !(ctx->vma->vm_flags & VM_DROPPABLE) &&
+	    folio_test_lazyfree(ctx->folio) && !pte_dirty(pteval))
+		return pte_check_fail(ctx, SCAN_PAGE_LAZYFREE);
+
+	if (!folio_test_anon(ctx->folio)) {
+		VM_WARN_ON_FOLIO(!folio_test_anon(ctx->folio), ctx->folio);
+		return pte_check_fail(ctx, SCAN_PAGE_ANON);
+	}
+
+	if (folio_maybe_mapped_shared(ctx->folio)) {
+		/*
+		 * TODO: Support shared pages without leading to further
+		 * mTHP collapses. Currently bringing in new pages via
+		 * shared may cause a future higher order collapse on a
+		 * rescan of the same range.
+		 */
+		if (++ctx->shared > ctx->max_ptes_shared) {
+			count_collapse_event(ctx->order, THP_SCAN_EXCEED_SHARED_PTE,
+					     MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+			return pte_check_fail(ctx, SCAN_EXCEED_SHARED_PTE);
+		}
+	}
+
+	return PTE_CHECK_SUCCEED;
+}
+
 static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
 		unsigned int order, struct list_head *compound_pagelist)
 {
-	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, order);
-	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, order);
 	const unsigned long nr_pages = 1UL << order;
-	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr = start_addr;
-	pte_t *_pte;
-	int none_or_zero = 0, shared = 0, referenced = 0;
+	pte_t *_pte, pteval;
+	int referenced = 0;
 	enum scan_result result = SCAN_FAIL;
+	enum pte_check_result pte_check;
+	struct pte_check_context ctx = {
+		.cc = cc,
+		.vma = vma,
+		.order = order,
+		.unmapped = -1, /* don't check swap PTEs */
+		.max_ptes_none = collapse_max_ptes_none(cc, vma, order),
+		.max_ptes_shared = collapse_max_ptes_shared(cc, order),
+	};
 
 	for (_pte = pte; _pte < pte + nr_pages;
 	     _pte++, addr += PAGE_SIZE) {
-		pte_t pteval = ptep_get(_pte);
-		if (pte_none_or_zero(pteval)) {
-			if (++none_or_zero > max_ptes_none) {
-				result = SCAN_EXCEED_NONE_PTE;
-				count_collapse_event(order, THP_SCAN_EXCEED_NONE_PTE,
-						     MTHP_STAT_COLLAPSE_EXCEED_NONE);
-				goto out;
-			}
-			continue;
-		}
-		if (!pte_present(pteval)) {
-			result = SCAN_PTE_NON_PRESENT;
-			goto out;
-		}
-		if (pte_uffd(pteval)) {
-			result = SCAN_PTE_UFFD;
-			goto out;
-		}
-		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
-			result = SCAN_PAGE_NULL;
+		pteval = ptep_get(_pte);
+		pte_check = collapse_check_pte(pteval, addr, &ctx);
+		folio = ctx.folio;
+		if (pte_check == PTE_CHECK_FAIL) {
+			result = ctx.result;
 			goto out;
 		}
-
-		folio = page_folio(page);
-		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
+		if (pte_check == PTE_CHECK_CONTINUE)
+			continue;
 
 		/*
-		 * If the vma has the VM_DROPPABLE flag, the collapse will
-		 * preserve the lazyfree property without needing to skip.
-		 */
-		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
-		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
-			result = SCAN_PAGE_LAZYFREE;
-			goto out;
-		}
-
-		/* See collapse_scan_pmd(). */
-		if (folio_maybe_mapped_shared(folio)) {
-			/*
-			 * TODO: Support shared pages without leading to further
-			 * mTHP collapses. Currently bringing in new pages via
-			 * shared may cause a future higher order collapse on a
-			 * rescan of the same range.
-			 */
-			if (++shared > max_ptes_shared) {
-				result = SCAN_EXCEED_SHARED_PTE;
-				count_collapse_event(order, THP_SCAN_EXCEED_SHARED_PTE,
-						     MTHP_STAT_COLLAPSE_EXCEED_SHARED);
-				goto out;
-			}
-		}
-		/*
 		 * TODO: In some cases of partially-mapped folios, we'd actually
 		 * want to collapse.
 		 */
@@ -841,13 +918,13 @@ next:
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
-		trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
+		trace_mm_collapse_huge_page_isolate(folio, ctx.none_or_zero,
 						    referenced, result, order);
 		return result;
 	}
 out:
 	release_pte_pages(pte, _pte, compound_pagelist);
-	trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
+	trace_mm_collapse_huge_page_isolate(folio, ctx.none_or_zero,
 					    referenced, result, order);
 	return result;
 }
@@ -1459,7 +1536,7 @@ static enum scan_result collapse_huge_pa
 			spin_lock_nested(pte_ptl, SINGLE_DEPTH_NESTING);
 		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
 		map_anon_folio_pte_nopf(folio, pte, vma, start_addr,
-					  /*uffd_wp=*/ false);
+					  /*uffd=*/ false);
 		if (pte_ptl != pmd_ptl)
 			spin_unlock(pte_ptl);
 	}
@@ -1613,24 +1690,30 @@ static enum scan_result collapse_scan_pm
 		struct vm_area_struct *vma, unsigned long start_addr,
 		bool *lock_dropped, struct collapse_control *cc)
 {
-	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
-	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
-	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
 	enum tva_type tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
 	pmd_t *pmd;
 	pte_t *pte, *_pte, pteval;
 	int i;
-	int none_or_zero = 0, shared = 0, referenced = 0;
-	enum scan_result result = SCAN_FAIL;
-	struct page *page = NULL;
 	struct folio *folio = NULL;
+	int referenced = 0;
+	enum scan_result result = SCAN_FAIL;
 	unsigned long addr;
 	unsigned long enabled_orders;
 	spinlock_t *ptl;
-	int node = NUMA_NO_NODE, unmapped = 0;
+	int node = NUMA_NO_NODE;
+	enum pte_check_result pte_check;
 
 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
 
+	struct pte_check_context ctx = {
+		.cc = cc,
+		.vma = vma,
+		.order = HPAGE_PMD_ORDER,
+		.max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER),
+		.max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER),
+		.max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER),
+	};
+
 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
 	if (result != SCAN_SUCCEED) {
 		cc->progress++;
@@ -1647,7 +1730,7 @@ static enum scan_result collapse_scan_pm
 	 * is then checked again in mthp_collapse() for each attempted order.
 	 */
 	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
-		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
+		ctx.max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
 
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
@@ -1663,81 +1746,14 @@ static enum scan_result collapse_scan_pm
 
 		cc->progress++;
 
-		if (pte_none_or_zero(pteval)) {
-			if (++none_or_zero > max_ptes_none) {
-				result = SCAN_EXCEED_NONE_PTE;
-				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_NONE_PTE,
-						     MTHP_STAT_COLLAPSE_EXCEED_NONE);
-				goto out_unmap;
-			}
-			continue;
-		}
-		if (!pte_present(pteval)) {
-			if (++unmapped > max_ptes_swap) {
-				result = SCAN_EXCEED_SWAP_PTE;
-				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SWAP_PTE,
-						     MTHP_STAT_COLLAPSE_EXCEED_SWAP);
-				goto out_unmap;
-			}
-			/*
-			 * Always be strict with uffd-wp
-			 * enabled swap entries.  Please see
-			 * comment below for pte_uffd().
-			 */
-			if (pte_swp_uffd_any(pteval)) {
-				result = SCAN_PTE_UFFD;
-				goto out_unmap;
-			}
-			continue;
-		}
-		if (pte_uffd(pteval)) {
-			/*
-			 * Don't collapse the page if any of the small
-			 * PTEs are armed with uffd write protection.
-			 * Here we can also mark the new huge pmd as
-			 * write protected if any of the small ones is
-			 * marked but that could bring unknown
-			 * userfault messages that falls outside of
-			 * the registered range.  So, just be simple.
-			 */
-			result = SCAN_PTE_UFFD;
-			goto out_unmap;
-		}
-
-		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
-			result = SCAN_PAGE_NULL;
-			goto out_unmap;
-		}
-		folio = page_folio(page);
-
-		/*
-		 * If the vma has the VM_DROPPABLE flag, the collapse will
-		 * preserve the lazyfree property without needing to skip.
-		 */
-		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
-		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
-			result = SCAN_PAGE_LAZYFREE;
-			goto out_unmap;
-		}
-
-		if (!folio_test_anon(folio)) {
-			result = SCAN_PAGE_ANON;
+		pte_check = collapse_check_pte(pteval, addr, &ctx);
+		folio = ctx.folio;
+		if (pte_check == PTE_CHECK_FAIL) {
+			result = ctx.result;
 			goto out_unmap;
 		}
-
-		/*
-		 * We treat a single page as shared if any part of the THP
-		 * is shared.
-		 */
-		if (folio_maybe_mapped_shared(folio)) {
-			if (++shared > max_ptes_shared) {
-				result = SCAN_EXCEED_SHARED_PTE;
-				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SHARED_PTE,
-						     MTHP_STAT_COLLAPSE_EXCEED_SHARED);
-				goto out_unmap;
-			}
-		}
+		if (pte_check == PTE_CHECK_CONTINUE)
+			continue;
 
 		/* Set bit for occupied pages */
 		__set_bit(i, cc->mthp_present_ptes);
@@ -1780,7 +1796,7 @@ static enum scan_result collapse_scan_pm
 	}
 	if (cc->is_khugepaged &&
 		   (!referenced ||
-		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
+		    (ctx.unmapped && referenced < HPAGE_PMD_NR / 2))) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -1791,13 +1807,13 @@ out_unmap:
 		/* collapse_huge_page() expects the lock to be dropped before calling */
 		mmap_read_unlock(mm);
 		result = mthp_collapse(mm, start_addr, referenced,
-				       unmapped, cc, enabled_orders);
+				       ctx.unmapped, cc, enabled_orders);
 		/* mmap_lock was released above, set lock_dropped */
 		*lock_dropped = true;
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
-				     none_or_zero, result, unmapped);
+				     ctx.none_or_zero, result, ctx.unmapped);
 	return result;
 }
 
_

Patches currently in -mm which might be from nico.pache@linux.dev are

mm-khugepaged-refactor-per-scan-state-clearing-into-collapse_control_init_scan.patch
mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper.patch
mm-khugepaged-introduce-a-count_collapse_event-helper.patch
mm-khugepaged-fix-outdated-comments.patch
mm-khugepaged-refactor-the-pte-state-checks-into-a-helper.patch
mm-khugepaged-unmap-pte-before-releasing-vma-write-lock.patch
mm-documentation-clarify-where-the-mthp-stats-live.patch

