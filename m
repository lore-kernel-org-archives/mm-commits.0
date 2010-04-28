From: akpm@linux-foundation.org
Subject: [to-be-updated] x86-fix-handling-of-the-reservetop-boot-option.patch removed from -mm tree
Date: Wed, 28 Apr 2010 11:34:08 -0700
Message-ID: <201004281834.o3SIY8pe012406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754270Ab0D1SfR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Apr 2010 14:35:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liang.li@windriver.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, wangchen@cn.fujitsu.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     x86: fix handling of the 'reservetop' boot option
has been removed from the -mm tree.  Its filename was
     x86-fix-handling-of-the-reservetop-boot-option.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fix handling of the 'reservetop' boot option
From: Liang Li <liang.li@windriver.com>

When specifying the 'reservetop=0xbadc0de' kernel parameter, the kernel
will stop booting due to a early_ioremap bug that relate to commit
8827247ff ("x86: don't define __this_fixmap_does_not_exist()").

The root cause of boot failure problem is the value of 'slot_virt[i]' was
initialized in setup_arch->early_ioremap_init.  But later in setup_arch,
the function 'parse_early_param' will modify 'FIXADDR_TOP' when
'reservetop=0xbadc0de' being specified.

The simplest fix might be use __fix_to_virt(idx0) to get updated value
of 'FIXADDR_TOP' in '__early_ioremap' instead of reference old value
from slot_virt[slot] directly.

Signed-off-by: Liang Li <liang.li@windriver.com>
Cc: Wang Chen <wangchen@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/ioremap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/mm/ioremap.c~x86-fix-handling-of-the-reservetop-boot-option arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~x86-fix-handling-of-the-reservetop-boot-option
+++ a/arch/x86/mm/ioremap.c
@@ -537,9 +537,9 @@ __early_ioremap(resource_size_t phys_add
 		--nrpages;
 	}
 	if (early_ioremap_debug)
-		printk(KERN_CONT "%08lx + %08lx\n", offset, slot_virt[slot]);
+		printk(KERN_CONT "%08lx + %08lx\n", offset, __fix_to_virt(idx0));
 
-	prev_map[slot] = (void __iomem *)(offset + slot_virt[slot]);
+	prev_map[slot] = (void __iomem *)(offset + __fix_to_virt(idx0));
 	return prev_map[slot];
 }
 
_

Patches currently in -mm which might be from liang.li@windriver.com are

x86-fix-handling-of-the-reservetop-boot-option.patch

