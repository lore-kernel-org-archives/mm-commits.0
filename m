From: akpm@linux-foundation.org
Subject: [merged] x86-mm-support-huge-kva-mappings-on-x86.patch removed
 from -mm tree
Date: Wed, 15 Apr 2015 12:11:28 -0700
Message-ID: <552eb7e0.Z4o22MNsOAE+ILdr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48368 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933580AbbDOTL3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:11:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, Elliott@hp.com, arnd@arndb.de, dave.hansen@intel.com, fengguang.wu@intel.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, mm: support huge KVA mappings on x86
has been removed from the -mm tree.  Its filename was
     x86-mm-support-huge-kva-mappings-on-x86.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: x86, mm: support huge KVA mappings on x86

Implement huge KVA mapping interfaces on x86.

On x86, MTRRs can override PAT memory types with a 4KB granularity.  When
using a huge page, MTRRs can override the memory type of the huge page,
which may lead a performance penalty.  The processor can also behave in an
undefined manner if a huge page is mapped to a memory range that MTRRs
have mapped with multiple different memory types.  Therefore, the mapping
code falls back to use a smaller page size toward 4KB when a mapping range
is covered by non-WB type of MTRRs.  The WB type of MTRRs has no affect on
the PAT memory types.

pud_set_huge() and pmd_set_huge() call mtrr_type_lookup() to see if a
given range is covered by MTRRs.  MTRR_TYPE_WRBACK indicates that the
range is either covered by WB or not covered and the MTRR default value is
set to WB.  0xFF indicates that MTRRs are disabled.

HAVE_ARCH_HUGE_VMAP is selected when X86_64 or X86_32 with X86_PAE is set.
 X86_32 without X86_PAE is not supported since such config can unlikey be
benefited from this feature, and there was an issue found in testing.

[fengguang.wu@intel.com: ioremap_pud_capable can be static]
Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Robert Elliott <Elliott@hp.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig      |    1 
 arch/x86/mm/pgtable.c |   65 ++++++++++++++++++++++++++++++++++++++++
 lib/ioremap.c         |    6 +--
 3 files changed, 69 insertions(+), 3 deletions(-)

diff -puN arch/x86/Kconfig~x86-mm-support-huge-kva-mappings-on-x86 arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-mm-support-huge-kva-mappings-on-x86
+++ a/arch/x86/Kconfig
@@ -99,6 +99,7 @@ config X86
 	select IRQ_FORCED_THREADING
 	select HAVE_BPF_JIT if X86_64
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
+	select HAVE_ARCH_HUGE_VMAP if X86_64 || (X86_32 && X86_PAE)
 	select ARCH_HAS_SG_CHAIN
 	select CLKEVT_I8253
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
diff -puN arch/x86/mm/pgtable.c~x86-mm-support-huge-kva-mappings-on-x86 arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c~x86-mm-support-huge-kva-mappings-on-x86
+++ a/arch/x86/mm/pgtable.c
@@ -4,6 +4,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlb.h>
 #include <asm/fixmap.h>
+#include <asm/mtrr.h>
 
 #define PGALLOC_GFP GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO
 
@@ -560,3 +561,67 @@ void native_set_fixmap(enum fixed_addres
 {
 	__native_set_fixmap(idx, pfn_pte(phys >> PAGE_SHIFT, flags));
 }
+
+#ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
+int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot)
+{
+	u8 mtrr;
+
+	/*
+	 * Do not use a huge page when the range is covered by non-WB type
+	 * of MTRRs.
+	 */
+	mtrr = mtrr_type_lookup(addr, addr + PUD_SIZE);
+	if ((mtrr != MTRR_TYPE_WRBACK) && (mtrr != 0xFF))
+		return 0;
+
+	prot = pgprot_4k_2_large(prot);
+
+	set_pte((pte_t *)pud, pfn_pte(
+		(u64)addr >> PAGE_SHIFT,
+		__pgprot(pgprot_val(prot) | _PAGE_PSE)));
+
+	return 1;
+}
+
+int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot)
+{
+	u8 mtrr;
+
+	/*
+	 * Do not use a huge page when the range is covered by non-WB type
+	 * of MTRRs.
+	 */
+	mtrr = mtrr_type_lookup(addr, addr + PMD_SIZE);
+	if ((mtrr != MTRR_TYPE_WRBACK) && (mtrr != 0xFF))
+		return 0;
+
+	prot = pgprot_4k_2_large(prot);
+
+	set_pte((pte_t *)pmd, pfn_pte(
+		(u64)addr >> PAGE_SHIFT,
+		__pgprot(pgprot_val(prot) | _PAGE_PSE)));
+
+	return 1;
+}
+
+int pud_clear_huge(pud_t *pud)
+{
+	if (pud_large(*pud)) {
+		pud_clear(pud);
+		return 1;
+	}
+
+	return 0;
+}
+
+int pmd_clear_huge(pmd_t *pmd)
+{
+	if (pmd_large(*pmd)) {
+		pmd_clear(pmd);
+		return 1;
+	}
+
+	return 0;
+}
+#endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
diff -puN lib/ioremap.c~x86-mm-support-huge-kva-mappings-on-x86 lib/ioremap.c
--- a/lib/ioremap.c~x86-mm-support-huge-kva-mappings-on-x86
+++ a/lib/ioremap.c
@@ -14,9 +14,9 @@
 #include <asm/pgtable.h>
 
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
-int __read_mostly ioremap_pud_capable;
-int __read_mostly ioremap_pmd_capable;
-int __read_mostly ioremap_huge_disabled;
+static int __read_mostly ioremap_pud_capable;
+static int __read_mostly ioremap_pmd_capable;
+static int __read_mostly ioremap_huge_disabled;
 
 static int __init set_nohugeiomap(char *str)
 {
_

Patches currently in -mm which might be from toshi.kani@hp.com are

origin.patch
mm-x86-document-return-values-of-mapping-funcs.patch
mtrr-x86-fix-mtrr-lookup-to-handle-inclusive-entry.patch
mtrr-x86-remove-a-wrong-address-check-in-__mtrr_type_lookup.patch
mtrr-x86-fix-mtrr-state-checks-in-mtrr_type_lookup.patch
mtrr-x86-define-mtrr_type_invalid-for-mtrr_type_lookup.patch
mtrr-x86-clean-up-mtrr_type_lookup.patch
mtrr-mm-x86-enhance-mtrr-checks-for-kva-huge-page-mapping.patch

