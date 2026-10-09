Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1944052B7
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525447; cv=none; b=A4iUmf8zLGshie51LHIZaGZXqlDCwMjAwVkOA90Pbt1cQfyV81C/xt99Cnnx7q47dwao8cy9RLy9W4cGllX4YxRKB007Rr8UtqpVw7d2YK9pBVOYBxXASfElErK8gqHZBVe+qY8uRTts35EGBzroFvGlm2xQguaKACRoMr4Rm/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525447; c=relaxed/simple;
	bh=TBFvC8pqFEX7yAWT6Zu00nTSv56rdLYI2AhLMaknNac=;
	h=Date:To:From:Subject:Message-Id; b=NvT4Gv80Gc8EipVpfz48WN5ScUOa26Q+iDY2YcvG9OVhz9OC3ng2iOBcZv5WkwFLawWGtjph3PszPYLEq/EruyLVzkBk3rb/YoR/TRwn3iq39Fl5rk72W6HKA7zSKxI2UWn47DO4wL1QBPVCltAk6AFWjGYQ3wb39Xc94LkGdTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZLEhZW+U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZLEhZW+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D3A1F000FF;
	Fri,  9 Oct 2026 05:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525446;
	bh=WUNedxDtcLCfCzOV8JgL/RHFzbm6ap/cecHgdWOgXXs=;
	h=Date:To:From:Subject;
	b=ZLEhZW+U5fMW0GklZasdFR2UPB7Bf3e5EcufvNgEiF0EzeIYtQUvj3QmZzr+EVshi
	 kYhfgudWIxCRW7ClcbCTG6MdETsSmj6F7STP+ALMkFAt3zFSEAL4ltplkNAKrxEJHx
	 gJI//OJ8/EAJws/XXwwf6YjsFHCH9hBsv8lDRSgU=
Date: Thu, 08 Oct 2026 22:57:25 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,kiyer@crusoe.ai,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-ops-common-handle-hugetlb-folios-in-folio-mkold-young-rmap-walkers.patch removed from -mm tree
Message-Id: <20261009055725.E5D3A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/ops-common: handle hugetlb folios in folio mkold/young rmap walkers
has been removed from the -mm tree.  Its filename was
     mm-damon-ops-common-handle-hugetlb-folios-in-folio-mkold-young-rmap-walkers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Krishna Iyer <kiyer@crusoe.ai>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Claude:claude-fable-5
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


