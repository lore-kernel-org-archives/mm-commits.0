Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D095227587C
	for <mm-commits@vger.kernel.org>; Mon,  5 May 2025 22:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746482633; cv=none; b=CthRMgznEYS2lrWs/mNOHA572hbKVMFSsMj50NJaV/U5nyUgoRXan1sJmVAg0knG40yFkeDVJaUiF+Sih25fbyEHv6WHb9wsL1pcxTEretrzzbBVFOt36Ov4f9MoAsujZc1u+p9Uzqg6hipYhug/Sw+iQILI2lPFZlV2fn7h2D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746482633; c=relaxed/simple;
	bh=CYggi/ZT/iwRX9e0tfE1XoFmmiUdlxyyj/9f37ZK1Lg=;
	h=Date:To:From:Subject:Message-Id; b=tq6RucyRuAUGc0e3GpeSipX4/SN9fnATNbEguJlhNK1oBUH5lwi9psqE2uP8IpDezQGHpkCuUPgivpvLG5pc5kxb5Huq13s+97vf8PzV6lCw9nWR1QkmQ8MZ+UV6/oLJeHYEsNPhIFOZG55KPj+9EtyVQOvyYo1b75Gj5C0YsVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TiKQfYUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TiKQfYUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1702DC4CEE4;
	Mon,  5 May 2025 22:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746482633;
	bh=CYggi/ZT/iwRX9e0tfE1XoFmmiUdlxyyj/9f37ZK1Lg=;
	h=Date:To:From:Subject:From;
	b=TiKQfYUTklB78HsDiVxRKnmFMVy9kbhkSmzs1NOX1PagMtz5k+MCZBozZLsnAaytu
	 ZSWA4q2NCzJaJdSPENG19xHI+WtauU0TiieAUcAPNzgT/pwAerMfNOGgJvGS5RtKHI
	 1HdzS5bgcsjQLFDk1MvIG1zDY6+2uOTcgPh50W3Y=
Date: Mon, 05 May 2025 15:03:52 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,fan.ni@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page.patch added to mm-unstable branch
Message-Id: <20250505220353.1702DC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: refactor __unmap_hugepage_range() to take folio instead of page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page.patch

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
Subject: mm/hugetlb: refactor __unmap_hugepage_range() to take folio instead of page
Date: Mon, 5 May 2025 11:22:43 -0700

The function __unmap_hugepage_range() has two kinds of users:
1) unmap_hugepage_range(), which passes in the head page of a folio.
   Since unmap_hugepage_range() already takes folio and there are no other
   uses of the folio struct in the function, it is natural for
   __unmap_hugepage_range() to take folio also.
2) All other uses, which pass in NULL pointer.

In both cases, we can pass in folio. Refactor __unmap_hugepage_range() to
take folio.

Link: https://lkml.kernel.org/r/20250505182345.506888-5-nifan.cxl@gmail.com
Signed-off-by: Fan Ni <fan.ni@samsung.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 ++--
 mm/hugetlb.c            |   18 +++++++++---------
 2 files changed, 11 insertions(+), 11 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page
+++ a/include/linux/hugetlb.h
@@ -134,7 +134,7 @@ void unmap_hugepage_range(struct vm_area
 void __unmap_hugepage_range(struct mmu_gather *tlb,
 			  struct vm_area_struct *vma,
 			  unsigned long start, unsigned long end,
-			  struct page *ref_page, zap_flags_t zap_flags);
+			  struct folio *, zap_flags_t zap_flags);
 void hugetlb_report_meminfo(struct seq_file *);
 int hugetlb_report_node_meminfo(char *buf, int len, int nid);
 void hugetlb_show_meminfo_node(int nid);
@@ -455,7 +455,7 @@ static inline long hugetlb_change_protec
 
 static inline void __unmap_hugepage_range(struct mmu_gather *tlb,
 			struct vm_area_struct *vma, unsigned long start,
-			unsigned long end, struct page *ref_page,
+			unsigned long end, struct folio *folio,
 			zap_flags_t zap_flags)
 {
 	BUG();
--- a/mm/hugetlb.c~mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page
+++ a/mm/hugetlb.c
@@ -5840,7 +5840,7 @@ int move_hugetlb_page_tables(struct vm_a
 
 void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			    unsigned long start, unsigned long end,
-			    struct page *ref_page, zap_flags_t zap_flags)
+			    struct folio *folio, zap_flags_t zap_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address;
@@ -5913,12 +5913,12 @@ void __unmap_hugepage_range(struct mmu_g
 
 		page = pte_page(pte);
 		/*
-		 * If a reference page is supplied, it is because a specific
-		 * page is being unmapped, not a range. Ensure the page we
-		 * are about to unmap is the actual page of interest.
+		 * If a folio is supplied, it is because a specific
+		 * folio is being unmapped, not a range. Ensure the folio we
+		 * are about to unmap is the actual folio of interest.
 		 */
-		if (ref_page) {
-			if (page != ref_page) {
+		if (folio) {
+			if (page_folio(page) != folio) {
 				spin_unlock(ptl);
 				continue;
 			}
@@ -5982,9 +5982,9 @@ void __unmap_hugepage_range(struct mmu_g
 
 		tlb_remove_page_size(tlb, page, huge_page_size(h));
 		/*
-		 * Bail out after unmapping reference page if supplied
+		 * If we were instructed to unmap a specific folio, we're done.
 		 */
-		if (ref_page)
+		if (folio)
 			break;
 	}
 	tlb_end_vma(tlb, vma);
@@ -6059,7 +6059,7 @@ void unmap_hugepage_range(struct vm_area
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 
 	__unmap_hugepage_range(&tlb, vma, start, end,
-			       &folio->page, zap_flags);
+			       folio, zap_flags);
 
 	mmu_notifier_invalidate_range_end(&range);
 	tlb_finish_mmu(&tlb);
_

Patches currently in -mm which might be from fan.ni@samsung.com are

mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache.patch
khugepaged-pass-folio-instead-of-head-page-to-trace-events.patch
mm-hugetlb-pass-folio-instead-of-page-to-unmap_ref_private.patch
mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-hugetlb-convert-use-of-struct-page-to-folio-in-__unmap_hugepage_range.patch

