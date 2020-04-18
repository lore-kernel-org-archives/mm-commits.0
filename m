From: akpm@linux-foundation.org
Subject: + mm-thp-rename-pmd_mknotpresent-as-pmd_mknotvalid.patch
 added to -mm tree
Date: Fri, 17 Apr 2020 17:05:57 -0700
Message-ID: <20200418000557.ZitIfToUC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbgDRAF7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 20:05:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com, dave.hansen@linux.intel.com, hpa@zytor.com, linux@armlinux.org.uk, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, peterz@infradead.org, rostedt@goodmis.org, tglx@linutronix.de, tsbogend@alpha.franken.de, vgupta@synopsys.com, will@kernel.org


The patch titled
     Subject: mm/thp: rename pmd_mknotpresent() to pmd_mknotvalid()
has been added to the -mm tree.  Its filename is
     mm-thp-rename-pmd_mknotpresent-as-pmd_mknotvalid.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-rename-pmd_mknotpresent-as-pmd_mknotvalid.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-rename-pmd_mknotpresent-as-pmd_mknotvalid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/thp: rename pmd_mknotpresent() to pmd_mknotvalid()

pmd_present() is expected to test positive after pmdp_mknotpresent() as
the PMD entry still points to a valid huge page in memory. 
pmdp_mknotpresent() implies that given PMD entry is just invalidated from
MMU perspective while still holding on to pmd_page() referred valid huge
page thus also clearing pmd_present() test.  This creates the following
situation which is counter intuitive.

[pmd_present(pmd_mknotpresent(pmd)) = true]

This renames pmd_mknotpresent() as pmd_mknotvalid() reflecting the
helper's functionality more accurately while changing the above mentioned
situation as follows.  This does not create any functional change.

[pmd_present(pmd_mknotvalid(pmd)) = true]

This is not applicable for platforms that define own pmdp_invalidate() via
__HAVE_ARCH_PMDP_INVALIDATE.  Suggestion for renaming came during a
previous discussion here.

https://patchwork.kernel.org/patch/11019637/

Link: http://lkml.kernel.org/r/1584680057-13753-3-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/hugepage.h       |    2 +-
 arch/arm/include/asm/pgtable-3level.h |    2 +-
 arch/arm64/include/asm/pgtable.h      |    2 +-
 arch/mips/include/asm/pgtable.h       |    2 +-
 arch/x86/include/asm/pgtable.h        |    2 +-
 arch/x86/mm/kmmio.c                   |    2 +-
 mm/pgtable-generic.c                  |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

--- a/arch/arc/include/asm/hugepage.h~mm-thp-rename-pmd_mknotpresent-as-pmd_mknotvalid
+++ a/arch/arc/include/asm/hugepage.h
@@ -26,7 +26,7 @@ static inline pmd_t pte_pmd(pte_t pte)
 #define pmd_mkold(pmd)		pte_pmd(pte_mkold(pmd_pte(pmd)))
 #define pmd_mkyoung(pmd)	pte_pmd(pte_mkyoung(pmd_pte(pmd)))
 #define pmd_mkhuge(pmd)		pte_pmd(pte_mkhuge(pmd_pte(pmd)))
