Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6486E382F13
	for <mm-commits@vger.kernel.org>; Wed,  9 Sep 2026 06:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788936868; cv=none; b=lOSQwkFhNPL78zcMCJVi4KdCh4oPsAJdQ10tmW52PFmrXqqORIjSS/hJPmaV/yxN9KnC5nh2pylsmgNp5RttaTrC8wvRTvJqGv8VpAJkStzRmCNzaMXWqbudDMx+XDl5Vn/ftCChAdP9D/epVB+pY3jViRNs+StfDdgNt558fsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788936868; c=relaxed/simple;
	bh=OfJ80FcB0TCucDvqhtKZ9pQmS1bT5f9hHopveOcDOXg=;
	h=Date:To:From:Subject:Message-Id; b=NKaaSkzjISP3eCs8IhxZ+AyMr4dKeKXEayXbqW4zWg6BdH3w89vyc4CQisISZkCylFhfck4RgzYzXIW1vxfm9ch2gTgpWgdU/GHUKkmhHhGYFBdCR4yFNgDyaEs49SCOaNA3nPr+B69VmtuGE13EiZ5R8nkewjrCEDmFjyu5pKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iFq5ByAz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iFq5ByAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47231F00A3D;
	Wed,  9 Sep 2026 06:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788936866;
	bh=ycbYFd/iavs4jTAk/JPcYWxokiS27gNsETMY6XTA+YM=;
	h=Date:To:From:Subject;
	b=iFq5ByAzqwpz1BE7hhHuohPNjkxnHPHARqh03C465eMad73zVjkL83kvABiKaNtwU
	 n3qEHaJ/zmtNBzImRpcEon+iH4luTUfDX4iLzGOt1j330WW3xLMjMuRS620s6haRCf
	 CAvrFXa4cGBl2g7HMr/jaYYMI3RoCsdz7zEr6Xdk=
Date: Tue, 08 Sep 2026 23:54:26 -0700
To: mm-commits@vger.kernel.org,yanglincheng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-fix-swap-entry-value-to-folio_pfn.patch removed from -mm tree
Message-Id: <20260909065426.D47231F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: khugepaged: fix swap entry value to folio_pfn()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-swap-entry-value-to-folio_pfn.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Vernon Yang <yanglincheng@kylinos.cn>
Subject: mm: khugepaged: fix swap entry value to folio_pfn()
Date: Fri, 28 Aug 2026 13:59:24 +0800

Patch series "mm: khugepaged: fix tracepoint UAF", v4.

The khugepaged tracepoints take a folio pointer and call folio_pfn(), but
by then the folio may no longer be valid: freed after folio_put(),
folio_unlock() or pte_unmap_unlock(), or not a folio at all but an
xarray-encoded swap entry.  On classic SPARSEMEM, dereferencing it oopses
khugepaged as soon as the trace event is enabled; on other memory models
it merely prints a bogus pfn.

Pass the pfn to the tracepoints directly, captured while the folio is
still pinned, closing the use-after-free windows in
mm_khugepaged_scan_file(), mm_khugepaged_scan_pmd() and
mm_khugepaged_collapse_file().


This patch (of 3):

When the swap entries found exceed max_ptes_swap, the loop is left via
break with folio still holding the xarray value that encodes the swap
entry, not valid folio pointer.

That value is passed to trace_mm_khugepaged_scan_file(), which feeds it to
folio_pfn().  On FLATMEM and SPARSEMEM_VMEMMAP, the page_to_pfn() is plain
pointer arithmetic, so the trace event merely prints bogus scan_pfn.  On
classic SPARSEMEM, the page_to_pfn() reads page->flags, dereferencing the
tiny encoded integer and oopsing khugepaged whenever the trace event is
enabled.

So when folio is the swap entry value, simply set pfn to -1, just like
exhausted scan naturally.

And the folio_put() has maybe dropped the last reference of folio.  The
trace_mm_khugepaged_scan_file() is left with a dangling folio pointer.  so
using the folio_pfn() before dropping the reference, closing
use-after-free window.

