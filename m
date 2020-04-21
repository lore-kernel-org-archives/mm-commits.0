From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-debug-add-tests-validating-architecture-page-table-helpers-v17.patch
 added to -mm tree
Date: Mon, 20 Apr 2020 19:52:45 -0700
Message-ID: <20200421025245.qid24Mfru%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbgDUCws (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 22:52:48 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de, cai@lca.pw, catalin.marinas@arm.com, christophe.leroy@c-s.fr, gerald.schaefer@de.ibm.com, gor@linux.ibm.com, heiko.carstens@de.ibm.com, hpa@zytor.com, kirill@shutemov.name, mingo@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, palmer@dabbelt.com, paul.walmsley@sifive.com, paulus@samba.org, rppt@linux.ibm.com, tglx@linutronix.de, vgupta@synopsys.com, will@kernel.org


The patch titled
     Subject: mm-debug-add-tests-validating-architecture-page-table-helpers-v17
has been added to the -mm tree.  Its filename is
     mm-debug-add-tests-validating-architecture-page-table-helpers-v17.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debug-add-tests-validating-architecture-page-table-helpers-v17.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-debug-add-tests-validating-architecture-page-table-helpers-v17.patch

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
Subject: mm-debug-add-tests-validating-architecture-page-table-helpers-v17

- debug_vm_pgtable() is now called from late_initcall() per Linus

- Explicitly enable DEBUG_VM_PGTABLE when ARCH_HAS_DEBUG_VM_PGTABLE and
  DEBUG_VM

- Added #ifdef documentation per Gerald

- Dropped page table helper semantics documentation (will be added via
  later patches)

- Split the X86 changes defining mm_p4d_folded() into a new prerequisite
  patch

Link: http://lkml.kernel.org/r/1587436495-22033-3-git-send-email-anshuman.khandual@arm.com
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>	# s390
Tested-by: Christophe Leroy <christophe.leroy@c-s.fr>	# ppc32
Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |    5 -----
 init/main.c             |    2 --
 lib/Kconfig.debug       |    3 +--
 mm/debug_vm_pgtable.c   |   34 ++++++++++++----------------------
 4 files changed, 13 insertions(+), 31 deletions(-)

--- a/include/linux/mmdebug.h~mm-debug-add-tests-validating-architecture-page-table-helpers-v17
+++ a/include/linux/mmdebug.h
@@ -64,9 +64,4 @@ void dump_mm(const struct mm_struct *mm)
 #define VM_BUG_ON_PGFLAGS(cond, page) BUILD_BUG_ON_INVALID(cond)
 #endif
 
-#ifdef CONFIG_DEBUG_VM_PGTABLE
-void debug_vm_pgtable(void);
-#else
-static inline void debug_vm_pgtable(void) { }
-#endif
 #endif
--- a/init/main.c~mm-debug-add-tests-validating-architecture-page-table-helpers-v17
+++ a/init/main.c
@@ -54,7 +54,6 @@
 #include <linux/delayacct.h>
 #include <linux/unistd.h>
 #include <linux/utsname.h>
-#include <linux/mmdebug.h>
 #include <linux/rmap.h>
 #include <linux/mempolicy.h>
 #include <linux/key.h>
@@ -1358,7 +1357,6 @@ static int __ref kernel_init(void *unuse
 	kernel_init_freeable();
 	/* need to finish all async __init code before freeing the memory */
 	async_synchronize_full();
-	debug_vm_pgtable();
 	ftrace_free_init_mem();
 	free_initmem();
 	mark_readonly();
--- a/lib/Kconfig.debug~mm-debug-add-tests-validating-architecture-page-table-helpers-v17
+++ a/lib/Kconfig.debug
@@ -699,8 +699,7 @@ config DEBUG_VM_PGTABLE
 	depends on MMU
 	depends on !IA64 && !ARM
 	depends on ARCH_HAS_DEBUG_VM_PGTABLE || EXPERT
-	default n if !ARCH_HAS_DEBUG_VM_PGTABLE
-	default y if DEBUG_VM
+	default y if ARCH_HAS_DEBUG_VM_PGTABLE && DEBUG_VM
 	help
 	  This option provides a debug method which can be used to test
 	  architecture page table helper functions on various platforms in
--- a/mm/debug_vm_pgtable.c~mm-debug-add-tests-validating-architecture-page-table-helpers-v17
+++ a/mm/debug_vm_pgtable.c
@@ -30,18 +30,6 @@
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
 
-/*
- * Basic operations
- *
- * mkold(entry)			= An old and not a young entry
- * mkyoung(entry)		= A young and not an old entry
- * mkdirty(entry)		= A dirty and not a clean entry
- * mkclean(entry)		= A clean and not a dirty entry
- * mkwrite(entry)		= A write and not a write protected entry
- * wrprotect(entry)		= A write protected and not a write entry
- * pxx_bad(entry)		= A mapped and non-table entry
- * pxx_same(entry1, entry2)	= Both entries hold the exact same value
- */
 #define VMFLAGS	(VM_READ|VM_WRITE|VM_EXEC)
 
 /*
@@ -107,13 +95,13 @@ static void __init pud_basic_tests(unsig
 	 */
 	WARN_ON(!pud_bad(pud_mkhuge(pud)));
 }
-#else
+#else  /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 static void __init pud_basic_tests(unsigned long pfn, pgprot_t prot) { }
-#endif
-#else
+#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+#else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
 static void __init pmd_basic_tests(unsigned long pfn, pgprot_t prot) { }
 static void __init pud_basic_tests(unsigned long pfn, pgprot_t prot) { }
-#endif
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static void __init p4d_basic_tests(unsigned long pfn, pgprot_t prot)
 {
@@ -163,13 +151,13 @@ static void __init pud_populate_tests(st
 	pud = READ_ONCE(*pudp);
 	WARN_ON(pud_bad(pud));
 }
-#else
+#else  /* !__PAGETABLE_PUD_FOLDED */
 static void __init pud_clear_tests(struct mm_struct *mm, pud_t *pudp) { }
 static void __init pud_populate_tests(struct mm_struct *mm, pud_t *pudp,
 				      pmd_t *pmdp)
 {
 }
-#endif
+#endif /* PAGETABLE_PUD_FOLDED */
 
 #ifndef __PAGETABLE_P4D_FOLDED
 static void __init p4d_clear_tests(struct mm_struct *mm, p4d_t *p4dp)
@@ -237,7 +225,7 @@ static void __init pgd_populate_tests(st
 	pgd = READ_ONCE(*pgdp);
 	WARN_ON(pgd_bad(pgd));
 }
-#else
+#else  /* !__PAGETABLE_P4D_FOLDED */
 static void __init p4d_clear_tests(struct mm_struct *mm, p4d_t *p4dp) { }
 static void __init pgd_clear_tests(struct mm_struct *mm, pgd_t *pgdp) { }
 static void __init p4d_populate_tests(struct mm_struct *mm, p4d_t *p4dp,
@@ -248,7 +236,7 @@ static void __init pgd_populate_tests(st
 				      p4d_t *p4dp)
 {
 }
-#endif
+#endif /* PAGETABLE_P4D_FOLDED */
 
 static void __init pte_clear_tests(struct mm_struct *mm, pte_t *ptep,
 				   unsigned long vaddr)
@@ -301,7 +289,7 @@ static unsigned long __init get_random_v
 	return random_vaddr;
 }
 
-void __init debug_vm_pgtable(void)
+static int __init debug_vm_pgtable(void)
 {
 	struct mm_struct *mm;
 	pgd_t *pgdp;
@@ -322,7 +310,7 @@ void __init debug_vm_pgtable(void)
 	mm = mm_alloc();
 	if (!mm) {
 		pr_err("mm_struct allocation failed\n");
-		return;
+		return 1;
 	}
 
 	/*
@@ -389,4 +377,6 @@ void __init debug_vm_pgtable(void)
 	mm_dec_nr_pmds(mm);
 	mm_dec_nr_ptes(mm);
 	mmdrop(mm);
+	return 0;
 }
+late_initcall(debug_vm_pgtable);
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

powerpc-mm-drop-platform-defined-pmd_mknotpresent.patch
mm-thp-rename-pmd_mknotpresent-as-pmd_mknotvalid.patch
x86-mm-define-mm_p4d_folded.patch
mm-debug-add-tests-validating-architecture-page-table-helpers.patch
mm-debug-add-tests-validating-architecture-page-table-helpers-v17.patch
