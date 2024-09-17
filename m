Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E589E28371
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560497; cv=none; b=V0ZKsVLWpfkvw3qdCjw2RfG3tkpQIgbOJgltcKWaTQX2quyitSrLV3UL3RTwZBQriZTbBXPvmhBO3pnmXRrAdcqps9Bj7WshkUL3vqsKYtutUxKkTU1hO+WkPRWmFt1HodBiFqWFy13ZbVqdckbk0UuPoSLxOzTGixL6AfFfpBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560497; c=relaxed/simple;
	bh=0HkOWT90bAbSSlK2kDt5PzgYGcTjRTwN4RYbb4WpHH8=;
	h=Date:To:From:Subject:Message-Id; b=k5a9ai9IU4EdcONkbYJ91ezigBp/eNYy0Z70OyyU9OwL8GOh3NDKfORK0yAEIFSGRIx7tCgSFzEyr/chT2/CxjhlF2klgeUiJO6zIxF4xZhu+EH1tTyfEZjR68v+UAwtU8nBZhQErpAG5oFP1/PUWCfhXEbZeT1SKrr5AqcPXUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EAXM8eA5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EAXM8eA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2BEC4CEC6;
	Tue, 17 Sep 2024 08:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560496;
	bh=0HkOWT90bAbSSlK2kDt5PzgYGcTjRTwN4RYbb4WpHH8=;
	h=Date:To:From:Subject:From;
	b=EAXM8eA5u+V8AxwcvXO56uHFGr7NkiuzuRtO95ZkpidfMGxjSeMN44XpIx37hHUbc
	 hmweqHC+bcX4kTjlTE2MhIbAVtRGxDF5GGOZEJKDGFn+6k0iSVaKyycPHFyVDaeDAm
	 XhL7KU8oYk975ydr6CA5YTaJ7GfhXa9gj66/mGH0=
Date: Tue, 17 Sep 2024 01:08:13 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vfio-use-the-new-follow_pfnmap-api.patch removed from -mm tree
Message-Id: <20240917080816.1E2BEC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vfio: use the new follow_pfnmap API
has been removed from the -mm tree.  Its filename was
     vfio-use-the-new-follow_pfnmap-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: vfio: use the new follow_pfnmap API
Date: Mon, 26 Aug 2024 16:43:47 -0400

Use the new API that can understand huge pfn mappings.

Link: https://lkml.kernel.org/r/20240826204353.2228736-14-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
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

 drivers/vfio/vfio_iommu_type1.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/drivers/vfio/vfio_iommu_type1.c~vfio-use-the-new-follow_pfnmap-api
+++ a/drivers/vfio/vfio_iommu_type1.c
@@ -513,12 +513,10 @@ static int follow_fault_pfn(struct vm_ar
 			    unsigned long vaddr, unsigned long *pfn,
 			    bool write_fault)
 {
-	pte_t *ptep;
-	pte_t pte;
-	spinlock_t *ptl;
+	struct follow_pfnmap_args args = { .vma = vma, .address = vaddr };
 	int ret;
 
-	ret = follow_pte(vma, vaddr, &ptep, &ptl);
+	ret = follow_pfnmap_start(&args);
 	if (ret) {
 		bool unlocked = false;
 
@@ -532,19 +530,17 @@ static int follow_fault_pfn(struct vm_ar
 		if (ret)
 			return ret;
 
-		ret = follow_pte(vma, vaddr, &ptep, &ptl);
+		ret = follow_pfnmap_start(&args);
 		if (ret)
 			return ret;
 	}
 
-	pte = ptep_get(ptep);
-
-	if (write_fault && !pte_write(pte))
+	if (write_fault && !args.writable)
 		ret = -EFAULT;
 	else
-		*pfn = pte_pfn(pte);
+		*pfn = args.pfn;
 
-	pte_unmap_unlock(ptep, ptl);
+	follow_pfnmap_end(&args);
 	return ret;
 }
 
_

Patches currently in -mm which might be from peterx@redhat.com are


