From: akpm@linux-foundation.org
Subject: + kmap-consolidate-kmap_prot-definitions.patch added to
 -mm tree
Date: Thu, 07 May 2020 13:37:15 -0700
Message-ID: <20200507203715.-OjCV_WeU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbgEGUhS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 16:37:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bp@alien8.de, chris@zankel.net, christian.koenig@amd.com, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net, deller@gmx.de, hch@infradead.org, hpa@zytor.com, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, tsbogend@alpha.franken.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: kmap: consolidate kmap_prot definitions
has been added to the -mm tree.  Its filename is
     kmap-consolidate-kmap_prot-definitions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmap-consolidate-kmap_prot-def=
initions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmap-consolidate-kmap_prot-def=
initions.patch

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
Subject: kmap: consolidate kmap_prot definitions

Most architectures define kmap_prot to be PAGE_KERNEL.

Let sparc and xtensa define there own and define PAGE_KERNEL as the
default if not overridden.

Link: http://lkml.kernel.org/r/20200507150004.1423069-16-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
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

 arch/arc/include/asm/highmem.h        |    3 ---
 arch/arm/include/asm/highmem.h        |    2 --
 arch/csky/include/asm/highmem.h       |    2 --
 arch/microblaze/include/asm/highmem.h |    1 -
 arch/mips/include/asm/highmem.h       |    2 --
 arch/nds32/include/asm/highmem.h      |    1 -
 arch/powerpc/include/asm/highmem.h    |    1 -
 arch/sparc/include/asm/highmem.h      |    3 ++-
 arch/sparc/mm/highmem.c               |    4 ----
 arch/x86/include/asm/fixmap.h         |    1 -
 include/linux/highmem.h               |    4 ++++
 11 files changed, 6 insertions(+), 18 deletions(-)

--- a/arch/arc/include/asm/highmem.h~kmap-consolidate-kmap_prot-definitions
+++ a/arch/arc/include/asm/highmem.h
@@ -25,9 +25,6 @@
 #define PKMAP_ADDR(nr)		(PKMAP_BASE + ((nr) << PAGE_SHIFT))
 #define PKMAP_NR(virt)		(((virt) - PKMAP_BASE) >> PAGE_SHIFT)
=20
-#define kmap_prot		PAGE_KERNEL
-
-
 #include <asm/cacheflush.h>
=20
 extern void kmap_init(void);
--- a/arch/arm/include/asm/highmem.h~kmap-consolidate-kmap_prot-definitions
+++ a/arch/arm/include/asm/highmem.h
@@ -10,8 +10,6 @@
 #define PKMAP_NR(virt)		(((virt) - PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)		(PKMAP_BASE + ((nr) << PAGE_SHIFT))
