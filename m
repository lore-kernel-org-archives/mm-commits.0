Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848D537CD33
	for <mm-commits@vger.kernel.org>; Wed,  9 Sep 2026 06:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788936869; cv=none; b=DMF++0fcwWGSflxEhkMW65BWwqfM3ocNUWF1hHydkl7q7vI+Uvusd5nLVRyH61OFDZXDTDKx6OHVrrOLL9qEwZtAHuxxteli2jrUE4PUzEF2ADOL9zyC40GtOyG+JF7DfKPpp5hleNrxVF2X/RxEDyPkcg8KIK+MLrIWQSkihMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788936869; c=relaxed/simple;
	bh=aI1/MhvX5gjvfzAEqcYifMJBXQamTxK0Qzq3mjQ6AyU=;
	h=Date:To:From:Subject:Message-Id; b=VBWtMAkRLRIJ7cXAJ3w6X+Bzul1Kz+K3+mCl5eGiEsZSNgg/u1KLoQcXSKRxHw/5CyNroq6fuALtTnYuZ+LkNq1E7E+c2LtEO45mPsMSc8b1kB5KSCJd8fVlyw2+Vfn0GOWgE1qMaxf4MMVoBj1DwIZT9ePJWnEIhsrmLBsgKSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wNSZ3bf7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wNSZ3bf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120FA1F00A3A;
	Wed,  9 Sep 2026 06:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788936868;
	bh=UNcqouJB1KEbS4C8F3Hfnvr9Xpc5Ruhup5D8JqApxf0=;
	h=Date:To:From:Subject;
	b=wNSZ3bf7x83174EKKO4MJCwlnvzztVLb19MYG0Mx7yw3ZN4g72dQ13dFK8oriGdQr
	 6Km6UMU7CtAVCpqCPqRfTshxbNEM/ysL0VEkhL+Se23Sgcv5Gjyg3E453M+TaChVPe
	 DWeBljtbIVqrv5OvYnfAu/P+U0OUfkpO2b+Ulvn4=
Date: Tue, 08 Sep 2026 23:54:27 -0700
To: mm-commits@vger.kernel.org,yanglincheng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-fix-folio-is-used-after-pte_unmap_unlock.patch removed from -mm tree
Message-Id: <20260909065428.120FA1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: khugepaged: fix folio is used after pte_unmap_unlock()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-folio-is-used-after-pte_unmap_unlock.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Vernon Yang <yanglincheng@kylinos.cn>
Subject: mm: khugepaged: fix folio is used after pte_unmap_unlock()
Date: Fri, 28 Aug 2026 13:59:25 +0800

After the page table lock has dropped, the folio can be freed
concurrently.  The trace_mm_khugepaged_scan_pmd() is left with a dangling
folio pointer.

So using the folio_pfn() before dropping the page table lock, closing
use-after-free window.

And other pre-existing bug, When the `for (i = 0; i < HPAGE_PMD_NR; i++)`
iteration to terminate and the folio operation preceding is normal, but
pfn will be incorrect.  so we really only trace the PFN if it really was
problematic.

About calling the respective trace_xxx() functions separately on success
and failure, refer to [1].

Link: https://lore.kernel.org/20260828055926.346744-3-vernon2gm@gmail.com
Link: https://lore.kernel.org/linux-mm/ao6jVbVHLUmuY2UA@gremlin/ [1]
Fixes: 7d2eba0557c1 ("mm: add tracepoint for scanning pages")
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    6 +++---
 mm/khugepaged.c                    |   17 ++++++++++++++---
 2 files changed, 17 insertions(+), 6 deletions(-)

--- a/include/trace/events/huge_memory.h~mm-khugepaged-fix-folio-is-used-after-pte_unmap_unlock
+++ a/include/trace/events/huge_memory.h
@@ -55,10 +55,10 @@ SCAN_STATUS
 
 TRACE_EVENT(mm_khugepaged_scan_pmd,
 
-	TP_PROTO(struct mm_struct *mm, struct folio *folio,
+	TP_PROTO(struct mm_struct *mm, unsigned long pfn,
 		 int referenced, int none_or_zero, int status, int unmapped),
 
-	TP_ARGS(mm, folio, referenced, none_or_zero, status, unmapped),
+	TP_ARGS(mm, pfn, referenced, none_or_zero, status, unmapped),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
@@ -71,7 +71,7 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__entry->pfn = folio ? folio_pfn(folio) : -1;
+		__entry->pfn = pfn;
 		__entry->referenced = referenced;
 		__entry->none_or_zero = none_or_zero;
 		__entry->status = status;
--- a/mm/khugepaged.c~mm-khugepaged-fix-folio-is-used-after-pte_unmap_unlock
+++ a/mm/khugepaged.c
@@ -1612,6 +1612,7 @@ static enum scan_result collapse_scan_pm
 	enum scan_result result = SCAN_FAIL;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
+	unsigned long failed_pfn = -1;
 	unsigned long addr;
 	unsigned long enabled_orders;
 	spinlock_t *ptl;
@@ -1706,11 +1707,13 @@ static enum scan_result collapse_scan_pm
 		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 
 		if (!folio_test_anon(folio)) {
 			result = SCAN_PAGE_ANON;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 
@@ -1721,6 +1724,7 @@ static enum scan_result collapse_scan_pm
 		if (folio_maybe_mapped_shared(folio)) {
 			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
+				failed_pfn = folio_pfn(folio);
 				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SHARED_PTE,
 						     MTHP_STAT_COLLAPSE_EXCEED_SHARED);
 				goto out_unmap;
@@ -1738,15 +1742,18 @@ static enum scan_result collapse_scan_pm
 		node = folio_nid(folio);
 		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 		cc->node_load[node]++;
 		if (!folio_test_lru(folio)) {
 			result = SCAN_PAGE_LRU;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 		if (folio_test_locked(folio)) {
 			result = SCAN_PAGE_LOCK;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 
@@ -1759,6 +1766,7 @@ static enum scan_result collapse_scan_pm
 		 */
 		if (folio_expected_ref_count(folio) != folio_ref_count(folio)) {
 			result = SCAN_PAGE_COUNT;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 
@@ -1782,10 +1790,13 @@ out_unmap:
 				       unmapped, cc, enabled_orders);
 		/* mmap_lock was released above, set lock_dropped */
 		*lock_dropped = true;
-	}
+		trace_mm_khugepaged_scan_pmd(mm, -1, referenced, none_or_zero,
+					     SCAN_SUCCEED, unmapped);
+	} else {
 out:
-	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
-				     none_or_zero, result, unmapped);
+		trace_mm_khugepaged_scan_pmd(mm, failed_pfn, referenced,
+					     none_or_zero, result, unmapped);
+	}
 	return result;
 }
 
_

Patches currently in -mm which might be from yanglincheng@kylinos.cn are

x86-mm-fix-pmd_modify-dropping-the-dirty-bit.patch
mm-khugepaged-fix-folio-is-used-after-folio_put-unlock.patch

