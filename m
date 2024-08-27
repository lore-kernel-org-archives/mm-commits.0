Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEC51D47A4
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724802760; cv=none; b=n1583JuSQiWNldkLnXRlvkGn2CyBvQrtk2IQUdu2K3Ub2iJ+LgVh+kAHQMknFtKHDW2R5m5UlfhPXoC/CB5rrjrFMJl3pfK0uMKqfqlBAOsOJf6wE8Ho80jJX+siVVFiu9nWIhQH+sB8aAppcT5ctXA2zJH6hVWfflwSMekkvxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724802760; c=relaxed/simple;
	bh=STWI8duk4T39IQ7ZNIkAnvfrh8aZW/V4TX14dHzKGls=;
	h=Date:To:From:Subject:Message-Id; b=mtnq7yMlBe4GviaEqCT/96302oJOQzSQzBO+cf1zooBZlnYZCCWvDYqdADkbyUMr1gywbDnxTauFPp5eJy4wuNdfhpmIBrX7UGK1jfR3WSlZ8fCVrX78O5je7Bu2maQ41Ysx/NE3KDrb+VqNw2NfVXx7719m/7CGQJxoeiNNGt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qGJMEMZv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qGJMEMZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EEDC32782;
	Tue, 27 Aug 2024 23:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724802760;
	bh=STWI8duk4T39IQ7ZNIkAnvfrh8aZW/V4TX14dHzKGls=;
	h=Date:To:From:Subject:From;
	b=qGJMEMZvZMHazR20MhSim2J6zzvEyDHy+AHwC6zNm2xV0GaPTDHqbFELJcMcSAM5g
	 2o8R2h+eUfT3x4VWosUS9vzI2tEN86QPMP5X+iEKBEm7mbC7Qj9vb2Yd0N9EVod0CK
	 l7RTAjllJDiUG7PCqCD4AJw45zcbASBat0zEbu+U=
Date: Tue, 27 Aug 2024 16:52:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-x86-support-large-pfn-mappings.patch added to mm-unstable branch
Message-Id: <20240827235239.F0EEDC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/x86: support large pfn mappings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-x86-support-large-pfn-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-x86-support-large-pfn-mappings.patch

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
Subject: mm/x86: support large pfn mappings
Date: Mon, 26 Aug 2024 16:43:51 -0400

Helpers to install and detect special pmd/pud entries.  In short, bit 9 on
x86 is not used for pmd/pud, so we can directly define them the same as
the pte level.  One note is that it's also used in _PAGE_BIT_CPA_TEST but
that is only used in the debug test, and shouldn't conflict in this case.

One note is that pxx_set|clear_flags() for pmd/pud will need to be moved
upper so that they can be referenced by the new special bit helpers. 
There's no change in the code that was moved.

Link: https://lkml.kernel.org/r/20240826204353.2228736-18-peterx@redhat.com
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

 arch/x86/Kconfig               |    1 
 arch/x86/include/asm/pgtable.h |   80 ++++++++++++++++++++-----------
 2 files changed, 53 insertions(+), 28 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~mm-x86-support-large-pfn-mappings
+++ a/arch/x86/include/asm/pgtable.h
@@ -120,6 +120,34 @@ extern pmdval_t early_pmd_flags;
 #define arch_end_context_switch(prev)	do {} while(0)
 #endif	/* CONFIG_PARAVIRT_XXL */
 
+static inline pmd_t pmd_set_flags(pmd_t pmd, pmdval_t set)
+{
+	pmdval_t v = native_pmd_val(pmd);
+
+	return native_make_pmd(v | set);
+}
+
+static inline pmd_t pmd_clear_flags(pmd_t pmd, pmdval_t clear)
+{
+	pmdval_t v = native_pmd_val(pmd);
+
+	return native_make_pmd(v & ~clear);
+}
+
+static inline pud_t pud_set_flags(pud_t pud, pudval_t set)
+{
+	pudval_t v = native_pud_val(pud);
+
+	return native_make_pud(v | set);
+}
+
+static inline pud_t pud_clear_flags(pud_t pud, pudval_t clear)
+{
+	pudval_t v = native_pud_val(pud);
+
+	return native_make_pud(v & ~clear);
+}
+
 /*
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
@@ -317,6 +345,30 @@ static inline int pud_devmap(pud_t pud)
 }
 #endif
 
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+static inline bool pmd_special(pmd_t pmd)
+{
+	return pmd_flags(pmd) & _PAGE_SPECIAL;
+}
+
+static inline pmd_t pmd_mkspecial(pmd_t pmd)
+{
+	return pmd_set_flags(pmd, _PAGE_SPECIAL);
+}
+#endif	/* CONFIG_ARCH_SUPPORTS_PMD_PFNMAP */
+
+#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
+static inline bool pud_special(pud_t pud)
+{
+	return pud_flags(pud) & _PAGE_SPECIAL;
+}
+
+static inline pud_t pud_mkspecial(pud_t pud)
+{
+	return pud_set_flags(pud, _PAGE_SPECIAL);
+}
+#endif	/* CONFIG_ARCH_SUPPORTS_PUD_PFNMAP */
+
 static inline int pgd_devmap(pgd_t pgd)
 {
 	return 0;
@@ -487,20 +539,6 @@ static inline pte_t pte_mkdevmap(pte_t p
 	return pte_set_flags(pte, _PAGE_SPECIAL|_PAGE_DEVMAP);
 }
 
-static inline pmd_t pmd_set_flags(pmd_t pmd, pmdval_t set)
-{
-	pmdval_t v = native_pmd_val(pmd);
-
-	return native_make_pmd(v | set);
-}
-
-static inline pmd_t pmd_clear_flags(pmd_t pmd, pmdval_t clear)
-{
-	pmdval_t v = native_pmd_val(pmd);
-
-	return native_make_pmd(v & ~clear);
-}
-
 /* See comments above mksaveddirty_shift() */
 static inline pmd_t pmd_mksaveddirty(pmd_t pmd)
 {
@@ -595,20 +633,6 @@ static inline pmd_t pmd_mkwrite_novma(pm
 pmd_t pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 #define pmd_mkwrite pmd_mkwrite
 
-static inline pud_t pud_set_flags(pud_t pud, pudval_t set)
-{
-	pudval_t v = native_pud_val(pud);
-
-	return native_make_pud(v | set);
-}
-
-static inline pud_t pud_clear_flags(pud_t pud, pudval_t clear)
-{
-	pudval_t v = native_pud_val(pud);
-
-	return native_make_pud(v & ~clear);
-}
-
 /* See comments above mksaveddirty_shift() */
 static inline pud_t pud_mksaveddirty(pud_t pud)
 {
--- a/arch/x86/Kconfig~mm-x86-support-large-pfn-mappings
+++ a/arch/x86/Kconfig
@@ -28,6 +28,7 @@ config X86_64
 	select ARCH_HAS_GIGANTIC_PAGE
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
 	select ARCH_SUPPORTS_PER_VMA_LOCK
+	select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
 	select HAVE_ARCH_SOFT_DIRTY
 	select MODULES_USE_ELF_RELA
 	select NEED_DMA_MAP_STATE
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

