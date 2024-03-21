Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EE253AC
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 23:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711062166; cv=none; b=DSkQuBnvr/SzvgLZEYioys7OxkzXkisVCVXZwNHTxQlWFvUFEL9UMpVB8HOqNFGdNuckUzbLB9QwghpXZta95FsZaJubeJIm49h9S9xoVW3rqhthI52vWylf6yvTvS5KeO4mv+FuKTzweXQp0J5UMNzqTRCxdHZhz0t+8oqAVUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711062166; c=relaxed/simple;
	bh=xSW5H3LEHjV4GKCpGjrGn+CB/1p6hS6x2dmk5p4x3WM=;
	h=Date:To:From:Subject:Message-Id; b=icKEDBZnGwalIV6w5iQkE7T8mO8ElffAJYMOMeqGT93IhVreiTvJvjbS3cAuUxkL0jX8+pCVJ2ZGdcr0UWTRVFrwzPLxLYFakXi1mnIObhy9yBsi0klNrRUdkwP83iPXRxSVOvhIH1AuFoN4FHAgO84ledBiyykdblH1QQAOznE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TO81t/jp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TO81t/jp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC0CC433C7;
	Thu, 21 Mar 2024 23:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711062166;
	bh=xSW5H3LEHjV4GKCpGjrGn+CB/1p6hS6x2dmk5p4x3WM=;
	h=Date:To:From:Subject:From;
	b=TO81t/jpj9JGGsjCKM/zjXrbvfyEK488xgzVw/g1cFqzIrWpvTli41EMtuMvcakB0
	 1TOibz0Mga23hxy0YH0rLeGZ43aJoaz8052fOdLiUjMJjI4zTTKAUQZ+kM3bQp+tXQ
	 AF6559JTgSkUyQ4bE7J8CSepdLn4g4j68CH2oYQ0=
Date: Thu, 21 Mar 2024 16:02:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,shy828301@gmail.com,rppt@kernel.org,riel@surriel.com,muchun.song@linux.dev,mpe@ellerman.id.au,mike.kravetz@oracle.com,lstoakes@gmail.com,kirill@shutemov.name,jthoughton@google.com,jhubbard@nvidia.com,jgg@nvidia.com,hch@infradead.org,david@redhat.com,christophe.leroy@csgroup.eu,axelrasmussen@google.com,aneesh.kumar@kernel.org,andrew.jones@linux.dev,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-handle-hugepd-for-follow_page.patch added to mm-unstable branch
Message-Id: <20240321230246.0FC0CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: handle hugepd for follow_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-handle-hugepd-for-follow_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-handle-hugepd-for-follow_page.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/gup: handle hugepd for follow_page()
Date: Thu, 21 Mar 2024 18:08:01 -0400

Hugepd is only used in PowerPC so far on 4K page size kernels where hash
mmu is used.  follow_page_mask() used to leverage hugetlb APIs to access
hugepd entries.  Teach follow_page_mask() itself on hugepd.

With previous refactors on fast-gup gup_huge_pd(), most of the code can be
easily leveraged.  There's something not needed for follow page, for
example, gup_hugepte() tries to detect pgtable entry change which will
never happen with slow gup (which has the pgtable lock held), but that's
not a problem to check.

Since follow_page() always only fetch one page, set the end to "address +
PAGE_SIZE" should suffice.  We will still do the pgtable walk once for
each hugetlb page by setting ctx->page_mask properly.

One thing worth mentioning is that some level of pgtable's _bad() helper
will report is_hugepd() entries as TRUE on Power8 hash MMUs.  I think it
at least applies to PUD on Power8 with 4K pgsize.  It means feeding a
hugepd entry to pud_bad() will report a false positive.  Let's leave that
for now because it can be arch-specific where I am a bit declined to
touch.  In this patch it's not a problem as long as hugepd is detected
before any bad pgtable entries.

Link: https://lkml.kernel.org/r/20240321220802.679544-12-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   73 +++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 66 insertions(+), 7 deletions(-)

--- a/mm/gup.c~mm-gup-handle-hugepd-for-follow_page
+++ a/mm/gup.c
@@ -30,6 +30,11 @@ struct follow_page_context {
 	unsigned int page_mask;
 };
 
