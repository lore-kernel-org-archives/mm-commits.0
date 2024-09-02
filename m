Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38040537FF
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247799; cv=none; b=mK2AK7No7T0IytkPX0ovEani0Vdbu2pR8xAJsE/E6sOEjbYof/bmMtH1HATqb+U1pUBGSaCTGHCBlBJCMgQd3xs1mIra2XoCgHQcbJEN/951BGkdCpzxxn6Cd8LHeC0TY1AXbr2eBWOCuTuTo06WDw/tIx9nORdHDkJjsHKVt+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247799; c=relaxed/simple;
	bh=SsTBT+1lETrZbN62NPZAsAhgE/CFiv7IRi23szZWP/A=;
	h=Date:To:From:Subject:Message-Id; b=XL87fLtClVgwuCX8WENVFWjZL6IOFbqVdgqnPADhe74ucxZ06KdhtWmiK5iGkYWVHOjoUOxuMb+YAQcBOdtDe4BJ9/TNNwYVoqCu6Q8xxkPTl5FjbGj9xE3M6i8Sjmv9YvG9RJN+uDQ2PH3n2tzgf6G2pQjKyKWbdQgiScbobKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0xwMLLLu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0xwMLLLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E370C4CEC2;
	Mon,  2 Sep 2024 03:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247799;
	bh=SsTBT+1lETrZbN62NPZAsAhgE/CFiv7IRi23szZWP/A=;
	h=Date:To:From:Subject:From;
	b=0xwMLLLumqSmJn85H5aKGTgo32AXyf/jSZ6Pno/+jRq9SRmihkhHnUSh+ZdYbFJX6
	 isSBweqGWQuJ4xd6s0J/jfrg2Igu5kWfd1rczBVSkoUMZ8IZgHdKtRK7wdoeBm9VS6
	 gxS99PvPngX38DGxzfQH+cIMFNpQr3hJva0QiqUQ=
Date: Sun, 01 Sep 2024 20:29:58 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,seanjc@google.com,rientjes@google.com,riel@surriel.com,rick.p.edgecombe@intel.com,pbonzini@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,kirill@shutemov.name,hughd@google.com,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-x86-implement-arch_check_zapped_pud.patch removed from -mm tree
Message-Id: <20240902032959.0E370C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/x86: implement arch_check_zapped_pud()
has been removed from the -mm tree.  Its filename was
     mm-x86-implement-arch_check_zapped_pud.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/x86: implement arch_check_zapped_pud()
Date: Mon, 12 Aug 2024 14:12:23 -0400

Introduce arch_check_zapped_pud() to sanity check shadow stack on PUD
zaps.  It has the same logic as the PMD helper.

One thing to mention is, it might be a good idea to use page_table_check
in the future for trapping wrong setups of shadow stack pgtable entries
[1].  That is left for the future as a separate effort.

[1] https://lore.kernel.org/all/59d518698f664e07c036a5098833d7b56b953305.camel@intel.com

Link: https://lkml.kernel.org/r/20240812181225.1360970-6-peterx@redhat.com
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
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
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
 arch/x86/mm/pgtable.c          |    6 ++++++
 include/linux/pgtable.h        |    6 ++++++
 mm/huge_memory.c               |    4 +++-
 4 files changed, 25 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/pgtable.h~mm-x86-implement-arch_check_zapped_pud
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
--- a/arch/x86/mm/pgtable.c~mm-x86-implement-arch_check_zapped_pud
+++ a/arch/x86/mm/pgtable.c
@@ -926,3 +926,9 @@ void arch_check_zapped_pmd(struct vm_are
 	VM_WARN_ON_ONCE(!(vma->vm_flags & VM_SHADOW_STACK) &&
 			pmd_shstk(pmd));
 }
+
+void arch_check_zapped_pud(struct vm_area_struct *vma, pud_t pud)
+{
+	/* See note in arch_check_zapped_pte() */
+	VM_WARN_ON_ONCE(!(vma->vm_flags & VM_SHADOW_STACK) && pud_shstk(pud));
+}
--- a/include/linux/pgtable.h~mm-x86-implement-arch_check_zapped_pud
+++ a/include/linux/pgtable.h
@@ -447,6 +447,12 @@ static inline void arch_check_zapped_pmd
 }
 #endif
 
+#ifndef arch_check_zapped_pud
+static inline void arch_check_zapped_pud(struct vm_area_struct *vma, pud_t pud)
+{
+}
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long address,
--- a/mm/huge_memory.c~mm-x86-implement-arch_check_zapped_pud
+++ a/mm/huge_memory.c
@@ -2283,12 +2283,14 @@ int zap_huge_pud(struct mmu_gather *tlb,
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

mm-introduce-arch_supports_huge_pfnmap-and-special-bits-to-pmd-pud.patch
mm-drop-is_huge_zero_pud.patch
mm-mark-special-bits-for-huge-pfn-mappings-when-inject.patch
mm-allow-thp-orders-for-pfnmaps.patch
mm-gup-detect-huge-pfnmap-entries-in-gup-fast.patch
mm-pagewalk-check-pfnmap-for-folio_walk_start.patch
mm-pagewalk-check-pfnmap-for-folio_walk_start-fix.patch
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

