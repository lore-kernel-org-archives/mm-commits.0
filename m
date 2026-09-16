Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481A64D37C2
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 22:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789598548; cv=none; b=Zry+z9NkrJaxB/TxLYyUiW1vIthg7Dwu9ajiBixtsTMZLxQMWXo28+2wTbOIZqhaxhM/UZMhQBfJfTQpNOrudWO2/EZ/wotSwAvteDIuf8cmaS5I7RkXxsxjgtiPrCBZAxtpZgdHSLl9tL4iI3xOlDn5VbtfdKGGX5poS2tYf3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789598548; c=relaxed/simple;
	bh=C7ywpS3hhIt35K9B2FqiWEdFRbyLQOg7SNSVseUD7Kc=;
	h=Date:To:From:Subject:Message-Id; b=POIYTf0L7kprwgfFOHyocJiLAeECbsf28vQG9NMPsXjELAoT41/ehie117FUmLl9Vn3eUrq+V3skAP4UehWpiY7z0jguXtpzDIR8JWzRNYQgQLPDda28iRxRQe0W7vPuycjziMLjwkgj1qN99ZXIoe3P0hTsUPCiVBeZyW+NhAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lo6gYpLo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lo6gYpLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA7C1F0089E;
	Wed, 16 Sep 2026 22:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789598527;
	bh=mnSjAKB8Muu5QmUoeaFzVwGQcPVfgBQsWLXCEEkQX5A=;
	h=Date:To:From:Subject;
	b=Lo6gYpLoBB+FACN/bzb6IiMVha2du8s38F9DYQQyt1A0cZ9t1ayrY343t+4ghIe4A
	 WNMKLPoXOn3m2Ia7NGqdZgOmN5xQuZ//C34rgAG/Le8JJPRT2068orlBCvq0io33ft
	 O+sp1lO98ooWfR5TvGJZKvVTCAT6eKjFbTy9rNlQ=
Date: Wed, 16 Sep 2026 15:42:06 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch removed from -mm tree
Message-Id: <20260916224207.0BA7C1F0089E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/collapse: work out the orders a VMA allows once per VMA
has been removed from the -mm tree.  Its filename was
     mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch

This patch was dropped because an updated version will be issued

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
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
@@ -2755,7 +2752,8 @@ static void collapse_control_release(str
 }
 
 static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
-		unsigned long addr, struct collapse_control *cc)
+		unsigned long addr, struct collapse_control *cc,
+		unsigned long orders)
 {
 	enum scan_result result;
 	pgoff_t pgoff;
@@ -2768,7 +2766,7 @@ static enum scan_result collapse_scan_pm
 	}
 
 	if (vma_is_anonymous(vma))
-		return collapse_scan_anon_pmd(vma, addr, cc);
+		return collapse_scan_anon_pmd(vma, addr, cc, orders);
 
 	pgoff = linear_page_index(vma, addr);
 	result = collapse_scan_file(vma->vm_mm, addr, vma->vm_file, pgoff, cc);
@@ -2889,15 +2887,17 @@ static void collapse_scan_mm_slot(unsign
 
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
@@ -2926,7 +2926,7 @@ static void collapse_scan_mm_slot(unsign
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 
-			*result = collapse_scan_pmd(vma, addr, cc);
+			*result = collapse_scan_pmd(vma, addr, cc, orders);
 			/* Nothing to collapse here, and the lock is still ours */
 			if (*result != SCAN_SUCCEED) {
 				if (cc->progress >= progress_max)
@@ -3210,14 +3210,16 @@ int madvise_collapse(struct vm_area_stru
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
@@ -3255,9 +3257,11 @@ int madvise_collapse(struct vm_area_stru
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
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch
a.patch

