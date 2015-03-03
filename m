From: akpm@linux-foundation.org
Subject: + x86-mm-support-huge-kva-mappings-on-x86.patch added to -mm tree
Date: Tue, 03 Mar 2015 14:46:06 -0800
Message-ID: <54f639ae.T3bNZ3F3O3ZmvdZe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618AbbCCWqH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2015 17:46:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, Elliott@hp.com, arnd@arndb.de, dave.hansen@intel.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, mm: support huge KVA mappings on x86
has been added to the -mm tree.  Its filename is
     x86-mm-support-huge-kva-mappings-on-x86.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-support-huge-kva-mappings-on-x86.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-support-huge-kva-mappings-on-x86.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Robert Elliott <Elliott@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig      |    1 
 arch/x86/mm/pgtable.c |   65 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

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
 
@@ -485,3 +486,67 @@ void native_set_fixmap(enum fixed_addres
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
_

Patches currently in -mm which might be from toshi.kani@hp.com are

mm-change-__get_vm_area_node-to-use-fls_long.patch
lib-add-huge-i-o-map-capability-interfaces.patch
mm-change-ioremap-to-set-up-huge-i-o-mappings.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings.patch
x86-mm-support-huge-i-o-mapping-capability-i-f.patch
x86-mm-support-huge-kva-mappings-on-x86.patch

