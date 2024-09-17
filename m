Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1758B10F4
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560168; cv=none; b=sbtrlkdgOq51D8OGggAKQP2Dn1Vtf4uDbpK4rhKP8Rl9TvQoBfAr1AFqa3OCSrUvNoYf0fpHc10DmaXUQI94eo4z7TJO/lyFGhWqXHD3G9X3UJVUivLpsWBe8SP72rVMl+DTwDmEiWsiqw+E6RZr43zKLae6bU534USACqMv/T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560168; c=relaxed/simple;
	bh=yPoh7eZAlSpKw9NsmPAZBouBhXQOLHAFNVa+df6jh34=;
	h=Date:To:From:Subject:Message-Id; b=BxeuE3AEUJz7UsFNpSDqfdRthWgvU+4mnYtX1mptrBkcwg+6yUluM4UV0CJtjOHSMhQDatMtWGacpOivRWc4XSFlgyX6vV8G9BXjPikKgldIGAbFysSXM7DBQQUqdhfKFjPplMhnOPvH/KCj8gzZjXs0VbKTEK0f6yF09kMSDxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=owxzHquT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="owxzHquT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E97FC4CEC6;
	Tue, 17 Sep 2024 08:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560167;
	bh=yPoh7eZAlSpKw9NsmPAZBouBhXQOLHAFNVa+df6jh34=;
	h=Date:To:From:Subject:From;
	b=owxzHquTA+kpz3KE4spvqEUVO0tI+pRZ3JBDPkH0ZhFw+efWi4dPexNFmfoxgrLfL
	 YLIurHSbmHKEtILfzhqng1UvvKQx2k4eH5o3YuSNR7QYxP7Xezv3wMdrzcH5p7bvRv
	 MLr4sKDHfcR8Q6CF5f1XOcewMKnO7HIifafMC4MU=
Date: Tue, 17 Sep 2024 01:02:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-pagewalk-check-pfnmap-for-folio_walk_start-fix.patch removed from -mm tree
Message-Id: <20240917080247.2E97FC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup! mm/pagewalk: check pfnmap for folio_walk_start()
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-check-pfnmap-for-folio_walk_start-fix.patch

This patch was dropped because it was folded into mm-pagewalk-check-pfnmap-for-folio_walk_start.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: fixup! mm/pagewalk: check pfnmap for folio_walk_start()
Date: Thu, 29 Aug 2024 16:22:37 -0400

Per David's suggestion, remove some stale comment in vm_normal_page_pmd()
as we start to have special bit in pmd too.  Meanwhile move the
pmd_special() check here from folio_walk_start().

Link: https://lkml.kernel.org/r/20240829202237.2640288-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
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

 mm/memory.c   |    9 ++++-----
 mm/pagewalk.c |    2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-pagewalk-check-pfnmap-for-folio_walk_start-fix
+++ a/mm/memory.c
@@ -672,11 +672,10 @@ struct page *vm_normal_page_pmd(struct v
 {
 	unsigned long pfn = pmd_pfn(pmd);
 
-	/*
-	 * There is no pmd_special() but there may be special pmds, e.g.
-	 * in a direct-access (dax) mapping, so let's just replicate the
-	 * !CONFIG_ARCH_HAS_PTE_SPECIAL case from vm_normal_page() here.
-	 */
+	/* Currently it's only used for huge pfnmaps */
+	if (unlikely(pmd_special(pmd)))
+		return NULL;
+
 	if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
 		if (vma->vm_flags & VM_MIXEDMAP) {
 			if (!pfn_valid(pfn))
--- a/mm/pagewalk.c~mm-pagewalk-check-pfnmap-for-folio_walk_start-fix
+++ a/mm/pagewalk.c
@@ -783,7 +783,7 @@ pmd_table:
 		fw->pmdp = pmdp;
 		fw->pmd = pmd;
 
-		if (pmd_none(pmd) || pmd_special(pmd)) {
+		if (pmd_none(pmd)) {
 			spin_unlock(ptl);
 			goto not_found;
 		} else if (!pmd_leaf(pmd)) {
_

Patches currently in -mm which might be from peterx@redhat.com are

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

