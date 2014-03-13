From: akpm@linux-foundation.org
Subject: + arm64-add-early_ioremap-support.patch added to -mm tree
Date: Thu, 13 Mar 2014 13:52:03 -0700
Message-ID: <53221a73./1MZFEwk+7Oop+vN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315AbaCMUwE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Mar 2014 16:52:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, dyoung@redhat.com, catalin.marinas@arm.com, borislav.petkov@amd.com, msalter@redhat.com

Subject: + arm64-add-early_ioremap-support.patch added to -mm tree
To: msalter@redhat.com,borislav.petkov@amd.com,catalin.marinas@arm.com,dyoung@redhat.com,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de,will.deacon@arm.com
From: akpm@linux-foundation.org
Date: Thu, 13 Mar 2014 13:52:03 -0700


The patch titled
     Subject: arm64: add early_ioremap support
has been added to the -mm tree.  Its filename is
     arm64-add-early_ioremap-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-add-early_ioremap-support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-add-early_ioremap-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark Salter <msalter@redhat.com>
Subject: arm64: add early_ioremap support

Add support for early IO or memory mappings which are needed before the
normal ioremap() is usable.  This also adds fixmap support for permanent
fixed mappings such as that used by the earlyprintk device register
region.

Signed-off-by: Mark Salter <msalter@redhat.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/arm64/memory.txt   |    4 -
 arch/arm64/Kconfig               |    1 
 arch/arm64/include/asm/Kbuild    |    1 
 arch/arm64/include/asm/fixmap.h  |   67 ++++++++++++++++++++++
 arch/arm64/include/asm/io.h      |    1 
 arch/arm64/include/asm/memory.h  |    2 
 arch/arm64/kernel/early_printk.c |    8 ++
 arch/arm64/kernel/head.S         |    9 +--
 arch/arm64/kernel/setup.c        |    2 
 arch/arm64/mm/ioremap.c          |   85 +++++++++++++++++++++++++++++
 arch/arm64/mm/mmu.c              |   41 -------------
 11 files changed, 169 insertions(+), 52 deletions(-)

diff -puN Documentation/arm64/memory.txt~arm64-add-early_ioremap-support Documentation/arm64/memory.txt
--- a/Documentation/arm64/memory.txt~arm64-add-early_ioremap-support
+++ a/Documentation/arm64/memory.txt
@@ -35,7 +35,7 @@ ffffffbc00000000	ffffffbdffffffff	   8GB
 
 ffffffbe00000000	ffffffbffbbfffff	  ~8GB		[guard, future vmmemap]
 
-ffffffbffbc00000	ffffffbffbdfffff	   2MB		earlyprintk device
+ffffffbffbc00000	ffffffbffbdfffff	   2MB		fixed mappings
 
 ffffffbffbe00000	ffffffbffbe0ffff	  64KB		PCI I/O space
 
@@ -60,7 +60,7 @@ fffffdfc00000000	fffffdfdffffffff	   8GB
 
 fffffdfe00000000	fffffdfffbbfffff	  ~8GB		[guard, future vmmemap]
 
-fffffdfffbc00000	fffffdfffbdfffff	   2MB		earlyprintk device
+fffffdfffbc00000	fffffdfffbdfffff	   2MB		fixed mappings
 
 fffffdfffbe00000	fffffdfffbe0ffff	  64KB		PCI I/O space
 
diff -puN arch/arm64/Kconfig~arm64-add-early_ioremap-support arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~arm64-add-early_ioremap-support
+++ a/arch/arm64/Kconfig
@@ -16,6 +16,7 @@ config ARM64
 	select DCACHE_WORD_ACCESS
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
+	select GENERIC_EARLY_IOREMAP
 	select GENERIC_IOMAP
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
diff -puN arch/arm64/include/asm/Kbuild~arm64-add-early_ioremap-support arch/arm64/include/asm/Kbuild
--- a/arch/arm64/include/asm/Kbuild~arm64-add-early_ioremap-support
+++ a/arch/arm64/include/asm/Kbuild
@@ -10,6 +10,7 @@ generic-y += delay.h
 generic-y += div64.h
 generic-y += dma.h
 generic-y += emergency-restart.h
+generic-y += early_ioremap.h
 generic-y += errno.h
 generic-y += ftrace.h
 generic-y += hw_irq.h
