Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A162EFD95;
	Wed,  7 Oct 2026 00:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334200; cv=none; b=P6tCDggi6gC+5SBwP0Knndm2I8NXWrwJMEJLznAEiam0MArQWIQJUQEys48E17drLvV2vsCixm3tlrecQB/Y0jXFRQtYk5EP1UxBG8lxw3xMu81TAle/jkYzkXttEu+YHQEoKieAgamds6DPWCqDSdcHaJ2yfRp/YwY6KllAuAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334200; c=relaxed/simple;
	bh=H3DzCo9uhi9f80w/cV9chUvOC+IUwWDdPmpZCzy4ke8=;
	h=Date:To:From:Subject:Message-Id; b=Xr2k2ZWkK9sAHORXXod8jPLMTNzlcOFKio2xuHvyi+k5LFYXTcbhtPrKd65U52+9Ks+yPC2X0zqlahoRxQ7Vo51TZMX/u4ngeNeNhY1WhLcmFJ7yTS1pFvdQRaZluFWMvPXoc/a6bcZP6Q7GrRQodRQH5k5+2QqxFxQhvCC/kqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oZSOn0qD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oZSOn0qD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA031F0089B;
	Wed,  7 Oct 2026 00:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334197;
	bh=sgGeHsLu/zTC6nKKn6Co9AtOtazoKFNgdmcgc71+sOw=;
	h=Date:To:From:Subject;
	b=oZSOn0qD99Pyfw2fYOGzhc7Saa/xZi+YwlUnwk1DjgxiF0Z8J+QIdtWekjljRVmIm
	 1gLxV17uvDIACHlKaqbXcA+NRGWBL/C0aelvUxf/wqqAdAVZo9ayv9/IjVG7S/uzRO
	 zD2omPxYrgtftg2cXmdkAceHVawWaJL70LCtMCH0=
Date: Tue, 06 Oct 2026 17:49:57 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,stable@vger.kernel.org,ryan.roberts@arm.com,ljs@kernel.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baohua@kernel.org,yanglincheng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-fix-swap-entry-value-to-folio_pfn.patch removed from -mm tree
Message-Id: <20261007004957.CCA031F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: khugepaged: fix swap entry value to folio_pfn()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-swap-entry-value-to-folio_pfn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vernon Yang <yanglincheng@kylinos.cn>
Subject: mm: khugepaged: fix swap entry value to folio_pfn()
Date: Wed, 9 Sep 2026 10:58:01 +0800

Patch series "mm: khugepaged: fix tracepoint UAF", v5.

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

Link: https://lore.kernel.org/20260909025804.3233645-1-vernon2gm@gmail.com
Link: https://lore.kernel.org/20260909025804.3233645-2-vernon2gm@gmail.com
Fixes: d41fd2016ed0 ("mm/khugepaged: add tracepoint to hpage_collapse_scan_file()")
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: <stable@vger.kernel.org>
---

 include/trace/events/huge_memory.h |    6 +++---
 mm/khugepaged.c                    |    7 ++++++-
 2 files changed, 9 insertions(+), 4 deletions(-)

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
@@ -2773,7 +2778,7 @@ static enum scan_result collapse_scan_fi
 		}
 	}
 
-	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
+	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present, swap, result);
 	return result;
 }
 
_

Patches currently in -mm which might be from yanglincheng@kylinos.cn are


