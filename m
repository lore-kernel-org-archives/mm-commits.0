From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 010/127] arm: add support for folded p4d page
 tables
Date: Thu, 04 Jun 2020 16:46:19 -0700
Message-ID: <20200604234619.TUv8Y5R1S%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726117AbgFDXqV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:46:21 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, bcain@codeaurora.org, benh@kernel.crashing.org, catalin.marinas@arm.com, christophe.leroy@c-s.fr, dalias@libc.org, fenghua.yu@intel.com, geert+renesas@glider.be, gxt@pku.edu.cn, james.morse@arm.com, jonas@southpole.se, julien.thierry.kdev@gmail.com, ley.foon.tan@intel.com, linux-mm@kvack.org, linux@armlinux.org.uk, m.szyprowski@samsung.com, maz@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, rppt@linux.ibm.com, shorne@gmail.com, stefan.kristiansson@saunalahti.fi, suzuki.poulose@arm.com, tony.luck@intel.com, torvalds@linux-foundation.org, will@kernel.org, ysato@users.sourceforge.jp

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: arm: add support for folded p4d page tables

Implement primitives necessary for the 4th level folding, add walks of p4d
level where appropriate, and remove __ARCH_USE_5LEVEL_HACK.

[rppt@linux.ibm.com: fix kexec]
  Link: http://lkml.kernel.org/r/20200508174232.GA759899@linux.ibm.com
Link: http://lkml.kernel.org/r/20200414153455.21744-3-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: James Morse <james.morse@arm.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable.h     |    1 
 arch/arm/lib/uaccess_with_memcpy.c |    7 ++++
 arch/arm/mach-sa1100/assabet.c     |    2 -
 arch/arm/mm/dump.c                 |   29 +++++++++++++++----
 arch/arm/mm/fault-armv.c           |    7 ++++
 arch/arm/mm/fault.c                |   22 +++++++++-----
 arch/arm/mm/idmap.c                |    3 +-
 arch/arm/mm/init.c                 |    2 -
 arch/arm/mm/ioremap.c              |   12 ++++++--
 arch/arm/mm/mm.h                   |    2 -
 arch/arm/mm/mmu.c                  |   35 +++++++++++++++++++----
 arch/arm/mm/pgd.c                  |   40 ++++++++++++++++++++++-----
 12 files changed, 125 insertions(+), 37 deletions(-)

--- a/arch/arm/include/asm/pgtable.h~arm-add-support-for-folded-p4d-page-tables
+++ a/arch/arm/include/asm/pgtable.h
@@ -17,7 +17,6 @@
 
 #else
 
-#define __ARCH_USE_5LEVEL_HACK
 #include <asm-generic/pgtable-nopud.h>
 #include <asm/memory.h>
 #include <asm/pgtable-hwdef.h>
