Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80867399036;
	Fri, 28 Aug 2026 17:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787939606; cv=none; b=dvVWuCj6EuaMyRvo8OIg3q3Q6LTHwlDUe84MoTXzVvTaur9Mv1O5DzjFSp9zRC48Eqafy+LbvP1sXcpIvNeCma1FVghJS0dGmv7WFDqCT7471zDVtCZo6DO8eGA0d8S0krLPtYRZkne8dhqC1Qae3xJhSQ/EioSW7ZY1bgA9Mh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787939606; c=relaxed/simple;
	bh=vLBkDu3mDDpHLk0LBvswY4RJfk+o2CVUicZ/4Y3wH8A=;
	h=Date:To:From:Subject:Message-Id; b=bTGvu2LYoT8zMGNd+5jED2LkVbF4wOoKlerwgGUa99LB6UVB250AFfBP0PJK98n9l8lYpaO3kGqikuyzZZPGDYNNefhTH+drZa74sA3n+Dr3d8ZVMXkKTdd5Wa56egJs3aGacDHd9tHnKOfhYQJi1Z8SMkGJrUmo5Yyo+qvo7JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bkXyV1Nd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bkXyV1Nd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6341F000E9;
	Fri, 28 Aug 2026 17:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787939605;
	bh=ZMdLie5uyxKiwf5W5zN0C0vKeqnngG2Csd6Ee5cW0m8=;
	h=Date:To:From:Subject;
	b=bkXyV1Nd98f5UCXaN9D/NjTUJiF1qAoNVzIPlBR6QD0zA0rLw+OJT+HiMlI7aK1qz
	 tBR/f9J0X7Ur5XIEcrPu/Chmxe7hkysN0KgdWjgdfRq0QyoWpNfwHSPGRQ78yaQtLy
	 CReDS2e07H+ZZOLtP0VCsRIRZ/t9vcX1Y0IcPEz4=
Date: Fri, 28 Aug 2026 10:53:24 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,stable@vger.kernel.org,ryan.roberts@arm.com,ljs@kernel.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baohua@kernel.org,yanglincheng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-fix-folio-is-used-after-pte_unmap_unlock.patch added to mm-new branch
Message-Id: <20260828175325.1D6341F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: khugepaged: fix folio is used after pte_unmap_unlock()
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-fix-folio-is-used-after-pte_unmap_unlock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-fix-folio-is-used-after-pte_unmap_unlock.patch

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

mm-khugepaged-fix-swap-entry-value-to-folio_pfn.patch
mm-khugepaged-fix-folio-is-used-after-pte_unmap_unlock.patch
mm-khugepaged-fix-folio-is-used-after-folio_put-unlock.patch

