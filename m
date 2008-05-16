From: akpm@linux-foundation.org
Subject: + powerpc-ioremap_prot.patch added to -mm tree
Date: Thu, 15 May 2008 17:22:17 -0700
Message-ID: <200805160022.m4G0MIUZ018068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753839AbYEPAWt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 20:22:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, airlied@linux.ie, arnd@arndb.de, benh@kernel.crashing.org, hugh@veritas.com, paulus@samba.org


The patch titled
     powerpc ioremap_prot
has been added to the -mm tree.  Its filename is
     powerpc-ioremap_prot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc ioremap_prot
From: Rik van Riel <riel@redhat.com>

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
@@ -110,6 +110,7 @@ config PPC
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_LMB
+	select HAVE_IOREMAP_PROT
 
 config EARLY_PRINTK
 	bool
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
@@ -588,7 +588,8 @@ static inline void iosync(void)
  *   and can be hooked by the platform via ppc_md
  *
  * * ioremap_flags allows to specify the page flags as an argument and can
- *   also be hooked by the platform via ppc_md
+ *   also be hooked by the platform via ppc_md. ioremap_prot is the exact
+ *   same thing as ioremap_flags.
  *
  * * ioremap_nocache is identical to ioremap
  *
@@ -610,6 +611,8 @@ extern void __iomem *ioremap(phys_addr_t
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
@@ -50,6 +50,9 @@
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
@@ -388,6 +388,12 @@ extern int icache_44x_need_flush;
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
@@ -398,6 +404,12 @@ extern int icache_44x_need_flush;
 
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
@@ -531,6 +543,10 @@ static inline pte_t pte_mkyoung(pte_t pt
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
@@ -115,6 +115,10 @@
 #define PAGE_AGP	__pgprot(_PAGE_BASE | _PAGE_WRENABLE | _PAGE_NO_CACHE)
 #define HAVE_PAGE_AGP
 
+#define PAGE_PROT_BITS	__pgprot(_PAGE_GUARDED | _PAGE_COHERENT | \
+				 _PAGE_NO_CACHE | _PAGE_WRITETHRU | \
+				 _PAGE_4K_PFN | _PAGE_RW | _PAGE_USER | \
+ 				 _PAGE_ACCESSED | _PAGE_DIRTY | _PAGE_EXEC)
 /* PTEIDX nibble */
 #define _PTEIDX_SECONDARY	0x8
 #define _PTEIDX_GROUP_IX	0x7
@@ -260,6 +264,10 @@ static inline pte_t pte_mkhuge(pte_t pte
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

Patches currently in -mm which might be from riel@redhat.com are

access_process_vm-device-memory-infrastructure.patch
use-generic_access_phys-for-dev-mem-mappings.patch
use-generic_access_phys-for-pci-mmap-on-x86.patch
powerpc-ioremap_prot.patch
spufs-use-the-new-vm_ops-access.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch
make-mm-rmapc-anon_vma_cachep-static.patch