About calling the respective trace_xxx() functions separately on success
and failure, refer to [1].

Link: https://lore.kernel.org/20260828055926.346744-1-vernon2gm@gmail.com
Link: https://lore.kernel.org/20260828055926.346744-2-vernon2gm@gmail.com
Link: https://lore.kernel.org/linux-mm/ao6jVbVHLUmuY2UA@gremlin/ [1]
Fixes: d41fd2016ed0 ("mm/khugepaged: add tracepoint to hpage_collapse_scan_file()")
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    6 +++---
 mm/khugepaged.c                    |   11 ++++++++++-
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/include/trace/events/huge_memory.h~mm-khugepaged-fix-swap-entry-value-to-folio_pfn
+++ a/include/trace/events/huge_memory.h
@@ -178,10 +178,10 @@ TRACE_EVENT(mm_collapse_huge_page_swapin
 
 TRACE_EVENT(mm_khugepaged_scan_file,
 
-	TP_PROTO(struct mm_struct *mm, struct folio *folio, struct file *file,
+	TP_PROTO(struct mm_struct *mm, unsigned long pfn, struct file *file,
 		 int present, int swap, int result),
 
-	TP_ARGS(mm, folio, file, present, swap, result),
+	TP_ARGS(mm, pfn, file, present, swap, result),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
@@ -194,7 +194,7 @@ TRACE_EVENT(mm_khugepaged_scan_file,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__entry->pfn = folio ? folio_pfn(folio) : -1;
+		__entry->pfn = pfn;
 		__assign_str(filename);
 		__entry->present = present;
 		__entry->swap = swap;
--- a/mm/khugepaged.c~mm-khugepaged-fix-swap-entry-value-to-folio_pfn
+++ a/mm/khugepaged.c
@@ -2683,6 +2683,7 @@ static enum scan_result collapse_scan_fi
 	int present, swap;
 	int node = NUMA_NO_NODE;
 	enum scan_result result = SCAN_SUCCEED;
+	unsigned long failed_pfn = -1;
 
 	present = 0;
 	swap = 0;
@@ -2715,6 +2716,7 @@ static enum scan_result collapse_scan_fi
 
 		if (is_pmd_order(folio_order(folio))) {
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
+			failed_pfn = folio_pfn(folio);
 			/*
 			 * PMD-sized THP implies that we can only try
 			 * retracting the PTE table.
@@ -2726,6 +2728,7 @@ static enum scan_result collapse_scan_fi
 		node = folio_nid(folio);
 		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
+			failed_pfn = folio_pfn(folio);
 			folio_put(folio);
 			break;
 		}
@@ -2733,12 +2736,14 @@ static enum scan_result collapse_scan_fi
 
 		if (!folio_test_lru(folio)) {
 			result = SCAN_PAGE_LRU;
+			failed_pfn = folio_pfn(folio);
 			folio_put(folio);
 			break;
 		}
 
 		if (folio_expected_ref_count(folio) + 1 != folio_ref_count(folio)) {
 			result = SCAN_PAGE_COUNT;
+			failed_pfn = folio_pfn(folio);
 			folio_put(folio);
 			break;
 		}
@@ -2771,9 +2776,13 @@ static enum scan_result collapse_scan_fi
 		} else {
 			result = collapse_file(mm, addr, file, start, cc);
 		}
+		trace_mm_khugepaged_scan_file(mm, -1, file, present, swap,
+					      SCAN_SUCCEED);
+	} else {
+		trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present,
+					      swap, result);
 	}
 
-	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
 	return result;
 }
 
_

Patches currently in -mm which might be from yanglincheng@kylinos.cn are

x86-mm-fix-pmd_modify-dropping-the-dirty-bit.patch
mm-khugepaged-fix-folio-is-used-after-pte_unmap_unlock.patch
mm-khugepaged-fix-folio-is-used-after-folio_put-unlock.patch

