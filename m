Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA389A95C
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 20:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753217325; cv=none; b=d7s+3jd3Xkj64XEufXs7cttWm156aVpoSh+tT2ypkosIlrMN/gmFIRUFeYe9KOnchBrqg3pymtmuc9rY53ZNNKQ0+O0CkK1m0+MwtgyNfIn5UTUdaWeG/7t38SBHDA9Cv+f3jIdrSoapG/tSTVP6LMK+WURBzmaSpVPWsqtNJ7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753217325; c=relaxed/simple;
	bh=4MXMd9D/U94p5mcYwp8MLl6CP02ecgcsorSugAzPKS0=;
	h=Date:To:From:Subject:Message-Id; b=MI4h8r+/rG47BJFGFwuOzmolIzOtTOfDGZav1y4YzfOGb0XIFzGRe0INcH9vpXae9OGZ3zp3dhhvMlbnc0QMJgMfyUviIjaE8p/KAzs6SrpO5UQXRSA1GE/gxjyogr3uJJSx0T8tBJvQ8Pl1yqtycH7p4dghGGXCZs7csVEmEag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fR3qoq7g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fR3qoq7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58BD4C4CEEB;
	Tue, 22 Jul 2025 20:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753217324;
	bh=4MXMd9D/U94p5mcYwp8MLl6CP02ecgcsorSugAzPKS0=;
	h=Date:To:From:Subject:From;
	b=fR3qoq7glWhD0HuvkL6LAkJurvWrQi3IS0EMaM+i3CYCa3Mr47li3vU9wrPN+nAHU
	 NgmVqAkPn9P76MxNMs9VtRyzitZcWrGy+QE90i6+YX1Fbvxe+RZT/abStzaB3M3D5g
	 whxfjqJ7jZ3py1MD1LtRDsOkOGxzoGgvaqMnQMp4=
Date: Tue, 22 Jul 2025 13:48:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-optimize-__collapse_huge_page_copy_succeeded-by-pte-batching.patch added to mm-new branch
Message-Id: <20250722204844.58BD4C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: optimize __collapse_huge_page_copy_succeeded() by PTE batching
has been added to the -mm mm-new branch.  Its filename is
     khugepaged-optimize-__collapse_huge_page_copy_succeeded-by-pte-batching.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-optimize-__collapse_huge_page_copy_succeeded-by-pte-batching.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: khugepaged: optimize __collapse_huge_page_copy_succeeded() by PTE batching
Date: Tue, 22 Jul 2025 20:35:58 +0530

Use PTE batching to optimize __collapse_huge_page_copy_succeeded().

On arm64, suppose khugepaged is scanning a pte-mapped 2MB THP for
collapse.  Then, calling ptep_clear() for every pte will cause a TLB flush
for every contpte block.  Instead, clear_ptes() does a
contpte_try_unfold_partial() which will flush the TLB only for the (if
any) starting and ending contpte block, if they partially overlap with the
range khugepaged is looking at.

For all arches, there should be a benefit due to batching atomic
operations on mapcounts due to folio_remove_rmap_ptes() and saving some
calls.

Link: https://lkml.kernel.org/r/20250722150559.96465-3-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/mm/khugepaged.c~khugepaged-optimize-__collapse_huge_page_copy_succeeded-by-pte-batching
+++ a/mm/khugepaged.c
@@ -700,12 +700,15 @@ static void __collapse_huge_page_copy_su
 						spinlock_t *ptl,
 						struct list_head *compound_pagelist)
 {
+	unsigned long end = address + HPAGE_PMD_SIZE;
 	struct folio *src, *tmp;
-	pte_t *_pte;
 	pte_t pteval;
+	pte_t *_pte;
+	int nr_ptes;
 
-	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
-	     _pte++, address += PAGE_SIZE) {
+	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
+	     address += nr_ptes * PAGE_SIZE) {
+		nr_ptes = 1;
 		pteval = ptep_get(_pte);
 		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
 			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
@@ -722,18 +725,26 @@ static void __collapse_huge_page_copy_su
 			struct page *src_page = pte_page(pteval);
 
 			src = page_folio(src_page);
-			if (!folio_test_large(src))
+
+			if (folio_test_large(src)) {
+				int max_nr_ptes = (end - address) >> PAGE_SHIFT;
+
+				nr_ptes = folio_pte_batch(src, _pte, pteval, max_nr_ptes);
+			} else {
 				release_pte_folio(src);
+			}
+
 			/*
 			 * ptl mostly unnecessary, but preempt has to
 			 * be disabled to update the per-cpu stats
 			 * inside folio_remove_rmap_pte().
 			 */
 			spin_lock(ptl);
-			ptep_clear(vma->vm_mm, address, _pte);
-			folio_remove_rmap_pte(src, src_page, vma);
+			clear_ptes(vma->vm_mm, address, _pte, nr_ptes);
+			folio_remove_rmap_ptes(src, src_page, nr_ptes, vma);
 			spin_unlock(ptl);
-			free_folio_and_swap_cache(src);
+			free_swap_cache(src);
+			folio_put_refs(src, nr_ptes);
 		}
 	}
 
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-refactor-mm_cp_prot_numa-skipping-case-into-new-function.patch
mm-optimize-mprotect-for-mm_cp_prot_numa-by-batch-skipping-ptes.patch
mm-add-batched-versions-of-ptep_modify_prot_start-commit.patch
mm-introduce-fpb_respect_write-for-pte-batching-infrastructure.patch
mm-split-can_change_pte_writable-into-private-and-shared-parts.patch
mm-optimize-mprotect-by-pte-batching.patch
arm64-add-batched-versions-of-ptep_modify_prot_start-commit.patch
khugepaged-optimize-__collapse_huge_page_copy_succeeded-by-pte-batching.patch
khugepaged-optimize-collapse_pte_mapped_thp-by-pte-batching.patch

