Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38CB14F118
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 21:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723066019; cv=none; b=Fx2BhCQVyvQATWHUzWKO0EdqrnCqAiH10KtInET6bYyoLUonTOSX9dUmj6CnO+VOY05UvXFGOyKCfpJyyLMyW6KCedbJIrK1l42al6V01wYx3w+WW2/roV+3gxT2r0jJqrBB79Wq1KMLkv31CzbqYpv2uw++jMEu7trljwDQ92M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723066019; c=relaxed/simple;
	bh=KgkebM15tr8hROs8rV4vWPg9PCGAj3LoDTPb3vxG/1g=;
	h=Date:To:From:Subject:Message-Id; b=FT3NMZvCLc3DSHG5TbfOjbfwXxqLC8Lxj3WaZz8MuzBIcbkOAXbzgACLZCBOwlWHWO/AHC1Q9oH6u3Tp3mIXVklTiCjNl1y2E65Rf1yJwLijD7+7DtKS/T1njMebPP3g+qADOEQzz+W9cVw2Qupr9MuOflH1xFZYHUnuVd1+ABU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1UQm0+d7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1UQm0+d7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5882CC32782;
	Wed,  7 Aug 2024 21:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723066019;
	bh=KgkebM15tr8hROs8rV4vWPg9PCGAj3LoDTPb3vxG/1g=;
	h=Date:To:From:Subject:From;
	b=1UQm0+d7lCQrJVa/nFl8EpDv3VwE/OZT/alMz5TnUbXcB9dA9pAzqhjFfWdcVFjxX
	 FeYAM4wrKUh6Hdiuq8ca8MWRkq2ftnO0S6OKtIAa7AC6ID+TMrMQC4HTBkBouoUmgR
	 H/kzo1Pu9SaMn/Q5l08oJHHNybih74Z5So43YmBI=
Date: Wed, 07 Aug 2024 14:26:58 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,seanjc@google.com,rientjes@google.com,riel@surriel.com,rick.p.edgecombe@intel.com,pbonzini@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mgorman@techsingularity.net,kirill@shutemov.name,jthoughton@google.com,hughd@google.com,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-x86-arch_check_zapped_pud.patch added to mm-unstable branch
Message-Id: <20240807212659.5882CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/x86: arch_check_zapped_pud()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-x86-arch_check_zapped_pud.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-x86-arch_check_zapped_pud.patch

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
Subject: mm/x86: arch_check_zapped_pud()
Date: Wed, 7 Aug 2024 15:48:09 -0400

Introduce arch_check_zapped_pud() to sanity check shadow stack on PUD
zaps.  It has the same logic of the PMD helper.

One thing to mention is, it might be a good idea to use page_table_check
in the future for trapping wrong setups of shadow stack pgtable entries
[1].  That is left for the future as a separate effort.

[1] https://lore.kernel.org/all/59d518698f664e07c036a5098833d7b56b953305.camel@intel.com

Link: https://lkml.kernel.org/r/20240807194812.819412-6-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |   10 ++++++++++
 arch/x86/mm/pgtable.c          |    7 +++++++
 include/linux/pgtable.h        |    7 +++++++
 mm/huge_memory.c               |    4 +++-
 4 files changed, 27 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/pgtable.h~mm-x86-arch_check_zapped_pud
+++ a/arch/x86/include/asm/pgtable.h
@@ -174,6 +174,13 @@ static inline int pud_young(pud_t pud)
 	return pud_flags(pud) & _PAGE_ACCESSED;
 }
 
+static inline bool pud_shstk(pud_t pud)
+{
+	return cpu_feature_enabled(X86_FEATURE_SHSTK) &&
+	       (pud_flags(pud) & (_PAGE_RW | _PAGE_DIRTY | _PAGE_PSE)) ==
+	       (_PAGE_DIRTY | _PAGE_PSE);
+}
+
 static inline int pte_write(pte_t pte)
 {
 	/*
@@ -1667,6 +1674,9 @@ void arch_check_zapped_pte(struct vm_are
 #define arch_check_zapped_pmd arch_check_zapped_pmd
 void arch_check_zapped_pmd(struct vm_area_struct *vma, pmd_t pmd);
 
+#define arch_check_zapped_pud arch_check_zapped_pud
+void arch_check_zapped_pud(struct vm_area_struct *vma, pud_t pud);
+
 #ifdef CONFIG_XEN_PV
 #define arch_has_hw_nonleaf_pmd_young arch_has_hw_nonleaf_pmd_young
 static inline bool arch_has_hw_nonleaf_pmd_young(void)
--- a/arch/x86/mm/pgtable.c~mm-x86-arch_check_zapped_pud
+++ a/arch/x86/mm/pgtable.c
@@ -926,3 +926,10 @@ void arch_check_zapped_pmd(struct vm_are
 	VM_WARN_ON_ONCE(!(vma->vm_flags & VM_SHADOW_STACK) &&
 			pmd_shstk(pmd));
 }
+
+void arch_check_zapped_pud(struct vm_area_struct *vma, pud_t pud)
+{
+	/* See note in arch_check_zapped_pte() */
+	VM_WARN_ON_ONCE(!(vma->vm_flags & VM_SHADOW_STACK) &&
+			pud_shstk(pud));
+}
--- a/include/linux/pgtable.h~mm-x86-arch_check_zapped_pud
+++ a/include/linux/pgtable.h
@@ -447,6 +447,13 @@ static inline void arch_check_zapped_pmd
 }
 #endif
 
+#ifndef arch_check_zapped_pud
+static inline void arch_check_zapped_pud(struct vm_area_struct *vma,
+					 pud_t pud)
+{
+}
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long address,
--- a/mm/huge_memory.c~mm-x86-arch_check_zapped_pud
+++ a/mm/huge_memory.c
@@ -2310,12 +2310,14 @@ int zap_huge_pud(struct mmu_gather *tlb,
 		 pud_t *pud, unsigned long addr)
 {
 	spinlock_t *ptl;
+	pud_t orig_pud;
 
 	ptl = __pud_trans_huge_lock(pud, vma);
 	if (!ptl)
 		return 0;
 
-	pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
+	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
+	arch_check_zapped_pud(vma, orig_pud);
 	tlb_remove_pud_tlb_entry(tlb, pud, addr);
 	if (vma_is_special_huge(vma)) {
 		spin_unlock(ptl);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-dax-dump-start-address-in-fault-handler.patch
mm-mprotect-push-mmu-notifier-to-puds.patch
mm-powerpc-add-missing-pud-helpers.patch
mm-x86-make-pud_leaf-only-care-about-pse-bit.patch
mm-x86-arch_check_zapped_pud.patch
mm-x86-add-missing-pud-helpers.patch
mm-mprotect-fix-dax-pud-handlings.patch

