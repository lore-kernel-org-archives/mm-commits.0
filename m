Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B3213AF2
	for <mm-commits@vger.kernel.org>; Mon,  5 May 2025 22:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746482631; cv=none; b=oViWqcq++gM0tBh3NCU/MF+thpgqZFRWgzP/gMWb3TP/6z90K3GPZm3lUotHRv3O1fEdFes+Qt/Wz2uoZuKav2TRUfZBoRonyUMaPBpE9s0798jtKiLD0Uh6eWu9PZls0uuc17lNxqjrcobIlOLyatsifh26WqCRxkoiyNZWQ9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746482631; c=relaxed/simple;
	bh=QA5Y98yetTO1fX7Bb+f9gc4b8YEVLxr0NYkoEyS0wp0=;
	h=Date:To:From:Subject:Message-Id; b=lB6FVo734T2z1D1qw+xVT6Vrk2rAzo7aL1DhmrgOOb+JwMWCcmbe6TthIwwyF+KHDFztHtfXB5cyioshWQM/YjaAfixgxVdNKrv90lOA7ZqqDzPG60WcwXg2q9GcFFnyNYI1cipFj5/QlrexZahvCkOmHd7vuEbeVjV4FVYnlIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UEl1a430; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UEl1a430"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B290AC4CEE4;
	Mon,  5 May 2025 22:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746482630;
	bh=QA5Y98yetTO1fX7Bb+f9gc4b8YEVLxr0NYkoEyS0wp0=;
	h=Date:To:From:Subject:From;
	b=UEl1a430AItqKXX4djybCrx4FnKTGRIit0RzTowVulSNldznYQ0aXQDTg2VDfL7bt
	 NUCpNV0V5ZG/7+oF3ns3/o32lNRmhAEOfrzVzN+XhMiVL8yHdXx6myxMFChYjFyLnZ
	 0U786zRPCJr8TmCFesGmCn1RRvx6CFoNTfuJppWw=
Date: Mon, 05 May 2025 15:03:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,fan.ni@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page.patch added to mm-unstable branch
Message-Id: <20250505220350.B290AC4CEE4@smtp.kernel.org>
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
Date: Mon, 5 May 2025 11:22:42 -0700

The function unmap_hugepage_range() has two kinds of users:
1) unmap_ref_private(), which passes in the head page of a folio.  Since
   unmap_ref_private() already takes folio and there are no other uses
   of the folio struct in the function, it is natural for
   unmap_hugepage_range() to take folio also.
2) All other uses, which pass in NULL pointer.

In both cases, we can pass in folio. Refactor unmap_hugepage_range() to
take folio.

Link: https://lkml.kernel.org/r/20250505182345.506888-4-nifan.cxl@gmail.com
Signed-off-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
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
@@ -6046,7 +6046,7 @@ void __hugetlb_zap_end(struct vm_area_st
 }
 
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
-			  unsigned long end, struct page *ref_page,
+			  unsigned long end, struct folio *folio,
 			  zap_flags_t zap_flags)
 {
 	struct mmu_notifier_range range;
@@ -6058,7 +6058,8 @@ void unmap_hugepage_range(struct vm_area
 	mmu_notifier_invalidate_range_start(&range);
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 
-	__unmap_hugepage_range(&tlb, vma, start, end, ref_page, zap_flags);
+	__unmap_hugepage_range(&tlb, vma, start, end,
+			       &folio->page, zap_flags);
 
 	mmu_notifier_invalidate_range_end(&range);
 	tlb_finish_mmu(&tlb);
@@ -6116,7 +6117,7 @@ static void unmap_ref_private(struct mm_
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

