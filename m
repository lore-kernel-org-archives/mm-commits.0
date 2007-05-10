From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-i386-optimization.patch removed from -mm tree
Date: Thu, 10 May 2007 15:32:20 -0700
Message-ID: <200705102232.l4AMWKCw032611@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46371 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694AbXEJWc7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 18:32:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, ak@muc.de, mm-commits@vger.kernel.org


The patch titled
     Linux Kernel Markers: i386 optimization
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-i386-optimization.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Linux Kernel Markers: i386 optimization
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

[akpm@linux-foundation.org: fix includes]
[bunk@stusta.de: marker exports must be EXPORT_SYMBOL_GPL]
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <>
---

 arch/i386/kernel/Makefile |    1 
 arch/i386/kernel/marker.c |   99 ++++++++++++++++++++++++++++++++++++
 include/asm-i386/marker.h |   79 ++++++++++++++++++++++++++++
 3 files changed, 179 insertions(+)

diff -puN arch/i386/kernel/Makefile~linux-kernel-markers-i386-optimization arch/i386/kernel/Makefile
--- a/arch/i386/kernel/Makefile~linux-kernel-markers-i386-optimization
+++ a/arch/i386/kernel/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_MODULES)		+= module.o
 obj-y				+= sysenter.o vsyscall.o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat.o
 obj-$(CONFIG_EFI) 		+= efi.o efi_stub.o
+obj-$(CONFIG_MARKERS_ENABLE_OPTIMIZATION)	+= marker.o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault.o
 obj-$(CONFIG_SERIAL_8250)	+= legacy_serial.o
 obj-$(CONFIG_VM86)		+= vm86.o
diff -puN /dev/null arch/i386/kernel/marker.c
--- /dev/null
+++ a/arch/i386/kernel/marker.c
@@ -0,0 +1,99 @@
+/* marker.c
+ *
+ * Erratum 49 fix for Intel PIII and higher.
+ *
+ * Permits marker activation by XMC with correct serialization.
+ *
+ * Reentrant for NMI and trap handler instrumentation. Permits XMC to a
+ * location that has preemption enabled because it involves no temporary or
+ * reused data structure.
+ *
+ * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ */
+
+#include <linux/notifier.h>
+#include <linux/mutex.h>
+#include <linux/preempt.h>
+#include <linux/smp.h>
+#include <linux/notifier.h>
+#include <linux/module.h>
+#include <linux/marker.h>
+#include <linux/kdebug.h>
+
+#include <asm/cacheflush.h>
+
+#define BREAKPOINT_INSTRUCTION  0xcc
+#define BREAKPOINT_INS_LEN 1
+
+static DEFINE_MUTEX(mark_mutex);
+static long target_eip = 0;
+
+static void mark_synchronize_core(void *info)
+{
+	sync_core();	/* use cpuid to stop speculative execution */
+}
+
+/* We simply skip the 2 bytes load immediate here, leaving the register in an
+ * undefined state. We don't care about the content (0 or !0), because we are
+ * changing the value 0->1 or 1->0. This small window of undefined value
+ * doesn't matter.
+ */
+static int mark_notifier(struct notifier_block *nb,
+	unsigned long val, void *data)
+{
+	enum die_val die_val = (enum die_val) val;
+	struct die_args *args = (struct die_args *)data;
+
+	if (!args->regs || user_mode_vm(args->regs))
+		return NOTIFY_DONE;
+
+	if (die_val == DIE_INT3	&& args->regs->eip == target_eip) {
+		args->regs->eip += 1; /* Skip the next byte of load immediate */
+		return NOTIFY_STOP;
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block mark_notify = {
+	.notifier_call = mark_notifier,
+	.priority = 0x7fffffff,	/* we need to be notified first */
+};
+
+int marker_optimized_set_enable(void *address, char enable)
+{
+	char saved_byte;
+	int ret;
+	char *dest = address;
+
+	if (!(enable ^ dest[1])) /* Must be a state change 0<->1 to execute */
+		return 0;
+
+	mutex_lock(&mark_mutex);
+	target_eip = (long)address + BREAKPOINT_INS_LEN;
+	/* register_die_notifier has memory barriers */
+	register_die_notifier(&mark_notify);
+	saved_byte = *dest;
+	*dest = BREAKPOINT_INSTRUCTION;
+	wmb();
+	/* Execute serializing instruction on each CPU.
+	 * Acts as a memory barrier. */
+	ret = on_each_cpu(mark_synchronize_core, NULL, 1, 1);
+	BUG_ON(ret != 0);
+
+	dest[1] = enable;
+	wmb();
+	*dest = saved_byte;
+		/* Wait for all int3 handlers to end
+		   (interrupts are disabled in int3).
+		   This CPU is clearly not in a int3 handler
+		   (not preemptible).
+		   synchronize_sched has memory barriers */
+	synchronize_sched();
+	unregister_die_notifier(&mark_notify);
+	/* unregister_die_notifier has memory barriers */
+	target_eip = 0;
+	mutex_unlock(&mark_mutex);
+	flush_icache_range(address, size);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(marker_optimized_set_enable);
diff -puN /dev/null include/asm-i386/marker.h
--- /dev/null
+++ a/include/asm-i386/marker.h
@@ -0,0 +1,79 @@
+#ifndef _ASM_I386_MARKER_H
+#define _ASM_I386_MARKER_H
+
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. i386 architecture optimisations.
+ *
+ * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
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
+					".long %1, 0f;\n\t" \
+					".previous;\n\t" \
+					".align 2\n\t" \
+					"0:\n\t" \
+					"movb $0,%0;\n\t" \
+				: "=r" (condition) \
+				: "m" (__mark_data_##name)); \
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
+	if (((flags) & MF_LOCKDEP) && ((flags) & MF_OPTIMIZED)) \
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
+/* Offset of the immediate value from the start of the movb instruction, in
+ * bytes. */
+#define MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET 1
+#define MARK_OPTIMIZED_ENABLE_TYPE char
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define MARK_OPTIMIZED_ENABLE(a) \
+	*(MARK_OPTIMIZED_ENABLE_TYPE*) \
+		((char*)a+MARK_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET)
+
+extern int marker_optimized_set_enable(void *address, char enable);
+
+#endif
+#endif //_ASM_I386_MARKER_H
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-avr32.patch
powerpc-promc-remove-undef-printk.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-update.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-non-optimized-architectures-update.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-update.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
