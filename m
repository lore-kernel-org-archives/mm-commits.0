Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67A9201278
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343135; cv=none; b=UE2fSykxSAX8baIRFP7vJ09hOErewC+g+Fd6LOwvTDrKpeTh5EaQklUe8UCkXeBPy1GPCAUlTmzUPZwVeZMa48HCU2ky1FeG9QlMGvorvfMoMb1VQKnB8UVXSXgqegZZzpP8WlEJtI/gWNEYYLPpcA9+FQgf9yGOdBXygySgO8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343135; c=relaxed/simple;
	bh=JeW1S/b/O8woh+3vbbLVxrMBxwBJZOid4aMgMUaCXc8=;
	h=Date:To:From:Subject:Message-Id; b=Cr242KoB6fp4FVGiPUwR8JrG5NqhDAtDkefLntE6OMNN4y2fx0iGerDrn14dp+/oog1oSNlbZQcNQLWdUIaE2CE64tT8hckI5DCgdqtqNQ5qtT9k4PQDtgD2BGIpkjS/Iiftb96uCE9w80SuPTBrv7FvfNx4scxuAVh8JEACvBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gWWDGYIq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gWWDGYIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56B6C113D0;
	Mon, 17 Nov 2025 01:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343135;
	bh=JeW1S/b/O8woh+3vbbLVxrMBxwBJZOid4aMgMUaCXc8=;
	h=Date:To:From:Subject:From;
	b=gWWDGYIqrDDmzKW7Cc/95GvQ40M3pNd7c3t3NnICPnad5karNff9IKgDxHykG+bso
	 fxLuH0JrAkO4kNH7E0UKL+gZH2yvnJnDo+pygOpSfP3n5jHhSlgo3ayj43ETM/H3NQ
	 eiSqVQPsOwimIMLthF+U8/jpTF409nQ3/lEbq7TY=
Date: Sun, 16 Nov 2025 17:32:14 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sidhartha.kumar@oracle.com,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mprotect-avoid-unnecessary-struct-page-accessing-if-pte_protnone.patch removed from -mm tree
Message-Id: <20251117013215.A56B6C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mprotect: avoid unnecessary struct page accessing if pte_protnone()
has been removed from the -mm tree.  Its filename was
     mm-mprotect-avoid-unnecessary-struct-page-accessing-if-pte_protnone.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-kill-mm_wr_locked-from-unmap_vmas-and-unmap_single_vma.patch

