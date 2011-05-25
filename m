From: akpm@linux-foundation.org
Subject: [merged] mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage.patch removed from -mm tree
Date: Wed, 25 May 2011 13:28:35 -0700
Message-ID: <201105252026.p4PKQxlP014529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114Ab1EYU2S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:28:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, benh@kernel.crashing.org, davem@davemloft.net, hughd@google.com, jdike@addtoit.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lethal@linu


The patch titled
     mm: now that all old mmu_gather code is gone, remove the storage
has been removed from the -mm tree.  Its filename was
     mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: now that all old mmu_gather code is gone, remove the storage
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Fold all the mmu_gather rework patches into one for submission

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reported-by: Hugh Dickins <hughd@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Tony Luck <tony.luck@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/mm/init.c      |    2 --
 arch/arm/mm/mmu.c         |    2 --
 arch/avr32/mm/init.c      |    2 --
 arch/cris/mm/init.c       |    2 --
 arch/frv/mm/init.c        |    2 --
 arch/ia64/mm/init.c       |    2 --
 arch/m32r/mm/init.c       |    2 --
 arch/m68k/mm/init_mm.c    |    2 --
 arch/microblaze/mm/init.c |    2 --
 arch/mips/mm/init.c       |    2 --
 arch/mn10300/mm/init.c    |    2 --
 arch/parisc/mm/init.c     |    2 --
 arch/s390/mm/pgtable.c    |    1 -
 arch/score/mm/init.c      |    2 --
 arch/sh/mm/init.c         |    1 -
 arch/sparc/mm/init_32.c   |    2 --
 arch/tile/mm/init.c       |    2 --
 arch/um/kernel/smp.c      |    3 ---
 arch/unicore32/mm/mmu.c   |    2 --
 arch/x86/mm/init.c        |    2 --
 arch/xtensa/mm/mmu.c      |    2 --
 21 files changed, 41 deletions(-)

diff -puN arch/alpha/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage arch/alpha/mm/init.c
--- a/arch/alpha/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage
+++ a/arch/alpha/mm/init.c
@@ -32,8 +32,6 @@
 #include <asm/console.h>
 #include <asm/tlb.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 extern void die_if_kernel(char *,struct pt_regs *,long);
 
 static struct pcb_struct original_pcb;
diff -puN arch/arm/mm/mmu.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage arch/arm/mm/mmu.c
--- a/arch/arm/mm/mmu.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage
+++ a/arch/arm/mm/mmu.c
@@ -31,8 +31,6 @@
 
 #include "mm.h"
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 /*
  * empty_zero_page is a special page that is used for
  * zero-initialized data and COW.
diff -puN arch/avr32/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage arch/avr32/mm/init.c
--- a/arch/avr32/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage
+++ a/arch/avr32/mm/init.c
@@ -25,8 +25,6 @@
 #include <asm/setup.h>
 #include <asm/sections.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 pgd_t swapper_pg_dir[PTRS_PER_PGD] __page_aligned_data;
 
 struct page *empty_zero_page;
diff -puN arch/cris/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage arch/cris/mm/init.c
--- a/arch/cris/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage
+++ a/arch/cris/mm/init.c
@@ -13,8 +13,6 @@
 #include <linux/bootmem.h>
 #include <asm/tlb.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 unsigned long empty_zero_page;
 
 extern char _stext, _edata, _etext; /* From linkerscript */
diff -puN arch/frv/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage arch/frv/mm/init.c
--- a/arch/frv/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage
+++ a/arch/frv/mm/init.c
@@ -41,8 +41,6 @@
 
 #undef DEBUG
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 /*
  * BAD_PAGE is the page that is used for page faults when linux
  * is out-of-memory. Older versions of linux just did a
diff -puN arch/ia64/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage
+++ a/arch/ia64/mm/init.c
@@ -36,8 +36,6 @@
 #include <asm/mca.h>
 #include <asm/paravirt.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 extern void ia64_tlb_init (void);
 
 unsigned long MAX_DMA_ADDRESS = PAGE_OFFSET + 0x100000000UL;
diff -puN arch/m32r/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage arch/m32r/mm/init.c
--- a/arch/m32r/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage
+++ a/arch/m32r/mm/init.c
@@ -35,8 +35,6 @@ extern char __init_begin, __init_end;
 
 pgd_t swapper_pg_dir[1024];
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 /*
  * Cache of MMU context last used.
  */
diff -puN arch/m68k/mm/init_mm.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage arch/m68k/mm/init_mm.c
--- a/arch/m68k/mm/init_mm.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage
+++ a/arch/m68k/mm/init_mm.c
@@ -32,8 +32,6 @@
 #include <asm/sections.h>
 #include <asm/tlb.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 pg_data_t pg_data_map[MAX_NUMNODES];
 EXPORT_SYMBOL(pg_data_map);
 
