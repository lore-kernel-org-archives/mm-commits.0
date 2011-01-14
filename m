From: akpm@linux-foundation.org
Subject: [merged] thp-special-pmd_trans_-functions.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:46:49 -0800
Message-ID: <201101142249.p0EMndUB005311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753849Ab1ANWtw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:49:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: special pmd_trans_* functions
has been removed from the -mm tree.  Its filename was
     thp-special-pmd_trans_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: special pmd_trans_* functions
From: Andrea Arcangeli <aarcange@redhat.com>

These returns 0 at compile time when the config option is disabled, to
allow gcc to eliminate the transparent hugepage function calls at compile
time without additional #ifdefs (only the export of those functions have
to be visible to gcc but they won't be required at link time and
huge_memory.o can be not built at all).

_PAGE_BIT_UNUSED1 is never used for pmd, only on pte.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable_64.h    |   13 +++++++++++++
 arch/x86/include/asm/pgtable_types.h |    2 ++
 include/asm-generic/pgtable.h        |   11 +++++++++++
 3 files changed, 26 insertions(+)

diff -puN arch/x86/include/asm/pgtable_64.h~thp-special-pmd_trans_-functions arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h~thp-special-pmd_trans_-functions
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -168,6 +168,19 @@ extern void cleanup_highmap(void);
 #define	kc_offset_to_vaddr(o) ((o) | ~__VIRTUAL_MASK)
 
 #define __HAVE_ARCH_PTE_SAME
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline int pmd_trans_splitting(pmd_t pmd)
+{
+	return pmd_val(pmd) & _PAGE_SPLITTING;
+}
+
+static inline int pmd_trans_huge(pmd_t pmd)
+{
+	return pmd_val(pmd) & _PAGE_PSE;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_X86_PGTABLE_64_H */
diff -puN arch/x86/include/asm/pgtable_types.h~thp-special-pmd_trans_-functions arch/x86/include/asm/pgtable_types.h
--- a/arch/x86/include/asm/pgtable_types.h~thp-special-pmd_trans_-functions
+++ a/arch/x86/include/asm/pgtable_types.h
@@ -22,6 +22,7 @@
 #define _PAGE_BIT_PAT_LARGE	12	/* On 2MB or 1GB pages */
 #define _PAGE_BIT_SPECIAL	_PAGE_BIT_UNUSED1
 #define _PAGE_BIT_CPA_TEST	_PAGE_BIT_UNUSED1
+#define _PAGE_BIT_SPLITTING	_PAGE_BIT_UNUSED1 /* only valid on a PSE pmd */
 #define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
 
 /* If _PAGE_BIT_PRESENT is clear, we use these: */
@@ -45,6 +46,7 @@
 #define _PAGE_PAT_LARGE (_AT(pteval_t, 1) << _PAGE_BIT_PAT_LARGE)
 #define _PAGE_SPECIAL	(_AT(pteval_t, 1) << _PAGE_BIT_SPECIAL)
 #define _PAGE_CPA_TEST	(_AT(pteval_t, 1) << _PAGE_BIT_CPA_TEST)
+#define _PAGE_SPLITTING	(_AT(pteval_t, 1) << _PAGE_BIT_SPLITTING)
 #define __HAVE_ARCH_PTE_SPECIAL
 
 #ifdef CONFIG_KMEMCHECK
diff -puN include/asm-generic/pgtable.h~thp-special-pmd_trans_-functions include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~thp-special-pmd_trans_-functions
+++ a/include/asm-generic/pgtable.h
@@ -348,6 +348,17 @@ extern void untrack_pfn_vma(struct vm_ar
 				unsigned long size);
 #endif
 
+#ifndef CONFIG_TRANSPARENT_HUGEPAGE
+static inline int pmd_trans_huge(pmd_t pmd)
+{
+	return 0;
+}
+static inline int pmd_trans_splitting(pmd_t pmd)
+{
+	return 0;
+}
+#endif
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_GENERIC_PGTABLE_H */
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