--- a/arch/arm/lib/uaccess_with_memcpy.c~arm-add-support-for-folded-p4d-page-tables
+++ a/arch/arm/lib/uaccess_with_memcpy.c
@@ -24,6 +24,7 @@ pin_page_for_write(const void __user *_a
 {
 	unsigned long addr = (unsigned long)_addr;
 	pgd_t *pgd;
+	p4d_t *p4d;
 	pmd_t *pmd;
 	pte_t *pte;
 	pud_t *pud;
@@ -33,7 +34,11 @@ pin_page_for_write(const void __user *_a
 	if (unlikely(pgd_none(*pgd) || pgd_bad(*pgd)))
 		return 0;
 
-	pud = pud_offset(pgd, addr);
+	p4d = p4d_offset(pgd, addr);
+	if (unlikely(p4d_none(*p4d) || p4d_bad(*p4d)))
+		return 0;
+
+	pud = pud_offset(p4d, addr);
 	if (unlikely(pud_none(*pud) || pud_bad(*pud)))
 		return 0;
 
--- a/arch/arm/mach-sa1100/assabet.c~arm-add-support-for-folded-p4d-page-tables
+++ a/arch/arm/mach-sa1100/assabet.c
@@ -633,7 +633,7 @@ static void __init map_sa1100_gpio_regs(
 	int prot = PMD_TYPE_SECT | PMD_SECT_AP_WRITE | PMD_DOMAIN(DOMAIN_IO);
 	pmd_t *pmd;
 
-	pmd = pmd_offset(pud_offset(pgd_offset_k(virt), virt), virt);
+	pmd = pmd_offset(pud_offset(p4d_offset(pgd_offset_k(virt), virt), virt), virt);
 	*pmd = __pmd(phys | prot);
 	flush_pmd_entry(pmd);
 }
--- a/arch/arm/mm/dump.c~arm-add-support-for-folded-p4d-page-tables
+++ a/arch/arm/mm/dump.c
@@ -207,6 +207,7 @@ struct pg_level {
 static struct pg_level pg_level[] = {
 	{
 	}, { /* pgd */
+	}, { /* p4d */
 	}, { /* pud */
 	}, { /* pmd */
 		.bits	= section_bits,
@@ -308,7 +309,7 @@ static void walk_pte(struct pg_state *st
 
 	for (i = 0; i < PTRS_PER_PTE; i++, pte++) {
 		addr = start + i * PAGE_SIZE;
-		note_page(st, addr, 4, pte_val(*pte), domain);
+		note_page(st, addr, 5, pte_val(*pte), domain);
 	}
 }
 
@@ -350,14 +351,14 @@ static void walk_pmd(struct pg_state *st
 			addr += SECTION_SIZE;
 			pmd++;
 			domain = get_domain_name(pmd);
-			note_page(st, addr, 3, pmd_val(*pmd), domain);
+			note_page(st, addr, 4, pmd_val(*pmd), domain);
 		}
 	}
 }
 
-static void walk_pud(struct pg_state *st, pgd_t *pgd, unsigned long start)
+static void walk_pud(struct pg_state *st, p4d_t *p4d, unsigned long start)
 {
-	pud_t *pud = pud_offset(pgd, 0);
+	pud_t *pud = pud_offset(p4d, 0);
 	unsigned long addr;
 	unsigned i;
 
@@ -366,7 +367,23 @@ static void walk_pud(struct pg_state *st
 		if (!pud_none(*pud)) {
 			walk_pmd(st, pud, addr);
 		} else {
-			note_page(st, addr, 2, pud_val(*pud), NULL);
+			note_page(st, addr, 3, pud_val(*pud), NULL);
+		}
+	}
+}
+
+static void walk_p4d(struct pg_state *st, pgd_t *pgd, unsigned long start)
+{
+	p4d_t *p4d = p4d_offset(pgd, 0);
+	unsigned long addr;
+	unsigned i;
+
+	for (i = 0; i < PTRS_PER_P4D; i++, p4d++) {
+		addr = start + i * P4D_SIZE;
+		if (!p4d_none(*p4d)) {
+			walk_pud(st, p4d, addr);
+		} else {
+			note_page(st, addr, 2, p4d_val(*p4d), NULL);
 		}
 	}
 }
@@ -381,7 +398,7 @@ static void walk_pgd(struct pg_state *st
 	for (i = 0; i < PTRS_PER_PGD; i++, pgd++) {
 		addr = start + i * PGDIR_SIZE;
 		if (!pgd_none(*pgd)) {
-			walk_pud(st, pgd, addr);
+			walk_p4d(st, pgd, addr);
 		} else {
 			note_page(st, addr, 1, pgd_val(*pgd), NULL);
 		}
--- a/arch/arm/mm/fault-armv.c~arm-add-support-for-folded-p4d-page-tables
+++ a/arch/arm/mm/fault-armv.c
@@ -91,6 +91,7 @@ static int adjust_pte(struct vm_area_str
 {
 	spinlock_t *ptl;
 	pgd_t *pgd;
+	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
@@ -100,7 +101,11 @@ static int adjust_pte(struct vm_area_str
 	if (pgd_none_or_clear_bad(pgd))
 		return 0;
 
-	pud = pud_offset(pgd, address);
+	p4d = p4d_offset(pgd, address);
+	if (p4d_none_or_clear_bad(p4d))
+		return 0;
+
+	pud = pud_offset(p4d, address);
 	if (pud_none_or_clear_bad(pud))
 		return 0;
 
--- a/arch/arm/mm/fault.c~arm-add-support-for-folded-p4d-page-tables
+++ a/arch/arm/mm/fault.c
@@ -43,19 +43,21 @@ void show_pte(const char *lvl, struct mm
 	printk("%s[%08lx] *pgd=%08llx", lvl, addr, (long long)pgd_val(*pgd));
 
 	do {
+		p4d_t *p4d;
 		pud_t *pud;
 		pmd_t *pmd;
 		pte_t *pte;
 
-		if (pgd_none(*pgd))
+		p4d = p4d_offset(pgd, addr);
+		if (p4d_none(*p4d))
 			break;
 
-		if (pgd_bad(*pgd)) {
+		if (p4d_bad(*p4d)) {
 			pr_cont("(bad)");
 			break;
 		}
 
-		pud = pud_offset(pgd, addr);
+		pud = pud_offset(p4d, addr);
 		if (PTRS_PER_PUD != 1)
 			pr_cont(", *pud=%08llx", (long long)pud_val(*pud));
 
@@ -405,6 +407,7 @@ do_translation_fault(unsigned long addr,
 {
 	unsigned int index;
 	pgd_t *pgd, *pgd_k;
+	p4d_t *p4d, *p4d_k;
 	pud_t *pud, *pud_k;
 	pmd_t *pmd, *pmd_k;
 
@@ -419,13 +422,16 @@ do_translation_fault(unsigned long addr,
 	pgd = cpu_get_pgd() + index;
 	pgd_k = init_mm.pgd + index;
 
-	if (pgd_none(*pgd_k))
+	p4d = p4d_offset(pgd, addr);
+	p4d_k = p4d_offset(pgd_k, addr);
+
+	if (p4d_none(*p4d_k))
 		goto bad_area;
-	if (!pgd_present(*pgd))
-		set_pgd(pgd, *pgd_k);
+	if (!p4d_present(*p4d))
+		set_p4d(p4d, *p4d_k);
 
-	pud = pud_offset(pgd, addr);
-	pud_k = pud_offset(pgd_k, addr);
+	pud = pud_offset(p4d, addr);
+	pud_k = pud_offset(p4d_k, addr);
 
 	if (pud_none(*pud_k))
 		goto bad_area;
--- a/arch/arm/mm/idmap.c~arm-add-support-for-folded-p4d-page-tables
+++ a/arch/arm/mm/idmap.c
@@ -68,7 +68,8 @@ static void idmap_add_pmd(pud_t *pud, un
 static void idmap_add_pud(pgd_t *pgd, unsigned long addr, unsigned long end,
 	unsigned long prot)
 {
-	pud_t *pud = pud_offset(pgd, addr);
+	p4d_t *p4d = p4d_offset(pgd, addr);
+	pud_t *pud = pud_offset(p4d, addr);
 	unsigned long next;
 
 	do {
--- a/arch/arm/mm/init.c~arm-add-support-for-folded-p4d-page-tables
+++ a/arch/arm/mm/init.c
@@ -519,7 +519,7 @@ static inline void section_update(unsign
 {
 	pmd_t *pmd;
 
-	pmd = pmd_offset(pud_offset(pgd_offset(mm, addr), addr), addr);
+	pmd = pmd_offset(pud_offset(p4d_offset(pgd_offset(mm, addr), addr), addr), addr);
 
 #ifdef CONFIG_ARM_LPAE
 	pmd[0] = __pmd((pmd_val(pmd[0]) & mask) | prot);
--- a/arch/arm/mm/ioremap.c~arm-add-support-for-folded-p4d-page-tables
+++ a/arch/arm/mm/ioremap.c
@@ -142,12 +142,14 @@ static void unmap_area_sections(unsigned
 {
 	unsigned long addr = virt, end = virt + (size & ~(SZ_1M - 1));
 	pgd_t *pgd;
+	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmdp;
 
 	flush_cache_vunmap(addr, end);
 	pgd = pgd_offset_k(addr);
-	pud = pud_offset(pgd, addr);
+	p4d = p4d_offset(pgd, addr);
+	pud = pud_offset(p4d, addr);
 	pmdp = pmd_offset(pud, addr);
 	do {
 		pmd_t pmd = *pmdp;
@@ -190,6 +192,7 @@ remap_area_sections(unsigned long virt,
 {
 	unsigned long addr = virt, end = virt + size;
 	pgd_t *pgd;
+	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
 
@@ -200,7 +203,8 @@ remap_area_sections(unsigned long virt,
 	unmap_area_sections(virt, size);
 
 	pgd = pgd_offset_k(addr);
-	pud = pud_offset(pgd, addr);
+	p4d = p4d_offset(pgd, addr);
+	pud = pud_offset(p4d, addr);
 	pmd = pmd_offset(pud, addr);
 	do {
 		pmd[0] = __pmd(__pfn_to_phys(pfn) | type->prot_sect);
@@ -222,6 +226,7 @@ remap_area_supersections(unsigned long v
 {
 	unsigned long addr = virt, end = virt + size;
 	pgd_t *pgd;
+	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
 
@@ -232,7 +237,8 @@ remap_area_supersections(unsigned long v
 	unmap_area_sections(virt, size);
 
 	pgd = pgd_offset_k(virt);
-	pud = pud_offset(pgd, addr);
+	p4d = p4d_offset(pgd, addr);
+	pud = pud_offset(p4d, addr);
 	pmd = pmd_offset(pud, addr);
 	do {
 		unsigned long super_pmd_val, i;
--- a/arch/arm/mm/mm.h~arm-add-support-for-folded-p4d-page-tables
+++ a/arch/arm/mm/mm.h
@@ -38,7 +38,7 @@ static inline pte_t get_top_pte(unsigned
 
 static inline pmd_t *pmd_off_k(unsigned long virt)
 {
-	return pmd_offset(pud_offset(pgd_offset_k(virt), virt), virt);
+	return pmd_offset(pud_offset(p4d_offset(pgd_offset_k(virt), virt), virt), virt);
 }
 
 struct mem_type {
--- a/arch/arm/mm/mmu.c~arm-add-support-for-folded-p4d-page-tables
+++ a/arch/arm/mm/mmu.c
@@ -357,7 +357,8 @@ static pte_t *pte_offset_late_fixmap(pmd
 static inline pmd_t * __init fixmap_pmd(unsigned long addr)
 {
 	pgd_t *pgd = pgd_offset_k(addr);
-	pud_t *pud = pud_offset(pgd, addr);
+	p4d_t *p4d = p4d_offset(pgd, addr);
+	pud_t *pud = pud_offset(p4d, addr);
 	pmd_t *pmd = pmd_offset(pud, addr);
 
 	return pmd;
@@ -801,12 +802,12 @@ static void __init alloc_init_pmd(pud_t
 	} while (pmd++, addr = next, addr != end);
 }
 
-static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
+static void __init alloc_init_pud(p4d_t *p4d, unsigned long addr,
 				  unsigned long end, phys_addr_t phys,
 				  const struct mem_type *type,
 				  void *(*alloc)(unsigned long sz), bool ng)
 {
-	pud_t *pud = pud_offset(pgd, addr);
+	pud_t *pud = pud_offset(p4d, addr);
 	unsigned long next;
 
 	do {
@@ -816,6 +817,21 @@ static void __init alloc_init_pud(pgd_t
 	} while (pud++, addr = next, addr != end);
 }
 
+static void __init alloc_init_p4d(pgd_t *pgd, unsigned long addr,
+				  unsigned long end, phys_addr_t phys,
+				  const struct mem_type *type,
+				  void *(*alloc)(unsigned long sz), bool ng)
+{
+	p4d_t *p4d = p4d_offset(pgd, addr);
+	unsigned long next;
+
+	do {
+		next = p4d_addr_end(addr, end);
+		alloc_init_pud(p4d, addr, next, phys, type, alloc, ng);
+		phys += next - addr;
+	} while (p4d++, addr = next, addr != end);
+}
+
 #ifndef CONFIG_ARM_LPAE
 static void __init create_36bit_mapping(struct mm_struct *mm,
 					struct map_desc *md,
@@ -863,7 +879,8 @@ static void __init create_36bit_mapping(
 	pgd = pgd_offset(mm, addr);
 	end = addr + length;
 	do {
-		pud_t *pud = pud_offset(pgd, addr);
+		p4d_t *p4d = p4d_offset(pgd, addr);
+		pud_t *pud = pud_offset(p4d, addr);
 		pmd_t *pmd = pmd_offset(pud, addr);
 		int i;
 
@@ -914,7 +931,7 @@ static void __init __create_mapping(stru
 	do {
 		unsigned long next = pgd_addr_end(addr, end);
 
-		alloc_init_pud(pgd, addr, next, phys, type, alloc, ng);
+		alloc_init_p4d(pgd, addr, next, phys, type, alloc, ng);
 
 		phys += next - addr;
 		addr = next;
@@ -950,7 +967,13 @@ void __init create_mapping_late(struct m
 				bool ng)
 {
 #ifdef CONFIG_ARM_LPAE
-	pud_t *pud = pud_alloc(mm, pgd_offset(mm, md->virtual), md->virtual);
+	p4d_t *p4d;
+	pud_t *pud;
+
+	p4d = p4d_alloc(mm, pgd_offset(mm, md->virtual), md->virtual);
+	if (!WARN_ON(!p4d))
+		return;
+	pud = pud_alloc(mm, p4d, md->virtual);
 	if (WARN_ON(!pud))
 		return;
 	pmd_alloc(mm, pud, 0);
--- a/arch/arm/mm/pgd.c~arm-add-support-for-folded-p4d-page-tables
+++ a/arch/arm/mm/pgd.c
@@ -30,6 +30,7 @@
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	pgd_t *new_pgd, *init_pgd;
+	p4d_t *new_p4d, *init_p4d;
 	pud_t *new_pud, *init_pud;
 	pmd_t *new_pmd, *init_pmd;
 	pte_t *new_pte, *init_pte;
@@ -53,8 +54,12 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	/*
 	 * Allocate PMD table for modules and pkmap mappings.
 	 */
-	new_pud = pud_alloc(mm, new_pgd + pgd_index(MODULES_VADDR),
+	new_p4d = p4d_alloc(mm, new_pgd + pgd_index(MODULES_VADDR),
 			    MODULES_VADDR);
+	if (!new_p4d)
+		goto no_p4d;
+
+	new_pud = pud_alloc(mm, new_p4d, MODULES_VADDR);
 	if (!new_pud)
 		goto no_pud;
 
@@ -69,7 +74,11 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 		 * contains the machine vectors. The vectors are always high
 		 * with LPAE.
 		 */
-		new_pud = pud_alloc(mm, new_pgd, 0);
+		new_p4d = p4d_alloc(mm, new_pgd, 0);
+		if (!new_p4d)
+			goto no_p4d;
+
+		new_pud = pud_alloc(mm, new_p4d, 0);
 		if (!new_pud)
 			goto no_pud;
 
@@ -91,7 +100,8 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 		pmd_val(*new_pmd) |= PMD_DOMAIN(DOMAIN_VECTORS);
 #endif
 
-		init_pud = pud_offset(init_pgd, 0);
+		init_p4d = p4d_offset(init_pgd, 0);
+		init_pud = pud_offset(init_p4d, 0);
 		init_pmd = pmd_offset(init_pud, 0);
 		init_pte = pte_offset_map(init_pmd, 0);
 		set_pte_ext(new_pte + 0, init_pte[0], 0);
@@ -108,6 +118,8 @@ no_pte:
 no_pmd:
 	pud_free(mm, new_pud);
 no_pud:
+	p4d_free(mm, new_p4d);
+no_p4d:
 	__pgd_free(new_pgd);
 no_pgd:
 	return NULL;
@@ -116,6 +128,7 @@ no_pgd:
 void pgd_free(struct mm_struct *mm, pgd_t *pgd_base)
 {
 	pgd_t *pgd;
+	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
 	pgtable_t pte;
@@ -127,7 +140,11 @@ void pgd_free(struct mm_struct *mm, pgd_
 	if (pgd_none_or_clear_bad(pgd))
 		goto no_pgd;
 
-	pud = pud_offset(pgd, 0);
+	p4d = p4d_offset(pgd, 0);
+	if (p4d_none_or_clear_bad(p4d))
+		goto no_p4d;
+
+	pud = pud_offset(p4d, 0);
 	if (pud_none_or_clear_bad(pud))
 		goto no_pud;
 
@@ -144,8 +161,11 @@ no_pmd:
 	pmd_free(mm, pmd);
 	mm_dec_nr_pmds(mm);
 no_pud:
-	pgd_clear(pgd);
+	p4d_clear(p4d);
 	pud_free(mm, pud);
+no_p4d:
+	pgd_clear(pgd);
+	p4d_free(mm, p4d);
 no_pgd:
 #ifdef CONFIG_ARM_LPAE
 	/*
@@ -156,15 +176,21 @@ no_pgd:
 			continue;
 		if (pgd_val(*pgd) & L_PGD_SWAPPER)
 			continue;
-		pud = pud_offset(pgd, 0);
+		p4d = p4d_offset(pgd, 0);
+		if (p4d_none_or_clear_bad(p4d))
+			continue;
+		pud = pud_offset(p4d, 0);
 		if (pud_none_or_clear_bad(pud))
 			continue;
 		pmd = pmd_offset(pud, 0);
 		pud_clear(pud);
 		pmd_free(mm, pmd);
 		mm_dec_nr_pmds(mm);
-		pgd_clear(pgd);
+		p4d_clear(p4d);
 		pud_free(mm, pud);
+		mm_dec_nr_puds(mm);
+		pgd_clear(pgd);
+		p4d_free(mm, p4d);
 	}
 #endif
 	__pgd_free(pgd_base);
_
