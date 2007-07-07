From: akpm@linux-foundation.org
Subject: - immediate-value-powerpc-optimization.patch removed from -mm tree
Date: Fri, 06 Jul 2007 17:28:49 -0700
Message-ID: <200707070033.l670X0R0029886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37661 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753233AbXGGAdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 20:33:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     Immediate Value: PowerPC Optimization
has been removed from the -mm tree.  Its filename was
     immediate-value-powerpc-optimization.patch

This patch was dropped because it had testing failures

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
immediate-value-powerpc-optimization.patch
immediate-value-documentation.patch
f00f-bug-fixup-for-i386-use-immediate-values.patch
scheduler-profiling-use-immediate-values.patch
scheduler-profiling-use-immediate-values-fix.patch
cxgb3-vs-immediate-stuff.patch
use-data_data-in-cris.patch
add-missing-data_data-in-powerpc.patch
use-data_data-in-xtensa.patch
linux-kernel-markers-architecture-independent-code.patch
linux-kernel-markers-add-kconfig-menus-for-the-marker-code.patch
linux-kernel-markers-documentation.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
port-of-blktrace-to-the-linux-kernel-markers-fix.patch
