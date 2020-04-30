From: akpm@linux-foundation.org
Subject: + arch-kunmap_atomic-consolidate-duplicate-code.patch
 added to -mm tree
Date: Thu, 30 Apr 2020 14:21:02 -0700
Message-ID: <20200430212102.ydCmefQGo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgD3VVE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Apr 2020 17:21:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, benh@kernel.crashing.org, bp@alien8.de, chris@zankel.net, christian.koenig@amd.com, dan.j.williams@intel.com, daniel@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net, deller@gmx.de, hpa@zytor.com, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@samba.org, peterz@infradead.org, ray.huang@amd.com, tglx@linutronix.de, thellstrom@vmware.com, tsbogend@alpha.franken.de


The patch titled
     Subject: arch/kunmap_atomic: consolidate duplicate code
has been added to the -mm tree.  Its filename is
     arch-kunmap_atomic-consolidate-duplicate-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-kunmap_atomic-consolidate-duplicate-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-kunmap_atomic-consolidate-duplicate-code.patch

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
Subject: arch/kunmap_atomic: consolidate duplicate code

Every single architecture (including !CONFIG_HIGHMEM) calls...

	pagefault_enable();
	preempt_enable();

... before returning from __kunmap_atomic().  Lift this code into the
kunmap_atomic() macro.

While we are at it rename __kunmap_atomic() to kunmap_atomic_high() to
be consistent.

Link: http://lkml.kernel.org/r/20200430203845.582900-7-ira.weiny@intel.com
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
 arch/arc/mm/highmem.c                 |    7 ++-----
 arch/arm/include/asm/highmem.h        |    2 +-
 arch/arm/mm/highmem.c                 |    6 ++----
 arch/csky/include/asm/highmem.h       |    2 +-
 arch/csky/mm/highmem.c                |    9 +++------
 arch/microblaze/include/asm/highmem.h |    2 +-
 arch/microblaze/mm/highmem.c          |    6 ++----
 arch/mips/include/asm/highmem.h       |    2 +-
 arch/mips/mm/cache.c                  |    4 ++--
 arch/mips/mm/highmem.c                |    6 ++----
 arch/nds32/include/asm/highmem.h      |    2 +-
 arch/nds32/mm/highmem.c               |    6 ++----
 arch/parisc/include/asm/cacheflush.h  |    4 +---
 arch/powerpc/include/asm/highmem.h    |    2 +-
 arch/powerpc/mm/highmem.c             |    6 ++----
 arch/sparc/include/asm/highmem.h      |    2 +-
 arch/sparc/mm/highmem.c               |    6 ++----
 arch/x86/include/asm/highmem.h        |    2 +-
 arch/x86/mm/highmem_32.c              |    7 ++-----
 arch/xtensa/include/asm/highmem.h     |    2 +-
 arch/xtensa/mm/highmem.c              |    7 ++-----
 include/linux/highmem.h               |   10 ++++++----
 23 files changed, 40 insertions(+), 64 deletions(-)

--- a/arch/arc/include/asm/highmem.h~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/arc/include/asm/highmem.h
@@ -31,7 +31,7 @@
 #include <asm/cacheflush.h>
 
 extern void *kmap_atomic_high(struct page *page);
-extern void __kunmap_atomic(void *kvaddr);
+extern void kunmap_atomic_high(void *kvaddr);
 
 extern void kmap_init(void);
 
--- a/arch/arc/mm/highmem.c~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/arc/mm/highmem.c
@@ -65,7 +65,7 @@ void *kmap_atomic_high(struct page *page
 }
 EXPORT_SYMBOL(kmap_atomic_high);
 
-void __kunmap_atomic(void *kv)
+void kunmap_atomic_high(void *kv)
 {
 	unsigned long kvaddr = (unsigned long)kv;
 
@@ -87,11 +87,8 @@ void __kunmap_atomic(void *kv)
 
 		kmap_atomic_idx_pop();
 	}
-
-	pagefault_enable();
-	preempt_enable();
 }
