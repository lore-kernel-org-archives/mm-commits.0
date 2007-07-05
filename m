From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-documentation.patch added to -mm tree
Date: Thu, 05 Jul 2007 13:27:51 -0700
Message-ID: <200707052027.l65KRpmv017441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57572 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757777AbXGEU2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 16:28:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     Linux Kernel Markers: documentation
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-documentation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Linux Kernel Markers: documentation
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Here is some documentation explaining what is/how to use the Linux
Kernel Markers.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/marker.txt |  249 +++++++++++++++++++++++++++++++++++++
 1 files changed, 249 insertions(+)

diff -puN /dev/null Documentation/marker.txt
--- /dev/null
+++ a/Documentation/marker.txt
@@ -0,0 +1,249 @@
+ 	             Using the Linux Kernel Markers
+
+			    Mathieu Desnoyers
+
+
+This document introduces Linux Kernel Markers and their use. It provides
+examples of how to insert markers in the kernel and connect probe functions to
+them and provides some examples of probe functions.
+
+
+* Purpose of markers
+
+A marker placed in your code provides a hook to call a function (probe) that
+you can provide at runtime. A marker can be "on" (a probe is connected to it)
+or "off" (no probe is attached). When a marker is "off" it has no
+effect. When a marker is "on", the function you provide is called each
+time the marker is executed, in the execution context of the
+caller. When the function provided ends its execution, it returns to the
+caller (continuing from the marker site).
+
+You can put markers at important locations in the code. Markers are
+lightweight hooks that can pass an arbitrary number of parameters,
+described in a printk-like format string, to the attached probe function.
+
+They can be used for tracing and performance accounting.
+
+
+* Usage
+
+In order to use the macro trace_mark, you should include linux/marker.h.
+
+#include <linux/marker.h>
+
+Add, in your code :
+
+trace_mark(subsystem_event, "%d %s", someint, somestring);
+Where :
+- subsystem_event is an identifier unique to your event
+    - subsystem is the name of your subsystem.
+    - event is the name of the event to mark.
+- "%d %s" is the formatted string for the serializer.
+- someint is an integer.
+- somestring is a char pointer.
+
+Connecting a function (probe) to a marker is done by providing a probe
+(function to call) for the specific marker through marker_arm_probe(). It will
+automatically connect the function and enable the marker site. Removing a probe
+is done through marker_disarm_probe(). Probe removal is preempt-safe because
+preemption is disabled around the probe call. See the "Probe example" section
+below for a sample probe module.
+
+The marker mechanism supports inserting multiple instances of the same marker.
+Markers can be put in inline functions, inlined static functions, and
+unrolled loops.
+
+Note: It is safe to put markers within preempt-safe code : preempt_enable()
+will not call the scheduler due to the tests in preempt_schedule().
+
+
+* Optimization for a given architecture
+
+One can implement optimized markers for a given architecture by replacing
+asm-$ARCH/marker.h.
+
+The IF_* flags can be used to control the type of marker. See the
+include/linux/immediate.h header for the list of flags. They can be specified as
+the first parameter of the _trace_mark() macro, as in the following example,
+which is safe with respect to lockdep.c (useful for marking lockdep.c and printk
+functions).
+
+_trace_mark(IF_DEFAULT | ~IF_LOCKDEP, subsystem_eventb, MARK_NOARGS);
+
+Flag compatibility is checked before connecting the probe to the marker: the
+right flags must be given to _marker_arm_probe().
+
+
+* Probe example
+
+You can build the kernel modules, probe-example.ko and marker-example.ko,
+using the following Makefile:
+------------------------------ CUT -------------------------------------
+obj-m := probe-example.o marker-example.o
+KDIR := /lib/modules/$(shell uname -r)/build
+PWD := $(shell pwd)
+default:
+	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules
+clean:
+	rm -f *.mod.c *.ko *.o
+------------------------------ CUT -------------------------------------
+/* probe-example.c
+ *
+ * Connects two functions to marker call sites.
+ *
+ * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/marker.h>
+#include <asm/atomic.h>
+
+struct probe_data {
+	const char *name;
+	const char *format;
+	marker_probe_func *probe_func;
+};
+
+void probe_subsystem_event(const struct __mark_marker_c *mdata,
+		const char *format, ...)
+{
+	va_list ap;
+	/* Declare args */
+	unsigned int value;
+	const char *mystr;
+
+	/* Assign args */
+	va_start(ap, format);
+	value = va_arg(ap, typeof(value));
+	mystr = va_arg(ap, typeof(mystr));
+
+	/* Call printk */
+	printk("Value %u, string %s\n", value, mystr);
+
+	/* or count, check rights, serialize data in a buffer */
+
+	va_end(ap);
+}
+
+atomic_t eventb_count = ATOMIC_INIT(0);
+
+void probe_subsystem_eventb(const struct __mark_marker_c *mdata,
+	const char *format, ...)
+{
+	/* Increment counter */
+	atomic_inc(&eventb_count);
+}
+
+static struct probe_data probe_array[] =
+{
+	{	.name = "subsystem_event",
+		.format = "%d %s",
+		.probe_func = probe_subsystem_event },
+	{	.name = "subsystem_eventb",
+		.format = MARK_NOARGS,
+		.probe_func = probe_subsystem_eventb },
+};
+
+static int __init probe_init(void)
+{
+	int result;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(probe_array); i++) {
+		result = marker_arm_probe(probe_array[i].name,
+				probe_array[i].format,
+				probe_array[i].probe_func, &probe_array[i]);
+		if (result)
+			printk(KERN_INFO "Unable to register probe %s\n",
+				probe_array[i].name);
+	}
+	return 0;
+}
+
+static void __exit probe_fini(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(probe_array); i++) {
+		marker_disarm_probe(probe_array[i].name);
+	}
+	printk("Number of event b : %u\n", atomic_read(&eventb_count));
+}
+
+module_init(probe_init);
+module_exit(probe_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("SUBSYSTEM Probe");
+------------------------------ CUT -------------------------------------
+/* marker-example.c
+ *
+ * Executes a marker when /proc/marker-example is opened.
+ *
+ * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/marker.h>
+#include <linux/sched.h>
+#include <linux/proc_fs.h>
+
+struct proc_dir_entry *pentry_example = NULL;
+
+static int my_open(struct inode *inode, struct file *file)
+{
+	int i;
+
+	trace_mark(subsystem_event, "%d %s", 123, "example string");
+	for (i=0; i<10; i++) {
+		trace_mark(subsystem_eventb, MARK_NOARGS);
+	}
+	return -EPERM;
+}
+
+static struct file_operations mark_ops = {
+	.open = my_open,
+};
+
+static int example_init(void)
+{
+	printk(KERN_ALERT "example init\n");
+	pentry_example = create_proc_entry("marker-example", 0444, NULL);
+	if (pentry_example)
+		pentry_example->proc_fops = &mark_ops;
+	else
+		return -EPERM;
+	return 0;
+}
+
+static void example_exit(void)
+{
+	printk(KERN_ALERT "example exit\n");
+	remove_proc_entry("marker-example", NULL);
+}
+
+module_init(example_init)
+module_exit(example_exit)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("Linux Trace Toolkit example");
+------------------------------ CUT -------------------------------------
+Sequence of operations : (as root)
+make
+insmod marker-example.ko
+insmod probe-example.ko
+  (it is important to load the probe after the marked code)
+cat /proc/marker-example (returns an expected error)
+rmmod marker-example probe-example
+dmesg
+------------------------------ CUT -------------------------------------
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
use-data_data-in-cris.patch
add-missing-data_data-in-powerpc.patch
use-data_data-in-xtensa.patch
linux-kernel-markers-architecture-independent-code.patch
linux-kernel-markers-add-kconfig-menus-for-the-marker-code.patch
linux-kernel-markers-documentation.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
