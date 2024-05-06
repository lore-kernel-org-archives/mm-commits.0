Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DE33A1CD
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957168; cv=none; b=TEtcgp3BDfbOUfcVdj2uXodz8mmUgCC4w+TD4DGhPNyUYIHRhcESmVcmILc7J+Jhoz6Ru+L3OFWfHaP44fDfi1DnzWtfaJ3IaGHLHEwgP0Sv5uF+li3OxCsGQHe0a3BW6apc1xxuKGQ1RSOnApEPUJLtcKocciboHivzhLGpwQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957168; c=relaxed/simple;
	bh=VbgNnfvIUQXWhyWTfSbMrlyDbC8TtcNw5hJVIKRH6LY=;
	h=Date:To:From:Subject:Message-Id; b=cs25QE3tatEfzugK+QwPhfYg2Kxk7piwqRF4Xe/7QFrraHkBFo2NOdT4bNPlzCh7xe2MKrBF5GscqYeA0L+TAy6iauQKj9qwbGJu4jZMN00l6kO7pqNCZDIY3X0U7/5IoAINhf1KDJwhS64LzoDKrytgi9HnAHXoxLaefTk3OH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BxBHFobm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BxBHFobm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E094C113CC;
	Mon,  6 May 2024 00:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957168;
	bh=VbgNnfvIUQXWhyWTfSbMrlyDbC8TtcNw5hJVIKRH6LY=;
	h=Date:To:From:Subject:From;
	b=BxBHFobm57rNPL5tZcrPmx+LnNL2N78lMGzru5wnvwmHeqj449vs0ZIfMfG+AzsJN
	 M8xPyjjxmNB5ZmxFKeZ3U0AB6w4zL6vmdtfDiFPAK1At3sxjmjak4VPTf8KoXGmUlr
	 SAyyKh6dZ0jw909qd7U3dbBxDqixU6GqZcQpLFuk=
Date: Sun, 05 May 2024 17:59:27 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,lstoakes@gmail.com,jhubbard@nvidia.com,jgg@nvidia.com,david@redhat.com,christophe.leroy@csgroup.eu,aneesh.kumar@kernel.org,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-fix-hugepd-handling-in-hugetlb-rework.patch removed from -mm tree
Message-Id: <20240506005928.0E094C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: fix hugepd handling in hugetlb rework
has been removed from the -mm tree.  Its filename was
     mm-gup-fix-hugepd-handling-in-hugetlb-rework.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/gup: fix hugepd handling in hugetlb rework
Date: Tue, 30 Apr 2024 09:13:03 -0400

Commit a12083d721d7 added hugepd handling for gup-slow, reusing gup-fast
functions.  follow_hugepd() correctly took the vma pointer in, however
didn't pass it over into the lower functions, which was overlooked.

The issue is gup_fast_hugepte() uses the vma pointer to make the correct
decision on whether an unshare is needed for a FOLL_PIN|FOLL_LONGTERM. 
Now without vma ponter it will constantly return "true" (needs an unshare)
for a page cache, even though in the SHARED case it will be wrong to
unshare.

The other problem is, even if an unshare is needed, it now returns 0
rather than -EMLINK, which will not trigger a follow up FAULT_FLAG_UNSHARE
fault.  That will need to be fixed too when the unshare is wanted.

gup_longterm test didn't expose this issue in the past because it didn't
yet test R/O unshare in this case, another separate patch will enable that
in future tests.

Fix it by passing vma correctly to the bottom, rename gup_fast_hugepte()
back to gup_hugepte() as it is shared between the fast/slow paths, and
also allow -EMLINK to be returned properly by gup_hugepte() even though
gup-fast will take it the same as zero.

Link: https://lkml.kernel.org/r/20240430131303.264331-1-peterx@redhat.com
Fixes: a12083d721d7 ("mm/gup: handle hugepd for follow_page()")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   64 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 39 insertions(+), 25 deletions(-)

--- a/mm/gup.c~mm-gup-fix-hugepd-handling-in-hugetlb-rework
+++ a/mm/gup.c
@@ -525,9 +525,17 @@ static unsigned long hugepte_addr_end(un
 	return (__boundary - 1 < end - 1) ? __boundary : end;
 }
 
