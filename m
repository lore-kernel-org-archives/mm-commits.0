From: akpm@osdl.org
Subject: - fault-injection-stacktrace-filtering.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:11:24 -0800
Message-ID: <200612082011.kB8KBOAN002914@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59140 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946642AbWLHULv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:11:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, dwm@meer.net, mm-commits@vger.kernel.org


The patch titled
     fault injection: stacktrace filtering
has been removed from the -mm tree.  Its filename was
     fault-injection-stacktrace-filtering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fault injection: stacktrace filtering
From: Akinobu Mita <akinobu.mita@gmail.com>

This patch provides stacktrace filtering feature.

The stacktrace filter allows failing only for the caller you are
interested in.

For example someone may want to inject kmalloc() failures into
only e100 module. they want to inject not only direct kmalloc() call,
but also indirect allocation, too.

- e100_poll --> netif_receive_skb --> packet_rcv_spkt --> skb_clone
  --> kmem_cache_alloc

This patch enables to detect function calls like this by stacktrace
and inject failures. The script Documentaion/fault-injection/failmodule.sh
helps it.

The range of text section of loaded e100 is expected to be
[/sys/module/e100/sections/.text, /sys/module/e100/sections/.exit.text)

So failmodule.sh stores these values into /debug/failslab/address-start
and /debug/failslab/address-end. The maximum stacktrace depth is specified
by /debug/failslab/stacktrace-depth.

Please see the example that demonstrates how to inject slab allocation
failures only for a specific module
in Documentation/fault-injection/fault-injection.txt

[dwm@meer.net: reject failure if any caller lies within specified range]
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Don Mullis <dwm@meer.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/fault-injection/fault-injection.txt |   12 -
 include/linux/fault-inject.h                      |   12 +
 lib/Kconfig.debug                                 |    5 
 lib/fault-inject.c                                |  126 +++++++++++-
 4 files changed, 150 insertions(+), 5 deletions(-)

diff -puN Documentation/fault-injection/fault-injection.txt~fault-injection-stacktrace-filtering Documentation/fault-injection/fault-injection.txt
--- a/Documentation/fault-injection/fault-injection.txt~fault-injection-stacktrace-filtering
+++ a/Documentation/fault-injection/fault-injection.txt
@@ -73,13 +73,17 @@ configuration of fault-injection capabil
 	Any positive value limits failures to only processes indicated by
 	/proc/<pid>/make-it-fail==1.
 
-- /debug/*/address-start:
-- /debug/*/address-end:
+- /debug/*/require-start:
+- /debug/*/require-end:
+- /debug/*/reject-start:
+- /debug/*/reject-end:
 
 	specifies the range of virtual addresses tested during
 	stacktrace walking.  Failure is injected only if some caller
