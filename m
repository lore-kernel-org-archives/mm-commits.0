From: akpm@linux-foundation.org
Subject: [merged]
 x86-mm-simplify-init_trampoline-and-surrounding-logic.patch removed from
 -mm tree
Date: Tue, 09 Jun 2020 17:39:03 -0700
Message-ID: <20200610003903.TztdeZc_I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgFJAjF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:39:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, bcain@codeaurora.org, bp@alien8.de, catalin.marinas@arm.com, chris@zankel.net, dalias@libc.org, davem@davemloft.net, deanbo422@gmail.com, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, mattst88@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tglx@linutronix.de, tony.luck@intel.com, tsbogend@alpha.franken.de, vgupta@synopsys.com, will@kernel.org, willy@infradead.org, ysato@users.sourceforge.jp


The patch titled
     Subject: x86/mm: simplify init_trampoline() and surrounding logic
has been removed from the -mm tree.  Its filename was
     x86-mm-simplify-init_trampoline-and-surrounding-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: x86/mm: simplify init_trampoline() and surrounding logic

There are three cases for the trampoline initialization:
* 32-bit does nothing
* 64-bit with kaslr disabled simply copies a PGD entry from the direct map
  to the trampoline PGD
* 64-bit with kaslr enabled maps the real mode trampoline at PUD level

These cases are currently differentiated by a bunch of ifdefs inside
asm/include/pgtable.h and the case of 64-bits with kaslr on uses
pgd_index() helper.

Replacing the ifdefs with a static function in arch/x86/mm/init.c gives
clearer code and allows moving pgd_index() to the generic implementation
in include/linux/pgtable.h

[rppt@linux.ibm.com: take CONFIG_RANDOMIZE_MEMORY into account in kaslr_enabled()]
  Link: http://lkml.kernel.org/r/20200525104045.GB13212@linux.ibm.com
Link: http://lkml.kernel.org/r/20200514170327.31389-8-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/kaslr.h   |    2 +
 arch/x86/include/asm/pgtable.h |   15 --------------
 arch/x86/include/asm/setup.h   |   12 ++++++++++-
 arch/x86/mm/init.c             |   22 ++++++++++++++++++++
 arch/x86/mm/kaslr.c            |   33 -------------------------------
 5 files changed, 37 insertions(+), 47 deletions(-)

--- a/arch/x86/include/asm/kaslr.h~x86-mm-simplify-init_trampoline-and-surrounding-logic
+++ a/arch/x86/include/asm/kaslr.h
@@ -6,8 +6,10 @@ unsigned long kaslr_get_random_long(cons
 
 #ifdef CONFIG_RANDOMIZE_MEMORY
 void kernel_randomize_memory(void);
+void init_trampoline_kaslr(void);
 #else
 static inline void kernel_randomize_memory(void) { }
+static inline void init_trampoline_kaslr(void) {}
 #endif /* CONFIG_RANDOMIZE_MEMORY */
 
 #endif
--- a/arch/x86/include/asm/pgtable.h~x86-mm-simplify-init_trampoline-and-surrounding-logic
+++ a/arch/x86/include/asm/pgtable.h
@@ -1071,27 +1071,14 @@ void init_mem_mapping(void);
 void early_alloc_pgt_buf(void);
 extern void memblock_find_dma_reserve(void);
 
+
 #ifdef CONFIG_X86_64
-/* Realmode trampoline initialization. */
 extern pgd_t trampoline_pgd_entry;
-static inline void __meminit init_trampoline_default(void)
-{
-	/* Default trampoline pgd value */
-	trampoline_pgd_entry = init_top_pgt[pgd_index(__PAGE_OFFSET)];
-}
 
 void __init poking_init(void);
 
 unsigned long init_memory_mapping(unsigned long start,
 				  unsigned long end, pgprot_t prot);
-
-# ifdef CONFIG_RANDOMIZE_MEMORY
-void __meminit init_trampoline(void);
-# else
-#  define init_trampoline init_trampoline_default
-# endif
-#else
-static inline void init_trampoline(void) { }
 #endif
 
 /* local pte updates need not use xchg for locking */
--- a/arch/x86/include/asm/setup.h~x86-mm-simplify-init_trampoline-and-surrounding-logic
+++ a/arch/x86/include/asm/setup.h
@@ -75,7 +75,17 @@ extern char _text[];
 
 static inline bool kaslr_enabled(void)
 {
-	return !!(boot_params.hdr.loadflags & KASLR_FLAG);
+	return IS_ENABLED(CONFIG_RANDOMIZE_MEMORY) &&
+		!!(boot_params.hdr.loadflags & KASLR_FLAG);
+}
+
+/*
+ * Apply no randomization if KASLR was disabled at boot or if KASAN
+ * is enabled. KASAN shadow mappings rely on regions being PGD aligned.
+ */
+static inline bool kaslr_memory_enabled(void)
+{
+	return kaslr_enabled() && !IS_ENABLED(CONFIG_KASAN);
 }
 
 static inline unsigned long kaslr_offset(void)
--- a/arch/x86/mm/init.c~x86-mm-simplify-init_trampoline-and-surrounding-logic
+++ a/arch/x86/mm/init.c
@@ -680,6 +680,28 @@ static void __init memory_map_bottom_up(
 	}
 }
 
