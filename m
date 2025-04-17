Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E105719CC0A
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 20:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744921824; cv=none; b=f61RKyEvdLey7z5qZLWUTqPl8e4iC7vlonjXxy77AQafYTwz/9IuI5IHH8ZN3404FMjdlIYvPeEH3Hiegj51zsEzfefXqc1thpGX6wxpGyALg5IgmcyJz6BKLyq7mUTi1UAzlJ16jzPpqVNbFqmuvbjKLhI+93IDYnymt11ZnMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744921824; c=relaxed/simple;
	bh=2n/3tdN8WvTZp+z2OJngs8jztW7eN3rsbLeoQv+ReBc=;
	h=Date:To:From:Subject:Message-Id; b=IlMYxd3/Mcbq1w3z2XYtwrhHTidIndkzYFBuK1zWr3UHwhit+wMvr1vxlweHB5ZATUiX7xAcnLCbcUezHpHgZiFK83QhFxr/TdBVFJv4Ukw6EWKCpMPdwv9/RKtgwmByiabA4KUDRZe8Ovwp54O+9nFwzchlwJcP9hX7dhz2F7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t1jjJVGE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t1jjJVGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463D2C4CEE4;
	Thu, 17 Apr 2025 20:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744921823;
	bh=2n/3tdN8WvTZp+z2OJngs8jztW7eN3rsbLeoQv+ReBc=;
	h=Date:To:From:Subject:From;
	b=t1jjJVGEFjnHCf7mSyayyIK92VpIfP+Lw3Omx5oc2elrOw4K6gQy2wN9OzJkF4u/j
	 sSYYiI1piT5whla2ZmiWfoQJbMOt6E5xHqOmzGUQFUCDLV2VhS1S1kmYHDF6SLISPt
	 ZcsfPeY4Z9VQhC6JYFGziLoZFYbL/MvT42Yu+nLk=
Date: Thu, 17 Apr 2025 13:30:22 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,muchun.song@linux.dev,mcgrof@kernel.org,david@redhat.com,dave@stgolabs.net,a.manzanares@samsung.com,fan.ni@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page.patch added to mm-unstable branch
Message-Id: <20250417203023.463D2C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: refactor unmap_hugepage_range() to take folio instead of page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm/hugetlb: refactor unmap_hugepage_range() to take folio instead of page
Date: Thu, 17 Apr 2025 08:43:14 -0700

The function unmap_hugepage_range() has two kinds of users:
1) unmap_ref_private(), which passes in the head page of a folio.  Since
   unmap_ref_private() already takes folio and there are no other uses
   of the folio struct in the function, it is natural for
   unmap_hugepage_range() to take folio also.
2) All other uses, which pass in NULL pointer.

In both cases, we can pass in folio. Refactor unmap_hugepage_range() to
take folio.

Link: https://lkml.kernel.org/r/20250417155530.124073-2-nifan.cxl@gmail.com
Signed-off-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 mm/hugetlb.c            |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page
+++ a/include/linux/hugetlb.h
@@ -128,7 +128,7 @@ int move_hugetlb_page_tables(struct vm_a
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *,
 			    struct vm_area_struct *, struct vm_area_struct *);
 void unmap_hugepage_range(struct vm_area_struct *,
-			  unsigned long, unsigned long, struct page *,
+			  unsigned long, unsigned long, struct folio *folio,
 			  zap_flags_t);
 void __unmap_hugepage_range(struct mmu_gather *tlb,
 			  struct vm_area_struct *vma,
--- a/mm/hugetlb.c~mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page
+++ a/mm/hugetlb.c
@@ -6014,7 +6014,7 @@ void __hugetlb_zap_end(struct vm_area_st
 }
 
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
-			  unsigned long end, struct page *ref_page,
+			  unsigned long end, struct folio *ref_folio,
 			  zap_flags_t zap_flags)
 {
 	struct mmu_notifier_range range;
@@ -6026,7 +6026,8 @@ void unmap_hugepage_range(struct vm_area
 	mmu_notifier_invalidate_range_start(&range);
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 
-	__unmap_hugepage_range(&tlb, vma, start, end, ref_page, zap_flags);
+	__unmap_hugepage_range(&tlb, vma, start, end,
+			       folio_page(ref_folio, 0), zap_flags);
 
 	mmu_notifier_invalidate_range_end(&range);
 	tlb_finish_mmu(&tlb);
@@ -6084,7 +6085,7 @@ static void unmap_ref_private(struct mm_
 		if (!is_vma_resv_set(iter_vma, HPAGE_RESV_OWNER))
 			unmap_hugepage_range(iter_vma, address,
 					     address + huge_page_size(h),
-					     folio_page(folio, 0), 0);
+					     folio, 0);
 	}
 	i_mmap_unlock_write(mapping);
 }
_

Patches currently in -mm which might be from fan.ni@samsung.com are

mm-hugetlb-refactor-unmap_ref_private-to-take-folio-instead-of-page.patch
mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache.patch
khugepaged-refactor-trace_mm_collapse_huge_page_isolate-to-take-folio-instead-of-page.patch

