Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574C819CC0A
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 20:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744921825; cv=none; b=Tfinp6AB7xg2d34My+mmyrz1SEEA18e7+NUm5bOmQfbmrrk49sC+iTOOT5yOfA5bk5Zgm6SNgRXRnS9/LI2PBzut036KwIzBrFFf8/a+P2NI9pHaBUNXtMKcYGvYjjHmqApvWaKAobrZXBJPnY3rbGzBI/VCCUvRpuTsK+oLEBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744921825; c=relaxed/simple;
	bh=M8hqAvHAae9DgZcYXIypUoRaXVnBt0yUrbpbbh9vHbg=;
	h=Date:To:From:Subject:Message-Id; b=WmYx43JWjqocr8julsgCJLGJ2G+pELBSdhuueWsYZQnZ7yq7Kkgv65S9rYzCtKvP7a6XZntb8faySXQKAn37ik6+rwOcWmw7bm8gaqaXRL95sG+rbCJIGP9VnKM8ajmwwgS5kvJjtQFuC+BY8Ot1JB868bqTEncifdJDXylQSAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W3Num/64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W3Num/64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD64BC4CEE7;
	Thu, 17 Apr 2025 20:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744921824;
	bh=M8hqAvHAae9DgZcYXIypUoRaXVnBt0yUrbpbbh9vHbg=;
	h=Date:To:From:Subject:From;
	b=W3Num/64WO6GIUCP397QTxN2Vq5d9BB/UzsyIVzTFflid6orllqxq+Mk2kdU6YrM5
	 3af0tv2EDNAI3CcxWctILtUHS89Sf4ew0PMGqsRRqdTvmBN9q5G0y4IAIJNCDiWPE/
	 pgrEj4L6o27J4cGgbjqX0MNI2mYjmBI5mQ6sCjpg=
Date: Thu, 17 Apr 2025 13:30:24 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,muchun.song@linux.dev,mcgrof@kernel.org,david@redhat.com,dave@stgolabs.net,a.manzanares@samsung.com,fan.ni@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page.patch added to mm-unstable branch
Message-Id: <20250417203024.AD64BC4CEE7@smtp.kernel.org>
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
Date: Thu, 17 Apr 2025 08:43:15 -0700

The function __unmap_hugepage_range() has two kinds of users:
1) unmap_hugepage_range(), which passes in the head page of a folio.
   Since unmap_hugepage_range() already takes folio and there are no other
   uses of the folio struct in the function, it is natural for
   __unmap_hugepage_range() to take folio also.
2) All other uses, which pass in NULL pointer.

In both cases, we can pass in folio. Refactor __unmap_hugepage_range() to
take folio.

Link: https://lkml.kernel.org/r/20250417155530.124073-3-nifan.cxl@gmail.com
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
 mm/hugetlb.c            |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page
+++ a/include/linux/hugetlb.h
@@ -133,7 +133,7 @@ void unmap_hugepage_range(struct vm_area
 void __unmap_hugepage_range(struct mmu_gather *tlb,
 			  struct vm_area_struct *vma,
 			  unsigned long start, unsigned long end,
-			  struct page *ref_page, zap_flags_t zap_flags);
+			  struct folio *ref_folio, zap_flags_t zap_flags);
 void hugetlb_report_meminfo(struct seq_file *);
 int hugetlb_report_node_meminfo(char *buf, int len, int nid);
 void hugetlb_show_meminfo_node(int nid);
--- a/mm/hugetlb.c~mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page
+++ a/mm/hugetlb.c
@@ -5808,7 +5808,7 @@ int move_hugetlb_page_tables(struct vm_a
 
 void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			    unsigned long start, unsigned long end,
-			    struct page *ref_page, zap_flags_t zap_flags)
+			    struct folio *ref_folio, zap_flags_t zap_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address;
@@ -5885,8 +5885,8 @@ void __unmap_hugepage_range(struct mmu_g
 		 * page is being unmapped, not a range. Ensure the page we
 		 * are about to unmap is the actual page of interest.
 		 */
-		if (ref_page) {
-			if (page != ref_page) {
+		if (ref_folio) {
+			if (page != folio_page(ref_folio, 0)) {
 				spin_unlock(ptl);
 				continue;
 			}
@@ -5952,7 +5952,7 @@ void __unmap_hugepage_range(struct mmu_g
 		/*
 		 * Bail out after unmapping reference page if supplied
 		 */
-		if (ref_page)
+		if (ref_folio)
 			break;
 	}
 	tlb_end_vma(tlb, vma);
@@ -6027,7 +6027,7 @@ void unmap_hugepage_range(struct vm_area
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 
 	__unmap_hugepage_range(&tlb, vma, start, end,
-			       folio_page(ref_folio, 0), zap_flags);
+			       ref_folio, zap_flags);
 
 	mmu_notifier_invalidate_range_end(&range);
 	tlb_finish_mmu(&tlb);
_

Patches currently in -mm which might be from fan.ni@samsung.com are

mm-hugetlb-refactor-unmap_ref_private-to-take-folio-instead-of-page.patch
mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache.patch
khugepaged-refactor-trace_mm_collapse_huge_page_isolate-to-take-folio-instead-of-page.patch

