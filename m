Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595692914
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 00:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747095820; cv=none; b=L3/h5M1r3tIMiclUJ2yrFhLp7XXlZMtoqVS3VLAhyNgpKo2/4pI6N/3hr9r34/QDLQG3qIBv1b5ZgvQx7cIIFdPqjjWh3IS+tVlHmcK7Fv0v+QCyFj/zp3DV+X4PoCCBk3n7mu22yZ91YUhonvJF+Up5kwcVpF+nQnFvzE+gYmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747095820; c=relaxed/simple;
	bh=1vMOJ57VrOn4l5ZpFlGhpIlkeU3QPm9AwnkY94p/CnU=;
	h=Date:To:From:Subject:Message-Id; b=rPUXu8Ev9WVSHY/0QSdXViSZ9aPYHpSQljm6lQwhaDWpgaVa2uULhXHVGxQd5ixT3uYGd66m9czA6QvAo4Jj6IlVMZJ0HBtchei+8EMTnhBTfjv4nMkGEKXUd/vwC4Qn6WrYweAaBINBXn1tYRBPIwlN+IFlaScIfgWjZ02bhPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xqSl9Qkx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xqSl9Qkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12C1C4CEE7;
	Tue, 13 May 2025 00:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747095819;
	bh=1vMOJ57VrOn4l5ZpFlGhpIlkeU3QPm9AwnkY94p/CnU=;
	h=Date:To:From:Subject:From;
	b=xqSl9QkxYsU+WvtG864mcfismFoSm/dvUvcT3WY9PtLmhjY/brD/fyDiD6LHruGUm
	 Vs6OnpTufExEgMVyV8Vh44WWnVnH0UsGRpJy0dZVQxjsEbZBybxRBVVUfx8n2BtdAh
	 n8WdHFfNzSXC4Az8E9jXoDWWB28Gar5ERagJuPuE=
Date: Mon, 12 May 2025 17:23:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-convert-set_huge_pmd-to-take-a-folio.patch added to mm-new branch
Message-Id: <20250513002339.C12C1C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: khugepaged: convert set_huge_pmd() to take a folio
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-convert-set_huge_pmd-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-convert-set_huge_pmd-to-take-a-folio.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: khugepaged: convert set_huge_pmd() to take a folio
Date: Mon, 12 May 2025 10:57:11 +0800

We've already gotten the stable locked folio in collapse_pte_mapped_thp(),
so just use folio for set_huge_pmd() to set the PMD entry, which is more
straightforward.

Moreover, we will check the folio size in do_set_pmd(), so we can remove
the unnecessary VM_BUG_ON() in set_huge_pmd().  While we are at it, we can
also remove the PageTransHuge(), as it currently has no callers.

Link: https://lkml.kernel.org/r/110c3e1ec5fe7854a0e2c95ffcbc985817180ed7.1747017104.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   15 ---------------
 mm/khugepaged.c            |   11 +++++------
 2 files changed, 5 insertions(+), 21 deletions(-)

--- a/include/linux/page-flags.h~mm-khugepaged-convert-set_huge_pmd-to-take-a-folio
+++ a/include/linux/page-flags.h
@@ -908,20 +908,6 @@ FOLIO_FLAG_FALSE(partially_mapped)
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
- * PageHuge() only returns true for hugetlbfs pages, but not for
- * normal or transparent huge pages.
- *
- * PageTransHuge() returns true for both transparent huge and
- * hugetlbfs pages, but not normal pages. PageTransHuge() can only be
- * called only in the core VM paths where hugetlbfs pages can't exist.
- */
-static inline int PageTransHuge(const struct page *page)
-{
-	VM_BUG_ON_PAGE(PageTail(page), page);
-	return PageHead(page);
-}
-
-/*
  * PageTransCompound returns true for both transparent huge pages
  * and hugetlbfs pages, so it should only be called when it's known
  * that hugetlbfs pages aren't involved.
@@ -931,7 +917,6 @@ static inline int PageTransCompound(cons
 	return PageCompound(page);
 }
 #else
-TESTPAGEFLAG_FALSE(TransHuge, transhuge)
 TESTPAGEFLAG_FALSE(TransCompound, transcompound)
 #endif
 
--- a/mm/khugepaged.c~mm-khugepaged-convert-set_huge_pmd-to-take-a-folio
+++ a/mm/khugepaged.c
@@ -1465,9 +1465,9 @@ static void collect_mm_slot(struct khuge
 }
 
 #ifdef CONFIG_SHMEM
-/* hpage must be locked, and mmap_lock must be held */
+/* folio must be locked, and mmap_lock must be held */
 static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
-			pmd_t *pmdp, struct page *hpage)
+			pmd_t *pmdp, struct folio *folio, struct page *page)
 {
 	struct vm_fault vmf = {
 		.vma = vma,
@@ -1476,13 +1476,12 @@ static int set_huge_pmd(struct vm_area_s
 		.pmd = pmdp,
 	};
 
-	VM_BUG_ON(!PageTransHuge(hpage));
 	mmap_assert_locked(vma->vm_mm);
 
-	if (do_set_pmd(&vmf, hpage))
+	if (do_set_pmd(&vmf, page))
 		return SCAN_FAIL;
 
-	get_page(hpage);
+	folio_get(folio);
 	return SCAN_SUCCEED;
 }
 
@@ -1689,7 +1688,7 @@ int collapse_pte_mapped_thp(struct mm_st
 maybe_install_pmd:
 	/* step 5: install pmd entry */
 	result = install_pmd
-			? set_huge_pmd(vma, haddr, pmd, &folio->page)
+			? set_huge_pmd(vma, haddr, pmd, folio, &folio->page)
 			: SCAN_SUCCEED;
 	goto drop_folio;
 abort:
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-mincore-use-pte_batch_bint-to-batch-process-large-folios.patch
mm-khugepaged-convert-set_huge_pmd-to-take-a-folio.patch
mm-convert-do_set_pmd-to-take-a-folio.patch

