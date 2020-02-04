From: akpm@linux-foundation.org
Subject: [merged]
 x86-mm-convert-dump_pagetables-to-use-walk_page_range.patch removed from
 -mm tree
Date: Tue, 04 Feb 2020 10:41:45 -0800
Message-ID: <20200204184145.d9sAnlH2W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727480AbgBDSls (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:41:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex@ghiti.fr, aou@eecs.berkeley.edu, ard.biesheuvel@linaro.org, arnd@arndb.de, benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com, dave.hansen@linux.intel.com, davem@davemloft.net, gor@linux.ibm.com, heiko.carstens@de.ibm.com, hpa@zytor.com, james.morse@arm.com, jglisse@redhat.com, jhogan@kernel.org, kan.liang@linux.intel.com, linux@armlinux.org.uk, luto@kernel.org, mark.rutland@arm.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paul.burton@mips.com, paul.walmsley@sifive.com, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org, steven.price@arm.com, tglx@linutronix.de, vgupta@synopsys.com, will@kernel.org, zong.li@sifive.com


The patch titled
     Subject: x86: mm: convert dump_pagetables to use walk_page_range
has been removed from the -mm tree.  Its filename was
     x86-mm-convert-dump_pagetables-to-use-walk_page_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Steven Price <steven.price@arm.com>
Subject: x86: mm: convert dump_pagetables to use walk_page_range

Make use of the new functionality in walk_page_range to remove the arch
page walking code and use the generic code to walk the page tables.

The effective permissions are passed down the chain using new fields in
struct pg_state.

The KASAN optimisation is implemented by setting action=CONTINUE in the
callbacks to skip an entire tree of entries.

Link: http://lkml.kernel.org/r/20191218162402.45610-21-steven.price@arm.com
Signed-off-by: Steven Price <steven.price@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Hogan <jhogan@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Liang, Kan" <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Burton <paul.burton@mips.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zong Li <zong.li@sifive.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig              |    1 
 arch/x86/Kconfig.debug        |   20 --
 arch/x86/mm/Makefile          |    4 
 arch/x86/mm/dump_pagetables.c |  294 +++++++-------------------------
 4 files changed, 71 insertions(+), 248 deletions(-)

--- a/arch/x86/Kconfig~x86-mm-convert-dump_pagetables-to-use-walk_page_range
+++ a/arch/x86/Kconfig
@@ -120,6 +120,7 @@ config X86
 	select GENERIC_IRQ_RESERVATION_MODE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_PENDING_IRQ		if SMP
+	select GENERIC_PTDUMP
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
--- a/arch/x86/Kconfig.debug~x86-mm-convert-dump_pagetables-to-use-walk_page_range
+++ a/arch/x86/Kconfig.debug
@@ -62,26 +62,10 @@ config EARLY_PRINTK_USB_XDBC
 config MCSAFE_TEST
 	def_bool n
 
-config X86_PTDUMP_CORE
-	def_bool n
-
-config X86_PTDUMP
-	tristate "Export kernel pagetable layout to userspace via debugfs"
-	depends on DEBUG_KERNEL
-	select DEBUG_FS
-	select X86_PTDUMP_CORE
-	---help---
-	  Say Y here if you want to show the kernel pagetable layout in a
-	  debugfs file. This information is only useful for kernel developers
-	  who are working in architecture specific areas of the kernel.
-	  It is probably not a good idea to enable this feature in a production
-	  kernel.
-	  If in doubt, say "N"
-
 config EFI_PGT_DUMP
 	bool "Dump the EFI pagetable"
 	depends on EFI
-	select X86_PTDUMP_CORE
+	select PTDUMP_CORE
 	---help---
 	  Enable this if you want to dump the EFI page table before
 	  enabling virtual mode. This can be used to debug miscellaneous
@@ -90,7 +74,7 @@ config EFI_PGT_DUMP
 
 config DEBUG_WX
 	bool "Warn on W+X mappings at boot"
-	select X86_PTDUMP_CORE
+	select PTDUMP_CORE
 	---help---
 	  Generate a warning if any W+X mappings are found at boot.
 
--- a/arch/x86/mm/dump_pagetables.c~x86-mm-convert-dump_pagetables-to-use-walk_page_range
+++ a/arch/x86/mm/dump_pagetables.c
@@ -16,6 +16,7 @@
 #include <linux/seq_file.h>
 #include <linux/highmem.h>
 #include <linux/pci.h>
+#include <linux/ptdump.h>
 
 #include <asm/e820/types.h>
 #include <asm/pgtable.h>
@@ -26,11 +27,12 @@
  * when a "break" in the continuity is found.
  */
 struct pg_state {
+	struct ptdump_state ptdump;
 	int level;
-	pgprot_t current_prot;
+	pgprotval_t current_prot;
 	pgprotval_t effective_prot;
+	pgprotval_t prot_levels[5];
 	unsigned long start_address;
-	unsigned long current_address;
 	const struct addr_marker *marker;
 	unsigned long lines;
 	bool to_dmesg;
@@ -175,9 +177,8 @@ static struct addr_marker address_marker
 /*
  * Print a readable form of a pgprot_t to the seq_file
  */
-static void printk_prot(struct seq_file *m, pgprot_t prot, int level, bool dmsg)
+static void printk_prot(struct seq_file *m, pgprotval_t pr, int level, bool dmsg)
 {
-	pgprotval_t pr = pgprot_val(prot);
 	static const char * const level_name[] =
 		{ "cr3", "pgd", "p4d", "pud", "pmd", "pte" };
 
@@ -224,24 +225,11 @@ static void printk_prot(struct seq_file
 	pt_dump_cont_printf(m, dmsg, "%s\n", level_name[level]);
 }
 
-/*
- * On 64 bits, sign-extend the 48 bit address to 64 bit
- */
-static unsigned long normalize_addr(unsigned long u)
-{
-	int shift;
-	if (!IS_ENABLED(CONFIG_X86_64))
-		return u;
-
-	shift = 64 - (__VIRTUAL_MASK_SHIFT + 1);
-	return (signed long)(u << shift) >> shift;
-}
-
-static void note_wx(struct pg_state *st)
+static void note_wx(struct pg_state *st, unsigned long addr)
 {
 	unsigned long npages;
 
-	npages = (st->current_address - st->start_address) / PAGE_SIZE;
+	npages = (addr - st->start_address) / PAGE_SIZE;
 
 #ifdef CONFIG_PCI_BIOS
 	/*
@@ -249,7 +237,7 @@ static void note_wx(struct pg_state *st)
 	 * Inform about it, but avoid the warning.
 	 */
 	if (pcibios_enabled && st->start_address >= PAGE_OFFSET + BIOS_BEGIN &&
-	    st->current_address <= PAGE_OFFSET + BIOS_END) {
+	    addr <= PAGE_OFFSET + BIOS_END) {
 		pr_warn_once("x86/mm: PCI BIOS W+X mapping %lu pages\n", npages);
 		return;
 	}
@@ -261,25 +249,44 @@ static void note_wx(struct pg_state *st)
 		  (void *)st->start_address);
 }
 
+static inline pgprotval_t effective_prot(pgprotval_t prot1, pgprotval_t prot2)
+{
+	return (prot1 & prot2 & (_PAGE_USER | _PAGE_RW)) |
+	       ((prot1 | prot2) & _PAGE_NX);
+}
+
 /*
  * This function gets called on a break in a continuous series
  * of PTE entries; the next one is different so we need to
  * print what we collected so far.
  */
-static void note_page(struct pg_state *st, pgprot_t new_prot,
-		      pgprotval_t new_eff, int level)
+static void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
+		      unsigned long val)
 {
-	pgprotval_t prot, cur, eff;
+	struct pg_state *st = container_of(pt_st, struct pg_state, ptdump);
+	pgprotval_t new_prot, new_eff;
+	pgprotval_t cur, eff;
 	static const char units[] = "BKMGTPE";
 	struct seq_file *m = st->seq;
 
+	new_prot = val & PTE_FLAGS_MASK;
+
+	if (level > 1) {
+		new_eff = effective_prot(st->prot_levels[level - 2],
+					 new_prot);
+	} else {
+		new_eff = new_prot;
+	}
+
+	if (level > 0)
+		st->prot_levels[level - 1] = new_eff;
+
 	/*
 	 * If we have a "break" in the series, we need to flush the state that
 	 * we have now. "break" is either changing perms, levels or
 	 * address space marker.
 	 */
-	prot = pgprot_val(new_prot);
-	cur = pgprot_val(st->current_prot);
+	cur = st->current_prot;
 	eff = st->effective_prot;
 
 	if (!st->level) {
@@ -291,14 +298,14 @@ static void note_page(struct pg_state *s
 		st->lines = 0;
 		pt_dump_seq_printf(m, st->to_dmesg, "---[ %s ]---\n",
 				   st->marker->name);
-	} else if (prot != cur || new_eff != eff || level != st->level ||
-		   st->current_address >= st->marker[1].start_address) {
+	} else if (new_prot != cur || new_eff != eff || level != st->level ||
+		   addr >= st->marker[1].start_address) {
 		const char *unit = units;
 		unsigned long delta;
 		int width = sizeof(unsigned long) * 2;
 
 		if (st->check_wx && (eff & _PAGE_RW) && !(eff & _PAGE_NX))
-			note_wx(st);
+			note_wx(st, addr);
 
 		/*
 		 * Now print the actual finished series
@@ -308,9 +315,9 @@ static void note_page(struct pg_state *s
 			pt_dump_seq_printf(m, st->to_dmesg,
 					   "0x%0*lx-0x%0*lx   ",
 					   width, st->start_address,
-					   width, st->current_address);
+					   width, addr);
 
-			delta = st->current_address - st->start_address;
+			delta = addr - st->start_address;
 			while (!(delta & 1023) && unit[1]) {
 				delta >>= 10;
 				unit++;
@@ -327,7 +334,7 @@ static void note_page(struct pg_state *s
 		 * such as the start of vmalloc space etc.
 		 * This helps in the interpretation.
 		 */
-		if (st->current_address >= st->marker[1].start_address) {
+		if (addr >= st->marker[1].start_address) {
 			if (st->marker->max_lines &&
 			    st->lines > st->marker->max_lines) {
 				unsigned long nskip =
@@ -343,217 +350,48 @@ static void note_page(struct pg_state *s
 					   st->marker->name);
 		}
 
-		st->start_address = st->current_address;
+		st->start_address = addr;
 		st->current_prot = new_prot;
 		st->effective_prot = new_eff;
 		st->level = level;
 	}
 }
 
-static inline pgprotval_t effective_prot(pgprotval_t prot1, pgprotval_t prot2)
-{
-	return (prot1 & prot2 & (_PAGE_USER | _PAGE_RW)) |
-	       ((prot1 | prot2) & _PAGE_NX);
-}
-
-static void walk_pte_level(struct pg_state *st, pmd_t addr, pgprotval_t eff_in,
-			   unsigned long P)
-{
-	int i;
-	pte_t *pte;
-	pgprotval_t prot, eff;
-
-	for (i = 0; i < PTRS_PER_PTE; i++) {
-		st->current_address = normalize_addr(P + i * PTE_LEVEL_MULT);
-		pte = pte_offset_map(&addr, st->current_address);
-		prot = pte_flags(*pte);
-		eff = effective_prot(eff_in, prot);
-		note_page(st, __pgprot(prot), eff, 5);
-		pte_unmap(pte);
-	}
-}
-#ifdef CONFIG_KASAN
-
-/*
- * This is an optimization for KASAN=y case. Since all kasan page tables
- * eventually point to the kasan_early_shadow_page we could call note_page()
- * right away without walking through lower level page tables. This saves
- * us dozens of seconds (minutes for 5-level config) while checking for
- * W+X mapping or reading kernel_page_tables debugfs file.
- */
-static inline bool kasan_page_table(struct pg_state *st, void *pt)
-{
-	if (__pa(pt) == __pa(kasan_early_shadow_pmd) ||
-	    (pgtable_l5_enabled() &&
-			__pa(pt) == __pa(kasan_early_shadow_p4d)) ||
-	    __pa(pt) == __pa(kasan_early_shadow_pud)) {
-		pgprotval_t prot = pte_flags(kasan_early_shadow_pte[0]);
-		note_page(st, __pgprot(prot), 0, 5);
-		return true;
-	}
-	return false;
-}
-#else
-static inline bool kasan_page_table(struct pg_state *st, void *pt)
-{
-	return false;
-}
-#endif
-
-#if PTRS_PER_PMD > 1
-
-static void walk_pmd_level(struct pg_state *st, pud_t addr,
-			   pgprotval_t eff_in, unsigned long P)
-{
-	int i;
-	pmd_t *start, *pmd_start;
-	pgprotval_t prot, eff;
-
-	pmd_start = start = (pmd_t *)pud_page_vaddr(addr);
-	for (i = 0; i < PTRS_PER_PMD; i++) {
-		st->current_address = normalize_addr(P + i * PMD_LEVEL_MULT);
-		if (!pmd_none(*start)) {
-			prot = pmd_flags(*start);
-			eff = effective_prot(eff_in, prot);
-			if (pmd_large(*start) || !pmd_present(*start)) {
-				note_page(st, __pgprot(prot), eff, 4);
-			} else if (!kasan_page_table(st, pmd_start)) {
-				walk_pte_level(st, *start, eff,
-					       P + i * PMD_LEVEL_MULT);
-			}
-		} else
-			note_page(st, __pgprot(0), 0, 4);
-		start++;
-	}
-}
-
-#else
-#define walk_pmd_level(s,a,e,p) walk_pte_level(s,__pmd(pud_val(a)),e,p)
-#define pud_large(a) pmd_large(__pmd(pud_val(a)))
-#define pud_none(a)  pmd_none(__pmd(pud_val(a)))
-#endif
-
-#if PTRS_PER_PUD > 1
-
-static void walk_pud_level(struct pg_state *st, p4d_t addr, pgprotval_t eff_in,
-			   unsigned long P)
-{
-	int i;
-	pud_t *start, *pud_start;
-	pgprotval_t prot, eff;
-
-	pud_start = start = (pud_t *)p4d_page_vaddr(addr);
-
-	for (i = 0; i < PTRS_PER_PUD; i++) {
-		st->current_address = normalize_addr(P + i * PUD_LEVEL_MULT);
-		if (!pud_none(*start)) {
-			prot = pud_flags(*start);
-			eff = effective_prot(eff_in, prot);
-			if (pud_large(*start) || !pud_present(*start)) {
-				note_page(st, __pgprot(prot), eff, 3);
-			} else if (!kasan_page_table(st, pud_start)) {
-				walk_pmd_level(st, *start, eff,
-					       P + i * PUD_LEVEL_MULT);
-			}
-		} else
-			note_page(st, __pgprot(0), 0, 3);
-
-		start++;
-	}
-}
-
-#else
-#define walk_pud_level(s,a,e,p) walk_pmd_level(s,__pud(p4d_val(a)),e,p)
-#define p4d_large(a) pud_large(__pud(p4d_val(a)))
-#define p4d_none(a)  pud_none(__pud(p4d_val(a)))
-#endif
-
-static void walk_p4d_level(struct pg_state *st, pgd_t addr, pgprotval_t eff_in,
-			   unsigned long P)
+static void ptdump_walk_pgd_level_core(struct seq_file *m, pgd_t *pgd,
+				       bool checkwx, bool dmesg)
 {
-	int i;
-	p4d_t *start, *p4d_start;
-	pgprotval_t prot, eff;
-
-	if (PTRS_PER_P4D == 1)
-		return walk_pud_level(st, __p4d(pgd_val(addr)), eff_in, P);
-
-	p4d_start = start = (p4d_t *)pgd_page_vaddr(addr);
-
-	for (i = 0; i < PTRS_PER_P4D; i++) {
-		st->current_address = normalize_addr(P + i * P4D_LEVEL_MULT);
-		if (!p4d_none(*start)) {
-			prot = p4d_flags(*start);
-			eff = effective_prot(eff_in, prot);
-			if (p4d_large(*start) || !p4d_present(*start)) {
-				note_page(st, __pgprot(prot), eff, 2);
-			} else if (!kasan_page_table(st, p4d_start)) {
-				walk_pud_level(st, *start, eff,
-					       P + i * P4D_LEVEL_MULT);
-			}
-		} else
-			note_page(st, __pgprot(0), 0, 2);
-
-		start++;
-	}
-}
+	const struct ptdump_range ptdump_ranges[] = {
+#ifdef CONFIG_X86_64
 
-#define pgd_large(a) (pgtable_l5_enabled() ? pgd_large(a) : p4d_large(__p4d(pgd_val(a))))
-#define pgd_none(a)  (pgtable_l5_enabled() ? pgd_none(a) : p4d_none(__p4d(pgd_val(a))))
+#define normalize_addr_shift (64 - (__VIRTUAL_MASK_SHIFT + 1))
+#define normalize_addr(u) ((signed long)((u) << normalize_addr_shift) >> \
+			   normalize_addr_shift)
 
-static inline bool is_hypervisor_range(int idx)
-{
-#ifdef CONFIG_X86_64
-	/*
-	 * A hole in the beginning of kernel address space reserved
-	 * for a hypervisor.
-	 */
-	return	(idx >= pgd_index(GUARD_HOLE_BASE_ADDR)) &&
-		(idx <  pgd_index(GUARD_HOLE_END_ADDR));
+	{0, PTRS_PER_PGD * PGD_LEVEL_MULT / 2},
+	{normalize_addr(PTRS_PER_PGD * PGD_LEVEL_MULT / 2), ~0UL},
 #else
-	return false;
+	{0, ~0UL},
 #endif
-}
+	{0, 0}
+};
 
-static void ptdump_walk_pgd_level_core(struct seq_file *m, pgd_t *pgd,
-				       bool checkwx, bool dmesg)
-{
-	pgd_t *start = pgd;
-	pgprotval_t prot, eff;
-	int i;
-	struct pg_state st = {};
-
-	st.to_dmesg = dmesg;
-	st.check_wx = checkwx;
-	st.seq = m;
-	if (checkwx)
-		st.wx_pages = 0;
-
-	for (i = 0; i < PTRS_PER_PGD; i++) {
-		st.current_address = normalize_addr(i * PGD_LEVEL_MULT);
-		if (!pgd_none(*start) && !is_hypervisor_range(i)) {
-			prot = pgd_flags(*start);
-#ifdef CONFIG_X86_PAE
-			eff = _PAGE_USER | _PAGE_RW;
-#else
-			eff = prot;
-#endif
-			if (pgd_large(*start) || !pgd_present(*start)) {
-				note_page(&st, __pgprot(prot), eff, 1);
-			} else {
-				walk_p4d_level(&st, *start, eff,
-					       i * PGD_LEVEL_MULT);
-			}
-		} else
-			note_page(&st, __pgprot(0), 0, 1);
+	struct pg_state st = {
+		.ptdump = {
+			.note_page	= note_page,
+			.range		= ptdump_ranges
+		},
+		.to_dmesg	= dmesg,
+		.check_wx	= checkwx,
+		.seq		= m
+	};
+
+	struct mm_struct fake_mm = {
+		.pgd = pgd
+	};
+	init_rwsem(&fake_mm.mmap_sem);
 
-		cond_resched();
-		start++;
-	}
+	ptdump_walk_pgd(&st.ptdump, &fake_mm);
 
-	/* Flush out the last page */
-	st.current_address = normalize_addr(PTRS_PER_PGD*PGD_LEVEL_MULT);
-	note_page(&st, __pgprot(0), 0, 0);
 	if (!checkwx)
 		return;
 	if (st.wx_pages)
--- a/arch/x86/mm/Makefile~x86-mm-convert-dump_pagetables-to-use-walk_page_range
+++ a/arch/x86/mm/Makefile
@@ -28,8 +28,8 @@ CFLAGS_fault.o := -I $(srctree)/$(src)/.
 obj-$(CONFIG_X86_32)		+= pgtable_32.o iomap_32.o
 
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
-obj-$(CONFIG_X86_PTDUMP_CORE)	+= dump_pagetables.o
-obj-$(CONFIG_X86_PTDUMP)	+= debug_pagetables.o
+obj-$(CONFIG_PTDUMP_CORE)	+= dump_pagetables.o
+obj-$(CONFIG_PTDUMP_DEBUGFS)	+= debug_pagetables.o
 
 obj-$(CONFIG_HIGHMEM)		+= highmem_32.o
 
_

Patches currently in -mm which might be from steven.price@arm.com are
