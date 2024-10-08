Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5264189910
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 18:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728411657; cv=none; b=GJaodKZikktSobqowddFVl78heQREPacxEYQxX14LKTGMN9tnQxhh9Db5huOjkuHZUJih0fz2LNzO/e4ZbI0roAjCt1jiEEosHGzn4qOXlnLXp6cwB1UKjYLV12ek797BokgISDsw/WzXV+xzNrY/hhSP7M9iYxgIVwBpYyIxEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728411657; c=relaxed/simple;
	bh=bOfJV47m5I4ivzO4TmtgeU1KXkoCWt09KtaPmeoSj2M=;
	h=Date:To:From:Subject:Message-Id; b=iLXbMv3fIrecOT2CqwYhMctjEp50qyktTlKz/A8vJbX7RLMqT/P+LkIVjqgayP7tGyADPuAoP7jSbZWQqLhhpQvtvJBIq88tH+td9EKi5wyEDNo9dt5IIlczDcRlBdPQGUV/xoX+csknCSySk/Ll1X1EomTPCvpaw6cclgUgn1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jmSDF8ci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jmSDF8ci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6FCC4CECF;
	Tue,  8 Oct 2024 18:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728411657;
	bh=bOfJV47m5I4ivzO4TmtgeU1KXkoCWt09KtaPmeoSj2M=;
	h=Date:To:From:Subject:From;
	b=jmSDF8ciV70qeDIf2Oz1n4YSGbjQTymL5oMTj1mZtfhqzHGRImAzHsLokdvtLCEFV
	 lMyYUbCCa3tU0oY+dMivs5etDJopYblSEoDqFX9BUY8lL+Z/UZd5m5o1EqrUITUMh2
	 4kHlz7vMxjhySBrb9b9Co/XZmM4Mq3JAmGkk9KJc=
Date: Tue, 08 Oct 2024 11:20:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,ryan.roberts@arm.com,peterx@redhat.com,mhocko@suse.com,mark.rutland@arm.com,kirill.shutemov@linux.intel.com,jack@suse.cz,ioworker0@gmail.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,cl@gentwo.org,catalin.marinas@arm.com,baohua@kernel.org,apopple@nvidia.com,anshuman.khandual@arm.com,aneesh.kumar@kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-allocate-thp-on-hugezeropage-wp-fault.patch added to mm-unstable branch
Message-Id: <20241008182057.3B6FCC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: allocate THP on hugezeropage wp-fault
has been added to the -mm mm-unstable branch.  Its filename is
     mm-allocate-thp-on-hugezeropage-wp-fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-allocate-thp-on-hugezeropage-wp-fault.patch

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
@@ -1792,6 +1792,38 @@ unlock:
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
@@ -1804,8 +1836,15 @@ vm_fault_t do_huge_pmd_wp_page(struct vm
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

mm-abstract-thp-allocation.patch
mm-allocate-thp-on-hugezeropage-wp-fault.patch

