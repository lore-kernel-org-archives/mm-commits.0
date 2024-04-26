Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40467E576
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104070; cv=none; b=FeQF1LC80Gbs4U1StD0Tm5CYA+wpiQFpX9SltGQ8Q+4ZZpBSquUMwdvbdOZ5d8bIwGPr9R8xHI4f8Pp6AIYnokaHHZOdnM8P83Tvf+1revcwCZ2cAc2yMEwurdutvt6jJjggC4iIvX+8wBPH0Ox4cws3WoeTAHS1a3JMjLgvW98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104070; c=relaxed/simple;
	bh=xvbsmyt6ZM7YHVPwXBr7VxzcXWGZ6hqtgNx5Gufm/z4=;
	h=Date:To:From:Subject:Message-Id; b=qMZ52BtApszBa7o0frdGhaNVsFoTacbSH9/4/xn14+TfxILM0L8JtjCL7cm//4nWSWz7BiBXGT6P8ntHYs8GyUp0Y4TbyDVlgg8qLafQn3+8sgV709UxaBaB0bOggrpJLNqbFsb5FskVovDEPHbUwvrbBDuDMUo7sikP0mGYwSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ipWyt1DE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ipWyt1DE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AB4C113CD;
	Fri, 26 Apr 2024 04:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104069;
	bh=xvbsmyt6ZM7YHVPwXBr7VxzcXWGZ6hqtgNx5Gufm/z4=;
	h=Date:To:From:Subject:From;
	b=ipWyt1DEVo1iOAG+UMdENMs4gIwiseZ96FY1pa2dzG8yP/8Ebwk9+luPUBwsoF30P
	 sCY0OjBzL+xm50aYj75jN60rdLeE/iUUePjG1azxSAascRqnfh8r1hW0km0Q1+YJTT
	 M9M7IG9zywiltJnmuUtK4GsepTqv20Jg7epEMlSE=
Date: Thu, 25 Apr 2024 21:01:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,shy828301@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,muchun.song@linux.dev,mpe@ellerman.id.au,lstoakes@gmail.com,kirill@shutemov.name,jthoughton@google.com,jhubbard@nvidia.com,jgg@nvidia.com,hch@infradead.org,david@redhat.com,christophe.leroy@csgroup.eu,axelrasmussen@google.com,aneesh.kumar@kernel.org,andrew.jones@linux.dev,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-handle-hugetlb-in-the-generic-follow_page_mask-code.patch removed from -mm tree
Message-Id: <20240426040109.C9AB4C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: handle hugetlb in the generic follow_page_mask code
has been removed from the -mm tree.  Its filename was
     mm-gup-handle-hugetlb-in-the-generic-follow_page_mask-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/gup: handle hugetlb in the generic follow_page_mask code
Date: Wed, 27 Mar 2024 11:23:32 -0400

Now follow_page() is ready to handle hugetlb pages in whatever form, and
over all architectures.  Switch to the generic code path.

Time to retire hugetlb_follow_page_mask(), following the previous
retirement of follow_hugetlb_page() in 4849807114b8.

There may be a slight difference of how the loops run when processing slow
GUP over a large hugetlb range on cont_pte/cont_pmd supported archs: each
loop of __get_user_pages() will resolve one pgtable entry with the patch
applied, rather than relying on the size of hugetlb hstate, the latter may
cover multiple entries in one loop.

A quick performance test on an aarch64 VM on M1 chip shows 15% degrade
over a tight loop of slow gup after the path switched.  That shouldn't be
a problem because slow-gup should not be a hot path for GUP in general:
when page is commonly present, fast-gup will already succeed, while when
the page is indeed missing and require a follow up page fault, the slow
gup degrade will probably buried in the fault paths anyway.  It also
explains why slow gup for THP used to be very slow before 57edfcfd3419
("mm/gup: accelerate thp gup even for "pages != NULL"") lands, the latter
not part of a performance analysis but a side benefit.  If the performance
will be a concern, we can consider handle CONT_PTE in follow_page().

Before that is justified to be necessary, keep everything clean and simple.

Link: https://lkml.kernel.org/r/20240327152332.950956-14-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    7 ---
 mm/gup.c                |   15 ++------
 mm/hugetlb.c            |   71 --------------------------------------
 3 files changed, 5 insertions(+), 88 deletions(-)

