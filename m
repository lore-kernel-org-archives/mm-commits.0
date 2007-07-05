From: akpm@linux-foundation.org
Subject: + immediate-value-powerpc-optimization.patch added to -mm tree
Date: Thu, 05 Jul 2007 13:22:03 -0700
Message-ID: <200707052022.l65KM3af017118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53625 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759590AbXGEUWP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 16:22:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     Immediate Value: PowerPC Optimization
has been added to the -mm tree.  Its filename is
     immediate-value-powerpc-optimization.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Immediate Value: PowerPC Optimization
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

PowerPC optimization of the immediate values which uses a li instruction,
patched with an immediate value 0 or 1 to set the immediate value.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/Makefile    |    1 
 arch/powerpc/kernel/immediate.c |   29 ++++++++++++
 include/asm-powerpc/immediate.h |   69 +++++++++++++++++++++++++++++-
 3 files changed, 98 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/Makefile~immediate-value-powerpc-optimization arch/powerpc/kernel/Makefile
--- a/arch/powerpc/kernel/Makefile~immediate-value-powerpc-optimization
+++ a/arch/powerpc/kernel/Makefile
@@ -103,3 +103,4 @@ obj-$(CONFIG_PPC64)		+= $(obj64-y)
 
 extra-$(CONFIG_PPC_FPU)		+= fpu.o
 extra-$(CONFIG_PPC64)		+= entry_64.o
+obj-$(CONFIG_IMMEDIATE)		+= immediate.o
diff -puN /dev/null arch/powerpc/kernel/immediate.c
--- /dev/null
+++ a/arch/powerpc/kernel/immediate.c
@@ -0,0 +1,29 @@
+/*
+ * Powerpc optimized immediate values enabling/disabling.
+ *
+ * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ */
+
+#include <linux/module.h>
+#include <linux/immediate.h>
+#include <linux/string.h>
+#include <asm/cacheflush.h>
+#include <asm/page.h>
+
+/*
+ * The address is aligned on 4 bytes boundary: the 4 bytes instruction we are
+ * changing fits within one page.
+ */
+int immediate_optimized_set_enable(void *address, char enable)
+{
+	char newi[IMMEDIATE_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET+1];
+	int size = IMMEDIATE_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET
+			+ sizeof(IMMEDIATE_OPTIMIZED_ENABLE_TYPE);
+
+	memcpy(newi, address, size);
+	IMMEDIATE_OPTIMIZED_ENABLE(&newi[0]) = enable;
+	memcpy(address, newi, size);
+	flush_icache_range((unsigned long)address, size);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(immediate_optimized_set_enable);
diff -puN include/asm-powerpc/immediate.h~immediate-value-powerpc-optimization include/asm-powerpc/immediate.h
--- a/include/asm-powerpc/immediate.h~immediate-value-powerpc-optimization
+++ a/include/asm-powerpc/immediate.h
@@ -1 +1,68 @@
-#include <asm-generic/immediate.h>
+#ifndef _ASM_POWERPC_IMMEDIATE_H
+#define _ASM_POWERPC_IMMEDIATE_H
+
+/*
+ * Immediate values. PowerPC architecture optimizations.
+ *
+ * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm/asm-compat.h>
+
+#define IF_DEFAULT (IF_OPTIMIZED | IF_LOCKDEP)
+
+/* Optimized version of the immediate */
+#define immediate_optimized(flags, var)					\
+	({								\
+		char condition;						\
+		asm (	".section __immediate, \"a\", @progbits;\n\t"	\
+					PPC_LONG "%1, 0f, %2;\n\t"	\
+					".previous;\n\t"		\
+					".align 4\n\t"			\
+					"0:\n\t"			\
+					"li %0,%3;\n\t"			\
+				: "=r" (condition)			\
+				: "i" (&var),				\
+				  "i" (flags),				\
+				  "i" (0));				\
+		condition;						\
+	})
+
+/*
+ * immediate macro selecting the generic or optimized version of immediate,
+ * depending on the flags specified. It is a macro because we need to pass the
+ * name to immediate_optimized() and immediate_generic() so they can declare a
+ * static variable with it.
+ */
+#define _immediate(flags, var)						\
+({									\
+	((flags) & IF_OPTIMIZED) ?					\
+		immediate_optimized(flags, var) :			\
+		immediate_generic(flags, var);				\
+})
+
+/* immediate with default behavior */
+#define immediate(var)	 _immediate(IF_DEFAULT, var)
+
+/*
+ * Architecture dependant immediate information, used internally for immediate
+ * activation.
+ */
+
+/*
+ * Offset of the immediate value from the start of the addi instruction (result
+ * of the li mnemonic), in bytes.
+ */
+#define IMMEDIATE_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET 2
+#define IMMEDIATE_OPTIMIZED_ENABLE_TYPE unsigned short
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define IMMEDIATE_OPTIMIZED_ENABLE(a)					\
+	(*(IMMEDIATE_OPTIMIZED_ENABLE_TYPE*)				\
+		((char*)(a)+IMMEDIATE_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET))
+
+extern int immediate_optimized_set_enable(void *address, char enable);
+
+#endif /* _ASM_POWERPC_IMMEDIATE_H */
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-promc-remove-undef-printk.patch
i386-text-edit-lock.patch
i386-text-edit-lock-alternative-instructions.patch
i386-text-edit-lock-kprobes.patch
immediate-values-global-modules-list-and-module-mutex.patch
immediate-value-architecture-independent-code.patch
immediate-values-non-optimized-architectures.patch
immediate-value-add-kconfig-menus.patch
immediate-values-kprobe-header-fix.patch
immediate-value-i386-optimization.patch
immediate-value-powerpc-optimization.patch
immediate-value-documentation.patch
f00f-bug-fixup-for-i386-use-immediate-values.patch
scheduler-profiling-use-immediate-values.patch
