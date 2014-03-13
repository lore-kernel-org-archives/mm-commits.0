From: akpm@linux-foundation.org
Subject: + x86-use-generic-early_ioremap.patch added to -mm tree
Date: Thu, 13 Mar 2014 13:52:00 -0700
Message-ID: <53221a70.lhD+HfZKIYxf6FgR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42146 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbaCMUwC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Mar 2014 16:52:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, dyoung@redhat.com, catalin.marinas@arm.com, borislav.petkov@amd.com, msalter@redhat.com

Subject: + x86-use-generic-early_ioremap.patch added to -mm tree
To: msalter@redhat.com,borislav.petkov@amd.com,catalin.marinas@arm.com,dyoung@redhat.com,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de,will.deacon@arm.com
From: akpm@linux-foundation.org
Date: Thu, 13 Mar 2014 13:52:00 -0700


The patch titled
     Subject: x86: use generic early_ioremap
has been added to the -mm tree.  Its filename is
     x86-use-generic-early_ioremap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-use-generic-early_ioremap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-use-generic-early_ioremap.patch

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
Subject: x86: use generic early_ioremap

Move x86 over to the generic early ioremap implementation.

Signed-off-by: Mark Salter <msalter@redhat.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig              |    1 
 arch/x86/include/asm/Kbuild   |    1 
 arch/x86/include/asm/fixmap.h |    6 
 arch/x86/include/asm/io.h     |   15 --
 arch/x86/mm/ioremap.c         |  228 --------------------------------
 arch/x86/mm/pgtable_32.c      |    2 
 6 files changed, 13 insertions(+), 240 deletions(-)

diff -puN arch/x86/Kconfig~x86-use-generic-early_ioremap arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-use-generic-early_ioremap
+++ a/arch/x86/Kconfig
@@ -127,6 +127,7 @@ config X86
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_64
 	select HAVE_CC_STACKPROTECTOR
+	select GENERIC_EARLY_IOREMAP
 
 config INSTRUCTION_DECODER
 	def_bool y
diff -puN arch/x86/include/asm/Kbuild~x86-use-generic-early_ioremap arch/x86/include/asm/Kbuild
--- a/arch/x86/include/asm/Kbuild~x86-use-generic-early_ioremap
+++ a/arch/x86/include/asm/Kbuild
@@ -5,3 +5,4 @@ genhdr-y += unistd_64.h
 genhdr-y += unistd_x32.h
 
 generic-y += clkdev.h
+generic-y += early_ioremap.h
diff -puN arch/x86/include/asm/fixmap.h~x86-use-generic-early_ioremap arch/x86/include/asm/fixmap.h
--- a/arch/x86/include/asm/fixmap.h~x86-use-generic-early_ioremap
+++ a/arch/x86/include/asm/fixmap.h
@@ -177,5 +177,11 @@ static inline void __set_fixmap(enum fix
 
 #include <asm-generic/fixmap.h>
 
+#define __late_set_fixmap(idx, phys, flags) __set_fixmap(idx, phys, flags)
+#define __late_clear_fixmap(idx) __set_fixmap(idx, 0, __pgprot(0))
+
+void __early_set_fixmap(enum fixed_addresses idx,
+			phys_addr_t phys, pgprot_t flags);
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASM_X86_FIXMAP_H */
diff -puN arch/x86/include/asm/io.h~x86-use-generic-early_ioremap arch/x86/include/asm/io.h
--- a/arch/x86/include/asm/io.h~x86-use-generic-early_ioremap
+++ a/arch/x86/include/asm/io.h
@@ -39,6 +39,7 @@
 #include <linux/string.h>
 #include <linux/compiler.h>
 #include <asm/page.h>
+#include <asm/early_ioremap.h>
 
 #define build_mmio_read(name, size, type, reg, barrier) \
 static inline type name(const volatile void __iomem *addr) \
@@ -316,20 +317,6 @@ extern int ioremap_change_attr(unsigned
 				unsigned long prot_val);
 extern void __iomem *ioremap_wc(resource_size_t offset, unsigned long size);
 
-/*
- * early_ioremap() and early_iounmap() are for temporary early boot-time
- * mappings, before the real ioremap() is functional.
- * A boot-time mapping is currently limited to at most 16 pages.
- */
-extern void early_ioremap_init(void);
-extern void early_ioremap_reset(void);
-extern void __iomem *early_ioremap(resource_size_t phys_addr,
-				   unsigned long size);
-extern void *early_memremap(resource_size_t phys_addr,
-				    unsigned long size);
-extern void early_iounmap(void __iomem *addr, unsigned long size);
-extern void early_memunmap(void *addr, unsigned long size);
-extern void fixup_early_ioremap(void);
 extern bool is_early_ioremap_ptep(pte_t *ptep);
 
 #ifdef CONFIG_XEN
diff -puN arch/x86/mm/ioremap.c~x86-use-generic-early_ioremap arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~x86-use-generic-early_ioremap
+++ a/arch/x86/mm/ioremap.c
@@ -328,17 +328,6 @@ void unxlate_dev_mem_ptr(unsigned long p
 	return;
 }
 
-static int __initdata early_ioremap_debug;
-
-static int __init early_ioremap_debug_setup(char *str)
-{
-	early_ioremap_debug = 1;
-
-	return 0;
-}
-early_param("early_ioremap_debug", early_ioremap_debug_setup);
-
-static __initdata int after_paging_init;
 static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)] __page_aligned_bss;
 
 static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
