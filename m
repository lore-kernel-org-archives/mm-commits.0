Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D80B1E7C1C
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160858; cv=none; b=B37BCoE+UpfwsERJkDQrHT5TQB/ZJMCPY0H3Y7CxN4Qhl3DpgpiWJiV9vUoiYEnHkUriijKoyMy5zhEeCC76vPhM8UtlumNjtC7sX68pwWLuLNnV2YmoiZNlq5Vs+ixUbKoxn636JJQQK9scgvBTHdyL2Qaa5d0RejFtErKCSMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160858; c=relaxed/simple;
	bh=18zGgWYw/jj6bbtYpP6F9/onwKTb2JsQ1fugmLe2OvU=;
	h=Date:To:From:Subject:Message-Id; b=Uzd+bmNXruDeSRDdiTRqu1jM3alyXcRs1FAeneERzszZhRuwdqP4u2jVUuHe8FMxgGuKeirIB2LSjO/gHL2iy1y0WQI36HqQzkyqLp4C82F8GOUv9ZSY15I6EW4lIg/IUwpACLZxeLW8lOIscFxDjB+Ri+6bI7exJ4gRSadU7t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fVzqPqty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fVzqPqty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72184C4CEEF;
	Sat,  2 Aug 2025 18:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160858;
	bh=18zGgWYw/jj6bbtYpP6F9/onwKTb2JsQ1fugmLe2OvU=;
	h=Date:To:From:Subject:From;
	b=fVzqPqtyRW3CWL+IIb6ovnTqOPblcXJWpmWYOfcqVchdN+wogkYSJ5+xzxJibnIl8
	 IoBea4yX+WRIiaWeJ8bipLF0vlxHdFnkU33Dcc7G4af2Nagp1gB1/GHc+4lQxq3Zvu
	 7/0jP2+6c/wOHf/vHz4ex/k4yvXhZ5jSsY1DIVUQ=
Date: Sat, 02 Aug 2025 11:54:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] khugepaged-optimize-__collapse_huge_page_copy_succeeded-by-pte-batching.patch removed from -mm tree
Message-Id: <20250802185418.72184C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: khugepaged: optimize __collapse_huge_page_copy_succeeded() by PTE batching
has been removed from the -mm tree.  Its filename was
     khugepaged-optimize-__collapse_huge_page_copy_succeeded-by-pte-batching.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: khugepaged: optimize __collapse_huge_page_copy_succeeded() by PTE batching
Date: Thu, 24 Jul 2025 10:53:00 +0530

Use PTE batching to batch process PTEs mapping the same large folio. An
improvement is expected due to batching refcount-mapcount manipulation on
the folios, and for arm64 which supports contig mappings, the number of
TLB flushes is also reduced.

Link: https://lkml.kernel.org/r/20250724052301.23844-3-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
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
+	unsigned int nr_ptes;
 
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
+				unsigned int max_nr_ptes = (end - address) >> PAGE_SHIFT;
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


