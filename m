From: akpm@linux-foundation.org
Subject: [merged] powerpc-mm-use-generic-version-of-pmdp_clear_flush.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:38:41 -0700
Message-ID: <5591acd1.w38Flw0iLctqiPnU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbbF2Uim (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:38:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, benh@kernel.crashing.org, kirill.shutemov@linux.intel.com, mpe@ellerman.id.au, paulus@samba.org, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: use generic version of pmdp_clear_flush()
has been removed from the -mm tree.  Its filename was
     powerpc-mm-use-generic-version-of-pmdp_clear_flush.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: powerpc/mm: use generic version of pmdp_clear_flush()

Also move the pmd_trans_huge check to generic code.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/pgtable-ppc64.h |    4 ----
 arch/powerpc/mm/pgtable_64.c             |   11 -----------
 arch/s390/include/asm/pgtable.h          |    8 ++++++++
 include/asm-generic/pgtable.h            |    9 ++-------
 mm/pgtable-generic.c                     |   17 +++++++++++++++++
 5 files changed, 27 insertions(+), 22 deletions(-)

diff -puN arch/powerpc/include/asm/pgtable-ppc64.h~powerpc-mm-use-generic-version-of-pmdp_clear_flush arch/powerpc/include/asm/pgtable-ppc64.h
--- a/arch/powerpc/include/asm/pgtable-ppc64.h~powerpc-mm-use-generic-version-of-pmdp_clear_flush
+++ a/arch/powerpc/include/asm/pgtable-ppc64.h
@@ -573,10 +573,6 @@ extern int pmdp_clear_flush_young(struct
 extern pmd_t pmdp_get_and_clear(struct mm_struct *mm,
 				unsigned long addr, pmd_t *pmdp);
 
-#define __HAVE_ARCH_PMDP_CLEAR_FLUSH
-extern pmd_t pmdp_clear_flush(struct vm_area_struct *vma, unsigned long address,
-			      pmd_t *pmdp);
-
 #define __HAVE_ARCH_PMDP_SET_WRPROTECT
 static inline void pmdp_set_wrprotect(struct mm_struct *mm, unsigned long addr,
 				      pmd_t *pmdp)
diff -puN arch/powerpc/mm/pgtable_64.c~powerpc-mm-use-generic-version-of-pmdp_clear_flush arch/powerpc/mm/pgtable_64.c
--- a/arch/powerpc/mm/pgtable_64.c~powerpc-mm-use-generic-version-of-pmdp_clear_flush
+++ a/arch/powerpc/mm/pgtable_64.c
@@ -554,17 +554,6 @@ unsigned long pmd_hugepage_update(struct
 	return old;
 }
 
-pmd_t pmdp_clear_flush(struct vm_area_struct *vma, unsigned long address,
-		       pmd_t *pmdp)
-{
-	pmd_t pmd;
-
-	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
-	VM_BUG_ON(!pmd_trans_huge(*pmdp));
-	pmd = pmdp_get_and_clear(vma->vm_mm, address, pmdp);
-	return pmd;
-}
-
 pmd_t pmdp_collapse_flush(struct vm_area_struct *vma, unsigned long address,
 			  pmd_t *pmdp)
 {
diff -puN arch/s390/include/asm/pgtable.h~powerpc-mm-use-generic-version-of-pmdp_clear_flush arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~powerpc-mm-use-generic-version-of-pmdp_clear_flush
+++ a/arch/s390/include/asm/pgtable.h
@@ -1548,6 +1548,14 @@ static inline void pmdp_set_wrprotect(st
 	}
 }
 
+static inline pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
+					unsigned long address,
+					pmd_t *pmdp)
+{
+	return pmdp_get_and_clear(vma->vm_mm, address, pmdp);
+}
+#define pmdp_collapse_flush pmdp_collapse_flush
+
 #define pfn_pmd(pfn, pgprot)	mk_pmd_phys(__pa((pfn) << PAGE_SHIFT), (pgprot))
 #define mk_pmd(page, pgprot)	pfn_pmd(page_to_pfn(page), (pgprot))
 
diff -puN include/asm-generic/pgtable.h~powerpc-mm-use-generic-version-of-pmdp_clear_flush include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~powerpc-mm-use-generic-version-of-pmdp_clear_flush
+++ a/include/asm-generic/pgtable.h
@@ -191,13 +191,8 @@ extern void pmdp_splitting_flush(struct
 
 #ifndef pmdp_collapse_flush
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static inline pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
-					unsigned long address,
-					pmd_t *pmdp)
-{
-	return pmdp_clear_flush(vma, address, pmdp);
-}
-#define pmdp_collapse_flush pmdp_collapse_flush
+extern pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
+				 unsigned long address, pmd_t *pmdp);
 #else
 static inline pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
 					unsigned long address,
diff -puN mm/pgtable-generic.c~powerpc-mm-use-generic-version-of-pmdp_clear_flush mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~powerpc-mm-use-generic-version-of-pmdp_clear_flush
+++ a/mm/pgtable-generic.c
@@ -126,6 +126,7 @@ pmd_t pmdp_clear_flush(struct vm_area_st
 {
 	pmd_t pmd;
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+	VM_BUG_ON(!pmd_trans_huge(*pmdp));
 	pmd = pmdp_get_and_clear(vma->vm_mm, address, pmdp);
 	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	return pmd;
@@ -198,3 +199,19 @@ void pmdp_invalidate(struct vm_area_stru
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
+
+#ifndef pmdp_collapse_flush
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+pmd_t pmdp_collapse_flush(struct vm_area_struct *vma, unsigned long address,
+			  pmd_t *pmdp)
+{
+	pmd_t pmd;
+
+	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+	VM_BUG_ON(pmd_trans_huge(*pmdp));
+	pmd = pmdp_get_and_clear(vma->vm_mm, address, pmdp);
+	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
+	return pmd;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#endif
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch

