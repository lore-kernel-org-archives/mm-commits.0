From: akpm@linux-foundation.org
Subject: [merged]
 arch-kmap_atomic-consolidate-duplicate-code.patch removed from -mm tree
Date: Fri, 05 Jun 2020 13:17:25 -0700
Message-ID: <20200605201725.tlNzxJ9Gc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728163AbgFEUR1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:17:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bp@alien8.de, chris@zankel.net, christian.koenig@amd.com, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net, deller@gmx.de, hch@lst.de, hpa@zytor.com, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, tsbogend@alpha.franken.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: arch/kmap_atomic: consolidate duplicate code
has been removed from the -mm tree.  Its filename was
     arch-kmap_atomic-consolidate-duplicate-code.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Ira Weiny <ira.weiny@intel.com>
Subject: arch/kmap_atomic: consolidate duplicate code

Every arch has the same code to ensure atomic operations and a check for
!HIGHMEM page.

Remove the duplicate code by defining a core kmap_atomic() which only
calls the arch specific kmap_atomic_high() when the page is high memory.

[akpm@linux-foundation.org: coding style fixes]
Link: http://lkml.kernel.org/r/20200507150004.1423069-7-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/highmem.h        |    1 -
 arch/arc/mm/highmem.c                 |    9 ++-------
 arch/arm/include/asm/highmem.h        |    1 -
 arch/arm/mm/highmem.c                 |    9 ++-------
 arch/csky/include/asm/highmem.h       |    1 -
 arch/csky/mm/highmem.c                |    9 ++-------
 arch/microblaze/include/asm/highmem.h |    4 ++--
 arch/mips/include/asm/highmem.h       |    1 -
 arch/mips/mm/cache.c                  |    2 +-
 arch/mips/mm/highmem.c                |   18 ++----------------
 arch/nds32/include/asm/highmem.h      |    1 -
 arch/nds32/mm/highmem.c               |   11 ++---------
 arch/powerpc/include/asm/highmem.h    |    4 ++--
 arch/powerpc/mm/highmem.c             |    6 ------
 arch/sparc/include/asm/highmem.h      |    1 -
 arch/sparc/mm/highmem.c               |    9 ++-------
 arch/x86/include/asm/highmem.h        |    5 ++++-
 arch/x86/mm/highmem_32.c              |   14 --------------
 arch/xtensa/include/asm/highmem.h     |    1 -
 arch/xtensa/mm/highmem.c              |    9 ++-------
 include/linux/highmem.h               |   23 +++++++++++++++++++++++
 21 files changed, 46 insertions(+), 93 deletions(-)

--- a/arch/arc/include/asm/highmem.h~arch-kmap_atomic-consolidate-duplicate=
-code
+++ a/arch/arc/include/asm/highmem.h
@@ -30,7 +30,6 @@
=20
 #include <asm/cacheflush.h>
=20
-extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
=20
 extern void kmap_init(void);
--- a/arch/arc/mm/highmem.c~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/arc/mm/highmem.c
@@ -49,16 +49,11 @@
 extern pte_t * pkmap_page_table;
 static pte_t * fixmap_page_table;
=20
-void *kmap_atomic(struct page *page)
+void *kmap_atomic_high(struct page *page)
 {
 	int idx, cpu_idx;
 	unsigned long vaddr;
=20
-	preempt_disable();
-	pagefault_disable();
-	if (!PageHighMem(page))
-		return page_address(page);
-
 	cpu_idx =3D kmap_atomic_idx_push();
 	idx =3D cpu_idx + KM_TYPE_NR * smp_processor_id();
 	vaddr =3D FIXMAP_ADDR(idx);
@@ -68,7 +63,7 @@ void *kmap_atomic(struct page *page)
=20
 	return (void *)vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic);
