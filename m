From: akpm@linux-foundation.org
Subject: [merged] x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch removed from -mm tree
Date: Fri, 25 Jan 2013 13:37:50 -0800
Message-ID: <20130125213751.315A95A4241@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:54678 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab3AYVhw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Jan 2013 16:37:52 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so81240ggi.3
        for <mm-commits@vger.kernel.org>; Fri, 25 Jan 2013 13:37:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, hpa@zytor.com, mingo@redhat.com, rientjes@google.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: convert update_mmu_cache() and update_mmu_cache_pmd() to functions
has been removed from the -mm tree.  Its filename was
     x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: x86: convert update_mmu_cache() and update_mmu_cache_pmd() to functions

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Converting macros to functions unhide type problems before changes will
be integrated and trigger problems on other architectures.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h    |   12 ++++++++++++
 arch/x86/include/asm/pgtable_32.h |    7 -------
 arch/x86/include/asm/pgtable_64.h |    3 ---
 3 files changed, 12 insertions(+), 10 deletions(-)

diff -puN arch/x86/include/asm/pgtable.h~x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions
+++ a/arch/x86/include/asm/pgtable.h
@@ -781,6 +781,18 @@ static inline void clone_pgd_range(pgd_t
        memcpy(dst, src, count * sizeof(pgd_t));
 }
 
+/*
+ * The x86 doesn't have any external MMU info: the kernel page
+ * tables contain all the necessary information.
+ */
+static inline void update_mmu_cache(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
+{
+}
+static inline void update_mmu_cache_pmd(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmd)
+{
+}
 
 #include <asm-generic/pgtable.h>
 #endif	/* __ASSEMBLY__ */
diff -puN arch/x86/include/asm/pgtable_32.h~x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions arch/x86/include/asm/pgtable_32.h
--- a/arch/x86/include/asm/pgtable_32.h~x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions
+++ a/arch/x86/include/asm/pgtable_32.h
@@ -66,13 +66,6 @@ do {						\
 	__flush_tlb_one((vaddr));		\
 } while (0)
 
-/*
- * The i386 doesn't have any external MMU info: the kernel page
- * tables contain all the necessary information.
- */
-#define update_mmu_cache(vma, address, ptep) do { } while (0)
-#define update_mmu_cache_pmd(vma, address, pmd) do { } while (0)
-
 #endif /* !__ASSEMBLY__ */
 
 /*
diff -puN arch/x86/include/asm/pgtable_64.h~x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h~x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -142,9 +142,6 @@ static inline int pgd_large(pgd_t pgd) {
 #define pte_offset_map(dir, address) pte_offset_kernel((dir), (address))
 #define pte_unmap(pte) ((void)(pte))/* NOP */
 
-#define update_mmu_cache(vma, address, ptep) do { } while (0)
-#define update_mmu_cache_pmd(vma, address, pmd) do { } while (0)
