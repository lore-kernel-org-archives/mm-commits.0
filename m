From: akpm@linux-foundation.org
Subject: + arch-kmap_atomic-consolidate-duplicate-code.patch added
 to -mm tree
Date: Thu, 30 Apr 2020 14:20:53 -0700
Message-ID: <20200430212053.7GKQhTXTh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgD3VU5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Apr 2020 17:20:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, benh@kernel.crashing.org, bp@alien8.de, chris@zankel.net, christian.koenig@amd.com, dan.j.williams@intel.com, daniel@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net, deller@gmx.de, hpa@zytor.com, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@samba.org, peterz@infradead.org, ray.huang@amd.com, tglx@linutronix.de, thellstrom@vmware.com, tsbogend@alpha.franken.de


The patch titled
     Subject: arch/kmap_atomic: consolidate duplicate code
has been added to the -mm tree.  Its filename is
     arch-kmap_atomic-consolidate-duplicate-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-kmap_atomic-consolidate-duplicate-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-kmap_atomic-consolidate-duplicate-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: arch/kmap_atomic: consolidate duplicate code

Every arch has the same code to ensure atomic operations and a check for
!HIGHMEM page.

Remove the duplicate code by defining a core kmap_atomic() which only
calls the arch specific kmap_atomic_high() when the page is high memory.

Link: http://lkml.kernel.org/r/20200430203845.582900-6-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/highmem.h        |    2 +-
 arch/arc/mm/highmem.c                 |    9 ++-------
 arch/arm/include/asm/highmem.h        |    2 +-
 arch/arm/mm/highmem.c                 |    9 ++-------
 arch/csky/include/asm/highmem.h       |    2 +-
 arch/csky/mm/highmem.c                |    9 ++-------
 arch/microblaze/include/asm/highmem.h |    2 +-
 arch/microblaze/mm/highmem.c          |    6 ------
 arch/mips/include/asm/highmem.h       |    2 +-
 arch/mips/mm/cache.c                  |    2 +-
 arch/mips/mm/highmem.c                |   18 ++----------------
 arch/nds32/include/asm/highmem.h      |    2 +-
 arch/nds32/mm/highmem.c               |    9 ++-------
 arch/powerpc/include/asm/highmem.h    |    2 +-
 arch/powerpc/mm/highmem.c             |   11 -----------
 arch/sparc/include/asm/highmem.h      |    2 +-
 arch/sparc/mm/highmem.c               |    9 ++-------
 arch/x86/include/asm/highmem.h        |    7 +++++--
 arch/x86/mm/highmem_32.c              |   20 --------------------
 arch/xtensa/include/asm/highmem.h     |    2 +-
 arch/xtensa/mm/highmem.c              |    9 ++-------
 include/linux/highmem.h               |   22 ++++++++++++++++++++++
 22 files changed, 51 insertions(+), 107 deletions(-)

--- a/arch/arc/include/asm/highmem.h~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/arc/include/asm/highmem.h
@@ -30,7 +30,7 @@
 
 #include <asm/cacheflush.h>
 
