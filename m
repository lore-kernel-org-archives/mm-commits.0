From: akpm@linux-foundation.org
Subject: + um-clean-up-delay-functions.patch added to -mm tree
Date: Fri, 17 Jun 2011 15:31:38 -0700
Message-ID: <201106172231.p5HMVcPb004950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756614Ab1FQWiA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jun 2011 18:38:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at


The patch titled
     um: clean up delay functions
has been added to the -mm tree.  Its filename is
     um-clean-up-delay-functions.patch

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
Subject: um: clean up delay functions
From: Richard Weinberger <richard@nod.at>

Both sys-i386 and sys-x86_64 support now ndelay().  The delay functions
are based on arch/x86/lib/delay.c.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/delay.h |    8 +---
 arch/um/sys-i386/delay.c    |   63 +++++++++++++++++++++++++---------
 arch/um/sys-x86_64/delay.c  |   56 +++++++++++++++++++++++-------
 3 files changed, 92 insertions(+), 35 deletions(-)

diff -puN arch/um/include/asm/delay.h~um-clean-up-delay-functions arch/um/include/asm/delay.h
--- a/arch/um/include/asm/delay.h~um-clean-up-delay-functions
+++ a/arch/um/include/asm/delay.h
@@ -1,8 +1,6 @@
 #ifndef __UM_DELAY_H
 #define __UM_DELAY_H
 
-#define MILLION 1000000
-
 /* Undefined on purpose */
 extern void __bad_udelay(void);
 
@@ -12,9 +10,7 @@ extern void __delay(unsigned long loops)
 #define udelay(n) ((__builtin_constant_p(n) && (n) > 20000) ? \
 	__bad_udelay() : __udelay(n))
 
-/* It appears that ndelay is not used at all for UML, and has never been
- * implemented. */
-extern void __unimplemented_ndelay(void);
-#define ndelay(n) __unimplemented_ndelay()
+#define ndelay(n) ((__builtin_constant_p(n) && (n) > 20000) ? \
+	__bad_udelay() : __ndelay(n))
 
 #endif
diff -puN arch/um/sys-i386/delay.c~um-clean-up-delay-functions arch/um/sys-i386/delay.c
--- a/arch/um/sys-i386/delay.c~um-clean-up-delay-functions
+++ a/arch/um/sys-i386/delay.c
@@ -1,29 +1,60 @@
+/*
+ * Copyright (C) 2011 Richard Weinberger <richrd@nod.at>
+ * Mostly copied from arch/x86/lib/delay.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <asm/param.h>
 
-void __delay(unsigned long time)
+void __delay(unsigned long loops)
 {
-	/* Stolen from the i386 __loop_delay */
-	int d0;
-	__asm__ __volatile__(
-		"\tjmp 1f\n"
-		".align 16\n"
-		"1:\tjmp 2f\n"
-		".align 16\n"
-		"2:\tdecl %0\n\tjns 2b"
-		:"=&a" (d0)
-		:"0" (time));
+	asm volatile(
+		" test %0,%0  \n"
+		" jz 3f   \n"
+		" jmp 1f    \n"
+
+		".align 16    \n"
+		"1: jmp 2f    \n"
+
+		".align 16    \n"
+		"2: dec %0    \n"
+		" jnz 2b    \n"
+		"3: dec %0    \n"
+
+		: /* we don't need output */
+		:"a" (loops)
+	);
 }
+EXPORT_SYMBOL(__delay);
 
-void __udelay(unsigned long usecs)
+inline void __const_udelay(unsigned long xloops)
 {
-	int i, n;
+	int d0;
 
-	n = (loops_per_jiffy * HZ * usecs) / MILLION;
-        for(i=0;i<n;i++)
-                cpu_relax();
+	xloops *= 4;
+	asm("mull %%edx"
+		:"=d" (xloops), "=&a" (d0)
+		:"1" (xloops), "0"
+		(loops_per_jiffy * (HZ/4)));
+
+	__delay(++xloops);
 }
+EXPORT_SYMBOL(__const_udelay);
 
+void __udelay(unsigned long usecs)
+{
+	__const_udelay(usecs * 0x000010c7); /* 2**32 / 1000000 (rounded up) */
+}
 EXPORT_SYMBOL(__udelay);
+
+void __ndelay(unsigned long nsecs)
+{
+	__const_udelay(nsecs * 0x00005); /* 2**32 / 1000000000 (rounded up) */
+}
+EXPORT_SYMBOL(__ndelay);
diff -puN arch/um/sys-x86_64/delay.c~um-clean-up-delay-functions arch/um/sys-x86_64/delay.c
--- a/arch/um/sys-x86_64/delay.c~um-clean-up-delay-functions
+++ a/arch/um/sys-x86_64/delay.c
@@ -1,30 +1,60 @@
 /*
- * Copyright 2003 PathScale, Inc.
- * Copied from arch/x86_64
+ * Copyright (C) 2011 Richard Weinberger <richrd@nod.at>
+ * Mostly copied from arch/x86/lib/delay.c
  *
- * Licensed under the GPL
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  */
 
 #include <linux/module.h>
+#include <linux/kernel.h>
 #include <linux/delay.h>
-#include <asm/processor.h>
 #include <asm/param.h>
 
 void __delay(unsigned long loops)
 {
-	unsigned long i;
-
-        for(i = 0; i < loops; i++)
-                cpu_relax();
+	asm volatile(
+		" test %0,%0  \n"
+		" jz 3f   \n"
+		" jmp 1f    \n"
+
+		".align 16    \n"
+		"1: jmp 2f    \n"
+
+		".align 16    \n"
+		"2: dec %0    \n"
+		" jnz 2b    \n"
+		"3: dec %0    \n"
+
+		: /* we don't need output */
+		:"a" (loops)
+	);
 }
+EXPORT_SYMBOL(__delay);
 
-void __udelay(unsigned long usecs)
+inline void __const_udelay(unsigned long xloops)
 {
-	unsigned long i, n;
+	int d0;
+
+	xloops *= 4;
+	asm("mull %%edx"
+		:"=d" (xloops), "=&a" (d0)
+		:"1" (xloops), "0"
+		(loops_per_jiffy * (HZ/4)));
 
-	n = (loops_per_jiffy * HZ * usecs) / MILLION;
-        for(i=0;i<n;i++)
-                cpu_relax();
+	__delay(++xloops);
 }
+EXPORT_SYMBOL(__const_udelay);
 
+void __udelay(unsigned long usecs)
+{
+	__const_udelay(usecs * 0x000010c7); /* 2**32 / 1000000 (rounded up) */
+}
 EXPORT_SYMBOL(__udelay);
+
+void __ndelay(unsigned long nsecs)
+{
+	__const_udelay(nsecs * 0x00005); /* 2**32 / 1000000000 (rounded up) */
+}
+EXPORT_SYMBOL(__ndelay);
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch
um-add-asm-percpuh.patch
linux-next.patch
um-clean-up-vm-flagsh.patch
um-clean-up-delay-functions.patch
fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch

