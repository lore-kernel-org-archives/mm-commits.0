From: akpm@linux-foundation.org
Subject: + arch-kunmap_atomic-consolidate-duplicate-code.patch
 added to -mm tree
Date: Thu, 07 May 2020 13:36:39 -0700
Message-ID: <20200507203639.ONoaHw1ot%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726542AbgEGUgl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 16:36:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bp@alien8.de, chris@zankel.net, christian.koenig@amd.com, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net, deller@gmx.de, hch@lst.de, hpa@zytor.com, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, tsbogend@alpha.franken.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: arch/kunmap_atomic: consolidate duplicate code
has been added to the -mm tree.  Its filename is
     arch-kunmap_atomic-consolidate-duplicate-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-kunmap_atomic-consolidate=
-duplicate-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-kunmap_atomic-consolidate=
-duplicate-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Ira Weiny <ira.weiny@intel.com>
Subject: arch/kunmap_atomic: consolidate duplicate code

Every single architecture (including !CONFIG_HIGHMEM) calls...

	pagefault_enable();
	preempt_enable();

... before returning from __kunmap_atomic().  Lift this code into the
kunmap_atomic() macro.

While we are at it rename __kunmap_atomic() to kunmap_atomic_high() to
be consistent.

Link: http://lkml.kernel.org/r/20200507150004.1423069-8-ira.weiny@intel.com
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

 arch/arc/include/asm/highmem.h        |    2 --
 arch/arc/mm/highmem.c                 |    7 ++-----
 arch/arm/include/asm/highmem.h        |    1 -
 arch/arm/mm/highmem.c                 |    6 ++----
 arch/csky/include/asm/highmem.h       |    1 -
 arch/csky/mm/highmem.c                |    9 +++------
 arch/microblaze/include/asm/highmem.h |    1 -
 arch/microblaze/mm/highmem.c          |    6 ++----
 arch/mips/include/asm/highmem.h       |    1 -
 arch/mips/mm/cache.c                  |    4 ++--
 arch/mips/mm/highmem.c                |    6 ++----
 arch/nds32/include/asm/highmem.h      |    1 -
 arch/nds32/mm/highmem.c               |    6 ++----
 arch/parisc/include/asm/cacheflush.h  |    4 +---
 arch/powerpc/include/asm/highmem.h    |    1 -
 arch/powerpc/mm/highmem.c             |    6 ++----
 arch/sparc/include/asm/highmem.h      |    2 --
 arch/sparc/mm/highmem.c               |    6 ++----
 arch/x86/include/asm/highmem.h        |    1 -
 arch/x86/mm/highmem_32.c              |    7 ++-----
 arch/xtensa/include/asm/highmem.h     |    2 --
 arch/xtensa/mm/highmem.c              |    7 ++-----
 include/linux/highmem.h               |   11 +++++++----
 23 files changed, 31 insertions(+), 67 deletions(-)

--- a/arch/arc/include/asm/highmem.h~arch-kunmap_atomic-consolidate-duplica=
te-code
+++ a/arch/arc/include/asm/highmem.h
@@ -30,8 +30,6 @@
=20
 #include <asm/cacheflush.h>
=20
-extern void __kunmap_atomic(void *kvaddr);
-
 extern void kmap_init(void);
=20
 static inline void flush_cache_kmaps(void)
--- a/arch/arc/mm/highmem.c~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/arc/mm/highmem.c
@@ -65,7 +65,7 @@ void *kmap_atomic_high(struct page *page
 }
 EXPORT_SYMBOL(kmap_atomic_high);
=20
-void __kunmap_atomic(void *kv)
+void kunmap_atomic_high(void *kv)
 {
 	unsigned long kvaddr =3D (unsigned long)kv;
=20
@@ -87,11 +87,8 @@ void __kunmap_atomic(void *kv)
=20
 		kmap_atomic_idx_pop();
 	}
-
-	pagefault_enable();
-	preempt_enable();
 }
