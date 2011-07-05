From: akpm@linux-foundation.org
Subject: + fault-injection-cleanup-simple-attribute-of-stacktrace_depth.patch added to -mm tree
Date: Tue, 05 Jul 2011 14:24:40 -0700
Message-ID: <201107052124.p65LOee7024965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608Ab1GEVYn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jul 2011 17:24:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     fault-injection: cleanup simple attribute of stacktrace_depth
has been added to the -mm tree.  Its filename is
     fault-injection-cleanup-simple-attribute-of-stacktrace_depth.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch
reiserfs-use-proper-little-endian-bitops.patch
reiserfs-use-hweight_long.patch
fault-injection-do-not-include-unneeded-header.patch
fault-injection-remove-nonexistent-function-extern.patch
fault-injection-cleanup-simple-attribute-of-stacktrace_depth.patch
fault-injection-use-debugfs_remove_recursive.patch
failslab-simplify-debugfs-initialization.patch
fail_page_alloc-simplify-debugfs-initialization.patch
fail_make_request-cleanup-should_fail_request.patch
asm-generic-add-another-generic-ext2-atomic-bitops.patch