=20
-#define kmap_prot		PAGE_KERNEL
-
 #define flush_cache_kmaps() \
 	do { \
 		if (cache_is_vivt()) \
--- a/arch/csky/include/asm/highmem.h~kmap-consolidate-kmap_prot-definitions
+++ a/arch/csky/include/asm/highmem.h
@@ -38,8 +38,6 @@ extern void *kmap_atomic_pfn(unsigned lo
=20
 extern void kmap_init(void);
=20
-#define kmap_prot PAGE_KERNEL
-
 #endif /* __KERNEL__ */
=20
 #endif /* __ASM_CSKY_HIGHMEM_H */
--- a/arch/microblaze/include/asm/highmem.h~kmap-consolidate-kmap_prot-defi=
nitions
+++ a/arch/microblaze/include/asm/highmem.h
@@ -25,7 +25,6 @@
 #include <linux/uaccess.h>
 #include <asm/fixmap.h>
=20
-#define kmap_prot		PAGE_KERNEL
 extern pte_t *kmap_pte;
 extern pte_t *pkmap_page_table;
=20
--- a/arch/mips/include/asm/highmem.h~kmap-consolidate-kmap_prot-definitions
+++ a/arch/mips/include/asm/highmem.h
@@ -54,8 +54,6 @@ extern void *kmap_atomic_pfn(unsigned lo
=20
 extern void kmap_init(void);
=20
-#define kmap_prot PAGE_KERNEL
-
 #endif /* __KERNEL__ */
=20
 #endif /* _ASM_HIGHMEM_H */
--- a/arch/nds32/include/asm/highmem.h~kmap-consolidate-kmap_prot-definitio=
ns
+++ a/arch/nds32/include/asm/highmem.h
@@ -32,7 +32,6 @@
 #define LAST_PKMAP_MASK		(LAST_PKMAP - 1)
 #define PKMAP_NR(virt)		(((virt) - (PKMAP_BASE)) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)		(PKMAP_BASE + ((nr) << PAGE_SHIFT))
-#define kmap_prot		PAGE_KERNEL
=20
 static inline void flush_cache_kmaps(void)
 {
--- a/arch/powerpc/include/asm/highmem.h~kmap-consolidate-kmap_prot-definit=
ions
+++ a/arch/powerpc/include/asm/highmem.h
@@ -29,7 +29,6 @@
 #include <asm/page.h>
 #include <asm/fixmap.h>
=20
-#define kmap_prot		PAGE_KERNEL
 extern pte_t *kmap_pte;
 extern pte_t *pkmap_page_table;
=20
--- a/arch/sparc/include/asm/highmem.h~kmap-consolidate-kmap_prot-definitio=
ns
+++ a/arch/sparc/include/asm/highmem.h
@@ -25,11 +25,12 @@
 #include <asm/vaddrs.h>
 #include <asm/kmap_types.h>
 #include <asm/pgtable.h>
+#include <asm/pgtsrmmu.h>
=20
 /* declarations for highmem.c */
 extern unsigned long highstart_pfn, highend_pfn;
=20
-extern pgprot_t kmap_prot;
+#define kmap_prot __pgprot(SRMMU_ET_PTE | SRMMU_PRIV | SRMMU_CACHE);
 extern pte_t *pkmap_page_table;
=20
 void kmap_init(void) __init;
--- a/arch/sparc/mm/highmem.c~kmap-consolidate-kmap_prot-definitions
+++ a/arch/sparc/mm/highmem.c
@@ -32,9 +32,6 @@
 #include <asm/pgalloc.h>
 #include <asm/vaddrs.h>
=20
-pgprot_t kmap_prot;
-EXPORT_SYMBOL(kmap_prot);
-
 static pte_t *kmap_pte;
=20
 void __init kmap_init(void)
@@ -51,7 +48,6 @@ void __init kmap_init(void)
=20
         /* cache the first kmap pte */
         kmap_pte =3D pte_offset_kernel(dir, address);
-        kmap_prot =3D __pgprot(SRMMU_ET_PTE | SRMMU_PRIV | SRMMU_CACHE);
 }
=20
 void *kmap_atomic_high_prot(struct page *page, pgprot_t prot)
--- a/arch/x86/include/asm/fixmap.h~kmap-consolidate-kmap_prot-definitions
+++ a/arch/x86/include/asm/fixmap.h
@@ -152,7 +152,6 @@ extern void reserve_top_address(unsigned
 extern int fixmaps_set;
=20
 extern pte_t *kmap_pte;
-#define kmap_prot PAGE_KERNEL
 extern pte_t *pkmap_page_table;
=20
 void __native_set_fixmap(enum fixed_addresses idx, pte_t pte);
--- a/include/linux/highmem.h~kmap-consolidate-kmap_prot-definitions
+++ a/include/linux/highmem.h
@@ -40,6 +40,10 @@ extern void kunmap_atomic_high(void *kva
 static inline void kmap_flush_tlb(unsigned long addr) { }
 #endif
=20
+#ifndef kmap_prot
+#define kmap_prot PAGE_KERNEL
+#endif
+
 void *kmap_high(struct page *page);
 static inline void *kmap(struct page *page)
 {
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
