Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908512BD1B
	for <mm-commits@vger.kernel.org>; Wed, 28 May 2025 02:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748399956; cv=none; b=fLT5qwXSl8oYBG+RYl+ePffxvsgTDa5sCSepSEE1PDFHMnPrU0egasj0RGi7MLqxlJwql9WVPrOiiYdtSi7y1IG6ZRFa+BE2pVDsDr/AB0pxi3lewlp1oqFdlpa6GA7xlPN3yex1Zp6fNdA5W+R5Eoj63CB1RJlKsQVHurcW5J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748399956; c=relaxed/simple;
	bh=LIXTvnalUyw010xmB7V4cMnS/7Vwo/LxcDsHR3ijMWs=;
	h=Date:To:From:Subject:Message-Id; b=QaIEGYGRB1GOodAx0l6/dockZG7uH6nuRmaGW24mFZ7emmKuXIHE8iUtpcrvXock7VdRdk0ZqIimqu53IaBPben2tjKakpn3sg/Qhc1AW7Pyy6XRS2XxDYUuR55Y/DzJgesPa7nbAIDhuD7+ffDOZxvsfU990SGQAbObK2OPYJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DQzLO6g8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DQzLO6g8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78F4C4CEEA;
	Wed, 28 May 2025 02:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748399956;
	bh=LIXTvnalUyw010xmB7V4cMnS/7Vwo/LxcDsHR3ijMWs=;
	h=Date:To:From:Subject:From;
	b=DQzLO6g8SPnEXTG1R8NDlbr45EoLqnot8iaNXSIENPsvXtypQYMoiUtgzL3gQ1q9q
	 qw0vYUhFX4yFtv4sITG/uNgxNCUd80EFtv8dOIVbcLQsJ9QrbAPV3V1jqjaL4pWFXK
	 JRHG1her1VFb2z9l/PpdvHb1WFufmDkul2FALhNc=
Date: Tue, 27 May 2025 19:39:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,fan.ni@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page.patch removed from -mm tree
Message-Id: <20250528023915.E78F4C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: refactor unmap_hugepage_range() to take folio instead of page
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


