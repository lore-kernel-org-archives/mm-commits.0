From: akpm@linux-foundation.org
Subject: - trace-sample.patch removed from -mm tree
Date: Tue, 07 Apr 2009 16:52:42 -0700
Message-ID: <200904072352.n37Nqgtl004369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753369AbZDGXxw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 19:53:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwilder@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Trace sample
has been removed from the -mm tree.  Its filename was
     trace-sample.patch

This patch was dropped because I guess I won't be merging these in their present form

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Trace sample
From: "David J. Wilder" <dwilder@us.ibm.com>

Add the trace example to samples/.

Signed-off-by: David Wilder <dwilder@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/Kconfig            |    6 +
 samples/Makefile           |    2 
 samples/trace/Makefile     |    4 +
 samples/trace/fork_trace.c |  132 +++++++++++++++++++++++++++++++++++
 4 files changed, 143 insertions(+), 1 deletion(-)

diff -puN samples/Kconfig~trace-sample samples/Kconfig
--- a/samples/Kconfig~trace-sample
+++ a/samples/Kconfig
@@ -39,5 +39,11 @@ config SAMPLE_KRETPROBES
 	default m
 	depends on SAMPLE_KPROBES && KRETPROBES
 
+config SAMPLE_TRACE
+	tristate "Build trace example -- loadable modules only"
+	depends on TRACE && KPROBES && m
+	help
+	  This builds a trace example module.
+
 endif # SAMPLES
 
diff -puN samples/Makefile~trace-sample samples/Makefile
--- a/samples/Makefile~trace-sample
+++ a/samples/Makefile
@@ -1,3 +1,3 @@
 # Makefile for Linux samples code
 
-obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/ tracepoints/
+obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/ tracepoints/ trace/
diff -puN /dev/null samples/trace/Makefile
--- /dev/null
+++ a/samples/trace/Makefile
@@ -0,0 +1,4 @@
+# builds the trace example kernel modules;
+# then to use (as root):  insmod <fork_trace.ko>
+
+obj-$(CONFIG_SAMPLE_TRACE) := fork_trace.o
diff -puN /dev/null samples/trace/fork_trace.c
--- /dev/null
+++ a/samples/trace/fork_trace.c
@@ -0,0 +1,132 @@
+/*
+ * An example of using trace in a kprobes module
+ *
+ * Copyright (C) 2007 IBM Inc.
+ *
+ * David Wilder <dwilder@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * -------
+ * This module creates a trace channel and places a kprobe
+ * on the function do_fork(). The value of current->pid is written to
+ * the trace channel each time the kprobe is hit..
+ *
+ * How to run the example:
+ * $ mount -t debugfs /debug
+ * $ insmod fork_trace.ko
+ *
+ * To view the data produced by the module:
+ * $ cat /debug/trace_example/do_fork/trace0
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/kprobes.h>
+#include <linux/trace.h>
+
+#define USE_GLOBAL_BUFFERS 1
+#define USE_FLIGHT 1
+
+#define PROBE_POINT "do_fork"
+
+static struct kprobe kp;
+static struct trace_info *kprobes_trace;
+
+#ifdef USE_GLOBAL_BUFFERS
+static DEFINE_SPINLOCK(trace_lock);
+#endif
+
+/*
+ * Send formatted trace data to trace channel.
+ * @note Preemption must be disabled to use this.
+ */
+static void trace_printf(struct trace_info *trace, const char *format, ...)
+{
+	va_list ap, aq;
+	char *record;
+	unsigned long flags;
+	int len;
+
+	if (!trace)
+		return;
+
+#ifdef USE_GLOBAL_BUFFERS
+	spin_lock_irqsave(&trace_lock, flags);
+#endif
+	if (trace_running(trace)) {
+		va_start(ap, format);
+		va_copy(aq, ap);
+		len = vsnprintf(NULL, 0, format, aq);
+		va_end(aq);
+		record = relay_reserve(trace->rchan, ++len);
+		if (record)
+			vsnprintf(record, len, format, ap);
+		va_end(ap);
+	}
+#ifdef USE_GLOBAL_BUFFERS
+	spin_unlock_irqrestore(&trace_lock, flags);
+#endif
+}
+
+static int handler_pre(struct kprobe *p, struct pt_regs *regs)
+{
+	rcu_read_lock();
+	trace_printf(kprobes_trace, "%d\n", current->pid);
+	rcu_read_unlock();
+	return 0;
+}
+
+int init_module(void)
+{
+	int ret;
+	u32 flags = 0;
+
+#ifdef USE_GLOBAL_BUFFERS
+	flags |= TRACE_GLOBAL_CHANNEL;
+#endif
+
+#ifdef USE_FLIGHT
+	flags |= TRACE_FLIGHT_CHANNEL;
+#endif
+
+	/* setup the trace */
+	kprobes_trace = trace_setup("trace_example", PROBE_POINT,
+				     1024, 8, flags);
+	if (IS_ERR(kprobes_trace))
+		return PTR_ERR(kprobes_trace);
+
+	trace_start(kprobes_trace);
+
+	/* setup the kprobe */
+	kp.pre_handler = handler_pre;
+	kp.post_handler = NULL;
+	kp.fault_handler = NULL;
+	kp.symbol_name = PROBE_POINT;
+	ret = register_kprobe(&kp);
+	if (ret) {
+		printk(KERN_ERR "fork_trace: register_kprobe failed\n");
+		return ret;
+	}
+	return 0;
+}
+
+void cleanup_module(void)
+{
+	unregister_kprobe(&kp);
+	trace_stop(kprobes_trace);
+	trace_cleanup(kprobes_trace);
+}
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from dwilder@us.ibm.com are

trace-sample.patch