+EXPORT_SYMBOL(kmap_atomic_high);
=20
 void __kunmap_atomic(void *kv)
 {
--- a/arch/arm/include/asm/highmem.h~arch-kmap_atomic-consolidate-duplicate=
-code
+++ a/arch/arm/include/asm/highmem.h
@@ -60,7 +60,6 @@ static inline void *kmap_high_get(struct
  * when CONFIG_HIGHMEM is not set.
  */
 #ifdef CONFIG_HIGHMEM
-extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
 #endif
--- a/arch/arm/mm/highmem.c~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/arm/mm/highmem.c
@@ -31,18 +31,13 @@ static inline pte_t get_fixmap_pte(unsig
 	return *ptep;
 }
=20
-void *kmap_atomic(struct page *page)
+void *kmap_atomic_high(struct page *page)
 {
 	unsigned int idx;
 	unsigned long vaddr;
 	void *kmap;
 	int type;
=20
-	preempt_disable();
-	pagefault_disable();
-	if (!PageHighMem(page))
-		return page_address(page);
-
 #ifdef CONFIG_DEBUG_HIGHMEM
 	/*
 	 * There is no cache coherency issue when non VIVT, so force the
@@ -76,7 +71,7 @@ void *kmap_atomic(struct page *page)
=20
 	return (void *)vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic);
+EXPORT_SYMBOL(kmap_atomic_high);
=20
 void __kunmap_atomic(void *kvaddr)
 {
--- a/arch/csky/include/asm/highmem.h~arch-kmap_atomic-consolidate-duplicat=
e-code
+++ a/arch/csky/include/asm/highmem.h
@@ -32,7 +32,6 @@ extern pte_t *pkmap_page_table;
=20
 #define ARCH_HAS_KMAP_FLUSH_TLB
 extern void kmap_flush_tlb(unsigned long addr);
-extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
 extern struct page *kmap_atomic_to_page(void *ptr);
--- a/arch/csky/mm/highmem.c~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/csky/mm/highmem.c
@@ -21,16 +21,11 @@ EXPORT_SYMBOL(kmap_flush_tlb);
=20
 EXPORT_SYMBOL(kmap);
=20
-void *kmap_atomic(struct page *page)
+void *kmap_atomic_high(struct page *page)
 {
 	unsigned long vaddr;
 	int idx, type;
=20
-	preempt_disable();
-	pagefault_disable();
-	if (!PageHighMem(page))
-		return page_address(page);
-
 	type =3D kmap_atomic_idx_push();
 	idx =3D type + KM_TYPE_NR*smp_processor_id();
 	vaddr =3D __fix_to_virt(FIX_KMAP_BEGIN + idx);
@@ -42,7 +37,7 @@ void *kmap_atomic(struct page *page)
=20
 	return (void *)vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic);
+EXPORT_SYMBOL(kmap_atomic_high);
=20
 void __kunmap_atomic(void *kvaddr)
 {
--- a/arch/microblaze/include/asm/highmem.h~arch-kmap_atomic-consolidate-du=
plicate-code
+++ a/arch/microblaze/include/asm/highmem.h
@@ -63,9 +63,9 @@ static inline void *kmap_atomic_prot(str
 }
 extern void __kunmap_atomic(void *kvaddr);
=20
-static inline void *kmap_atomic(struct page *page)
+static inline void *kmap_atomic_high(struct page *page)
 {
-	return kmap_atomic_prot(page, kmap_prot);
+	return kmap_atomic_high_prot(page, kmap_prot);
 }
=20
 #define flush_cache_kmaps()	{ flush_icache(); flush_dcache(); }
--- a/arch/mips/include/asm/highmem.h~arch-kmap_atomic-consolidate-duplicat=
e-code
+++ a/arch/mips/include/asm/highmem.h
@@ -48,7 +48,6 @@ extern pte_t *pkmap_page_table;
=20
 #define ARCH_HAS_KMAP_FLUSH_TLB
 extern void kmap_flush_tlb(unsigned long addr);
-extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
=20
--- a/arch/mips/mm/cache.c~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/mips/mm/cache.c
@@ -14,9 +14,9 @@
 #include <linux/sched.h>
 #include <linux/syscalls.h>
 #include <linux/mm.h>
+#include <linux/highmem.h>
=20
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
=20
-/*
- * kmap_atomic/kunmap_atomic is significantly faster than kmap/kunmap beca=
use
- * no global lock is needed and because the kmap code must perform a globa=
l TLB
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
=20
-	preempt_disable();
-	pagefault_disable();
-	if (!PageHighMem(page))
-		return page_address(page);
-
 	type =3D kmap_atomic_idx_push();
 	idx =3D type + KM_TYPE_NR*smp_processor_id();
 	vaddr =3D __fix_to_virt(FIX_KMAP_BEGIN + idx);
@@ -48,7 +34,7 @@ void *kmap_atomic(struct page *page)
=20
 	return (void*) vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic);
+EXPORT_SYMBOL(kmap_atomic_high);
=20
 void __kunmap_atomic(void *kvaddr)
 {
--- a/arch/nds32/include/asm/highmem.h~arch-kmap_atomic-consolidate-duplica=
te-code
+++ a/arch/nds32/include/asm/highmem.h
@@ -51,7 +51,6 @@ extern void kmap_init(void);
  * when CONFIG_HIGHMEM is not set.
  */
 #ifdef CONFIG_HIGHMEM
-extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
 extern struct page *kmap_atomic_to_page(void *ptr);
--- a/arch/nds32/mm/highmem.c~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/nds32/mm/highmem.c
@@ -10,18 +10,13 @@
 #include <asm/fixmap.h>
 #include <asm/tlbflush.h>
=20
-void *kmap_atomic(struct page *page)
+void *kmap_atomic_high(struct page *page)
 {
 	unsigned int idx;
 	unsigned long vaddr, pte;
 	int type;
 	pte_t *ptep;
=20
-	preempt_disable();
-	pagefault_disable();
-	if (!PageHighMem(page))
-		return page_address(page);
-
 	type =3D kmap_atomic_idx_push();
=20
 	idx =3D type + KM_TYPE_NR * smp_processor_id();
@@ -36,8 +31,7 @@ void *kmap_atomic(struct page *page)
 	__nds32__isb();
 	return (void *)vaddr;
 }
-
-EXPORT_SYMBOL(kmap_atomic);
+EXPORT_SYMBOL(kmap_atomic_high);
=20
 void __kunmap_atomic(void *kvaddr)
 {
@@ -53,5 +47,4 @@ void __kunmap_atomic(void *kvaddr)
 	pagefault_enable();
 	preempt_enable();
 }
-
 EXPORT_SYMBOL(__kunmap_atomic);
--- a/arch/powerpc/include/asm/highmem.h~arch-kmap_atomic-consolidate-dupli=
cate-code
+++ a/arch/powerpc/include/asm/highmem.h
@@ -71,9 +71,9 @@ static inline void *kmap_atomic_prot(str
 }
 extern void __kunmap_atomic(void *kvaddr);
=20
-static inline void *kmap_atomic(struct page *page)
+static inline void *kmap_atomic_high(struct page *page)
 {
-	return kmap_atomic_prot(page, kmap_prot);
+	return kmap_atomic_high_prot(page, kmap_prot);
 }
=20
=20
--- a/arch/powerpc/mm/highmem.c~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/powerpc/mm/highmem.c
@@ -24,12 +24,6 @@
 #include <linux/highmem.h>
 #include <linux/module.h>
=20
-/*
- * The use of kmap_atomic/kunmap_atomic is discouraged - kmap/kunmap
- * gives a more generic (and caching) interface. But kmap_atomic can
- * be used in IRQ contexts, so in some (very limited) cases we need
- * it.
- */
 void *kmap_atomic_high_prot(struct page *page, pgprot_t prot)
 {
 	unsigned long vaddr;
--- a/arch/sparc/include/asm/highmem.h~arch-kmap_atomic-consolidate-duplica=
te-code
+++ a/arch/sparc/include/asm/highmem.h
@@ -50,7 +50,6 @@ void kmap_init(void) __init;
=20
 #define PKMAP_END (PKMAP_ADDR(LAST_PKMAP))
=20
-void *kmap_atomic(struct page *page);
 void __kunmap_atomic(void *kvaddr);
=20
 #define flush_cache_kmaps()	flush_cache_all()
--- a/arch/sparc/mm/highmem.c~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/sparc/mm/highmem.c
@@ -53,16 +53,11 @@ void __init kmap_init(void)
         kmap_prot =3D __pgprot(SRMMU_ET_PTE | SRMMU_PRIV | SRMMU_CACHE);
 }
=20
-void *kmap_atomic(struct page *page)
+void *kmap_atomic_high(struct page *page)
 {
 	unsigned long vaddr;
 	long idx, type;
=20
-	preempt_disable();
-	pagefault_disable();
-	if (!PageHighMem(page))
-		return page_address(page);
-
 	type =3D kmap_atomic_idx_push();
 	idx =3D type + KM_TYPE_NR*smp_processor_id();
 	vaddr =3D __fix_to_virt(FIX_KMAP_BEGIN + idx);
@@ -87,7 +82,7 @@ void *kmap_atomic(struct page *page)
=20
 	return (void*) vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic);
+EXPORT_SYMBOL(kmap_atomic_high);
=20
 void __kunmap_atomic(void *kvaddr)
 {
--- a/arch/x86/include/asm/highmem.h~arch-kmap_atomic-consolidate-duplicate=
-code
+++ a/arch/x86/include/asm/highmem.h
@@ -68,7 +68,10 @@ static inline void *kmap_atomic_prot(str
=20
 	return kmap_atomic_high_prot(page, prot);
 }
-void *kmap_atomic(struct page *page);
+static inline void *kmap_atomic_high(struct page *page)
+{
+	return kmap_atomic_high_prot(page, kmap_prot);
+}
 void __kunmap_atomic(void *kvaddr);
 void *kmap_atomic_pfn(unsigned long pfn);
 void *kmap_atomic_prot_pfn(unsigned long pfn, pgprot_t prot);
--- a/arch/x86/mm/highmem_32.c~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/x86/mm/highmem_32.c
@@ -4,14 +4,6 @@
 #include <linux/swap.h> /* for totalram_pages */
 #include <linux/memblock.h>
=20
-/*
- * kmap_atomic/kunmap_atomic is significantly faster than kmap/kunmap beca=
use
- * no global lock is needed and because the kmap code must perform a globa=
l TLB
- * invalidation when the kmap pool wraps.
- *
- * However when holding an atomic kmap it is not legal to sleep, so atomic
- * kmaps are appropriate for short, tight code paths only.
- */
 void *kmap_atomic_high_prot(struct page *page, pgprot_t prot)
 {
 	unsigned long vaddr;
@@ -28,12 +20,6 @@ void *kmap_atomic_high_prot(struct page
 }
 EXPORT_SYMBOL(kmap_atomic_high_prot);
=20
-void *kmap_atomic(struct page *page)
-{
-	return kmap_atomic_prot(page, kmap_prot);
-}
-EXPORT_SYMBOL(kmap_atomic);
-
 /*
  * This is the same as kmap_atomic() but can map memory that doesn't
  * have a struct page associated with it.
--- a/arch/xtensa/include/asm/highmem.h~arch-kmap_atomic-consolidate-duplic=
ate-code
+++ a/arch/xtensa/include/asm/highmem.h
@@ -68,7 +68,6 @@ static inline void flush_cache_kmaps(voi
 	flush_cache_all();
 }
=20
-void *kmap_atomic(struct page *page);
 void __kunmap_atomic(void *kvaddr);
=20
 void kmap_init(void);
--- a/arch/xtensa/mm/highmem.c~arch-kmap_atomic-consolidate-duplicate-code
+++ a/arch/xtensa/mm/highmem.c
@@ -37,16 +37,11 @@ static inline enum fixed_addresses kmap_
 		color;
 }
=20
-void *kmap_atomic(struct page *page)
+void *kmap_atomic_high(struct page *page)
 {
 	enum fixed_addresses idx;
 	unsigned long vaddr;
=20
-	preempt_disable();
-	pagefault_disable();
-	if (!PageHighMem(page))
-		return page_address(page);
-
 	idx =3D kmap_idx(kmap_atomic_idx_push(),
 		       DCACHE_ALIAS(page_to_phys(page)));
 	vaddr =3D __fix_to_virt(FIX_KMAP_BEGIN + idx);
@@ -57,7 +52,7 @@ void *kmap_atomic(struct page *page)
=20
 	return (void *)vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic);
+EXPORT_SYMBOL(kmap_atomic_high);
=20
 void __kunmap_atomic(void *kvaddr)
 {
--- a/include/linux/highmem.h~arch-kmap_atomic-consolidate-duplicate-code
+++ a/include/linux/highmem.h
@@ -32,6 +32,7 @@ static inline void invalidate_kernel_vma
 #include <asm/kmap_types.h>
=20
 #ifdef CONFIG_HIGHMEM
+extern void *kmap_atomic_high(struct page *page);
 #include <asm/highmem.h>
=20
 #ifndef ARCH_HAS_KMAP_FLUSH_TLB
@@ -62,6 +63,28 @@ static inline void kunmap(struct page *p
 	kunmap_high(page);
 }
=20
+/*
+ * kmap_atomic/kunmap_atomic is significantly faster than kmap/kunmap beca=
use
+ * no global lock is needed and because the kmap code must perform a globa=
l TLB
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
