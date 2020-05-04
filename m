From: akpm@linux-foundation.org
Subject: +
 arch-kunmap-remove-duplicate-kunmap-implementations.patch added to -mm tree
Date: Mon, 04 May 2020 15:09:08 -0700
Message-ID: <20200504220908.-QdZYH8Y0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726433AbgEDWJK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 May 2020 18:09:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bp@alien8.de, chris@zankel.net, christian.koenig@amd.com, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net, deller@gmx.de, hch@lst.de, hpa@zytor.com, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@samba.org, peterz@infradead.org, ray.huang@amd.com, tglx@linutronix.de, tsbogend@alpha.franken.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: arch/kunmap: remove duplicate kunmap implementations
has been added to the -mm tree.  Its filename is
     arch-kunmap-remove-duplicate-kunmap-implementations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-kunmap-remove-duplicate-kunmap-implementations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-kunmap-remove-duplicate-kunmap-implementations.patch

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
Subject: arch/kunmap: remove duplicate kunmap implementations

All architectures do exactly the same thing for kunmap(); remove all the
duplicate definitions and lift the call to the core.

This also has the benefit of changing kmap_unmap() on a number of
architectures to be an inline call rather than an actual function.

Link: http://lkml.kernel.org/r/20200504010912.982044-5-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
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
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/highmem.h        |   10 ----------
 arch/arm/include/asm/highmem.h        |    3 ---
 arch/arm/mm/highmem.c                 |    9 ---------
 arch/csky/include/asm/highmem.h       |    3 ---
 arch/csky/mm/highmem.c                |    9 ---------
 arch/microblaze/include/asm/highmem.h |    9 ---------
 arch/mips/include/asm/highmem.h       |    3 ---
 arch/mips/mm/highmem.c                |    9 ---------
 arch/nds32/include/asm/highmem.h      |    3 ---
 arch/nds32/mm/highmem.c               |   10 ----------
 arch/powerpc/include/asm/highmem.h    |    9 ---------
 arch/sparc/include/asm/highmem.h      |   10 ----------
 arch/x86/include/asm/highmem.h        |    4 ----
 arch/x86/mm/highmem_32.c              |    9 ---------
 arch/xtensa/include/asm/highmem.h     |   10 ----------
 include/linux/highmem.h               |    9 +++++++++
 16 files changed, 9 insertions(+), 110 deletions(-)

--- a/arch/arc/include/asm/highmem.h~arch-kunmap-remove-duplicate-kunmap-implementations
+++ a/arch/arc/include/asm/highmem.h
@@ -32,7 +32,6 @@
 
 extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
-extern void kunmap_high(struct page *page);
 
 extern void kmap_init(void);
 
@@ -41,15 +40,6 @@ static inline void flush_cache_kmaps(voi
 	flush_cache_all();
 }
 
-static inline void kunmap(struct page *page)
-{
-	might_sleep();
-	if (!PageHighMem(page))
-		return;
-	kunmap_high(page);
-}
-
-
 #endif
 
 #endif
--- a/arch/arm/include/asm/highmem.h~arch-kunmap-remove-duplicate-kunmap-implementations
+++ a/arch/arm/include/asm/highmem.h
@@ -20,8 +20,6 @@
 
 extern pte_t *pkmap_page_table;
 
-extern void kunmap_high(struct page *page);
-
 /*
  * The reason for kmap_high_get() is to ensure that the currently kmap'd
  * page usage count does not decrease to zero while we're using its
@@ -62,7 +60,6 @@ static inline void *kmap_high_get(struct
  * when CONFIG_HIGHMEM is not set.
  */
 #ifdef CONFIG_HIGHMEM
-extern void kunmap(struct page *page);
 extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
--- a/arch/arm/mm/highmem.c~arch-kunmap-remove-duplicate-kunmap-implementations
+++ a/arch/arm/mm/highmem.c
@@ -31,15 +31,6 @@ static inline pte_t get_fixmap_pte(unsig
 	return *ptep;
 }
 
