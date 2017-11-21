From: akpm@linux-foundation.org
Subject: +
 mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write.patch added
 to -mm tree
Date: Tue, 21 Nov 2017 12:47:51 -0800
Message-ID: <5a1490f7.NuLHlVvmlqpqmwNQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57784 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751067AbdKUUrx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2017 15:47:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, arnd@arndb.de, benh@kernel.crashing.org, cmetcalf@mellanox.com, hpa@zytor.com, linux@armlinux.org.uk, ralf@linux-mips.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: switch to 'define pmd_write' instead of __HAVE_ARCH_PMD_WRITE
has been added to the -mm tree.  Its filename is
     mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: switch to 'define pmd_write' instead of __HAVE_ARCH_PMD_WRITE

In response to compile breakage introduced by a series that added the
pud_write helper to x86, Stephen notes:

    did you consider using the other paradigm:

    In arch include files:
    #define pud_write       pud_write
    static inline int pud_write(pud_t pud)
     .....

    Then in include/asm-generic/pgtable.h:

    #ifndef pud_write
    tatic inline int pud_write(pud_t pud)
    {
            ....
    }
    #endif

    If you had, then the powerpc code would have worked ... ;-) and many
    of the other interfaces in include/asm-generic/pgtable.h are
    protected that way ...

Given that some architecture already define pmd_write() as a macro, it's a
net reduction to drop the definition of __HAVE_ARCH_PMD_WRITE.

Link: http://lkml.kernel.org/r/151129126721.37405.13339850900081557813.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Suggested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable-3level.h        |    1 -
 arch/arm64/include/asm/pgtable.h             |    1 -
 arch/mips/include/asm/pgtable.h              |    2 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h |    1 -
 arch/s390/include/asm/pgtable.h              |    2 +-
 arch/sparc/include/asm/pgtable_64.h          |    2 +-
 arch/tile/include/asm/pgtable.h              |    1 -
 arch/x86/include/asm/pgtable.h               |    2 +-
 include/asm-generic/pgtable.h                |    4 ++--
 9 files changed, 6 insertions(+), 10 deletions(-)

