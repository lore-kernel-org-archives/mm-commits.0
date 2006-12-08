From: akpm@osdl.org
Subject: - fault-injection-stacktrace-filtering-reject-failure-if-any-caller-lies-within-specified-range.patch removed from -mm tree
Date: Fri, 08 Dec 2006 01:00:05 -0800
Message-ID: <200612080900.kB8905SB014282@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38280 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425260AbWLHJAX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 04:00:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwm@meer.net, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fault-injection: reject failure if any caller lies within specified range
has been removed from the -mm tree.  Its filename was
     fault-injection-stacktrace-filtering-reject-failure-if-any-caller-lies-within-specified-range.patch

This patch was dropped because it was folded into fault-injection-stacktrace-filtering.patch

------------------------------------------------------
Subject: fault-injection: reject failure if any caller lies within specified range
From: Don Mullis <dwm@meer.net>

/debug/fail_make_request can force a failure like the following:

	FAULT_INJECTION: forcing a failure
	 [<c0103085>] dump_trace+0x63/0x1cd
	 [<c0103209>] show_trace_log_lvl+0x1a/0x2f
	 [<c0103770>] show_trace+0x12/0x14
	 [<c01037f4>] dump_stack+0x16/0x18
	 [<c01b82bb>] should_fail+0x118/0x15b
	 [<c01ab57a>] generic_make_request+0x1ca/0x373
	 [<c01ad414>] submit_bio+0xa6/0xae
	 [<c0169801>] submit_bh+0xc7/0xe3
	 [<c016ae7f>] sync_dirty_buffer+0x7f/0xde
	 [<c0193e75>] journal_commit_transaction+0xb44/0x1007
	 [<c0197633>] kjournald+0xb3/0x1e5
	 [<c01202d1>] kthread+0xa3/0xce
	 [<c0102d0b>] kernel_thread_helper+0x7/0x10
	DWARF2 unwinder stuck at kernel_thread_helper+0x7/0x10
	Leftover inexact backtrace:
	 [<c0103209>] show_trace_log_lvl+0x1a/0x2f
	 [<c0103770>] show_trace+0x12/0x14
	 [<c01037f4>] dump_stack+0x16/0x18
	 [<c01b82bb>] should_fail+0x118/0x15b
	 [<c01ab57a>] generic_make_request+0x1ca/0x373
	 [<c01ad414>] submit_bio+0xa6/0xae
	 [<c0169801>] submit_bh+0xc7/0xe3
	 [<c016ae7f>] sync_dirty_buffer+0x7f/0xde
	 [<c0193e75>] journal_commit_transaction+0xb44/0x1007
	 [<c0197633>] kjournald+0xb3/0x1e5
	 [<c01202d1>] kthread+0xa3/0xce
	 [<c0102d0b>] kernel_thread_helper+0x7/0x10
	 =======================
	Buffer I/O error on device hda2, logical block 5782
	lost page write due to I/O error on hda2
	Aborting journal on device hda2.
	journal commit I/O error
	ext3_abort called.
	EXT3-fs error (device hda2): ext3_journal_start_sb: Detected aborted journal
	Remounting filesystem read-only

The above read-only remount effectively ends the test run.

With the patch applied, any (single) case such as the above can be
excluded like so:

	cd /debug/fail_make_request/

	awk '/kjournald/{print "0x" $1}' /boot/System.map-2.6.19* >reject-start
	awk '/kjournald/{getline; print "0x" $1}' /boot/System.map-2.6.19* >reject-end

	echo -1 >times
	echo 9 >verbose
	echo 1 >probability
	echo 1 >/sys/block/hda/hda2/make-it-fail

Implementation approach is to extend the existing
address-start/address-end mechanism specifying a range _required_ to
be found on the stack, by the addition of an address range to be
_rejected_.

address-start/address-end have been renamed to place them in the new
context.

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Don Mullis <dwm@meer.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/fault-injection/fault-injection.txt |   12 +
 include/linux/fault-inject.h                      |   15 +-
 lib/fault-inject.c                                |   73 +++++++-----
 3 files changed, 64 insertions(+), 36 deletions(-)

