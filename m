From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 029/127] arch/kunmap: remove duplicate kunmap
 implementations
Date: Thu, 04 Jun 2020 16:47:34 -0700
Message-ID: <20200604234734.yf7egg5dC%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXrh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:47:37 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, bp@alien8.de, chris@zankel.net, christian.koenig@amd.com, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net, deller@gmx.de, hch@lst.de, hpa@zytor.com, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, linux-mm@kvack.org, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, torvalds@linux-foundation.org, tsbogend@alpha.franken.de, viro@zeniv.linux.org.uk

=46rom: Ira Weiny <ira.weiny@intel.com>
Subject: arch/kunmap: remove duplicate kunmap implementations

All architectures do exactly the same thing for kunmap(); remove all the
duplicate definitions and lift the call to the core.

This also has the benefit of changing kmap_unmap() on a number of
architectures to be an inline call rather than an actual function.

[akpm@linux-foundation.org: fix CONFIG_HIGHMEM=3Dn build on various archite=
ctures]
Link: http://lkml.kernel.org/r/20200507150004.1423069-5-ira.weiny@intel.com
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
 include/linux/highmem.h               |   14 ++++++++++++++
 16 files changed, 14 insertions(+), 110 deletions(-)

--- a/arch/arc/include/asm/highmem.h~arch-kunmap-remove-duplicate-kunmap-im=
plementations
+++ a/arch/arc/include/asm/highmem.h
@@ -32,7 +32,6 @@
=20
 extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
-extern void kunmap_high(struct page *page);
=20
 extern void kmap_init(void);
=20
@@ -41,15 +40,6 @@ static inline void flush_cache_kmaps(voi
 	flush_cache_all();
 }
=20
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
=20
 #endif
--- a/arch/arm/include/asm/highmem.h~arch-kunmap-remove-duplicate-kunmap-im=
plementations
+++ a/arch/arm/include/asm/highmem.h
@@ -20,8 +20,6 @@
=20
 extern pte_t *pkmap_page_table;
=20
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
--- a/arch/arm/mm/highmem.c~arch-kunmap-remove-duplicate-kunmap-implementat=
ions
+++ a/arch/arm/mm/highmem.c
@@ -31,15 +31,6 @@ static inline pte_t get_fixmap_pte(unsig
 	return *ptep;
 }
=20
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
--- a/arch/csky/include/asm/highmem.h~arch-kunmap-remove-duplicate-kunmap-i=
mplementations
+++ a/arch/csky/include/asm/highmem.h
@@ -30,11 +30,8 @@ extern pte_t *pkmap_page_table;
 #define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
=20
-extern void kunmap_high(struct page *page);
-
 #define ARCH_HAS_KMAP_FLUSH_TLB
 extern void kmap_flush_tlb(unsigned long addr);
-extern void kunmap(struct page *page);
 extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
--- a/arch/csky/mm/highmem.c~arch-kunmap-remove-duplicate-kunmap-implementa=
tions
+++ a/arch/csky/mm/highmem.c
@@ -21,15 +21,6 @@ EXPORT_SYMBOL(kmap_flush_tlb);
=20
 EXPORT_SYMBOL(kmap);
=20
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
--- a/arch/microblaze/include/asm/highmem.h~arch-kunmap-remove-duplicate-ku=
nmap-implementations
+++ a/arch/microblaze/include/asm/highmem.h
@@ -51,18 +51,9 @@ extern pte_t *pkmap_page_table;
 #define PKMAP_NR(virt)  ((virt - PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
=20
-extern void kunmap_high(struct page *page);
 extern void *kmap_atomic_prot(struct page *page, pgprot_t prot);
 extern void __kunmap_atomic(void *kvaddr);
=20
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
--- a/arch/mips/include/asm/highmem.h~arch-kunmap-remove-duplicate-kunmap-i=
mplementations
+++ a/arch/mips/include/asm/highmem.h
@@ -46,11 +46,8 @@ extern pte_t *pkmap_page_table;
 #define PKMAP_NR(virt)	((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)	(PKMAP_BASE + ((nr) << PAGE_SHIFT))
=20
-extern void kunmap_high(struct page *page);
-
 #define ARCH_HAS_KMAP_FLUSH_TLB
 extern void kmap_flush_tlb(unsigned long addr);
