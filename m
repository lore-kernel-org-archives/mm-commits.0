Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C7915A8
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 02:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723516071; cv=none; b=VlJNUKX6Op/s4Qocn7/GNHUL+dTLNdhKCdhjrDH8ANMw2AXhb6NGBEZaC8119n4odLyRmAIFjn/KvTyKQ9JgjwueT6hB2kG4dnPQhwU/6uGbXK5IO9UGmlBTUn1XR3vk5VGSQBjrHgh5cwvP4vcx8zisL/Dtp27lbHwPpivAWPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723516071; c=relaxed/simple;
	bh=XGrHY3CGuZIofUrYkK/Wl0VDSW+lMREYjVvq4bihzEQ=;
	h=Date:To:From:Subject:Message-Id; b=lvSnB7hT8HdmbsBNvcT6yjr26xb0y3dpZts0E3OqEeBUrpvuchMto8K+4BqP2D1gXlEMGxqy1lZ5So6iWxexAPleevzlNKWccQ1hxdSLy1v/WBcDD4urXYRovpjh+HS8KmZNldekufkWgByFi+i9IEOcCt04c3m+iAarCNIkgzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=StC92Ig1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="StC92Ig1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11ACC4AF0D;
	Tue, 13 Aug 2024 02:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723516070;
	bh=XGrHY3CGuZIofUrYkK/Wl0VDSW+lMREYjVvq4bihzEQ=;
	h=Date:To:From:Subject:From;
	b=StC92Ig1o97sjLV4iebX5xJsDlebMGc1Wr9jIFoojgngDvlLm8wd3qaDJnsrrd0GT
	 o9anfVE3m2zibVlgASzo3b/Xclq2MFe+b42BX5zPvLygY5ptf0wsQTNPeWbNzvCav4
	 nttz6SOsggBsCvPtciKHT7OTbMLaJkiumlrCnSXQ=
Date: Mon, 12 Aug 2024 19:27:49 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,seanjc@google.com,rientjes@google.com,riel@surriel.com,rick.p.edgecombe@intel.com,pbonzini@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mgorman@techsingularity.net,kirill@shutemov.name,jthoughton@google.com,hughd@google.com,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-x86-arch_check_zapped_pud.patch removed from -mm tree
Message-Id: <20240813022750.B11ACC4AF0D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/x86: arch_check_zapped_pud()
has been removed from the -mm tree.  Its filename was
     mm-x86-arch_check_zapped_pud.patch

This patch was dropped because an updated version will be issued

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
@@ -2290,12 +2290,14 @@ int zap_huge_pud(struct mmu_gather *tlb,
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

mm-x86-add-missing-pud-helpers.patch
mm-mprotect-fix-dax-pud-handlings.patch

