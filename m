From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-samples.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:54:28 -0700
Message-ID: <200710192254.l9JMsSgw024536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33754 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966889AbXJSXF2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     Linux Kernel Markers - Samples
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-samples.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Linux Kernel Markers - Samples
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Module example showing how to use the Linux Kernel Markers.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/marker.h           |    1 
 samples/Kconfig                  |    5 +
 samples/Makefile                 |    3 
 samples/markers/Makefile         |    4 +
 samples/markers/marker-example.c |   54 +++++++++++++++
 samples/markers/probe-example.c  |   98 +++++++++++++++++++++++++++++
 6 files changed, 164 insertions(+), 1 deletion(-)

diff -puN include/linux/marker.h~linux-kernel-markers-samples include/linux/marker.h
--- a/include/linux/marker.h~linux-kernel-markers-samples
+++ a/include/linux/marker.h
@@ -61,7 +61,6 @@ struct marker {
 		__attribute__((section("__markers"), aligned(8))) =	\
 		{ __mstrtab_name_##name, __mstrtab_format_##name,	\
 		0, __mark_empty_function, NULL };			\
-		asm volatile("" : : "i" (&__mark_##name));		\
 		__mark_check_format(format, ## args);			\
 		if (unlikely(__mark_##name.state)) {			\
 			preempt_disable();				\
diff -puN samples/Kconfig~linux-kernel-markers-samples samples/Kconfig
--- a/samples/Kconfig~linux-kernel-markers-samples
+++ a/samples/Kconfig
@@ -7,5 +7,10 @@ menuconfig SAMPLES
 
 if SAMPLES
 
+config SAMPLE_MARKERS
+	tristate "Build markers examples -- loadable modules only"
+	depends on MARKERS && m
+	help
+	  This build markers example modules.
 
 endif # SAMPLES
diff -puN /dev/null samples/Makefile
--- /dev/null
+++ a/samples/Makefile
@@ -0,0 +1,3 @@
+# Makefile for Linux samples code
+
+obj-$(CONFIG_SAMPLES)	+= markers/
diff -puN /dev/null samples/markers/Makefile
--- /dev/null
+++ a/samples/markers/Makefile
@@ -0,0 +1,4 @@
+# builds the kprobes example kernel modules;
+# then to use one (as root):  insmod <module_name.ko>
+
+obj-$(CONFIG_SAMPLE_MARKERS) += probe-example.o marker-example.o
diff -puN /dev/null samples/markers/marker-example.c
--- /dev/null
+++ a/samples/markers/marker-example.c
@@ -0,0 +1,54 @@
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
+struct proc_dir_entry *pentry_example;
+
+static int my_open(struct inode *inode, struct file *file)
+{
+	int i;
+
+	trace_mark(subsystem_event, "%d %s", 123, "example string");
+	for (i = 0; i < 10; i++)
+		trace_mark(subsystem_eventb, MARK_NOARGS);
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
+MODULE_DESCRIPTION("Marker example");
diff -puN /dev/null samples/markers/probe-example.c
--- /dev/null
+++ a/samples/markers/probe-example.c
@@ -0,0 +1,98 @@
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
+void probe_subsystem_event(const struct marker *mdata, void *private,
+	const char *format, ...)
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
+	printk(KERN_DEBUG "Value %u, string %s\n", value, mystr);
+
+	/* or count, check rights, serialize data in a buffer */
+
+	va_end(ap);
+}
+
+atomic_t eventb_count = ATOMIC_INIT(0);
+
+void probe_subsystem_eventb(const struct marker *mdata, void *private,
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
+		result = marker_probe_register(probe_array[i].name,
+				probe_array[i].format,
+				probe_array[i].probe_func, &probe_array[i]);
+		if (result)
+			printk(KERN_INFO "Unable to register probe %s\n",
+				probe_array[i].name);
+		result = marker_arm(probe_array[i].name);
+		if (result)
+			printk(KERN_INFO "Unable to arm probe %s\n",
+				probe_array[i].name);
+	}
+	return 0;
+}
+
+static void __exit probe_fini(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(probe_array); i++)
+		marker_probe_unregister(probe_array[i].name);
+	printk(KERN_INFO "Number of event b : %u\n",
+			atomic_read(&eventb_count));
+}
+
+module_init(probe_init);
+module_exit(probe_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("SUBSYSTEM Probe");
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
