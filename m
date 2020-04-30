From: akpm@linux-foundation.org
Subject: + arch-kmap-define-kmap_atomic_prot-for-all-archs.patch
 added to -mm tree
Date: Thu, 30 Apr 2020 14:21:17 -0700
Message-ID: <20200430212117.rTeW_eAlS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgD3VVU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Apr 2020 17:21:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, benh@kernel.crashing.org, bp@alien8.de, chris@zankel.net, christian.koenig@amd.com, dan.j.williams@intel.com, daniel@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net, deller@gmx.de, hpa@zytor.com, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@samba.org, peterz@infradead.org, ray.huang@amd.com, tglx@linutronix.de, thellstrom@vmware.com, tsbogend@alpha.franken.de


The patch titled
     Subject: arch/kmap: define kmap_atomic_prot() for all arch's
has been added to the -mm tree.  Its filename is
     arch-kmap-define-kmap_atomic_prot-for-all-archs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-kmap-define-kmap_atomic_prot-for-all-archs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-kmap-define-kmap_atomic_prot-for-all-archs.patch

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
Subject: arch/kmap: define kmap_atomic_prot() for all arch's

To support kmap_atomic_prot(), all architectures need to support
protections passed to their kmap_atomic_high() function.  Pass protections
into kmap_atomic_high() and change the name to kmap_atomic_high_prot() to
match.

Then define kmap_atomic_prot() as a core function which calls
kmap_atomic_high_prot() when needed.

Finally, redefine kmap_atomic() as a wrapper of kmap_atomic_prot() with
the default kmap_prot exported by the architectures.

Link: http://lkml.kernel.org/r/20200430203845.582900-10-ira.weiny@intel.com
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
 arch/arc/mm/highmem.c                 |    6 +++---
 arch/arm/include/asm/highmem.h        |    2 +-
 arch/arm/mm/highmem.c                 |    6 +++---
 arch/csky/include/asm/highmem.h       |    2 +-
 arch/csky/mm/highmem.c                |    6 +++---
 arch/microblaze/include/asm/highmem.h |    7 +------
 arch/microblaze/mm/highmem.c          |    4 ++--
 arch/mips/include/asm/highmem.h       |    2 +-
 arch/mips/mm/highmem.c                |    6 +++---
 arch/nds32/include/asm/highmem.h      |    2 +-
 arch/nds32/mm/highmem.c               |    6 +++---
 arch/powerpc/include/asm/highmem.h    |    8 +-------
 arch/powerpc/mm/highmem.c             |    4 ++--
 arch/sparc/include/asm/highmem.h      |    2 +-
 arch/sparc/mm/highmem.c               |    6 +++---
 arch/x86/include/asm/highmem.h        |    6 +-----
 arch/x86/mm/highmem_32.c              |    4 ++--
 arch/xtensa/include/asm/highmem.h     |    2 +-
 arch/xtensa/mm/highmem.c              |    6 +++---
 include/linux/highmem.h               |    5 +++--
 21 files changed, 40 insertions(+), 54 deletions(-)

--- a/arch/arc/include/asm/highmem.h~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/arc/include/asm/highmem.h
@@ -30,7 +30,7 @@
 
 #include <asm/cacheflush.h>
 
-extern void *kmap_atomic_high(struct page *page);
+extern void *kmap_atomic_high_prot(struct page *page, pgprot_t prot);
 extern void kunmap_atomic_high(void *kvaddr);
 
 extern void kmap_init(void);
--- a/arch/arc/mm/highmem.c~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/arc/mm/highmem.c
@@ -49,7 +49,7 @@
 extern pte_t * pkmap_page_table;
 static pte_t * fixmap_page_table;
 
-void *kmap_atomic_high(struct page *page)
+void *kmap_atomic_high_prot(struct page *page, pgprot_t prot)
 {
 	int idx, cpu_idx;
 	unsigned long vaddr;
@@ -59,11 +59,11 @@ void *kmap_atomic_high(struct page *page
 	vaddr = FIXMAP_ADDR(idx);
 
 	set_pte_at(&init_mm, vaddr, fixmap_page_table + idx,
-		   mk_pte(page, kmap_prot));
+		   mk_pte(page, prot));
 
 	return (void *)vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic_high);
