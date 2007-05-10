From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-powerpc-optimization.patch removed from -mm tree
Date: Thu, 10 May 2007 15:32:12 -0700
Message-ID: <200705102232.l4AMWCon032598@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756708AbXEJWc1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 18:32:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Linux Kernel Markers: powerpc optimization
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-powerpc-optimization.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Linux Kernel Markers: powerpc optimization
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/Makefile |    1 
 arch/powerpc/kernel/marker.c |   25 ++++++++++
 include/asm-powerpc/marker.h |   81 +++++++++++++++++++++++++++++++++
 3 files changed, 107 insertions(+)

diff -puN arch/powerpc/kernel/Makefile~linux-kernel-markers-powerpc-optimization arch/powerpc/kernel/Makefile
--- a/arch/powerpc/kernel/Makefile~linux-kernel-markers-powerpc-optimization
+++ a/arch/powerpc/kernel/Makefile
@@ -96,3 +96,4 @@ obj-$(CONFIG_PPC64)		+= $(obj64-y)
 
 extra-$(CONFIG_PPC_FPU)		+= fpu.o
 extra-$(CONFIG_PPC64)		+= entry_64.o
+obj-$(CONFIG_MARKERS_ENABLE_OPTIMIZATION)	+= marker.o
diff -puN /dev/null arch/powerpc/kernel/marker.c
--- /dev/null
+++ a/arch/powerpc/kernel/marker.c
@@ -0,0 +1,25 @@
+/* marker.c
+ *
+ * Powerpc optimized marker enabling/disabling.
+ *
+ * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ */
+
+#include <linux/module.h>
+#include <linux/marker.h>
+#include <linux/string.h>
+#include <asm/cacheflush.h>
+
+int marker_optimized_set_enable(void *address, char enable)
+{
+	char newi[MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET+1];
+	int size = MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET
+			+ sizeof(MARK_OPTIMIZED_ENABLE_TYPE);
+
+	memcpy(newi, address, size);
+	MARK_OPTIMIZED_ENABLE(&newi[0]) = enable;
+	memcpy(address, newi, size);
+	flush_icache_range((unsigned long)address, size);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(marker_optimized_set_enable);
diff -puN /dev/null include/asm-powerpc/marker.h
--- /dev/null
+++ a/include/asm-powerpc/marker.h
@@ -0,0 +1,81 @@
+#ifndef _ASM_POWERPC_MARKER_H
+#define _ASM_POWERPC_MARKER_H
+
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. PowerPC architecture
+ * optimisations.
+ *
+ * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm/asm-compat.h>
+
+#ifdef CONFIG_MARKERS
+
+#define MF_DEFAULT (MF_OPTIMIZED | MF_LOCKDEP | MF_PRINTK)
+
+/* Optimized version of the markers */
+#define MARK_OPTIMIZED(flags, name, format, args...) \
+	do { \
+		static const char __mstrtab_name_##name[] \
+		__attribute__((section("__markers_strings"))) \
+		= #name; \
+		static const char __mstrtab_format_##name[] \
+		__attribute__((section("__markers_strings"))) \
+		= format; \
+		static struct __mark_marker_data __mark_data_##name \
+		__attribute__((section("__markers_data"))) = \
+		{ __mstrtab_name_##name,  __mstrtab_format_##name, \
+		(flags) | MF_OPTIMIZED, __mark_empty_function, NULL }; \
+		char condition; \
+		asm volatile(	".section __markers, \"a\", @progbits;\n\t" \
+					PPC_LONG "%1, 0f;\n\t" \
+					".previous;\n\t" \
+					".align 4\n\t" \
+					"0:\n\t" \
+					"li %0,0;\n\t" \
+				: "=r" (condition) \
+				: "i" (&__mark_data_##name)); \
+		__mark_check_format(format, ## args); \
+		if (unlikely(condition)) { \
+			preempt_disable(); \
+			(*__mark_data_##name.call)(&__mark_data_##name, \
+						format, ## args); \
+			preempt_enable(); \
+		} \
+	} while (0)
+
+/* Marker macro selecting the generic or optimized version of marker, depending
+ * on the flags specified. */
+#define _trace_mark(flags, format, args...) \
+do { \
+	if ((flags) & MF_OPTIMIZED) \
+		MARK_OPTIMIZED(flags, format, ## args); \
+	else \
+		MARK_GENERIC(flags, format, ## args); \
+} while (0)
+
+/* Marker with default behavior */
+#define trace_mark(format, args...) _trace_mark(MF_DEFAULT, format, ## args)
+
+/* Architecture dependant marker information, used internally for marker
+ * activation. */
+
+/* Offset of the immediate value from the start of the addi instruction (result
+ * of the li mnemonic), in bytes. */
+#define MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET 2
+#define MARK_OPTIMIZED_ENABLE_TYPE short
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define MARK_OPTIMIZED_ENABLE(a) \
+	*(MARK_OPTIMIZED_ENABLE_TYPE*) \
+		((char*)a+MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET)
+
+extern int marker_optimized_set_enable(void *address, char enable);
+
+#endif
+#endif //_ASM_POWERPC_MARKER_H
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-avr32.patch
powerpc-promc-remove-undef-printk.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-powerpc-optimization-update.patch
linux-kernel-markers-powerpc-optimization-fix.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-update.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-non-optimized-architectures-update.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-update.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
