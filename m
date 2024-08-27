Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0482377117
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724802756; cv=none; b=WWAWaYtsOHNuJMoi+r2ah5VfBBMRxeoap2PZ/ADKItmDazmYtM9PUFqIGRLU6As72sr4ZBb5fUbQtNSW6RctX7+yXOH0kyvtN6mHjPsDHGLn9tTxPeYiuteylXUY+MXI+Xj89gpFOPYVp/VDTarHpknJA+WkuuD/DfbTLGCDjRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724802756; c=relaxed/simple;
	bh=4O7kF8mXz+wsifeJBbHKTEHl5f+XmE2D6buh8xoouH0=;
	h=Date:To:From:Subject:Message-Id; b=L+PQ3n9ByASCqV0wGpbk20e6SNbQ5nA1KX5YGSTQFtuck+b2u4w1NhfkKFC9f02vadQ9Hh6+nvN+/rtyHtzsM7IXm/UCBQ1rguZqeVLEN8YW37PkF1ImQ8w/3JihyKuRNSrRoC47ghMRYAQJKDxYmY4s4DmUOwqwMHFe4LwDcR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q4dlot8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q4dlot8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2FCC32782;
	Tue, 27 Aug 2024 23:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724802755;
	bh=4O7kF8mXz+wsifeJBbHKTEHl5f+XmE2D6buh8xoouH0=;
	h=Date:To:From:Subject:From;
	b=q4dlot8kx4MMFqDe2AuR/epBLwXE8mjFGM/lQEpen45cWfKMxVbp879krNJmLGLi7
	 WZP1dJI/akfrtFjxqwd+ir/Hf10na2VO5urBKrTbcVqOLcwlvOoM4bDXp/qEwi1kSo
	 bvc59Wd8iMTYttqJdKu1MHKX76WvHUuYQKBSP27k=
Date: Tue, 27 Aug 2024 16:52:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-access_process_vm-use-the-new-follow_pfnmap-api.patch added to mm-unstable branch
Message-Id: <20240827235235.6A2FCC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/access_process_vm: use the new follow_pfnmap API
has been added to the -mm mm-unstable branch.  Its filename is
     mm-access_process_vm-use-the-new-follow_pfnmap-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-access_process_vm-use-the-new-follow_pfnmap-api.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/access_process_vm: use the new follow_pfnmap API
Date: Mon, 26 Aug 2024 16:43:49 -0400

Use the new API that can understand huge pfn mappings.

Link: https://lkml.kernel.org/r/20240826204353.2228736-16-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/mm/memory.c~mm-access_process_vm-use-the-new-follow_pfnmap-api
+++ a/mm/memory.c
@@ -6538,34 +6538,34 @@ int generic_access_phys(struct vm_area_s
 	resource_size_t phys_addr;
 	unsigned long prot = 0;
 	void __iomem *maddr;
-	pte_t *ptep, pte;
-	spinlock_t *ptl;
 	int offset = offset_in_page(addr);
 	int ret = -EINVAL;
+	bool writable;
+	struct follow_pfnmap_args args = { .vma = vma, .address = addr };
 
 retry:
-	if (follow_pte(vma, addr, &ptep, &ptl))
+	if (follow_pfnmap_start(&args))
 		return -EINVAL;
-	pte = ptep_get(ptep);
-	pte_unmap_unlock(ptep, ptl);
+	prot = pgprot_val(args.pgprot);
+	phys_addr = (resource_size_t)args.pfn << PAGE_SHIFT;
+	writable = args.writable;
+	follow_pfnmap_end(&args);
 
-	prot = pgprot_val(pte_pgprot(pte));
-	phys_addr = (resource_size_t)pte_pfn(pte) << PAGE_SHIFT;
-
-	if ((write & FOLL_WRITE) && !pte_write(pte))
+	if ((write & FOLL_WRITE) && !writable)
 		return -EINVAL;
 
 	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
 	if (!maddr)
 		return -ENOMEM;
 
-	if (follow_pte(vma, addr, &ptep, &ptl))
+	if (follow_pfnmap_start(&args))
 		goto out_unmap;
 
-	if (!pte_same(pte, ptep_get(ptep))) {
-		pte_unmap_unlock(ptep, ptl);
+	if ((prot != pgprot_val(args.pgprot)) ||
+	    (phys_addr != (args.pfn << PAGE_SHIFT)) ||
+	    (writable != args.writable)) {
+		follow_pfnmap_end(&args);
 		iounmap(maddr);
-
 		goto retry;
 	}
 
@@ -6574,7 +6574,7 @@ retry:
 	else
 		memcpy_fromio(buf, maddr + offset, len);
 	ret = len;
-	pte_unmap_unlock(ptep, ptl);
+	follow_pfnmap_end(&args);
 out_unmap:
 	iounmap(maddr);
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-dax-dump-start-address-in-fault-handler.patch
mm-mprotect-push-mmu-notifier-to-puds.patch
mm-powerpc-add-missing-pud-helpers.patch
mm-x86-make-pud_leaf-only-care-about-pse-bit.patch
mm-x86-implement-arch_check_zapped_pud.patch
mm-x86-add-missing-pud-helpers.patch
mm-mprotect-fix-dax-pud-handlings.patch
mm-introduce-arch_supports_huge_pfnmap-and-special-bits-to-pmd-pud.patch
mm-drop-is_huge_zero_pud.patch
mm-mark-special-bits-for-huge-pfn-mappings-when-inject.patch
mm-allow-thp-orders-for-pfnmaps.patch
mm-gup-detect-huge-pfnmap-entries-in-gup-fast.patch
mm-pagewalk-check-pfnmap-for-folio_walk_start.patch
mm-fork-accept-huge-pfnmap-entries.patch
mm-always-define-pxx_pgprot.patch
mm-new-follow_pfnmap-api.patch
kvm-use-follow_pfnmap-api.patch
s390-pci_mmio-use-follow_pfnmap-api.patch
mm-x86-pat-use-the-new-follow_pfnmap-api.patch
vfio-use-the-new-follow_pfnmap-api.patch
acrn-use-the-new-follow_pfnmap-api.patch
mm-access_process_vm-use-the-new-follow_pfnmap-api.patch
mm-remove-follow_pte.patch
mm-x86-support-large-pfn-mappings.patch
mm-arm64-support-large-pfn-mappings.patch

