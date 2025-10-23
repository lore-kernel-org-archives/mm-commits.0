Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3CA34D4F7
	for <mm-commits@vger.kernel.org>; Thu, 23 Oct 2025 20:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761250471; cv=none; b=pdx4uPnPzk7O/TJKrhUBFjQtAntCpD341u8SOK/06WjG/EJ7visu9d2ck6Cx3IBau9zrKp5fPKSNY5QYM3rgabgVFUa1EG73p+6cYYM2nv0lQaHHgLEWtJvkOPxqXX4WSxd5Uvwi1hKur9ORyAXdooavz/h0O54rCzvklxB4tT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761250471; c=relaxed/simple;
	bh=cZjYdyPgymPkuv+m0shGG4HeFeCiOaVbRXXil3ibXv4=;
	h=Date:To:From:Subject:Message-Id; b=MKbXVVky6EG8TQNFkVdAvJdWoNuWwk5No0hFCB0mmWFtfYh+7CAsN5qJxKA+dgiaNEbJvNZ35GlJm0AlB+GmuEVR7RpDXEMJMLTQZoBpzeNVQSkmGl3Po7xLPky+KDgHVkoKsQLuuzO7ZbGbMMoDuaPHETOg3o7h4dktV3373Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YYa5OV5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YYa5OV5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12768C4CEE7;
	Thu, 23 Oct 2025 20:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761250471;
	bh=cZjYdyPgymPkuv+m0shGG4HeFeCiOaVbRXXil3ibXv4=;
	h=Date:To:From:Subject:From;
	b=YYa5OV5nWQYINYiBeutW37xm5A1Of2VG7dhKPkxtQf5uEfjHEBSTDsoZJyceS+kQM
	 6zu8x2r+yfjotqk7pRLSB579IJZdowvpjPPr8FCSMFSWtXc6jMBlqjIAq06y1aoEP9
	 9VpBhvX74rti6nvc4NJGGKmpf8DFp0L3pa0HOmao=
Date: Thu, 23 Oct 2025 13:14:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sidhartha.kumar@oracle.com,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-avoid-unnecessary-struct-page-accessing-if-pte_protnone.patch added to mm-unstable branch
Message-Id: <20251023201431.12768C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mprotect: avoid unnecessary struct page accessing if pte_protnone()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mprotect-avoid-unnecessary-struct-page-accessing-if-pte_protnone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-avoid-unnecessary-struct-page-accessing-if-pte_protnone.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mprotect: avoid unnecessary struct page accessing if pte_protnone()
Date: Thu, 23 Oct 2025 19:37:35 +0800

If the pte_protnone() is true, we could avoid unnecessary struct page
accessing and reduce cache footprint when scanning page tables for prot
numa, there was a similar change before, see more commit a818f5363a0e
("autonuma: reduce cache footprint when scanning page tables").

Link: https://lkml.kernel.org/r/20251023113737.3572790-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-avoid-unnecessary-struct-page-accessing-if-pte_protnone
+++ a/mm/mprotect.c
@@ -118,18 +118,13 @@ static int mprotect_folio_pte_batch(stru
 	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
 }
 
-static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
-			   pte_t oldpte, pte_t *pte, int target_node,
-			   struct folio *folio)
+static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
+		struct folio *folio)
 {
 	bool ret = true;
 	bool toptier;
 	int nid;
 
-	/* Avoid TLB flush if possible */
-	if (pte_protnone(oldpte))
-		goto skip;
-
 	if (!folio)
 		goto skip;
 
@@ -307,23 +302,25 @@ static long change_pte_range(struct mmu_
 			struct page *page;
 			pte_t ptent;
 
+			/* Already in the desired state. */
+			if (prot_numa && pte_protnone(oldpte))
+				continue;
+
 			page = vm_normal_page(vma, addr, oldpte);
 			if (page)
 				folio = page_folio(page);
+
 			/*
 			 * Avoid trapping faults against the zero or KSM
 			 * pages. See similar comment in change_huge_pmd.
 			 */
-			if (prot_numa) {
-				int ret = prot_numa_skip(vma, addr, oldpte, pte,
-							 target_node, folio);
-				if (ret) {
-
-					/* determine batch to skip */
-					nr_ptes = mprotect_folio_pte_batch(folio,
-						  pte, oldpte, max_nr_ptes, /* flags = */ 0);
-					continue;
-				}
+			if (prot_numa &&
+			    prot_numa_skip(vma, target_node, folio)) {
+
+				/* determine batch to skip */
+				nr_ptes = mprotect_folio_pte_batch(folio,
+					  pte, oldpte, max_nr_ptes, /* flags = */ 0);
+				continue;
 			}
 
 			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-mprotect-always-skip-dma-pinned-folio-in-prot_numa_skip.patch
mm-mprotect-avoid-unnecessary-struct-page-accessing-if-pte_protnone.patch
mm-mprotect-convert-to-folio_can_map_prot_numa.patch
mm-huge_memory-use-folio_can_map_prot_numa-for-pmd-folio.patch
mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page.patch
mm-page_alloc-add-__split_page.patch
mm-cma-add-__cma_release.patch
mm-page_alloc-add-alloc_contig_frozen_rangepages.patch
mm-cma-add-cma_alloc_frozen_compound.patch
mm-hugetlb-allocate-frozen-pages-in-alloc_gigantic_folio.patch

