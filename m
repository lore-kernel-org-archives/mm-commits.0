Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4548E28371
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560493; cv=none; b=WREr6LqA1MLMHzxhBLN04L89kH4Rj7gBicvqLCfS+RNrPgFPXfwtu9fw5Gb5wt6ssDO2VIHltuTk7wT/hMTtRD0JoevWg8R4yuHeDJ2BpkeH9QQjjIBd+MKSEel56d0NgEJPU89R0mu59q/CGnuOH/UvPgKW0L4ZOLY2eeQ/QmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560493; c=relaxed/simple;
	bh=NOYgj/IX/4S3K0k3bX3BRbIBuy8LwAqt6s5BFW4bDSs=;
	h=Date:To:From:Subject:Message-Id; b=Lsh0Ivn2oAGZ0qQfOGNHqvooUZ/kDErF/lhRZvn0ktKjS7rao8xpZDIXU0Y5QQvX1/vWQFNO4wfk48aAv3HPISCqtumZir3ISlb8p3PBZEpN+8veYzB5KaKjzsdPruMAXWW2fI6wf2He4l0iW10zU19O23lPktZbW03QCAbEz+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zer+QT6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zer+QT6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D1AC4CECE;
	Tue, 17 Sep 2024 08:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560493;
	bh=NOYgj/IX/4S3K0k3bX3BRbIBuy8LwAqt6s5BFW4bDSs=;
	h=Date:To:From:Subject:From;
	b=Zer+QT6tDpV0/Fuxpp10uSRfiblsU0arpss8iK99xjSC/Ul3e3mqW2CHt0GKgPKTD
	 O0dSTkviAXZUJZLNfbtMH1rbWh22h7Td8M9pXMTRRG1ShI4eYGdzp2Tg3EqfT1ZTZE
	 vlvIamS7ebdSyc+REoIToUjWnArXc5P+GAcqtL7M=
Date: Tue, 17 Sep 2024 01:08:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-x86-pat-use-the-new-follow_pfnmap-api.patch removed from -mm tree
Message-Id: <20240917080812.C2D1AC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/x86/pat: use the new follow_pfnmap API
has been removed from the -mm tree.  Its filename was
     mm-x86-pat-use-the-new-follow_pfnmap-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/x86/pat: use the new follow_pfnmap API
Date: Mon, 26 Aug 2024 16:43:46 -0400

Use the new API that can understand huge pfn mappings.

Link: https://lkml.kernel.org/r/20240826204353.2228736-13-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat/memtype.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/arch/x86/mm/pat/memtype.c~mm-x86-pat-use-the-new-follow_pfnmap-api
+++ a/arch/x86/mm/pat/memtype.c
@@ -951,23 +951,20 @@ static void free_pfn_range(u64 paddr, un
 static int follow_phys(struct vm_area_struct *vma, unsigned long *prot,
 		resource_size_t *phys)
 {
-	pte_t *ptep, pte;
-	spinlock_t *ptl;
+	struct follow_pfnmap_args args = { .vma = vma, .address = vma->vm_start };
 
-	if (follow_pte(vma, vma->vm_start, &ptep, &ptl))
+	if (follow_pfnmap_start(&args))
 		return -EINVAL;
 
-	pte = ptep_get(ptep);
-
 	/* Never return PFNs of anon folios in COW mappings. */
-	if (vm_normal_folio(vma, vma->vm_start, pte)) {
-		pte_unmap_unlock(ptep, ptl);
+	if (!args.special) {
+		follow_pfnmap_end(&args);
 		return -EINVAL;
 	}
 
-	*prot = pgprot_val(pte_pgprot(pte));
-	*phys = (resource_size_t)pte_pfn(pte) << PAGE_SHIFT;
-	pte_unmap_unlock(ptep, ptl);
+	*prot = pgprot_val(args.pgprot);
+	*phys = (resource_size_t)args.pfn << PAGE_SHIFT;
+	follow_pfnmap_end(&args);
 	return 0;
 }
 
_

Patches currently in -mm which might be from peterx@redhat.com are


