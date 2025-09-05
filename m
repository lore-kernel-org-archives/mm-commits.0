Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C591946BC
	for <mm-commits@vger.kernel.org>; Fri,  5 Sep 2025 00:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757032831; cv=none; b=H/l46EQGdJ5HCxWUd/X6swtql3kyf6LxKCqSasSis4tRyLJ9Rq6meCdXw80VxfkfYGF0qaoF69fs0X53Z6f3yR+Ja9YGWK77K2PTDNw1wxhVQuRA8O+yly6Cu6l5D5EsY3/Z/0RBhe44rK8ZMeqG2zeiF2HQCtt3+rNVNFcU06w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757032831; c=relaxed/simple;
	bh=dMQ98a9YQ49oMWULaulIWPqLEGVXXodPAg8s9vJwZFQ=;
	h=Date:To:From:Subject:Message-Id; b=URzvUjG9X94RHOkh1BmEgQxL8VoeE4HdAc4LoMDfo2zvFvBHN7PYKsVouVW4hZl5TDXOD0o2aNXDPy9XNDh2KLI4tIQORmihJokQOxOF4kVCD9V3cGxpX6p++Rabg+noWvDIXZpz/0dfUt/sPNb7hU24HaH2dknYsrBTiFbR2Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jd0qV+7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jd0qV+7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E4BC4CEF4;
	Fri,  5 Sep 2025 00:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757032830;
	bh=dMQ98a9YQ49oMWULaulIWPqLEGVXXodPAg8s9vJwZFQ=;
	h=Date:To:From:Subject:From;
	b=Jd0qV+7AJ8yWkKN9kEe9RMimASgK1LPTUrAt/JVJLQRUnyTuQJkAhh5kK3KWay4AU
	 DBH2DM0zV2nY4rlyYH0eYsEbQecxR2pQAjDIoVhDqu5N56QtLJRmb1v2jKxeNP4iW9
	 fvEwj9OWBqEY7xO9dIrp/1/7nurQwcBavley56YQ=
Date: Thu, 04 Sep 2025 17:40:29 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,jhubbard@nvidia.com,jgg@nvidia.com,david@redhat.com,dan.j.williams@intel.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-dead-pgmap-refcounting-code.patch added to mm-new branch
Message-Id: <20250905004030.77E4BC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: remove dead pgmap refcounting code
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-remove-dead-pgmap-refcounting-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-remove-dead-pgmap-refcounting-code.patch

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
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/gup: remove dead pgmap refcounting code
Date: Thu, 4 Sep 2025 08:59:25 +1000

