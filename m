From: akpm@linux-foundation.org
Subject: [failures] mips-mm-add-page-soft-dirty-tracking.patch
 removed from -mm tree
Date: Mon, 27 Apr 2020 13:57:45 -0700
Message-ID: <20200427205745.Vbezjw4b0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgD0U5s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Apr 2020 16:57:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, dansilsby@gmail.com, dkorotin@wavecomp.com, geert@linux-m68k.org, gorcunov@gmail.com, jiaxun.yang@flygoat.com, koct9i@gmail.com, lixuefeng@loongson.cn, mm-commits@vger.kernel.org, paul@crapouillou.net, paulburton@kernel.org, ralf@linux-mips.org, rppt@linux.ibm.com, steven.price@arm.com, sunguoyun@loongson.cn, tsbogend@alpha.franken.de, xemul@openvz.org, yangtiezhu@loongson.cn


The patch titled
     Subject: mips/mm: add page soft dirty tracking
has been removed from the -mm tree.  Its filename was
     mips-mm-add-page-soft-dirty-tracking.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Guoyun Sun <sunguoyun@loongson.cn>
Subject: mips/mm: add page soft dirty tracking

User space checkpoint and restart tool (CRIU) needs the page's change to
be soft tracked.  This allows to do a pre checkpoint and then dump only
touched pages.

Link: http://lkml.kernel.org/r/1587460527-13986-1-git-send-email-sunguoyun@loongson.cn
Signed-off-by: Guoyun Sun <sunguoyun@loongson.cn>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Daniel Silsby <dansilsby@gmail.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Paul Cercueil <paul@crapouillou.net>
Cc: Dmitry Korotin <dkorotin@wavecomp.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Guoyun Sun <sunguoyun@loongson.cn>
Cc: TieZhu Yang <yangtiezhu@loongson.cn>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig                    |    1 
 arch/mips/include/asm/pgtable-bits.h |    8 +++-
 arch/mips/include/asm/pgtable.h      |   48 +++++++++++++++++++++++--
 3 files changed, 53 insertions(+), 4 deletions(-)

--- a/arch/mips/include/asm/pgtable-bits.h~mips-mm-add-page-soft-dirty-tracking
+++ a/arch/mips/include/asm/pgtable-bits.h
@@ -55,6 +55,7 @@ enum pgtable_bits {
 #if defined(CONFIG_ARCH_HAS_PTE_SPECIAL)
 	_PAGE_SPECIAL_SHIFT,
 #endif
+	_PAGE_SOFT_DIRTY_SHIFT,
 };
 
 /*
@@ -84,6 +85,7 @@ enum pgtable_bits {
 #if defined(CONFIG_ARCH_HAS_PTE_SPECIAL)
 	_PAGE_SPECIAL_SHIFT,
 #endif
+	_PAGE_SOFT_DIRTY_SHIFT,
 };
 
 #elif defined(CONFIG_CPU_R3K_TLB)
@@ -99,6 +101,7 @@ enum pgtable_bits {
 #if defined(CONFIG_ARCH_HAS_PTE_SPECIAL)
 	_PAGE_SPECIAL_SHIFT,
 #endif
+	_PAGE_SOFT_DIRTY_SHIFT,
 
 	/* Used by TLB hardware (placed in EntryLo) */
 	_PAGE_GLOBAL_SHIFT = 8,