diff -puN Documentation/fault-injection/fault-injection.txt~fault-injection-stacktrace-filtering-reject-failure-if-any-caller-lies-within-specified-range Documentation/fault-injection/fault-injection.txt
--- a/Documentation/fault-injection/fault-injection.txt~fault-injection-stacktrace-filtering-reject-failure-if-any-caller-lies-within-specified-range
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
 
diff -puN include/linux/fault-inject.h~fault-injection-stacktrace-filtering-reject-failure-if-any-caller-lies-within-specified-range include/linux/fault-inject.h
--- a/include/linux/fault-inject.h~fault-injection-stacktrace-filtering-reject-failure-if-any-caller-lies-within-specified-range
+++ a/include/linux/fault-inject.h
@@ -19,8 +19,10 @@ struct fault_attr {
 	unsigned long verbose;
 	u32 task_filter;
 	unsigned long stacktrace_depth;
-	unsigned long address_start;
-	unsigned long address_end;
+	unsigned long require_start;
+	unsigned long require_end;
+	unsigned long reject_start;
+	unsigned long reject_end;
 
 	unsigned long count;
 
@@ -36,8 +38,10 @@ struct fault_attr {
 		struct dentry *verbose_file;
 		struct dentry *task_filter_file;
 		struct dentry *stacktrace_depth_file;
-		struct dentry *address_start_file;
-		struct dentry *address_end_file;
+		struct dentry *require_start_file;
+		struct dentry *require_end_file;
+		struct dentry *reject_start_file;
+		struct dentry *reject_end_file;
 	} dentries;
 
 #endif
@@ -46,7 +50,8 @@ struct fault_attr {
 #define FAULT_ATTR_INITIALIZER {				\
 		.interval = 1,					\
 		.times = ATOMIC_INIT(1),			\
-		.address_end = ULONG_MAX,			\
+		.require_end = ULONG_MAX,			\
+		.stacktrace_depth = 32,				\
 	}
 
 #define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
diff -puN lib/fault-inject.c~fault-injection-stacktrace-filtering-reject-failure-if-any-caller-lies-within-specified-range lib/fault-inject.c
--- a/lib/fault-inject.c~fault-injection-stacktrace-filtering-reject-failure-if-any-caller-lies-within-specified-range
+++ a/lib/fault-inject.c
@@ -53,11 +53,6 @@ static int fail_task(struct fault_attr *
 	return !in_interrupt() && task->make_it_fail;
 }
 
-static int fail_any_address(struct fault_attr *attr)
-{
-	return (attr->address_start == 0 && attr->address_end == ULONG_MAX);
-}
-
 #ifdef CONFIG_STACK_UNWIND
 
 static asmlinkage int fail_stacktrace_callback(struct unwind_frame_info *info,
@@ -65,16 +60,20 @@ static asmlinkage int fail_stacktrace_ca
 {
 	int depth;
 	struct fault_attr *attr = arg;
+	bool found = (attr->require_start == 0 && attr->require_end == ULONG_MAX);
 
 	for (depth = 0; depth < attr->stacktrace_depth
 			&& unwind(info) == 0 && UNW_PC(info); depth++) {
 		if (arch_unw_user_mode(info))
 			break;
-		if (attr->address_start <= UNW_PC(info) &&
-			       UNW_PC(info) < attr->address_end)
-			return 1;
+		if (attr->reject_start <= UNW_PC(info) &&
+			       UNW_PC(info) < attr->reject_end)
+			return 0;
+		if (attr->require_start <= UNW_PC(info) &&
+			       UNW_PC(info) < attr->require_end)
+			found = 1;
 	}
-	return 0;
+	return found;
 }
 
 static int fail_stacktrace(struct fault_attr *attr)
@@ -86,7 +85,7 @@ static int fail_stacktrace(struct fault_
 
 #elif defined(CONFIG_STACKTRACE)
 
-#define MAX_STACK_TRACE_DEPTH 10
+#define MAX_STACK_TRACE_DEPTH 32
 
 static int fail_stacktrace(struct fault_attr *attr)
 {
@@ -94,9 +93,10 @@ static int fail_stacktrace(struct fault_
 	int depth = attr->stacktrace_depth;
 	unsigned long entries[MAX_STACK_TRACE_DEPTH];
 	int n;
+	bool found = (attr->require_start == 0 && attr->require_end == ULONG_MAX);
 
 	if (depth == 0)
-		return 0;
+		return found;
 
 	trace.nr_entries = 0;
 	trace.entries = entries;
@@ -106,11 +106,15 @@ static int fail_stacktrace(struct fault_
 	trace.all_contexts = 0;
 
 	save_stack_trace(&trace, NULL);
-	for (n = 0; n < trace.nr_entries; n++)
-		if (attr->address_start <= entries[n] &&
-			       entries[n] < attr->address_end)
-			return 1;
-	return 0;
+	for (n = 0; n < trace.nr_entries; n++) {
+		if (attr->reject_start <= entries[n] &&
+			       entries[n] < attr->reject_end)
+			return 0;
+		if (attr->require_start <= entries[n] &&
+			       entries[n] < attr->require_end)
+			found = 1;
+	}
+	return found;
 }
 
 #else
@@ -139,7 +143,7 @@ int should_fail(struct fault_attr *attr,
 	if (attr->task_filter && !fail_task(attr, current))
 		return 0;
 
-	if (!fail_any_address(attr) && !fail_stacktrace(attr))
+	if (!fail_stacktrace(attr))
 		return 0;
 
 	if (atomic_read(&attr->times) == 0)
@@ -232,11 +236,17 @@ void cleanup_fault_attr_dentries(struct 
 	debugfs_remove(attr->dentries.stacktrace_depth_file);
 	attr->dentries.stacktrace_depth_file = NULL;
 
-	debugfs_remove(attr->dentries.address_start_file);
-	attr->dentries.address_start_file = NULL;
+	debugfs_remove(attr->dentries.require_start_file);
+	attr->dentries.require_start_file = NULL;
+
+	debugfs_remove(attr->dentries.require_end_file);
+	attr->dentries.require_end_file = NULL;
 
-	debugfs_remove(attr->dentries.address_end_file);
-	attr->dentries.address_end_file = NULL;
+	debugfs_remove(attr->dentries.reject_start_file);
+	attr->dentries.reject_start_file = NULL;
+
+	debugfs_remove(attr->dentries.reject_end_file);
+	attr->dentries.reject_end_file = NULL;
 
 	if (attr->dentries.dir)
 		WARN_ON(!simple_empty(attr->dentries.dir));
@@ -279,19 +289,28 @@ int init_fault_attr_dentries(struct faul
 		debugfs_create_ul("stacktrace-depth", mode, dir,
 				  &attr->stacktrace_depth);
 
-	attr->dentries.address_start_file = debugfs_create_ul("address-start",
-					mode, dir, &attr->address_start);
+	attr->dentries.require_start_file =
+		debugfs_create_ul("require-start", mode, dir, &attr->require_start);
+
+	attr->dentries.require_end_file =
+		debugfs_create_ul("require-end", mode, dir, &attr->require_end);
+
+	attr->dentries.reject_start_file =
+		debugfs_create_ul("reject-start", mode, dir, &attr->reject_start);
 
-	attr->dentries.address_end_file =
-		debugfs_create_ul("address-end", mode, dir, &attr->address_end);
+	attr->dentries.reject_end_file =
+		debugfs_create_ul("reject-end", mode, dir, &attr->reject_end);
 
 
 	if (!attr->dentries.probability_file || !attr->dentries.interval_file
 	    || !attr->dentries.times_file || !attr->dentries.space_file
 	    || !attr->dentries.verbose_file || !attr->dentries.task_filter_file
 	    || !attr->dentries.stacktrace_depth_file
-	    || !attr->dentries.address_start_file
-	    || !attr->dentries.address_end_file)
+	    || !attr->dentries.require_start_file
+	    || !attr->dentries.require_end_file
+	    || !attr->dentries.reject_start_file
+	    || !attr->dentries.reject_end_file
+	    )
 		goto fail;
 
 	return 0;
_

Patches currently in -mm which might be from dwm@meer.net are

fault-injection-documentation-and-scripts.patch
fault-injection-capabilities-infrastructure.patch
fault-injection-stacktrace-filtering.patch
fault-injection-stacktrace-filtering-reject-failure-if-any-caller-lies-within-specified-range.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
fault-injection-correct-disambiguate-and.patch
fault-injection-use-bool-true-false-throughout.patch
fault-injection-clamp-debugfs-stacktrace-depth-to.patch
fault-injection-optimize-and-simplify.patch
fault-injection-defaults-likely-to-please-a-new.patch

