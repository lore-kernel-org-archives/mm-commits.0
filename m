From: akpm@linux-foundation.org
Subject: [failures] mm-make-ioremap_prot-take-a-pgprot.patch removed from -mm tree
Date: Thu, 02 Dec 2010 14:46:49 -0800
Message-ID: <201012022319.oB2NJTsO014489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758158Ab0LBXTz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Dec 2010 18:19:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, benh@kernel.crashing.org, cmetcalf@tilera.com, jesper.nilsson@axis.com, mingo@redhat.com, paulus@samba.org, starvik@axis.com, tglx@linutronix.de, tj@kernel.orgm


The patch titled
     mm: make ioremap_prot() take a pgprot
has been removed from the -mm tree.  Its filename was
     mm-make-ioremap_prot-take-a-pgprot.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: make ioremap_prot() take a pgprot
From: Paul Mundt <lethal@linux-sh.org>

The current definition of ioremap_prot() takes an unsigned long for the
page flags and then converts to/from a pgprot as necessary.  This is
unfortunately not sufficient for the SH-X2 TLB case which has a 64-bit
pgprot and a 32-bit unsigned long.

An inspection of the tree shows that tile and cris also have their own
equivalent routines that are using the pgprot_t but do not set
HAVE_IOREMAP_PROT, both of which could trivially be adapted.

After cris/tile are updated there would also be enough critical mass to
move the powerpc devm_ioremap_prot() in to the generic lib/devres.c.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/io.h       |    8 +++++---
 arch/powerpc/lib/devres.c           |   10 +++++-----
 arch/sh/Kconfig                     |    2 +-
 arch/sh/boards/mach-landisk/setup.c |    2 +-
 arch/sh/boards/mach-lboxre2/setup.c |    2 +-
 arch/sh/boards/mach-sh03/setup.c    |    2 +-
 arch/sh/include/asm/io.h            |    4 ++--
 arch/x86/include/asm/io.h           |    2 +-
 arch/x86/mm/ioremap.c               |    5 +++--
 arch/x86/mm/pat.c                   |    5 ++---
 include/linux/mm.h                  |    2 +-
 mm/memory.c                         |    6 +++---
 12 files changed, 26 insertions(+), 24 deletions(-)

diff -puN arch/powerpc/include/asm/io.h~mm-make-ioremap_prot-take-a-pgprot arch/powerpc/include/asm/io.h
--- a/arch/powerpc/include/asm/io.h~mm-make-ioremap_prot-take-a-pgprot
+++ a/arch/powerpc/include/asm/io.h
@@ -618,7 +618,8 @@ static inline void iosync(void)
  *
  * * ioremap_flags allows to specify the page flags as an argument and can
  *   also be hooked by the platform via ppc_md. ioremap_prot is the exact
- *   same thing as ioremap_flags.
+ *   same thing as ioremap_flags, with the exception that it takes a
+ *   pgprot value instead.
  *
  * * ioremap_nocache is identical to ioremap
  *
@@ -643,7 +644,8 @@ extern void __iomem *ioremap(phys_addr_t
 extern void __iomem *ioremap_flags(phys_addr_t address, unsigned long size,
 				   unsigned long flags);
 #define ioremap_nocache(addr, size)	ioremap((addr), (size))
-#define ioremap_prot(addr, size, prot)	ioremap_flags((addr), (size), (prot))
+#define ioremap_prot(addr, size, prot)	ioremap_flags((addr), (size), \
+						      pgprot_val(prot))
 
 extern void iounmap(volatile void __iomem *addr);
 
@@ -779,7 +781,7 @@ static inline void * bus_to_virt(unsigne
 #define clrsetbits_8(addr, clear, set) clrsetbits(8, addr, clear, set)
 
 void __iomem *devm_ioremap_prot(struct device *dev, resource_size_t offset,
-				size_t size, unsigned long flags);
+				size_t size, pgprot_t prot);
 
 #endif /* __KERNEL__ */
 
diff -puN arch/powerpc/lib/devres.c~mm-make-ioremap_prot-take-a-pgprot arch/powerpc/lib/devres.c
--- a/arch/powerpc/lib/devres.c~mm-make-ioremap_prot-take-a-pgprot
+++ a/arch/powerpc/lib/devres.c
@@ -9,21 +9,21 @@
 
 #include <linux/device.h>	/* devres_*(), devm_ioremap_release() */
 #include <linux/gfp.h>
