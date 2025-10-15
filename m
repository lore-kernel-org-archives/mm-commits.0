Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E825F1F4613
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 01:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760492223; cv=none; b=F3aIWufF3itjUSiMlvwoqY6wTFzdon2l5zLs1vSvW8ABHXn52zLB4OXRI2VVHtIf5k62OxXt0Rxm2n9dhXiBsyfkxor32xGEKdT7gF3/aTFRD5kWu9zGzswDUnqbk+SCz4kqd3nWuN1kzOcjWmmwwq4Km+zDSm9OrJUnlCwzv5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760492223; c=relaxed/simple;
	bh=vsLhpHSN3fi4HZAyK9yKg7ea6SEe2p5F5c+hqTc208s=;
	h=Date:To:From:Subject:Message-Id; b=EwT8uE7xBko4AJ3xWRQq48ubwew+q3Kl41oF+YNAXawuS5Bw6z3FxzMGXVGJjKc8k4vKiFj5eYly9bMzlqoVAo0BC+jDTUFsthKg7qX+jz2mtld5fG/ZLTupCpeDkL62ubMHstsoA12slcY2zoPs1lPb/fZjgySYq1QdiBePOhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JQAojmnV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JQAojmnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63513C4CEE7;
	Wed, 15 Oct 2025 01:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760492221;
	bh=vsLhpHSN3fi4HZAyK9yKg7ea6SEe2p5F5c+hqTc208s=;
	h=Date:To:From:Subject:From;
	b=JQAojmnVVOhkkEhsAfb7giIPnJys521DbafT5lLwMrgGeJnCi2QQxRkRdHXsRt6TK
	 wxibxNjUz5aVcywpcfFs6K0W6TZUpSpH/C50UV3K7zV/938krs2XOFt6awhK1ASaFO
	 xupDOjY8M8sxdMSyI4Ea71J9H6WyFxD2kyCXh4UQ=
Date: Tue, 14 Oct 2025 18:37:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sidhartha.kumar@oracle.com,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-avoid-unnecessary-struct-page-accessing-if-pte_protnone.patch added to mm-new branch
Message-Id: <20251015013701.63513C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mprotect: avoid unnecessary struct page accessing if pte_protnone()
has been added to the -mm mm-new branch.  Its filename is
     mm-mprotect-avoid-unnecessary-struct-page-accessing-if-pte_protnone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-avoid-unnecessary-struct-page-accessing-if-pte_protnone.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mprotect: avoid unnecessary struct page accessing if pte_protnone()
Date: Tue, 14 Oct 2025 19:33:48 +0800

If the pte_protnone() is true, we could avoid unnecessary struct page
accessing and reduce cache footprint when scanning page tables for prot
numa, the performance test of pmbench memory accessing benchmark should be
benifit, see more commit a818f5363a0e ("autonuma: reduce cache footprint
when scanning page tables").

Link: https://lkml.kernel.org/r/20251014113349.2618158-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

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
 
@@ -307,23 +302,23 @@ static long change_pte_range(struct mmu_
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
+			if (prot_numa & prot_numa_skip(vma, target_node, folio)) {
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
mm-huge_memory-use-folio_skip_prot_numa-for-pmd-folio.patch