-static int gup_fast_hugepte(pte_t *ptep, unsigned long sz, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+/*
+ * Returns 1 if succeeded, 0 if failed, -EMLINK if unshare needed.
+ *
+ * NOTE: for the same entry, gup-fast and gup-slow can return different
+ * results (0 v.s. -EMLINK) depending on whether vma is available.  This is
+ * the expected behavior, where we simply want gup-fast to fallback to
+ * gup-slow to take the vma reference first.
+ */
+static int gup_hugepte(struct vm_area_struct *vma, pte_t *ptep, unsigned long sz,
+		       unsigned long addr, unsigned long end, unsigned int flags,
+		       struct page **pages, int *nr)
 {
 	unsigned long pte_end;
 	struct page *page;
@@ -559,9 +567,9 @@ static int gup_fast_hugepte(pte_t *ptep,
 		return 0;
 	}
 
-	if (!pte_write(pte) && gup_must_unshare(NULL, flags, &folio->page)) {
+	if (!pte_write(pte) && gup_must_unshare(vma, flags, &folio->page)) {
 		gup_put_folio(folio, refs, flags);
-		return 0;
+		return -EMLINK;
 	}
 
 	*nr += refs;
@@ -577,19 +585,22 @@ static int gup_fast_hugepte(pte_t *ptep,
  * of the other folios. See writable_file_mapping_allowed() and
  * gup_fast_folio_allowed() for more information.
  */
-static int gup_fast_hugepd(hugepd_t hugepd, unsigned long addr,
-		unsigned int pdshift, unsigned long end, unsigned int flags,
-		struct page **pages, int *nr)
+static int gup_hugepd(struct vm_area_struct *vma, hugepd_t hugepd,
+		      unsigned long addr, unsigned int pdshift,
+		      unsigned long end, unsigned int flags,
+		      struct page **pages, int *nr)
 {
 	pte_t *ptep;
 	unsigned long sz = 1UL << hugepd_shift(hugepd);
 	unsigned long next;
+	int ret;
 
 	ptep = hugepte_offset(hugepd, addr, pdshift);
 	do {
 		next = hugepte_addr_end(addr, end, sz);
-		if (!gup_fast_hugepte(ptep, sz, addr, end, flags, pages, nr))
-			return 0;
+		ret = gup_hugepte(vma, ptep, sz, addr, end, flags, pages, nr);
+		if (ret != 1)
+			return ret;
 	} while (ptep++, addr = next, addr != end);
 
 	return 1;
@@ -613,22 +624,25 @@ static struct page *follow_hugepd(struct
 	h = hstate_vma(vma);
 	ptep = hugepte_offset(hugepd, addr, pdshift);
 	ptl = huge_pte_lock(h, vma->vm_mm, ptep);
-	ret = gup_fast_hugepd(hugepd, addr, pdshift, addr + PAGE_SIZE,
-			      flags, &page, &nr);
+	ret = gup_hugepd(vma, hugepd, addr, pdshift, addr + PAGE_SIZE,
+			 flags, &page, &nr);
 	spin_unlock(ptl);
 
-	if (ret) {
+	if (ret == 1) {
+		/* GUP succeeded */
 		WARN_ON_ONCE(nr != 1);
 		ctx->page_mask = (1U << huge_page_order(h)) - 1;
 		return page;
 	}
 
-	return NULL;
+	/* ret can be either 0 (translates to NULL) or negative */
+	return ERR_PTR(ret);
 }
 #else /* CONFIG_ARCH_HAS_HUGEPD */
-static inline int gup_fast_hugepd(hugepd_t hugepd, unsigned long addr,
-		unsigned int pdshift, unsigned long end, unsigned int flags,
-		struct page **pages, int *nr)
+static inline int gup_hugepd(struct vm_area_struct *vma, hugepd_t hugepd,
+			     unsigned long addr, unsigned int pdshift,
+			     unsigned long end, unsigned int flags,
+			     struct page **pages, int *nr)
 {
 	return 0;
 }
@@ -3261,8 +3275,8 @@ static int gup_fast_pmd_range(pud_t *pud
 			 * architecture have different format for hugetlbfs
 			 * pmd format and THP pmd format
 			 */
-			if (!gup_fast_hugepd(__hugepd(pmd_val(pmd)), addr,
-					     PMD_SHIFT, next, flags, pages, nr))
+			if (gup_hugepd(NULL, __hugepd(pmd_val(pmd)), addr,
+				       PMD_SHIFT, next, flags, pages, nr) != 1)
 				return 0;
 		} else if (!gup_fast_pte_range(pmd, pmdp, addr, next, flags,
 					       pages, nr))
@@ -3291,8 +3305,8 @@ static int gup_fast_pud_range(p4d_t *p4d
 					       pages, nr))
 				return 0;
 		} else if (unlikely(is_hugepd(__hugepd(pud_val(pud))))) {
-			if (!gup_fast_hugepd(__hugepd(pud_val(pud)), addr,
-					     PUD_SHIFT, next, flags, pages, nr))
+			if (gup_hugepd(NULL, __hugepd(pud_val(pud)), addr,
+				       PUD_SHIFT, next, flags, pages, nr) != 1)
 				return 0;
 		} else if (!gup_fast_pmd_range(pudp, pud, addr, next, flags,
 					       pages, nr))
@@ -3318,8 +3332,8 @@ static int gup_fast_p4d_range(pgd_t *pgd
 			return 0;
 		BUILD_BUG_ON(p4d_leaf(p4d));
 		if (unlikely(is_hugepd(__hugepd(p4d_val(p4d))))) {
-			if (!gup_fast_hugepd(__hugepd(p4d_val(p4d)), addr,
-					     P4D_SHIFT, next, flags, pages, nr))
+			if (gup_hugepd(NULL, __hugepd(p4d_val(p4d)), addr,
+				       P4D_SHIFT, next, flags, pages, nr) != 1)
 				return 0;
 		} else if (!gup_fast_pud_range(p4dp, p4d, addr, next, flags,
 					       pages, nr))
@@ -3347,8 +3361,8 @@ static void gup_fast_pgd_range(unsigned
 					       pages, nr))
 				return;
 		} else if (unlikely(is_hugepd(__hugepd(pgd_val(pgd))))) {
-			if (!gup_fast_hugepd(__hugepd(pgd_val(pgd)), addr,
-					      PGDIR_SHIFT, next, flags, pages, nr))
+			if (gup_hugepd(NULL, __hugepd(pgd_val(pgd)), addr,
+				       PGDIR_SHIFT, next, flags, pages, nr) != 1)
 				return;
 		} else if (!gup_fast_p4d_range(pgdp, pgd, addr, next, flags,
 					       pages, nr))
_

Patches currently in -mm which might be from peterx@redhat.com are


