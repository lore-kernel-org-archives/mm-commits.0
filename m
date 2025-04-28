Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCEA1A00E7
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 19:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745868847; cv=none; b=RNPnoHn0oRNZlqr6JVvYpVNqFwyiQ9oSQcGIC02GFcEnG/P7lcLTt3z/+DhFUYvjCCdKHXtwfy2pY7eVOE+SzFQuzNOoFUeAgV/+L371YO3zkbRoqFFXUALhTTx94OEWAbmRrjOH+1AhiOrGZFNYUGUcVOMxS7ly3m9j6gY8d+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745868847; c=relaxed/simple;
	bh=1GqX1sM5MWgVhrIYNePEfVzdj+BB3funS1hPus/RXbk=;
	h=Date:To:From:Subject:Message-Id; b=cTRJR0Jh4veutIYUWPHFuDz0OybRSRtg6fBo0QU+OM05pWvg6+2nJ53Xgj1noRo82rhIv+McaBXu7bAiInZJnG8dfwhC3nrPIB6esH7mn4k8tb8t1EUkH9TrRKSdI4WhQ55N+uTCOgV5bN+9G0zZ+xgHPD5AJ3/V91d3WLf6rU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f7Dk2/G8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f7Dk2/G8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45D8C4CEE4;
	Mon, 28 Apr 2025 19:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745868845;
	bh=1GqX1sM5MWgVhrIYNePEfVzdj+BB3funS1hPus/RXbk=;
	h=Date:To:From:Subject:From;
	b=f7Dk2/G8d3SQweyoQEwq1n+MSP3zyGrPGcY1DvQ3FAIFag70HaKzs4WSkeqG48zYj
	 Sa4LjTtWLAUjxlXGVLbzgpiq4iK3Wf1yvuH7YqFRlGtubJwuOZ8+L4wyK3eZxNwI8z
	 5KXoKyeTVFns1/A85ZnkOigXyiGW3V5D5QT2iHJA=
Date: Mon, 28 Apr 2025 12:34:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,muchun.song@linux.dev,mcgrof@kernel.org,david@redhat.com,dave@stgolabs.net,a.manzanares@samsung.com,fan.ni@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page.patch added to mm-new branch
Message-Id: <20250428193404.E45D8C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: refactor unmap_hugepage_range() to take folio instead of page
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page.patch

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
Subject: mm/hugetlb: refactor unmap_hugepage_range() to take folio instead of page
Date: Mon, 28 Apr 2025 10:11:45 -0700

unmap_hugepage_range() has two kinds of users:
1) unmap_ref_private(), which passes in the head page of a folio.  Since
   unmap_ref_private() already takes folio and there are no other uses
   of the folio struct in the function, it is natural for
   unmap_hugepage_range() to take folio also.
2) All other uses, which pass in NULL pointer.

In both cases, we can pass in folio.  Refactor unmap_hugepage_range() to
take folio.

Link: https://lkml.kernel.org/r/20250428171608.21111-5-nifan.cxl@gmail.com
Signed-off-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 ++--
 mm/hugetlb.c            |    7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page
+++ a/include/linux/hugetlb.h
@@ -129,8 +129,8 @@ int move_hugetlb_page_tables(struct vm_a
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *,
 			    struct vm_area_struct *, struct vm_area_struct *);
 void unmap_hugepage_range(struct vm_area_struct *,
-			  unsigned long, unsigned long, struct page *,
-			  zap_flags_t);
+			  unsigned long start, unsigned long end,
+			  struct folio *, zap_flags_t);
 void __unmap_hugepage_range(struct mmu_gather *tlb,
 			  struct vm_area_struct *vma,
 			  unsigned long start, unsigned long end,
--- a/mm/hugetlb.c~mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page
+++ a/mm/hugetlb.c
@@ -6040,7 +6040,7 @@ void __hugetlb_zap_end(struct vm_area_st
 }
 
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
-			  unsigned long end, struct page *ref_page,
+			  unsigned long end, struct folio *folio,
 			  zap_flags_t zap_flags)
 {
 	struct mmu_notifier_range range;
@@ -6052,7 +6052,8 @@ void unmap_hugepage_range(struct vm_area
 	mmu_notifier_invalidate_range_start(&range);
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 
-	__unmap_hugepage_range(&tlb, vma, start, end, ref_page, zap_flags);
+	__unmap_hugepage_range(&tlb, vma, start, end,
+			       &folio->page, zap_flags);
 
 	mmu_notifier_invalidate_range_end(&range);
 	tlb_finish_mmu(&tlb);
@@ -6110,7 +6111,7 @@ static void unmap_ref_private(struct mm_
 		if (!is_vma_resv_set(iter_vma, HPAGE_RESV_OWNER))
 			unmap_hugepage_range(iter_vma, address,
 					     address + huge_page_size(h),
-					     &folio->page, 0);
+					     folio, 0);
 	}
 	i_mmap_unlock_write(mapping);
 }
_

Patches currently in -mm which might be from fan.ni@samsung.com are

mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache.patch
khugepaged-pass-folio-instead-of-head-page-to-trace-events.patch
mm-hugetlb-pass-folio-instead-of-page-to-unmap_ref_private.patch
mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-hugetlb-convert-use-of-struct-page-to-folio-in-__unmap_hugepage_range.patch