diff -puN arch/microblaze/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage arch/microblaze/mm/init.c
--- a/arch/microblaze/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage
+++ a/arch/microblaze/mm/init.c
@@ -32,8 +32,6 @@ unsigned int __page_offset;
 EXPORT_SYMBOL(__page_offset);
 
 #else
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 static int init_bootmem_done;
 #endif /* CONFIG_MMU */
 
diff -puN arch/mips/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage arch/mips/mm/init.c
--- a/arch/mips/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage
+++ a/arch/mips/mm/init.c
@@ -64,8 +64,6 @@
 
 #endif /* CONFIG_MIPS_MT_SMTC */
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 /*
  * We have up to 8 empty zeroed pages so we can map one of the right colour
  * when needed.  This is necessary only on R4000 / R4400 SC and MC versions
diff -puN arch/mn10300/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage arch/mn10300/mm/init.c
--- a/arch/mn10300/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage
+++ a/arch/mn10300/mm/init.c
@@ -37,8 +37,6 @@
 #include <asm/tlb.h>
 #include <asm/sections.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 unsigned long highstart_pfn, highend_pfn;
 
 #ifdef CONFIG_MN10300_HAS_ATOMIC_OPS_UNIT
diff -puN arch/parisc/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage
+++ a/arch/parisc/mm/init.c
@@ -31,8 +31,6 @@
 #include <asm/mmzone.h>
 #include <asm/sections.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 extern int  data_start;
 
 #ifdef CONFIG_DISCONTIGMEM
diff -puN arch/s390/mm/pgtable.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage arch/s390/mm/pgtable.c
--- a/arch/s390/mm/pgtable.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage
+++ a/arch/s390/mm/pgtable.c
@@ -36,7 +36,6 @@ struct rcu_table_freelist {
 	((PAGE_SIZE - sizeof(struct rcu_table_freelist)) \
 	  / sizeof(unsigned long))
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 static DEFINE_PER_CPU(struct rcu_table_freelist *, rcu_table_freelist);
 
 static void __page_table_free(struct mm_struct *mm, unsigned long *table);
diff -puN arch/score/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage arch/score/mm/init.c
--- a/arch/score/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage
+++ a/arch/score/mm/init.c
@@ -38,8 +38,6 @@
 #include <asm/sections.h>
 #include <asm/tlb.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 unsigned long empty_zero_page;
 EXPORT_SYMBOL_GPL(empty_zero_page);
 
diff -puN arch/sh/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage
+++ a/arch/sh/mm/init.c
@@ -28,7 +28,6 @@
 #include <asm/cache.h>
 #include <asm/sizes.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
 void __init generic_mem_init(void)
diff -puN arch/sparc/mm/init_32.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage arch/sparc/mm/init_32.c
--- a/arch/sparc/mm/init_32.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage
+++ a/arch/sparc/mm/init_32.c
@@ -37,8 +37,6 @@
 #include <asm/prom.h>
 #include <asm/leon.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 unsigned long *sparc_valid_addr_bitmap;
 EXPORT_SYMBOL(sparc_valid_addr_bitmap);
 
diff -puN arch/tile/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage arch/tile/mm/init.c
--- a/arch/tile/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage
+++ a/arch/tile/mm/init.c
@@ -60,8 +60,6 @@ unsigned long VMALLOC_RESERVE = CONFIG_V
 EXPORT_SYMBOL(VMALLOC_RESERVE);
 #endif
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 /* Create an L2 page table */
 static pte_t * __init alloc_pte(void)
 {
diff -puN arch/um/kernel/smp.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage arch/um/kernel/smp.c
--- a/arch/um/kernel/smp.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage
+++ a/arch/um/kernel/smp.c
@@ -7,9 +7,6 @@
 #include "asm/pgalloc.h"
 #include "asm/tlb.h"
 
-/* For some reason, mmu_gathers are referenced when CONFIG_SMP is off. */
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 #ifdef CONFIG_SMP
 
 #include "linux/sched.h"
diff -puN arch/unicore32/mm/mmu.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage arch/unicore32/mm/mmu.c
--- a/arch/unicore32/mm/mmu.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage
+++ a/arch/unicore32/mm/mmu.c
@@ -30,8 +30,6 @@
 
 #include "mm.h"
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 /*
  * empty_zero_page is a special page that is used for
  * zero-initialized data and COW.
diff -puN arch/x86/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage arch/x86/mm/init.c
--- a/arch/x86/mm/init.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage
+++ a/arch/x86/mm/init.c
@@ -16,8 +16,6 @@
 #include <asm/tlb.h>
 #include <asm/proto.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 unsigned long __initdata pgt_buf_start;
 unsigned long __meminitdata pgt_buf_end;
 unsigned long __meminitdata pgt_buf_top;
diff -puN arch/xtensa/mm/mmu.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage arch/xtensa/mm/mmu.c
--- a/arch/xtensa/mm/mmu.c~mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage
+++ a/arch/xtensa/mm/mmu.c
@@ -14,8 +14,6 @@
 #include <asm/mmu_context.h>
 #include <asm/page.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
