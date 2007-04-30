From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-documentation-markers-update-documentation.patch removed from -mm tree
Date: Mon, 30 Apr 2007 13:28:09 -0700
Message-ID: <200704302028.l3UKS9ie014201@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946784AbXD3U2T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 16:28:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     markers: update documentation
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-documentation-markers-update-documentation.patch

This patch was dropped because it was folded into linux-kernel-markers-documentation.patch

------------------------------------------------------
Subject: markers: update documentation
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Update marker Documentation to be in sync with the flag bitmask change.  Give
more complete probe example.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/marker.txt |  188 ++++++++++++++++++++++++++-----------
 1 file changed, 136 insertions(+), 52 deletions(-)

diff -puN Documentation/marker.txt~linux-kernel-markers-documentation-markers-update-documentation Documentation/marker.txt
--- a/Documentation/marker.txt~linux-kernel-markers-documentation-markers-update-documentation
+++ a/Documentation/marker.txt
@@ -12,11 +12,11 @@ probe module examples. This is what conn
 * Purpose of markers
 
 A marker placed in your code provides a hook to a function (probe) that
-you can provide at runtime. A marker can be on (a probe is connected to it)
-or off (no probe is attached). An "off" marker has no effect. When turned on,
+you can provide at runtime. A marker can be "on" (a probe is connected to it)
+or "off" (no probe is attached). An "off" marker has no effect. When turned on,
 the function you provide is called each time the marker is executed in the
 execution context of the caller. When the function provided ends its execution,
-it returns to the caller (probe site).
+it returns to the caller (marker site).
 
 You can put markers at important locations in the code. They act as
 lightweight hooks that can pass an arbitrary number of parameters,
@@ -40,20 +40,14 @@ In order to use the macro MARK, you shou
 
 Add, in your code :
 
-MARK(subsystem_event, "%d %s %p[struct task_struct]",
-  someint, somestring, current);
+MARK(subsystem_event, "%d %s", someint, somestring);
 Where :
 - subsystem_event is an identifier unique to your event
     - subsystem is the name of your subsystem.
     - event is the name of the event to mark.
-- "%d %s %p[struct task_struct]" is the formatted string for (printk-style).
+- "%d %s" is the formatted string for the serializer.
 - someint is an integer.
 - somestring is a char pointer.
-- current is a pointer to a struct task_struct.
-
-The expression %p[struct task_struct] is a suggested marker definition
-standard that could eventually be used for pointer type checking in
-sparse. The brackets contain the type to which the pointer refers.
 
 Connecting a function (probe) to a marker is done by providing a probe
 (function to call) for the specific marker through marker_set_probe(). It will
@@ -73,7 +67,7 @@ will not call the scheduler due to the t
 * Optimization for a given architecture
 
 You will find, in asm-*/marker.h, optimisations for given architectures
-(currently i386 and powerpc). They use a load immediate instead of a data read,
+(currently i386 and powerpc). They use a load immediate instead of a data load,
 which saves a data cache hit, but also requires cross CPU code modification. In
 order to support embedded systems which use read-only memory for their code, the
 optimization can be disabled through menu options.
@@ -81,25 +75,35 @@ optimization can be disabled through men
 The MF_* flags can be used to control the type of marker. See the
 include/marker.h header for the list of flags. They can be specified as the
 first parameter of the _MARK() macro, such as the following example which is
-safe wrt lockdep.c (useful for marking lockdep.c functions).
+safe with respect to lockdep.c (useful for marking lockdep.c and printk
+functions).
 
-_MARK(_MF_DEFAULT | ~_MF_LOCKDEP, subsystem_eventb,
-  MARK_NOARGS);
+_MARK(MF_DEFAULT | ~MF_LOCKDEP, subsystem_eventb, MARK_NOARGS);
 
 Another example is to specify that a specific marker must never call printk :
-_MARK(_MF_DEFAULT | ~_MF_PRINTK, subsystem_eventc,
-  "%d %s %p[struct task_struct]",
-  someint, somestring, current);
+_MARK(MF_DEFAULT | ~MF_PRINTK, subsystem_eventc,
+  "%d %s", someint, somestring,);
 