diff -puN /dev/null arch/arm64/include/asm/fixmap.h
--- /dev/null
+++ a/arch/arm64/include/asm/fixmap.h
@@ -0,0 +1,67 @@
+/*
+ * fixmap.h: compile-time virtual memory allocation
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 1998 Ingo Molnar
+ * Copyright (C) 2013 Mark Salter <msalter@redhat.com>
+ *
+ * Adapted from arch/x86_64 version.
+ *
+ */
+
+#ifndef _ASM_ARM64_FIXMAP_H
+#define _ASM_ARM64_FIXMAP_H
+
+#ifndef __ASSEMBLY__
+#include <linux/kernel.h>
+#include <asm/page.h>
+
+/*
+ * Here we define all the compile-time 'special' virtual
+ * addresses. The point is to have a constant address at
+ * compile time, but to set the physical address only
+ * in the boot process.
+ *
+ * These 'compile-time allocated' memory buffers are
+ * page-sized. Use set_fixmap(idx,phys) to associate
+ * physical memory with fixmap indices.
+ *
+ */
+enum fixed_addresses {
+	FIX_EARLYCON_MEM_BASE,
+	__end_of_permanent_fixed_addresses,
+
+	/*
+	 * Temporary boot-time mappings, used by early_ioremap(),
+	 * before ioremap() is functional.
+	 */
+#ifdef CONFIG_ARM64_64K_PAGES
+#define NR_FIX_BTMAPS		4
+#else
+#define NR_FIX_BTMAPS		64
+#endif
+#define FIX_BTMAPS_SLOTS	7
+#define TOTAL_FIX_BTMAPS	(NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)
+
+	FIX_BTMAP_END = __end_of_permanent_fixed_addresses,
+	FIX_BTMAP_BEGIN = FIX_BTMAP_END + TOTAL_FIX_BTMAPS - 1,
+	__end_of_fixed_addresses
+};
+
+#define FIXADDR_SIZE	(__end_of_permanent_fixed_addresses << PAGE_SHIFT)
+#define FIXADDR_START	(FIXADDR_TOP - FIXADDR_SIZE)
+
+#define FIXMAP_PAGE_IO     __pgprot(PROT_DEVICE_nGnRE)
+
+extern void __early_set_fixmap(enum fixed_addresses idx,
+			       phys_addr_t phys, pgprot_t flags);
+
+#define __set_fixmap __early_set_fixmap
+
+#include <asm-generic/fixmap.h>
+
+#endif /* !__ASSEMBLY__ */
+#endif /* _ASM_ARM64_FIXMAP_H */
diff -puN arch/arm64/include/asm/io.h~arm64-add-early_ioremap-support arch/arm64/include/asm/io.h
--- a/arch/arm64/include/asm/io.h~arm64-add-early_ioremap-support
+++ a/arch/arm64/include/asm/io.h
@@ -27,6 +27,7 @@
 #include <asm/byteorder.h>
 #include <asm/barrier.h>
 #include <asm/pgtable.h>
+#include <asm/early_ioremap.h>
 
 #include <xen/xen.h>
 
diff -puN arch/arm64/include/asm/memory.h~arm64-add-early_ioremap-support arch/arm64/include/asm/memory.h
--- a/arch/arm64/include/asm/memory.h~arm64-add-early_ioremap-support
+++ a/arch/arm64/include/asm/memory.h
@@ -49,7 +49,7 @@
 #define PAGE_OFFSET		(UL(0xffffffffffffffff) << (VA_BITS - 1))
 #define MODULES_END		(PAGE_OFFSET)
 #define MODULES_VADDR		(MODULES_END - SZ_64M)
-#define EARLYCON_IOBASE		(MODULES_VADDR - SZ_4M)
+#define FIXADDR_TOP		(MODULES_VADDR - SZ_2M - PAGE_SIZE)
 #define TASK_SIZE_64		(UL(1) << VA_BITS)
 
 #ifdef CONFIG_COMPAT
diff -puN arch/arm64/kernel/early_printk.c~arm64-add-early_ioremap-support arch/arm64/kernel/early_printk.c
--- a/arch/arm64/kernel/early_printk.c~arm64-add-early_ioremap-support
+++ a/arch/arm64/kernel/early_printk.c
@@ -26,6 +26,8 @@
 #include <linux/amba/serial.h>
 #include <linux/serial_reg.h>
 
