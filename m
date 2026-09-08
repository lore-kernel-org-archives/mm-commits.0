Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D565C598C03
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 18:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788893963; cv=none; b=jSLt0vaFq8++irMxNK+TRQqJbSDUHD5QqAvspGhbrozz4YMuvmCpH1TGTMC1aycoPR8s59t2xJeq6DH3Q8nWsrHO3y69tOT9ky+NtaTjYHnuyW6mExW66po6Hb7KJH5CtQHKBbnK8YQXNTGGJmmqvmvDhbl/efbPmjLE4cNM5J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788893963; c=relaxed/simple;
	bh=8Lld7O1QgWtLzgV/p9mc3C9xORGRmH6lBqpkiEOv9mw=;
	h=Date:To:From:Subject:Message-Id; b=C5STUXqi+M6Fgn4THzySJfsDaTQWejp69c40+2t3TVq2KZralvvYt8TdI40PdQIgrpeC9h5QZgsQqDwPQ8aJh3FXyntQjXg9CGFvSy0abfS8pD8eWwUXi+jG+1ZKYwrudkc6bsYy2lX8DsB+AeLCDMJvrzDGqkNxgEDx1aeVw34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sSdsKzsc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sSdsKzsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7643F1F00A3A;
	Tue,  8 Sep 2026 18:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788893961;
	bh=UD56K9oyakHV70nJAMBDM42iCFU2aXD/dQBmnlHn6Gs=;
	h=Date:To:From:Subject;
	b=sSdsKzsczRzxzrGxe4VWuVqrbnRWtalSnmnNQu4DevjBsS4ftfBqTDdH23TYV3oa2
	 mGoQuc3Qy1FDKTcOZyyO29fbmSRWTbaKbxSbIJi5PsstkX9m2SMbmVFI9P27HLhHP7
	 FSiJClhoQ4cx5YQPr1zD7+2k+mVTkZq7xKqGz/Ac=
Date: Tue, 08 Sep 2026 11:59:21 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,kiyer@crusoe.ai,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-ops-common-handle-hugetlb-folios-in-folio-mkold-young-rmap-walkers.patch added to mm-new branch
Message-Id: <20260908185921.7643F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/ops-common: handle hugetlb folios in folio mkold/young rmap walkers
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-ops-common-handle-hugetlb-folios-in-folio-mkold-young-rmap-walkers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-ops-common-handle-hugetlb-folios-in-folio-mkold-young-rmap-walkers.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Krishna Iyer <kiyer@crusoe.ai>
Subject: mm/damon/ops-common: handle hugetlb folios in folio mkold/young rmap walkers
Date: Tue, 8 Sep 2026 06:51:54 -0700

damon_folio_mkold_one() and damon_folio_young_one() assume the folios they
walk are mapped by normal PTEs or THP PMDs.  When the folio is a hugetlb
folio, page_vma_mapped_walk() returns the huge PTE in pvmw.pte with its
page table lock held, but the walkers treat it as a normal PTE: they read
and age it with PAGE_SIZE-granularity helpers, which is wrong for huge
PTEs (up to PUD level), and notify secondary MMUs for only PAGE_SIZE of
the mapping.

Add hugetlb branches to both walkers.  The mkold walker reuses
damon_hugetlb_mkold(), which the virtual address space operations set has
been using for hugetlb aging: it clears the young bit of the huge PTE via
set_huge_pte_at() and calls mmu_notifier_clear_young() spanning the whole
huge page size.  The young walker gets an equivalent new helper,
damon_hugetlb_young(), which reads the huge PTE with huge_ptep_get() and
consults the page idle flag and mmu_notifier_test_young() like the
existing PTE branch.

Locking mirrors what page_vma_mapped_walk() provides: the huge PTE's page
table lock is held inside the walk, and for shared hugetlb mappings (the
only ones subject to huge PMD sharing), rmap_walk_file() already holds
i_mmap_rwsem, satisfying hugetlb_walk()'s locking requirements.