Prior to commit aed877c2b425 ("device/dax: properly refcount device dax
pages when mapping") ZONE_DEVICE pages were not fully reference counted
when mapped into user page tables.  Instead GUP would take a reference on
the associated pgmap to ensure the results of pfn_to_page() remained
valid.

This is no longer required and most of the code was removed by commit
fd2825b0760a ("mm/gup: remove pXX_devmap usage from get_user_pages()"). 
Finish cleaning this up by removing the dead calls to put_dev_pagemap()
and the temporary context struct.

Link: https://lkml.kernel.org/r/20250903225926.34702-1-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   67 ++++++++++++++++++++---------------------------------
 1 file changed, 26 insertions(+), 41 deletions(-)

--- a/mm/gup.c~mm-gup-remove-dead-pgmap-refcounting-code
+++ a/mm/gup.c
@@ -28,11 +28,6 @@
 #include "internal.h"
 #include "swap.h"
 
-struct follow_page_context {
-	struct dev_pagemap *pgmap;
-	unsigned int page_mask;
-};
-
 static inline void sanity_check_pinned_pages(struct page **pages,
 					     unsigned long npages)
 {
@@ -653,7 +648,7 @@ static inline bool can_follow_write_pud(
 
 static struct page *follow_huge_pud(struct vm_area_struct *vma,
 				    unsigned long addr, pud_t *pudp,
-				    int flags, struct follow_page_context *ctx)
+				    int flags, unsigned long *page_mask)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct page *page;
@@ -680,7 +675,7 @@ static struct page *follow_huge_pud(stru
 	if (ret)
 		page = ERR_PTR(ret);
 	else
-		ctx->page_mask = HPAGE_PUD_NR - 1;
+		*page_mask = HPAGE_PUD_NR - 1;
 
 	return page;
 }
@@ -706,7 +701,7 @@ static inline bool can_follow_write_pmd(
 static struct page *follow_huge_pmd(struct vm_area_struct *vma,
 				    unsigned long addr, pmd_t *pmd,
 				    unsigned int flags,
-				    struct follow_page_context *ctx)
+				    unsigned long *page_mask)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t pmdval = *pmd;
@@ -743,7 +738,7 @@ static struct page *follow_huge_pmd(stru
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
-	ctx->page_mask = HPAGE_PMD_NR - 1;
+	*page_mask = HPAGE_PMD_NR - 1;
 
 	return page;
 }
@@ -751,7 +746,7 @@ static struct page *follow_huge_pmd(stru
 #else  /* CONFIG_PGTABLE_HAS_HUGE_LEAVES */
 static struct page *follow_huge_pud(struct vm_area_struct *vma,
 				    unsigned long addr, pud_t *pudp,
-				    int flags, struct follow_page_context *ctx)
+				    int flags, unsigned long *page_mask)
 {
 	return NULL;
 }
@@ -759,7 +754,7 @@ static struct page *follow_huge_pud(stru
 static struct page *follow_huge_pmd(struct vm_area_struct *vma,
 				    unsigned long addr, pmd_t *pmd,
 				    unsigned int flags,
-				    struct follow_page_context *ctx)
+				    unsigned long *page_mask)
 {
 	return NULL;
 }
@@ -805,8 +800,7 @@ static inline bool can_follow_write_pte(
 }
 
 static struct page *follow_page_pte(struct vm_area_struct *vma,
-		unsigned long address, pmd_t *pmd, unsigned int flags,
-		struct dev_pagemap **pgmap)
+		unsigned long address, pmd_t *pmd, unsigned int flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct folio *folio;
@@ -904,7 +898,7 @@ no_page:
 static struct page *follow_pmd_mask(struct vm_area_struct *vma,
 				    unsigned long address, pud_t *pudp,
 				    unsigned int flags,
-				    struct follow_page_context *ctx)
+				    unsigned long *page_mask)
 {
 	pmd_t *pmd, pmdval;
 	spinlock_t *ptl;
@@ -918,7 +912,7 @@ static struct page *follow_pmd_mask(stru
 	if (!pmd_present(pmdval))
 		return no_page_table(vma, flags, address);
 	if (likely(!pmd_leaf(pmdval)))
-		return follow_page_pte(vma, address, pmd, flags, &ctx->pgmap);
+		return follow_page_pte(vma, address, pmd, flags);
 
 	if (pmd_protnone(pmdval) && !gup_can_follow_protnone(vma, flags))
 		return no_page_table(vma, flags, address);
@@ -931,16 +925,16 @@ static struct page *follow_pmd_mask(stru
 	}
 	if (unlikely(!pmd_leaf(pmdval))) {
 		spin_unlock(ptl);
-		return follow_page_pte(vma, address, pmd, flags, &ctx->pgmap);
+		return follow_page_pte(vma, address, pmd, flags);
 	}
 	if (pmd_trans_huge(pmdval) && (flags & FOLL_SPLIT_PMD)) {
 		spin_unlock(ptl);
 		split_huge_pmd(vma, pmd, address);
 		/* If pmd was left empty, stuff a page table in there quickly */
 		return pte_alloc(mm, pmd) ? ERR_PTR(-ENOMEM) :
-			follow_page_pte(vma, address, pmd, flags, &ctx->pgmap);
+			follow_page_pte(vma, address, pmd, flags);
 	}
-	page = follow_huge_pmd(vma, address, pmd, flags, ctx);
+	page = follow_huge_pmd(vma, address, pmd, flags, page_mask);
 	spin_unlock(ptl);
 	return page;
 }
@@ -948,7 +942,7 @@ static struct page *follow_pmd_mask(stru
 static struct page *follow_pud_mask(struct vm_area_struct *vma,
 				    unsigned long address, p4d_t *p4dp,
 				    unsigned int flags,
-				    struct follow_page_context *ctx)
+				    unsigned long *page_mask)
 {
 	pud_t *pudp, pud;
 	spinlock_t *ptl;
@@ -961,7 +955,7 @@ static struct page *follow_pud_mask(stru
 		return no_page_table(vma, flags, address);
 	if (pud_leaf(pud)) {
 		ptl = pud_lock(mm, pudp);
-		page = follow_huge_pud(vma, address, pudp, flags, ctx);
+		page = follow_huge_pud(vma, address, pudp, flags, page_mask);
 		spin_unlock(ptl);
 		if (page)
 			return page;
@@ -970,13 +964,13 @@ static struct page *follow_pud_mask(stru
 	if (unlikely(pud_bad(pud)))
 		return no_page_table(vma, flags, address);
 
-	return follow_pmd_mask(vma, address, pudp, flags, ctx);
+	return follow_pmd_mask(vma, address, pudp, flags, page_mask);
 }
 
 static struct page *follow_p4d_mask(struct vm_area_struct *vma,
 				    unsigned long address, pgd_t *pgdp,
 				    unsigned int flags,
-				    struct follow_page_context *ctx)
+				    unsigned long *page_mask)
 {
 	p4d_t *p4dp, p4d;
 
@@ -987,7 +981,7 @@ static struct page *follow_p4d_mask(stru
 	if (!p4d_present(p4d) || p4d_bad(p4d))
 		return no_page_table(vma, flags, address);
 
-	return follow_pud_mask(vma, address, p4dp, flags, ctx);
+	return follow_pud_mask(vma, address, p4dp, flags, page_mask);
 }
 
 /**
@@ -995,20 +989,16 @@ static struct page *follow_p4d_mask(stru
  * @vma: vm_area_struct mapping @address
  * @address: virtual address to look up
  * @flags: flags modifying lookup behaviour
- * @ctx: contains dev_pagemap for %ZONE_DEVICE memory pinning and a
- *       pointer to output page_mask
+ * @page_mask: a pointer to output page_mask
  *
  * @flags can have FOLL_ flags set, defined in <linux/mm.h>
  *
- * When getting pages from ZONE_DEVICE memory, the @ctx->pgmap caches
- * the device's dev_pagemap metadata to avoid repeating expensive lookups.
- *
  * When getting an anonymous page and the caller has to trigger unsharing
  * of a shared anonymous page first, -EMLINK is returned. The caller should
  * trigger a fault with FAULT_FLAG_UNSHARE set. Note that unsharing is only
  * relevant with FOLL_PIN and !FOLL_WRITE.
  *
- * On output, the @ctx->page_mask is set according to the size of the page.
+ * On output, @page_mask is set according to the size of the page.
  *
  * Return: the mapped (struct page *), %NULL if no mapping exists, or
  * an error pointer if there is a mapping to something not represented
@@ -1016,7 +1006,7 @@ static struct page *follow_p4d_mask(stru
  */
 static struct page *follow_page_mask(struct vm_area_struct *vma,
 			      unsigned long address, unsigned int flags,
-			      struct follow_page_context *ctx)
+			      unsigned long *page_mask)
 {
 	pgd_t *pgd;
 	struct mm_struct *mm = vma->vm_mm;
@@ -1024,13 +1014,13 @@ static struct page *follow_page_mask(str
 
 	vma_pgtable_walk_begin(vma);
 
-	ctx->page_mask = 0;
+	*page_mask = 0;
 	pgd = pgd_offset(mm, address);
 
 	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
 		page = no_page_table(vma, flags, address);
 	else
-		page = follow_p4d_mask(vma, address, pgd, flags, ctx);
+		page = follow_p4d_mask(vma, address, pgd, flags, page_mask);
 
 	vma_pgtable_walk_end(vma);
 
@@ -1368,7 +1358,7 @@ static long __get_user_pages(struct mm_s
 {
 	long ret = 0, i = 0;
 	struct vm_area_struct *vma = NULL;
-	struct follow_page_context ctx = { NULL };
+	unsigned long page_mask = 0;
 
 	if (!nr_pages)
 		return 0;
@@ -1410,7 +1400,7 @@ static long __get_user_pages(struct mm_s
 						pages ? &page : NULL);
 				if (ret)
 					goto out;
-				ctx.page_mask = 0;
+				page_mask = 0;
 				goto next_page;
 			}
 
@@ -1433,7 +1423,7 @@ retry:
 		}
 		cond_resched();
 
-		page = follow_page_mask(vma, start, gup_flags, &ctx);
+		page = follow_page_mask(vma, start, gup_flags, &page_mask);
 		if (!page || PTR_ERR(page) == -EMLINK) {
 			ret = faultin_page(vma, start, gup_flags,
 					   PTR_ERR(page) == -EMLINK, locked);
@@ -1466,7 +1456,7 @@ retry:
 			goto out;
 		}
 next_page:
-		page_increm = 1 + (~(start >> PAGE_SHIFT) & ctx.page_mask);
+		page_increm = 1 + (~(start >> PAGE_SHIFT) & page_mask);
 		if (page_increm > nr_pages)
 			page_increm = nr_pages;
 
@@ -1516,8 +1506,6 @@ next_page:
 		nr_pages -= page_increm;
 	} while (nr_pages);
 out:
-	if (ctx.pgmap)
-		put_dev_pagemap(ctx.pgmap);
 	return i ? i : ret;
 }
 
@@ -2849,7 +2837,6 @@ static int gup_fast_pte_range(pmd_t pmd,
 		unsigned long end, unsigned int flags, struct page **pages,
 		int *nr)
 {
-	struct dev_pagemap *pgmap = NULL;
 	int ret = 0;
 	pte_t *ptep, *ptem;
 
@@ -2922,8 +2909,6 @@ static int gup_fast_pte_range(pmd_t pmd,
 	ret = 1;
 
 pte_unmap:
-	if (pgmap)
-		put_dev_pagemap(pgmap);
 	pte_unmap(ptem);
 	return ret;
 }
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-gup-remove-dead-pgmap-refcounting-code.patch
mm-memremap-remove-unused-get_dev_pagemap-parameter.patch

