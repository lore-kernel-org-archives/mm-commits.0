From: akpm@linux-foundation.org
Subject: [wrecked] arm-translate-delays-into-mostly-c.patch removed from -mm tree
Date: Wed, 12 Jan 2011 13:41:54 -0800
Message-ID: <201101122144.p0CLiRHq005387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756409Ab1ALVod (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 16:44:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, nicolas.pitre@linaro.org, skannan@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     arm: translate delay.S into (mostly) C
has been removed from the -mm tree.  Its filename was
     arm-translate-delays-into-mostly-c.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: translate delay.S into (mostly) C
From: Stephen Boyd <sboyd@codeaurora.org>

We want to allow machines to override the __delay() implementation at
runtime so they can use a timer based __delay() routine.  It's easier to
do this using C, so let's write udelay and friends in C.

We lose the #if 0 code, which according to Russell is used "to make the
delay loop more stable and predictable on older CPUs" (see
http://article.gmane.org/gmane.linux.kernel/888867 for more info).  We
shouldn't be too worried though, since we'll soon add functionality
allowing a machine to set the __delay() loop themselves, thus allowing
machines to resurrect the commented out code should they need it.

Nico expressed concern that fixed lpj cmdlines will break due to compiler
optimizations.  That doesn't seem to be the case since before and after
this patch I get the same lpj value when running my CPU at 19.2 MHz.  That
should be sufficiently slow enough to cover any machine running Linux.

This will break builds when you switch back and forth without this patch. 
You need to rm arch/arm/lib/.delay.o.cmd if you ever build a kernel before
this patch after you've built with this patch.

 delete mode 100644 arch/arm/lib/delay.S
 create mode 100644 arch/arm/lib/delay.c

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/delay.h |    2 -
 arch/arm/kernel/armksyms.c   |    4 --
 arch/arm/lib/delay.S         |   65 ---------------------------------
 arch/arm/lib/delay.c         |   56 ++++++++++++++++++++++++++++
 4 files changed, 57 insertions(+), 70 deletions(-)

diff -puN arch/arm/include/asm/delay.h~arm-translate-delays-into-mostly-c arch/arm/include/asm/delay.h
--- a/arch/arm/include/asm/delay.h~arm-translate-delays-into-mostly-c
+++ a/arch/arm/include/asm/delay.h
@@ -8,7 +8,7 @@
 
 #include <asm/param.h>	/* HZ */
 
-extern void __delay(int loops);
+extern void __delay(unsigned long loops);
 
 /*
  * This function intentionally does not exist; if you see references to
diff -puN arch/arm/kernel/armksyms.c~arm-translate-delays-into-mostly-c arch/arm/kernel/armksyms.c
--- a/arch/arm/kernel/armksyms.c~arm-translate-delays-into-mostly-c
+++ a/arch/arm/kernel/armksyms.c
@@ -52,10 +52,6 @@ extern void fpundefinstr(void);
 
 EXPORT_SYMBOL(__backtrace);
 
-	/* platform dependent support */
-EXPORT_SYMBOL(__udelay);
-EXPORT_SYMBOL(__const_udelay);
-
 	/* networking */
 EXPORT_SYMBOL(csum_partial);
 EXPORT_SYMBOL(csum_partial_copy_from_user);
diff -puN arch/arm/lib/delay.S~arm-translate-delays-into-mostly-c /dev/null
--- a/arch/arm/lib/delay.S
+++ /dev/null
@@ -1,65 +0,0 @@
-/*
- *  linux/arch/arm/lib/delay.S
- *
- *  Copyright (C) 1995, 1996 Russell King
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/linkage.h>
-#include <asm/assembler.h>
-#include <asm/param.h>
-		.text
-
-.LC0:		.word	loops_per_jiffy
-.LC1:		.word	(2199023*HZ)>>11
-
-/*
- * r0  <= 2000
- * lpj <= 0x01ffffff (max. 3355 bogomips)
- * HZ  <= 1000
- */
-
-ENTRY(__udelay)
-		ldr	r2, .LC1
-		mul	r0, r2, r0
-ENTRY(__const_udelay)				@ 0 <= r0 <= 0x7fffff06
-		ldr	r2, .LC0
-		ldr	r2, [r2]		@ max = 0x01ffffff
-		mov	r0, r0, lsr #14		@ max = 0x0001ffff
-		mov	r2, r2, lsr #10		@ max = 0x00007fff
-		mul	r0, r2, r0		@ max = 2^32-1
-		movs	r0, r0, lsr #6
-		moveq	pc, lr
-
-/*
- * loops = r0 * HZ * loops_per_jiffy / 1000000
- *
- * Oh, if only we had a cycle counter...
- */
-
-@ Delay routine
-ENTRY(__delay)
-		subs	r0, r0, #1
-#if 0
-		movls	pc, lr
-		subs	r0, r0, #1
-		movls	pc, lr
-		subs	r0, r0, #1
-		movls	pc, lr
-		subs	r0, r0, #1
-		movls	pc, lr
-		subs	r0, r0, #1
-		movls	pc, lr
-		subs	r0, r0, #1
-		movls	pc, lr
-		subs	r0, r0, #1
-		movls	pc, lr
-		subs	r0, r0, #1
-#endif
-		bhi	__delay
-		mov	pc, lr
-ENDPROC(__udelay)
-ENDPROC(__const_udelay)
-ENDPROC(__delay)
diff -puN /dev/null arch/arm/lib/delay.c
--- /dev/null
+++ a/arch/arm/lib/delay.c
@@ -0,0 +1,56 @@
+/*
+ *  Originally from linux/arch/arm/lib/delay.S
+ *
+ *  Copyright (C) 1995, 1996 Russell King
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/delay.h>
+
+/*
+ * loops = usecs * HZ * loops_per_jiffy / 1000000
+ *
+ * Oh, if only we had a cycle counter...
+ */
+void __delay(unsigned long loops)
+{
+	asm volatile(
+	"1:	subs %0, %0, #1 \n"
+	"	bhi 1b		\n"
+	: /* No output */
+	: "r" (loops)
+	);
+}
+EXPORT_SYMBOL(__delay);
+
+/*
+ * 0 <= xloops <= 0x7fffff06
+ * loops_per_jiffy <= 0x01ffffff (max. 3355 bogomips)
+ */
+void __const_udelay(unsigned long xloops)
+{
+	unsigned long lpj;
+	unsigned long loops;
+
+	xloops >>= 14;			/* max = 0x01ffffff */
+	lpj = loops_per_jiffy >> 10;	/* max = 0x0001ffff */
+	loops = lpj * xloops;		/* max = 0x00007fff */
+	loops >>= 6;			/* max = 2^32-1 */
+
+	if (likely(loops))
+		__delay(loops);
+}
+EXPORT_SYMBOL(__const_udelay);
+
+/*
+ * usecs  <= 2000
+ * HZ  <= 1000
+ */
+void __udelay(unsigned long usecs)
+{
+	__const_udelay(usecs * ((2199023*HZ)>>11));
+}
+EXPORT_SYMBOL(__udelay);
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

origin.patch
arm-allow-machines-to-override-__delay.patch
arm-implement-a-timer-based-__delay-loop.patch
msm-timer-migrate-to-timer-based-__delay.patch

