Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9AF77117
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724802753; cv=none; b=CIzhvpeq5z0Vk+piSIKgxiIW3IrpJNlHN5HBKPJwNlPyyMjYwUXXZaskNgMRBUkk7uReqkS5dZKs/Juq5FmcDRFm+N1pp1oKHTQpqzl6sUu4HvXcec4PP6faaLVpXiqI1kRMPjPNxZYGexWowKwGGxUHvb/mqyGEKMOkRgcu5dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724802753; c=relaxed/simple;
	bh=eJ1wIphM45UwLImFIms2rOl0gBhWwUsJ0FTZ9i3DFpA=;
	h=Date:To:From:Subject:Message-Id; b=QOmJN/vF777mvwdVUXgB4HFMbRj3h61HQ86YxgiJw6c86RVAucL0VGy3xKoqIqDBS2kWeFH7bheQE+uGZj/5VNXQ5ounPLJaadTrzoY9tVZKmUg9JMCz6SDSDMv0DiivHv0ut89n+hSTg7B41KiLcDLHT7bMszz0n6uhNmcDsa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KsCdV18Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KsCdV18Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451F2C32782;
	Tue, 27 Aug 2024 23:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724802753;
	bh=eJ1wIphM45UwLImFIms2rOl0gBhWwUsJ0FTZ9i3DFpA=;
	h=Date:To:From:Subject:From;
	b=KsCdV18YSwGPspufZkS7935tQXCF6vnJToqmqRW7x+CARYVWNfZNfEdqjo7H643e3
	 8UD3U15oR+gAAb3UIzaCyVObWn3DbG/1SC/P6+dEwdL92hqxZIWYLQBu52aDoUFDvr
	 D3oriMXgSRW/XvyQAM8L3YR+xfLH4Q8up73bBhrE=
Date: Tue, 27 Aug 2024 16:52:32 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + acrn-use-the-new-follow_pfnmap-api.patch added to mm-unstable branch
Message-Id: <20240827235233.451F2C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: acrn: use the new follow_pfnmap API
has been added to the -mm mm-unstable branch.  Its filename is
     acrn-use-the-new-follow_pfnmap-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/acrn-use-the-new-follow_pfnmap-api.patch

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
Subject: acrn: use the new follow_pfnmap API
Date: Mon, 26 Aug 2024 16:43:48 -0400

Use the new API that can understand huge pfn mappings.

Link: https://lkml.kernel.org/r/20240826204353.2228736-15-peterx@redhat.com
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

 drivers/virt/acrn/mm.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/virt/acrn/mm.c~acrn-use-the-new-follow_pfnmap-api
+++ a/drivers/virt/acrn/mm.c
@@ -177,9 +177,7 @@ int acrn_vm_ram_map(struct acrn_vm *vm,
 	vma = vma_lookup(current->mm, memmap->vma_base);
 	if (vma && ((vma->vm_flags & VM_PFNMAP) != 0)) {
 		unsigned long start_pfn, cur_pfn;
-		spinlock_t *ptl;
 		bool writable;
-		pte_t *ptep;
 
 		if ((memmap->vma_base + memmap->len) > vma->vm_end) {
 			mmap_read_unlock(current->mm);
@@ -187,16 +185,20 @@ int acrn_vm_ram_map(struct acrn_vm *vm,
 		}
 
 		for (i = 0; i < nr_pages; i++) {
-			ret = follow_pte(vma, memmap->vma_base + i * PAGE_SIZE,
-					 &ptep, &ptl);
+			struct follow_pfnmap_args args = {
+				.vma = vma,
+				.address = memmap->vma_base + i * PAGE_SIZE,
+			};
+
+			ret = follow_pfnmap_start(&args);
 			if (ret)
 				break;
 
-			cur_pfn = pte_pfn(ptep_get(ptep));
+			cur_pfn = args.pfn;
 			if (i == 0)
 				start_pfn = cur_pfn;
-			writable = !!pte_write(ptep_get(ptep));
-			pte_unmap_unlock(ptep, ptl);
+			writable = args.writable;
+			follow_pfnmap_end(&args);
 
 			/* Disallow write access if the PTE is not writable. */
 			if (!writable &&
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

