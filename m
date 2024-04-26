Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EA07E576
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104064; cv=none; b=Hf7pR9FH+GyasZEmIgFaYTUBf45mNk3I4QPETWuNrgY3S0SfBF1pLNo5WpXx/3NTguhAxJfNVIRCkjRRWXzmg+qi0YJmzLFc5UXOe+lWWa4tHGkAgGRlkI05PI/9jBz/eFcR2ArSkddMI1rFFkTW3mVuCVxZ0pU05v5VevFBMwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104064; c=relaxed/simple;
	bh=+XjjAqOodQvT8ZjoEHvLNZDoFDzHbJLZQ1lB+KNRVco=;
	h=Date:To:From:Subject:Message-Id; b=i93ECrbSwdFPXM6V9JbWbZdQydnykf7mh+FyKVkmWVzWokUdNbroo64pExAQrn1GFSVXLdkJoVZHQKfy5HXSylrO+H2iHoxPAcxQVVpQtYSacuwobhgG7Zby/vNs9vPACPBts8MLaAhKAw0yh02sGQXQ8UG5xypNnSsx42Cns2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xg4+Y3qj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xg4+Y3qj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510E9C113CD;
	Fri, 26 Apr 2024 04:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104064;
	bh=+XjjAqOodQvT8ZjoEHvLNZDoFDzHbJLZQ1lB+KNRVco=;
	h=Date:To:From:Subject:From;
	b=xg4+Y3qjYZzxYmrxx76e0ODXJdI5LWRfl69GH1iZEqCn9tuteaD9sL4JDCMLO+PDM
	 NYtc9gsy4ouTxk3wOYzkQLB7EjpcbtNxbgNWcWinxqw9OVQECHEbulKQC1rEhchVWu
	 LFwjr+baXoKaW7N6oHek3dIDsMUBvMbxahLFIddI=
Date: Thu, 25 Apr 2024 21:01:03 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,shy828301@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,muchun.song@linux.dev,mpe@ellerman.id.au,lstoakes@gmail.com,kirill@shutemov.name,jthoughton@google.com,jhubbard@nvidia.com,jgg@nvidia.com,hch@infradead.org,david@redhat.com,christophe.leroy@csgroup.eu,axelrasmussen@google.com,aneesh.kumar@kernel.org,andrew.jones@linux.dev,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-handle-huge-pud-for-follow_pud_mask.patch removed from -mm tree
Message-Id: <20240426040104.510E9C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: handle huge pud for follow_pud_mask()
has been removed from the -mm tree.  Its filename was
     mm-gup-handle-huge-pud-for-follow_pud_mask.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/gup: handle huge pud for follow_pud_mask()
Date: Wed, 27 Mar 2024 11:23:29 -0400

Teach follow_pud_mask() to be able to handle normal PUD pages like
hugetlb.

Rename follow_devmap_pud() to follow_huge_pud() so that it can process
either huge devmap or hugetlb.  Move it out of TRANSPARENT_HUGEPAGE_PUD
and and huge_memory.c (which relies on CONFIG_THP).  Switch to pud_leaf()
to detect both cases in the slow gup.

In the new follow_huge_pud(), taking care of possible CoR for hugetlb if
necessary.  touch_pud() needs to be moved out of huge_memory.c to be
accessable from gup.c even if !THP.

Since at it, optimize the non-present check by adding a pud_present()
early check before taking the pgtable lock, failing the follow_page()
early if PUD is not present: that is required by both devmap or hugetlb. 
Use pud_huge() to also cover the pud_devmap() case.

One more trivial thing to mention is, introduce "pud_t pud" in the code
paths along the way, so the code doesn't dereference *pudp multiple time. 
Not only because that looks less straightforward, but also because if the
dereference really happened, it's not clear whether there can be race to
see different *pudp values when it's being modified at the same time.

Setting ctx->page_mask properly for a PUD entry.  As a side effect, this
patch should also be able to optimize devmap GUP on PUD to be able to jump
over the whole PUD range, but not yet verified.  Hugetlb already can do so
prior to this patch.

Link: https://lkml.kernel.org/r/20240327152332.950956-11-peterx@redhat.com
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

 include/linux/huge_mm.h |    8 ----
 mm/gup.c                |   70 ++++++++++++++++++++++++++++++++++++--
 mm/huge_memory.c        |   47 +------------------------
 mm/internal.h           |    2 +
 4 files changed, 71 insertions(+), 56 deletions(-)

--- a/include/linux/huge_mm.h~mm-gup-handle-huge-pud-for-follow_pud_mask
+++ a/include/linux/huge_mm.h
@@ -351,8 +351,6 @@ static inline bool folio_test_pmd_mappab
 
 struct page *follow_devmap_pmd(struct vm_area_struct *vma, unsigned long addr,
 		pmd_t *pmd, int flags, struct dev_pagemap **pgmap);
-struct page *follow_devmap_pud(struct vm_area_struct *vma, unsigned long addr,
-		pud_t *pud, int flags, struct dev_pagemap **pgmap);
 
 vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf);
 
@@ -506,12 +504,6 @@ static inline struct page *follow_devmap
 {
 	return NULL;
 }
