Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545401D6DB4
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119247; cv=none; b=pWlpYAz+r0w0Q8WZA+5gZzLBsxULs/5flChKEGxOJcg6x+aTdfGjbwoAeHHDnqfXmUw4vwlHkxkiBAxStZrTiY3nB7/U4PTqavQ5LYCRqFgcugVKxZXem9+r+dAU8NtMMv4uGlY2FINGQJne9hppHdAQGwAWisezxr8zA0PnnMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119247; c=relaxed/simple;
	bh=76sV3ZfS15o8KqwdrdjHFtItOZXO3+m/GCgkFE2eaPU=;
	h=Date:To:From:Subject:Message-Id; b=Z5N4XDckwuE7JiP5S530rmCCmnVA5jBiQwTSR2DAAW3Gjj40siO3k6CtN0DUnsaA73Ax6I+Fq41A3nhC+oEJ+w2GMXfjW8bTH8m3uyXwlL8u/hHG77q24dauVMpNkXDP1lcOVCClJFsYyU1aIC4QtHAFys1usk6irxzsVeT+zbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xI0BF1Jq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xI0BF1Jq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294FCC4CEED;
	Tue, 13 May 2025 06:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119247;
	bh=76sV3ZfS15o8KqwdrdjHFtItOZXO3+m/GCgkFE2eaPU=;
	h=Date:To:From:Subject:From;
	b=xI0BF1JqFjkYp6DwUUyYKPUNcB8HubtQApzezjracNWuJZonJen6E3Pk/ZQP2uXxx
	 C3OnXWidC8QPyjk75nIkQVgDsTO73yiiiYY2HPiV1liRuIFFf8Fnxz4aQZY4RmiyGQ
	 51FGrUgxe/4ptElZY5e5nSvYTIbKrduvTFoVBbJc=
Date: Mon, 12 May 2025 23:54:06 -0700
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,willy@infradead.org,rostedt@goodmis.org,npache@redhat.com,mhiramat@kernel.org,mcgrof@kernel.org,david@redhat.com,dave@stgolabs.net,baolin.wang@linux.alibaba.com,a.manzanares@samsung.com,fan.ni@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] khugepaged-pass-folio-instead-of-head-page-to-trace-events.patch removed from -mm tree
Message-Id: <20250513065407.294FCC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: khugepaged: pass folio instead of head page to trace events
has been removed from the -mm tree.  Its filename was
     khugepaged-pass-folio-instead-of-head-page-to-trace-events.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Fan Ni <fan.ni@samsung.com>
Subject: khugepaged: pass folio instead of head page to trace events
Date: Thu, 24 Apr 2025 17:16:51 -0700

The trace functions trace_mm_collapse_huge_page_isolate() and
trace_mm_khugepaged_scan_pmd() each have a single user, which always
passes in the head page of a folio.  Refactor both functions to take a
folio directly.

Link: https://lkml.kernel.org/r/20250425002425.533698-1-nifan.cxl@gmail.com
Signed-off-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Nico Pache <npache@redhat.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Mariano Pache <npache@redhat.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |   12 ++++++------
 mm/khugepaged.c                    |    6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

--- a/include/trace/events/huge_memory.h~khugepaged-pass-folio-instead-of-head-page-to-trace-events
+++ a/include/trace/events/huge_memory.h
@@ -55,10 +55,10 @@ SCAN_STATUS
 
 TRACE_EVENT(mm_khugepaged_scan_pmd,
 
-	TP_PROTO(struct mm_struct *mm, struct page *page, bool writable,
+	TP_PROTO(struct mm_struct *mm, struct folio *folio, bool writable,
 		 int referenced, int none_or_zero, int status, int unmapped),
 
-	TP_ARGS(mm, page, writable, referenced, none_or_zero, status, unmapped),
+	TP_ARGS(mm, folio, writable, referenced, none_or_zero, status, unmapped),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
@@ -72,7 +72,7 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__entry->pfn = page ? page_to_pfn(page) : -1;
+		__entry->pfn = folio ? folio_pfn(folio) : -1;
 		__entry->writable = writable;
 		__entry->referenced = referenced;
 		__entry->none_or_zero = none_or_zero;
@@ -116,10 +116,10 @@ TRACE_EVENT(mm_collapse_huge_page,
 
 TRACE_EVENT(mm_collapse_huge_page_isolate,
 
-	TP_PROTO(struct page *page, int none_or_zero,
+	TP_PROTO(struct folio *folio, int none_or_zero,
 		 int referenced, bool  writable, int status),
 
-	TP_ARGS(page, none_or_zero, referenced, writable, status),
+	TP_ARGS(folio, none_or_zero, referenced, writable, status),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, pfn)
@@ -130,7 +130,7 @@ TRACE_EVENT(mm_collapse_huge_page_isolat
 	),
 
 	TP_fast_assign(
-		__entry->pfn = page ? page_to_pfn(page) : -1;
+		__entry->pfn = folio ? folio_pfn(folio) : -1;
 		__entry->none_or_zero = none_or_zero;
 		__entry->referenced = referenced;
 		__entry->writable = writable;
--- a/mm/khugepaged.c~khugepaged-pass-folio-instead-of-head-page-to-trace-events
+++ a/mm/khugepaged.c
@@ -696,13 +696,13 @@ next:
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
-		trace_mm_collapse_huge_page_isolate(&folio->page, none_or_zero,
+		trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
 						    referenced, writable, result);
 		return result;
 	}
 out:
 	release_pte_pages(pte, _pte, compound_pagelist);
-	trace_mm_collapse_huge_page_isolate(&folio->page, none_or_zero,
+	trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
 					    referenced, writable, result);
 	return result;
 }
@@ -1435,7 +1435,7 @@ out_unmap:
 		*mmap_locked = false;
 	}
 out:
-	trace_mm_khugepaged_scan_pmd(mm, &folio->page, writable, referenced,
+	trace_mm_khugepaged_scan_pmd(mm, folio, writable, referenced,
 				     none_or_zero, result, unmapped);
 	return result;
 }
_

Patches currently in -mm which might be from fan.ni@samsung.com are

mm-hugetlb-pass-folio-instead-of-page-to-unmap_ref_private.patch
mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-hugetlb-convert-use-of-struct-page-to-folio-in-__unmap_hugepage_range.patch

