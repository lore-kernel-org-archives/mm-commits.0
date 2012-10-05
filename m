From: akpm@linux-foundation.org
Subject: + sparc64-only-support-4mb-huge-pages-and-8kb-base-pages.patch added to -mm tree
Date: Fri, 05 Oct 2012 15:00:46 -0700
Message-ID: <20121005220047.B6AD5100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:52773 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab2JEWAt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 18:00:49 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so249417vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 15:00:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, aarcange@redhat.com, gerald.schaefer@de.ibm.com, hannes@cmpxchg.org


The patch titled
     Subject: sparc64: Only support 4MB huge pages and 8KB base pages.
has been added to the -mm tree.  Its filename is
     sparc64-only-support-4mb-huge-pages-and-8kb-base-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Miller <davem@davemloft.net>
Subject: sparc64: Only support 4MB huge pages and 8KB base pages.

Narrowing the scope of the page size configurations will make the
transparent hugepage changes much simpler.

In the end what we really want to do is have the kernel support multiple
huge page sizes and use whatever is appropriate as the context dictactes.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/Kconfig                  |   36 ------------------------
 arch/sparc/include/asm/mmu_64.h     |   16 ----------
 arch/sparc/include/asm/page_64.h    |   12 --------
 arch/sparc/include/asm/pgtable_64.h |   38 +++-----------------------
 arch/sparc/mm/init_64.c             |    9 +-----
 arch/sparc/mm/tsb.c                 |   17 -----------
 6 files changed, 8 insertions(+), 120 deletions(-)

diff -puN arch/sparc/Kconfig~sparc64-only-support-4mb-huge-pages-and-8kb-base-pages arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~sparc64-only-support-4mb-huge-pages-and-8kb-base-pages
+++ a/arch/sparc/Kconfig
@@ -231,25 +231,6 @@ config EARLYFB
 	help
 	  Say Y here to enable a faster early framebuffer boot console.
 
-choice
-	prompt "Kernel page size" if SPARC64
-	default SPARC64_PAGE_SIZE_8KB
-
-config SPARC64_PAGE_SIZE_8KB
-	bool "8KB"
-	help
-	  This lets you select the page size of the kernel.
-
-	  8KB and 64KB work quite well, since SPARC ELF sections
-	  provide for up to 64KB alignment.
-
-	  If you don't know what to do, choose 8KB.
-
-config SPARC64_PAGE_SIZE_64KB
-	bool "64KB"
-
-endchoice
-
 config SECCOMP
 	bool "Enable seccomp to safely compute untrusted bytecode"
 	depends on SPARC64 && PROC_FS
@@ -321,23 +302,6 @@ config GENERIC_LOCKBREAK
 	default y
 	depends on SPARC64 && SMP && PREEMPT
 
-choice
-	prompt "SPARC64 Huge TLB Page Size"
-	depends on SPARC64 && HUGETLB_PAGE
-	default HUGETLB_PAGE_SIZE_4MB
-
-config HUGETLB_PAGE_SIZE_4MB
-	bool "4MB"
-
-config HUGETLB_PAGE_SIZE_512K
-	bool "512K"
-
-config HUGETLB_PAGE_SIZE_64K
-	depends on !SPARC64_PAGE_SIZE_64KB
-	bool "64K"
-
-endchoice
-
 config NUMA
 	bool "NUMA support"
 	depends on SPARC64 && SMP
diff -puN arch/sparc/include/asm/mmu_64.h~sparc64-only-support-4mb-huge-pages-and-8kb-base-pages arch/sparc/include/asm/mmu_64.h
--- a/arch/sparc/include/asm/mmu_64.h~sparc64-only-support-4mb-huge-pages-and-8kb-base-pages
+++ a/arch/sparc/include/asm/mmu_64.h
@@ -30,22 +30,8 @@
 #define CTX_PGSZ_MASK		((CTX_PGSZ_BITS << CTX_PGSZ0_SHIFT) | \
 				 (CTX_PGSZ_BITS << CTX_PGSZ1_SHIFT))
 
-#if defined(CONFIG_SPARC64_PAGE_SIZE_8KB)
 #define CTX_PGSZ_BASE	CTX_PGSZ_8KB
