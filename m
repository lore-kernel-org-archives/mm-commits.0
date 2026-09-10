Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CD049B5DC
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 21:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789077374; cv=none; b=n4Aqfps3rNIi/6bBk5xDzUd/OmntrhPvkpBMrqlcovGnAmB40iyHUjrJvKMu091lAyzBcsq6aS+xptQ/QQsSUE+Y9C6L6eQB1+zb/p/8boDO60EjI/BOyuRqFbjm+HuSHbKjK61Eifex/RwZ6dLeRXliQWMyTNNtmovo2CGDHNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789077374; c=relaxed/simple;
	bh=c48dGXxXC9bmdx+B7V1QCfMAoAw1tbdVqSPDaFv4lao=;
	h=Date:To:From:Subject:Message-Id; b=fNTUoxp2H9rZhLFTy7wEOOyEwwrZLm7RC2z6S/cPglA5E9XBjRbgyOvdMo+JM4xB22hBl1Zs3l3+shQ1o864mjeP7Ui149jTzpE6suIxUyBl+QB7PBHrwN/rdDbo3Mzhl8eHYqQCzetAthRPMpSTyL/FEDiwyw71QGnfqALch34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ddIgUS2h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ddIgUS2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C272C1F000FF;
	Thu, 10 Sep 2026 21:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789077372;
	bh=n0sw02qeAw6su+qa7PAXfO/SH4dN8d3wOsxsRtUzY1I=;
	h=Date:To:From:Subject;
	b=ddIgUS2h9eeCtzaFvQXAIgPDXCMbmg2n0Y/P92u6PewRH2eCiEiuEMpv1WwR33LpF
	 YV/8S/A/dil57Gx23kAgSbQq362U+kE4lMxzMbmPZESP+FHK7AslccFAn+pMKdh4AP
	 /KsERyek1vcTscdK4KaudSxmE5cFjKNIvZJEbuuo=
Date: Thu, 10 Sep 2026 14:56:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch added to mm-new branch
Message-Id: <20260910215612.C272C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/collapse: work out the orders a VMA allows once per VMA
has been added to the -mm mm-new branch.  Its filename is
     mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch

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
Subject: mm/collapse: work out the orders a VMA allows once per VMA
Date: Thu, 10 Sep 2026 13:02:30 +0100

The scan asked collapse_possible_orders() for every PTE table, for an
answer that is a property of the VMA.  Both callers walk a VMA a table at
a time, so let them work it out once and pass the mask in.  It is only
good while the lock that produced it is held, so madvise_collapse() takes
it again after every collapse.

The mask is then sampled once per VMA rather than once per table.  A thp
enabled knob written during a walk takes effect one VMA later, and cannot
widen a collapse: hugepage_vma_revalidate() tests the order again under
the lock the collapse retakes.

Assisted-by: LLM
Link: https://lore.kernel.org/20260910120238.2529819-11-kirill@shutemov.name
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

 mm/khugepaged.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

--- a/mm/khugepaged.c~mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma
+++ a/mm/khugepaged.c
@@ -1551,12 +1551,12 @@ done:
 }
 
 static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
-		unsigned long start_addr, struct collapse_control *cc)
+		unsigned long start_addr, struct collapse_control *cc,
+		unsigned long enabled_orders)
 {
 	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
 	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
 	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
-	enum tva_type tva_flags = cc->policy.tva_type;
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t *pmd;
 	pte_t *pte, *_pte, pteval;
@@ -1567,7 +1567,6 @@ static enum scan_result collapse_scan_an
 	struct folio *folio = NULL;
 	unsigned long failed_pfn = -1;
 	unsigned long addr;
-	unsigned long enabled_orders;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
 
@@ -1581,8 +1580,6 @@ static enum scan_result collapse_scan_an
 
 	collapse_scan_reset(cc);
 
-	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
-
 	/*
 	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
 	 * scan all pages to populate the bitmap for mTHP collapse. The bitmap
@@ -2762,7 +2759,8 @@ static void collapse_control_release(str
 }
 
 static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
-		unsigned long addr, struct collapse_control *cc)
+		unsigned long addr, struct collapse_control *cc,
+		unsigned long orders)
 {
 	enum scan_result result;
 	pgoff_t pgoff;
@@ -2775,7 +2773,7 @@ static enum scan_result collapse_scan_pm
 	}
 
 	if (vma_is_anonymous(vma))
-		return collapse_scan_anon_pmd(vma, addr, cc);
+		return collapse_scan_anon_pmd(vma, addr, cc, orders);
 
 	pgoff = linear_page_index(vma, addr);
 	result = collapse_scan_file(vma->vm_mm, addr, vma->vm_file, pgoff, cc);
@@ -2896,15 +2894,17 @@ static void collapse_scan_mm_slot(unsign
 
 	vma_iter_init(&vmi, mm, khugepaged_scan.address);
 	for_each_vma(vmi, vma) {
-		unsigned long hstart, hend;
+		unsigned long hstart, hend, orders;
 
 		cond_resched();
 		if (unlikely(collapse_test_exit_or_disable(mm))) {
 			cc->progress++;
 			break;
 		}
-		if (!collapse_possible_orders(vma, vma->vm_flags,
-					      TVA_KHUGEPAGED)) {
+		/* One mask for the whole VMA */
+		orders = collapse_possible_orders(vma, vma->vm_flags,
+						  cc->policy.tva_type);
+		if (!orders) {
 			cc->progress++;
 			continue;
 		}
@@ -2933,7 +2933,7 @@ static void collapse_scan_mm_slot(unsign
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 
-			*result = collapse_scan_pmd(vma, addr, cc);
+			*result = collapse_scan_pmd(vma, addr, cc, orders);
 			/* Nothing to collapse here, and the lock is still ours */
 			if (*result != SCAN_SUCCEED) {
 				if (cc->progress >= progress_max)
@@ -3217,14 +3217,16 @@ int madvise_collapse(struct vm_area_stru
 {
 	struct collapse_control *cc;
 	struct mm_struct *mm = vma->vm_mm;
-	unsigned long hstart, hend, addr;
+	unsigned long hstart, hend, addr, orders;
 	enum scan_result last_fail = SCAN_FAIL;
 	int thps = 0;
 
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!collapse_possible_orders(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
+	orders = collapse_possible_orders(vma, vma->vm_flags,
+					  TVA_FORCED_COLLAPSE);
+	if (!orders)
 		return -EINVAL;
 
 	hstart = ALIGN(start, HPAGE_PMD_SIZE);
@@ -3262,9 +3264,11 @@ int madvise_collapse(struct vm_area_stru
 			}
 			vma = found;
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
+			orders = collapse_possible_orders(vma, vma->vm_flags,
+							  cc->policy.tva_type);
 		}
 
-		result = collapse_scan_pmd(vma, addr, cc);
+		result = collapse_scan_pmd(vma, addr, cc, orders);
 		/* Nothing to collapse here, and the lock is still ours */
 		if (result != SCAN_SUCCEED)
 			goto tally;
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