-#define pmd_mknotpresent(pmd)	pte_pmd(pte_mknotpresent(pmd_pte(pmd)))
+#define pmd_mknotvalid(pmd)	pte_pmd(pte_mknotpresent(pmd_pte(pmd)))
 #define pmd_mkclean(pmd)	pte_pmd(pte_mkclean(pmd_pte(pmd)))
 
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
--- a/arch/arm64/include/asm/pgtable.h~mm-thp-rename-pmd_mknotpresent-as-pmd_mknotvalid
+++ a/arch/arm64/include/asm/pgtable.h
@@ -371,7 +371,7 @@ static inline int pmd_protnone(pmd_t pmd
 #define pmd_mkclean(pmd)	pte_pmd(pte_mkclean(pmd_pte(pmd)))
 #define pmd_mkdirty(pmd)	pte_pmd(pte_mkdirty(pmd_pte(pmd)))
 #define pmd_mkyoung(pmd)	pte_pmd(pte_mkyoung(pmd_pte(pmd)))
-#define pmd_mknotpresent(pmd)	(__pmd(pmd_val(pmd) & ~PMD_SECT_VALID))
+#define pmd_mknotvalid(pmd)	(__pmd(pmd_val(pmd) & ~PMD_SECT_VALID))
 
 #define pmd_thp_or_huge(pmd)	(pmd_huge(pmd) || pmd_trans_huge(pmd))
 
--- a/arch/arm/include/asm/pgtable-3level.h~mm-thp-rename-pmd_mknotpresent-as-pmd_mknotvalid
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -221,7 +221,7 @@ PMD_BIT_FUNC(mkyoung,   |= PMD_SECT_AF);
 #define pmdp_establish generic_pmdp_establish
 
 /* represent a notpresent pmd by faulting entry, this is used by pmdp_invalidate */
-static inline pmd_t pmd_mknotpresent(pmd_t pmd)
+static inline pmd_t pmd_mknotvalid(pmd_t pmd)
 {
 	return __pmd(pmd_val(pmd) & ~L_PMD_SECT_VALID);
 }
--- a/arch/mips/include/asm/pgtable.h~mm-thp-rename-pmd_mknotpresent-as-pmd_mknotvalid
+++ a/arch/mips/include/asm/pgtable.h
@@ -631,7 +631,7 @@ static inline pmd_t pmd_modify(pmd_t pmd
 	return pmd;
 }
 
-static inline pmd_t pmd_mknotpresent(pmd_t pmd)
+static inline pmd_t pmd_mknotvalid(pmd_t pmd)
 {
 	pmd_val(pmd) &= ~(_PAGE_PRESENT | _PAGE_VALID | _PAGE_DIRTY);
 
--- a/arch/x86/include/asm/pgtable.h~mm-thp-rename-pmd_mknotpresent-as-pmd_mknotvalid
+++ a/arch/x86/include/asm/pgtable.h
@@ -624,7 +624,7 @@ static inline pud_t pfn_pud(unsigned lon
 	return __pud(pfn | check_pgprot(pgprot));
 }
 
-static inline pmd_t pmd_mknotpresent(pmd_t pmd)
+static inline pmd_t pmd_mknotvalid(pmd_t pmd)
 {
 	return pfn_pmd(pmd_pfn(pmd),
 		      __pgprot(pmd_flags(pmd) & ~(_PAGE_PRESENT|_PAGE_PROTNONE)));
--- a/arch/x86/mm/kmmio.c~mm-thp-rename-pmd_mknotpresent-as-pmd_mknotvalid
+++ a/arch/x86/mm/kmmio.c
@@ -130,7 +130,7 @@ static void clear_pmd_presence(pmd_t *pm
 	pmdval_t v = pmd_val(*pmd);
 	if (clear) {
 		*old = v;
-		new_pmd = pmd_mknotpresent(*pmd);
+		new_pmd = pmd_mknotvalid(*pmd);
 	} else {
 		/* Presume this has been called with clear==true previously */
 		new_pmd = __pmd(*old);
--- a/mm/pgtable-generic.c~mm-thp-rename-pmd_mknotpresent-as-pmd_mknotvalid
+++ a/mm/pgtable-generic.c
@@ -194,7 +194,7 @@ pgtable_t pgtable_trans_huge_withdraw(st
 pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 		     pmd_t *pmdp)
 {
-	pmd_t old = pmdp_establish(vma, address, pmdp, pmd_mknotpresent(*pmdp));
+	pmd_t old = pmdp_establish(vma, address, pmdp, pmd_mknotvalid(*pmdp));
 	flush_pmd_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	return old;
 }
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug-add-tests-validating-architecture-page-table-helpers.patch
powerpc-mm-drop-platform-defined-pmd_mknotpresent.patch
mm-thp-rename-pmd_mknotpresent-as-pmd_mknotvalid.patch