+EXPORT_SYMBOL(kmap_atomic_high_prot);
 
 void kunmap_atomic_high(void *kv)
 {
--- a/arch/arm/include/asm/highmem.h~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/arm/include/asm/highmem.h
@@ -60,7 +60,7 @@ static inline void *kmap_high_get(struct
  * when CONFIG_HIGHMEM is not set.
  */
 #ifdef CONFIG_HIGHMEM
-extern void *kmap_atomic_high(struct page *page);
+extern void *kmap_atomic_high_prot(struct page *page, pgprot_t prot);
 extern void kunmap_atomic_high(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
 #endif
--- a/arch/arm/mm/highmem.c~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/arm/mm/highmem.c
@@ -31,7 +31,7 @@ static inline pte_t get_fixmap_pte(unsig
 	return *ptep;
 }
 
-void *kmap_atomic_high(struct page *page)
+void *kmap_atomic_high_prot(struct page *page, pgprot_t prot)
 {
 	unsigned int idx;
 	unsigned long vaddr;
@@ -67,11 +67,11 @@ void *kmap_atomic_high(struct page *page
 	 * in place, so the contained TLB flush ensures the TLB is updated
 	 * with the new mapping.
 	 */
-	set_fixmap_pte(idx, mk_pte(page, kmap_prot));
+	set_fixmap_pte(idx, mk_pte(page, prot));
 
 	return (void *)vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic_high);
+EXPORT_SYMBOL(kmap_atomic_high_prot);
 
 void kunmap_atomic_high(void *kvaddr)
 {
--- a/arch/csky/include/asm/highmem.h~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/csky/include/asm/highmem.h
@@ -32,7 +32,7 @@ extern pte_t *pkmap_page_table;
 
 #define ARCH_HAS_KMAP_FLUSH_TLB
 extern void kmap_flush_tlb(unsigned long addr);
-extern void *kmap_atomic_high(struct page *page);
+extern void *kmap_atomic_high_prot(struct page *page, pgprot_t prot);
 extern void kunmap_atomic_high(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
 extern struct page *kmap_atomic_to_page(void *ptr);
--- a/arch/csky/mm/highmem.c~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/csky/mm/highmem.c
@@ -21,7 +21,7 @@ EXPORT_SYMBOL(kmap_flush_tlb);
 
 EXPORT_SYMBOL(kmap);
 
-void *kmap_atomic_high(struct page *page)
+void *kmap_atomic_high_prot(struct page *page, pgprot_t prot)
 {
 	unsigned long vaddr;
 	int idx, type;
@@ -32,12 +32,12 @@ void *kmap_atomic_high(struct page *page
 #ifdef CONFIG_DEBUG_HIGHMEM
 	BUG_ON(!pte_none(*(kmap_pte - idx)));
 #endif
-	set_pte(kmap_pte-idx, mk_pte(page, kmap_prot));
+	set_pte(kmap_pte-idx, mk_pte(page, prot));
 	flush_tlb_one((unsigned long)vaddr);
 
 	return (void *)vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic_high);
+EXPORT_SYMBOL(kmap_atomic_high_prot);
 
 void kunmap_atomic_high(void *kvaddr)
 {
--- a/arch/microblaze/include/asm/highmem.h~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/microblaze/include/asm/highmem.h
@@ -51,14 +51,9 @@ extern pte_t *pkmap_page_table;
 #define PKMAP_NR(virt)  ((virt - PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
 
-extern void *kmap_atomic_prot(struct page *page, pgprot_t prot);
+extern void *kmap_atomic_high_prot(struct page *page, pgprot_t prot);
 extern void kunmap_atomic_high(void *kvaddr);
 
-static inline void *kmap_atomic_high(struct page *page)
-{
-	return kmap_atomic_prot(page, kmap_prot);
-}
-
 #define flush_cache_kmaps()	{ flush_icache(); flush_dcache(); }
 
 #endif /* __KERNEL__ */
--- a/arch/microblaze/mm/highmem.c~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/microblaze/mm/highmem.c
@@ -32,7 +32,7 @@
  */
 #include <asm/tlbflush.h>
 
-void *kmap_atomic_prot(struct page *page, pgprot_t prot)
+void *kmap_atomic_high_prot(struct page *page, pgprot_t prot)
 {
 
 	unsigned long vaddr;
@@ -49,7 +49,7 @@ void *kmap_atomic_prot(struct page *page
 
 	return (void *) vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic_prot);
+EXPORT_SYMBOL(kmap_atomic_high_prot);
 
 void kunmap_atomic_high(void *kvaddr)
 {
--- a/arch/mips/include/asm/highmem.h~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/mips/include/asm/highmem.h
@@ -48,7 +48,7 @@ extern pte_t *pkmap_page_table;
 
 #define ARCH_HAS_KMAP_FLUSH_TLB
 extern void kmap_flush_tlb(unsigned long addr);
-extern void *kmap_atomic_high(struct page *page);
+extern void *kmap_atomic_high_prot(struct page *page, pgprot_t prot);
 extern void kunmap_atomic_high(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
 
--- a/arch/mips/mm/highmem.c~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/mips/mm/highmem.c
@@ -18,7 +18,7 @@ void kmap_flush_tlb(unsigned long addr)
 }
 EXPORT_SYMBOL(kmap_flush_tlb);
 
-void *kmap_atomic_high(struct page *page)
+void *kmap_atomic_high_prot(struct page *page, pgprot_t prot)
 {
 	unsigned long vaddr;
 	int idx, type;
@@ -29,12 +29,12 @@ void *kmap_atomic_high(struct page *page
 #ifdef CONFIG_DEBUG_HIGHMEM
 	BUG_ON(!pte_none(*(kmap_pte - idx)));
 #endif
-	set_pte(kmap_pte-idx, mk_pte(page, kmap_prot));
+	set_pte(kmap_pte-idx, mk_pte(page, prot));
 	local_flush_tlb_one((unsigned long)vaddr);
 
 	return (void*) vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic_high);
+EXPORT_SYMBOL(kmap_atomic_high_prot);
 
 void kunmap_atomic_high(void *kvaddr)
 {
--- a/arch/nds32/include/asm/highmem.h~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/nds32/include/asm/highmem.h
@@ -51,7 +51,7 @@ extern void kmap_init(void);
  * when CONFIG_HIGHMEM is not set.
  */
 #ifdef CONFIG_HIGHMEM
-extern void *kmap_atomic_high(struct page *page);
+extern void *kmap_atomic_high_prot(struct page *page, pgprot_t prot);
 extern void kunmap_atomic_high(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
 extern struct page *kmap_atomic_to_page(void *ptr);
--- a/arch/nds32/mm/highmem.c~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/nds32/mm/highmem.c
@@ -10,7 +10,7 @@
 #include <asm/fixmap.h>
 #include <asm/tlbflush.h>
 
-void *kmap_atomic_high(struct page *page)
+void *kmap_atomic_high_prot(struct page *page, pgprot_t prot)
 {
 	unsigned int idx;
 	unsigned long vaddr, pte;
@@ -21,7 +21,7 @@ void *kmap_atomic_high(struct page *page
 
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
-	pte = (page_to_pfn(page) << PAGE_SHIFT) | (kmap_prot);
+	pte = (page_to_pfn(page) << PAGE_SHIFT) | prot;
 	ptep = pte_offset_kernel(pmd_off_k(vaddr), vaddr);
 	set_pte(ptep, pte);
 
@@ -32,7 +32,7 @@ void *kmap_atomic_high(struct page *page
 	return (void *)vaddr;
 }
 
-EXPORT_SYMBOL(kmap_atomic_high);
+EXPORT_SYMBOL(kmap_atomic_high_prot);
 
 void kunmap_atomic_high(void *kvaddr)
 {
--- a/arch/powerpc/include/asm/highmem.h~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/powerpc/include/asm/highmem.h
@@ -59,15 +59,9 @@ extern pte_t *pkmap_page_table;
 #define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
 
-extern void *kmap_atomic_prot(struct page *page, pgprot_t prot);
+extern void *kmap_atomic_high_prot(struct page *page, pgprot_t prot);
 extern void kunmap_atomic_high(void *kvaddr);
 
-static inline void *kmap_atomic_high(struct page *page)
-{
-	return kmap_atomic_prot(page, kmap_prot);
-}
-
-
 #define flush_cache_kmaps()	flush_cache_all()
 
 #endif /* __KERNEL__ */
--- a/arch/powerpc/mm/highmem.c~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/powerpc/mm/highmem.c
@@ -24,7 +24,7 @@
 #include <linux/highmem.h>
 #include <linux/module.h>
 
-void *kmap_atomic_prot(struct page *page, pgprot_t prot)
+void *kmap_atomic_high_prot(struct page *page, pgprot_t prot)
 {
 	unsigned long vaddr;
 	int idx, type;
@@ -38,7 +38,7 @@ void *kmap_atomic_prot(struct page *page
 
 	return (void*) vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic_prot);
+EXPORT_SYMBOL(kmap_atomic_high_prot);
 
 void kunmap_atomic_high(void *kvaddr)
 {
--- a/arch/sparc/include/asm/highmem.h~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/sparc/include/asm/highmem.h
@@ -50,7 +50,7 @@ void kmap_init(void) __init;
 
 #define PKMAP_END (PKMAP_ADDR(LAST_PKMAP))
 
-void *kmap_atomic_high(struct page *page);
+void *kmap_atomic_high_prot(struct page *page, pgprot_t prot);
 void kunmap_atomic_high(void *kvaddr);
 
 #define flush_cache_kmaps()	flush_cache_all()
--- a/arch/sparc/mm/highmem.c~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/sparc/mm/highmem.c
@@ -54,7 +54,7 @@ void __init kmap_init(void)
         kmap_prot = __pgprot(SRMMU_ET_PTE | SRMMU_PRIV | SRMMU_CACHE);
 }
 
-void *kmap_atomic_high(struct page *page)
+void *kmap_atomic_high_prot(struct page *page, pgprot_t prot)
 {
 	unsigned long vaddr;
 	long idx, type;
@@ -73,7 +73,7 @@ void *kmap_atomic_high(struct page *page
 #ifdef CONFIG_DEBUG_HIGHMEM
 	BUG_ON(!pte_none(*(kmap_pte-idx)));
 #endif
-	set_pte(kmap_pte-idx, mk_pte(page, kmap_prot));
+	set_pte(kmap_pte-idx, mk_pte(page, prot));
 /* XXX Fix - Anton */
 #if 0
 	__flush_tlb_one(vaddr);
@@ -83,7 +83,7 @@ void *kmap_atomic_high(struct page *page
 
 	return (void*) vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic_high);
+EXPORT_SYMBOL(kmap_atomic_high_prot);
 
 void kunmap_atomic_high(void *kvaddr)
 {
--- a/arch/x86/include/asm/highmem.h~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/x86/include/asm/highmem.h
@@ -58,11 +58,7 @@ extern unsigned long highstart_pfn, high
 #define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
 
-extern void *kmap_atomic_prot(struct page *page, pgprot_t prot);
-void *kmap_atomic_high(struct page *page)
-{
-	return kmap_atomic_prot(page, kmap_prot);
-}
+void *kmap_atomic_high_prot(struct page *page, pgprot_t prot);
 void kunmap_atomic_high(void *kvaddr);
 void *kmap_atomic_pfn(unsigned long pfn);
 void *kmap_atomic_prot_pfn(unsigned long pfn, pgprot_t prot);
--- a/arch/x86/mm/highmem_32.c~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/x86/mm/highmem_32.c
@@ -4,7 +4,7 @@
 #include <linux/swap.h> /* for totalram_pages */
 #include <linux/memblock.h>
 
-void *kmap_atomic_prot(struct page *page, pgprot_t prot)
+void *kmap_atomic_high_prot(struct page *page, pgprot_t prot)
 {
 	unsigned long vaddr;
 	int idx, type;
@@ -18,7 +18,7 @@ void *kmap_atomic_prot(struct page *page
 
 	return (void *)vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic_prot);
+EXPORT_SYMBOL(kmap_atomic_high_prot);
 
 /*
  * This is the same as kmap_atomic() but can map memory that doesn't
--- a/arch/xtensa/include/asm/highmem.h~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/xtensa/include/asm/highmem.h
@@ -68,7 +68,7 @@ static inline void flush_cache_kmaps(voi
 	flush_cache_all();
 }
 
-void *kmap_atomic_high(struct page *page);
+void *kmap_atomic_high_prot(struct page *page, pgprot_t prot);
 void kunmap_atomic_high(void *kvaddr);
 
 void kmap_init(void);
--- a/arch/xtensa/mm/highmem.c~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/xtensa/mm/highmem.c
@@ -37,7 +37,7 @@ static inline enum fixed_addresses kmap_
 		color;
 }
 
-void *kmap_atomic_high(struct page *page)
+void *kmap_atomic_high_prot(struct page *page, pgprot_t prot)
 {
 	enum fixed_addresses idx;
 	unsigned long vaddr;
@@ -48,11 +48,11 @@ void *kmap_atomic_high(struct page *page
 #ifdef CONFIG_DEBUG_HIGHMEM
 	BUG_ON(!pte_none(*(kmap_pte + idx)));
 #endif
-	set_pte(kmap_pte + idx, mk_pte(page, kmap_prot));
+	set_pte(kmap_pte + idx, mk_pte(page, prot));
 
 	return (void *)vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic_high);
+EXPORT_SYMBOL(kmap_atomic_high_prot);
 
 void kunmap_atomic_high(void *kvaddr)
 {
--- a/include/linux/highmem.h~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/include/linux/highmem.h
@@ -74,14 +74,15 @@ static inline void kunmap(struct page *p
  * be used in IRQ contexts, so in some (very limited) cases we need
  * it.
  */
-static inline void *kmap_atomic(struct page *page)
+static inline void *kmap_atomic_prot(struct page *page, pgprot_t prot)
 {
 	preempt_disable();
 	pagefault_disable();
 	if (!PageHighMem(page))
 		return page_address(page);
-	return kmap_atomic_high(page);
+	return kmap_atomic_high_prot(page, prot);
 }
+#define kmap_atomic(page)	kmap_atomic_prot(page, kmap_prot)
 
 /* declarations for linux/mm/highmem.c */
 unsigned int nr_free_highpages(void);
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
