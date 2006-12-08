From: akpm@osdl.org
Subject: - fault-injection-clamp-debugfs-stacktrace-depth-to.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:11:39 -0800
Message-ID: <200612082011.kB8KBdFe002940@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59241 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946686AbWLHUMW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:12:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwm@meer.net, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fault-injection: Clamp debugfs stacktrace-depth to MAX_STACK_TRACE_DEPTH
has been removed from the -mm tree.  Its filename was
     fault-injection-clamp-debugfs-stacktrace-depth-to.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fault-injection: Clamp debugfs stacktrace-depth to MAX_STACK_TRACE_DEPTH
From: Don Mullis <dwm@meer.net>

Clamp /debug/fail*/stacktrace-depth to MAX_STACK_TRACE_DEPTH.  Ensures that a
read of /debug/fail*/stacktrace-depth always returns a truthful answer.

Signed-off-by: Don Mullis <dwm@meer.net>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 lib/fault-inject.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff -puN lib/fault-inject.c~fault-injection-clamp-debugfs-stacktrace-depth-to lib/fault-inject.c
--- a/lib/fault-inject.c~fault-injection-clamp-debugfs-stacktrace-depth-to
+++ a/lib/fault-inject.c
@@ -53,6 +53,8 @@ static bool fail_task(struct fault_attr 
 	return !in_interrupt() && task->make_it_fail;
 }
 
+#define MAX_STACK_TRACE_DEPTH 32
+
 #ifdef CONFIG_STACK_UNWIND
 
 static asmlinkage int fail_stacktrace_callback(struct unwind_frame_info *info,
@@ -98,8 +100,7 @@ static bool fail_stacktrace(struct fault
 
 	trace.nr_entries = 0;
 	trace.entries = entries;
-	trace.max_entries = (depth < MAX_STACK_TRACE_DEPTH) ?
-				depth : MAX_STACK_TRACE_DEPTH;
+	trace.max_entries = depth;
 	trace.skip = 1;
 	trace.all_contexts = 0;
 
@@ -179,6 +180,13 @@ static void debugfs_ul_set(void *data, u
 	*(unsigned long *)data = val;
 }
 
+static void debugfs_ul_set_MAX_STACK_TRACE_DEPTH(void *data, u64 val)
+{
+	*(unsigned long *)data =
+		val < MAX_STACK_TRACE_DEPTH ?
+		val : MAX_STACK_TRACE_DEPTH;
+}
+
 static u64 debugfs_ul_get(void *data)
 {
 	return *(unsigned long *)data;
@@ -192,6 +200,17 @@ static struct dentry *debugfs_create_ul(
 	return debugfs_create_file(name, mode, parent, value, &fops_ul);
 }
 
+DEFINE_SIMPLE_ATTRIBUTE(fops_ul_MAX_STACK_TRACE_DEPTH, debugfs_ul_get,
+			debugfs_ul_set_MAX_STACK_TRACE_DEPTH, "%llu\n");
+
+static struct dentry *debugfs_create_ul_MAX_STACK_TRACE_DEPTH(
+	const char *name, mode_t mode,
+	struct dentry *parent, unsigned long *value)
+{
+	return debugfs_create_file(name, mode, parent, value,
+				   &fops_ul_MAX_STACK_TRACE_DEPTH);
+}
+
 static void debugfs_atomic_t_set(void *data, u64 val)
 {
 	atomic_set((atomic_t *)data, val);
@@ -284,8 +303,8 @@ int init_fault_attr_dentries(struct faul
 						mode, dir, &attr->task_filter);
 
 	attr->dentries.stacktrace_depth_file =
-		debugfs_create_ul("stacktrace-depth", mode, dir,
-				  &attr->stacktrace_depth);
+		debugfs_create_ul_MAX_STACK_TRACE_DEPTH(
+			"stacktrace-depth", mode, dir, &attr->stacktrace_depth);
 
 	attr->dentries.require_start_file =
 		debugfs_create_ul("require-start", mode, dir, &attr->require_start);
_

Patches currently in -mm which might be from dwm@meer.net are

fault-injection-clamp-debugfs-stacktrace-depth-to.patch
fault-injection-optimize-and-simplify.patch
fault-injection-defaults-likely-to-please-a-new.patch
kconfig-refactoring-for-better-menu-nesting.patch
sched-improve-migration-accuracy-fix.patch

