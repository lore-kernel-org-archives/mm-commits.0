Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5408E15FD13
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854787; cv=none; b=EwF5qGFZg65lFGmnDHtzogBSSJmauwBkzkdvd+xP74tFekApB+rSo3kYx9tAQ+JvljTQsHl2ylL8tU6EUI5HS9xbThy8DRiUrtxMirjKTjSwqMcgB5O7dgcgfjEAq+G2aCYQLYwREfQqRAcBLYOmMLiv1W0qL9KWo9zoNxoSkVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854787; c=relaxed/simple;
	bh=OCMtvwq2ae1X2Mh7FrDHFxvZEUwi5lqHQH8IW6tp8CA=;
	h=Date:To:From:Subject:Message-Id; b=s490ZATdjYSGpJXCzTOOM+MHPhdBD3sd5sClJXzxCOHtc22Xgsfw1voPpOihBkKrcOSOsEwhb37hrUhiwmTaCbMysMkXgVRU21k4crM3LReG/ol0v6MCtgDF5KdykLIayIX+cpk5DncC67rWWKPt4T7j5pGMmZuYrrjYp+yPH4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kU1IULA1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kU1IULA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FE1C4CECF;
	Wed,  6 Nov 2024 00:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854787;
	bh=OCMtvwq2ae1X2Mh7FrDHFxvZEUwi5lqHQH8IW6tp8CA=;
	h=Date:To:From:Subject:From;
	b=kU1IULA16F94qSCOLCunPKogZegaB9n/Q21Xc7K3kApdqc5+esAvO3S2dOTtdE8CG
	 qd2u7btMv3PNUZl3cIwcNhxAC58eaZOuCQZTajGKezm6kpwfMADqdiJUVUMX36NyBw
	 SWtT+34qnrunwfDvSfOuwBiRV8YvvGXuWb91BaDw=
Date: Tue, 05 Nov 2024 16:59:46 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,ryan.roberts@arm.com,peterx@redhat.com,mhocko@suse.com,mark.rutland@arm.com,kirill.shutemov@linux.intel.com,jack@suse.cz,ioworker0@gmail.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,cl@gentwo.org,catalin.marinas@arm.com,baohua@kernel.org,apopple@nvidia.com,anshuman.khandual@arm.com,aneesh.kumar@kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-allocate-thp-on-hugezeropage-wp-fault.patch removed from -mm tree
Message-Id: <20241106005947.29FE1C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: allocate THP on hugezeropage wp-fault
has been removed from the -mm tree.  Its filename was
     mm-allocate-thp-on-hugezeropage-wp-fault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm: allocate THP on hugezeropage wp-fault
Date: Tue, 8 Oct 2024 11:47:46 +0530

Introduce do_huge_zero_wp_pmd() to handle wp-fault on a hugezeropage and
replace it with a PMD-mapped THP.  Remember to flush TLB entry
corresponding to the hugezeropage.  In case of failure, fallback to
splitting the PMD.

Link: https://lkml.kernel.org/r/20241008061746.285961-3-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-allocate-thp-on-hugezeropage-wp-fault
+++ a/mm/huge_memory.c
@@ -1781,6 +1781,38 @@ unlock:
 	spin_unlock(vmf->ptl);
 }
 
+static vm_fault_t do_huge_zero_wp_pmd(struct vm_fault *vmf)
+{
+	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
+	struct vm_area_struct *vma = vmf->vma;
+	struct mmu_notifier_range range;
+	struct folio *folio;
+	vm_fault_t ret = 0;
+
+	folio = vma_alloc_anon_folio_pmd(vma, vmf->address);
+	if (unlikely(!folio))
+		return VM_FAULT_FALLBACK;
+
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm, haddr,
+				haddr + HPAGE_PMD_SIZE);
+	mmu_notifier_invalidate_range_start(&range);
+	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
+	if (unlikely(!pmd_same(pmdp_get(vmf->pmd), vmf->orig_pmd)))
+		goto release;
+	ret = check_stable_address_space(vma->vm_mm);
+	if (ret)
+		goto release;
+	(void)pmdp_huge_clear_flush(vma, haddr, vmf->pmd);
+	map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
+	goto unlock;
+release:
+	folio_put(folio);
+unlock:
+	spin_unlock(vmf->ptl);
+	mmu_notifier_invalidate_range_end(&range);
+	return ret;
+}
+
 vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf)
 {
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
@@ -1793,8 +1825,15 @@ vm_fault_t do_huge_pmd_wp_page(struct vm
 	vmf->ptl = pmd_lockptr(vma->vm_mm, vmf->pmd);
 	VM_BUG_ON_VMA(!vma->anon_vma, vma);
 
-	if (is_huge_zero_pmd(orig_pmd))
+	if (is_huge_zero_pmd(orig_pmd)) {
+		vm_fault_t ret = do_huge_zero_wp_pmd(vmf);
+
+		if (!(ret & VM_FAULT_FALLBACK))
+			return ret;
+
+		/* Fallback to splitting PMD if THP cannot be allocated */
 		goto fallback;
+	}
 
 	spin_lock(vmf->ptl);
 
_

Patches currently in -mm which might be from dev.jain@arm.com are


