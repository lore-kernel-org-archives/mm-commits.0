From: akpm@linux-foundation.org
Subject: [merged] fault-injection-cleanup-simple-attribute-of-stacktrace_depth.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:29:40 -0700
Message-ID: <201107271928.p6RJSRM5003305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755025Ab1G0T2r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:28:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fault-injection: cleanup simple attribute of stacktrace_depth
has been removed from the -mm tree.  Its filename was
     fault-injection-cleanup-simple-attribute-of-stacktrace_depth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fault-injection: cleanup simple attribute of stacktrace_depth
From: Akinobu Mita <akinobu.mita@gmail.com>

Minor cosmetic changes for simple attribute of stacktrace_depth:

 - use min_t()
 - reduce #ifdef by moving a function
 - do not use partly capitalized function name

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/fault-inject.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN lib/fault-inject.c~fault-injection-cleanup-simple-attribute-of-stacktrace_depth lib/fault-inject.c
--- a/lib/fault-inject.c~fault-injection-cleanup-simple-attribute-of-stacktrace_depth
+++ a/lib/fault-inject.c
@@ -139,16 +139,6 @@ static int debugfs_ul_set(void *data, u6
 	return 0;
 }
 
-#ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
-static int debugfs_ul_set_MAX_STACK_TRACE_DEPTH(void *data, u64 val)
-{
-	*(unsigned long *)data =
-		val < MAX_STACK_TRACE_DEPTH ?
-		val : MAX_STACK_TRACE_DEPTH;
-	return 0;
-}
-#endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
-
 static int debugfs_ul_get(void *data, u64 *val)
 {
 	*val = *(unsigned long *)data;
@@ -164,16 +154,26 @@ static struct dentry *debugfs_create_ul(
 }
 
 #ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
-DEFINE_SIMPLE_ATTRIBUTE(fops_ul_MAX_STACK_TRACE_DEPTH, debugfs_ul_get,
-			debugfs_ul_set_MAX_STACK_TRACE_DEPTH, "%llu\n");
 
-static struct dentry *debugfs_create_ul_MAX_STACK_TRACE_DEPTH(
+static int debugfs_stacktrace_depth_set(void *data, u64 val)
+{
+	*(unsigned long *)data =
+		min_t(unsigned long, val, MAX_STACK_TRACE_DEPTH);
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(fops_stacktrace_depth, debugfs_ul_get,
+			debugfs_stacktrace_depth_set, "%llu\n");
+
+static struct dentry *debugfs_create_stacktrace_depth(
 	const char *name, mode_t mode,
 	struct dentry *parent, unsigned long *value)
 {
 	return debugfs_create_file(name, mode, parent, value,
-				   &fops_ul_MAX_STACK_TRACE_DEPTH);
+				   &fops_stacktrace_depth);
 }
+
 #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
 static int debugfs_atomic_t_set(void *data, u64 val)
@@ -281,7 +281,7 @@ int init_fault_attr_dentries(struct faul
 #ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
 
 	attr->dentries.stacktrace_depth_file =
-		debugfs_create_ul_MAX_STACK_TRACE_DEPTH(
+		debugfs_create_stacktrace_depth(
 			"stacktrace-depth", mode, dir, &attr->stacktrace_depth);
 
 	attr->dentries.require_start_file =
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory.patch
linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch

