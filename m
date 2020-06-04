From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 028/127] arch/kmap: remove redundant arch specific
 kmaps
Date: Thu, 04 Jun 2020 16:47:30 -0700
Message-ID: <20200604234730.WbK1PGqGF%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXrd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:47:33 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, bp@alien8.de, chris@zankel.net, christian.koenig@amd.com, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net, deller@gmx.de, hch@lst.de, hpa@zytor.com, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, linux-mm@kvack.org, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, torvalds@linux-foundation.org, tsbogend@alpha.franken.de, viro@zeniv.linux.org.uk

=46rom: Ira Weiny <ira.weiny@intel.com>
Subject: arch/kmap: remove redundant arch specific kmaps

The kmap code for all the architectures is almost 100% identical.

Lift the common code to the core.  Use ARCH_HAS_KMAP_FLUSH_TLB to indicate
if an arch defines kmap_flush_tlb() and call if if needed.

This also has the benefit of changing kmap() on a number of architectures
to be an inline call rather than an actual function.

Link: http://lkml.kernel.org/r/20200507150004.1423069-4-ira.weiny@intel.com
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
 arch/arc/mm/highmem.c                 |   10 ----------
 arch/arm/include/asm/highmem.h        |    2 --
 arch/arm/mm/highmem.c                 |    9 ---------
 arch/csky/include/asm/highmem.h       |    4 ++--
 arch/csky/mm/highmem.c                |   14 ++++----------
 arch/microblaze/include/asm/highmem.h |    9 ---------
 arch/mips/include/asm/highmem.h       |    4 ++--
 arch/mips/mm/highmem.c                |   14 +++-----------
 arch/nds32/include/asm/highmem.h      |    2 --
 arch/nds32/mm/highmem.c               |   12 ------------
 arch/powerpc/include/asm/highmem.h    |    9 ---------
 arch/sparc/include/asm/highmem.h      |    9 ---------
 arch/x86/include/asm/highmem.h        |    2 --
 arch/x86/mm/highmem_32.c              |    9 ---------
 arch/xtensa/include/asm/highmem.h     |    9 ---------
 include/linux/highmem.h               |   18 ++++++++++++++++++
 17 files changed, 29 insertions(+), 109 deletions(-)

--- a/arch/arc/include/asm/highmem.h~arch-kmap-remove-redundant-arch-specif=
ic-kmaps
+++ a/arch/arc/include/asm/highmem.h
@@ -30,8 +30,6 @@
=20
 #include <asm/cacheflush.h>
=20
-extern void *kmap(struct page *page);
-extern void *kmap_high(struct page *page);
 extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void kunmap_high(struct page *page);
--- a/arch/arc/mm/highmem.c~arch-kmap-remove-redundant-arch-specific-kmaps
+++ a/arch/arc/mm/highmem.c
@@ -49,16 +49,6 @@
 extern pte_t * pkmap_page_table;
 static pte_t * fixmap_page_table;
