From: akpm@linux-foundation.org
Subject: [merged] um-clean-up-delay-functions-v2.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:54:22 -0700
Message-ID: <201107260753.p6Q7rPUh003228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753056Ab1GZHyT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:54:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     um: clean up delay functions
has been removed from the -mm tree.  Its filename was
     um-clean-up-delay-functions-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: clean up delay functions
From: Richard Weinberger <richard@nod.at>

Both sys-i386 and sys-x86_64 support now ndelay().  The delay functions
are based on arch/x86/lib/delay.c.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/delay.h |   10 ++---
 arch/um/sys-i386/delay.c    |   59 +++++++++++++++++++++++++---------
 arch/um/sys-x86_64/delay.c  |   56 ++++++++++++++++++++++++--------
 3 files changed, 92 insertions(+), 33 deletions(-)

diff -puN arch/um/include/asm/delay.h~um-clean-up-delay-functions-v2 arch/um/include/asm/delay.h
--- a/arch/um/include/asm/delay.h~um-clean-up-delay-functions-v2
+++ a/arch/um/include/asm/delay.h
@@ -1,20 +1,18 @@
 #ifndef __UM_DELAY_H
 #define __UM_DELAY_H
 
-#define MILLION 1000000
-
 /* Undefined on purpose */
 extern void __bad_udelay(void);
+extern void __bad_ndelay(void);
 
 extern void __udelay(unsigned long usecs);
+extern void __ndelay(unsigned long usecs);
 extern void __delay(unsigned long loops);
 
 #define udelay(n) ((__builtin_constant_p(n) && (n) > 20000) ? \
 	__bad_udelay() : __udelay(n))
 
-/* It appears that ndelay is not used at all for UML, and has never been
- * implemented. */
-extern void __unimplemented_ndelay(void);
-#define ndelay(n) __unimplemented_ndelay()
+#define ndelay(n) ((__builtin_constant_p(n) && (n) > 20000) ? \
+	__bad_ndelay() : __ndelay(n))
 
 #endif
diff -puN arch/um/sys-i386/delay.c~um-clean-up-delay-functions-v2 arch/um/sys-i386/delay.c
--- a/arch/um/sys-i386/delay.c~um-clean-up-delay-functions-v2
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
+	asm volatile(
+		"test %0,%0\n"
+		"jz 3f\n"
+		"jmp 1f\n"
+
 		".align 16\n"
-		"1:\tjmp 2f\n"
+		"1: jmp 2f\n"
+
 		".align 16\n"
-		"2:\tdecl %0\n\tjns 2b"
-		:"=&a" (d0)
-		:"0" (time));
+		"2: dec %0\n"
+		" jnz 2b\n"
+		"3: dec %0\n"
+
+		: /* we don't need output */
+		: "a" (loops)
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
+		: "=d" (xloops), "=&a" (d0)
+		: "1" (xloops), "0"
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
diff -puN arch/um/sys-x86_64/delay.c~um-clean-up-delay-functions-v2 arch/um/sys-x86_64/delay.c
--- a/arch/um/sys-x86_64/delay.c~um-clean-up-delay-functions-v2
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
+		"test %0,%0\n"
+		"jz 3f\n"
+		"jmp 1f\n"
+
+		".align 16\n"
+		"1: jmp 2f\n"
+
+		".align 16\n"
+		"2: dec %0\n"
+		" jnz 2b\n"
+		"3: dec %0\n"
+
+		: /* we don't need output */
+		: "a" (loops)
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
+		: "=d" (xloops), "=&a" (d0)
+		: "1" (xloops), "0"
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
fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch
exec-do-not-call-request_module-twice-from-search_binary_handler.patch
exec-do-not-retry-load_binary-method-if-config_modules=n.patch
gcov-disable-constructors-for-uml.patch

