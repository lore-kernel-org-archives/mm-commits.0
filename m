From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 035/127] arch/kmap: define kmap_atomic_prot() for
 all arch's
Date: Thu, 04 Jun 2020 16:47:58 -0700
Message-ID: <20200604234758.KL6cDLTzV%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXsB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:48:01 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, bp@alien8.de, chris@zankel.net, christian.koenig@amd.com, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net, deller@gmx.de, hch@lst.de, hpa@zytor.com, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, linux-mm@kvack.org, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, torvalds@linux-foundation.org, tsbogend@alpha.franken.de, viro@zeniv.linux.org.uk

=46rom: Ira Weiny <ira.weiny@intel.com>
Subject: arch/kmap: define kmap_atomic_prot() for all arch's

To support kmap_atomic_prot(), all architectures need to support
protections passed to their kmap_atomic_high() function.  Pass protections
into kmap_atomic_high() and change the name to kmap_atomic_high_prot() to
match.

Then define kmap_atomic_prot() as a core function which calls
kmap_atomic_high_prot() when needed.

Finally, redefine kmap_atomic() as a wrapper of kmap_atomic_prot() with
the default kmap_prot exported by the architectures.

Link: http://lkml.kernel.org/r/20200507150004.1423069-11-ira.weiny@intel.com
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

 arch/arc/mm/highmem.c                 |    6 +++---
 arch/arm/mm/highmem.c                 |    6 +++---
 arch/csky/mm/highmem.c                |    6 +++---
 arch/microblaze/include/asm/highmem.h |   16 ----------------
 arch/mips/mm/highmem.c                |    6 +++---
 arch/nds32/mm/highmem.c               |    6 +++---
 arch/powerpc/include/asm/highmem.h    |   17 -----------------
 arch/sparc/mm/highmem.c               |    6 +++---
 arch/x86/include/asm/highmem.h        |   14 --------------
 arch/xtensa/mm/highmem.c              |    6 +++---
 include/linux/highmem.h               |    7 ++++---
 11 files changed, 25 insertions(+), 71 deletions(-)

--- a/arch/arc/mm/highmem.c~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/arc/mm/highmem.c
@@ -49,7 +49,7 @@
 extern pte_t * pkmap_page_table;
 static pte_t * fixmap_page_table;
=20
-void *kmap_atomic_high(struct page *page)
+void *kmap_atomic_high_prot(struct page *page, pgprot_t prot)
 {
 	int idx, cpu_idx;
 	unsigned long vaddr;
@@ -59,11 +59,11 @@ void *kmap_atomic_high(struct page *page
 	vaddr =3D FIXMAP_ADDR(idx);
=20
 	set_pte_at(&init_mm, vaddr, fixmap_page_table + idx,
-		   mk_pte(page, kmap_prot));
+		   mk_pte(page, prot));
=20
 	return (void *)vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic_high);
+EXPORT_SYMBOL(kmap_atomic_high_prot);
=20
 void kunmap_atomic_high(void *kv)
 {
--- a/arch/arm/mm/highmem.c~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/arm/mm/highmem.c
@@ -31,7 +31,7 @@ static inline pte_t get_fixmap_pte(unsig
 	return *ptep;
 }
=20
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
=20
 	return (void *)vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic_high);
+EXPORT_SYMBOL(kmap_atomic_high_prot);
=20
 void kunmap_atomic_high(void *kvaddr)
 {
--- a/arch/csky/mm/highmem.c~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/csky/mm/highmem.c
@@ -21,7 +21,7 @@ EXPORT_SYMBOL(kmap_flush_tlb);
=20
 EXPORT_SYMBOL(kmap);
=20
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
=20
 	return (void *)vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic_high);
+EXPORT_SYMBOL(kmap_atomic_high_prot);
=20
 void kunmap_atomic_high(void *kvaddr)
 {
--- a/arch/microblaze/include/asm/highmem.h~arch-kmap-define-kmap_atomic_pr=
ot-for-all-archs
+++ a/arch/microblaze/include/asm/highmem.h
@@ -51,22 +51,6 @@ extern pte_t *pkmap_page_table;
 #define PKMAP_NR(virt)  ((virt - PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
=20
-extern void *kmap_atomic_high_prot(struct page *page, pgprot_t prot);
-static inline void *kmap_atomic_prot(struct page *page, pgprot_t prot)
-{
-	preempt_disable();
-	pagefault_disable();
-	if (!PageHighMem(page))
-		return page_address(page);
-
-	return kmap_atomic_high_prot(page, prot);
-}
-
-static inline void *kmap_atomic_high(struct page *page)
-{
-	return kmap_atomic_high_prot(page, kmap_prot);
-}
-
 #define flush_cache_kmaps()	{ flush_icache(); flush_dcache(); }
=20
 #endif /* __KERNEL__ */
--- a/arch/mips/mm/highmem.c~arch-kmap-define-kmap_atomic_prot-for-all-archs
+++ a/arch/mips/mm/highmem.c
@@ -18,7 +18,7 @@ void kmap_flush_tlb(unsigned long addr)
 }
 EXPORT_SYMBOL(kmap_flush_tlb);
=20
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
=20
 	return (void*) vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic_high);
