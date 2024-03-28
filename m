Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43146137759
	for <mm-commits@vger.kernel.org>; Thu, 28 Mar 2024 18:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711651746; cv=none; b=CazWfLA+f2+r3PMNtHG9DMc0vvYYylnyXc8zEO7CSKFaOe9DPTj0wYrihquCBA6zg7dBFFe/PVEu98SIR50JXVodDJXbx7xfjWBTmK8dswuYKCsPxJBnNvqVDxkVDyZ9vBkBpiSy2ZaQksz0aguvy3g60l4rpMZGn3zrf13dTCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711651746; c=relaxed/simple;
	bh=BJ++oF3Ajk/00+1emhHrJI+11ju2q81hTh9ZuDt8oL8=;
	h=Date:To:From:Subject:Message-Id; b=jmavO6OQlbu7oGSCzSETsoeqeVWlm3vwviCAtMEFOPZ8k2mFUt++fnN2nDb73/PUpA2La+SkbxJDidf2RPlhJ82HHkDPMrrHCmkOlPnkD84ov4uW7C3Z7SPNQICizCnK9eVgIIi8B0zWufPDwss8vPysls5x/kO4H5vuqn34JEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OYo8E/0W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OYo8E/0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD633C43390;
	Thu, 28 Mar 2024 18:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711651745;
	bh=BJ++oF3Ajk/00+1emhHrJI+11ju2q81hTh9ZuDt8oL8=;
	h=Date:To:From:Subject:From;
	b=OYo8E/0WBMGwVDDxwHfl0NZkz3nPLptkJxJr7UFWYxf5z0dzXE5myyzD7ZlEgPOpv
	 0tRe+01g3D2KgbGdlgp7Tm3rWeSKvx/tYFRnWzpf9+a4C/XBxQWKRVfReSQFG6titX
	 B+VRnlQ8Y1KJHEcLvT+Pv8iY5/NdJsPuPjnhl7o0=
Date: Thu, 28 Mar 2024 11:49:05 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,mgorman@techsingularity.net,jhubbard@nvidia.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-factor-out-the-numa-mapping-rebuilding-into-a-new-helper.patch removed from -mm tree
Message-Id: <20240328184905.AD633C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: factor out the numa mapping rebuilding into a new helper
has been removed from the -mm tree.  Its filename was
     mm-factor-out-the-numa-mapping-rebuilding-into-a-new-helper.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: factor out the numa mapping rebuilding into a new helper
Date: Tue, 26 Mar 2024 19:51:24 +0800

Patch series "support multi-size THP numa balancing".

This patchset tries to support mTHP numa balancing, as a simple solution
to start, the NUMA balancing algorithm for mTHP will follow the THP
strategy as the basic support.


This patch (of 2):

To support large folio's numa balancing, factor out the numa mapping
rebuilding into a new helper as a preparation.

Link: https://lkml.kernel.org/r/cover.1711453317.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/0c9df470bd2a62af8cc707cf01e42c7c744dd927.1711453317.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
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
@@ -5054,6 +5054,20 @@ int numa_migrate_prep(struct folio *foli
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
@@ -5159,13 +5173,7 @@ out_map:
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

mm-record-the-migration-reason-for-struct-migration_target_control.patch
mm-hugetlb-make-the-hugetlb-migration-strategy-consistent.patch
docs-hugetlbpagerst-add-hugetlb-migration-description.patch
mm-support-multi-size-thp-numa-balancing.patch

