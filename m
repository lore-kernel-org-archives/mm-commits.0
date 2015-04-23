From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare.patch added to -mm tree
Date: Thu, 23 Apr 2015 15:11:24 -0700
Message-ID: <55396e0c.S87ODDek44ReieBa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758429AbbDWWLZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Apr 2015 18:11:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenzhang.zhang@huawei.com, James.Yang@freescale.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, catalin.marinas@arm.com, cmetcalf@ezchip.com, james.hogan@imgtec.com, linux@arm.linux.org.uk, ralf@linux-mips.org, rientjes@google.com, schwidefsky@de.ibm.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: reduce arch dependent code about huge_pmd_unshare
has been added to the -mm tree.  Its filename is
     mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: mm/hugetlb: reduce arch dependent code about huge_pmd_unshare

Currently we have many duplicates in definitions of huge_pmd_unshare.  In
all architectures this function just returns 0 when
CONFIG_ARCH_WANT_HUGE_PMD_SHARE is N.

This patch puts the default implementation in mm/hugetlb.c and lets these
architectures use the common code.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: David Rientjes <rientjes@google.com>
Cc: James Yang <James.Yang@freescale.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/hugetlbpage.c     |    5 -----
 arch/arm64/mm/hugetlbpage.c   |    7 -------
 arch/ia64/mm/hugetlbpage.c    |    5 -----
 arch/metag/mm/hugetlbpage.c   |    5 -----
 arch/mips/mm/hugetlbpage.c    |    5 -----
 arch/powerpc/mm/hugetlbpage.c |    5 -----
 arch/s390/mm/hugetlbpage.c    |    5 -----
 arch/sh/mm/hugetlbpage.c      |    5 -----
 arch/sparc/mm/hugetlbpage.c   |    5 -----
 arch/tile/mm/hugetlbpage.c    |    5 -----
 mm/hugetlb.c                  |    5 +++++
 11 files changed, 5 insertions(+), 52 deletions(-)

diff -puN arch/arm/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare arch/arm/mm/hugetlbpage.c
--- a/arch/arm/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare
+++ a/arch/arm/mm/hugetlbpage.c
@@ -41,11 +41,6 @@ int pud_huge(pud_t pud)
 	return 0;
 }
 
-int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep)
-{
-	return 0;
-}
-
 int pmd_huge(pmd_t pmd)
 {
 	return pmd_val(pmd) && !(pmd_val(pmd) & PMD_TABLE_BIT);
diff -puN arch/arm64/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare arch/arm64/mm/hugetlbpage.c
--- a/arch/arm64/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -31,13 +31,6 @@
 #include <asm/tlbflush.h>
 #include <asm/pgalloc.h>
 
-#ifndef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
-int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep)
-{
-	return 0;
-}
-#endif
-
 int pmd_huge(pmd_t pmd)
 {
 	return !(pmd_val(pmd) & PMD_TABLE_BIT);
diff -puN arch/ia64/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare arch/ia64/mm/hugetlbpage.c
--- a/arch/ia64/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare
+++ a/arch/ia64/mm/hugetlbpage.c
@@ -65,11 +65,6 @@ huge_pte_offset (struct mm_struct *mm, u
 	return pte;
 }
 
-int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep)
-{
-	return 0;
-}
-
 #define mk_pte_huge(entry) { pte_val(entry) |= _PAGE_P; }
 
 /*
diff -puN arch/metag/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare arch/metag/mm/hugetlbpage.c
--- a/arch/metag/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare
+++ a/arch/metag/mm/hugetlbpage.c
@@ -89,11 +89,6 @@ pte_t *huge_pte_offset(struct mm_struct
 	return pte;
 }
 
-int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep)
-{
-	return 0;
-}
-
 int pmd_huge(pmd_t pmd)
 {
 	return pmd_page_shift(pmd) > PAGE_SHIFT;
diff -puN arch/mips/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare arch/mips/mm/hugetlbpage.c
--- a/arch/mips/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare
+++ a/arch/mips/mm/hugetlbpage.c
@@ -51,11 +51,6 @@ pte_t *huge_pte_offset(struct mm_struct
 	return (pte_t *) pmd;
 }
 
-int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep)
-{
-	return 0;
-}
-
 /*
  * This function checks for proper alignment of input addr and len parameters.
  */
diff -puN arch/powerpc/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -439,11 +439,6 @@ int alloc_bootmem_huge_page(struct hstat
 }
 #endif
 
-int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep)
-{
-	return 0;
-}
-
 #ifdef CONFIG_PPC_FSL_BOOK3E
 #define HUGEPD_FREELIST_SIZE \
 	((PAGE_SIZE - sizeof(struct hugepd_freelist)) / sizeof(pte_t))
diff -puN arch/s390/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare arch/s390/mm/hugetlbpage.c
--- a/arch/s390/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare
+++ a/arch/s390/mm/hugetlbpage.c
@@ -187,11 +187,6 @@ pte_t *huge_pte_offset(struct mm_struct
 	return (pte_t *) pmdp;
 }
 
-int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep)
-{
-	return 0;
-}
-
 int pmd_huge(pmd_t pmd)
 {
 	if (!MACHINE_HAS_HPAGE)
diff -puN arch/sh/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare arch/sh/mm/hugetlbpage.c
--- a/arch/sh/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare
+++ a/arch/sh/mm/hugetlbpage.c
@@ -62,11 +62,6 @@ pte_t *huge_pte_offset(struct mm_struct
 	return pte;
 }
 
-int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep)
-{
-	return 0;
-}
-
 int pmd_huge(pmd_t pmd)
 {
 	return 0;
diff -puN arch/sparc/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare arch/sparc/mm/hugetlbpage.c
--- a/arch/sparc/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -172,11 +172,6 @@ pte_t *huge_pte_offset(struct mm_struct
 	return pte;
 }
 
-int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep)
-{
-	return 0;
-}
-
 void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 		     pte_t *ptep, pte_t entry)
 {
diff -puN arch/tile/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare arch/tile/mm/hugetlbpage.c
--- a/arch/tile/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare
+++ a/arch/tile/mm/hugetlbpage.c
@@ -160,11 +160,6 @@ int pud_huge(pud_t pud)
 	return !!(pud_val(pud) & _PAGE_HUGE_PAGE);
 }
 
-int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep)
-{
-	return 0;
-}
-
 #ifdef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 static unsigned long hugetlb_get_unmapped_area_bottomup(struct file *file,
 		unsigned long addr, unsigned long len,
diff -puN mm/hugetlb.c~mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare
+++ a/mm/hugetlb.c
@@ -3789,6 +3789,11 @@ pte_t *huge_pmd_share(struct mm_struct *
 {
 	return NULL;
 }
+
+int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep)
+{
+	return 0;
+}
 #define want_pmd_share()	(0)
 #endif /* CONFIG_ARCH_WANT_HUGE_PMD_SHARE */
 
_

Patches currently in -mm which might be from zhenzhang.zhang@huawei.com are

origin.patch
mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare.patch