diff -puN arch/arm64/include/asm/pgtable.h~mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write arch/arm64/include/asm/pgtable.h
--- a/arch/arm64/include/asm/pgtable.h~mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write
+++ a/arch/arm64/include/asm/pgtable.h
@@ -345,7 +345,6 @@ static inline int pmd_protnone(pmd_t pmd
 
 #define pmd_thp_or_huge(pmd)	(pmd_huge(pmd) || pmd_trans_huge(pmd))
 
-#define __HAVE_ARCH_PMD_WRITE
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
 
 #define pmd_mkhuge(pmd)		(__pmd(pmd_val(pmd) & ~PMD_TABLE_BIT))
diff -puN arch/arm/include/asm/pgtable-3level.h~mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write arch/arm/include/asm/pgtable-3level.h
--- a/arch/arm/include/asm/pgtable-3level.h~mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -221,7 +221,6 @@ static inline pte_t pte_mkspecial(pte_t
 }
 #define	__HAVE_ARCH_PTE_SPECIAL
 
-#define __HAVE_ARCH_PMD_WRITE
 #define pmd_write(pmd)		(pmd_isclear((pmd), L_PMD_SECT_RDONLY))
 #define pmd_dirty(pmd)		(pmd_isset((pmd), L_PMD_SECT_DIRTY))
 #define pud_page(pud)		pmd_page(__pmd(pud_val(pud)))
diff -puN arch/mips/include/asm/pgtable.h~mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write arch/mips/include/asm/pgtable.h
--- a/arch/mips/include/asm/pgtable.h~mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write
+++ a/arch/mips/include/asm/pgtable.h
@@ -552,7 +552,7 @@ static inline pmd_t pmd_mkhuge(pmd_t pmd
 extern void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 		       pmd_t *pmdp, pmd_t pmd);
 
-#define __HAVE_ARCH_PMD_WRITE
+#define pmd_write pmd_write
 static inline int pmd_write(pmd_t pmd)
 {
 	return !!(pmd_val(pmd) & _PAGE_WRITE);
diff -puN arch/powerpc/include/asm/book3s/64/pgtable.h~mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write arch/powerpc/include/asm/book3s/64/pgtable.h
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1005,7 +1005,6 @@ static inline int pmd_protnone(pmd_t pmd
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
-#define __HAVE_ARCH_PMD_WRITE
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
 #define __pmd_write(pmd)	__pte_write(pmd_pte(pmd))
 #define pmd_savedwrite(pmd)	pte_savedwrite(pmd_pte(pmd))
diff -puN arch/s390/include/asm/pgtable.h~mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write
+++ a/arch/s390/include/asm/pgtable.h
@@ -709,7 +709,7 @@ static inline unsigned long pmd_pfn(pmd_
 	return (pmd_val(pmd) & origin_mask) >> PAGE_SHIFT;
 }
 
-#define __HAVE_ARCH_PMD_WRITE
+#define pmd_write pmd_write
 static inline int pmd_write(pmd_t pmd)
 {
 	return (pmd_val(pmd) & _SEGMENT_ENTRY_WRITE) != 0;
diff -puN arch/sparc/include/asm/pgtable_64.h~mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -715,7 +715,7 @@ static inline unsigned long pmd_pfn(pmd_
 	return pte_pfn(pte);
 }
 
-#define __HAVE_ARCH_PMD_WRITE
+#define pmd_write pmd_write
 static inline unsigned long pmd_write(pmd_t pmd)
 {
 	pte_t pte = __pte(pmd_val(pmd));
diff -puN arch/tile/include/asm/pgtable.h~mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write arch/tile/include/asm/pgtable.h
--- a/arch/tile/include/asm/pgtable.h~mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write
+++ a/arch/tile/include/asm/pgtable.h
@@ -475,7 +475,6 @@ static inline void pmd_clear(pmd_t *pmdp
 #define pmd_mkdirty(pmd)	pte_pmd(pte_mkdirty(pmd_pte(pmd)))
 #define pmd_huge_page(pmd)	pte_huge(pmd_pte(pmd))
 #define pmd_mkhuge(pmd)		pte_pmd(pte_mkhuge(pmd_pte(pmd)))
-#define __HAVE_ARCH_PMD_WRITE
 
 #define pfn_pmd(pfn, pgprot)	pte_pmd(pfn_pte((pfn), (pgprot)))
 #define pmd_pfn(pmd)		pte_pfn(pmd_pte(pmd))
diff -puN arch/x86/include/asm/pgtable.h~mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write
+++ a/arch/x86/include/asm/pgtable.h
@@ -1061,7 +1061,7 @@ extern int pmdp_clear_flush_young(struct
 				  unsigned long address, pmd_t *pmdp);
 
 
-#define __HAVE_ARCH_PMD_WRITE
+#define pmd_write pmd_write
 static inline int pmd_write(pmd_t pmd)
 {
 	return pmd_flags(pmd) & _PAGE_RW;
diff -puN include/asm-generic/pgtable.h~mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write
+++ a/include/asm-generic/pgtable.h
@@ -805,13 +805,13 @@ static inline int pmd_trans_huge(pmd_t p
 {
 	return 0;
 }
-#ifndef __HAVE_ARCH_PMD_WRITE
+#ifndef pmd_write
 static inline int pmd_write(pmd_t pmd)
 {
 	BUG();
 	return 0;
 }
-#endif /* __HAVE_ARCH_PMD_WRITE */
+#endif /* pmd_write */
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifndef pud_write
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages.patch
mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages-v3.patch
mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write.patch
mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths.patch
mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths-v3.patch
mm-replace-pmd_write-with-pmd_access_permitted-in-fault-gup-paths.patch
mm-replace-pte_write-with-pte_access_permitted-in-fault-gup-paths.patch