+EXPORT_SYMBOL(kmap_atomic_high_prot);
=20
 void kunmap_atomic_high(void *kvaddr)
 {
--- a/arch/nds32/mm/highmem.c~arch-kmap-define-kmap_atomic_prot-for-all-arc=
hs
+++ a/arch/nds32/mm/highmem.c
@@ -10,7 +10,7 @@
 #include <asm/fixmap.h>
 #include <asm/tlbflush.h>
=20
-void *kmap_atomic_high(struct page *page)
+void *kmap_atomic_high_prot(struct page *page, pgprot_t prot)
 {
 	unsigned int idx;
 	unsigned long vaddr, pte;
@@ -21,7 +21,7 @@ void *kmap_atomic_high(struct page *page
=20
 	idx =3D type + KM_TYPE_NR * smp_processor_id();
 	vaddr =3D __fix_to_virt(FIX_KMAP_BEGIN + idx);
-	pte =3D (page_to_pfn(page) << PAGE_SHIFT) | (kmap_prot);
+	pte =3D (page_to_pfn(page) << PAGE_SHIFT) | prot;
 	ptep =3D pte_offset_kernel(pmd_off_k(vaddr), vaddr);
 	set_pte(ptep, pte);
=20
@@ -31,7 +31,7 @@ void *kmap_atomic_high(struct page *page
 	__nds32__isb();
 	return (void *)vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic_high);
+EXPORT_SYMBOL(kmap_atomic_high_prot);
=20
 void kunmap_atomic_high(void *kvaddr)
 {
--- a/arch/powerpc/include/asm/highmem.h~arch-kmap-define-kmap_atomic_prot-=
for-all-archs
+++ a/arch/powerpc/include/asm/highmem.h
@@ -59,23 +59,6 @@ extern pte_t *pkmap_page_table;
 #define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
=20
-extern void *kmap_atomic_high_prot(struct page *page, pgprot_t prot);
-static inline void *kmap_atomic_prot(struct page *page, pgprot_t prot)
-{
-	preempt_disable();
-	pagefault_disable();
-	if (!PageHighMem(page))
-		return page_address(page);
-
-	return kmap_atomic_high_prot(page, prot);
-}
-
-static inline void *kmap_atomic_high(struct page *page)
-{
-	return kmap_atomic_high_prot(page, kmap_prot);
-}
-
-
 #define flush_cache_kmaps()	flush_cache_all()
=20
 #endif /* __KERNEL__ */
--- a/arch/sparc/mm/highmem.c~arch-kmap-define-kmap_atomic_prot-for-all-arc=
hs
+++ a/arch/sparc/mm/highmem.c
@@ -54,7 +54,7 @@ void __init kmap_init(void)
         kmap_prot =3D __pgprot(SRMMU_ET_PTE | SRMMU_PRIV | SRMMU_CACHE);
 }
=20
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
=20
 	return (void*) vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic_high);
+EXPORT_SYMBOL(kmap_atomic_high_prot);
=20
 void kunmap_atomic_high(void *kvaddr)
 {
--- a/arch/x86/include/asm/highmem.h~arch-kmap-define-kmap_atomic_prot-for-=
all-archs
+++ a/arch/x86/include/asm/highmem.h
@@ -58,20 +58,6 @@ extern unsigned long highstart_pfn, high
 #define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
=20
-extern void *kmap_atomic_high_prot(struct page *page, pgprot_t prot);
-static inline void *kmap_atomic_prot(struct page *page, pgprot_t prot)
-{
-	preempt_disable();
-	pagefault_disable();
-	if (!PageHighMem(page))
-		return page_address(page);
-
-	return kmap_atomic_high_prot(page, prot);
-}
-static inline void *kmap_atomic_high(struct page *page)
-{
-	return kmap_atomic_high_prot(page, kmap_prot);
-}
 void *kmap_atomic_pfn(unsigned long pfn);
 void *kmap_atomic_prot_pfn(unsigned long pfn, pgprot_t prot);
=20
--- a/arch/xtensa/mm/highmem.c~arch-kmap-define-kmap_atomic_prot-for-all-ar=
chs
+++ a/arch/xtensa/mm/highmem.c
@@ -37,7 +37,7 @@ static inline enum fixed_addresses kmap_
 		color;
 }
=20
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
=20
 	return (void *)vaddr;
 }
-EXPORT_SYMBOL(kmap_atomic_high);
+EXPORT_SYMBOL(kmap_atomic_high_prot);
=20
 void kunmap_atomic_high(void *kvaddr)
 {
--- a/include/linux/highmem.h~arch-kmap-define-kmap_atomic_prot-for-all-arc=
hs
+++ a/include/linux/highmem.h
@@ -32,7 +32,7 @@ static inline void invalidate_kernel_vma
 #include <asm/kmap_types.h>
=20
 #ifdef CONFIG_HIGHMEM
-extern void *kmap_atomic_high(struct page *page);
+extern void *kmap_atomic_high_prot(struct page *page, pgprot_t prot);
 extern void kunmap_atomic_high(void *kvaddr);
 #include <asm/highmem.h>
=20
@@ -77,14 +77,15 @@ static inline void kunmap(struct page *p
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
=20
 /* declarations for linux/mm/highmem.c */
 unsigned int nr_free_highpages(void);
_
