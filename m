From: akpm@linux-foundation.org
Subject: [merged]
 arm-arm64-add-support-for-folded-p4d-page-tables-fix-fix.patch removed from
 -mm tree
Date: Fri, 06 Mar 2020 20:01:11 -0800
Message-ID: <20200307040111.Nkzf3Q_ba%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbgCGEBP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 6 Mar 2020 23:01:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anders.roxell@linaro.org, anshuman.khandual@arm.com, arnd@arndb.de, bcain@codeaurora.org, benh@kernel.crashing.org, catalin.marinas@arm.com, christophe.leroy@c-s.fr, dalias@libc.org, fenghua.yu@intel.com, geert+renesas@glider.be, gxt@pku.edu.cn, james.morse@arm.com, jonas@southpole.se, julien.thierry.kdev@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, maz@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, naresh.kamboju@linaro.org, paulus@samba.org, rppt@linux.ibm.com, sfr@canb.auug.org.au, shorne@gmail.com, stefan.kristiansson@saunalahti.fi, suzuki.poulose@arm.com, tony.luck@intel.com, will@kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: arm-arm64-add-support-for-folded-p4d-page-tables-fix-fix
has been removed from the -mm tree.  Its filename was
     arm-arm64-add-support-for-folded-p4d-page-tables-fix-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: arm-arm64-add-support-for-folded-p4d-page-tables-fix-fix

Link: http://lkml.kernel.org/r/20200302174553.GC4166275@arrakis.emea.arm.com
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brian Cain <bcain@codeaurora.org>
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
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stephen Rothwell<sfr@canb.auug.org.au>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c |   41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

--- a/arch/arm64/mm/mmu.c~arm-arm64-add-support-for-folded-p4d-page-tables-fix-fix
+++ a/arch/arm64/mm/mmu.c
@@ -816,7 +816,7 @@ static void unmap_hotplug_pmd_range(pud_
 	} while (addr = next, addr < end);
 }
 
-static void unmap_hotplug_pud_range(pgd_t *pgdp, unsigned long addr,
+static void unmap_hotplug_pud_range(p4d_t *p4dp, unsigned long addr,
 				    unsigned long end, bool free_mapped)
 {
 	unsigned long next;
@@ -824,7 +824,7 @@ static void unmap_hotplug_pud_range(pgd_
 
 	do {
 		next = pud_addr_end(addr, end);
-		pudp = pud_offset(pgdp, addr);
+		pudp = pud_offset(p4dp, addr);
 		pud = READ_ONCE(*pudp);
 		if (pud_none(pud))
 			continue;
@@ -848,15 +848,15 @@ static void unmap_hotplug_pud_range(pgd_
 	} while (addr = next, addr < end);
 }
 
-static void unmap_hotplug_p4d_range(pgd_t *pgd, unsigned long addr,
-				unsigned long end, bool free_mapped)
+static void unmap_hotplug_p4d_range(pgd_t *pgdp, unsigned long addr,
+				    unsigned long end, bool free_mapped)
 {
 	unsigned long next;
-	pgd_t *p4dp, p4d;
+	p4d_t *p4dp, p4d;
 
 	do {
 		next = p4d_addr_end(addr, end);
-		p4dp = p4d_offset(pgd, addr);
+		p4dp = p4d_offset(pgdp, addr);
 		p4d = READ_ONCE(*p4dp);
 		if (p4d_none(p4d))
 			continue;
@@ -961,7 +961,7 @@ static void free_empty_pmd_table(pud_t *
 	free_hotplug_pgtable_page(virt_to_page(pmdp));
 }
 
-static void free_empty_pud_table(pgd_t *pgdp, unsigned long addr,
+static void free_empty_pud_table(p4d_t *p4dp, unsigned long addr,
 				 unsigned long end, unsigned long floor,
 				 unsigned long ceiling)
 {
@@ -970,7 +970,7 @@ static void free_empty_pud_table(pgd_t *
 
 	do {
 		next = pud_addr_end(addr, end);
-		pudp = pud_offset(pgdp, addr);
+		pudp = pud_offset(p4dp, addr);
 		pud = READ_ONCE(*pudp);
 		if (pud_none(pud))
 			continue;
@@ -990,17 +990,36 @@ static void free_empty_pud_table(pgd_t *
 	 * entries are empty. Overlap with other regions have been
 	 * handled by the floor/ceiling check.
 	 */
-	pudp = pud_offset(pgdp, 0UL);
+	pudp = pud_offset(p4dp, 0UL);
 	for (i = 0; i < PTRS_PER_PUD; i++) {
 		if (!pud_none(READ_ONCE(pudp[i])))
 			return;
 	}
 
-	pgd_clear(pgdp);
+	p4d_clear(p4dp);
 	__flush_tlb_kernel_pgtable(start);
 	free_hotplug_pgtable_page(virt_to_page(pudp));
 }
 
+static void free_empty_p4d_table(pgd_t *pgdp, unsigned long addr,
+				 unsigned long end, unsigned long floor,
+				 unsigned long ceiling)
+{
+	p4d_t *p4dp, p4d;
+	unsigned long next;
+
+	do {
+		next = p4d_addr_end(addr, end);
+		p4dp = p4d_offset(pgdp, addr);
+		p4d = READ_ONCE(*p4dp);
+		if (p4d_none(p4d))
+			continue;
+
+		WARN_ON(!p4d_present(p4d));
+		free_empty_pud_table(p4dp, addr, next, floor, ceiling);
+	} while (addr = next, addr < end);
+}
+
 static void free_empty_tables(unsigned long addr, unsigned long end,
 			      unsigned long floor, unsigned long ceiling)
 {
@@ -1015,7 +1034,7 @@ static void free_empty_tables(unsigned l
 			continue;
 
 		WARN_ON(!pgd_present(pgd));
-		free_empty_pud_table(pgdp, addr, next, floor, ceiling);
+		free_empty_p4d_table(pgdp, addr, next, floor, ceiling);
 	} while (addr = next, addr < end);
 }
 #endif
_

Patches currently in -mm which might be from catalin.marinas@arm.com are