+/*
+ * The real mode trampoline, which is required for bootstrapping CPUs
+ * occupies only a small area under the low 1MB.  See reserve_real_mode()
+ * for details.
+ *
+ * If KASLR is disabled the first PGD entry of the direct mapping is copied
+ * to map the real mode trampoline.
+ *
+ * If KASLR is enabled, copy only the PUD which covers the low 1MB
+ * area. This limits the randomization granularity to 1GB for both 4-level
+ * and 5-level paging.
+ */
+static void __init init_trampoline(void)
+{
+#ifdef CONFIG_X86_64
+	if (!kaslr_memory_enabled())
+		trampoline_pgd_entry = init_top_pgt[pgd_index(__PAGE_OFFSET)];
+	else
+		init_trampoline_kaslr();
+#endif
+}
+
 void __init init_mem_mapping(void)
 {
 	unsigned long end;
--- a/arch/x86/mm/kaslr.c~x86-mm-simplify-init_trampoline-and-surrounding-logic
+++ a/arch/x86/mm/kaslr.c
@@ -61,15 +61,6 @@ static inline unsigned long get_padding(
 	return (region->size_tb << TB_SHIFT);
 }
 
-/*
- * Apply no randomization if KASLR was disabled at boot or if KASAN
- * is enabled. KASAN shadow mappings rely on regions being PGD aligned.
- */
-static inline bool kaslr_memory_enabled(void)
-{
-	return kaslr_enabled() && !IS_ENABLED(CONFIG_KASAN);
-}
-
 /* Initialize base and padding for each memory region randomized with KASLR */
 void __init kernel_randomize_memory(void)
 {
@@ -148,7 +139,7 @@ void __init kernel_randomize_memory(void
 	}
 }
 
-static void __meminit init_trampoline_pud(void)
+void __meminit init_trampoline_kaslr(void)
 {
 	pud_t *pud_page_tramp, *pud, *pud_tramp;
 	p4d_t *p4d_page_tramp, *p4d, *p4d_tramp;
@@ -189,25 +180,3 @@ static void __meminit init_trampoline_pu
 			__pgd(_KERNPG_TABLE | __pa(pud_page_tramp)));
 	}
 }
-
-/*
- * The real mode trampoline, which is required for bootstrapping CPUs
- * occupies only a small area under the low 1MB.  See reserve_real_mode()
- * for details.
- *
- * If KASLR is disabled the first PGD entry of the direct mapping is copied
- * to map the real mode trampoline.
- *
- * If KASLR is enabled, copy only the PUD which covers the low 1MB
- * area. This limits the randomization granularity to 1GB for both 4-level
- * and 5-level paging.
- */
-void __meminit init_trampoline(void)
-{
-	if (!kaslr_memory_enabled()) {
-		init_trampoline_default();
-		return;
-	}