-extern void *kmap_atomic(struct page *page);
+extern void *kmap_atomic_high(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 
 extern void kmap_init(void);
--- a/arch/arc/mm/highmem.c~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/arc/mm/highmem.c
@@ -49,16 +49,11 @@
 extern pte_t * pkmap_page_table;
 static pte_t * fixmap_page_table;
 
-void *kmap_atomic(struct page *page)
+void *kmap_atomic_high(struct page *page)
 {
 	int idx, cpu_idx;
 	unsigned long vaddr;
 
-	preempt_disable();
-	pagefault_disable();
-	if (!PageHighMem(page))
-		return page_address(page);
-
 	cpu_idx = kmap_atomic_idx_push();
 	idx = cpu_idx + KM_TYPE_NR * smp_processor_id();
 	vaddr = FIXMAP_ADDR(idx);
@@ -68,7 +63,7 @@ void *kmap_atomic(struct page *page)
 
 	return (void *)vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic);
+EXPORT_SYMBOL(kmap_atomic_high);
 
 void __kunmap_atomic(void *kv)
 {
--- a/arch/arm/include/asm/highmem.h~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/arm/include/asm/highmem.h
@@ -60,7 +60,7 @@ static inline void *kmap_high_get(struct
  * when CONFIG_HIGHMEM is not set.
  */
 #ifdef CONFIG_HIGHMEM
-extern void *kmap_atomic(struct page *page);
+extern void *kmap_atomic_high(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
 #endif
--- a/arch/arm/mm/highmem.c~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/arm/mm/highmem.c
@@ -31,18 +31,13 @@ static inline pte_t get_fixmap_pte(unsig
 	return *ptep;
 }
 
-void *kmap_atomic(struct page *page)
+void *kmap_atomic_high(struct page *page)
 {
 	unsigned int idx;
 	unsigned long vaddr;
 	void *kmap;
 	int type;
 
-	preempt_disable();
-	pagefault_disable();
-	if (!PageHighMem(page))
-		return page_address(page);
-
 #ifdef CONFIG_DEBUG_HIGHMEM
 	/*
 	 * There is no cache coherency issue when non VIVT, so force the
@@ -76,7 +71,7 @@ void *kmap_atomic(struct page *page)
 
 	return (void *)vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic);
+EXPORT_SYMBOL(kmap_atomic_high);
 
 void __kunmap_atomic(void *kvaddr)
 {
--- a/arch/csky/include/asm/highmem.h~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/csky/include/asm/highmem.h
@@ -32,7 +32,7 @@ extern pte_t *pkmap_page_table;
 
 #define ARCH_HAS_KMAP_FLUSH_TLB
 extern void kmap_flush_tlb(unsigned long addr);
-extern void *kmap_atomic(struct page *page);
+extern void *kmap_atomic_high(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
 extern struct page *kmap_atomic_to_page(void *ptr);
--- a/arch/csky/mm/highmem.c~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/csky/mm/highmem.c
@@ -21,16 +21,11 @@ EXPORT_SYMBOL(kmap_flush_tlb);
 
 EXPORT_SYMBOL(kmap);
 
-void *kmap_atomic(struct page *page)
+void *kmap_atomic_high(struct page *page)
 {
 	unsigned long vaddr;
 	int idx, type;
 
-	preempt_disable();
-	pagefault_disable();
-	if (!PageHighMem(page))
-		return page_address(page);
-
 	type = kmap_atomic_idx_push();
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
@@ -42,7 +37,7 @@ void *kmap_atomic(struct page *page)
 
 	return (void *)vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic);
+EXPORT_SYMBOL(kmap_atomic_high);
 
 void __kunmap_atomic(void *kvaddr)
 {
--- a/arch/microblaze/include/asm/highmem.h~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/microblaze/include/asm/highmem.h
@@ -54,7 +54,7 @@ extern pte_t *pkmap_page_table;
 extern void *kmap_atomic_prot(struct page *page, pgprot_t prot);
 extern void __kunmap_atomic(void *kvaddr);
 
-static inline void *kmap_atomic(struct page *page)
+static inline void *kmap_atomic_high(struct page *page)
 {
 	return kmap_atomic_prot(page, kmap_prot);
 }
--- a/arch/microblaze/mm/highmem.c~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/microblaze/mm/highmem.c
@@ -38,12 +38,6 @@ void *kmap_atomic_prot(struct page *page
 	unsigned long vaddr;
 	int idx, type;
 
-	preempt_disable();
-	pagefault_disable();
-	if (!PageHighMem(page))
-		return page_address(page);
-
-
 	type = kmap_atomic_idx_push();
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
--- a/arch/mips/include/asm/highmem.h~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/mips/include/asm/highmem.h
@@ -48,7 +48,7 @@ extern pte_t *pkmap_page_table;
 
 #define ARCH_HAS_KMAP_FLUSH_TLB
 extern void kmap_flush_tlb(unsigned long addr);
-extern void *kmap_atomic(struct page *page);
+extern void *kmap_atomic_high(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
 
--- a/arch/mips/mm/cache.c~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/mips/mm/cache.c
@@ -14,9 +14,9 @@
 #include <linux/sched.h>
 #include <linux/syscalls.h>
 #include <linux/mm.h>
+#include <linux/highmem.h>
 
 #include <asm/cacheflush.h>
-#include <asm/highmem.h>
 #include <asm/processor.h>
 #include <asm/cpu.h>
 #include <asm/cpu-features.h>
--- a/arch/mips/mm/highmem.c~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/mips/mm/highmem.c
@@ -18,25 +18,11 @@ void kmap_flush_tlb(unsigned long addr)
 }
 EXPORT_SYMBOL(kmap_flush_tlb);
 
-/*
- * kmap_atomic/kunmap_atomic is significantly faster than kmap/kunmap because
- * no global lock is needed and because the kmap code must perform a global TLB
- * invalidation when the kmap pool wraps.
- *
- * However when holding an atomic kmap is is not legal to sleep, so atomic
- * kmaps are appropriate for short, tight code paths only.
- */
-
-void *kmap_atomic(struct page *page)
+void *kmap_atomic_high(struct page *page)
 {
 	unsigned long vaddr;
 	int idx, type;
 
-	preempt_disable();
-	pagefault_disable();
-	if (!PageHighMem(page))
-		return page_address(page);
-
 	type = kmap_atomic_idx_push();
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
@@ -48,7 +34,7 @@ void *kmap_atomic(struct page *page)
 
 	return (void*) vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic);
+EXPORT_SYMBOL(kmap_atomic_high);
 
 void __kunmap_atomic(void *kvaddr)
 {
--- a/arch/nds32/include/asm/highmem.h~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/nds32/include/asm/highmem.h
@@ -51,7 +51,7 @@ extern void kmap_init(void);
  * when CONFIG_HIGHMEM is not set.
  */
 #ifdef CONFIG_HIGHMEM
-extern void *kmap_atomic(struct page *page);
+extern void *kmap_atomic_high(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
 extern struct page *kmap_atomic_to_page(void *ptr);
--- a/arch/nds32/mm/highmem.c~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/nds32/mm/highmem.c
@@ -10,18 +10,13 @@
 #include <asm/fixmap.h>
 #include <asm/tlbflush.h>
 
-void *kmap_atomic(struct page *page)
+void *kmap_atomic_high(struct page *page)
 {
 	unsigned int idx;
 	unsigned long vaddr, pte;
 	int type;
 	pte_t *ptep;
 
-	preempt_disable();
-	pagefault_disable();
-	if (!PageHighMem(page))
-		return page_address(page);
-
 	type = kmap_atomic_idx_push();
 
 	idx = type + KM_TYPE_NR * smp_processor_id();
@@ -37,7 +32,7 @@ void *kmap_atomic(struct page *page)
 	return (void *)vaddr;
 }
 
-EXPORT_SYMBOL(kmap_atomic);
+EXPORT_SYMBOL(kmap_atomic_high);
 
 void __kunmap_atomic(void *kvaddr)
 {
--- a/arch/powerpc/include/asm/highmem.h~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/powerpc/include/asm/highmem.h
@@ -62,7 +62,7 @@ extern pte_t *pkmap_page_table;
 extern void *kmap_atomic_prot(struct page *page, pgprot_t prot);
 extern void __kunmap_atomic(void *kvaddr);
 
-static inline void *kmap_atomic(struct page *page)
+static inline void *kmap_atomic_high(struct page *page)
 {
 	return kmap_atomic_prot(page, kmap_prot);
 }
--- a/arch/powerpc/mm/highmem.c~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/powerpc/mm/highmem.c
@@ -24,22 +24,11 @@
 #include <linux/highmem.h>
 #include <linux/module.h>
 
-/*
- * The use of kmap_atomic/kunmap_atomic is discouraged - kmap/kunmap
- * gives a more generic (and caching) interface. But kmap_atomic can
- * be used in IRQ contexts, so in some (very limited) cases we need
- * it.
- */
 void *kmap_atomic_prot(struct page *page, pgprot_t prot)
 {
 	unsigned long vaddr;
 	int idx, type;
 
-	preempt_disable();
-	pagefault_disable();
-	if (!PageHighMem(page))
-		return page_address(page);
-
 	type = kmap_atomic_idx_push();
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
--- a/arch/sparc/include/asm/highmem.h~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/sparc/include/asm/highmem.h
@@ -50,7 +50,7 @@ void kmap_init(void) __init;
 
 #define PKMAP_END (PKMAP_ADDR(LAST_PKMAP))
 
-void *kmap_atomic(struct page *page);
+void *kmap_atomic_high(struct page *page);
 void __kunmap_atomic(void *kvaddr);
 
 #define flush_cache_kmaps()	flush_cache_all()
--- a/arch/sparc/mm/highmem.c~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/sparc/mm/highmem.c
@@ -53,16 +53,11 @@ void __init kmap_init(void)
         kmap_prot = __pgprot(SRMMU_ET_PTE | SRMMU_PRIV | SRMMU_CACHE);
 }
 
-void *kmap_atomic(struct page *page)
+void *kmap_atomic_high(struct page *page)
 {
 	unsigned long vaddr;
 	long idx, type;
 
-	preempt_disable();
-	pagefault_disable();
-	if (!PageHighMem(page))
-		return page_address(page);
-
 	type = kmap_atomic_idx_push();
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
@@ -87,7 +82,7 @@ void *kmap_atomic(struct page *page)
 
 	return (void*) vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic);
+EXPORT_SYMBOL(kmap_atomic_high);
 
 void __kunmap_atomic(void *kvaddr)
 {
--- a/arch/x86/include/asm/highmem.h~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/x86/include/asm/highmem.h
@@ -58,8 +58,11 @@ extern unsigned long highstart_pfn, high
 #define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
 
-void *kmap_atomic_prot(struct page *page, pgprot_t prot);
-void *kmap_atomic(struct page *page);
+extern void *kmap_atomic_prot(struct page *page, pgprot_t prot);
+void *kmap_atomic_high(struct page *page)
+{
+	return kmap_atomic_prot(page, kmap_prot);
+}
 void __kunmap_atomic(void *kvaddr);
 void *kmap_atomic_pfn(unsigned long pfn);
 void *kmap_atomic_prot_pfn(unsigned long pfn, pgprot_t prot);
--- a/arch/x86/mm/highmem_32.c~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/x86/mm/highmem_32.c
@@ -4,25 +4,11 @@
 #include <linux/swap.h> /* for totalram_pages */
 #include <linux/memblock.h>
 
-/*
- * kmap_atomic/kunmap_atomic is significantly faster than kmap/kunmap because
- * no global lock is needed and because the kmap code must perform a global TLB
- * invalidation when the kmap pool wraps.
- *
- * However when holding an atomic kmap it is not legal to sleep, so atomic
- * kmaps are appropriate for short, tight code paths only.
- */
 void *kmap_atomic_prot(struct page *page, pgprot_t prot)
 {
 	unsigned long vaddr;
 	int idx, type;
 
-	preempt_disable();
-	pagefault_disable();
-
-	if (!PageHighMem(page))
-		return page_address(page);
-
 	type = kmap_atomic_idx_push();
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
@@ -34,12 +20,6 @@ void *kmap_atomic_prot(struct page *page
 }
 EXPORT_SYMBOL(kmap_atomic_prot);
 
-void *kmap_atomic(struct page *page)
-{
-	return kmap_atomic_prot(page, kmap_prot);
-}
-EXPORT_SYMBOL(kmap_atomic);
-
 /*
  * This is the same as kmap_atomic() but can map memory that doesn't
  * have a struct page associated with it.
--- a/arch/xtensa/include/asm/highmem.h~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/xtensa/include/asm/highmem.h
@@ -68,7 +68,7 @@ static inline void flush_cache_kmaps(voi
 	flush_cache_all();
 }
 
-void *kmap_atomic(struct page *page);
+void *kmap_atomic_high(struct page *page);
 void __kunmap_atomic(void *kvaddr);
 
 void kmap_init(void);
--- a/arch/xtensa/mm/highmem.c~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/xtensa/mm/highmem.c
@@ -37,16 +37,11 @@ static inline enum fixed_addresses kmap_
 		color;
 }
 
-void *kmap_atomic(struct page *page)
+void *kmap_atomic_high(struct page *page)
 {
 	enum fixed_addresses idx;
 	unsigned long vaddr;
 
-	preempt_disable();
-	pagefault_disable();
-	if (!PageHighMem(page))
-		return page_address(page);
-
 	idx = kmap_idx(kmap_atomic_idx_push(),
 		       DCACHE_ALIAS(page_to_phys(page)));
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
@@ -57,7 +52,7 @@ void *kmap_atomic(struct page *page)
 
 	return (void *)vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic);
+EXPORT_SYMBOL(kmap_atomic_high);
 
 void __kunmap_atomic(void *kvaddr)
 {
--- a/include/linux/highmem.h~arch-kmap_atomic-consolidate-duplicate-code
+++ a/include/linux/highmem.h
@@ -61,6 +61,28 @@ static inline void kunmap(struct page *p
 	kunmap_high(page);
 }
 
+/*
+ * kmap_atomic/kunmap_atomic is significantly faster than kmap/kunmap because
+ * no global lock is needed and because the kmap code must perform a global TLB
+ * invalidation when the kmap pool wraps.
+ *
+ * However when holding an atomic kmap is is not legal to sleep, so atomic
+ * kmaps are appropriate for short, tight code paths only.
+ *
+ * The use of kmap_atomic/kunmap_atomic is discouraged - kmap/kunmap
+ * gives a more generic (and caching) interface. But kmap_atomic can
+ * be used in IRQ contexts, so in some (very limited) cases we need
+ * it.
+ */
+static inline void *kmap_atomic(struct page *page)
+{
+	preempt_disable();
+	pagefault_disable();
+	if (!PageHighMem(page))
+		return page_address(page);
+	return kmap_atomic_high(page);
+}
+
 /* declarations for linux/mm/highmem.c */
 unsigned int nr_free_highpages(void);
 extern atomic_long_t _totalhigh_pages;
_

Patches currently in -mm which might be from ira.weiny@intel.com are

arch-kmap-remove-bug_on.patch
arch-xtensa-move-kmap-build-bug-out-of-the-way.patch
arch-kmap-remove-redundant-arch-specific-kmaps.patch
arch-kunmap-remove-duplicate-kunmap-implementations.patch
arch-kmap_atomic-consolidate-duplicate-code.patch
arch-kunmap_atomic-consolidate-duplicate-code.patch
arch-kmap-ensure-kmap_prot-visibility.patch
arch-kmap-dont-hard-code-kmap_prot-values.patch
arch-kmap-define-kmap_atomic_prot-for-all-archs.patch
drm-remove-drm-specific-kmap_atomic-code.patch