-
-static inline struct page *follow_devmap_pud(struct vm_area_struct *vma,
-	unsigned long addr, pud_t *pud, int flags, struct dev_pagemap **pgmap)
-{
-	return NULL;
-}
 
 static inline bool thp_migration_supported(void)
 {
--- a/mm/gup.c~mm-gup-handle-huge-pud-for-follow_pud_mask
+++ a/mm/gup.c
@@ -525,6 +525,70 @@ static struct page *no_page_table(struct
 	return NULL;
 }
 
+#ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
+static struct page *follow_huge_pud(struct vm_area_struct *vma,
+				    unsigned long addr, pud_t *pudp,
+				    int flags, struct follow_page_context *ctx)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct page *page;
+	pud_t pud = *pudp;
+	unsigned long pfn = pud_pfn(pud);
+	int ret;
+
+	assert_spin_locked(pud_lockptr(mm, pudp));
+
+	if ((flags & FOLL_WRITE) && !pud_write(pud))
+		return NULL;
+
+	if (!pud_present(pud))
+		return NULL;
+
+	pfn += (addr & ~PUD_MASK) >> PAGE_SHIFT;
+
+	if (IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD) &&
+	    pud_devmap(pud)) {
+		/*
+		 * device mapped pages can only be returned if the caller
+		 * will manage the page reference count.
+		 *
+		 * At least one of FOLL_GET | FOLL_PIN must be set, so
+		 * assert that here:
+		 */
+		if (!(flags & (FOLL_GET | FOLL_PIN)))
+			return ERR_PTR(-EEXIST);
+
+		if (flags & FOLL_TOUCH)
+			touch_pud(vma, addr, pudp, flags & FOLL_WRITE);
+
+		ctx->pgmap = get_dev_pagemap(pfn, ctx->pgmap);
+		if (!ctx->pgmap)
+			return ERR_PTR(-EFAULT);
+	}
+
+	page = pfn_to_page(pfn);
+
+	if (!pud_devmap(pud) && !pud_write(pud) &&
+	    gup_must_unshare(vma, flags, page))
+		return ERR_PTR(-EMLINK);
+
+	ret = try_grab_page(page, flags);
+	if (ret)
+		page = ERR_PTR(ret);
+	else
+		ctx->page_mask = HPAGE_PUD_NR - 1;
+
+	return page;
+}
+#else  /* CONFIG_PGTABLE_HAS_HUGE_LEAVES */
+static struct page *follow_huge_pud(struct vm_area_struct *vma,
+				    unsigned long addr, pud_t *pudp,
+				    int flags, struct follow_page_context *ctx)
+{
+	return NULL;
+}
+#endif	/* CONFIG_PGTABLE_HAS_HUGE_LEAVES */
+
 static int follow_pfn_pte(struct vm_area_struct *vma, unsigned long address,
 		pte_t *pte, unsigned int flags)
 {
@@ -760,11 +824,11 @@ static struct page *follow_pud_mask(stru
 
 	pudp = pud_offset(p4dp, address);
 	pud = READ_ONCE(*pudp);
-	if (pud_none(pud))
+	if (!pud_present(pud))
 		return no_page_table(vma, flags, address);
-	if (pud_devmap(pud)) {
+	if (pud_leaf(pud)) {
 		ptl = pud_lock(mm, pudp);
-		page = follow_devmap_pud(vma, address, pudp, flags, &ctx->pgmap);
+		page = follow_huge_pud(vma, address, pudp, flags, ctx);
 		spin_unlock(ptl);
 		if (page)
 			return page;
--- a/mm/huge_memory.c~mm-gup-handle-huge-pud-for-follow_pud_mask
+++ a/mm/huge_memory.c
@@ -1378,8 +1378,8 @@ out:
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-static void touch_pud(struct vm_area_struct *vma, unsigned long addr,
-		      pud_t *pud, bool write)
+void touch_pud(struct vm_area_struct *vma, unsigned long addr,
+	       pud_t *pud, bool write)
 {
 	pud_t _pud;
 
@@ -1391,49 +1391,6 @@ static void touch_pud(struct vm_area_str
 		update_mmu_cache_pud(vma, addr, pud);
 }
 
-struct page *follow_devmap_pud(struct vm_area_struct *vma, unsigned long addr,
-		pud_t *pud, int flags, struct dev_pagemap **pgmap)
-{
-	unsigned long pfn = pud_pfn(*pud);
-	struct mm_struct *mm = vma->vm_mm;
-	struct page *page;
-	int ret;
-
-	assert_spin_locked(pud_lockptr(mm, pud));
-
-	if (flags & FOLL_WRITE && !pud_write(*pud))
-		return NULL;
-
-	if (pud_present(*pud) && pud_devmap(*pud))
-		/* pass */;
-	else
-		return NULL;
-
-	if (flags & FOLL_TOUCH)
-		touch_pud(vma, addr, pud, flags & FOLL_WRITE);
-
-	/*
-	 * device mapped pages can only be returned if the
-	 * caller will manage the page reference count.
-	 *
-	 * At least one of FOLL_GET | FOLL_PIN must be set, so assert that here:
-	 */
-	if (!(flags & (FOLL_GET | FOLL_PIN)))
-		return ERR_PTR(-EEXIST);
-
-	pfn += (addr & ~PUD_MASK) >> PAGE_SHIFT;
-	*pgmap = get_dev_pagemap(pfn, *pgmap);
-	if (!*pgmap)
-		return ERR_PTR(-EFAULT);
-	page = pfn_to_page(pfn);
-
-	ret = try_grab_page(page, flags);
-	if (ret)
-		page = ERR_PTR(ret);
-
-	return page;
-}
-
 int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
 		  struct vm_area_struct *vma)
--- a/mm/internal.h~mm-gup-handle-huge-pud-for-follow_pud_mask
+++ a/mm/internal.h
@@ -1112,6 +1112,8 @@ int __must_check try_grab_page(struct pa
 /*
  * mm/huge_memory.c
  */
+void touch_pud(struct vm_area_struct *vma, unsigned long addr,
+	       pud_t *pud, bool write);
 struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
 				   unsigned long addr, pmd_t *pmd,
 				   unsigned int flags);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch

