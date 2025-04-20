Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D9D647
	for <mm-commits@vger.kernel.org>; Sun, 20 Apr 2025 22:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745187140; cv=none; b=roOY219dKC+wPazWPRlIXJCtURpgHTavpPb6SJ2eN/Ocj5WL7PvknqTRLQtBaTDVElY0Vw06wMSvwvF8/BSEmUSkVLsk9NYsQnEWcgXqzDUCwe0Jbx+W8A4jsUttoNbuJrAZQH2kn7emjFSCvoDopqvv8kOzJKOMBDjCKKTRhcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745187140; c=relaxed/simple;
	bh=+EVT4nfUUTQB/MfAwnUybX1YJZJZ/h9KPPhy8bBi+/I=;
	h=Date:To:From:Subject:Message-Id; b=Xe6WrkvR5XSg9cr6fkiUElTFleZDLHifoZ5Saj7G88q000Rg5t5Zlqk/07nn+H4HhJTPR3H+M1qceXPopncMIYhKDILZnwUVlbab9lcxiWJCciEN9Tvz6MGBziBiJdmvKkIEMggXLOuF8p2fhXj8cOCxq1zzi9p1/8L+InGC/ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ccT3oWrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ccT3oWrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D7CC4CEE2;
	Sun, 20 Apr 2025 22:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745187140;
	bh=+EVT4nfUUTQB/MfAwnUybX1YJZJZ/h9KPPhy8bBi+/I=;
	h=Date:To:From:Subject:From;
	b=ccT3oWrDd7DPjyNBf+CUraidrVSicpIwzvrmXbZIdN7A5jh4oMVSqbnAQe3YVu5cI
	 abkcj1rQq7a1OPHik5ES3pmIfPkZ4LsiuCWun9XmCPG+DzAbrsoZ+HRHIbAJvVCzL2
	 QrbxkYy2/qPH165XhicVFMMnEdwHhjrH8GuIl5as=
Date: Sun, 20 Apr 2025 15:12:19 -0700
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,willy@infradead.org,rostedt@goodmis.org,npache@redhat.com,mhiramat@kernel.org,mcgrof@kernel.org,david@redhat.com,dave@stgolabs.net,baolin.wang@linux.alibaba.com,a.manzanares@samsung.com,fan.ni@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-refactor-trace_mm_collapse_huge_page_isolate-to-take-folio-instead-of-page.patch added to mm-new branch
Message-Id: <20250420221219.E8D7CC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: refactor trace_mm_collapse_huge_page_isolate() to take folio instead of page
has been added to the -mm mm-new branch.  Its filename is
     khugepaged-refactor-trace_mm_collapse_huge_page_isolate-to-take-folio-instead-of-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-refactor-trace_mm_collapse_huge_page_isolate-to-take-folio-instead-of-page.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: khugepaged: refactor trace_mm_collapse_huge_page_isolate() to take folio instead of page
Date: Fri, 18 Apr 2025 11:34:20 -0700

trace_mm_collapse_huge_page_isolate() is only used in
__collapse_huge_page_isolate(), which passes in the head page of a folio,
so refactor it to take folio directly.

Link: https://lkml.kernel.org/r/20250418183920.273154-1-nifan.cxl@gmail.com
Signed-off-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Nico Pache <npache@redhat.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Mariano Pache <npache@redhat.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    6 +++---
 mm/khugepaged.c                    |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/trace/events/huge_memory.h~khugepaged-refactor-trace_mm_collapse_huge_page_isolate-to-take-folio-instead-of-page
+++ a/include/trace/events/huge_memory.h
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
--- a/mm/khugepaged.c~khugepaged-refactor-trace_mm_collapse_huge_page_isolate-to-take-folio-instead-of-page
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
_

Patches currently in -mm which might be from fan.ni@samsung.com are

mm-hugetlb-refactor-unmap_ref_private-to-take-folio-instead-of-page.patch
mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache.patch
khugepaged-refactor-trace_mm_collapse_huge_page_isolate-to-take-folio-instead-of-page.patch
khugepaged-refactor-trace_mm_khugepaged_scan_pmd-to-take-folio-instead-of-page.patch

