Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA790156866
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 20:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712176825; cv=none; b=BmB2Gk4f8Sf0/2DwbHKVSkyQJQLrWY5o0es9iQHw7oO7qwI4B8G7NPOqOJwl8NtOtUQ9FMDfu3OS0BlWCwdqcvJKygU/qOHDJ9l4N50rRCQCL9LOnWYeqa0z4DezI/UpYfztGJ/6+VsYBUFgwoFfyQoUUl+7aui1a2Uq/fuWmxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712176825; c=relaxed/simple;
	bh=PtREw/S51Csxo7Y2/sl/51NOlrXsMLM5d3gkEqVpfVo=;
	h=Date:To:From:Subject:Message-Id; b=CnywXpJ7b1VPkTy3BYRWkQz21Hv2TMUVs2P80es+pcsCMRNLhfDUAo9d46l3iFfy5Mk7evWeknYjuFhDsZPFUu5OB/d6eP7gx1B+ywP5846vu8Hvh+mPBiADr4p2MovFwEPQZbHhTQT9WY5IvXzO0VKec/aK9MZZL2rZJ1GUVsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iOos82gU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iOos82gU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F65C433C7;
	Wed,  3 Apr 2024 20:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712176823;
	bh=PtREw/S51Csxo7Y2/sl/51NOlrXsMLM5d3gkEqVpfVo=;
	h=Date:To:From:Subject:From;
	b=iOos82gUPAm2SGn4cRRHnqLBX6POqKOP8jlbBl1ev3+cHsjoAVYa1Zs7XdjEyOJfG
	 rL20yGdbEYNbgC7PGnPnCEIOzY6SAD2JLR0pveNe1D1mEEY3nYjqeKEvJeAqS9TZuZ
	 vbWE0kI5PF/arYBe718Be9hykknD46hCOWG/QIl4=
Date: Wed, 03 Apr 2024 13:40:22 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,mgorman@techsingularity.net,jhubbard@nvidia.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-support-multi-size-thp-numa-balancing-v3.patch added to mm-unstable branch
Message-Id: <20240403204023.99F65C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-support-multi-size-thp-numa-balancing-v3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-support-multi-size-thp-numa-balancing-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-support-multi-size-thp-numa-balancing-v3.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-support-multi-size-thp-numa-balancing-v3
Date: Wed, 3 Apr 2024 16:39:10 +0800

- Reuse numa_rebuild_single_mapping() to remove duplicate code per Kefeng Wang.
- Remove an unnecessary vma_wants_manual_pte_write_upgrad() per Huang, Ying. 

Link: https://lkml.kernel.org/r/c33a5c0b0a0323b1f8ed53772f50501f4b196e25.1712132950.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

--- a/mm/memory.c~mm-support-multi-size-thp-numa-balancing-v3
+++ a/mm/memory.c
@@ -5064,32 +5064,32 @@ int numa_migrate_prep(struct folio *foli
 }
 
 static void numa_rebuild_single_mapping(struct vm_fault *vmf, struct vm_area_struct *vma,
+					unsigned long fault_addr, pte_t *fault_pte,
 					bool writable)
 {
 	pte_t pte, old_pte;
 
-	old_pte = ptep_modify_prot_start(vma, vmf->address, vmf->pte);
+	old_pte = ptep_modify_prot_start(vma, fault_addr, fault_pte);
 	pte = pte_modify(old_pte, vma->vm_page_prot);
 	pte = pte_mkyoung(pte);
 	if (writable)
 		pte = pte_mkwrite(pte, vma);
-	ptep_modify_prot_commit(vma, vmf->address, vmf->pte, old_pte, pte);
-	update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
+	ptep_modify_prot_commit(vma, fault_addr, fault_pte, old_pte, pte);
+	update_mmu_cache_range(vmf, vma, fault_addr, fault_pte, 1);
 }
 
 static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_struct *vma,
-				       struct folio *folio, pte_t fault_pte, bool ignore_writable)
+				       struct folio *folio, pte_t fault_pte,
+				       bool ignore_writable, bool pte_write_upgrade)
 {
 	int nr = pte_pfn(fault_pte) - folio_pfn(folio);
 	unsigned long start = max(vmf->address - nr * PAGE_SIZE, vma->vm_start);
 	unsigned long end = min(vmf->address + (folio_nr_pages(folio) - nr) * PAGE_SIZE, vma->vm_end);
 	pte_t *start_ptep = vmf->pte - (vmf->address - start) / PAGE_SIZE;
-	bool pte_write_upgrade = vma_wants_manual_pte_write_upgrade(vma);
 	unsigned long addr;
 
 	/* Restore all PTEs' mapping of the large folio */
 	for (addr = start; addr != end; start_ptep++, addr += PAGE_SIZE) {
-		pte_t pte, old_pte;
 		pte_t ptent = ptep_get(start_ptep);
 		bool writable = false;
 
@@ -5107,13 +5107,7 @@ static void numa_rebuild_large_mapping(s
 				writable = true;
 		}
 
-		old_pte = ptep_modify_prot_start(vma, addr, start_ptep);
-		pte = pte_modify(old_pte, vma->vm_page_prot);
-		pte = pte_mkyoung(pte);
-		if (writable)
-			pte = pte_mkwrite(pte, vma);
-		ptep_modify_prot_commit(vma, addr, start_ptep, old_pte, pte);
-		update_mmu_cache_range(vmf, vma, addr, start_ptep, 1);
+		numa_rebuild_single_mapping(vmf, vma, addr, start_ptep, writable);
 	}
 }
 
@@ -5123,6 +5117,7 @@ static vm_fault_t do_numa_page(struct vm
 	struct folio *folio = NULL;
 	int nid = NUMA_NO_NODE;
 	bool writable = false, ignore_writable = false;
+	bool pte_write_upgrade = vma_wants_manual_pte_write_upgrade(vma);
 	int last_cpupid;
 	int target_nid;
 	pte_t pte, old_pte;
@@ -5148,7 +5143,7 @@ static vm_fault_t do_numa_page(struct vm
 	 * is only valid while holding the PT lock.
 	 */
 	writable = pte_write(pte);
-	if (!writable && vma_wants_manual_pte_write_upgrade(vma) &&
+	if (!writable && pte_write_upgrade &&
 	    can_change_pte_writable(vma, vmf->address, pte))
 		writable = true;
 
@@ -5221,9 +5216,11 @@ out_map:
 	 * non-accessible ptes, some can allow access by kernel mode.
 	 */
 	if (folio && folio_test_large(folio))
-		numa_rebuild_large_mapping(vmf, vma, folio, pte, ignore_writable);
+		numa_rebuild_large_mapping(vmf, vma, folio, pte, ignore_writable,
+					   pte_write_upgrade);
 	else
-		numa_rebuild_single_mapping(vmf, vma, writable);
+		numa_rebuild_single_mapping(vmf, vma, vmf->address, vmf->pte,
+					    writable);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	goto out;
 }
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-record-the-migration-reason-for-struct-migration_target_control.patch
mm-hugetlb-make-the-hugetlb-migration-strategy-consistent.patch
docs-hugetlbpagerst-add-hugetlb-migration-description.patch
mm-factor-out-the-numa-mapping-rebuilding-into-a-new-helper.patch
mm-support-multi-size-thp-numa-balancing.patch
mm-support-multi-size-thp-numa-balancing-v3.patch
mm-huge_memory-add-the-missing-folio_test_pmd_mappable-for-thp-split-statistics.patch
mm-page_alloc-use-the-correct-thp-order-for-thp-pcp.patch

