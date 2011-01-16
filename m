From: akpm@linux-foundation.org
Subject: + mm-thp-remove-pmdp_get_and_clear-pmdp_clear_flush-pmdp_splitting_flush-methods-when-thp=n.patch added to -mm tree
Date: Sat, 15 Jan 2011 19:54:46 -0800
Message-ID: <201101160354.p0G3skhw014726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754418Ab1APDzM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 15 Jan 2011 22:55:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, James.Bottomley@HansenPartnership.com, benh@kernel.crashing.org, davem@davemloft.net, sfr@canb.auug.org.au, tony.luck@intel.com


The patch titled
     mm: thp: remove pmdp_get_and_clear/pmdp_clear_flush/pmdp_splitting_flush methods when THP=n
has been added to the -mm tree.  Its filename is
     mm-thp-remove-pmdp_get_and_clear-pmdp_clear_flush-pmdp_splitting_flush-methods-when-thp=n.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: thp: remove pmdp_get_and_clear/pmdp_clear_flush/pmdp_splitting_flush methods when THP=n
From: Andrea Arcangeli <aarcange@redhat.com>

pmdp_get_and_clear/pmdp_clear_flush/pmdp_splitting_flush were trapped as
BUG() and they were defined only to diminish the risk of build issues on
not-x86 archs and to be consistent with the generic pte methods previously
defined in include/asm-generic/pgtable.h.

But they are causing more trouble than they were supposed to solve, so
it's simpler not to define them when THP is off.

This is also correcting the export of pmdp_splitting_flush which is
currently unused (x86 isn't using the generic implementation in
mm/pgtable-generic.c and no other arch needs that [yet]).

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Sam Ravnborg <sam@ravnborg.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |   14 +++-----------
 mm/pgtable-generic.c          |   11 ++++-------
 2 files changed, 7 insertions(+), 18 deletions(-)

diff -puN include/asm-generic/pgtable.h~mm-thp-remove-pmdp_get_and_clear-pmdp_clear_flush-pmdp_splitting_flush-methods-when-thp=n include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-thp-remove-pmdp_get_and_clear-pmdp_clear_flush-pmdp_splitting_flush-methods-when-thp=n
+++ a/include/asm-generic/pgtable.h
@@ -87,14 +87,6 @@ static inline pmd_t pmdp_get_and_clear(s
 	pmd_clear(mm, address, pmdp);
 	return pmd;
 })
-#else /* CONFIG_TRANSPARENT_HUGEPAGE */
-static inline pmd_t pmdp_get_and_clear(struct mm_struct *mm,
-				       unsigned long address,
-				       pmd_t *pmdp)
-{
-	BUG();
-	return __pmd(0);
-}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
@@ -163,9 +155,9 @@ static inline void pmdp_set_wrprotect(st
 #endif
 
 #ifndef __HAVE_ARCH_PMDP_SPLITTING_FLUSH
-extern pmd_t pmdp_clear_flush(struct vm_area_struct *vma,
-			      unsigned long address,
-			      pmd_t *pmdp);
+extern pmd_t pmdp_splitting_flush(struct vm_area_struct *vma,
+				  unsigned long address,
+				  pmd_t *pmdp);
 #endif
 
 #ifndef __HAVE_ARCH_PTE_SAME
diff -puN mm/pgtable-generic.c~mm-thp-remove-pmdp_get_and_clear-pmdp_clear_flush-pmdp_splitting_flush-methods-when-thp=n mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mm-thp-remove-pmdp_get_and_clear-pmdp_clear_flush-pmdp_splitting_flush-methods-when-thp=n
+++ a/mm/pgtable-generic.c
@@ -92,32 +92,29 @@ pte_t ptep_clear_flush(struct vm_area_st
 #endif
 
 #ifndef __HAVE_ARCH_PMDP_CLEAR_FLUSH
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 pmd_t pmdp_clear_flush(struct vm_area_struct *vma, unsigned long address,
 		       pmd_t *pmdp)
 {
 	pmd_t pmd;
-#ifndef CONFIG_TRANSPARENT_HUGEPAGE
-	BUG();
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 	pmd = pmdp_get_and_clear(vma->vm_mm, address, pmdp);
 	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	return pmd;
 }
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
 #ifndef __HAVE_ARCH_PMDP_SPLITTING_FLUSH
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 pmd_t pmdp_splitting_flush(struct vm_area_struct *vma, unsigned long address,
 			   pmd_t *pmdp)
 {
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	pmd_t pmd = pmd_mksplitting(*pmdp);
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 	set_pmd_at(vma->vm_mm, address, pmdp, pmd);
 	/* tlb flush only to serialize against gup-fast */
 	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
-#else /* CONFIG_TRANSPARENT_HUGEPAGE */
-	BUG();
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 }
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
mm-thp-remove-pmdp_get_and_clear-pmdp_clear_flush-pmdp_splitting_flush-methods-when-thp=n.patch
thp-add-pagetranscompound.patch