-#elif defined(CONFIG_SPARC64_PAGE_SIZE_64KB)
-#define CTX_PGSZ_BASE	CTX_PGSZ_64KB
-#else
-#error No page size specified in kernel configuration
-#endif
-
-#if defined(CONFIG_HUGETLB_PAGE_SIZE_4MB)
-#define CTX_PGSZ_HUGE		CTX_PGSZ_4MB
-#elif defined(CONFIG_HUGETLB_PAGE_SIZE_512K)
-#define CTX_PGSZ_HUGE		CTX_PGSZ_512KB
-#elif defined(CONFIG_HUGETLB_PAGE_SIZE_64K)
-#define CTX_PGSZ_HUGE		CTX_PGSZ_64KB
-#endif
-
+#define CTX_PGSZ_HUGE	CTX_PGSZ_4MB
 #define CTX_PGSZ_KERN	CTX_PGSZ_4MB
 
 /* Thus, when running on UltraSPARC-III+ and later, we use the following
diff -puN arch/sparc/include/asm/page_64.h~sparc64-only-support-4mb-huge-pages-and-8kb-base-pages arch/sparc/include/asm/page_64.h
--- a/arch/sparc/include/asm/page_64.h~sparc64-only-support-4mb-huge-pages-and-8kb-base-pages
+++ a/arch/sparc/include/asm/page_64.h
@@ -3,13 +3,7 @@
 
 #include <linux/const.h>
 
-#if defined(CONFIG_SPARC64_PAGE_SIZE_8KB)
 #define PAGE_SHIFT   13
-#elif defined(CONFIG_SPARC64_PAGE_SIZE_64KB)
-#define PAGE_SHIFT   16
-#else
-#error No page size specified in kernel configuration
-#endif
 
 #define PAGE_SIZE    (_AC(1,UL) << PAGE_SHIFT)
 #define PAGE_MASK    (~(PAGE_SIZE-1))
@@ -21,13 +15,7 @@
 #define DCACHE_ALIASING_POSSIBLE
 #endif
 
-#if defined(CONFIG_HUGETLB_PAGE_SIZE_4MB)
 #define HPAGE_SHIFT		22
-#elif defined(CONFIG_HUGETLB_PAGE_SIZE_512K)
-#define HPAGE_SHIFT		19
-#elif defined(CONFIG_HUGETLB_PAGE_SIZE_64K)
-#define HPAGE_SHIFT		16
-#endif
 
 #ifdef CONFIG_HUGETLB_PAGE
 #define HPAGE_SIZE		(_AC(1,UL) << HPAGE_SHIFT)
diff -puN arch/sparc/include/asm/pgtable_64.h~sparc64-only-support-4mb-huge-pages-and-8kb-base-pages arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~sparc64-only-support-4mb-huge-pages-and-8kb-base-pages
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -160,26 +160,11 @@
 #define _PAGE_SZ8K_4V	  _AC(0x0000000000000000,UL) /* 8K Page              */
 #define _PAGE_SZALL_4V	  _AC(0x0000000000000007,UL) /* All pgsz bits        */
 
-#if PAGE_SHIFT == 13
 #define _PAGE_SZBITS_4U	_PAGE_SZ8K_4U
 #define _PAGE_SZBITS_4V	_PAGE_SZ8K_4V
-#elif PAGE_SHIFT == 16
-#define _PAGE_SZBITS_4U	_PAGE_SZ64K_4U
-#define _PAGE_SZBITS_4V	_PAGE_SZ64K_4V
-#else
-#error Wrong PAGE_SHIFT specified
-#endif
 
-#if defined(CONFIG_HUGETLB_PAGE_SIZE_4MB)
 #define _PAGE_SZHUGE_4U	_PAGE_SZ4MB_4U
 #define _PAGE_SZHUGE_4V	_PAGE_SZ4MB_4V
-#elif defined(CONFIG_HUGETLB_PAGE_SIZE_512K)
-#define _PAGE_SZHUGE_4U	_PAGE_SZ512K_4U
-#define _PAGE_SZHUGE_4V	_PAGE_SZ512K_4V
-#elif defined(CONFIG_HUGETLB_PAGE_SIZE_64K)
-#define _PAGE_SZHUGE_4U	_PAGE_SZ64K_4U
-#define _PAGE_SZHUGE_4V	_PAGE_SZ64K_4V
-#endif
 
 /* These are actually filled in at boot time by sun4{u,v}_pgprot_init() */
 #define __P000	__pgprot(0)
@@ -218,7 +203,6 @@ extern unsigned long _PAGE_CACHE;
 
 extern unsigned long pg_iobits;
 extern unsigned long _PAGE_ALL_SZ_BITS;