-Flag compatibility is checked before connecting the probe to the marker.
+Flag compatibility is checked before connecting the probe to the marker : the
+right flags must be given to _marker_set_enable().
 
 
 * Probe example
 
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
 ------------------------------ CUT -------------------------------------
 /* probe-example.c
  *
- * Loads a function at a marker call site.
+ * Connects a two functions to marker call sites.
  *
  * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
  *
@@ -109,67 +113,83 @@ Flag compatibility is checked before con
 
 #include <linux/sched.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/marker.h>
+#include <asm/atomic.h>
+
+#define NUM_PROBES (sizeof(probe_array) / sizeof(struct probe_data))
 
-#define SUBSYSTEM_EVENT_FORMAT "%d %s %p[struct task_struct]"
-void probe_subsystem_event(const char *format, ...)
+struct probe_data {
+	const char *name;
+	const char *format;
+	marker_probe_func *probe_func;
+};
+
+void probe_subsystem_event(const struct __mark_marker_c *mdata,
+		const char *format, ...)
 {
 	va_list ap;
 	/* Declare args */
 	unsigned int value;
 	const char *mystr;
-	struct task_struct *task;
 
 	/* Assign args */
 	va_start(ap, format);
 	value = va_arg(ap, typeof(value));
 	mystr = va_arg(ap, typeof(mystr));
-	task = va_arg(ap, typeof(task));
-
-	/* Call tracer */
-	trace_subsystem_event(value, mystr, task);
 
-	/* Or call printk */
-	vprintk(format, ap);
+	/* Call printk */
+	printk("Value %u, string %s\n", value, mystr);
 
-	/* or count, check rights... */
+	/* or count, check rights, serialize data in a buffer */
 
 	va_end(ap);
 }
 
-#define SUBSYSTEM_EVENTB_FORMAT MARK_NOARGS
-void probe_subsystem_eventb(const char *format, ...)
+atomic_t eventb_count = ATOMIC_INIT(0);
+
+void probe_subsystem_eventb(const struct __mark_marker_c *mdata,
+	const char *format, ...)
 {
-	/* Increment counters, trace, ... but _never_ generate a call to
-	 * lockdep.c ! */
+	/* Increment counter */
+	atomic_inc(&eventb_count);
 }
 
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
 static int __init probe_init(void)
 {
 	int result;
-	result = marker_set_probe("subsystem_event",
-			SUBSYSTEM_EVENT_FORMAT,
-			probe_subsystem_event);
-	if (!result)
-		goto cleanup;
-	result = _marker_set_probe(_MF_DEFAULT & ~_MF_LOCKDEP,
-			"subsystem_eventb",
-			SUBSYSTEM_EVENTB_FORMAT,
-			probe_subsystem_eventb);
-	if (!result)
-		goto cleanup;
-	return 0;
+	uint8_t eID;
 
-cleanup:
-	marker_remove_probe(probe_subsystem_event);
-	marker_remove_probe(probe_subsystem_eventb);
-	return -EPERM;
+	for (eID = 0; eID < NUM_PROBES; eID++) {
+		result = marker_set_probe(probe_array[eID].name,
+				probe_array[eID].format,
+				probe_array[eID].probe_func, &probe_array[eID]);
+		if (!result)
+			printk(KERN_INFO "Unable to register probe %s\n",
+				probe_array[eID].name);
+	}
+	return 0;
 }
 
 static void __exit probe_fini(void)
 {
-	marker_remove_probe(probe_subsystem_event);
-	marker_remove_probe(probe_subsystem_eventb);
+	uint8_t eID;
+
+	for (eID = 0; eID < NUM_PROBES; eID++) {
+		marker_remove_probe(probe_array[eID].name);
+	}
+	synchronize_sched();	/* Wait for probes to finish */
+	printk("Number of event b : %u\n", atomic_read(&eventb_count));
 }
 
 module_init(probe_init);
@@ -179,4 +199,68 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mathieu Desnoyers");
 MODULE_DESCRIPTION("SUBSYSTEM Probe");
 ------------------------------ CUT -------------------------------------
+/* marker-example.c
+ *
+ * Executes a marker when /proc/marker-example is opened.
+ *
+ * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
 
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
+	MARK(subsystem_event, "%d %s", 123, "example string");
+	for (i=0; i<10; i++) {
+		MARK(subsystem_eventb, MARK_NOARGS);
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

origin.patch
git-powerpc.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
local_t-architecture-independant-extension.patch
local_t-alpha-extension.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
markers-add-instrumentation-markers-menus-to-avr32.patch
linux-kernel-markers-non-optimized-architectures.patch
markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-markers-update-documentation.patch
linux-kernel-markers-documentation-fix-typo-and-use-array_size.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