+#include <asm/fixmap.h>
+
 static void __iomem *early_base;
 static void (*printch)(char ch);
 
@@ -141,8 +143,10 @@ static int __init setup_early_printk(cha
 	}
 	/* no options parsing yet */
 
-	if (paddr)
-		early_base = early_io_map(paddr, EARLYCON_IOBASE);
+	if (paddr) {
+		set_fixmap_io(FIX_EARLYCON_MEM_BASE, paddr);
+		early_base = (void __iomem *)fix_to_virt(FIX_EARLYCON_MEM_BASE);
+	}
 
 	printch = match->printch;
 	early_console = &early_console_dev;
diff -puN arch/arm64/kernel/head.S~arm64-add-early_ioremap-support arch/arm64/kernel/head.S
--- a/arch/arm64/kernel/head.S~arm64-add-early_ioremap-support
+++ a/arch/arm64/kernel/head.S
@@ -412,7 +412,7 @@ ENDPROC(__calc_phys_offset)
  *   - identity mapping to enable the MMU (low address, TTBR0)
  *   - first few MB of the kernel linear mapping to jump to once the MMU has
  *     been enabled, including the FDT blob (TTBR1)
- *   - UART mapping if CONFIG_EARLY_PRINTK is enabled (TTBR1)
+ *   - pgd entry for fixed mappings (TTBR1)
  */
 __create_page_tables:
 	pgtbl	x25, x26, x24			// idmap_pg_dir and swapper_pg_dir addresses
@@ -465,15 +465,12 @@ __create_page_tables:
 	sub	x6, x6, #1			// inclusive range
 	create_block_map x0, x7, x3, x5, x6
 1:
-#ifdef CONFIG_EARLY_PRINTK
 	/*
-	 * Create the pgd entry for the UART mapping. The full mapping is done
-	 * later based earlyprintk kernel parameter.
+	 * Create the pgd entry for the fixed mappings.
 	 */
-	ldr	x5, =EARLYCON_IOBASE		// UART virtual address
+	ldr	x5, =FIXADDR_TOP		// Fixed mapping virtual address
 	add	x0, x26, #2 * PAGE_SIZE		// section table address
 	create_pgd_entry x26, x0, x5, x6, x7
-#endif
 	ret
 ENDPROC(__create_page_tables)
 	.ltorg
diff -puN arch/arm64/kernel/setup.c~arm64-add-early_ioremap-support arch/arm64/kernel/setup.c
--- a/arch/arm64/kernel/setup.c~arm64-add-early_ioremap-support
+++ a/arch/arm64/kernel/setup.c
@@ -42,6 +42,7 @@
 #include <linux/of_fdt.h>
 #include <linux/of_platform.h>
 
+#include <asm/fixmap.h>
 #include <asm/cputype.h>
 #include <asm/elf.h>
 #include <asm/cputable.h>
@@ -328,6 +329,7 @@ void __init setup_arch(char **cmdline_p)
 	*cmdline_p = boot_command_line;
 
 	init_mem_pgprot();
+	early_ioremap_init();
 
 	parse_early_param();
 
diff -puN arch/arm64/mm/ioremap.c~arm64-add-early_ioremap-support arch/arm64/mm/ioremap.c
--- a/arch/arm64/mm/ioremap.c~arm64-add-early_ioremap-support
+++ a/arch/arm64/mm/ioremap.c
@@ -25,6 +25,10 @@
 #include <linux/vmalloc.h>
 #include <linux/io.h>
 
