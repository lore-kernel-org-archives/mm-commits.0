Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BCA152E0C
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560505; cv=none; b=WJrXLyVoK65ynX3pMHhgWqq8obMA1nrWbzs3p9vgsjmhRIfiM60GIY6igsQtH6xw3vINV3JI99CaFJ22edtZ8Hj6Bh6K6iJExoobQrzGyzT0HOAM9PFV/QHq06SLzRQg9fJExN9eJPI2h08EKmqJhpiv7MptLX++VO0abRpxS08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560505; c=relaxed/simple;
	bh=9Dp7Tg6wV5gNlvdYwwEzD6l4imXRoOXjwRQ+VeH1Agw=;
	h=Date:To:From:Subject:Message-Id; b=eNxdcROBegTCaH3SHPBy2o848FXAMsoVZD/AUc1qf17+xz3KhTSjZvebJOxo/o3kmUqHdJ+tu/zIUz7Jo8+v9qA/sMD3nnRzUmgpSYEzmFaBGx1uj+p+lCCo+z1vZP+p6GpdQVMa6p/IGFsd125ywiMHP1UFmYSFeDrkR61TWtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rI2fgABu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rI2fgABu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58874C4CEC6;
	Tue, 17 Sep 2024 08:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560505;
	bh=9Dp7Tg6wV5gNlvdYwwEzD6l4imXRoOXjwRQ+VeH1Agw=;
	h=Date:To:From:Subject:From;
	b=rI2fgABubG9Iyby6F6qOYxP0dwJ3jjZxnJnO23pDYto91vW4xEzTdvSFDo1Lm/UQL
	 pHBxd7RiSkBzlK3efujnC7JvwolOtLj1Cx5erzLDl0hidHxxje7hecjTA4+2MOnBpZ
	 RpY5hy0ltq1i+UjK791N1/CxBBkeinrB+ZHce8Mk=
Date: Tue, 17 Sep 2024 01:08:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-access_process_vm-use-the-new-follow_pfnmap-api.patch removed from -mm tree
Message-Id: <20240917080824.58874C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/access_process_vm: use the new follow_pfnmap API
has been removed from the -mm tree.  Its filename was
     mm-access_process_vm-use-the-new-follow_pfnmap-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -6341,34 +6341,34 @@ int generic_access_phys(struct vm_area_s
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
 
@@ -6377,7 +6377,7 @@ retry:
 	else
 		memcpy_fromio(buf, maddr + offset, len);
 	ret = len;
-	pte_unmap_unlock(ptep, ptl);
+	follow_pfnmap_end(&args);
 out_unmap:
 	iounmap(maddr);
 
_

Patches currently in -mm which might be from peterx@redhat.com are