=20
-void *kmap(struct page *page)
-{
-	might_sleep();
-	if (!PageHighMem(page))
-		return page_address(page);
-
-	return kmap_high(page);
-}
-EXPORT_SYMBOL(kmap);
-
 void *kmap_atomic(struct page *page)
 {
 	int idx, cpu_idx;
--- a/arch/arm/include/asm/highmem.h~arch-kmap-remove-redundant-arch-specif=
ic-kmaps
+++ a/arch/arm/include/asm/highmem.h
@@ -20,7 +20,6 @@
=20
 extern pte_t *pkmap_page_table;
=20
-extern void *kmap_high(struct page *page);
 extern void kunmap_high(struct page *page);
=20
 /*
@@ -63,7 +62,6 @@ static inline void *kmap_high_get(struct
  * when CONFIG_HIGHMEM is not set.
  */
 #ifdef CONFIG_HIGHMEM
-extern void *kmap(struct page *page);
 extern void kunmap(struct page *page);
 extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
--- a/arch/arm/mm/highmem.c~arch-kmap-remove-redundant-arch-specific-kmaps
+++ a/arch/arm/mm/highmem.c
@@ -31,15 +31,6 @@ static inline pte_t get_fixmap_pte(unsig
 	return *ptep;
 }
=20
-void *kmap(struct page *page)
-{
-	might_sleep();
-	if (!PageHighMem(page))
-		return page_address(page);
-	return kmap_high(page);
-}
-EXPORT_SYMBOL(kmap);
-
 void kunmap(struct page *page)
 {
 	might_sleep();
--- a/arch/csky/include/asm/highmem.h~arch-kmap-remove-redundant-arch-speci=
fic-kmaps
+++ a/arch/csky/include/asm/highmem.h
@@ -30,10 +30,10 @@ extern pte_t *pkmap_page_table;
 #define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
=20
-extern void *kmap_high(struct page *page);
 extern void kunmap_high(struct page *page);
=20
-extern void *kmap(struct page *page);
+#define ARCH_HAS_KMAP_FLUSH_TLB
+extern void kmap_flush_tlb(unsigned long addr);
 extern void kunmap(struct page *page);
 extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
--- a/arch/csky/mm/highmem.c~arch-kmap-remove-redundant-arch-specific-kmaps
+++ a/arch/csky/mm/highmem.c
@@ -13,18 +13,12 @@ static pte_t *kmap_pte;
=20
 unsigned long highstart_pfn, highend_pfn;
=20
-void *kmap(struct page *page)
+void kmap_flush_tlb(unsigned long addr)
 {
-	void *addr;
-
-	might_sleep();
-	if (!PageHighMem(page))
-		return page_address(page);
-	addr =3D kmap_high(page);
-	flush_tlb_one((unsigned long)addr);
-
-	return addr;
+	flush_tlb_one(addr);
 }
+EXPORT_SYMBOL(kmap_flush_tlb);
+
 EXPORT_SYMBOL(kmap);
=20
 void kunmap(struct page *page)
--- a/arch/microblaze/include/asm/highmem.h~arch-kmap-remove-redundant-arch=
-specific-kmaps
+++ a/arch/microblaze/include/asm/highmem.h
@@ -51,19 +51,10 @@ extern pte_t *pkmap_page_table;
 #define PKMAP_NR(virt)  ((virt - PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
=20
-extern void *kmap_high(struct page *page);
 extern void kunmap_high(struct page *page);
 extern void *kmap_atomic_prot(struct page *page, pgprot_t prot);
 extern void __kunmap_atomic(void *kvaddr);
=20
-static inline void *kmap(struct page *page)
-{
-	might_sleep();
-	if (!PageHighMem(page))
-		return page_address(page);
-	return kmap_high(page);
-}
-
 static inline void kunmap(struct page *page)
 {
 	might_sleep();
--- a/arch/mips/include/asm/highmem.h~arch-kmap-remove-redundant-arch-speci=
fic-kmaps
+++ a/arch/mips/include/asm/highmem.h
@@ -46,10 +46,10 @@ extern pte_t *pkmap_page_table;
 #define PKMAP_NR(virt)	((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)	(PKMAP_BASE + ((nr) << PAGE_SHIFT))
=20
-extern void * kmap_high(struct page *page);
 extern void kunmap_high(struct page *page);
=20
-extern void *kmap(struct page *page);
+#define ARCH_HAS_KMAP_FLUSH_TLB
+extern void kmap_flush_tlb(unsigned long addr);
 extern void kunmap(struct page *page);
 extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
--- a/arch/mips/mm/highmem.c~arch-kmap-remove-redundant-arch-specific-kmaps
+++ a/arch/mips/mm/highmem.c
@@ -12,19 +12,11 @@ static pte_t *kmap_pte;
=20
 unsigned long highstart_pfn, highend_pfn;
=20
-void *kmap(struct page *page)
+void kmap_flush_tlb(unsigned long addr)
 {
-	void *addr;
-
-	might_sleep();
-	if (!PageHighMem(page))
-		return page_address(page);
-	addr =3D kmap_high(page);
-	flush_tlb_one((unsigned long)addr);
-
-	return addr;
+	flush_tlb_one(addr);
 }
-EXPORT_SYMBOL(kmap);
+EXPORT_SYMBOL(kmap_flush_tlb);
=20
 void kunmap(struct page *page)
 {
--- a/arch/nds32/include/asm/highmem.h~arch-kmap-remove-redundant-arch-spec=
ific-kmaps
+++ a/arch/nds32/include/asm/highmem.h
@@ -44,7 +44,6 @@ extern unsigned long highstart_pfn, high
=20
 extern pte_t *pkmap_page_table;
=20
-extern void *kmap_high(struct page *page);
 extern void kunmap_high(struct page *page);
=20
 extern void kmap_init(void);
@@ -54,7 +53,6 @@ extern void kmap_init(void);
  * when CONFIG_HIGHMEM is not set.
  */
 #ifdef CONFIG_HIGHMEM
-extern void *kmap(struct page *page);
 extern void kunmap(struct page *page);
 extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
--- a/arch/nds32/mm/highmem.c~arch-kmap-remove-redundant-arch-specific-kmaps
+++ a/arch/nds32/mm/highmem.c
@@ -10,18 +10,6 @@
 #include <asm/fixmap.h>
 #include <asm/tlbflush.h>
=20
-void *kmap(struct page *page)
-{
-	unsigned long vaddr;
-	might_sleep();
-	if (!PageHighMem(page))
-		return page_address(page);
-	vaddr =3D (unsigned long)kmap_high(page);
-	return (void *)vaddr;
-}
-
-EXPORT_SYMBOL(kmap);
-
 void kunmap(struct page *page)
 {
 	might_sleep();
--- a/arch/powerpc/include/asm/highmem.h~arch-kmap-remove-redundant-arch-sp=
ecific-kmaps
+++ a/arch/powerpc/include/asm/highmem.h
@@ -59,19 +59,10 @@ extern pte_t *pkmap_page_table;
 #define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
=20
-extern void *kmap_high(struct page *page);
 extern void kunmap_high(struct page *page);
 extern void *kmap_atomic_prot(struct page *page, pgprot_t prot);
 extern void __kunmap_atomic(void *kvaddr);
=20
-static inline void *kmap(struct page *page)
-{
-	might_sleep();
-	if (!PageHighMem(page))
-		return page_address(page);
-	return kmap_high(page);
-}
-
 static inline void kunmap(struct page *page)
 {
 	might_sleep();
--- a/arch/sparc/include/asm/highmem.h~arch-kmap-remove-redundant-arch-spec=
ific-kmaps
+++ a/arch/sparc/include/asm/highmem.h
@@ -50,17 +50,8 @@ void kmap_init(void) __init;
=20
 #define PKMAP_END (PKMAP_ADDR(LAST_PKMAP))
=20
-void *kmap_high(struct page *page);
 void kunmap_high(struct page *page);
=20
-static inline void *kmap(struct page *page)
-{
-	might_sleep();
-	if (!PageHighMem(page))
-		return page_address(page);
-	return kmap_high(page);
-}
-
 static inline void kunmap(struct page *page)
 {
 	might_sleep();
--- a/arch/x86/include/asm/highmem.h~arch-kmap-remove-redundant-arch-specif=
ic-kmaps
+++ a/arch/x86/include/asm/highmem.h
@@ -58,10 +58,8 @@ extern unsigned long highstart_pfn, high
 #define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
=20
-extern void *kmap_high(struct page *page);
 extern void kunmap_high(struct page *page);
=20
-void *kmap(struct page *page);
 void kunmap(struct page *page);
=20
 void *kmap_atomic_prot(struct page *page, pgprot_t prot);
--- a/arch/x86/mm/highmem_32.c~arch-kmap-remove-redundant-arch-specific-kma=
ps
+++ a/arch/x86/mm/highmem_32.c
@@ -4,15 +4,6 @@
 #include <linux/swap.h> /* for totalram_pages */
 #include <linux/memblock.h>
=20
-void *kmap(struct page *page)
-{
-	might_sleep();
-	if (!PageHighMem(page))
-		return page_address(page);
-	return kmap_high(page);
-}
-EXPORT_SYMBOL(kmap);
-
 void kunmap(struct page *page)
 {
 	might_sleep();
--- a/arch/xtensa/include/asm/highmem.h~arch-kmap-remove-redundant-arch-spe=
cific-kmaps
+++ a/arch/xtensa/include/asm/highmem.h
@@ -63,17 +63,8 @@ static inline wait_queue_head_t *get_pkm
=20
 extern pte_t *pkmap_page_table;
=20
-void *kmap_high(struct page *page);
 void kunmap_high(struct page *page);
=20
-static inline void *kmap(struct page *page)
-{
-	might_sleep();
-	if (!PageHighMem(page))
-		return page_address(page);
-	return kmap_high(page);
-}
-
 static inline void kunmap(struct page *page)
 {
 	might_sleep();
--- a/include/linux/highmem.h~arch-kmap-remove-redundant-arch-specific-kmaps
+++ a/include/linux/highmem.h
@@ -34,6 +34,24 @@ static inline void invalidate_kernel_vma
 #ifdef CONFIG_HIGHMEM
 #include <asm/highmem.h>
=20
+#ifndef ARCH_HAS_KMAP_FLUSH_TLB
+static inline void kmap_flush_tlb(unsigned long addr) { }
+#endif
+
+void *kmap_high(struct page *page);
+static inline void *kmap(struct page *page)
+{
+	void *addr;
+
+	might_sleep();
+	if (!PageHighMem(page))
+		addr =3D page_address(page);
+	else
+		addr =3D kmap_high(page);
+	kmap_flush_tlb((unsigned long)addr);
+	return addr;
+}
+
 /* declarations for linux/mm/highmem.c */
 unsigned int nr_free_highpages(void);
 extern atomic_long_t _totalhigh_pages;
_
