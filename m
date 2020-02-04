From: akpm@linux-foundation.org
Subject: [merged]
 mm-ptdump-reduce-level-numbers-by-1-in-note_page.patch removed from -mm
 tree
Date: Tue, 04 Feb 2020 10:41:54 -0800
Message-ID: <20200204184154.V9U7cbjh8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727542AbgBDSl5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:41:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex@ghiti.fr, aou@eecs.berkeley.edu, ard.biesheuvel@linaro.org, arnd@arndb.de, benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com, dave.hansen@linux.intel.com, davem@davemloft.net, gor@linux.ibm.com, heiko.carstens@de.ibm.com, hpa@zytor.com, james.morse@arm.com, jglisse@redhat.com, jhogan@kernel.org, kan.liang@linux.intel.com, linux@armlinux.org.uk, luto@kernel.org, mark.rutland@arm.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paul.burton@mips.com, paul.walmsley@sifive.com, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org, steven.price@arm.com, tglx@linutronix.de, vgupta@synopsys.com, will@kernel.org, zong.li@sifive.com


The patch titled
     Subject: mm: ptdump: reduce level numbers by 1 in note_page()
has been removed from the -mm tree.  Its filename was
     mm-ptdump-reduce-level-numbers-by-1-in-note_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Steven Price <steven.price@arm.com>
Subject: mm: ptdump: reduce level numbers by 1 in note_page()

Rather than having to increment the 'depth' number by 1 in ptdump_hole(),
let's change the meaning of 'level' in note_page() since that makes the
code simplier.

Note that for x86, the level numbers were previously increased by 1 in
commit 45dcd2091363 ("x86/mm/dump_pagetables: Fix printout of p4d level")
and the comment "Bit 7 has a different meaning" was not updated, so this
change also makes the code match the comment again.

Link: http://lkml.kernel.org/r/20191218162402.45610-24-steven.price@arm.com
Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
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

 arch/arm64/mm/dump.c          |    6 +++---
 arch/x86/mm/dump_pagetables.c |   19 ++++++++++---------
 include/linux/ptdump.h        |    1 +
 mm/ptdump.c                   |   16 ++++++++--------
 4 files changed, 22 insertions(+), 20 deletions(-)