@@ -125,7 +128,7 @@ enum pgtable_bits {
 #if defined(CONFIG_ARCH_HAS_PTE_SPECIAL)
 	_PAGE_SPECIAL_SHIFT,
 #endif
-
+	_PAGE_SOFT_DIRTY_SHIFT,
 	/* Used by TLB hardware (placed in EntryLo*) */
 #if defined(CONFIG_CPU_HAS_RIXI)
 	_PAGE_NO_EXEC_SHIFT,
@@ -152,6 +155,7 @@ enum pgtable_bits {
 #else
 # define _PAGE_SPECIAL		0
 #endif
+#define _PAGE_SOFT_DIRTY	(1 << _PAGE_SOFT_DIRTY_SHIFT)
 
 /* Used by TLB hardware (placed in EntryLo*) */
 #if defined(CONFIG_XPA)
@@ -269,6 +273,6 @@ static inline uint64_t pte_to_entrylo(un
 #define __WRITEABLE	(_PAGE_SILENT_WRITE | _PAGE_WRITE | _PAGE_MODIFIED)
 
 #define _PAGE_CHG_MASK	(_PAGE_ACCESSED | _PAGE_MODIFIED |	\
-			 _PFN_MASK | _CACHE_MASK)
+			 _PAGE_SOFT_DIRTY | _PFN_MASK | _CACHE_MASK)
 
 #endif /* _ASM_PGTABLE_BITS_H */
--- a/arch/mips/include/asm/pgtable.h~mips-mm-add-page-soft-dirty-tracking
+++ a/arch/mips/include/asm/pgtable.h
@@ -400,7 +400,7 @@ static inline pte_t pte_mkwrite(pte_t pt
 
 static inline pte_t pte_mkdirty(pte_t pte)
 {
-	pte_val(pte) |= _PAGE_MODIFIED;
+	pte_val(pte) |= _PAGE_MODIFIED | _PAGE_SOFT_DIRTY;
 	if (pte_val(pte) & _PAGE_WRITE)
 		pte_val(pte) |= _PAGE_SILENT_WRITE;
 	return pte;
@@ -423,6 +423,30 @@ static inline pte_t pte_mkhuge(pte_t pte
 	return pte;
 }
 #endif /* CONFIG_MIPS_HUGE_TLB_SUPPORT */
+
+#ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
+static inline bool pte_soft_dirty(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_SOFT_DIRTY;
+}
+#define pte_swp_soft_dirty pte_soft_dirty
+
+static inline pte_t pte_mksoft_dirty(pte_t pte)
+{
+	pte_val(pte) |= _PAGE_SOFT_DIRTY;
+	return pte;
+}
+#define pte_swp_mksoft_dirty pte_mksoft_dirty
+
+static inline pte_t pte_clear_soft_dirty(pte_t pte)
+{
+	pte_val(pte) &= ~(_PAGE_SOFT_DIRTY);
+	return pte;
+}
+#define pte_swp_clear_soft_dirty pte_clear_soft_dirty
+
+#endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
+
 #endif
 
 /*
@@ -576,7 +600,7 @@ static inline pmd_t pmd_mkclean(pmd_t pm
 
 static inline pmd_t pmd_mkdirty(pmd_t pmd)
 {
-	pmd_val(pmd) |= _PAGE_MODIFIED;
+	pmd_val(pmd) |= _PAGE_MODIFIED | _PAGE_SOFT_DIRTY;
 	if (pmd_val(pmd) & _PAGE_WRITE)
 		pmd_val(pmd) |= _PAGE_SILENT_WRITE;
 
@@ -605,6 +629,26 @@ static inline pmd_t pmd_mkyoung(pmd_t pm
 	return pmd;
 }
 
+#ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
+static inline int pmd_soft_dirty(pmd_t pmd)
+{
+	return !!(pmd_val(pmd) & _PAGE_SOFT_DIRTY);
+}
+
+static inline pmd_t pmd_mksoft_dirty(pmd_t pmd)
+{
+	pmd_val(pmd) |= _PAGE_SOFT_DIRTY;
+	return pmd;
+}
+
+static inline pmd_t pmd_clear_soft_dirty(pmd_t pmd)
+{
+	pmd_val(pmd) &= ~(_PAGE_SOFT_DIRTY);
+	return pmd;
+}
+
+#endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
+
 /* Extern to avoid header file madness */
 extern pmd_t mk_pmd(struct page *page, pgprot_t prot);
 
--- a/arch/mips/Kconfig~mips-mm-add-page-soft-dirty-tracking
+++ a/arch/mips/Kconfig
@@ -494,6 +494,7 @@ config MACH_LOONGSON64
 	select COMMON_CLK
 	select USE_OF
 	select BUILTIN_DTB
+	select HAVE_ARCH_SOFT_DIRTY
 	help
 	  This enables the support of Loongson-2/3 family of machines.
 
_

Patches currently in -mm which might be from sunguoyun@loongson.cn are