-EXPORT_SYMBOL(__kunmap_atomic);
+EXPORT_SYMBOL(kunmap_atomic_high);
=20
 static noinline pte_t * __init alloc_kmap_pgtable(unsigned long kvaddr)
 {
--- a/arch/arm/include/asm/highmem.h~arch-kunmap_atomic-consolidate-duplica=
te-code
+++ a/arch/arm/include/asm/highmem.h
@@ -60,7 +60,6 @@ static inline void *kmap_high_get(struct
  * when CONFIG_HIGHMEM is not set.
  */
 #ifdef CONFIG_HIGHMEM
-extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
 #endif
=20
--- a/arch/arm/mm/highmem.c~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/arm/mm/highmem.c
@@ -73,7 +73,7 @@ void *kmap_atomic_high(struct page *page
 }
 EXPORT_SYMBOL(kmap_atomic_high);
=20
-void __kunmap_atomic(void *kvaddr)
+void kunmap_atomic_high(void *kvaddr)
 {
 	unsigned long vaddr =3D (unsigned long) kvaddr & PAGE_MASK;
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
=20
 void *kmap_atomic_pfn(unsigned long pfn)
 {
--- a/arch/csky/include/asm/highmem.h~arch-kunmap_atomic-consolidate-duplic=
ate-code
+++ a/arch/csky/include/asm/highmem.h
@@ -32,7 +32,6 @@ extern pte_t *pkmap_page_table;
=20
 #define ARCH_HAS_KMAP_FLUSH_TLB
 extern void kmap_flush_tlb(unsigned long addr);
-extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
 extern struct page *kmap_atomic_to_page(void *ptr);
=20
--- a/arch/csky/mm/highmem.c~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/csky/mm/highmem.c
@@ -39,13 +39,13 @@ void *kmap_atomic_high(struct page *page
 }
 EXPORT_SYMBOL(kmap_atomic_high);
=20
-void __kunmap_atomic(void *kvaddr)
+void kunmap_atomic_high(void *kvaddr)
 {
 	unsigned long vaddr =3D (unsigned long) kvaddr & PAGE_MASK;
 	int idx;
=20
 	if (vaddr < FIXADDR_START)
-		goto out;
+		return;
=20
 #ifdef CONFIG_DEBUG_HIGHMEM
 	idx =3D KM_TYPE_NR*smp_processor_id() + kmap_atomic_idx();
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
=20
 /*
  * This is the same as kmap_atomic() but can map memory that doesn't
--- a/arch/microblaze/include/asm/highmem.h~arch-kunmap_atomic-consolidate-=
duplicate-code
+++ a/arch/microblaze/include/asm/highmem.h
@@ -61,7 +61,6 @@ static inline void *kmap_atomic_prot(str
=20
 	return kmap_atomic_high_prot(page, prot);
 }
-extern void __kunmap_atomic(void *kvaddr);
=20
 static inline void *kmap_atomic_high(struct page *page)
 {
--- a/arch/microblaze/mm/highmem.c~arch-kunmap_atomic-consolidate-duplicate=
-code
+++ a/arch/microblaze/mm/highmem.c
@@ -51,7 +51,7 @@ void *kmap_atomic_high_prot(struct page
 }
 EXPORT_SYMBOL(kmap_atomic_high_prot);
=20
-void __kunmap_atomic(void *kvaddr)
+void kunmap_atomic_high(void *kvaddr)
 {
 	unsigned long vaddr =3D (unsigned long) kvaddr & PAGE_MASK;
 	int type;
@@ -77,7 +77,5 @@ void __kunmap_atomic(void *kvaddr)
 	local_flush_tlb_page(NULL, vaddr);
=20
 	kmap_atomic_idx_pop();
-	pagefault_enable();
-	preempt_enable();
 }
-EXPORT_SYMBOL(__kunmap_atomic);
+EXPORT_SYMBOL(kunmap_atomic_high);
--- a/arch/mips/include/asm/highmem.h~arch-kunmap_atomic-consolidate-duplic=
ate-code
+++ a/arch/mips/include/asm/highmem.h
@@ -48,7 +48,6 @@ extern pte_t *pkmap_page_table;
=20
 #define ARCH_HAS_KMAP_FLUSH_TLB
 extern void kmap_flush_tlb(unsigned long addr);
-extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
=20
 #define flush_cache_kmaps()	BUG_ON(cpu_has_dc_aliases)
--- a/arch/mips/mm/cache.c~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/mips/mm/cache.c
@@ -104,7 +104,7 @@ void __flush_dcache_page(struct page *pa
 	flush_data_cache_page(addr);
=20
 	if (PageHighMem(page))
-		__kunmap_atomic((void *)addr);
+		kunmap_atomic((void *)addr);
 }
=20
 EXPORT_SYMBOL(__flush_dcache_page);
@@ -147,7 +147,7 @@ void __update_cache(unsigned long addres
 			flush_data_cache_page(addr);
=20
 		if (PageHighMem(page))
-			__kunmap_atomic((void *)addr);
+			kunmap_atomic((void *)addr);
=20
 		ClearPageDcacheDirty(page);
 	}
--- a/arch/mips/mm/highmem.c~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/mips/mm/highmem.c
@@ -36,7 +36,7 @@ void *kmap_atomic_high(struct page *page
 }
 EXPORT_SYMBOL(kmap_atomic_high);
=20
-void __kunmap_atomic(void *kvaddr)
+void kunmap_atomic_high(void *kvaddr)
 {
 	unsigned long vaddr =3D (unsigned long) kvaddr & PAGE_MASK;
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
=20
 /*
  * This is the same as kmap_atomic() but can map memory that doesn't
--- a/arch/nds32/include/asm/highmem.h~arch-kunmap_atomic-consolidate-dupli=
cate-code
+++ a/arch/nds32/include/asm/highmem.h
@@ -51,7 +51,6 @@ extern void kmap_init(void);
  * when CONFIG_HIGHMEM is not set.
  */
 #ifdef CONFIG_HIGHMEM
-extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
 extern struct page *kmap_atomic_to_page(void *ptr);
 #endif
--- a/arch/nds32/mm/highmem.c~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/nds32/mm/highmem.c
@@ -34,7 +34,7 @@ void *kmap_atomic_high(struct page *page
=20
 EXPORT_SYMBOL(kmap_atomic_high);
=20
-void __kunmap_atomic(void *kvaddr)
+void kunmap_atomic_high(void *kvaddr)
 {
 	if (kvaddr >=3D (void *)FIXADDR_START) {
 		unsigned long vaddr =3D (unsigned long)kvaddr;
@@ -45,8 +45,6 @@ void __kunmap_atomic(void *kvaddr)
 		ptep =3D pte_offset_kernel(pmd_off_k(vaddr), vaddr);
 		set_pte(ptep, 0);
 	}
-	pagefault_enable();
-	preempt_enable();
 }
=20
-EXPORT_SYMBOL(__kunmap_atomic);
+EXPORT_SYMBOL(kunmap_atomic_high);
--- a/arch/parisc/include/asm/cacheflush.h~arch-kunmap_atomic-consolidate-d=
uplicate-code
+++ a/arch/parisc/include/asm/cacheflush.h
@@ -122,11 +122,9 @@ static inline void *kmap_atomic(struct p
 	return page_address(page);
 }
=20
-static inline void __kunmap_atomic(void *addr)
+static inline void kunmap_atomic_high(void *addr)
 {
 	flush_kernel_dcache_page_addr(addr);
-	pagefault_enable();
-	preempt_enable();
 }
=20
 #define kmap_atomic_prot(page, prot)	kmap_atomic(page)
--- a/arch/powerpc/include/asm/highmem.h~arch-kunmap_atomic-consolidate-dup=
licate-code
+++ a/arch/powerpc/include/asm/highmem.h
@@ -69,7 +69,6 @@ static inline void *kmap_atomic_prot(str
=20
 	return kmap_atomic_high_prot(page, prot);
 }
-extern void __kunmap_atomic(void *kvaddr);
=20
 static inline void *kmap_atomic_high(struct page *page)
 {
--- a/arch/powerpc/mm/highmem.c~arch-kunmap_atomic-consolidate-duplicate-co=
de
+++ a/arch/powerpc/mm/highmem.c
@@ -40,7 +40,7 @@ void *kmap_atomic_high_prot(struct page
 }
 EXPORT_SYMBOL(kmap_atomic_high_prot);
=20
-void __kunmap_atomic(void *kvaddr)
+void kunmap_atomic_high(void *kvaddr)
 {
 	unsigned long vaddr =3D (unsigned long) kvaddr & PAGE_MASK;
=20
@@ -66,7 +66,5 @@ void __kunmap_atomic(void *kvaddr)
 	}
=20
 	kmap_atomic_idx_pop();
-	pagefault_enable();
-	preempt_enable();
 }
-EXPORT_SYMBOL(__kunmap_atomic);
+EXPORT_SYMBOL(kunmap_atomic_high);
--- a/arch/sparc/include/asm/highmem.h~arch-kunmap_atomic-consolidate-dupli=
cate-code
+++ a/arch/sparc/include/asm/highmem.h
@@ -50,8 +50,6 @@ void kmap_init(void) __init;
=20
 #define PKMAP_END (PKMAP_ADDR(LAST_PKMAP))
=20
-void __kunmap_atomic(void *kvaddr);
-
 #define flush_cache_kmaps()	flush_cache_all()
=20
 #endif /* __KERNEL__ */
--- a/arch/sparc/mm/highmem.c~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/sparc/mm/highmem.c
@@ -84,7 +84,7 @@ void *kmap_atomic_high(struct page *page
 }
 EXPORT_SYMBOL(kmap_atomic_high);
=20
-void __kunmap_atomic(void *kvaddr)
+void kunmap_atomic_high(void *kvaddr)
 {
 	unsigned long vaddr =3D (unsigned long) kvaddr & PAGE_MASK;
 	int type;
@@ -126,7 +126,5 @@ void __kunmap_atomic(void *kvaddr)
 #endif
=20
 	kmap_atomic_idx_pop();
-	pagefault_enable();
-	preempt_enable();
 }
-EXPORT_SYMBOL(__kunmap_atomic);
+EXPORT_SYMBOL(kunmap_atomic_high);
--- a/arch/x86/include/asm/highmem.h~arch-kunmap_atomic-consolidate-duplica=
te-code
+++ a/arch/x86/include/asm/highmem.h
@@ -72,7 +72,6 @@ static inline void *kmap_atomic_high(str
 {
 	return kmap_atomic_high_prot(page, kmap_prot);
 }
-void __kunmap_atomic(void *kvaddr);
 void *kmap_atomic_pfn(unsigned long pfn);
 void *kmap_atomic_prot_pfn(unsigned long pfn, pgprot_t prot);
=20
--- a/arch/x86/mm/highmem_32.c~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/x86/mm/highmem_32.c
@@ -30,7 +30,7 @@ void *kmap_atomic_pfn(unsigned long pfn)
 }
 EXPORT_SYMBOL_GPL(kmap_atomic_pfn);
=20
-void __kunmap_atomic(void *kvaddr)
+void kunmap_atomic_high(void *kvaddr)
 {
 	unsigned long vaddr =3D (unsigned long) kvaddr & PAGE_MASK;
=20
@@ -60,11 +60,8 @@ void __kunmap_atomic(void *kvaddr)
 		BUG_ON(vaddr >=3D (unsigned long)high_memory);
 	}
 #endif
-
-	pagefault_enable();
-	preempt_enable();
 }
-EXPORT_SYMBOL(__kunmap_atomic);
+EXPORT_SYMBOL(kunmap_atomic_high);
=20
 void __init set_highmem_pages_init(void)
 {
--- a/arch/xtensa/include/asm/highmem.h~arch-kunmap_atomic-consolidate-dupl=
icate-code
+++ a/arch/xtensa/include/asm/highmem.h
@@ -68,8 +68,6 @@ static inline void flush_cache_kmaps(voi
 	flush_cache_all();
 }
=20
-void __kunmap_atomic(void *kvaddr);
-
 void kmap_init(void);
=20
 #endif
--- a/arch/xtensa/mm/highmem.c~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/arch/xtensa/mm/highmem.c
@@ -54,7 +54,7 @@ void *kmap_atomic_high(struct page *page
 }
 EXPORT_SYMBOL(kmap_atomic_high);
=20
-void __kunmap_atomic(void *kvaddr)
+void kunmap_atomic_high(void *kvaddr)
 {
 	if (kvaddr >=3D (void *)FIXADDR_START &&
 	    kvaddr < (void *)FIXADDR_TOP) {
@@ -73,11 +73,8 @@ void __kunmap_atomic(void *kvaddr)
=20
 		kmap_atomic_idx_pop();
 	}
-
-	pagefault_enable();
-	preempt_enable();
 }
-EXPORT_SYMBOL(__kunmap_atomic);
+EXPORT_SYMBOL(kunmap_atomic_high);
=20
 void __init kmap_init(void)
 {
--- a/include/linux/highmem.h~arch-kunmap_atomic-consolidate-duplicate-code
+++ a/include/linux/highmem.h
@@ -33,6 +33,7 @@ static inline void invalidate_kernel_vma
=20
 #ifdef CONFIG_HIGHMEM
 extern void *kmap_atomic_high(struct page *page);
+extern void kunmap_atomic_high(void *kvaddr);
 #include <asm/highmem.h>
=20
 #ifndef ARCH_HAS_KMAP_FLUSH_TLB
@@ -146,10 +147,10 @@ static inline void *kmap_atomic(struct p
 }
 #define kmap_atomic_prot(page, prot)	kmap_atomic(page)
=20
-static inline void __kunmap_atomic(void *addr)
+static inline void kunmap_atomic_high(void *addr)
 {
-	pagefault_enable();
-	preempt_enable();
+	/* Nothing to do in the CONFIG_HIGHMEM=3Dn case as kunmap_atomic()
+	 * handles re-enabling faults + preemption */
 }
=20
 #define kmap_atomic_pfn(pfn)	kmap_atomic(pfn_to_page(pfn))
@@ -199,7 +200,9 @@ static inline void kmap_atomic_idx_pop(v
 #define kunmap_atomic(addr)                                     \
 do {                                                            \
 	BUILD_BUG_ON(__same_type((addr), struct page *));       \
-	__kunmap_atomic(addr);                                  \
+	kunmap_atomic_high(addr);                                  \
+	pagefault_enable();                                     \
+	preempt_enable();                                       \
 } while (0)
=20
=20
_

Patches currently in -mm which might be from ira.weiny@intel.com are

arch-kmap-remove-bug_on.patch
arch-xtensa-move-kmap-build-bug-out-of-the-way.patch
arch-kmap-remove-redundant-arch-specific-kmaps.patch
arch-kunmap-remove-duplicate-kunmap-implementations.patch
x86powerpcmicroblaze-kmap-move-preempt-disable.patch
arch-kmap_atomic-consolidate-duplicate-code.patch
arch-kunmap_atomic-consolidate-duplicate-code.patch
arch-kmap-ensure-kmap_prot-visibility.patch
arch-kmap-dont-hard-code-kmap_prot-values.patch
arch-kmap-define-kmap_atomic_prot-for-all-archs.patch
drm-remove-drm-specific-kmap_atomic-code.patch
kmap-remove-kmap_atomic_to_page.patch
parisc-kmap-remove-duplicate-kmap-code.patch
sparc-remove-unnecessary-includes.patch
kmap-consolidate-kmap_prot-definitions.patch
