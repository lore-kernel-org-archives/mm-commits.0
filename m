From: akpm@linux-foundation.org
Subject: + powerpc-32-drop-get_pteptr.patch added to -mm tree
Date: Sat, 29 Feb 2020 20:38:08 -0800
Message-ID: <20200301043808.Uxzjvb-gq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgCAEiK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 29 Feb 2020 23:38:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, bcain@codeaurora.org, benh@kernel.crashing.org, catalin.marinas@arm.com, christophe.leroy@c-s.fr, dalias@libc.org, fenghua.yu@intel.com, geert+renesas@glider.be, gxt@pku.edu.cn, james.morse@arm.com, jonas@southpole.se, julien.thierry.kdev@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, maz@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, rppt@linux.ibm.com, shorne@gmail.com, stefan.kristiansson@saunalahti.fi, suzuki.poulose@arm.com, tony.luck@intel.com, will@kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: powerpc/32: drop get_pteptr()
has been added to the -mm tree.  Its filename is
     powerpc-32-drop-get_pteptr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-32-drop-get_pteptr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-32-drop-get_pteptr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: powerpc/32: drop get_pteptr()

Commit 8d30c14cab30 ("powerpc/mm: Rework I$/D$ coherency (v3)") and commit
90ac19a8b21b ("[POWERPC] Abolish iopa(), mm_ptov(), io_block_mapping()
from arch/powerpc") removed the use of get_pteptr() outside of
mm/pgtable_32.c

In mm/pgtable_32.c, the only user of get_pteptr() is __change_page_attr()
which operates on kernel context and on lowmem pages only.

Move page table traversal to __change_page_attr() and drop get_pteptr().

Link: http://lkml.kernel.org/r/20200227084608.18223-8-rppt@kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
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

 arch/powerpc/mm/pgtable_32.c |   43 +++++----------------------------
 1 file changed, 7 insertions(+), 36 deletions(-)

--- a/arch/powerpc/mm/pgtable_32.c~powerpc-32-drop-get_pteptr
+++ a/arch/powerpc/mm/pgtable_32.c
@@ -121,53 +121,24 @@ void __init mapin_ram(void)
 	}
 }
 
-/* Scan the real Linux page tables and return a PTE pointer for
- * a virtual address in a context.
- * Returns true (1) if PTE was found, zero otherwise.  The pointer to
- * the PTE pointer is unmodified if PTE is not found.
- */
-static int
-get_pteptr(struct mm_struct *mm, unsigned long addr, pte_t **ptep, pmd_t **pmdp)
-{
-        pgd_t	*pgd;
-	pud_t	*pud;
-        pmd_t	*pmd;
-        pte_t	*pte;
-        int     retval = 0;
-
-        pgd = pgd_offset(mm, addr & PAGE_MASK);
-        if (pgd) {
-		pud = pud_offset(pgd, addr & PAGE_MASK);
-		if (pud && pud_present(*pud)) {
-			pmd = pmd_offset(pud, addr & PAGE_MASK);
-			if (pmd_present(*pmd)) {
-				pte = pte_offset_map(pmd, addr & PAGE_MASK);
-				if (pte) {
-					retval = 1;
-					*ptep = pte;
-					if (pmdp)
-						*pmdp = pmd;
-					/* XXX caller needs to do pte_unmap, yuck */
-				}
-			}
-		}
-        }
-        return(retval);
-}
-
 static int __change_page_attr_noflush(struct page *page, pgprot_t prot)
 {
 	pte_t *kpte;
 	pmd_t *kpmd;
-	unsigned long address;
+	unsigned long address, va;
 
 	BUG_ON(PageHighMem(page));
 	address = (unsigned long)page_address(page);
+	va = address & PAGE_MASK;
 
 	if (v_block_mapped(address))
 		return 0;
-	if (!get_pteptr(&init_mm, address, &kpte, &kpmd))
+
+	kpmd = pmd_offset(pud_offset(pgd_offset_k(va), va), va);
+	if (!pmd_present(*kpmd))
 		return -EINVAL;
+
+	kpte = pte_offset_map(kpmd, va);
 	__set_pte_at(&init_mm, address, kpte, mk_pte(page, prot), 0);
 	pte_unmap(kpte);
 
_

Patches currently in -mm which might be from christophe.leroy@c-s.fr are

powerpc-32-drop-get_pteptr.patch
