From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-i386-optimization.patch added to -mm tree
Date: Wed, 14 Feb 2007 23:22:10 -0800
Message-ID: <200702150722.l1F7MAqL022853@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37663 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964962AbXBOHWX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 02:22:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, ak@muc.de


The patch titled
     Linux Kernel Markers: i386 optimization
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-i386-optimization.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: Linux Kernel Markers: i386 optimization
=46rom: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/Makefile |    1=20
 arch/i386/kernel/marker.c |   93 ++++++++++++++++++++++++++++++++++++
 include/asm-i386/marker.h |   47 ++++++++++++++++++
 3 files changed, 141 insertions(+)

diff -puN arch/i386/kernel/Makefile~linux-kernel-markers-i386-optimizat=
ion arch/i386/kernel/Makefile
--- a/arch/i386/kernel/Makefile~linux-kernel-markers-i386-optimization
+++ a/arch/i386/kernel/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_VM86)		+=3D vm86.o
 obj-$(CONFIG_EARLY_PRINTK)	+=3D early_printk.o
 obj-$(CONFIG_HPET_TIMER) 	+=3D hpet.o
 obj-$(CONFIG_K8_NB)		+=3D k8.o
+obj-$(CONFIG_MARKERS_ENABLE_OPTIMIZATION)	+=3D marker.o
=20
 obj-$(CONFIG_VMI)		+=3D vmi.o vmitime.o
 obj-$(CONFIG_PARAVIRT)		+=3D paravirt.o
diff -puN /dev/null arch/i386/kernel/marker.c
--- /dev/null
+++ a/arch/i386/kernel/marker.c
@@ -0,0 +1,93 @@
+/* marker.c
+ *
+ * Erratum 49 fix for Intel PIII and higher.
+ *
+ * Permits marker activation by XMC with correct serialization.
+ *
+ * Reentrant for NMI and trap handler instrumentation.=C2=A0:-)
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
+#include <asm/cacheflush.h>
+#include <asm/kdebug.h>
+
+#define BREAKPOINT_INSTRUCTION  0xcc
+#define BREAKPOINT_INS_LEN 1
+
+static DEFINE_MUTEX(mark_mutex);
+static long target_eip =3D 0;
+
+static void mark_synchronize_core(void *info)
+{
+	sync_core();	/* use cpuid to stop speculative execution */
+}
+
+/* We simply skip the 2 bytes load immediate here, leaving the registe=
r in an
+ * undefined state. We don't care about the content (0 or !0), because=
 we are
+ * changing the value 0->1 or 1->0. This small window of undefined val=
ue
+ * doesn't matter.
+ */
+static int mark_notifier(struct notifier_block *nb,
+	unsigned long val, void *data)
+{
+	enum die_val die_val =3D (enum die_val) val;
+	struct die_args *args =3D (struct die_args *)data;
+
+	if (!args->regs || user_mode_vm(args->regs))
+		return NOTIFY_DONE;
+
+	if (die_val =3D=3D DIE_INT3	&& args->regs->eip =3D=3D target_eip) {
+		args->regs->eip +=3D 1; /* Skip the next byte of load immediate */
+		return NOTIFY_STOP;
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block mark_notify =3D {
+	.notifier_call =3D mark_notifier,
+	.priority =3D 0x7fffffff,	/* we need to be notified first */
+};
+
+int arch_marker_set_ins_enable(void *address, char enable)
+{
+	char saved_byte;
+	int ret;
+	char *dest =3D address;
+
+	mutex_lock(&mark_mutex);
+	BUG_ON(!(enable ^ dest[1]));	/* Must be a state change 0<->1 */
+	target_eip =3D (long)address + BREAKPOINT_INS_LEN;
+	/* register_die_notifier has memory barriers */
+	register_die_notifier(&mark_notify);
+	saved_byte =3D *dest;
+	*dest =3D BREAKPOINT_INSTRUCTION;
+	wmb();
+	/* Execute serializing instruction on each CPU.
+	 * Acts as a memory barrier. */
+	ret =3D on_each_cpu(mark_synchronize_core, NULL, 1, 1);
+	BUG_ON(ret !=3D 0);
+
+	dest[1] =3D enable;
+	wmb();
+	*dest =3D saved_byte;
+		/* Wait for all int3 handlers to end
+		   (interrupts are disabled in int3).
+		   This CPU is clearly not in a int3 handler
+		   (not preemptible).
+		   synchronize_sched has memory barriers */
+	synchronize_sched();
+	unregister_die_notifier(&mark_notify);
+	/* unregister_die_notifier has memory barriers */
+	target_eip =3D 0;
+	mutex_unlock(&mark_mutex);
+	flush_icache_range(address, size);
+	return 0;
+}
+EXPORT_SYMBOL(arch_marker_set_ins_enable);
diff -puN /dev/null include/asm-i386/marker.h
--- /dev/null
+++ a/include/asm-i386/marker.h
@@ -0,0 +1,47 @@
+/*
+ * marker.h
+ *
+ * Code markup for dynamic and static tracing. i386 architecture optim=
isations.
+ *
+ * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+
+#ifdef CONFIG_MARKERS
+#define MARK(name, format, args...) \
+	do { \
+		static marker_probe_func *__mark_call_##name =3D \
+					__mark_empty_function; \
+		static const struct __mark_marker_c __mark_c_##name \
+			__attribute__((section(".markers.c"))) =3D \
+			{ #name, &__mark_call_##name, format, \
+			MARKER_OPTIMIZED } ; \
+		char condition; \
+		asm volatile(	".section .markers, \"a\";\n\t" \
+					".long %1, 0f;\n\t" \
+					".previous;\n\t" \
+					".align 2\n\t" \
+					"0:\n\t" \
+					"movb $0,%0;\n\t" \
+				: "=3Dr" (condition) \
+				: "m" (__mark_c_##name)); \
+		__mark_check_format(format, ## args); \
+		if (unlikely(condition)) { \
+			preempt_disable(); \
+			(*__mark_call_##name)(format, ## args); \
+			preempt_enable(); \
+		} \
+	} while (0)
+
+/* Offset of the immediate value from the start of the movb instructio=
n, in
+ * bytes. */
+#define MARK_ENABLE_IMMEDIATE_OFFSET 1
+#define MARK_ENABLE_TYPE char
+#define MARK_POLYMORPHIC
+
+extern int arch_marker_set_ins_enable(void *address, char enable);
+
+#endif
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.=
ca are

origin.patch
git-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64_xchg-to-s390.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dep=
endency.patch
local_t-architecture-independant-extension.patch
local_t-alpha-extension.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-s390-cleanup.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-non-optimized-architectures.patch