+static struct page *follow_hugepd(struct vm_area_struct *vma, hugepd_t hugepd,
+				  unsigned long addr, unsigned int pdshift,
+				  unsigned int flags,
+				  struct follow_page_context *ctx);
+
 static inline void sanity_check_pinned_pages(struct page **pages,
 					     unsigned long npages)
 {
@@ -871,6 +876,9 @@ static struct page *follow_pmd_mask(stru
 		return no_page_table(vma, flags, address);
 	if (!pmd_present(pmdval))
 		return no_page_table(vma, flags, address);
+	if (unlikely(is_hugepd(__hugepd(pmd_val(pmdval)))))
+		return follow_hugepd(vma, __hugepd(pmd_val(pmdval)),
+				     address, PMD_SHIFT, flags, ctx);
 	if (pmd_devmap(pmdval)) {
 		ptl = pmd_lock(mm, pmd);
 		page = follow_devmap_pmd(vma, address, pmd, flags, &ctx->pgmap);
@@ -921,6 +929,9 @@ static struct page *follow_pud_mask(stru
 	pud = READ_ONCE(*pudp);
 	if (!pud_present(pud))
 		return no_page_table(vma, flags, address);
+	if (unlikely(is_hugepd(__hugepd(pud_val(pud)))))
+		return follow_hugepd(vma, __hugepd(pud_val(pud)),
+				     address, PUD_SHIFT, flags, ctx);
 	if (pud_leaf(pud)) {
 		ptl = pud_lock(mm, pudp);
 		page = follow_huge_pud(vma, address, pudp, flags, ctx);
@@ -944,10 +955,13 @@ static struct page *follow_p4d_mask(stru
 
 	p4dp = p4d_offset(pgdp, address);
 	p4d = READ_ONCE(*p4dp);
-	if (!p4d_present(p4d))
-		return no_page_table(vma, flags, address);
 	BUILD_BUG_ON(p4d_leaf(p4d));
-	if (unlikely(p4d_bad(p4d)))
+
+	if (unlikely(is_hugepd(__hugepd(p4d_val(p4d)))))
+		return follow_hugepd(vma, __hugepd(p4d_val(p4d)),
+				     address, P4D_SHIFT, flags, ctx);
+
+	if (!p4d_present(p4d) || p4d_bad(p4d))
 		return no_page_table(vma, flags, address);
 
 	return follow_pud_mask(vma, address, p4dp, flags, ctx);
@@ -981,7 +995,7 @@ static struct page *follow_page_mask(str
 			      unsigned long address, unsigned int flags,
 			      struct follow_page_context *ctx)
 {
-	pgd_t *pgd;
+	pgd_t *pgd, pgdval;
 	struct mm_struct *mm = vma->vm_mm;
 
 	ctx->page_mask = 0;
@@ -996,11 +1010,17 @@ static struct page *follow_page_mask(str
 						&ctx->page_mask);
 
 	pgd = pgd_offset(mm, address);
+	pgdval = *pgd;
 
-	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
-		return no_page_table(vma, flags, address);
+	if (unlikely(is_hugepd(__hugepd(pgd_val(pgdval)))))
+		page = follow_hugepd(vma, __hugepd(pgd_val(pgdval)),
+				     address, PGDIR_SHIFT, flags, ctx);
+	else if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
+		page = no_page_table(vma, flags, address);
+	else
+		page = follow_p4d_mask(vma, address, pgd, flags, ctx);
 
-	return follow_p4d_mask(vma, address, pgd, flags, ctx);
+	return page;
 }
 
 struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
@@ -3037,6 +3057,37 @@ static int gup_huge_pd(hugepd_t hugepd,
 
 	return 1;
 }
+
+static struct page *follow_hugepd(struct vm_area_struct *vma, hugepd_t hugepd,
+				  unsigned long addr, unsigned int pdshift,
+				  unsigned int flags,
+				  struct follow_page_context *ctx)
+{
+	struct page *page;
+	struct hstate *h;
+	spinlock_t *ptl;
+	int nr = 0, ret;
+	pte_t *ptep;
+
+	/* Only hugetlb supports hugepd */
+	if (WARN_ON_ONCE(!is_vm_hugetlb_page(vma)))
+		return ERR_PTR(-EFAULT);
+
+	h = hstate_vma(vma);
+	ptep = hugepte_offset(hugepd, addr, pdshift);
+	ptl = huge_pte_lock(h, vma->vm_mm, ptep);
+	ret = gup_huge_pd(hugepd, addr, pdshift, addr + PAGE_SIZE,
+			  flags, &page, &nr);
+	spin_unlock(ptl);
+
+	if (ret) {
+		WARN_ON_ONCE(nr != 1);
+		ctx->page_mask = (1U << huge_page_order(h)) - 1;
+		return page;
+	}
+
+	return NULL;
+}
 #else
 static inline int gup_huge_pd(hugepd_t hugepd, unsigned long addr,
 		unsigned int pdshift, unsigned long end, unsigned int flags,
@@ -3044,6 +3095,14 @@ static inline int gup_huge_pd(hugepd_t h
 {
 	return 0;
 }
+
+static struct page *follow_hugepd(struct vm_area_struct *vma, hugepd_t hugepd,
+				  unsigned long addr, unsigned int pdshift,
+				  unsigned int flags,
+				  struct follow_page_context *ctx)
+{
+	return NULL;
+}
 #endif /* CONFIG_ARCH_HAS_HUGEPD */
 
 static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-memory-fix-missing-pte-marker-for-page-on-pte-zaps.patch
mm-hmm-process-pud-swap-entry-without-pud_huge.patch
mm-gup-cache-p4d-in-follow_p4d_mask.patch
mm-gup-check-p4d-presence-before-going-on.patch
mm-x86-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-arm-use-macros-to-define-pmd-pud-helpers.patch
mm-arm-redefine-pmd_huge-with-pmd_leaf.patch
mm-arm64-merge-pxd_huge-and-pxd_leaf-definitions.patch
mm-powerpc-redefine-pxd_huge-with-pxd_leaf.patch
mm-gup-merge-pxd-huge-mapping-checks.patch
mm-treewide-replace-pxd_huge-with-pxd_leaf.patch
mm-treewide-remove-pxd_huge.patch
mm-arm-remove-pmd_thp_or_huge.patch
mm-document-pxd_leaf-api.patch
mm-kconfig-config_pgtable_has_huge_leaves.patch
mm-hugetlb-declare-hugetlbfs_pagecache_present-non-static.patch
mm-make-hpage_pxd_-macros-even-if-thp.patch
mm-introduce-vma_pgtable_walk_beginend.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing.patch
mm-gup-refactor-record_subpages-to-find-1st-small-page.patch
mm-gup-handle-hugetlb-for-no_page_table.patch
mm-gup-cache-pudp-in-follow_pud_mask.patch
mm-gup-handle-huge-pud-for-follow_pud_mask.patch
mm-gup-handle-huge-pmd-for-follow_pmd_mask.patch
mm-gup-handle-hugepd-for-follow_page.patch
mm-gup-handle-hugetlb-in-the-generic-follow_page_mask-code.patch

