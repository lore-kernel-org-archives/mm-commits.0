From: akpm@linux-foundation.org
Subject: +
 arm-arm64-add-support-for-folded-p4d-page-tables-fix.patch added to -mm
 tree
Date: Mon, 02 Mar 2020 14:27:07 -0800
Message-ID: <20200302222707.Y92hJwgwH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgCBW1K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Mar 2020 17:27:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anders.roxell@linaro.org, anshuman.khandual@arm.com, arnd@arndb.de, bcain@codeaurora.org, benh@kernel.crashing.org, catalin.marinas@arm.com, christophe.leroy@c-s.fr, dalias@libc.org, fenghua.yu@intel.com, geert+renesas@glider.be, gxt@pku.edu.cn, james.morse@arm.com, jonas@southpole.se, julien.thierry.kdev@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, maz@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, naresh.kamboju@linaro.org, paulus@samba.org, rppt@linux.ibm.com, sfr@canb.auug.org.au, shorne@gmail.com, stefan.kristiansson@saunalahti.fi, suzuki.poulose@arm.com, tony.luck@intel.com, will@kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: arm64/mm: implement unmap_hotplug_p4d_range
has been added to the -mm tree.  Its filename is
     arm-arm64-add-support-for-folded-p4d-page-tables-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-arm64-add-support-for-folded-p4d-page-tables-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-arm64-add-support-for-folded-p4d-page-tables-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: arm64/mm: implement unmap_hotplug_p4d_range

Link: http://lkml.kernel.org/r/20200302135443.GA24831@linux.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
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

 arch/arm64/mm/mmu.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/arch/arm64/mm/mmu.c~arm-arm64-add-support-for-folded-p4d-page-tables-fix
+++ a/arch/arm64/mm/mmu.c
@@ -848,6 +848,24 @@ static void unmap_hotplug_pud_range(pgd_
 	} while (addr = next, addr < end);
 }
 
+static void unmap_hotplug_p4d_range(pgd_t *pgd, unsigned long addr,
+				unsigned long end, bool free_mapped)
+{
+	unsigned long next;
+	pgd_t *p4dp, p4d;
+
+	do {
+		next = p4d_addr_end(addr, end);
+		p4dp = p4d_offset(pgd, addr);
+		p4d = READ_ONCE(*p4dp);
+		if (p4d_none(p4d))
+			continue;
+
+		WARN_ON(!p4d_present(p4d));
+		unmap_hotplug_pud_range(p4dp, addr, next, free_mapped);
+	} while (addr = next, addr < end);
+}
+
 static void unmap_hotplug_range(unsigned long addr, unsigned long end,
 				bool free_mapped)
 {
@@ -862,7 +880,7 @@ static void unmap_hotplug_range(unsigned
 			continue;
 
 		WARN_ON(!pgd_present(pgd));
-		unmap_hotplug_pud_range(pgdp, addr, next, free_mapped);
+		unmap_hotplug_p4d_range(pgdp, addr, next, free_mapped);
 	} while (addr = next, addr < end);
 }
 
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

arm-arm64-add-support-for-folded-p4d-page-tables.patch
arm-arm64-add-support-for-folded-p4d-page-tables-fix.patch
h8300-remove-usage-of-__arch_use_5level_hack.patch
hexagon-remove-__arch_use_5level_hack.patch
ia64-add-support-for-folded-p4d-page-tables.patch
nios2-add-support-for-folded-p4d-page-tables.patch
openrisc-add-support-for-folded-p4d-page-tables.patch
powerpc-add-support-for-folded-p4d-page-tables.patch
sh-drop-__pxd_offset-macros-that-duplicate-pxd_index-ones.patch
sh-add-support-for-folded-p4d-page-tables.patch
unicore32-remove-__arch_use_5level_hack.patch
asm-generic-remove-pgtable-nop4d-hackh.patch
mm-remove-__arch_has_5level_hack-and-include-asm-generic-5level-fixuph.patch