-extern void kunmap(struct page *page);
 extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
--- a/arch/mips/mm/highmem.c~arch-kunmap-remove-duplicate-kunmap-implementa=
tions
+++ a/arch/mips/mm/highmem.c
@@ -18,15 +18,6 @@ void kmap_flush_tlb(unsigned long addr)
 }
 EXPORT_SYMBOL(kmap_flush_tlb);
=20
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
  * kmap_atomic/kunmap_atomic is significantly faster than kmap/kunmap beca=
use
  * no global lock is needed and because the kmap code must perform a globa=
l TLB
--- a/arch/nds32/include/asm/highmem.h~arch-kunmap-remove-duplicate-kunmap-=
implementations
+++ a/arch/nds32/include/asm/highmem.h
@@ -44,8 +44,6 @@ extern unsigned long highstart_pfn, high
=20
 extern pte_t *pkmap_page_table;
=20
-extern void kunmap_high(struct page *page);
-
 extern void kmap_init(void);
=20
 /*
@@ -53,7 +51,6 @@ extern void kmap_init(void);
  * when CONFIG_HIGHMEM is not set.
  */
 #ifdef CONFIG_HIGHMEM
-extern void kunmap(struct page *page);
 extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
--- a/arch/nds32/mm/highmem.c~arch-kunmap-remove-duplicate-kunmap-implement=
ations
+++ a/arch/nds32/mm/highmem.c
@@ -10,16 +10,6 @@
 #include <asm/fixmap.h>
 #include <asm/tlbflush.h>
=20
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
--- a/arch/powerpc/include/asm/highmem.h~arch-kunmap-remove-duplicate-kunma=
p-implementations
+++ a/arch/powerpc/include/asm/highmem.h
@@ -59,18 +59,9 @@ extern pte_t *pkmap_page_table;
 #define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
=20
-extern void kunmap_high(struct page *page);
 extern void *kmap_atomic_prot(struct page *page, pgprot_t prot);
 extern void __kunmap_atomic(void *kvaddr);
=20
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
--- a/arch/sparc/include/asm/highmem.h~arch-kunmap-remove-duplicate-kunmap-=
implementations
+++ a/arch/sparc/include/asm/highmem.h
@@ -50,16 +50,6 @@ void kmap_init(void) __init;
=20
 #define PKMAP_END (PKMAP_ADDR(LAST_PKMAP))
=20
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
=20
--- a/arch/x86/include/asm/highmem.h~arch-kunmap-remove-duplicate-kunmap-im=
plementations
+++ a/arch/x86/include/asm/highmem.h
@@ -58,10 +58,6 @@ extern unsigned long highstart_pfn, high
 #define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
=20
-extern void kunmap_high(struct page *page);
-
-void kunmap(struct page *page);
-
 void *kmap_atomic_prot(struct page *page, pgprot_t prot);
 void *kmap_atomic(struct page *page);
 void __kunmap_atomic(void *kvaddr);
--- a/arch/x86/mm/highmem_32.c~arch-kunmap-remove-duplicate-kunmap-implemen=
tations
+++ a/arch/x86/mm/highmem_32.c
@@ -4,15 +4,6 @@
 #include <linux/swap.h> /* for totalram_pages */
 #include <linux/memblock.h>
=20
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
  * kmap_atomic/kunmap_atomic is significantly faster than kmap/kunmap beca=
use
  * no global lock is needed and because the kmap code must perform a globa=
l TLB
--- a/arch/xtensa/include/asm/highmem.h~arch-kunmap-remove-duplicate-kunmap=
-implementations
+++ a/arch/xtensa/include/asm/highmem.h
@@ -63,16 +63,6 @@ static inline wait_queue_head_t *get_pkm
=20
 extern pte_t *pkmap_page_table;
=20
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
--- a/include/linux/highmem.h~arch-kunmap-remove-duplicate-kunmap-implement=
ations
+++ a/include/linux/highmem.h
@@ -52,6 +52,16 @@ static inline void *kmap(struct page *pa
 	return addr;
 }
=20
+void kunmap_high(struct page *page);
+
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
@@ -102,6 +112,10 @@ static inline void *kmap(struct page *pa
 	return page_address(page);
 }
=20
+static inline void kunmap_high(struct page *page)
+{
+}
+
 static inline void kunmap(struct page *page)
 {
 }
_
