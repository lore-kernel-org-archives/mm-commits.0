From: akpm@linux-foundation.org
Subject: - powerpc-ioremap_prot.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:21:49 -0700
Message-ID: <200807242321.m6ONLnSb010425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753176AbYGXXW6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:22:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, airlied@linux.ie, arnd@arndb.de, hugh@veritas.com, paulus@samba.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     powerpc ioremap_prot
has been removed from the -mm tree.  Its filename was
     powerpc-ioremap_prot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc ioremap_prot
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

This adds ioremap_prot and pte_pgprot() so that one can extract protection
bits from a PTE and use them to ioremap_prot() (in order to support ptrace
of VM_IO | VM_PFNMAP as per Rik's patch).

This moves a couple of flag checks around in the ioremap implementations
of arch/powerpc.  There's a side effect of allowing non-cacheable and
non-guarded mappings on ppc32 which before would always have _PAGE_GUARDED
set whenever _PAGE_NO_CACHE is.

(standard ioremap will still set _PAGE_GUARDED, but ioremap_prot will be
capable of setting such a non guarded mapping).

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig                |    1 +
 arch/powerpc/mm/pgtable_32.c        |   22 ++++++++++++++++------
 arch/powerpc/mm/pgtable_64.c        |   16 ++++++++++++++++
 include/asm-powerpc/io.h            |    5 ++++-
 include/asm-powerpc/pgtable-4k.h    |    3 +++
 include/asm-powerpc/pgtable-ppc32.h |   16 ++++++++++++++++
 include/asm-powerpc/pgtable-ppc64.h |    8 ++++++++
 7 files changed, 64 insertions(+), 7 deletions(-)

diff -puN arch/powerpc/Kconfig~powerpc-ioremap_prot arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~powerpc-ioremap_prot
+++ a/arch/powerpc/Kconfig
@@ -111,6 +111,7 @@ config PPC
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE
 	select HAVE_IDE
+	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
 	select HAVE_ARCH_KGDB
 	select HAVE_KRETPROBES
diff -puN arch/powerpc/mm/pgtable_32.c~powerpc-ioremap_prot arch/powerpc/mm/pgtable_32.c
--- a/arch/powerpc/mm/pgtable_32.c~powerpc-ioremap_prot
+++ a/arch/powerpc/mm/pgtable_32.c
@@ -145,13 +145,20 @@ void pte_free(struct mm_struct *mm, pgta
 void __iomem *
 ioremap(phys_addr_t addr, unsigned long size)
 {
-	return __ioremap(addr, size, _PAGE_NO_CACHE);
+	return __ioremap(addr, size, _PAGE_NO_CACHE | _PAGE_GUARDED);
 }
 EXPORT_SYMBOL(ioremap);
 
 void __iomem *
 ioremap_flags(phys_addr_t addr, unsigned long size, unsigned long flags)
 {
+	/* writeable implies dirty for kernel addresses */
+	if (flags & _PAGE_RW)
+		flags |= _PAGE_DIRTY | _PAGE_HWWRITE;
+
+	/* we don't want to let _PAGE_USER and _PAGE_EXEC leak out */
+	flags &= ~(_PAGE_USER | _PAGE_EXEC | _PAGE_HWEXEC);
+
 	return __ioremap(addr, size, flags);
 }
 EXPORT_SYMBOL(ioremap_flags);
@@ -163,6 +170,14 @@ __ioremap(phys_addr_t addr, unsigned lon
 	phys_addr_t p;
 	int err;
 
+	/* Make sure we have the base flags */
+	if ((flags & _PAGE_PRESENT) == 0)
+		flags |= _PAGE_KERNEL;
+
+	/* Non-cacheable page cannot be coherent */
+	if (flags & _PAGE_NO_CACHE)
+		flags &= ~_PAGE_COHERENT;
+
 	/*
 	 * Choose an address to map it to.
 	 * Once the vmalloc system is running, we use it.
@@ -219,11 +234,6 @@ __ioremap(phys_addr_t addr, unsigned lon
 		v = (ioremap_bot -= size);
 	}
 
-	if ((flags & _PAGE_PRESENT) == 0)
-		flags |= _PAGE_KERNEL;
-	if (flags & _PAGE_NO_CACHE)
-		flags |= _PAGE_GUARDED;
-
 	/*
 	 * Should check if it is a candidate for a BAT mapping
 	 */
diff -puN arch/powerpc/mm/pgtable_64.c~powerpc-ioremap_prot arch/powerpc/mm/pgtable_64.c
--- a/arch/powerpc/mm/pgtable_64.c~powerpc-ioremap_prot
+++ a/arch/powerpc/mm/pgtable_64.c
@@ -107,9 +107,18 @@ void __iomem * __ioremap_at(phys_addr_t 
 {
 	unsigned long i;
 
+	/* Make sure we have the base flags */
 	if ((flags & _PAGE_PRESENT) == 0)
 		flags |= pgprot_val(PAGE_KERNEL);
 
+	/* Non-cacheable page cannot be coherent */
+	if (flags & _PAGE_NO_CACHE)
+		flags &= ~_PAGE_COHERENT;
+
+	/* We don't support the 4K PFN hack with ioremap */
+	if (flags & _PAGE_4K_PFN)
+		return NULL;
+
 	WARN_ON(pa & ~PAGE_MASK);
 	WARN_ON(((unsigned long)ea) & ~PAGE_MASK);
 	WARN_ON(size & ~PAGE_MASK);
@@ -190,6 +199,13 @@ void __iomem * ioremap(phys_addr_t addr,
 void __iomem * ioremap_flags(phys_addr_t addr, unsigned long size,
 			     unsigned long flags)
 {
+	/* writeable implies dirty for kernel addresses */
+	if (flags & _PAGE_RW)
+		flags |= _PAGE_DIRTY;
+
+	/* we don't want to let _PAGE_USER and _PAGE_EXEC leak out */
+	flags &= ~(_PAGE_USER | _PAGE_EXEC);
+
 	if (ppc_md.ioremap)
 		return ppc_md.ioremap(addr, size, flags);
 	return __ioremap(addr, size, flags);
diff -puN include/asm-powerpc/io.h~powerpc-ioremap_prot include/asm-powerpc/io.h
--- a/include/asm-powerpc/io.h~powerpc-ioremap_prot
+++ a/include/asm-powerpc/io.h
@@ -617,7 +617,8 @@ static inline void iosync(void)
  *   and can be hooked by the platform via ppc_md
  *
  * * ioremap_flags allows to specify the page flags as an argument and can
- *   also be hooked by the platform via ppc_md
+ *   also be hooked by the platform via ppc_md. ioremap_prot is the exact
+ *   same thing as ioremap_flags.
  *
  * * ioremap_nocache is identical to ioremap
  *
@@ -639,6 +640,8 @@ extern void __iomem *ioremap(phys_addr_t
 extern void __iomem *ioremap_flags(phys_addr_t address, unsigned long size,
 				   unsigned long flags);
 #define ioremap_nocache(addr, size)	ioremap((addr), (size))
+#define ioremap_prot(addr, size, prot)	ioremap_flags((addr), (size), (prot))
+
 extern void iounmap(volatile void __iomem *addr);
 
 extern void __iomem *__ioremap(phys_addr_t, unsigned long size,
diff -puN include/asm-powerpc/pgtable-4k.h~powerpc-ioremap_prot include/asm-powerpc/pgtable-4k.h
--- a/include/asm-powerpc/pgtable-4k.h~powerpc-ioremap_prot
+++ a/include/asm-powerpc/pgtable-4k.h
@@ -51,6 +51,9 @@
 #define _PAGE_HPTEFLAGS (_PAGE_BUSY | _PAGE_HASHPTE | \
 			 _PAGE_SECONDARY | _PAGE_GROUP_IX)
 
+/* There is no 4K PFN hack on 4K pages */
+#define _PAGE_4K_PFN	0
+
 /* PAGE_MASK gives the right answer below, but only by accident */
 /* It should be preserving the high 48 bits and then specifically */
 /* preserving _PAGE_SECONDARY | _PAGE_GROUP_IX */
diff -puN include/asm-powerpc/pgtable-ppc32.h~powerpc-ioremap_prot include/asm-powerpc/pgtable-ppc32.h
--- a/include/asm-powerpc/pgtable-ppc32.h~powerpc-ioremap_prot
+++ a/include/asm-powerpc/pgtable-ppc32.h
@@ -395,6 +395,12 @@ extern int icache_44x_need_flush;
 #ifndef _PAGE_EXEC
 #define _PAGE_EXEC	0
 #endif
+#ifndef _PAGE_ENDIAN
+#define _PAGE_ENDIAN	0
+#endif
+#ifndef _PAGE_COHERENT
+#define _PAGE_COHERENT	0
+#endif
 #ifndef _PMD_PRESENT_MASK
 #define _PMD_PRESENT_MASK	_PMD_PRESENT
 #endif
@@ -405,6 +411,12 @@ extern int icache_44x_need_flush;
 
 #define _PAGE_CHG_MASK	(PAGE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
 
+
+#define PAGE_PROT_BITS	__pgprot(_PAGE_GUARDED | _PAGE_COHERENT | _PAGE_NO_CACHE | \
+				 _PAGE_WRITETHRU | _PAGE_ENDIAN | \
+				 _PAGE_USER | _PAGE_ACCESSED | \
+				 _PAGE_RW | _PAGE_HWWRITE | _PAGE_DIRTY | \
+				 _PAGE_EXEC | _PAGE_HWEXEC)
 /*
  * Note: the _PAGE_COHERENT bit automatically gets set in the hardware
  * PTE if CONFIG_SMP is defined (hash_page does this); there is no need
@@ -538,6 +550,10 @@ static inline pte_t pte_mkyoung(pte_t pt
 	pte_val(pte) |= _PAGE_ACCESSED; return pte; }
 static inline pte_t pte_mkspecial(pte_t pte) {
 	return pte; }
+static inline unsigned long pte_pgprot(pte_t pte)
+{
+	return __pgprot(pte_val(pte)) & PAGE_PROT_BITS;
+}
 
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
diff -puN include/asm-powerpc/pgtable-ppc64.h~powerpc-ioremap_prot include/asm-powerpc/pgtable-ppc64.h
--- a/include/asm-powerpc/pgtable-ppc64.h~powerpc-ioremap_prot
+++ a/include/asm-powerpc/pgtable-ppc64.h
@@ -117,6 +117,10 @@
 #define PAGE_AGP	__pgprot(_PAGE_BASE | _PAGE_WRENABLE | _PAGE_NO_CACHE)
 #define HAVE_PAGE_AGP
 
+#define PAGE_PROT_BITS	__pgprot(_PAGE_GUARDED | _PAGE_COHERENT | \
+				 _PAGE_NO_CACHE | _PAGE_WRITETHRU | \
+				 _PAGE_4K_PFN | _PAGE_RW | _PAGE_USER | \
+ 				 _PAGE_ACCESSED | _PAGE_DIRTY | _PAGE_EXEC)
 /* PTEIDX nibble */
 #define _PTEIDX_SECONDARY	0x8
 #define _PTEIDX_GROUP_IX	0x7
@@ -262,6 +266,10 @@ static inline pte_t pte_mkhuge(pte_t pte
 	return pte; }
 static inline pte_t pte_mkspecial(pte_t pte) {
 	return pte; }
+static inline unsigned long pte_pgprot(pte_t pte)
+{
+	return __pgprot(pte_val(pte)) & PAGE_PROT_BITS;
+}
 
 /* Atomic PTE updates */
 static inline unsigned long pte_update(struct mm_struct *mm,
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
linux-next.patch
powerpc-86xx-mpc8610_hpcd-add-watchdog-node.patch
gpiolib-allow-user-selection.patch
gpiolib-allow-user-selection-update.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-pasemi_mac.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-implement-pte_special-update.patch
powerpc-lockless-get_user_pages.patch
powerpc-hugetlb-pgtable-cache-access-cleanup.patch
mm-print-swapcache-page-count-in-show_swap_cache_info.patch
lib-generic-show_mem.patch
powerpc-use-generic-show_mem.patch