-EXPORT_SYMBOL(__kunmap_atomic);
+EXPORT_SYMBOL(kunmap_atomic_high);
 
 static noinline pte_t * __init alloc_kmap_pgtable(unsigned long kvaddr)
 {
--- a/arch/arm/include/asm/highmem.h~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/arm/include/asm/highmem.h
@@ -61,7 +61,7 @@ static inline void *kmap_high_get(struct
  */
 #ifdef CONFIG_HIGHMEM
 extern void *kmap_atomic_high(struct page *page);
-extern void __kunmap_atomic(void *kvaddr);
+extern void kunmap_atomic_high(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
 #endif
 
--- a/arch/arm/mm/highmem.c~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/arm/mm/highmem.c
@@ -73,7 +73,7 @@ void *kmap_atomic_high(struct page *page
 }
 EXPORT_SYMBOL(kmap_atomic_high);
 
-void __kunmap_atomic(void *kvaddr)
+void kunmap_atomic_high(void *kvaddr)
 {
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
 	int idx, type;
@@ -95,10 +95,8 @@ void __kunmap_atomic(void *kvaddr)
 		/* this address was obtained through kmap_high_get() */
 		kunmap_high(pte_page(pkmap_page_table[PKMAP_NR(vaddr)]));
 	}
-	pagefault_enable();
-	preempt_enable();
 }
-EXPORT_SYMBOL(__kunmap_atomic);
+EXPORT_SYMBOL(kunmap_atomic_high);
 
 void *kmap_atomic_pfn(unsigned long pfn)
 {
--- a/arch/csky/include/asm/highmem.h~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/csky/include/asm/highmem.h
@@ -33,7 +33,7 @@ extern pte_t *pkmap_page_table;
 #define ARCH_HAS_KMAP_FLUSH_TLB
 extern void kmap_flush_tlb(unsigned long addr);
 extern void *kmap_atomic_high(struct page *page);
-extern void __kunmap_atomic(void *kvaddr);
+extern void kunmap_atomic_high(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
 extern struct page *kmap_atomic_to_page(void *ptr);
 
--- a/arch/csky/mm/highmem.c~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/csky/mm/highmem.c
@@ -39,13 +39,13 @@ void *kmap_atomic_high(struct page *page
 }
 EXPORT_SYMBOL(kmap_atomic_high);
 
-void __kunmap_atomic(void *kvaddr)
+void kunmap_atomic_high(void *kvaddr)
 {
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
 	int idx;
 
 	if (vaddr < FIXADDR_START)
-		goto out;
+		return;
 
 #ifdef CONFIG_DEBUG_HIGHMEM
 	idx = KM_TYPE_NR*smp_processor_id() + kmap_atomic_idx();
@@ -58,11 +58,8 @@ void __kunmap_atomic(void *kvaddr)
 	(void) idx; /* to kill a warning */
 #endif
 	kmap_atomic_idx_pop();
-out:
-	pagefault_enable();
-	preempt_enable();
 }
-EXPORT_SYMBOL(__kunmap_atomic);
+EXPORT_SYMBOL(kunmap_atomic_high);
 
 /*
  * This is the same as kmap_atomic() but can map memory that doesn't
--- a/arch/microblaze/include/asm/highmem.h~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/microblaze/include/asm/highmem.h
@@ -52,7 +52,7 @@ extern pte_t *pkmap_page_table;
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
 
 extern void *kmap_atomic_prot(struct page *page, pgprot_t prot);
-extern void __kunmap_atomic(void *kvaddr);
+extern void kunmap_atomic_high(void *kvaddr);
 
 static inline void *kmap_atomic_high(struct page *page)
 {
--- a/arch/microblaze/mm/highmem.c~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/microblaze/mm/highmem.c
@@ -51,7 +51,7 @@ void *kmap_atomic_prot(struct page *page
 }
 EXPORT_SYMBOL(kmap_atomic_prot);
 
-void __kunmap_atomic(void *kvaddr)
+void kunmap_atomic_high(void *kvaddr)
 {
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
 	int type;
@@ -77,7 +77,5 @@ void __kunmap_atomic(void *kvaddr)
 	local_flush_tlb_page(NULL, vaddr);
 
 	kmap_atomic_idx_pop();
-	pagefault_enable();
-	preempt_enable();
 }
-EXPORT_SYMBOL(__kunmap_atomic);
+EXPORT_SYMBOL(kunmap_atomic_high);
--- a/arch/mips/include/asm/highmem.h~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/mips/include/asm/highmem.h
@@ -49,7 +49,7 @@ extern pte_t *pkmap_page_table;
 #define ARCH_HAS_KMAP_FLUSH_TLB
 extern void kmap_flush_tlb(unsigned long addr);
 extern void *kmap_atomic_high(struct page *page);
-extern void __kunmap_atomic(void *kvaddr);
+extern void kunmap_atomic_high(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
 
 #define flush_cache_kmaps()	BUG_ON(cpu_has_dc_aliases)
--- a/arch/mips/mm/cache.c~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/mips/mm/cache.c
@@ -104,7 +104,7 @@ void __flush_dcache_page(struct page *pa
 	flush_data_cache_page(addr);
 
 	if (PageHighMem(page))
-		__kunmap_atomic((void *)addr);
+		kunmap_atomic((void *)addr);
 }
 
 EXPORT_SYMBOL(__flush_dcache_page);
@@ -147,7 +147,7 @@ void __update_cache(unsigned long addres
 			flush_data_cache_page(addr);
 
 		if (PageHighMem(page))
-			__kunmap_atomic((void *)addr);
+			kunmap_atomic((void *)addr);
 
 		ClearPageDcacheDirty(page);
 	}
--- a/arch/mips/mm/highmem.c~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/mips/mm/highmem.c
@@ -36,7 +36,7 @@ void *kmap_atomic_high(struct page *page
 }
 EXPORT_SYMBOL(kmap_atomic_high);
 
-void __kunmap_atomic(void *kvaddr)
+void kunmap_atomic_high(void *kvaddr)
 {
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
 	int type __maybe_unused;
@@ -63,10 +63,8 @@ void __kunmap_atomic(void *kvaddr)
 	}
 #endif
 	kmap_atomic_idx_pop();
-	pagefault_enable();
-	preempt_enable();
 }
-EXPORT_SYMBOL(__kunmap_atomic);
+EXPORT_SYMBOL(kunmap_atomic_high);
 
 /*
  * This is the same as kmap_atomic() but can map memory that doesn't
--- a/arch/nds32/include/asm/highmem.h~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/nds32/include/asm/highmem.h
@@ -52,7 +52,7 @@ extern void kmap_init(void);
  */
 #ifdef CONFIG_HIGHMEM
 extern void *kmap_atomic_high(struct page *page);
-extern void __kunmap_atomic(void *kvaddr);
+extern void kunmap_atomic_high(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
 extern struct page *kmap_atomic_to_page(void *ptr);
 #endif
--- a/arch/nds32/mm/highmem.c~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/nds32/mm/highmem.c
@@ -34,7 +34,7 @@ void *kmap_atomic_high(struct page *page
 
 EXPORT_SYMBOL(kmap_atomic_high);
 
-void __kunmap_atomic(void *kvaddr)
+void kunmap_atomic_high(void *kvaddr)
 {
 	if (kvaddr >= (void *)FIXADDR_START) {
 		unsigned long vaddr = (unsigned long)kvaddr;
@@ -45,8 +45,6 @@ void __kunmap_atomic(void *kvaddr)
 		ptep = pte_offset_kernel(pmd_off_k(vaddr), vaddr);
 		set_pte(ptep, 0);
 	}
-	pagefault_enable();
-	preempt_enable();
 }
 
-EXPORT_SYMBOL(__kunmap_atomic);
+EXPORT_SYMBOL(kunmap_atomic_high);
--- a/arch/parisc/include/asm/cacheflush.h~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/parisc/include/asm/cacheflush.h
@@ -122,11 +122,9 @@ static inline void *kmap_atomic(struct p
 	return page_address(page);
 }
 
-static inline void __kunmap_atomic(void *addr)
+static inline void kunmap_atomic_high(void *addr)
 {
 	flush_kernel_dcache_page_addr(addr);
-	pagefault_enable();
-	preempt_enable();
 }
 
 #define kmap_atomic_prot(page, prot)	kmap_atomic(page)
--- a/arch/powerpc/include/asm/highmem.h~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/powerpc/include/asm/highmem.h
@@ -60,7 +60,7 @@ extern pte_t *pkmap_page_table;
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
 
 extern void *kmap_atomic_prot(struct page *page, pgprot_t prot);
-extern void __kunmap_atomic(void *kvaddr);
+extern void kunmap_atomic_high(void *kvaddr);
 
 static inline void *kmap_atomic_high(struct page *page)
 {
--- a/arch/powerpc/mm/highmem.c~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/powerpc/mm/highmem.c
@@ -40,7 +40,7 @@ void *kmap_atomic_prot(struct page *page
 }
 EXPORT_SYMBOL(kmap_atomic_prot);
 
-void __kunmap_atomic(void *kvaddr)
+void kunmap_atomic_high(void *kvaddr)
 {
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
 
@@ -66,7 +66,5 @@ void __kunmap_atomic(void *kvaddr)
 	}
 
 	kmap_atomic_idx_pop();
-	pagefault_enable();
-	preempt_enable();
 }
-EXPORT_SYMBOL(__kunmap_atomic);
+EXPORT_SYMBOL(kunmap_atomic_high);
--- a/arch/sparc/include/asm/highmem.h~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/sparc/include/asm/highmem.h
@@ -51,7 +51,7 @@ void kmap_init(void) __init;
 #define PKMAP_END (PKMAP_ADDR(LAST_PKMAP))
 
 void *kmap_atomic_high(struct page *page);
-void __kunmap_atomic(void *kvaddr);
+void kunmap_atomic_high(void *kvaddr);
 
 #define flush_cache_kmaps()	flush_cache_all()
 
--- a/arch/sparc/mm/highmem.c~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/sparc/mm/highmem.c
@@ -84,7 +84,7 @@ void *kmap_atomic_high(struct page *page
 }
 EXPORT_SYMBOL(kmap_atomic_high);
 
-void __kunmap_atomic(void *kvaddr)
+void kunmap_atomic_high(void *kvaddr)
 {
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
 	int type;
@@ -126,7 +126,5 @@ void __kunmap_atomic(void *kvaddr)
 #endif
 
 	kmap_atomic_idx_pop();
-	pagefault_enable();
-	preempt_enable();
 }
-EXPORT_SYMBOL(__kunmap_atomic);
+EXPORT_SYMBOL(kunmap_atomic_high);
--- a/arch/x86/include/asm/highmem.h~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/x86/include/asm/highmem.h
@@ -63,7 +63,7 @@ void *kmap_atomic_high(struct page *page
 {
 	return kmap_atomic_prot(page, kmap_prot);
 }
-void __kunmap_atomic(void *kvaddr);
+void kunmap_atomic_high(void *kvaddr);
 void *kmap_atomic_pfn(unsigned long pfn);
 void *kmap_atomic_prot_pfn(unsigned long pfn, pgprot_t prot);
 
--- a/arch/x86/mm/highmem_32.c~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/x86/mm/highmem_32.c
@@ -30,7 +30,7 @@ void *kmap_atomic_pfn(unsigned long pfn)
 }
 EXPORT_SYMBOL_GPL(kmap_atomic_pfn);
 
-void __kunmap_atomic(void *kvaddr)
+void kunmap_atomic_high(void *kvaddr)
 {
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
 
@@ -60,11 +60,8 @@ void __kunmap_atomic(void *kvaddr)
 		BUG_ON(vaddr >= (unsigned long)high_memory);
 	}
 #endif
-
-	pagefault_enable();
-	preempt_enable();
 }
-EXPORT_SYMBOL(__kunmap_atomic);
+EXPORT_SYMBOL(kunmap_atomic_high);
 
 void __init set_highmem_pages_init(void)
 {
--- a/arch/xtensa/include/asm/highmem.h~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/xtensa/include/asm/highmem.h
@@ -69,7 +69,7 @@ static inline void flush_cache_kmaps(voi
 }
 
 void *kmap_atomic_high(struct page *page);
-void __kunmap_atomic(void *kvaddr);
+void kunmap_atomic_high(void *kvaddr);
 
 void kmap_init(void);
 
--- a/arch/xtensa/mm/highmem.c~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/xtensa/mm/highmem.c
@@ -54,7 +54,7 @@ void *kmap_atomic_high(struct page *page
 }
 EXPORT_SYMBOL(kmap_atomic_high);
 
-void __kunmap_atomic(void *kvaddr)
+void kunmap_atomic_high(void *kvaddr)
 {
 	if (kvaddr >= (void *)FIXADDR_START &&
 	    kvaddr < (void *)FIXADDR_TOP) {
@@ -73,11 +73,8 @@ void __kunmap_atomic(void *kvaddr)
 
 		kmap_atomic_idx_pop();
 	}
-
-	pagefault_enable();
-	preempt_enable();
 }
-EXPORT_SYMBOL(__kunmap_atomic);
+EXPORT_SYMBOL(kunmap_atomic_high);
 
 void __init kmap_init(void)
 {
--- a/include/linux/highmem.h~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/include/linux/highmem.h
@@ -145,10 +145,10 @@ static inline void *kmap_atomic(struct p
 }
 #define kmap_atomic_prot(page, prot)	kmap_atomic(page)
 
-static inline void __kunmap_atomic(void *addr)
+static inline void kunmap_atomic_high(void *addr)
 {
-	pagefault_enable();
-	preempt_enable();
+	/* Nothing to do in the CONFIG_HIGHMEM=n case as kunmap_atomic()
+	 * handles re-enabling faults + preemption */
 }
 
 #define kmap_atomic_pfn(pfn)	kmap_atomic(pfn_to_page(pfn))
@@ -198,7 +198,9 @@ static inline void kmap_atomic_idx_pop(v
 #define kunmap_atomic(addr)                                     \
 do {                                                            \
 	BUILD_BUG_ON(__same_type((addr), struct page *));       \
-	__kunmap_atomic(addr);                                  \
+	kunmap_atomic_high(addr);                                  \
+	pagefault_enable();                                     \
+	preempt_enable();                                       \
 } while (0)
 
 
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
