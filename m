From: akpm@linux-foundation.org
Subject: + x86-fix-handling-of-the-reservetop-boot-option.patch added to -mm tree
Date: Wed, 28 Apr 2010 11:36:17 -0700
Message-ID: <201004281836.o3SIaIsw012541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756388Ab0D1ShI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Apr 2010 14:37:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liang.li@windriver.com, akpm@linux-foundation.org, hpa@zytor.com, jeremy.fitzhardinge@citrix.com, konrad.wilk@oracle.com, mingo@elte.hu, tglx@linutronix.de, wangchen@cn.fujitsu.com, yinghai@kernel.org


The patch titled
     x86: fix handling of the 'reservetop' boot option
has been added to the -mm tree.  Its filename is
     x86-fix-handling-of-the-reservetop-boot-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

The simplest fix might be use __fix_to_virt(idx0) to get updated value of
'FIXADDR_TOP' in '__early_ioremap' instead of reference old value from
slot_virt[slot] directly.

Signed-off-by: Liang Li <liang.li@windriver.com>
Cc: Wang Chen <wangchen@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/io.h |    1 +
 arch/x86/mm/ioremap.c     |   15 +++++++++++++++
 arch/x86/mm/pgtable_32.c  |    1 +
 3 files changed, 17 insertions(+)

diff -puN arch/x86/include/asm/io.h~x86-fix-handling-of-the-reservetop-boot-option arch/x86/include/asm/io.h
--- a/arch/x86/include/asm/io.h~x86-fix-handling-of-the-reservetop-boot-option
+++ a/arch/x86/include/asm/io.h
@@ -347,6 +347,7 @@ extern void __iomem *early_ioremap(resou
 extern void __iomem *early_memremap(resource_size_t phys_addr,
 				    unsigned long size);
 extern void early_iounmap(void __iomem *addr, unsigned long size);
+extern void fixup_early_ioremap(void);
 
 #define IO_SPACE_LIMIT 0xffff
 
diff -puN arch/x86/mm/ioremap.c~x86-fix-handling-of-the-reservetop-boot-option arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~x86-fix-handling-of-the-reservetop-boot-option
+++ a/arch/x86/mm/ioremap.c
@@ -448,6 +448,21 @@ static inline void __init early_clear_fi
 static void __iomem *prev_map[FIX_BTMAPS_SLOTS] __initdata;
 static unsigned long prev_size[FIX_BTMAPS_SLOTS] __initdata;
 
+void __init fixup_early_ioremap(void)
+{
+	int i;
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
+		if (prev_map[i])
+			break;
+	}
+
+	if (i < FIX_BTMAPS_SLOTS)
+		BUG_ON(1);
+
+	early_ioremap_init();
+	return;
+}
+
 static int __init check_early_ioremap_leak(void)
 {
 	int count = 0;
diff -puN arch/x86/mm/pgtable_32.c~x86-fix-handling-of-the-reservetop-boot-option arch/x86/mm/pgtable_32.c
--- a/arch/x86/mm/pgtable_32.c~x86-fix-handling-of-the-reservetop-boot-option
+++ a/arch/x86/mm/pgtable_32.c
@@ -127,6 +127,7 @@ static int __init parse_reservetop(char 
 
 	address = memparse(arg, &arg);
 	reserve_top_address(address);
+	fixup_early_ioremap();
 	return 0;
 }
 early_param("reservetop", parse_reservetop);
_

Patches currently in -mm which might be from liang.li@windriver.com are

x86-fix-handling-of-the-reservetop-boot-option.patch

