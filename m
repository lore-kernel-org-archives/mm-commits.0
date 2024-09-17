Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8FB28371
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560500; cv=none; b=tUkl6XdqWGKPvJUuAuNW13VbfcqggtVh/xjrCI6p/mk9mKQtQ6AiWcx2cTq0/c3bD2AGcL5OAdrttOwXjJo3HjB3Jgst4+vI/a+bmv7+8kQiFldmFssOudwHz91mL583FFhfastgroskzQlUofCgHc11qZ+lVuG6VTTz1TkLzSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560500; c=relaxed/simple;
	bh=SdkJqCo4Jt9KEhtiZFikAd1oPr4wfxXGoaRFWnTd6T4=;
	h=Date:To:From:Subject:Message-Id; b=rIQ615CG3VNiRy7C/ttzgW7/vGlEusSpnGjHQKsEdvhvjosgta8MC/psiqWah3mKgQurrbpYQZGryYd37ZvSv9PhNX88Lh5tbdHPB+NxVI4tPEBA/FYALqzJjQGB54zjvhy/BXW3sC84iW6IV7j7N7XTuq8X6wytdMZ9Wlu8zZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iG74rOfX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iG74rOfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF571C4CEC6;
	Tue, 17 Sep 2024 08:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560500;
	bh=SdkJqCo4Jt9KEhtiZFikAd1oPr4wfxXGoaRFWnTd6T4=;
	h=Date:To:From:Subject:From;
	b=iG74rOfXA7NJTzD0GRlh64HZqRrHRbDh8rc2iuYFdd9KC+mH2cyzNhxNS7m5MnQ7W
	 EGK1XbTPXf+62Zx0ApyNVYiKYYGvQzW38lvMchqtpnbi088ylhPy286tYOyXIPvJUp
	 Ush5C/TiVrYXFNnJCkDllrlXGw6PxihgOrzUUpG4=
Date: Tue, 17 Sep 2024 01:08:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] acrn-use-the-new-follow_pfnmap-api.patch removed from -mm tree
Message-Id: <20240917080819.DF571C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: acrn: use the new follow_pfnmap API
has been removed from the -mm tree.  Its filename was
     acrn-use-the-new-follow_pfnmap-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