--- a/arch/arm64/mm/dump.c~mm-ptdump-reduce-level-numbers-by-1-in-note_page
+++ a/arch/arm64/mm/dump.c
@@ -176,8 +176,7 @@ struct pg_level {
 };
 
 static struct pg_level pg_level[] = {
-	{
-	}, { /* pgd */
+	{ /* pgd */
 		.name	= "PGD",
 		.bits	= pte_bits,
 		.num	= ARRAY_SIZE(pte_bits),
@@ -257,7 +256,7 @@ static void note_page(struct ptdump_stat
 	if (level >= 0)
 		prot = val & pg_level[level].mask;
 
-	if (!st->level) {
+	if (st->level == -1) {
 		st->level = level;
 		st->current_prot = prot;
 		st->start_address = addr;
@@ -351,6 +350,7 @@ void ptdump_check_wx(void)
 			{ 0, NULL},
 			{ -1, NULL},
 		},
+		.level = -1,
 		.check_wx = true,
 		.ptdump = {
 			.note_page = note_page,
--- a/arch/x86/mm/dump_pagetables.c~mm-ptdump-reduce-level-numbers-by-1-in-note_page
+++ a/arch/x86/mm/dump_pagetables.c
@@ -180,7 +180,7 @@ static struct addr_marker address_marker
 static void printk_prot(struct seq_file *m, pgprotval_t pr, int level, bool dmsg)
 {
 	static const char * const level_name[] =
-		{ "cr3", "pgd", "p4d", "pud", "pmd", "pte" };
+		{ "pgd", "p4d", "pud", "pmd", "pte" };
 
 	if (!(pr & _PAGE_PRESENT)) {
 		/* Not present */
@@ -204,12 +204,12 @@ static void printk_prot(struct seq_file
 			pt_dump_cont_printf(m, dmsg, "    ");
 
 		/* Bit 7 has a different meaning on level 3 vs 4 */
-		if (level <= 4 && pr & _PAGE_PSE)
+		if (level <= 3 && pr & _PAGE_PSE)
 			pt_dump_cont_printf(m, dmsg, "PSE ");
 		else
 			pt_dump_cont_printf(m, dmsg, "    ");
-		if ((level == 5 && pr & _PAGE_PAT) ||
-		    ((level == 4 || level == 3) && pr & _PAGE_PAT_LARGE))
+		if ((level == 4 && pr & _PAGE_PAT) ||
+		    ((level == 3 || level == 2) && pr & _PAGE_PAT_LARGE))
 			pt_dump_cont_printf(m, dmsg, "PAT ");
 		else
 			pt_dump_cont_printf(m, dmsg, "    ");
@@ -271,15 +271,15 @@ static void note_page(struct ptdump_stat
 
 	new_prot = val & PTE_FLAGS_MASK;
 
-	if (level > 1) {
-		new_eff = effective_prot(st->prot_levels[level - 2],
+	if (level > 0) {
+		new_eff = effective_prot(st->prot_levels[level - 1],
 					 new_prot);
 	} else {
 		new_eff = new_prot;
 	}
 
-	if (level > 0)
-		st->prot_levels[level - 1] = new_eff;
+	if (level >= 0)
+		st->prot_levels[level] = new_eff;
 
 	/*
 	 * If we have a "break" in the series, we need to flush the state that
@@ -289,7 +289,7 @@ static void note_page(struct ptdump_stat
 	cur = st->current_prot;
 	eff = st->effective_prot;
 
-	if (!st->level) {
+	if (st->level == -1) {
 		/* First entry */
 		st->current_prot = new_prot;
 		st->effective_prot = new_eff;
@@ -380,6 +380,7 @@ static void ptdump_walk_pgd_level_core(s
 			.note_page	= note_page,
 			.range		= ptdump_ranges
 		},
+		.level = -1,
 		.to_dmesg	= dmesg,
 		.check_wx	= checkwx,
 		.seq		= m
--- a/include/linux/ptdump.h~mm-ptdump-reduce-level-numbers-by-1-in-note_page
+++ a/include/linux/ptdump.h
@@ -11,6 +11,7 @@ struct ptdump_range {
 };
 
 struct ptdump_state {
+	/* level is 0:PGD to 4:PTE, or -1 if unknown */
 	void (*note_page)(struct ptdump_state *st, unsigned long addr,
 			  int level, unsigned long val);
 	const struct ptdump_range *range;
--- a/mm/ptdump.c~mm-ptdump-reduce-level-numbers-by-1-in-note_page
+++ a/mm/ptdump.c
@@ -17,7 +17,7 @@ static inline int note_kasan_page_table(
 {
 	struct ptdump_state *st = walk->private;
 
-	st->note_page(st, addr, 5, pte_val(kasan_early_shadow_pte[0]));
+	st->note_page(st, addr, 4, pte_val(kasan_early_shadow_pte[0]));
 
 	walk->action = ACTION_CONTINUE;
 
@@ -37,7 +37,7 @@ static int ptdump_pgd_entry(pgd_t *pgd,
 #endif
 
 	if (pgd_leaf(val))
-		st->note_page(st, addr, 1, pgd_val(val));
+		st->note_page(st, addr, 0, pgd_val(val));
 
 	return 0;
 }
@@ -54,7 +54,7 @@ static int ptdump_p4d_entry(p4d_t *p4d,
 #endif
 
 	if (p4d_leaf(val))
-		st->note_page(st, addr, 2, p4d_val(val));
+		st->note_page(st, addr, 1, p4d_val(val));
 
 	return 0;
 }
@@ -71,7 +71,7 @@ static int ptdump_pud_entry(pud_t *pud,
 #endif
 
 	if (pud_leaf(val))
-		st->note_page(st, addr, 3, pud_val(val));
+		st->note_page(st, addr, 2, pud_val(val));
 
 	return 0;
 }
@@ -88,7 +88,7 @@ static int ptdump_pmd_entry(pmd_t *pmd,
 #endif
 
 	if (pmd_leaf(val))
-		st->note_page(st, addr, 4, pmd_val(val));
+		st->note_page(st, addr, 3, pmd_val(val));
 
 	return 0;
 }
@@ -98,7 +98,7 @@ static int ptdump_pte_entry(pte_t *pte,
 {
 	struct ptdump_state *st = walk->private;
 
-	st->note_page(st, addr, 5, pte_val(READ_ONCE(*pte)));
+	st->note_page(st, addr, 4, pte_val(READ_ONCE(*pte)));
 
 	return 0;
 }
@@ -108,7 +108,7 @@ static int ptdump_hole(unsigned long add
 {
 	struct ptdump_state *st = walk->private;
 
-	st->note_page(st, addr, depth + 1, 0);
+	st->note_page(st, addr, depth, 0);
 
 	return 0;
 }
@@ -135,5 +135,5 @@ void ptdump_walk_pgd(struct ptdump_state
 	up_read(&mm->mmap_sem);
 
 	/* Flush out the last page */
-	st->note_page(st, 0, 0, 0);
+	st->note_page(st, 0, -1, 0);
 }
_

Patches currently in -mm which might be from steven.price@arm.com are