--- a/include/linux/hugetlb.h~mm-gup-handle-hugetlb-in-the-generic-follow_page_mask-code
+++ a/include/linux/hugetlb.h
@@ -328,13 +328,6 @@ static inline void hugetlb_zap_end(
 {
 }
 
-static inline struct page *hugetlb_follow_page_mask(
-    struct vm_area_struct *vma, unsigned long address, unsigned int flags,
-    unsigned int *page_mask)
-{
-	BUILD_BUG(); /* should never be compiled in if !CONFIG_HUGETLB_PAGE*/
-}
-
 static inline int copy_hugetlb_page_range(struct mm_struct *dst,
 					  struct mm_struct *src,
 					  struct vm_area_struct *dst_vma,
--- a/mm/gup.c~mm-gup-handle-hugetlb-in-the-generic-follow_page_mask-code
+++ a/mm/gup.c
@@ -1132,18 +1132,11 @@ static struct page *follow_page_mask(str
 {
 	pgd_t *pgd;
 	struct mm_struct *mm = vma->vm_mm;
+	struct page *page;
 
-	ctx->page_mask = 0;
-
-	/*
-	 * Call hugetlb_follow_page_mask for hugetlb vmas as it will use
-	 * special hugetlb page table walking code.  This eliminates the
-	 * need to check for hugetlb entries in the general walking code.
-	 */
-	if (is_vm_hugetlb_page(vma))
-		return hugetlb_follow_page_mask(vma, address, flags,
-						&ctx->page_mask);
+	vma_pgtable_walk_begin(vma);
 
+	ctx->page_mask = 0;
 	pgd = pgd_offset(mm, address);
 
 	if (unlikely(is_hugepd(__hugepd(pgd_val(*pgd)))))
@@ -1154,6 +1147,8 @@ static struct page *follow_page_mask(str
 	else
 		page = follow_p4d_mask(vma, address, pgd, flags, ctx);
 
+	vma_pgtable_walk_end(vma);
+
 	return page;
 }
 
--- a/mm/hugetlb.c~mm-gup-handle-hugetlb-in-the-generic-follow_page_mask-code
+++ a/mm/hugetlb.c
@@ -6876,77 +6876,6 @@ out_release_nounlock:
 }
 #endif /* CONFIG_USERFAULTFD */
 
-struct page *hugetlb_follow_page_mask(struct vm_area_struct *vma,
-				      unsigned long address, unsigned int flags,
-				      unsigned int *page_mask)
-{
-	struct hstate *h = hstate_vma(vma);
-	struct mm_struct *mm = vma->vm_mm;
-	unsigned long haddr = address & huge_page_mask(h);
-	struct page *page = NULL;
-	spinlock_t *ptl;
-	pte_t *pte, entry;
-	int ret;
-
-	hugetlb_vma_lock_read(vma);
-	pte = hugetlb_walk(vma, haddr, huge_page_size(h));
-	if (!pte)
-		goto out_unlock;
-
-	ptl = huge_pte_lock(h, mm, pte);
-	entry = huge_ptep_get(pte);
-	if (pte_present(entry)) {
-		page = pte_page(entry);
-
-		if (!huge_pte_write(entry)) {
-			if (flags & FOLL_WRITE) {
-				page = NULL;
-				goto out;
-			}
-
-			if (gup_must_unshare(vma, flags, page)) {
-				/* Tell the caller to do unsharing */
-				page = ERR_PTR(-EMLINK);
-				goto out;
-			}
-		}
-
-		page = nth_page(page, ((address & ~huge_page_mask(h)) >> PAGE_SHIFT));
-
-		/*
-		 * Note that page may be a sub-page, and with vmemmap
-		 * optimizations the page struct may be read only.
-		 * try_grab_page() will increase the ref count on the
-		 * head page, so this will be OK.
-		 *
-		 * try_grab_page() should always be able to get the page here,
-		 * because we hold the ptl lock and have verified pte_present().
-		 */
-		ret = try_grab_page(page, flags);
-
-		if (WARN_ON_ONCE(ret)) {
-			page = ERR_PTR(ret);
-			goto out;
-		}
-
-		*page_mask = (1U << huge_page_order(h)) - 1;
-	}
-out:
-	spin_unlock(ptl);
-out_unlock:
-	hugetlb_vma_unlock_read(vma);
-
-	/*
-	 * Fixup retval for dump requests: if pagecache doesn't exist,
-	 * don't try to allocate a new page but just skip it.
-	 */
-	if (!page && (flags & FOLL_DUMP) &&
-	    !hugetlbfs_pagecache_present(h, vma, address))
-		page = ERR_PTR(-EFAULT);
-
-	return page;
-}
-
 long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end,
 		pgprot_t newprot, unsigned long cp_flags)
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch

