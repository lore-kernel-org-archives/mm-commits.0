From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages-v3.patch
 removed from -mm tree
Date: Wed, 29 Nov 2017 16:04:47 -0800
Message-ID: <5a1f4b1f.zzTYX1HG339OdNKy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59538 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752183AbdK3AEt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 19:04:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages-v3
has been removed from the -mm tree.  Its filename was
     mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages-v3.patch

This patch was dropped because it was folded into mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages.patch

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages-v3

* Switch from the "#define __HAVE_ARCH_PUD_WRITE" to "#define
  pud_write". This incidentally fixes a powerpc compile error.
  (Stephen)

Link: http://lkml.kernel.org/r/151129126165.37405.16031785266675461397.stgit@dwillia2-desk3.amr.corp.intel.com
Fixes: a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hugepages")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h    |    1 -
 arch/sparc/include/asm/pgtable_64.h |    1 -
 arch/x86/include/asm/pgtable.h      |    2 +-
 include/asm-generic/pgtable.h       |    7 +++----
 4 files changed, 4 insertions(+), 7 deletions(-)

diff -puN arch/arm64/include/asm/pgtable.h~mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages-v3 arch/arm64/include/asm/pgtable.h
--- a/arch/arm64/include/asm/pgtable.h~mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages-v3
+++ a/arch/arm64/include/asm/pgtable.h
@@ -354,7 +354,6 @@ static inline int pmd_protnone(pmd_t pmd
 #define pfn_pmd(pfn,prot)	(__pmd(((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot)))
 #define mk_pmd(page,prot)	pfn_pmd(page_to_pfn(page),prot)
 
-#define __HAVE_ARCH_PUD_WRITE
 #define pud_write(pud)		pte_write(pud_pte(pud))
 #define pud_pfn(pud)		(((pud_val(pud) & PUD_MASK) & PHYS_MASK) >> PAGE_SHIFT)
 
diff -puN arch/sparc/include/asm/pgtable_64.h~mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages-v3 arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages-v3
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -723,7 +723,6 @@ static inline unsigned long pmd_write(pm
 	return pte_write(pte);
 }
 
-#define __HAVE_ARCH_PUD_WRITE
 #define pud_write(pud)	pte_write(__pte(pud_val(pud)))
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff -puN arch/x86/include/asm/pgtable.h~mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages-v3 arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages-v3
+++ a/arch/x86/include/asm/pgtable.h
@@ -1088,7 +1088,7 @@ static inline void pmdp_set_wrprotect(st
 	clear_bit(_PAGE_BIT_RW, (unsigned long *)pmdp);
 }
 
-#define __HAVE_ARCH_PUD_WRITE
+#define pud_write pud_write
 static inline int pud_write(pud_t pud)
 {
 	return pud_flags(pud) & _PAGE_RW;
diff -puN include/asm-generic/pgtable.h~mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages-v3 include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages-v3
+++ a/include/asm-generic/pgtable.h
@@ -812,16 +812,15 @@ static inline int pmd_write(pmd_t pmd)
 	return 0;
 }
 #endif /* __HAVE_ARCH_PMD_WRITE */
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-#ifndef __HAVE_ARCH_PUD_WRITE
+#ifndef pud_write
 static inline int pud_write(pud_t pud)
 {
 	BUG();
 	return 0;
 }
-#endif /* __HAVE_ARCH_PUD_WRITE */
