From: akpm@osdl.org
Subject: - fault-injection-use-bool-true-false-throughout.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:11:36 -0800
Message-ID: <200612082011.kB8KBamT002933@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59181 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946647AbWLHUMB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:12:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwm@meer.net, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fault-injection: Use bool-true-false throughout
has been removed from the -mm tree.  Its filename was
     fault-injection-use-bool-true-false-throughout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fault-injection: Use bool-true-false throughout
From: Don Mullis <dwm@meer.net>

Use bool-true-false throughout.

Signed-off-by: Don Mullis <dwm@meer.net>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/fault-inject.h |    2 -
 lib/fault-inject.c           |   40 +++++++++++++++------------------
 2 files changed, 20 insertions(+), 22 deletions(-)

diff -puN include/linux/fault-inject.h~fault-injection-use-bool-true-false-throughout include/linux/fault-inject.h
--- a/include/linux/fault-inject.h~fault-injection-use-bool-true-false-throughout
+++ a/include/linux/fault-inject.h
@@ -57,7 +57,7 @@ struct fault_attr {
 #define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
 int setup_fault_attr(struct fault_attr *attr, char *str);
 void should_fail_srandom(unsigned long entropy);
-int should_fail(struct fault_attr *attr, ssize_t size);
+bool should_fail(struct fault_attr *attr, ssize_t size);
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
 
diff -puN lib/fault-inject.c~fault-injection-use-bool-true-false-throughout lib/fault-inject.c
--- a/lib/fault-inject.c~fault-injection-use-bool-true-false-throughout
+++ a/lib/fault-inject.c
@@ -48,7 +48,7 @@ static void fail_dump(struct fault_attr 
 
 #define atomic_dec_not_zero(v)		atomic_add_unless((v), -1, 0)
 
-static int fail_task(struct fault_attr *attr, struct task_struct *task)
+static bool fail_task(struct fault_attr *attr, struct task_struct *task)
 {
 	return !in_interrupt() && task->make_it_fail;
 }
@@ -68,15 +68,15 @@ static asmlinkage int fail_stacktrace_ca
 			break;
 		if (attr->reject_start <= UNW_PC(info) &&
 			       UNW_PC(info) < attr->reject_end)
-			return 0;
+			return false;
 		if (attr->require_start <= UNW_PC(info) &&
 			       UNW_PC(info) < attr->require_end)
-			found = 1;
+			found = true;
 	}
 	return found;
 }
 
-static int fail_stacktrace(struct fault_attr *attr)
+static bool fail_stacktrace(struct fault_attr *attr)
 {
 	struct unwind_frame_info info;
 
@@ -85,9 +85,7 @@ static int fail_stacktrace(struct fault_
 
 #elif defined(CONFIG_STACKTRACE)
 
-#define MAX_STACK_TRACE_DEPTH 32
-
-static int fail_stacktrace(struct fault_attr *attr)
+static bool fail_stacktrace(struct fault_attr *attr)
 {
 	struct stack_trace trace;
 	int depth = attr->stacktrace_depth;
@@ -109,26 +107,26 @@ static int fail_stacktrace(struct fault_
 	for (n = 0; n < trace.nr_entries; n++) {
 		if (attr->reject_start <= entries[n] &&
 			       entries[n] < attr->reject_end)
-			return 0;
+			return false;
 		if (attr->require_start <= entries[n] &&
 			       entries[n] < attr->require_end)
-			found = 1;
+			found = true;
 	}
 	return found;
 }
 
 #else
 
-static inline int fail_stacktrace(struct fault_attr *attr)
+static inline bool fail_stacktrace(struct fault_attr *attr)
 {
-	static int firsttime = 1;
+	static bool firsttime = true;
 
 	if (firsttime) {
 		printk(KERN_WARNING
 		"This architecture does not implement save_stack_trace()\n");
-		firsttime = 0;
+		firsttime = false;
 	}
-	return 0;
+	return false;
 }
 
 #endif
@@ -138,32 +136,32 @@ static inline int fail_stacktrace(struct
  * http://www.nongnu.org/failmalloc/
  */
 
-int should_fail(struct fault_attr *attr, ssize_t size)
+bool should_fail(struct fault_attr *attr, ssize_t size)
 {
 	if (attr->task_filter && !fail_task(attr, current))
-		return 0;
+		return false;
 
 	if (!fail_stacktrace(attr))
-		return 0;
+		return false;
 
 	if (atomic_read(&attr->times) == 0)
-		return 0;
+		return false;
 
 	if (atomic_read(&attr->space) > size) {
 		atomic_sub(size, &attr->space);
-		return 0;
+		return false;
 	}
 
 	if (attr->interval > 1) {
 		attr->count++;
 		if (attr->count % attr->interval)
-			return 0;
+			return false;
 	}
 
 	if (attr->probability > random32() % 100)
 		goto fail;
 
-	return 0;
+	return false;
 
 fail:
 	fail_dump(attr);
@@ -171,7 +169,7 @@ fail:
 	if (atomic_read(&attr->times) != -1)
 		atomic_dec_not_zero(&attr->times);
 
-	return 1;
+	return true;
 }
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
_

Patches currently in -mm which might be from dwm@meer.net are

fault-injection-use-bool-true-false-throughout.patch
fault-injection-clamp-debugfs-stacktrace-depth-to.patch
fault-injection-optimize-and-simplify.patch
fault-injection-defaults-likely-to-please-a-new.patch
kconfig-refactoring-for-better-menu-nesting.patch
sched-improve-migration-accuracy-fix.patch