-#include <linux/io.h>		/* ioremap_flags() */
+#include <linux/io.h>		/* ioremap_prot() */
 #include <linux/module.h>	/* EXPORT_SYMBOL() */
 
 /**
- * devm_ioremap_prot - Managed ioremap_flags()
+ * devm_ioremap_prot - Managed ioremap_prot()
  * @dev: Generic device to remap IO address for
  * @offset: BUS offset to map
  * @size: Size of map
- * @flags: Page flags
+ * @prot: Page protection flags
  *
  * Managed ioremap_prot().  Map is automatically unmapped on driver
  * detach.
  */
 void __iomem *devm_ioremap_prot(struct device *dev, resource_size_t offset,
-				 size_t size, unsigned long flags)
+				 size_t size, pgprot_t prot)
 {
 	void __iomem **ptr, *addr;
 
@@ -31,7 +31,7 @@ void __iomem *devm_ioremap_prot(struct d
 	if (!ptr)
 		return NULL;
 
-	addr = ioremap_flags(offset, size, flags);
+	addr = ioremap_prot(offset, size, prot);
 	if (addr) {
 		*ptr = addr;
 		devres_add(dev, ptr);
diff -puN arch/sh/Kconfig~mm-make-ioremap_prot-take-a-pgprot arch/sh/Kconfig
--- a/arch/sh/Kconfig~mm-make-ioremap_prot-take-a-pgprot
+++ a/arch/sh/Kconfig
@@ -33,7 +33,7 @@ config SUPERH32
 	def_bool ARCH = "sh"
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
-	select HAVE_IOREMAP_PROT if MMU && !X2TLB
+	select HAVE_IOREMAP_PROT if MMU
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
diff -puN arch/sh/boards/mach-landisk/setup.c~mm-make-ioremap_prot-take-a-pgprot arch/sh/boards/mach-landisk/setup.c
--- a/arch/sh/boards/mach-landisk/setup.c~mm-make-ioremap_prot-take-a-pgprot
+++ a/arch/sh/boards/mach-landisk/setup.c
@@ -63,7 +63,7 @@ static int __init landisk_devices_setup(
 	/* open I/O area window */
 	paddrbase = virt_to_phys((void *)PA_AREA5_IO);
 	prot = PAGE_KERNEL_PCC(1, _PAGE_PCC_IO16);
-	cf_ide_base = ioremap_prot(paddrbase, PAGE_SIZE, pgprot_val(prot));
+	cf_ide_base = ioremap_prot(paddrbase, PAGE_SIZE, prot);
 	if (!cf_ide_base) {
 		printk("allocate_cf_area : can't open CF I/O window!\n");
 		return -ENOMEM;
diff -puN arch/sh/boards/mach-lboxre2/setup.c~mm-make-ioremap_prot-take-a-pgprot arch/sh/boards/mach-lboxre2/setup.c
--- a/arch/sh/boards/mach-lboxre2/setup.c~mm-make-ioremap_prot-take-a-pgprot
+++ a/arch/sh/boards/mach-lboxre2/setup.c
@@ -57,7 +57,7 @@ static int __init lboxre2_devices_setup(
 	paddrbase = virt_to_phys((void*)PA_AREA5_IO);
 	psize = PAGE_SIZE;
 	prot = PAGE_KERNEL_PCC(1, _PAGE_PCC_IO16);
-	cf0_io_base = (u32)ioremap_prot(paddrbase, psize, pgprot_val(prot));
+	cf0_io_base = (u32)ioremap_prot(paddrbase, psize, prot);
 	if (!cf0_io_base) {
 		printk(KERN_ERR "%s : can't open CF I/O window!\n" , __func__ );
 		return -ENOMEM;
diff -puN arch/sh/boards/mach-sh03/setup.c~mm-make-ioremap_prot-take-a-pgprot arch/sh/boards/mach-sh03/setup.c
--- a/arch/sh/boards/mach-sh03/setup.c~mm-make-ioremap_prot-take-a-pgprot
+++ a/arch/sh/boards/mach-sh03/setup.c
@@ -82,7 +82,7 @@ static int __init sh03_devices_setup(voi
 	/* open I/O area window */
 	paddrbase = virt_to_phys((void *)PA_AREA5_IO);
 	prot = PAGE_KERNEL_PCC(1, _PAGE_PCC_IO16);
-	cf_ide_base = ioremap_prot(paddrbase, PAGE_SIZE, pgprot_val(prot));
+	cf_ide_base = ioremap_prot(paddrbase, PAGE_SIZE, prot);
 	if (!cf_ide_base) {
 		printk("allocate_cf_area : can't open CF I/O window!\n");
 		return -ENOMEM;
diff -puN arch/sh/include/asm/io.h~mm-make-ioremap_prot-take-a-pgprot arch/sh/include/asm/io.h
--- a/arch/sh/include/asm/io.h~mm-make-ioremap_prot-take-a-pgprot
+++ a/arch/sh/include/asm/io.h
@@ -389,9 +389,9 @@ ioremap_cache(phys_addr_t offset, unsign
 
 #ifdef CONFIG_HAVE_IOREMAP_PROT
 static inline void __iomem *
-ioremap_prot(phys_addr_t offset, unsigned long size, unsigned long flags)
+ioremap_prot(phys_addr_t offset, unsigned long size, pgprot_t prot)
 {
-	return __ioremap_mode(offset, size, __pgprot(flags));
+	return __ioremap_mode(offset, size, prot);
 }
 #endif
 
diff -puN arch/x86/include/asm/io.h~mm-make-ioremap_prot-take-a-pgprot arch/x86/include/asm/io.h
--- a/arch/x86/include/asm/io.h~mm-make-ioremap_prot-take-a-pgprot
+++ a/arch/x86/include/asm/io.h
@@ -196,7 +196,7 @@ static inline unsigned int isa_virt_to_b
 extern void __iomem *ioremap_nocache(resource_size_t offset, unsigned long size);
 extern void __iomem *ioremap_cache(resource_size_t offset, unsigned long size);
 extern void __iomem *ioremap_prot(resource_size_t offset, unsigned long size,
-				unsigned long prot_val);
+				pgprot_t prot);
 
 /*
  * The default ioremap() behavior is non-cached:
diff -puN arch/x86/mm/ioremap.c~mm-make-ioremap_prot-take-a-pgprot arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~mm-make-ioremap_prot-take-a-pgprot
+++ a/arch/x86/mm/ioremap.c
@@ -243,9 +243,10 @@ void __iomem *ioremap_cache(resource_siz
 EXPORT_SYMBOL(ioremap_cache);
 
 void __iomem *ioremap_prot(resource_size_t phys_addr, unsigned long size,
-				unsigned long prot_val)
+				pgprot_t prot)
 {
-	return __ioremap_caller(phys_addr, size, (prot_val & _PAGE_CACHE_MASK),
+	return __ioremap_caller(phys_addr, size,
+				(pgprot_val(prot) & _PAGE_CACHE_MASK),
 				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(ioremap_prot);
diff -puN arch/x86/mm/pat.c~mm-make-ioremap_prot-take-a-pgprot arch/x86/mm/pat.c
--- a/arch/x86/mm/pat.c~mm-make-ioremap_prot-take-a-pgprot
+++ a/arch/x86/mm/pat.c
@@ -661,7 +661,6 @@ static void free_pfn_range(u64 paddr, un
 int track_pfn_vma_copy(struct vm_area_struct *vma)
 {
 	resource_size_t paddr;
-	unsigned long prot;
 	unsigned long vma_size = vma->vm_end - vma->vm_start;
 	pgprot_t pgprot;
 
@@ -670,11 +669,11 @@ int track_pfn_vma_copy(struct vm_area_st
 		 * reserve the whole chunk covered by vma. We need the
 		 * starting address and protection from pte.
 		 */
-		if (follow_phys(vma, vma->vm_start, 0, &prot, &paddr)) {
+		if (follow_phys(vma, vma->vm_start, 0, &pgprot, &paddr)) {
 			WARN_ON_ONCE(1);
 			return -EINVAL;
 		}
-		pgprot = __pgprot(prot);
+
 		return reserve_pfn_range(paddr, vma_size, &pgprot, 1);
 	}
 
diff -puN include/linux/mm.h~mm-make-ioremap_prot-take-a-pgprot include/linux/mm.h
--- a/include/linux/mm.h~mm-make-ioremap_prot-take-a-pgprot
+++ a/include/linux/mm.h
@@ -819,7 +819,7 @@ void unmap_mapping_range(struct address_
 int follow_pfn(struct vm_area_struct *vma, unsigned long address,
 	unsigned long *pfn);
 int follow_phys(struct vm_area_struct *vma, unsigned long address,
-		unsigned int flags, unsigned long *prot, resource_size_t *phys);
+		unsigned int flags, pgprot_t *prot, resource_size_t *phys);
 int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 			void *buf, int len, int write);
 
diff -puN mm/memory.c~mm-make-ioremap_prot-take-a-pgprot mm/memory.c
--- a/mm/memory.c~mm-make-ioremap_prot-take-a-pgprot
+++ a/mm/memory.c
@@ -3456,7 +3456,7 @@ EXPORT_SYMBOL(follow_pfn);
 #ifdef CONFIG_HAVE_IOREMAP_PROT
 int follow_phys(struct vm_area_struct *vma,
 		unsigned long address, unsigned int flags,
-		unsigned long *prot, resource_size_t *phys)
+		pgprot_t *prot, resource_size_t *phys)
 {
 	int ret = -EINVAL;
 	pte_t *ptep, pte;
@@ -3472,7 +3472,7 @@ int follow_phys(struct vm_area_struct *v
 	if ((flags & FOLL_WRITE) && !pte_write(pte))
 		goto unlock;
 
-	*prot = pgprot_val(pte_pgprot(pte));
+	*prot = pte_pgprot(pte);
 	*phys = (resource_size_t)pte_pfn(pte) << PAGE_SHIFT;
 
 	ret = 0;
@@ -3486,7 +3486,7 @@ int generic_access_phys(struct vm_area_s
 			void *buf, int len, int write)
 {
 	resource_size_t phys_addr;
-	unsigned long prot = 0;
+	pgprot_t prot;
 	void __iomem *maddr;
 	int offset = addr & (PAGE_SIZE-1);
 
_

Patches currently in -mm which might be from lethal@linux-sh.org are

linux-next.patch
set_rtc_mmss-show-warning-message-only-once.patch
bitops-introduce-little-endian-bitops-for-most-architectures.patch
bitops-remove-minix-bitops-from-asm-bitopsh.patch