This is currently dead code: both rmap walkers are only reachable through
damon_get_folio(), which rejects hugetlb folios since they are not on the
LRU lists.  A following commit will let the physical address space
monitoring primitives opt in to hugetlb folios.

Link: https://lore.kernel.org/20260902025700.17975-3-kiyer@crusoe.ai
Link: https://lore.kernel.org/20260908135156.97481-3-sj@kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Krishna Iyer <kiyer@crusoe.ai>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |   61 ++++++++++++++++++++++++++++++----------
 1 file changed, 47 insertions(+), 14 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-handle-hugetlb-folios-in-folio-mkold-young-rmap-walkers
+++ a/mm/damon/ops-common.c
@@ -205,10 +205,15 @@ static bool damon_folio_mkold_one(struct
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		addr = pvmw.address;
-		if (pvmw.pte)
-			damon_ptep_mkold(pvmw.pte, vma, addr);
-		else
+		if (pvmw.pte) {
+			if (folio_test_hugetlb(folio))
+				damon_hugetlb_mkold(pvmw.pte, vma->vm_mm, vma,
+						addr);
+			else
+				damon_ptep_mkold(pvmw.pte, vma, addr);
+		} else {
 			damon_pmdp_mkold(pvmw.pmd, vma, addr);
+		}
 	}
 	return true;
 }
@@ -233,27 +238,55 @@ void damon_folio_mkold(struct folio *fol
 
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+static bool damon_hugetlb_young(pte_t *pte, struct vm_area_struct *vma,
+		unsigned long addr, struct folio *folio)
+{
+	pte_t entry = huge_ptep_get(vma->vm_mm, addr, pte);
+
+	return (pte_present(entry) && pte_young(entry)) ||
+		!folio_test_idle(folio) ||
+		mmu_notifier_test_young(vma->vm_mm, addr);
+}
+#else
+static bool damon_hugetlb_young(pte_t *pte, struct vm_area_struct *vma,
+		unsigned long addr, struct folio *folio)
+{
+	return false;
+}
+#endif	/* CONFIG_HUGETLB_PAGE */
+
+static bool damon_pte_young(pte_t *pte, struct vm_area_struct *vma,
+		unsigned long addr, struct folio *folio)
+{
+	pte_t entry = ptep_get(pte);
+
+	/*
+	 * PFN swap PTEs, such as device-exclusive ones, that actually map
+	 * pages are "old" from a CPU perspective. The MMU notifier takes care
+	 * of any device aspects.
+	 */
+	return (pte_present(entry) && pte_young(entry)) ||
+		!folio_test_idle(folio) ||
+		mmu_notifier_test_young(vma->vm_mm, addr);
+}
+
 static bool damon_folio_young_one(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long addr, void *arg)
 {
 	bool *accessed = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, addr, 0);
-	pte_t pte;
 
 	*accessed = false;
 	while (page_vma_mapped_walk(&pvmw)) {
 		addr = pvmw.address;
 		if (pvmw.pte) {
-			pte = ptep_get(pvmw.pte);
-
-			/*
-			 * PFN swap PTEs, such as device-exclusive ones, that
-			 * actually map pages are "old" from a CPU perspective.
-			 * The MMU notifier takes care of any device aspects.
-			 */
-			*accessed = (pte_present(pte) && pte_young(pte)) ||
-				!folio_test_idle(folio) ||
-				mmu_notifier_test_young(vma->vm_mm, addr);
+			if (folio_test_hugetlb(folio))
+				*accessed = damon_hugetlb_young(pvmw.pte, vma,
+						addr, folio);
+			else
+				*accessed = damon_pte_young(pvmw.pte, vma,
+						addr, folio);
 		} else {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			pmd_t pmd = pmdp_get(pvmw.pmd);
_

Patches currently in -mm which might be from kiyer@crusoe.ai are

mm-damon-move-damon_hugetlb_mkold-from-vaddr-to-ops-common.patch
mm-damon-ops-common-handle-hugetlb-folios-in-folio-mkold-young-rmap-walkers.patch
mm-damon-paddr-support-hugetlb-folios-in-access-monitoring.patch

