From: akpm@linux-foundation.org
Subject: + arm64-expose-number-of-page-table-levels-on-kconfig-level.patch added to -mm tree
Date: Mon, 23 Feb 2015 12:44:32 -0800
Message-ID: <54eb9130.NvF+KeHcU5RKzNPm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44308 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbbBWUod (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 15:44:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, catalin.marinas@arm.com, linux@roeck-us.net, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: expose number of page table levels on Kconfig level
has been added to the -mm tree.  Its filename is
     arm64-expose-number-of-page-table-levels-on-kconfig-level.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-expose-number-of-page-table-levels-on-kconfig-level.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-expose-number-of-page-table-levels-on-kconfig-level.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: arm64: expose number of page table levels on Kconfig level

We would want to use number of page table level to define mm_struct.
Let's expose it as CONFIG_PGTABLE_LEVELS.

ARM64_PGTABLE_LEVELS is renamed to PGTABLE_LEVELS and defined before
sourcing init/Kconfig: arch/Kconfig will define default value and it's
sourced from init/Kconfig.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig                     |   14 +++++++-------
 arch/arm64/include/asm/kvm_mmu.h       |    4 ++--
 arch/arm64/include/asm/page.h          |    4 ++--
 arch/arm64/include/asm/pgalloc.h       |    8 ++++----
 arch/arm64/include/asm/pgtable-hwdef.h |    6 +++---
 arch/arm64/include/asm/pgtable-types.h |   12 ++++++------
 arch/arm64/include/asm/pgtable.h       |    8 ++++----
 arch/arm64/include/asm/tlb.h           |    4 ++--
 arch/arm64/mm/mmu.c                    |    4 ++--
 9 files changed, 32 insertions(+), 32 deletions(-)

diff -puN arch/arm64/Kconfig~arm64-expose-number-of-page-table-levels-on-kconfig-level arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~arm64-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/arm64/Kconfig
@@ -143,6 +143,13 @@ config KERNEL_MODE_NEON
 config FIX_EARLYCON_MEM
 	def_bool y
 
+config PGTABLE_LEVELS
+	int
+	default 2 if ARM64_64K_PAGES && ARM64_VA_BITS_42
+	default 3 if ARM64_64K_PAGES && ARM64_VA_BITS_48
+	default 3 if ARM64_4K_PAGES && ARM64_VA_BITS_39
+	default 4 if ARM64_4K_PAGES && ARM64_VA_BITS_48
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
@@ -413,13 +420,6 @@ config ARM64_VA_BITS
 	default 42 if ARM64_VA_BITS_42
 	default 48 if ARM64_VA_BITS_48
 
-config ARM64_PGTABLE_LEVELS
-	int
-	default 2 if ARM64_64K_PAGES && ARM64_VA_BITS_42
-	default 3 if ARM64_64K_PAGES && ARM64_VA_BITS_48
-	default 3 if ARM64_4K_PAGES && ARM64_VA_BITS_39
-	default 4 if ARM64_4K_PAGES && ARM64_VA_BITS_48
-
 config CPU_BIG_ENDIAN
        bool "Build big-endian kernel"
        help
diff -puN arch/arm64/include/asm/kvm_mmu.h~arm64-expose-number-of-page-table-levels-on-kconfig-level arch/arm64/include/asm/kvm_mmu.h
--- a/arch/arm64/include/asm/kvm_mmu.h~arm64-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/arm64/include/asm/kvm_mmu.h
@@ -161,12 +161,12 @@ static inline bool kvm_s2pmd_readonly(pm
 /*
  * If we are concatenating first level stage-2 page tables, we would have less
  * than or equal to 16 pointers in the fake PGD, because that's what the
- * architecture allows.  In this case, (4 - CONFIG_ARM64_PGTABLE_LEVELS)
+ * architecture allows.  In this case, (4 - CONFIG_PGTABLE_LEVELS)
  * represents the first level for the host, and we add 1 to go to the next
  * level (which uses contatenation) for the stage-2 tables.
  */
 #if PTRS_PER_S2_PGD <= 16
-#define KVM_PREALLOC_LEVEL	(4 - CONFIG_ARM64_PGTABLE_LEVELS + 1)
+#define KVM_PREALLOC_LEVEL	(4 - CONFIG_PGTABLE_LEVELS + 1)
 #else
 #define KVM_PREALLOC_LEVEL	(0)
 #endif
diff -puN arch/arm64/include/asm/page.h~arm64-expose-number-of-page-table-levels-on-kconfig-level arch/arm64/include/asm/page.h
--- a/arch/arm64/include/asm/page.h~arm64-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/arm64/include/asm/page.h
@@ -36,9 +36,9 @@
  * for more information).
  */
 #ifdef CONFIG_ARM64_64K_PAGES
-#define SWAPPER_PGTABLE_LEVELS	(CONFIG_ARM64_PGTABLE_LEVELS)
+#define SWAPPER_PGTABLE_LEVELS	(CONFIG_PGTABLE_LEVELS)
 #else
-#define SWAPPER_PGTABLE_LEVELS	(CONFIG_ARM64_PGTABLE_LEVELS - 1)
+#define SWAPPER_PGTABLE_LEVELS	(CONFIG_PGTABLE_LEVELS - 1)
 #endif
 
 #define SWAPPER_DIR_SIZE	(SWAPPER_PGTABLE_LEVELS * PAGE_SIZE)
diff -puN arch/arm64/include/asm/pgalloc.h~arm64-expose-number-of-page-table-levels-on-kconfig-level arch/arm64/include/asm/pgalloc.h
--- a/arch/arm64/include/asm/pgalloc.h~arm64-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/arm64/include/asm/pgalloc.h
@@ -28,7 +28,7 @@
 
 #define PGALLOC_GFP	(GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO)
 
-#if CONFIG_ARM64_PGTABLE_LEVELS > 2
+#if CONFIG_PGTABLE_LEVELS > 2
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
@@ -46,9 +46,9 @@ static inline void pud_populate(struct m
 	set_pud(pud, __pud(__pa(pmd) | PMD_TYPE_TABLE));
 }
 
-#endif	/* CONFIG_ARM64_PGTABLE_LEVELS > 2 */
+#endif	/* CONFIG_PGTABLE_LEVELS > 2 */
 
-#if CONFIG_ARM64_PGTABLE_LEVELS > 3
+#if CONFIG_PGTABLE_LEVELS > 3
 
 static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
@@ -66,7 +66,7 @@ static inline void pgd_populate(struct m
 	set_pgd(pgd, __pgd(__pa(pud) | PUD_TYPE_TABLE));
 }
 
-#endif	/* CONFIG_ARM64_PGTABLE_LEVELS > 3 */
+#endif	/* CONFIG_PGTABLE_LEVELS > 3 */
 
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
diff -puN arch/arm64/include/asm/pgtable-hwdef.h~arm64-expose-number-of-page-table-levels-on-kconfig-level arch/arm64/include/asm/pgtable-hwdef.h
--- a/arch/arm64/include/asm/pgtable-hwdef.h~arm64-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/arm64/include/asm/pgtable-hwdef.h
@@ -21,7 +21,7 @@
 /*
  * PMD_SHIFT determines the size a level 2 page table entry can map.
  */
-#if CONFIG_ARM64_PGTABLE_LEVELS > 2
+#if CONFIG_PGTABLE_LEVELS > 2
 #define PMD_SHIFT		((PAGE_SHIFT - 3) * 2 + 3)
 #define PMD_SIZE		(_AC(1, UL) << PMD_SHIFT)
 #define PMD_MASK		(~(PMD_SIZE-1))
@@ -31,7 +31,7 @@
 /*
  * PUD_SHIFT determines the size a level 1 page table entry can map.
  */
-#if CONFIG_ARM64_PGTABLE_LEVELS > 3
+#if CONFIG_PGTABLE_LEVELS > 3
 #define PUD_SHIFT		((PAGE_SHIFT - 3) * 3 + 3)
 #define PUD_SIZE		(_AC(1, UL) << PUD_SHIFT)
 #define PUD_MASK		(~(PUD_SIZE-1))
@@ -42,7 +42,7 @@
  * PGDIR_SHIFT determines the size a top-level page table entry can map
  * (depending on the configuration, this level can be 0, 1 or 2).
  */
-#define PGDIR_SHIFT		((PAGE_SHIFT - 3) * CONFIG_ARM64_PGTABLE_LEVELS + 3)
+#define PGDIR_SHIFT		((PAGE_SHIFT - 3) * CONFIG_PGTABLE_LEVELS + 3)
 #define PGDIR_SIZE		(_AC(1, UL) << PGDIR_SHIFT)
 #define PGDIR_MASK		(~(PGDIR_SIZE-1))
 #define PTRS_PER_PGD		(1 << (VA_BITS - PGDIR_SHIFT))
diff -puN arch/arm64/include/asm/pgtable-types.h~arm64-expose-number-of-page-table-levels-on-kconfig-level arch/arm64/include/asm/pgtable-types.h
--- a/arch/arm64/include/asm/pgtable-types.h~arm64-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/arm64/include/asm/pgtable-types.h
@@ -38,13 +38,13 @@ typedef struct { pteval_t pte; } pte_t;
 #define pte_val(x)	((x).pte)
 #define __pte(x)	((pte_t) { (x) } )
 
-#if CONFIG_ARM64_PGTABLE_LEVELS > 2
+#if CONFIG_PGTABLE_LEVELS > 2
 typedef struct { pmdval_t pmd; } pmd_t;
 #define pmd_val(x)	((x).pmd)
 #define __pmd(x)	((pmd_t) { (x) } )
 #endif
 
-#if CONFIG_ARM64_PGTABLE_LEVELS > 3
+#if CONFIG_PGTABLE_LEVELS > 3
 typedef struct { pudval_t pud; } pud_t;
 #define pud_val(x)	((x).pud)
 #define __pud(x)	((pud_t) { (x) } )
@@ -64,13 +64,13 @@ typedef pteval_t pte_t;
 #define pte_val(x)	(x)
 #define __pte(x)	(x)
 
-#if CONFIG_ARM64_PGTABLE_LEVELS > 2
+#if CONFIG_PGTABLE_LEVELS > 2
 typedef pmdval_t pmd_t;
 #define pmd_val(x)	(x)
 #define __pmd(x)	(x)
 #endif
 
-#if CONFIG_ARM64_PGTABLE_LEVELS > 3
+#if CONFIG_PGTABLE_LEVELS > 3
 typedef pudval_t pud_t;
 #define pud_val(x)	(x)
 #define __pud(x)	(x)
@@ -86,9 +86,9 @@ typedef pteval_t pgprot_t;
 
 #endif /* STRICT_MM_TYPECHECKS */
 
-#if CONFIG_ARM64_PGTABLE_LEVELS == 2
+#if CONFIG_PGTABLE_LEVELS == 2
 #include <asm-generic/pgtable-nopmd.h>
-#elif CONFIG_ARM64_PGTABLE_LEVELS == 3
+#elif CONFIG_PGTABLE_LEVELS == 3
 #include <asm-generic/pgtable-nopud.h>
 #endif
 
diff -puN arch/arm64/include/asm/pgtable.h~arm64-expose-number-of-page-table-levels-on-kconfig-level arch/arm64/include/asm/pgtable.h
--- a/arch/arm64/include/asm/pgtable.h~arm64-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/arm64/include/asm/pgtable.h
@@ -374,7 +374,7 @@ static inline pte_t *pmd_page_vaddr(pmd_
  */
 #define mk_pte(page,prot)	pfn_pte(page_to_pfn(page),prot)
 
-#if CONFIG_ARM64_PGTABLE_LEVELS > 2
+#if CONFIG_PGTABLE_LEVELS > 2
 
 #define pmd_ERROR(pmd)		__pmd_error(__FILE__, __LINE__, pmd_val(pmd))
 
@@ -409,9 +409,9 @@ static inline pmd_t *pmd_offset(pud_t *p
 
 #define pud_page(pud)		pfn_to_page(__phys_to_pfn(pud_val(pud) & PHYS_MASK))
 
-#endif	/* CONFIG_ARM64_PGTABLE_LEVELS > 2 */
+#endif	/* CONFIG_PGTABLE_LEVELS > 2 */
 
-#if CONFIG_ARM64_PGTABLE_LEVELS > 3
+#if CONFIG_PGTABLE_LEVELS > 3
 
 #define pud_ERROR(pud)		__pud_error(__FILE__, __LINE__, pud_val(pud))
 
@@ -445,7 +445,7 @@ static inline pud_t *pud_offset(pgd_t *p
 
 #define pgd_page(pgd)		pfn_to_page(__phys_to_pfn(pgd_val(pgd) & PHYS_MASK))
 
-#endif  /* CONFIG_ARM64_PGTABLE_LEVELS > 3 */
+#endif  /* CONFIG_PGTABLE_LEVELS > 3 */
 
 #define pgd_ERROR(pgd)		__pgd_error(__FILE__, __LINE__, pgd_val(pgd))
 
diff -puN arch/arm64/include/asm/tlb.h~arm64-expose-number-of-page-table-levels-on-kconfig-level arch/arm64/include/asm/tlb.h
--- a/arch/arm64/include/asm/tlb.h~arm64-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/arm64/include/asm/tlb.h
@@ -52,7 +52,7 @@ static inline void __pte_free_tlb(struct
 	tlb_remove_entry(tlb, pte);
 }
 
-#if CONFIG_ARM64_PGTABLE_LEVELS > 2
+#if CONFIG_PGTABLE_LEVELS > 2
 static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
 				  unsigned long addr)
 {
@@ -60,7 +60,7 @@ static inline void __pmd_free_tlb(struct
 }
 #endif
 
-#if CONFIG_ARM64_PGTABLE_LEVELS > 3
+#if CONFIG_PGTABLE_LEVELS > 3
 static inline void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pudp,
 				  unsigned long addr)
 {
diff -puN arch/arm64/mm/mmu.c~arm64-expose-number-of-page-table-levels-on-kconfig-level arch/arm64/mm/mmu.c
--- a/arch/arm64/mm/mmu.c~arm64-expose-number-of-page-table-levels-on-kconfig-level
+++ a/arch/arm64/mm/mmu.c
@@ -550,10 +550,10 @@ void vmemmap_free(unsigned long start, u
 #endif	/* CONFIG_SPARSEMEM_VMEMMAP */
 
 static pte_t bm_pte[PTRS_PER_PTE] __page_aligned_bss;
-#if CONFIG_ARM64_PGTABLE_LEVELS > 2
+#if CONFIG_PGTABLE_LEVELS > 2
 static pmd_t bm_pmd[PTRS_PER_PMD] __page_aligned_bss;
 #endif
-#if CONFIG_ARM64_PGTABLE_LEVELS > 3
+#if CONFIG_PGTABLE_LEVELS > 3
 static pud_t bm_pud[PTRS_PER_PUD] __page_aligned_bss;
 #endif
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-rename-foll_mlock-to-foll_populate.patch
mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch
mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
mm-move-mm_populate-related-code-to-mm-gupc.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
alpha-expose-number-of-page-table-levels-on-kconfig-level.patch
arm64-expose-number-of-page-table-levels-on-kconfig-level.patch
arm-expose-number-of-page-table-levels-on-kconfig-level.patch
frv-mark-pud-and-pmd-folded.patch
ia64-expose-number-of-page-table-levels-on-kconfig-level.patch
m32r-mark-pmd-folded.patch
m68k-mark-pmd-folded-and-expose-number-of-page-table-levels.patch
mips-expose-number-of-page-table-levels-on-kconfig-level.patch
mn10300-mark-pud-and-pmd-folded.patch
parisc-expose-number-of-page-table-levels-on-kconfig-level.patch
powerpc-expose-number-of-page-table-levels-on-kconfig-level.patch
s390-expose-number-of-page-table-levels.patch
sh-expose-number-of-page-table-levels.patch
sparc-expose-number-of-page-table-levels.patch
tile-expose-number-of-page-table-levels.patch
um-expose-number-of-page-table-levels.patch
x86-expose-number-of-page-table-levels-on-kconfig-level.patch
mm-define-default-pgtable_levels-to-two.patch
mm-do-not-add-nr_pmds-into-mm_struct-if-pmd-is-folded.patch