-extern unsigned long _PAGE_SZBITS;
 
 extern struct page *mem_map_zero;
 #define ZERO_PAGE(vaddr)	(mem_map_zero)
@@ -231,22 +215,9 @@ extern struct page *mem_map_zero;
 static inline pte_t pfn_pte(unsigned long pfn, pgprot_t prot)
 {
 	unsigned long paddr = pfn << PAGE_SHIFT;
-	unsigned long sz_bits;
 
-	sz_bits = 0UL;
-	if (_PAGE_SZBITS_4U != 0UL || _PAGE_SZBITS_4V != 0UL) {
-		__asm__ __volatile__(
-		"\n661:	sethi		%%uhi(%1), %0\n"
-		"	sllx		%0, 32, %0\n"
-		"	.section	.sun4v_2insn_patch, \"ax\"\n"
-		"	.word		661b\n"
-		"	mov		%2, %0\n"
-		"	nop\n"
-		"	.previous\n"
-		: "=r" (sz_bits)
-		: "i" (_PAGE_SZBITS_4U), "i" (_PAGE_SZBITS_4V));
-	}
-	return __pte(paddr | sz_bits | pgprot_val(prot));
+	BUILD_BUG_ON(_PAGE_SZBITS_4U != 0UL || _PAGE_SZBITS_4V != 0UL);
+	return __pte(paddr | pgprot_val(prot));
 }
 #define mk_pte(page, pgprot)	pfn_pte(page_to_pfn(page), (pgprot))
 
@@ -286,6 +257,7 @@ static inline pte_t pte_modify(pte_t pte
 	 * Note: We encode this into 3 sun4v 2-insn patch sequences.
 	 */
 
+	BUILD_BUG_ON(_PAGE_SZBITS_4U != 0UL || _PAGE_SZBITS_4V != 0UL);
 	__asm__ __volatile__(
 	"\n661:	sethi		%%uhi(%2), %1\n"
 	"	sethi		%%hi(%2), %0\n"
@@ -307,10 +279,10 @@ static inline pte_t pte_modify(pte_t pte
 	: "=r" (mask), "=r" (tmp)
 	: "i" (_PAGE_PADDR_4U | _PAGE_MODIFIED_4U | _PAGE_ACCESSED_4U |
 	       _PAGE_CP_4U | _PAGE_CV_4U | _PAGE_E_4U | _PAGE_PRESENT_4U |
-	       _PAGE_SZBITS_4U | _PAGE_SPECIAL),
+	       _PAGE_SPECIAL),
 	  "i" (_PAGE_PADDR_4V | _PAGE_MODIFIED_4V | _PAGE_ACCESSED_4V |
 	       _PAGE_CP_4V | _PAGE_CV_4V | _PAGE_E_4V | _PAGE_PRESENT_4V |
-	       _PAGE_SZBITS_4V | _PAGE_SPECIAL));
+	       _PAGE_SPECIAL));
 
 	return __pte((pte_val(pte) & mask) | (pgprot_val(prot) & ~mask));
 }
diff -puN arch/sparc/mm/init_64.c~sparc64-only-support-4mb-huge-pages-and-8kb-base-pages arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~sparc64-only-support-4mb-huge-pages-and-8kb-base-pages
+++ a/arch/sparc/mm/init_64.c
@@ -276,7 +276,6 @@ static inline void tsb_insert(struct tsb
 }
 
 unsigned long _PAGE_ALL_SZ_BITS __read_mostly;
