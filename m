Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B30647
	for <mm-commits@vger.kernel.org>; Sun, 20 Apr 2025 22:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745187143; cv=none; b=Gbpm5ais+m5jMSgFVLY0dvkGifGjUbZ05fc180sINJ5Z9SAQVoI+glK8fzzshv+xLw6T3Sa5Edk3EXnZYPT2mUApA1+a7d5mZWYlIWgKvOC7xwEc/mqjM0i8SpCHFXPd0I5yej/Gp1I0ZmVzCBgfruv9FXoYTKtGGPeLCfXlKHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745187143; c=relaxed/simple;
	bh=CHyQlvEuoIxWjiMh3FGGrmu30n3IjJ5dqFPQEe5A0KA=;
	h=Date:To:From:Subject:Message-Id; b=o+nvqAke2pNZyePtGT0iT6Tjv4B1ZTR+M6ubh1CGsaFf3FNvd79ijrEsdCSz+uaK0f5sR3XzEr+CABOndK2rhjjtrPCbErg/GrsFdn6487mhyviV1wVZRjMoVwCi7LK1q6VXYO95c6Nw2bABddft438Y00R23+qoKlS2t7pxPBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H9T5eFLo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H9T5eFLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53306C4CEE2;
	Sun, 20 Apr 2025 22:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745187142;
	bh=CHyQlvEuoIxWjiMh3FGGrmu30n3IjJ5dqFPQEe5A0KA=;
	h=Date:To:From:Subject:From;
	b=H9T5eFLozM2Mxl2ouqwmykTd/+RXKDNhkSRaJbiDsJL97mc9QHSB1p9O0ndyjh/ES
	 Cq6wfXwGwmIKckvY9Py6OX3jldHadp3mFCUZ0bzeT3U/9wNzToJ9cdZTTF+t3UQFq0
	 Rxy/Yx1n7PyVeSvRvywxkQ0MGeDVhdA50hhAddgc=
Date: Sun, 20 Apr 2025 15:12:21 -0700
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,willy@infradead.org,rostedt@goodmis.org,npache@redhat.com,mhiramat@kernel.org,mcgrof@kernel.org,david@redhat.com,dave@stgolabs.net,baolin.wang@linux.alibaba.com,a.manzanares@samsung.com,fan.ni@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-refactor-trace_mm_khugepaged_scan_pmd-to-take-folio-instead-of-page.patch added to mm-new branch
Message-Id: <20250420221222.53306C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: refactor trace_mm_khugepaged_scan_pmd() to take folio instead of page
has been added to the -mm mm-new branch.  Its filename is
     khugepaged-refactor-trace_mm_khugepaged_scan_pmd-to-take-folio-instead-of-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-refactor-trace_mm_khugepaged_scan_pmd-to-take-folio-instead-of-page.patch

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
Subject: khugepaged: refactor trace_mm_khugepaged_scan_pmd() to take folio instead of page
Date: Fri, 18 Apr 2025 11:34:21 -0700

trace_mm_khugepaged_scan_pmd() is only called in
hpage_collapse_scan_pmd(), where the head page of a folio is passed in, so
refactor it to take folio directly.

Link: https://lkml.kernel.org/r/20250418183920.273154-2-nifan.cxl@gmail.com
Signed-off-by: Fan Ni <fan.ni@samsung.com>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Mariano Pache <npache@redhat.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    6 +++---
 mm/khugepaged.c                    |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/trace/events/huge_memory.h~khugepaged-refactor-trace_mm_khugepaged_scan_pmd-to-take-folio-instead-of-page
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
--- a/mm/khugepaged.c~khugepaged-refactor-trace_mm_khugepaged_scan_pmd-to-take-folio-instead-of-page
+++ a/mm/khugepaged.c
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

mm-hugetlb-refactor-unmap_ref_private-to-take-folio-instead-of-page.patch
mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache.patch
khugepaged-refactor-trace_mm_collapse_huge_page_isolate-to-take-folio-instead-of-page.patch
khugepaged-refactor-trace_mm_khugepaged_scan_pmd-to-take-folio-instead-of-page.patch

