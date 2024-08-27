Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F5F77117
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724802725; cv=none; b=eQsNYWR8scUt1dfaK0oHTHuRPLTxQjNdWrB0VRhCl79GK2FxgWXvq1Rcoue4TqRUEyRxjyoO2VSXH+FE7ZIBBxokhoBqNkVviB9jabtVPqikay9PBo5kXp0cJXsLHpQqoWQa1fxJ6ZMg0fQ/+zRXpNPqe7cAFyDzW9BWJSjmww8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724802725; c=relaxed/simple;
	bh=ODkkLXKE0lgZzdAk+idxSRrJYagZ6kmB4mgELSS3PhM=;
	h=Date:To:From:Subject:Message-Id; b=T+2Zlkx4G5iLjAzlI/3DnpxoyK58UXOztW0JRLUxRxe7cOrmfeXWSuhQc4lUJpNrOPrDFmpbp3k93GcGSey426ivh7UjKXv+tLAQzHWNpmJthcEAUCcigg8iQzGkSEBFN9M7f2z+7q/MwRE0so4cvbpekJVoJ4hyOlWOAwZHpBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c876Rqdm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c876Rqdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D906EC4FF6F;
	Tue, 27 Aug 2024 23:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724802724;
	bh=ODkkLXKE0lgZzdAk+idxSRrJYagZ6kmB4mgELSS3PhM=;
	h=Date:To:From:Subject:From;
	b=c876RqdmAYq3nVI9lSw9JpFuXTW7smEmC31orkef9Yy5NvcktO8J65zPNc8SliECG
	 /xAehe/ZdoBSmU55M97tCKcZR4YXZHYjq1HyUzF0JTIn5zUUDXjbCh8eZ6ScopMzf6
	 FgQddcAGZHV6OLGDYHxbJw7NZ7K7C6J5k63gaOwI=
Date: Tue, 27 Aug 2024 16:52:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-drop-is_huge_zero_pud.patch added to mm-unstable branch
Message-Id: <20240827235204.D906EC4FF6F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: drop is_huge_zero_pud()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-drop-is_huge_zero_pud.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-drop-is_huge_zero_pud.patch

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
Subject: mm: drop is_huge_zero_pud()
Date: Mon, 26 Aug 2024 16:43:36 -0400

It constantly returns false since 2017.  One assertion is added in 2019 but
it should never have triggered, IOW it means what is checked should be
asserted instead.

If it didn't exist for 7 years maybe it's good idea to remove it and only
add it when it comes.

Link: https://lkml.kernel.org/r/20240826204353.2228736-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
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

 include/linux/huge_mm.h |   10 ----------
 mm/huge_memory.c        |   13 +------------
 2 files changed, 1 insertion(+), 22 deletions(-)

--- a/include/linux/huge_mm.h~mm-drop-is_huge_zero_pud
+++ a/include/linux/huge_mm.h
@@ -433,11 +433,6 @@ static inline bool is_huge_zero_pmd(pmd_
 	return pmd_present(pmd) && READ_ONCE(huge_zero_pfn) == pmd_pfn(pmd);
 }
 
-static inline bool is_huge_zero_pud(pud_t pud)
-{
-	return false;
-}
-
 struct folio *mm_get_huge_zero_folio(struct mm_struct *mm);
 void mm_put_huge_zero_folio(struct mm_struct *mm);
 
@@ -577,11 +572,6 @@ static inline bool is_huge_zero_pmd(pmd_
 {
 	return false;
 }
-
-static inline bool is_huge_zero_pud(pud_t pud)
-{
-	return false;
-}
 
 static inline void mm_put_huge_zero_folio(struct mm_struct *mm)
 {
--- a/mm/huge_memory.c~mm-drop-is_huge_zero_pud
+++ a/mm/huge_memory.c
@@ -1429,10 +1429,8 @@ static void insert_pfn_pud(struct vm_are
 	ptl = pud_lock(mm, pud);
 	if (!pud_none(*pud)) {
 		if (write) {
-			if (pud_pfn(*pud) != pfn_t_to_pfn(pfn)) {
-				WARN_ON_ONCE(!is_huge_zero_pud(*pud));
+			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn_t_to_pfn(pfn)))
 				goto out_unlock;
-			}
 			entry = pud_mkyoung(*pud);
 			entry = maybe_pud_mkwrite(pud_mkdirty(entry), vma);
 			if (pudp_set_access_flags(vma, addr, pud, entry, 1))
@@ -1681,15 +1679,6 @@ int copy_huge_pud(struct mm_struct *dst_
 		goto out_unlock;
 
 	/*
-	 * When page table lock is held, the huge zero pud should not be
-	 * under splitting since we don't split the page itself, only pud to
-	 * a page table.
-	 */
-	if (is_huge_zero_pud(pud)) {
-		/* No huge zero pud yet */
-	}
-
-	/*
 	 * TODO: once we support anonymous pages, use
 	 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
 	 */
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

