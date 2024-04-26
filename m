Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040A97F7D1
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104106; cv=none; b=RaXGrux+hZX2jePh7FoqcgfemmYPYFPmUawlWYsqmyEqX4+V4xOK4ekmefDui4yLYpaNIrnsLwhvQjc+LOOVvzFSVehPu1xC2VP4HhWMjL5UiF1EL+KAJs9gkYoX3ExPl6b5L+/c8pT2F+Ncru0ipUb9hFs01cbweErqJ2qAzJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104106; c=relaxed/simple;
	bh=e7LSUNgOcZDlNZaeyzw7RSIahUnHajum8i1Yadqj+MQ=;
	h=Date:To:From:Subject:Message-Id; b=XLNzIV2XWSe5ajigZ7aKH9ptCD+lDyYFDmSzEPLpq1gkOwbjhTrB7RR9LLV+VpSnBBbsLn4AoYUaQPQymyzvFlh6Oqfk5y9Bn1eLYzYBWqq1iLAZ1dWWsw0DDnb3v+YWUuws4XIERDvvMy39tbBLo8Kse1cUxFpLcd8g6Ol/UAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jO69NbZM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jO69NbZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDBFFC113CD;
	Fri, 26 Apr 2024 04:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104105;
	bh=e7LSUNgOcZDlNZaeyzw7RSIahUnHajum8i1Yadqj+MQ=;
	h=Date:To:From:Subject:From;
	b=jO69NbZMWyXi8l6Npg6A0hkPu6abpST379JOuX++t9fvVzyfvhyQ/tUK1qIYxuyXh
	 vFEQ0njR209NhFl2coJsk1oSCsbUy0Zdj0Rgh+jZ1Y+dQ2fih3yZ1Y9ImMvrZ/WCn0
	 0q0x+JAzDtYTs7yIT4Z6DKHufnuiQqe2UBRr5Vgs=
Date: Thu, 25 Apr 2024 21:01:45 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,mgorman@techsingularity.net,jhubbard@nvidia.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-factor-out-the-numa-mapping-rebuilding-into-a-new-helper.patch removed from -mm tree
Message-Id: <20240426040145.CDBFFC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: factor out the numa mapping rebuilding into a new helper
has been removed from the -mm tree.  Its filename was
     mm-factor-out-the-numa-mapping-rebuilding-into-a-new-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: factor out the numa mapping rebuilding into a new helper
Date: Fri, 29 Mar 2024 14:56:45 +0800

Patch series "support multi-size THP numa balancing", v2.

This patchset tries to support mTHP numa balancing, as a simple solution
to start, the NUMA balancing algorithm for mTHP will follow the THP
strategy as the basic support.  Please find details in each patch.


This patch (of 2):

To support large folio's numa balancing, factor out the numa mapping
rebuilding into a new helper as a preparation.

Link: https://lkml.kernel.org/r/cover.1712132950.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/cover.1711683069.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/8bc2586bdd8dbbe6d83c09b77b360ec8fcac3736.1711683069.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/mm/memory.c~mm-factor-out-the-numa-mapping-rebuilding-into-a-new-helper
+++ a/mm/memory.c
@@ -5063,6 +5063,20 @@ int numa_migrate_prep(struct folio *foli
 	return mpol_misplaced(folio, vmf, addr);
 }
 
+static void numa_rebuild_single_mapping(struct vm_fault *vmf, struct vm_area_struct *vma,
+					bool writable)
+{
+	pte_t pte, old_pte;
+
+	old_pte = ptep_modify_prot_start(vma, vmf->address, vmf->pte);
+	pte = pte_modify(old_pte, vma->vm_page_prot);
+	pte = pte_mkyoung(pte);
+	if (writable)
+		pte = pte_mkwrite(pte, vma);
+	ptep_modify_prot_commit(vma, vmf->address, vmf->pte, old_pte, pte);
+	update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
+}
+
 static vm_fault_t do_numa_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -5168,13 +5182,7 @@ out_map:
 	 * Make it present again, depending on how arch implements
 	 * non-accessible ptes, some can allow access by kernel mode.
 	 */
-	old_pte = ptep_modify_prot_start(vma, vmf->address, vmf->pte);
-	pte = pte_modify(old_pte, vma->vm_page_prot);
-	pte = pte_mkyoung(pte);
-	if (writable)
-		pte = pte_mkwrite(pte, vma);
-	ptep_modify_prot_commit(vma, vmf->address, vmf->pte, old_pte, pte);
-	update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
+	numa_rebuild_single_mapping(vmf, vma, writable);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	goto out;
 }
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-page_alloc-allowing-mthp-compaction-to-capture-the-freed-page-directly.patch