-	in the walked stacktrace lies within this range.
-	Default is [0,ULONG_MAX) (whole of virtual address space).
+	in the walked stacktrace lies within the required range, and
+	none lies within the rejected range.
+	Default required range is [0,ULONG_MAX) (whole of virtual address space).
+	Default rejected range is [0,0).
 
 - /debug/*/stacktrace-depth:
 
diff -puN include/linux/fault-inject.h~fault-injection-stacktrace-filtering include/linux/fault-inject.h
--- a/include/linux/fault-inject.h~fault-injection-stacktrace-filtering
+++ a/include/linux/fault-inject.h
@@ -18,6 +18,11 @@ struct fault_attr {
 	atomic_t space;
 	unsigned long verbose;
 	u32 task_filter;
+	unsigned long stacktrace_depth;
+	unsigned long require_start;
+	unsigned long require_end;
+	unsigned long reject_start;
+	unsigned long reject_end;
 
 	unsigned long count;
 
@@ -32,6 +37,11 @@ struct fault_attr {
 		struct dentry *space_file;
 		struct dentry *verbose_file;
 		struct dentry *task_filter_file;
+		struct dentry *stacktrace_depth_file;
+		struct dentry *require_start_file;
+		struct dentry *require_end_file;
+		struct dentry *reject_start_file;
+		struct dentry *reject_end_file;
 	} dentries;
 
 #endif
@@ -40,6 +50,8 @@ struct fault_attr {
 #define FAULT_ATTR_INITIALIZER {				\
 		.interval = 1,					\
 		.times = ATOMIC_INIT(1),			\
+		.require_end = ULONG_MAX,			\
+		.stacktrace_depth = 32,				\
 	}
 
 #define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
diff -puN lib/Kconfig.debug~fault-injection-stacktrace-filtering lib/Kconfig.debug
--- a/lib/Kconfig.debug~fault-injection-stacktrace-filtering
+++ a/lib/Kconfig.debug
@@ -416,6 +416,11 @@ config LKDTM
 
 config FAULT_INJECTION
 	bool
+	select STACKTRACE
+	select FRAME_POINTER
+	help
+	  Provide fault-injection framework.
+	  For more details, see Documentation/fault-injection/.
 
 config FAILSLAB
 	bool "Fault-injection capabilitiy for kmalloc"
diff -puN lib/fault-inject.c~fault-injection-stacktrace-filtering lib/fault-inject.c
--- a/lib/fault-inject.c~fault-injection-stacktrace-filtering
+++ a/lib/fault-inject.c
@@ -6,6 +6,9 @@
 #include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/unwind.h>
+#include <linux/stacktrace.h>
+#include <linux/kallsyms.h>
 #include <linux/fault-inject.h>
 
 /*
@@ -50,6 +53,86 @@ static int fail_task(struct fault_attr *
 	return !in_interrupt() && task->make_it_fail;
 }
 
+#ifdef CONFIG_STACK_UNWIND
+
+static asmlinkage int fail_stacktrace_callback(struct unwind_frame_info *info,
+						void *arg)
+{
+	int depth;
+	struct fault_attr *attr = arg;
+	bool found = (attr->require_start == 0 && attr->require_end == ULONG_MAX);
+
+	for (depth = 0; depth < attr->stacktrace_depth
+			&& unwind(info) == 0 && UNW_PC(info); depth++) {
+		if (arch_unw_user_mode(info))
+			break;
+		if (attr->reject_start <= UNW_PC(info) &&
+			       UNW_PC(info) < attr->reject_end)
+			return 0;
+		if (attr->require_start <= UNW_PC(info) &&
+			       UNW_PC(info) < attr->require_end)
+			found = 1;
+	}
+	return found;
+}
+
+static int fail_stacktrace(struct fault_attr *attr)
+{
+	struct unwind_frame_info info;
+
+	return unwind_init_running(&info, fail_stacktrace_callback, attr);
+}
+
+#elif defined(CONFIG_STACKTRACE)
+
+#define MAX_STACK_TRACE_DEPTH 32
+
+static int fail_stacktrace(struct fault_attr *attr)
+{
+	struct stack_trace trace;
+	int depth = attr->stacktrace_depth;
+	unsigned long entries[MAX_STACK_TRACE_DEPTH];
+	int n;
+	bool found = (attr->require_start == 0 && attr->require_end == ULONG_MAX);
+
+	if (depth == 0)
+		return found;
+
+	trace.nr_entries = 0;
+	trace.entries = entries;
+	trace.max_entries = (depth < MAX_STACK_TRACE_DEPTH) ?
+				depth : MAX_STACK_TRACE_DEPTH;
+	trace.skip = 1;
+	trace.all_contexts = 0;
+
+	save_stack_trace(&trace, NULL);
+	for (n = 0; n < trace.nr_entries; n++) {
+		if (attr->reject_start <= entries[n] &&
+			       entries[n] < attr->reject_end)
+			return 0;
+		if (attr->require_start <= entries[n] &&
+			       entries[n] < attr->require_end)
+			found = 1;
+	}
+	return found;
+}
+
+#else
+
+static inline int fail_stacktrace(struct fault_attr *attr)
+{
+	static int firsttime = 1;
+
+	if (firsttime) {
+		printk(KERN_WARNING
+		"This architecture does not implement save_stack_trace()\n");
+		firsttime = 0;
+	}
+	return 0;
+}
+
+#endif
+
 /*
  * This code is stolen from failmalloc-1.0
  * http://www.nongnu.org/failmalloc/
@@ -60,6 +143,9 @@ int should_fail(struct fault_attr *attr,
 	if (attr->task_filter && !fail_task(attr, current))
 		return 0;
 
+	if (!fail_stacktrace(attr))
+		return 0;
+
 	if (atomic_read(&attr->times) == 0)
 		return 0;
 
@@ -147,6 +233,21 @@ void cleanup_fault_attr_dentries(struct 
 	debugfs_remove(attr->dentries.task_filter_file);
 	attr->dentries.task_filter_file = NULL;
 
+	debugfs_remove(attr->dentries.stacktrace_depth_file);
+	attr->dentries.stacktrace_depth_file = NULL;
+
+	debugfs_remove(attr->dentries.require_start_file);
+	attr->dentries.require_start_file = NULL;
+
+	debugfs_remove(attr->dentries.require_end_file);
+	attr->dentries.require_end_file = NULL;
+
+	debugfs_remove(attr->dentries.reject_start_file);
+	attr->dentries.reject_start_file = NULL;
+
+	debugfs_remove(attr->dentries.reject_end_file);
+	attr->dentries.reject_end_file = NULL;
+
 	if (attr->dentries.dir)
 		WARN_ON(!simple_empty(attr->dentries.dir));
 
@@ -184,9 +285,32 @@ int init_fault_attr_dentries(struct faul
 	attr->dentries.task_filter_file = debugfs_create_bool("task-filter",
 						mode, dir, &attr->task_filter);
 
+	attr->dentries.stacktrace_depth_file =
+		debugfs_create_ul("stacktrace-depth", mode, dir,
+				  &attr->stacktrace_depth);
+
+	attr->dentries.require_start_file =
+		debugfs_create_ul("require-start", mode, dir, &attr->require_start);
+
+	attr->dentries.require_end_file =
+		debugfs_create_ul("require-end", mode, dir, &attr->require_end);
+
+	attr->dentries.reject_start_file =
+		debugfs_create_ul("reject-start", mode, dir, &attr->reject_start);
+
+	attr->dentries.reject_end_file =
+		debugfs_create_ul("reject-end", mode, dir, &attr->reject_end);
+
+
 	if (!attr->dentries.probability_file || !attr->dentries.interval_file
 	    || !attr->dentries.times_file || !attr->dentries.space_file
-	    || !attr->dentries.verbose_file || !attr->dentries.task_filter_file)
+	    || !attr->dentries.verbose_file || !attr->dentries.task_filter_file
+	    || !attr->dentries.stacktrace_depth_file
+	    || !attr->dentries.require_start_file
+	    || !attr->dentries.require_end_file
+	    || !attr->dentries.reject_start_file
+	    || !attr->dentries.reject_end_file
+	    )
 		goto fail;
 
 	return 0;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
fault-injection-stacktrace-filtering.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
fault-injection-correct-disambiguate-and.patch
fault-injection-use-bool-true-false-throughout.patch
fault-injection-clamp-debugfs-stacktrace-depth-to.patch
fault-injection-optimize-and-simplify.patch
fault-injection-defaults-likely-to-please-a-new.patch
acpi-fix-single-linked-list-manipulation.patch
acpi-processor-prevent-loading-module-on-failures.patch
git-alsa.patch
audit-fix-kstrdup-error-check.patch
drm-fix-return-value-check.patch
ata-fix-platform_device_register_simple-error-check.patch
git-mtd.patch
net-use-bitrev8.patch
gss_spkm3-fix-error-handling-in-module-init.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
iscsi-fix-crypto_alloc_hash-error-check.patch

