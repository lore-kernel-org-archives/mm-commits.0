Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773542E5B2A;
	Wed,  7 Oct 2026 00:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334201; cv=none; b=nvYodfwPIAb2nFOth6aSK18NBfaal94B5SYsXfSQGPsqR8/djNelNLZSZyPI0bLD5O2sREr0d+f4xs2mue3zlNiT5OxNaEDi3Pq+6OrUPT0FPKMkjDGW9qo+AHF9GM/nSdItVUxd5OC+S+ytQ6Xuhzx0BKWXAbU9xKRUVSMw8sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334201; c=relaxed/simple;
	bh=gbGjbDk3X+Elbk3Vjs0zehrDvZoU+KpNtOqPuEcUgh0=;
	h=Date:To:From:Subject:Message-Id; b=r+GLL4WDLxM9SCQcWL5u7z6ezMnlP8s2D1Xomlyxyesg9Lpd0YGFxdjvvIyB87oRMmriqRWv/6j0jLRnkcD97DErWBJVSWanlnddZJIZ2YeQ7yEt1gYtXsHbSyEBELPl73WqS3d9P09Wg8XLaYOpJI5tk0aynHaYslDc9Gsh0Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R7sszvd5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R7sszvd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA3D1F0089C;
	Wed,  7 Oct 2026 00:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334199;
	bh=LPK3iIREyP/pFNhck2hOb0I1XexJ242hGizUwAs+7ok=;
	h=Date:To:From:Subject;
	b=R7sszvd5UrJmPcI7mdCsk3UOPB38FJHjft7bR4R8ZZb6x9ZwLXkrlEF2pv4uqHgkO
	 GZR+TfOCMfuCCwBvTtowG06HGEE63MtBUAp9lBAFG8she3VjgOl+7YsRc3lo3UiV67
	 wK3flqGg2z/p+Xwe6KcFHTcxvecRM53tn4Tl+Gwg=
Date: Tue, 06 Oct 2026 17:49:58 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,stable@vger.kernel.org,ryan.roberts@arm.com,ljs@kernel.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baohua@kernel.org,yanglincheng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-fix-folio-is-used-after-pte_unmap_unlock.patch removed from -mm tree
Message-Id: <20261007004959.4AA3D1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: khugepaged: fix folio is used after pte_unmap_unlock()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-folio-is-used-after-pte_unmap_unlock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vernon Yang <yanglincheng@kylinos.cn>
Subject: mm: khugepaged: fix folio is used after pte_unmap_unlock()
Date: Wed, 9 Sep 2026 10:58:02 +0800

After the page table lock has dropped, the folio can be freed
concurrently.  The trace_mm_khugepaged_scan_pmd() is left with a dangling
folio pointer.

So using the folio_pfn() before dropping the page table lock, closing
use-after-free window.

And other pre-existing bug, When the `for (i = 0; i < HPAGE_PMD_NR; i++)`
iteration to terminate and the folio operation preceding is normal, but
pfn will be incorrect.  so we really only trace the PFN if it really was
problematic.

Link: https://lore.kernel.org/20260909025804.3233645-3-vernon2gm@gmail.com
Fixes: 7d2eba0557c1 ("mm: add tracepoint for scanning pages")
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: <stable@vger.kernel.org>
---

 include/trace/events/huge_memory.h |    6 +++---
 mm/khugepaged.c                    |   10 +++++++++-
 2 files changed, 12 insertions(+), 4 deletions(-)

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
 
@@ -1784,7 +1792,7 @@ out_unmap:
 		*lock_dropped = true;
 	}
 out:
-	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
+	trace_mm_khugepaged_scan_pmd(mm, failed_pfn, referenced,
 				     none_or_zero, result, unmapped);
 	return result;
 }
_

Patches currently in -mm which might be from yanglincheng@kylinos.cn are