-unsigned long _PAGE_SZBITS __read_mostly;
 
 static void flush_dcache(unsigned long pfn)
 {
@@ -2275,8 +2274,7 @@ static void __init sun4u_pgprot_init(voi
 		     __ACCESS_BITS_4U | _PAGE_E_4U);
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-	kern_linear_pte_xor[0] = (_PAGE_VALID | _PAGE_SZBITS_4U) ^
-		0xfffff80000000000UL;
+	kern_linear_pte_xor[0] = _PAGE_VALID ^ 0xfffff80000000000UL;
 #else
 	kern_linear_pte_xor[0] = (_PAGE_VALID | _PAGE_SZ4MB_4U) ^
 		0xfffff80000000000UL;
@@ -2287,7 +2285,6 @@ static void __init sun4u_pgprot_init(voi
 	for (i = 1; i < 4; i++)
 		kern_linear_pte_xor[i] = kern_linear_pte_xor[0];
 
-	_PAGE_SZBITS = _PAGE_SZBITS_4U;
 	_PAGE_ALL_SZ_BITS =  (_PAGE_SZ4MB_4U | _PAGE_SZ512K_4U |
 			      _PAGE_SZ64K_4U | _PAGE_SZ8K_4U |
 			      _PAGE_SZ32MB_4U | _PAGE_SZ256MB_4U);
@@ -2324,8 +2321,7 @@ static void __init sun4v_pgprot_init(voi
 	_PAGE_CACHE = _PAGE_CACHE_4V;
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-	kern_linear_pte_xor[0] = (_PAGE_VALID | _PAGE_SZBITS_4V) ^
-		0xfffff80000000000UL;
+	kern_linear_pte_xor[0] = _PAGE_VALID ^ 0xfffff80000000000UL;
 #else
 	kern_linear_pte_xor[0] = (_PAGE_VALID | _PAGE_SZ4MB_4V) ^
 		0xfffff80000000000UL;
@@ -2339,7 +2335,6 @@ static void __init sun4v_pgprot_init(voi
 	pg_iobits = (_PAGE_VALID | _PAGE_PRESENT_4V | __DIRTY_BITS_4V |
 		     __ACCESS_BITS_4V | _PAGE_E_4V);
 
-	_PAGE_SZBITS = _PAGE_SZBITS_4V;
 	_PAGE_ALL_SZ_BITS = (_PAGE_SZ16GB_4V | _PAGE_SZ2GB_4V |
 			     _PAGE_SZ256MB_4V | _PAGE_SZ32MB_4V |
 			     _PAGE_SZ4MB_4V | _PAGE_SZ512K_4V |
diff -puN arch/sparc/mm/tsb.c~sparc64-only-support-4mb-huge-pages-and-8kb-base-pages arch/sparc/mm/tsb.c
--- a/arch/sparc/mm/tsb.c~sparc64-only-support-4mb-huge-pages-and-8kb-base-pages
+++ a/arch/sparc/mm/tsb.c
@@ -90,29 +90,12 @@ void flush_tsb_user(struct tlb_batch *tb
 	spin_unlock_irqrestore(&mm->context.lock, flags);
 }
 
-#if defined(CONFIG_SPARC64_PAGE_SIZE_8KB)
 #define HV_PGSZ_IDX_BASE	HV_PGSZ_IDX_8K
 #define HV_PGSZ_MASK_BASE	HV_PGSZ_MASK_8K
-#elif defined(CONFIG_SPARC64_PAGE_SIZE_64KB)
-#define HV_PGSZ_IDX_BASE	HV_PGSZ_IDX_64K
-#define HV_PGSZ_MASK_BASE	HV_PGSZ_MASK_64K
-#else
-#error Broken base page size setting...
-#endif
 
 #ifdef CONFIG_HUGETLB_PAGE
-#if defined(CONFIG_HUGETLB_PAGE_SIZE_64K)
-#define HV_PGSZ_IDX_HUGE	HV_PGSZ_IDX_64K
-#define HV_PGSZ_MASK_HUGE	HV_PGSZ_MASK_64K
-#elif defined(CONFIG_HUGETLB_PAGE_SIZE_512K)
-#define HV_PGSZ_IDX_HUGE	HV_PGSZ_IDX_512K
-#define HV_PGSZ_MASK_HUGE	HV_PGSZ_MASK_512K
-#elif defined(CONFIG_HUGETLB_PAGE_SIZE_4MB)
 #define HV_PGSZ_IDX_HUGE	HV_PGSZ_IDX_4MB
 #define HV_PGSZ_MASK_HUGE	HV_PGSZ_MASK_4MB
-#else
-#error Broken huge page size setting...
-#endif
 #endif
 
 static void setup_tsb_params(struct mm_struct *mm, unsigned long tsb_idx, unsigned long tsb_bytes)
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
linux-next.patch
kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option.patch
kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option.patch
kconfig-clean-up-the-long-arch-list-for-the-debug_bugverbose-config-option.patch
kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry.patch
atomic-implement-generic-atomic_dec_if_positive.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
sparc64-only-support-4mb-huge-pages-and-8kb-base-pages.patch
sparc64-halve-the-size-of-pte-tables.patch
sparc64-eliminate-pte-table-memory-wastage.patch
sparc64-document-pgd-and-pmd-layout.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix.patch
mm-thp-use-more-portable-pmd-clearing-sequenece-in-zap_huge_pmd.patch
sparc64-support-transparent-huge-pages.patch
compat-generic-compat_sys_sched_rr_get_interval-implementation.patch