-void kunmap(struct page *page)
-{
-	might_sleep();
-	if (!PageHighMem(page))
-		return;
-	kunmap_high(page);
-}
-EXPORT_SYMBOL(kunmap);
-
 void *kmap_atomic(struct page *page)
 {
 	unsigned int idx;
--- a/arch/csky/include/asm/highmem.h~arch-kunmap-remove-duplicate-kunmap-implementations
+++ a/arch/csky/include/asm/highmem.h
@@ -30,11 +30,8 @@ extern pte_t *pkmap_page_table;
 #define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
 
-extern void kunmap_high(struct page *page);
-
 #define ARCH_HAS_KMAP_FLUSH_TLB
 extern void kmap_flush_tlb(unsigned long addr);
-extern void kunmap(struct page *page);
 extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
--- a/arch/csky/mm/highmem.c~arch-kunmap-remove-duplicate-kunmap-implementations
+++ a/arch/csky/mm/highmem.c
@@ -21,15 +21,6 @@ EXPORT_SYMBOL(kmap_flush_tlb);
 
 EXPORT_SYMBOL(kmap);
 
-void kunmap(struct page *page)
-{
-	might_sleep();
-	if (!PageHighMem(page))
-		return;
-	kunmap_high(page);
-}
-EXPORT_SYMBOL(kunmap);
-
 void *kmap_atomic(struct page *page)
 {
 	unsigned long vaddr;
--- a/arch/microblaze/include/asm/highmem.h~arch-kunmap-remove-duplicate-kunmap-implementations
+++ a/arch/microblaze/include/asm/highmem.h
@@ -51,18 +51,9 @@ extern pte_t *pkmap_page_table;
 #define PKMAP_NR(virt)  ((virt - PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
 
-extern void kunmap_high(struct page *page);
 extern void *kmap_atomic_prot(struct page *page, pgprot_t prot);
 extern void __kunmap_atomic(void *kvaddr);
 
-static inline void kunmap(struct page *page)
-{
-	might_sleep();
-	if (!PageHighMem(page))
-		return;
-	kunmap_high(page);
-}
-
 static inline void *kmap_atomic(struct page *page)
 {
 	return kmap_atomic_prot(page, kmap_prot);
--- a/arch/mips/include/asm/highmem.h~arch-kunmap-remove-duplicate-kunmap-implementations
+++ a/arch/mips/include/asm/highmem.h
@@ -46,11 +46,8 @@ extern pte_t *pkmap_page_table;
 #define PKMAP_NR(virt)	((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)	(PKMAP_BASE + ((nr) << PAGE_SHIFT))
 
-extern void kunmap_high(struct page *page);
-
 #define ARCH_HAS_KMAP_FLUSH_TLB
 extern void kmap_flush_tlb(unsigned long addr);
-extern void kunmap(struct page *page);
 extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
--- a/arch/mips/mm/highmem.c~arch-kunmap-remove-duplicate-kunmap-implementations
+++ a/arch/mips/mm/highmem.c
@@ -18,15 +18,6 @@ void kmap_flush_tlb(unsigned long addr)
 }
 EXPORT_SYMBOL(kmap_flush_tlb);
 
-void kunmap(struct page *page)
-{
-	might_sleep();
-	if (!PageHighMem(page))
-		return;
-	kunmap_high(page);
-}
-EXPORT_SYMBOL(kunmap);
-
 /*
  * kmap_atomic/kunmap_atomic is significantly faster than kmap/kunmap because
  * no global lock is needed and because the kmap code must perform a global TLB
--- a/arch/nds32/include/asm/highmem.h~arch-kunmap-remove-duplicate-kunmap-implementations
+++ a/arch/nds32/include/asm/highmem.h
@@ -44,8 +44,6 @@ extern unsigned long highstart_pfn, high
 
 extern pte_t *pkmap_page_table;
 
-extern void kunmap_high(struct page *page);
-
 extern void kmap_init(void);
 
 /*
@@ -53,7 +51,6 @@ extern void kmap_init(void);
  * when CONFIG_HIGHMEM is not set.
  */
 #ifdef CONFIG_HIGHMEM
-extern void kunmap(struct page *page);
 extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
--- a/arch/nds32/mm/highmem.c~arch-kunmap-remove-duplicate-kunmap-implementations
+++ a/arch/nds32/mm/highmem.c
@@ -10,16 +10,6 @@
 #include <asm/fixmap.h>
 #include <asm/tlbflush.h>
 
-void kunmap(struct page *page)
-{
-	might_sleep();
-	if (!PageHighMem(page))
-		return;
-	kunmap_high(page);
-}
-
-EXPORT_SYMBOL(kunmap);
-
 void *kmap_atomic(struct page *page)
 {
 	unsigned int idx;
--- a/arch/powerpc/include/asm/highmem.h~arch-kunmap-remove-duplicate-kunmap-implementations
+++ a/arch/powerpc/include/asm/highmem.h
@@ -59,18 +59,9 @@ extern pte_t *pkmap_page_table;
 #define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
 
-extern void kunmap_high(struct page *page);
 extern void *kmap_atomic_prot(struct page *page, pgprot_t prot);
 extern void __kunmap_atomic(void *kvaddr);
 
-static inline void kunmap(struct page *page)
-{
-	might_sleep();
-	if (!PageHighMem(page))
-		return;
-	kunmap_high(page);
-}
-
 static inline void *kmap_atomic(struct page *page)
 {
 	return kmap_atomic_prot(page, kmap_prot);
--- a/arch/sparc/include/asm/highmem.h~arch-kunmap-remove-duplicate-kunmap-implementations
+++ a/arch/sparc/include/asm/highmem.h
@@ -50,16 +50,6 @@ void kmap_init(void) __init;
 
 #define PKMAP_END (PKMAP_ADDR(LAST_PKMAP))
 
-void kunmap_high(struct page *page);
-
-static inline void kunmap(struct page *page)
-{
-	might_sleep();
-	if (!PageHighMem(page))
-		return;
-	kunmap_high(page);
-}
-
 void *kmap_atomic(struct page *page);
 void __kunmap_atomic(void *kvaddr);
 
--- a/arch/x86/include/asm/highmem.h~arch-kunmap-remove-duplicate-kunmap-implementations
+++ a/arch/x86/include/asm/highmem.h
@@ -58,10 +58,6 @@ extern unsigned long highstart_pfn, high
 #define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
 
-extern void kunmap_high(struct page *page);
-
-void kunmap(struct page *page);
-
 void *kmap_atomic_prot(struct page *page, pgprot_t prot);
 void *kmap_atomic(struct page *page);
 void __kunmap_atomic(void *kvaddr);
--- a/arch/x86/mm/highmem_32.c~arch-kunmap-remove-duplicate-kunmap-implementations
+++ a/arch/x86/mm/highmem_32.c
@@ -4,15 +4,6 @@
 #include <linux/swap.h> /* for totalram_pages */
 #include <linux/memblock.h>
 
-void kunmap(struct page *page)
-{
-	might_sleep();
-	if (!PageHighMem(page))
-		return;
-	kunmap_high(page);
-}
-EXPORT_SYMBOL(kunmap);
-
 /*
  * kmap_atomic/kunmap_atomic is significantly faster than kmap/kunmap because
  * no global lock is needed and because the kmap code must perform a global TLB
--- a/arch/xtensa/include/asm/highmem.h~arch-kunmap-remove-duplicate-kunmap-implementations
+++ a/arch/xtensa/include/asm/highmem.h
@@ -63,16 +63,6 @@ static inline wait_queue_head_t *get_pkm
 
 extern pte_t *pkmap_page_table;
 
-void kunmap_high(struct page *page);
-
-static inline void kunmap(struct page *page)
-{
-	might_sleep();
-	if (!PageHighMem(page))
-		return;
-	kunmap_high(page);
-}
-
 static inline void flush_cache_kmaps(void)
 {
 	flush_cache_all();
--- a/include/linux/highmem.h~arch-kunmap-remove-duplicate-kunmap-implementations
+++ a/include/linux/highmem.h
@@ -52,6 +52,15 @@ static inline void *kmap(struct page *pa
 	return addr;
 }
 
+void kunmap_high(struct page *page);
+static inline void kunmap(struct page *page)
+{
+	might_sleep();
+	if (!PageHighMem(page))
+		return;
+	kunmap_high(page);
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
x86powerpcmicroblaze-kmap-move-preempt-disable.patch
arch-kmap_atomic-consolidate-duplicate-code.patch
arch-kunmap_atomic-consolidate-duplicate-code.patch
arch-kmap-ensure-kmap_prot-visibility.patch
arch-kmap-dont-hard-code-kmap_prot-values.patch
arch-kmap-define-kmap_atomic_prot-for-all-archs.patch
drm-remove-drm-specific-kmap_atomic-code.patch
kmap-remove-kmap_atomic_to_page.patch
parisc-kmap-remove-duplicate-kmap-code.patch