@@ -362,18 +351,11 @@ bool __init is_early_ioremap_ptep(pte_t
 	return ptep >= &bm_pte[0] && ptep < &bm_pte[PAGE_SIZE/sizeof(pte_t)];
 }
 
-static unsigned long slot_virt[FIX_BTMAPS_SLOTS] __initdata;
-
 void __init early_ioremap_init(void)
 {
 	pmd_t *pmd;
-	int i;
 
-	if (early_ioremap_debug)
-		printk(KERN_INFO "early_ioremap_init()\n");
-
-	for (i = 0; i < FIX_BTMAPS_SLOTS; i++)
-		slot_virt[i] = __fix_to_virt(FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*i);
+	early_ioremap_setup();
 
 	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
 	memset(bm_pte, 0, sizeof(bm_pte));
@@ -402,13 +384,8 @@ void __init early_ioremap_init(void)
 	}
 }
 
-void __init early_ioremap_reset(void)
-{
-	after_paging_init = 1;
-}
-
-static void __init __early_set_fixmap(enum fixed_addresses idx,
-				      phys_addr_t phys, pgprot_t flags)
+void __init __early_set_fixmap(enum fixed_addresses idx,
+			       phys_addr_t phys, pgprot_t flags)
 {
 	unsigned long addr = __fix_to_virt(idx);
 	pte_t *pte;
@@ -425,202 +402,3 @@ static void __init __early_set_fixmap(en
 		pte_clear(&init_mm, addr, pte);
 	__flush_tlb_one(addr);
 }
-
-static inline void __init early_set_fixmap(enum fixed_addresses idx,
-					   phys_addr_t phys, pgprot_t prot)
-{
-	if (after_paging_init)
-		__set_fixmap(idx, phys, prot);
-	else
-		__early_set_fixmap(idx, phys, prot);
-}
-
-static inline void __init early_clear_fixmap(enum fixed_addresses idx)
-{
-	if (after_paging_init)
-		clear_fixmap(idx);
-	else
-		__early_set_fixmap(idx, 0, __pgprot(0));
-}
-
-static void __iomem *prev_map[FIX_BTMAPS_SLOTS] __initdata;
-static unsigned long prev_size[FIX_BTMAPS_SLOTS] __initdata;
-
-void __init fixup_early_ioremap(void)
-{
-	int i;
-
-	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
-		if (prev_map[i]) {
-			WARN_ON(1);
-			break;
-		}
-	}
-
-	early_ioremap_init();
-}
-
-static int __init check_early_ioremap_leak(void)
-{
-	int count = 0;
-	int i;
-
-	for (i = 0; i < FIX_BTMAPS_SLOTS; i++)
-		if (prev_map[i])
-			count++;
-
-	if (!count)
-		return 0;
-	WARN(1, KERN_WARNING
-	       "Debug warning: early ioremap leak of %d areas detected.\n",
-		count);
-	printk(KERN_WARNING
-		"please boot with early_ioremap_debug and report the dmesg.\n");
-
-	return 1;
-}
-late_initcall(check_early_ioremap_leak);
-
-static void __init __iomem *
-__early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
-{
-	unsigned long offset;
-	resource_size_t last_addr;
-	unsigned int nrpages;
-	enum fixed_addresses idx;
-	int i, slot;
-
-	WARN_ON(system_state != SYSTEM_BOOTING);
-
-	slot = -1;
-	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
-		if (!prev_map[i]) {
-			slot = i;
-			break;
-		}
-	}
-
-	if (slot < 0) {
-		printk(KERN_INFO "%s(%08llx, %08lx) not found slot\n",
-		       __func__, (u64)phys_addr, size);
-		WARN_ON(1);
-		return NULL;
-	}
-
-	if (early_ioremap_debug) {
-		printk(KERN_INFO "%s(%08llx, %08lx) [%d] => ",
-		       __func__, (u64)phys_addr, size, slot);
-		dump_stack();
-	}
-
-	/* Don't allow wraparound or zero size */
-	last_addr = phys_addr + size - 1;
-	if (!size || last_addr < phys_addr) {
-		WARN_ON(1);
-		return NULL;
-	}
-
-	prev_size[slot] = size;
-	/*
-	 * Mappings have to be page-aligned
-	 */
-	offset = phys_addr & ~PAGE_MASK;
-	phys_addr &= PAGE_MASK;
-	size = PAGE_ALIGN(last_addr + 1) - phys_addr;
-
-	/*
-	 * Mappings have to fit in the FIX_BTMAP area.
-	 */
-	nrpages = size >> PAGE_SHIFT;
-	if (nrpages > NR_FIX_BTMAPS) {
-		WARN_ON(1);
-		return NULL;
-	}
-
-	/*
-	 * Ok, go for it..
-	 */
-	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
-	while (nrpages > 0) {
-		early_set_fixmap(idx, phys_addr, prot);
-		phys_addr += PAGE_SIZE;
-		--idx;
-		--nrpages;
-	}
-	if (early_ioremap_debug)
-		printk(KERN_CONT "%08lx + %08lx\n", offset, slot_virt[slot]);
-
-	prev_map[slot] = (void __iomem *)(offset + slot_virt[slot]);
-	return prev_map[slot];
-}
-
-/* Remap an IO device */
-void __init __iomem *
-early_ioremap(resource_size_t phys_addr, unsigned long size)
-{
-	return __early_ioremap(phys_addr, size, PAGE_KERNEL_IO);
-}
-
-/* Remap memory */
-void __init *early_memremap(resource_size_t phys_addr, unsigned long size)
-{
-	return (__force void *)__early_ioremap(phys_addr, size, PAGE_KERNEL);
-}
-
-void __init early_iounmap(void __iomem *addr, unsigned long size)
-{
-	unsigned long virt_addr;
-	unsigned long offset;
-	unsigned int nrpages;
-	enum fixed_addresses idx;
-	int i, slot;
-
-	slot = -1;
-	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
-		if (prev_map[i] == addr) {
-			slot = i;
-			break;
-		}
-	}
-
-	if (slot < 0) {
-		printk(KERN_INFO "early_iounmap(%p, %08lx) not found slot\n",
-			 addr, size);
-		WARN_ON(1);
-		return;
-	}
-
-	if (prev_size[slot] != size) {
-		printk(KERN_INFO "early_iounmap(%p, %08lx) [%d] size not consistent %08lx\n",
-			 addr, size, slot, prev_size[slot]);
-		WARN_ON(1);
-		return;
-	}
-
-	if (early_ioremap_debug) {
-		printk(KERN_INFO "early_iounmap(%p, %08lx) [%d]\n", addr,
-		       size, slot);
-		dump_stack();
-	}
-
-	virt_addr = (unsigned long)addr;
-	if (virt_addr < fix_to_virt(FIX_BTMAP_BEGIN)) {
-		WARN_ON(1);
-		return;
-	}
-	offset = virt_addr & ~PAGE_MASK;
-	nrpages = PAGE_ALIGN(offset + size) >> PAGE_SHIFT;
-
-	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
-	while (nrpages > 0) {
-		early_clear_fixmap(idx);
-		--idx;
-		--nrpages;
-	}
-	prev_map[slot] = NULL;
-}
-
-void __init early_memunmap(void *addr, unsigned long size)
-{
-	early_iounmap((__force void __iomem *)addr, size);
-}
diff -puN arch/x86/mm/pgtable_32.c~x86-use-generic-early_ioremap arch/x86/mm/pgtable_32.c
--- a/arch/x86/mm/pgtable_32.c~x86-use-generic-early_ioremap
+++ a/arch/x86/mm/pgtable_32.c
@@ -127,7 +127,7 @@ static int __init parse_reservetop(char
 
 	address = memparse(arg, &arg);
 	reserve_top_address(address);
-	fixup_early_ioremap();
+	early_ioremap_init();
 	return 0;
 }
 early_param("reservetop", parse_reservetop);
_

Patches currently in -mm which might be from msalter@redhat.com are

arm-use-generic-fixmaph.patch
x86-mm-sparse-warning-fix-for-early_memremap.patch
mm-create-generic-early_ioremap-support.patch
x86-use-generic-early_ioremap.patch
arm64-initialize-pgprot-info-earlier-in-boot.patch
arm64-add-early_ioremap-support.patch
doc-kernel-parameterstxt-add-early_ioremap_debug.patch

