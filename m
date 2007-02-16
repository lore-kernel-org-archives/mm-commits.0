From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-documentation.patch added to -mm tree
Date: Thu, 15 Feb 2007 17:44:41 -0800
Message-ID: <200702160144.l1G1ifDO015709@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42742 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422997AbXBPBov (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 20:44:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     Linux Kernel Markers Documentation
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-documentation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Linux Kernel Markers Documentation
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Here is some documentation explaining what is/how to use the Linux
Kernel Markers.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/marker.txt |  130 +++++++++++++++++++++++++++++++++++++
 1 files changed, 130 insertions(+)

diff -puN /dev/null Documentation/marker.txt
--- /dev/null
+++ a/Documentation/marker.txt
@@ -0,0 +1,130 @@
+ 	             Using the Linux Kernel Markers
+
+			    Mathieu Desnoyers
+
+
+	This document discusses the purpose of markers. It shows some usage
+examples of the Linux Kernel Markers : how to insert markers within the kernel
+and how to connect probes to a marker. Finally, it has some probe module
+examples. This is what connects to a marker.
+
+
+* Purpose of markers
+
+You can put markers at important locations in the code. They act as
+lightweight hooks that can pass an arbitrary number of parameters,
+described in a printk-like format string, to a function whenever the marker
+code is reached.
+
+They can be used for tracing (LTTng, LKET over SystemTAP), overall performance
+accounting (SystemTAP). They could also be used to implement
+efficient hooks for SELinux or any other subsystem the would have this
+kind of need.
+
+Using the markers for system audit (SELinux) would require to pass a
+variable by address that would be later checked by the marked routine.
+
+
+* Usage
+
+MARK(subsystem_event, "%d %s %p[struct task_struct]",
+  someint, somestring, current);
+Where :
+- Subsystem is the name of your subsystem.
+- event is the name of the event to mark.
+- "%d %s %p[struct task_struct]" is the formatted string for (printk-style).
+- someint is an integer.
+- somestring is a char pointer.
+- current is a pointer to a struct task_struct.
+
+The expression %p[struct task_struct] is a suggested marker definition
+standard that could eventually be used for pointer type checking in
+sparse. The brackets contain the type to which the pointer refer.
+
+The marker mechanism supports multiple instances of the same marker.
+Markers can be put in inline functions, inlined static functions and
+unrolled loops.
+
+Note : It is safe to put markers within preempt-safe code : preempt_enable()
+will not call the scheduler due to the tests in preempt_schedule().
+
+
+* Optimization for a given architecture
+
+You will find, in asm-*/marker.h, optimisations for given architectures
+(currently i386 and powerpc). They use a load immediate instead of a data read,
+which saves a data cache hit, but also requires cross CPU code modification. In
+order to support embedded systems which use read-only memory for their code, the
+optimization can be disabled through menu options.
+
+
+* Probe example
+
+------------------------------ CUT -------------------------------------
+/* probe-example.c
+ *
+ * Loads a function at a marker call site.
+ *
+ * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <linux/sched.h>
+#include <linux/kernel.h>
+
+#define SUBSYSTEM_EVENT_FORMAT "%d %s %p[struct task_struct]"
+void probe_subsystem_event(const char *format, ...)
+{
+	va_list ap;
+	/* Declare args */
+	unsigned int value;
+	const char *mystr;
+	struct task_struct *task;
+
+	/* Assign args */
+	va_start(ap, format);
+	value = va_arg(ap, typeof(value));
+	mystr = va_arg(ap, typeof(mystr));
+	task = va_arg(ap, typeof(task));
+
+	/* Call tracer */
+	trace_subsystem_event(value, mystr, task);
+
+	/* Or call printk */
+	vprintk(format, ap);
+
+	/* or count, check rights... */
+
+	va_end(ap);
+}
+
+static int __init probe_init(void)
+{
+	int result;
+	result = marker_set_probe("subsystem_event",
+			FS_CLOSE_FORMAT,
+			probe_fs_close);
+	if (!result)
+		goto cleanup;
+	return 0;
+
+cleanup:
+	marker_remove_probe(probe_subsystem_event);
+	return -EPERM;
+}
+
+static void __exit probe_fini(void)
+{
+	marker_remove_probe(probe_subsystem_event);
+}
+
+module_init(probe_init);
+module_exit(probe_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("SUBSYSTEM Probe");
+------------------------------ CUT -------------------------------------
+
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
powerpc-move-of_irq_to_resource-to-prom_parsec.patch
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
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
local_t-architecture-independant-extension.patch
local_t-alpha-extension.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-mips-extension-fix.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-powerpc-extension-fix.patch
local_t-s390-cleanup.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-kconfig-menus-fix.patch
linux-kernel-markers-kconfig-menus-fix-2.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-documentation.patch
