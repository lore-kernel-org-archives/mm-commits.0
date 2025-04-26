Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC4F1957FC
	for <mm-commits@vger.kernel.org>; Sat, 26 Apr 2025 01:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745632580; cv=none; b=jhPPt1BsF6/w6QVpiu6DsooCklRfzCSdSMfk8Q8EGFH30CjIWvYpbJ9Npoq0jyjlRw80kamBY3HT8a1P34X7Dbdfl4Cw3QAgkoTba2ciJEiaiyFJsEMnxnVBfD71FtTLCix1HDP06pNm6O+thfN7gkca5H13DckcPdGIbLitass=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745632580; c=relaxed/simple;
	bh=PJCIIsAyzWBpCdGgyknivkkWkiR3cCqBcTlFsX1iWno=;
	h=Date:To:From:Subject:Message-Id; b=t8pEVF5Wf76MpITr48Li/Wxp9LJytMU71nTlSlWw9R7kCI2FG+A0THacnhY7iLOnHJHJy3KOzuWcWaPfKlg6l3NEehQj8fnY9RssTG1LxCfAss58GpTeebh03GFHFYU8t2yHEIgkiSJq5vNMa+DeIdLRHk4n4xoLK3dgi/1AVPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p7QdRSXm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p7QdRSXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD152C4CEE4;
	Sat, 26 Apr 2025 01:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745632580;
	bh=PJCIIsAyzWBpCdGgyknivkkWkiR3cCqBcTlFsX1iWno=;
	h=Date:To:From:Subject:From;
	b=p7QdRSXmS1bWZohr4qRvxoSABFww3tGNyWca0y10mwVI3gwYXrOMox4Ly78TgIbuu
	 T60IRvJ4HMJQK7CTcOUTdW6wsfW6ql77JjGjQIGdcIidP9BBau5xc0g7vm10Rsd6OW
	 HF49IMtyTq8vc8RhDwVeDXwAK3xr1/S6i+fcTQyw=
Date: Fri, 25 Apr 2025 18:56:19 -0700
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,willy@infradead.org,rostedt@goodmis.org,npache@redhat.com,mhiramat@kernel.org,mcgrof@kernel.org,david@redhat.com,dave@stgolabs.net,baolin.wang@linux.alibaba.com,a.manzanares@samsung.com,fan.ni@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-pass-folio-instead-of-head-page-to-trace-events.patch added to mm-new branch
Message-Id: <20250426015619.DD152C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: pass folio instead of head page to trace events
has been added to the -mm mm-new branch.  Its filename is
     khugepaged-pass-folio-instead-of-head-page-to-trace-events.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-pass-folio-instead-of-head-page-to-trace-events.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache.patch
khugepaged-pass-folio-instead-of-head-page-to-trace-events.patch

