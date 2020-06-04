From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 009/127] h8300: remove usage of
 __ARCH_USE_5LEVEL_HACK
Date: Thu, 04 Jun 2020 16:46:15 -0700
Message-ID: <20200604234615.2UqeTBR_w%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgFDXqS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:46:18 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, bcain@codeaurora.org, benh@kernel.crashing.org, catalin.marinas@arm.com, christophe.leroy@c-s.fr, dalias@libc.org, fenghua.yu@intel.com, geert+renesas@glider.be, gxt@pku.edu.cn, james.morse@arm.com, jonas@southpole.se, joro@8bytes.org, julien.thierry.kdev@gmail.com, ley.foon.tan@intel.com, linux-mm@kvack.org, linux@armlinux.org.uk, maz@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, rppt@linux.ibm.com, shorne@gmail.com, stefan.kristiansson@saunalahti.fi, suzuki.poulose@arm.com, tony.luck@intel.com, torvalds@linux-foundation.org, will@kernel.org, ysato@users.sourceforge.jp

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: h8300: remove usage of __ARCH_USE_5LEVEL_HACK

Patch series "mm: remove __ARCH_HAS_5LEVEL_HACK", v4.

These patches convert several architectures to use page table folding and
remove __ARCH_HAS_5LEVEL_HACK along with
include/asm-generic/5level-fixup.h and
include/asm-generic/pgtable-nop4d-hack.h.  With that we'll have a single
and consistent way of dealing with page table folding instead of a mix of
three existing options.

The changes are mostly about mechanical replacement of pgd accessors with
p4d ones and the addition of higher levels to page table traversals.


This patch (of 14):

h8300 is a nommu architecture and does not require fixup for upper layers
of the page tables because it is already handled by the generic nommu
implementation.

Remove definition of __ARCH_USE_5LEVEL_HACK in
arch/h8300/include/asm/pgtable.h

Link: http://lkml.kernel.org/r/20200414153455.21744-1-rppt@kernel.org
Link: http://lkml.kernel.org/r/20200414153455.21744-2-rppt@kernel.org
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
Cc: Stafford Horne <shorne@gmail.com> [openrisc]
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Joerg Roedel <joro@8bytes.org>
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
