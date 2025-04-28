Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3560294A0C
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 19:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745868848; cv=none; b=A20J7OVFzSYAWG7Z613qOpd8Tg6onIoWlgzGohPlsUziYPzCnrdFg2EygNSK3HVzvueiOZHjiCeGHyzUuq9Q9xPYKuXl0blFvTtIJZlkWFv5pxCqCF7UqXgBPbRjZx+rLRiIXsGFan2ViT4VVAFeAz7xnYrodxswoeoS9ionICY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745868848; c=relaxed/simple;
	bh=Gz2qrNXgscAqoYOscTRctn1vpvEg1qVEZiJ6u+el8rU=;
	h=Date:To:From:Subject:Message-Id; b=nzUAVrkDflPeuDoLlDKfc+FPdnmFaMOX+wW9W8SOizW0UWHTLOWQooDQOKsjIegSIq6rPV9i/L6hekpfNui8j88ly1PraeYTtJWezLHZPfs/5ljvGUsmGiWZmq1C5bu9uunMHzGPe6+FfB5OjmN2yOEgJb3nbdeJYtTLn9kzZV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YOqEb9ig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YOqEb9ig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD6CC4CEE9;
	Mon, 28 Apr 2025 19:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745868847;
	bh=Gz2qrNXgscAqoYOscTRctn1vpvEg1qVEZiJ6u+el8rU=;
	h=Date:To:From:Subject:From;
	b=YOqEb9igN3OdOMu7fDlRTh9bqlz7zwEXHbUs9S2C7pzr3lV5tJ6nw0dxhis19YrDu
	 3XroOrRERVjxiBZ03Mbls9uKZDX3T5DWi3mOyKRa5LNL3d0s2Kpy4uejinUrKBF6HF
	 hmGoQDLeMTNSwqfhk7vCJItSZHeDREZu5HXt2JTQ=
Date: Mon, 28 Apr 2025 12:34:06 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,muchun.song@linux.dev,mcgrof@kernel.org,david@redhat.com,dave@stgolabs.net,a.manzanares@samsung.com,fan.ni@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page.patch added to mm-new branch
Message-Id: <20250428193407.4CD6CC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: refactor __unmap_hugepage_range() to take folio instead of page
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page.patch

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
Subject: mm/hugetlb: refactor __unmap_hugepage_range() to take folio instead of page
Date: Mon, 28 Apr 2025 10:11:46 -0700

__unmap_hugepage_range() has two kinds of users:
1) unmap_hugepage_range(), which passes in the head page of a folio.
   Since unmap_hugepage_range() already takes folio and there are no other
   uses of the folio struct in the function, it is natural for
   __unmap_hugepage_range() to take folio also.
2) All other uses, which pass in NULL pointer.

In both cases, we can pass in folio. Refactor __unmap_hugepage_range() to
take folio.

Link: https://lkml.kernel.org/r/20250428171608.21111-6-nifan.cxl@gmail.com
Signed-off-by: Fan Ni <fan.ni@samsung.com>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 ++--
 mm/hugetlb.c            |   10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

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
@@ -5834,7 +5834,7 @@ int move_hugetlb_page_tables(struct vm_a
 
 void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			    unsigned long start, unsigned long end,
-			    struct page *ref_page, zap_flags_t zap_flags)
+			    struct folio *folio, zap_flags_t zap_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address;
@@ -5911,8 +5911,8 @@ void __unmap_hugepage_range(struct mmu_g
 		 * page is being unmapped, not a range. Ensure the page we
 		 * are about to unmap is the actual page of interest.
 		 */
-		if (ref_page) {
-			if (page != ref_page) {
+		if (folio) {
+			if (page_folio(page) != folio) {
 				spin_unlock(ptl);
 				continue;
 			}
@@ -5978,7 +5978,7 @@ void __unmap_hugepage_range(struct mmu_g
 		/*
 		 * Bail out after unmapping reference page if supplied
 		 */
-		if (ref_page)
+		if (folio)
 			break;
 	}
 	tlb_end_vma(tlb, vma);
@@ -6053,7 +6053,7 @@ void unmap_hugepage_range(struct vm_area
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

