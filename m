From: akpm@linux-foundation.org
Subject: + h8300-remove-usage-of-__arch_use_5level_hack.patch
 added to -mm tree
Date: Sat, 29 Feb 2020 20:37:49 -0800
Message-ID: <20200301043749.H8LqlsHHE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgCAEhy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 29 Feb 2020 23:37:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, bcain@codeaurora.org, benh@kernel.crashing.org, catalin.marinas@arm.com, christophe.leroy@c-s.fr, dalias@libc.org, fenghua.yu@intel.com, geert+renesas@glider.be, gxt@pku.edu.cn, james.morse@arm.com, jonas@southpole.se, julien.thierry.kdev@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, maz@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, rppt@linux.ibm.com, shorne@gmail.com, stefan.kristiansson@saunalahti.fi, suzuki.poulose@arm.com, tony.luck@intel.com, will@kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: h8300: remove usage of __ARCH_USE_5LEVEL_HACK
has been added to the -mm tree.  Its filename is
     h8300-remove-usage-of-__arch_use_5level_hack.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/h8300-remove-usage-of-__arch_use_5level_hack.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/h8300-remove-usage-of-__arch_use_5level_hack.patch

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
Subject: h8300: remove usage of __ARCH_USE_5LEVEL_HACK

h8300 is a nommu architecture and does not require fixup for upper layers
of the page tables because it is already handled by the generic nommu
implementation.

Remove definition of __ARCH_USE_5LEVEL_HACK in
arch/h8300/include/asm/pgtable.h

Link: http://lkml.kernel.org/r/20200227084608.18223-3-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
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

 arch/h8300/include/asm/pgtable.h |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/h8300/include/asm/pgtable.h~h8300-remove-usage-of-__arch_use_5level_hack
+++ a/arch/h8300/include/asm/pgtable.h
@@ -1,7 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _H8300_PGTABLE_H
 #define _H8300_PGTABLE_H
-#define __ARCH_USE_5LEVEL_HACK
 #include <asm-generic/pgtable-nopud.h>
 #include <asm-generic/pgtable.h>
 extern void paging_init(void);
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

arm-arm64-add-support-for-folded-p4d-page-tables.patch
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
