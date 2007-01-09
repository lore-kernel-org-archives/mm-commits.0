From: akpm@osdl.org
Subject: + local_t-documentation.patch added to -mm tree
Date: Tue, 09 Jan 2007 14:12:06 -0800
Message-ID: <200701092212.l09MC6mt016767@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47909 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932442AbXAIWMO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 17:12:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     local_t: Documentation
has been added to the -mm tree.  Its filename is
     local_t-documentation.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: local_t: Documentation
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>



Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/local_ops.txt |  148 ++++++++++++++++++++++++++++++++++
 1 files changed, 148 insertions(+)

diff -puN /dev/null Documentation/local_ops.txt
--- /dev/null
+++ a/Documentation/local_ops.txt
@@ -0,0 +1,148 @@
+	     Semantics and Behavior of Local Atomic Operations
+
+			    Mathieu Desnoyers
+
+
+	This document explains the purpose of the local atomic operations, how
+to implement them for any given architecture and shows how they can be used
+properly. It also stresses on the precautions that must be taken when reading
+those local variables across CPUs when the order of memory writes matters.
+
+
+
+* Purpose of local atomic operations
+
+Local atomic operations are meant to provide fast and highly reentrant per CPU
+counters. They minimize the performance cost of standard atomic operations by
+removing the LOCK prefix and memory barriers normally required to synchronize
+across CPUs.
+
+Having fast per CPU atomic counters is interesting in many cases : it does not
+require disabling interrupts to protect from interrupt handlers and it permits
+coherent counters in NMI handlers. It is especially useful for tracing purposes
+and for various performance monitoring counters.
+
+
+* Implementation for a given architecture
+
+It can be done by slightly modifying the standard atomic operations : only
+their UP variant must be kept. It typically means removing LOCK prefix (on
+i386 and x86_64) and any SMP sychronization barrier. If the architecture does
+not have a different behavior between SMP and UP, including asm-generic/local.h
+in your archtecture's local.h is sufficient.
+
+
+* How to use local atomic operations
+
+#include <linux/percpu.h>
+#include <asm/local.h>
+
+static DEFINE_PER_CPU(local_t, counters) = LOCAL_INIT(0);
+
+
+* Counting
+
+In preemptible context, use get_cpu_var() and put_cpu_var() around local atomic
+operations : it makes sure that preemption is disabled around write access to
+the per cpu variable. For instance :
+
+	local_inc(&get_cpu_var(counters));
+	put_cpu_var(counters);
+
+If you are already in a preemption-safe context, you can directly use
+__get_cpu_var() instead.
+
+	local_inc(&__get_cpu_var(counters));
+
+
+
+* Reading the counters
+
+Those local counters can be read from foreign CPUs to sum the count. Note that
+the data seen by local_read across CPUs must be considered to be out of order
+relatively to other memory writes happening on the CPU that owns the data.
+
+	long sum = 0;
+	for_each_online_cpu(cpu)
+		sum += local_read(&per_cpu(counters, cpu));
+
+If you want to use a remote local_read to synchronize access to a resource
+between CPUs, explicit smp_wmb() and smp_rmb() memory barriers must be used
+respectively on the writer and the reader CPUs. It would be the case if you use
+the local_t variable as a counter of bytes written in a buffer : there should
+be a smp_wmb() between the buffer write and the counter increment and also a
+smp_rmb() between the counter read and the buffer read.
+
+
+Here is a sample module which implements a basic per cpu counter using local.h.
+
+--- BEGIN ---
+/* test-local.c
+ *
+ * Sample module for local.h usage.
+ */
+
+
+#include <asm/local.h>
+#include <linux/module.h>
+#include <linux/timer.h>
+
+static DEFINE_PER_CPU(local_t, counters) = LOCAL_INIT(0);
+
+static struct timer_list test_timer;
+
+/* IPI called on each CPU. */
+static void test_each(void *info)
+{
+	/* Increment the counter from a non preemptible context */
+	printk("Increment on cpu %d\n", smp_processor_id());
+	local_inc(&__get_cpu_var(counters));
+
+	/* This is what incrementing the variable would look like within a
+	 * preemptible context (it disables preemption) :
+	 *
+	 * local_inc(&get_cpu_var(counters));
+	 * put_cpu_var(counters);
+	 */
+}
+
+static void do_test_timer(unsigned long data)
+{
+	int cpu;
+
+	/* Increment the counters */
+	on_each_cpu(test_each, NULL, 0, 1);
+	/* Read all the counters */
+	printk("Counters read from CPU %d\n", smp_processor_id());
+	for_each_online_cpu(cpu) {
+		printk("Read : CPU %d, count %ld\n", cpu,
+			local_read(&per_cpu(counters, cpu)));
+	}
+	del_timer(&test_timer);
+	test_timer.expires = jiffies + 1000;
+	add_timer(&test_timer);
+}
+
+static int __init test_init(void)
+{
+	/* initialize the timer that will increment the counter */
+	init_timer(&test_timer);
+	test_timer.function = do_test_timer;
+	test_timer.expires = jiffies + 1;
+	add_timer(&test_timer);
+
+	return 0;
+}
+
+static void __exit test_exit(void)
+{
+	del_timer_sync(&test_timer);
+}
+
+module_init(test_init);
+module_exit(test_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("Local Atomic Ops");
+--- END ---
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

relay-add-cpu-hotplug-support.patch
local_t-documentation.patch