+#include <asm/fixmap.h>
+#include <asm/tlbflush.h>
+#include <asm/pgalloc.h>
+
 static void __iomem *__ioremap_caller(phys_addr_t phys_addr, size_t size,
 				      pgprot_t prot, void *caller)
 {
@@ -98,3 +102,84 @@ void __iomem *ioremap_cache(phys_addr_t
 				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(ioremap_cache);
+
+#ifndef CONFIG_ARM64_64K_PAGES
+static pte_t bm_pte[PTRS_PER_PTE] __page_aligned_bss;
+#endif
+
+static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+
+	pgd = pgd_offset_k(addr);
+	BUG_ON(pgd_none(*pgd) || pgd_bad(*pgd));
+
+	pud = pud_offset(pgd, addr);
+	BUG_ON(pud_none(*pud) || pud_bad(*pud));
+
+	return pmd_offset(pud, addr);
+}
+
+static inline pte_t * __init early_ioremap_pte(unsigned long addr)
+{
+	pmd_t *pmd = early_ioremap_pmd(addr);
+
+	BUG_ON(pmd_none(*pmd) || pmd_bad(*pmd));
+
+	return pte_offset_kernel(pmd, addr);
+}
+
+void __init early_ioremap_init(void)
+{
+	pmd_t *pmd;
+
+	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
+#ifndef CONFIG_ARM64_64K_PAGES
+	/* need to populate pmd for 4k pagesize only */
+	pmd_populate_kernel(&init_mm, pmd, bm_pte);
+#endif
+	/*
+	 * The boot-ioremap range spans multiple pmds, for which
+	 * we are not prepared:
+	 */
+	BUILD_BUG_ON((__fix_to_virt(FIX_BTMAP_BEGIN) >> PMD_SHIFT)
+		     != (__fix_to_virt(FIX_BTMAP_END) >> PMD_SHIFT));
+
+	if (pmd != early_ioremap_pmd(fix_to_virt(FIX_BTMAP_END))) {
+		WARN_ON(1);
+		pr_warn("pmd %p != %p\n",
+			pmd, early_ioremap_pmd(fix_to_virt(FIX_BTMAP_END)));
+		pr_warn("fix_to_virt(FIX_BTMAP_BEGIN): %08lx\n",
+			fix_to_virt(FIX_BTMAP_BEGIN));
+		pr_warn("fix_to_virt(FIX_BTMAP_END):   %08lx\n",
+			fix_to_virt(FIX_BTMAP_END));
+
+		pr_warn("FIX_BTMAP_END:       %d\n", FIX_BTMAP_END);
+		pr_warn("FIX_BTMAP_BEGIN:     %d\n",
+			FIX_BTMAP_BEGIN);
+	}
+
+	early_ioremap_setup();
+}
+
+void __init __early_set_fixmap(enum fixed_addresses idx,
+			       phys_addr_t phys, pgprot_t flags)
+{
+	unsigned long addr = __fix_to_virt(idx);
+	pte_t *pte;
+
+	if (idx >= __end_of_fixed_addresses) {
+		BUG();
+		return;
+	}
+
+	pte = early_ioremap_pte(addr);
+
+	if (pgprot_val(flags))
+		set_pte(pte, pfn_pte(phys >> PAGE_SHIFT, flags));
+	else {
+		pte_clear(&init_mm, addr, pte);
+		flush_tlb_kernel_range(addr, addr+PAGE_SIZE);
+	}
+}
diff -puN arch/arm64/mm/mmu.c~arm64-add-early_ioremap-support arch/arm64/mm/mmu.c
--- a/arch/arm64/mm/mmu.c~arm64-add-early_ioremap-support
+++ a/arch/arm64/mm/mmu.c
@@ -260,47 +260,6 @@ static void __init create_mapping(phys_a
 	} while (pgd++, addr = next, addr != end);
 }
 
-#ifdef CONFIG_EARLY_PRINTK
-/*
- * Create an early I/O mapping using the pgd/pmd entries already populated
- * in head.S as this function is called too early to allocated any memory. The
- * mapping size is 2MB with 4KB pages or 64KB or 64KB pages.
- */
-void __iomem * __init early_io_map(phys_addr_t phys, unsigned long virt)
-{
-	unsigned long size, mask;
-	bool page64k = IS_ENABLED(CONFIG_ARM64_64K_PAGES);
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-
-	/*
-	 * No early pte entries with !ARM64_64K_PAGES configuration, so using
-	 * sections (pmd).
-	 */
-	size = page64k ? PAGE_SIZE : SECTION_SIZE;
-	mask = ~(size - 1);
-
-	pgd = pgd_offset_k(virt);
-	pud = pud_offset(pgd, virt);
-	if (pud_none(*pud))
-		return NULL;
-	pmd = pmd_offset(pud, virt);
-
-	if (page64k) {
-		if (pmd_none(*pmd))
-			return NULL;
-		pte = pte_offset_kernel(pmd, virt);
-		set_pte(pte, __pte((phys & mask) | PROT_DEVICE_nGnRE));
-	} else {
-		set_pmd(pmd, __pmd((phys & mask) | PROT_SECT_DEVICE_nGnRE));
-	}
-
-	return (void __iomem *)((virt & mask) + (phys & ~mask));
-}
-#endif
