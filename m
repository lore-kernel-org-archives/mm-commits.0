From: akpm@linux-foundation.org
Subject: + mm-change-ioremap-to-set-up-huge-i-o-mappings.patch added to
 -mm tree
Date: Tue, 03 Mar 2015 14:46:00 -0800
Message-ID: <54f639a8.Vb6y5G+rlfSuVk/O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36529 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618AbbCCWqB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2015 17:46:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, Elliott@hp.com, arnd@arndb.de, dave.hansen@intel.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change ioremap to set up huge I/O mappings
has been added to the -mm tree.  Its filename is
     mm-change-ioremap-to-set-up-huge-i-o-mappings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-change-ioremap-to-set-up-huge-i-o-mappings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-change-ioremap-to-set-up-huge-i-o-mappings.patch

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
Subject: mm: change ioremap to set up huge I/O mappings

ioremap_pud_range() and ioremap_pmd_range() are changed to create huge I/O
mappings when their capability is enabled, and a request meets required
conditions -- both virtual & physical addresses are aligned by their huge
page size, and a requested range fufills their huge page size.  When
pud_set_huge() or pmd_set_huge() returns zero, i.e.  no-operation is
performed, the code simply falls back to the next level.

The changes are only enabled when CONFIG_HAVE_ARCH_HUGE_VMAP is defined on
the architecture.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Robert Elliott <Elliott@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |   15 +++++++++++++++
 lib/ioremap.c                 |   16 ++++++++++++++++
 2 files changed, 31 insertions(+)

diff -puN include/asm-generic/pgtable.h~mm-change-ioremap-to-set-up-huge-i-o-mappings include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-change-ioremap-to-set-up-huge-i-o-mappings
+++ a/include/asm-generic/pgtable.h
@@ -6,6 +6,7 @@
 
 #include <linux/mm_types.h>
 #include <linux/bug.h>
+#include <linux/errno.h>
 
 #if 4 - defined(__PAGETABLE_PUD_FOLDED) - defined(__PAGETABLE_PMD_FOLDED) != \
 	CONFIG_PGTABLE_LEVELS
@@ -702,4 +703,18 @@ static inline int pmd_protnone(pmd_t pmd
 #define io_remap_pfn_range remap_pfn_range
 #endif
 
+#ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
+int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot);
+int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot);
+#else	/* !CONFIG_HAVE_ARCH_HUGE_VMAP */
+static inline int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot)
+{
+	return 0;
+}
+static inline int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot)
+{
+	return 0;
+}
+#endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
+
 #endif /* _ASM_GENERIC_PGTABLE_H */
diff -puN lib/ioremap.c~mm-change-ioremap-to-set-up-huge-i-o-mappings lib/ioremap.c
--- a/lib/ioremap.c~mm-change-ioremap-to-set-up-huge-i-o-mappings
+++ a/lib/ioremap.c
@@ -81,6 +81,14 @@ static inline int ioremap_pmd_range(pud_
 		return -ENOMEM;
 	do {
 		next = pmd_addr_end(addr, end);
+
+		if (ioremap_pmd_enabled() &&
+		    ((next - addr) == PMD_SIZE) &&
+		    IS_ALIGNED(phys_addr + addr, PMD_SIZE)) {
+			if (pmd_set_huge(pmd, phys_addr + addr, prot))
+				continue;
+		}
+
 		if (ioremap_pte_range(pmd, addr, next, phys_addr + addr, prot))
 			return -ENOMEM;
 	} while (pmd++, addr = next, addr != end);
@@ -99,6 +107,14 @@ static inline int ioremap_pud_range(pgd_
 		return -ENOMEM;
 	do {
 		next = pud_addr_end(addr, end);
+
+		if (ioremap_pud_enabled() &&
+		    ((next - addr) == PUD_SIZE) &&
+		    IS_ALIGNED(phys_addr + addr, PUD_SIZE)) {
+			if (pud_set_huge(pud, phys_addr + addr, prot))
+				continue;
+		}
+
 		if (ioremap_pmd_range(pud, addr, next, phys_addr + addr, prot))
 			return -ENOMEM;
 	} while (pud++, addr = next, addr != end);
_

Patches currently in -mm which might be from toshi.kani@hp.com are

mm-change-__get_vm_area_node-to-use-fls_long.patch
lib-add-huge-i-o-map-capability-interfaces.patch
mm-change-ioremap-to-set-up-huge-i-o-mappings.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings.patch
x86-mm-support-huge-i-o-mapping-capability-i-f.patch
x86-mm-support-huge-kva-mappings-on-x86.patch

