From: akpm@linux-foundation.org
Subject: + fault-injection-split-up-stacktrace-filter-kconfig-option.patch added to -mm tree
Date: Thu, 15 Feb 2007 17:07:43 -0800
Message-ID: <200702160107.l1G17hEF015046@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41774 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbXBPBHq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 20:07:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, blaisorblade@yahoo.it


The patch titled
     fault injection: split up stacktrace filter Kconfig option
has been added to the -mm tree.  Its filename is
     fault-injection-split-up-stacktrace-filter-kconfig-option.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fault injection: split up stacktrace filter Kconfig option
From: Akinobu Mita <akinobu.mita@gmail.com>

There is no prompt for CONFIG_STACKTRACE, so FAULT_INJECTION cannot be
selected without LOCKDEP enabled.  (found by Paolo 'Blaisorblade'
Giarrusso)

In order to fix such broken Kconfig dependency, this patch splits up the
stacktrace filter support for fault injection by new Kconfig option, which
enables to use fault injection on the architecture which doesn't have
general stacktrace support.

Cc: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug  |   10 ++++++++--
 lib/fault-inject.c |   41 +++++++++++++++++++++--------------------
 2 files changed, 29 insertions(+), 22 deletions(-)

diff -puN lib/Kconfig.debug~fault-injection-split-up-stacktrace-filter-kconfig-option lib/Kconfig.debug
--- a/lib/Kconfig.debug~fault-injection-split-up-stacktrace-filter-kconfig-option
+++ a/lib/Kconfig.debug
@@ -400,8 +400,6 @@ config LKDTM
 config FAULT_INJECTION
 	bool "Fault-injection framework"
 	depends on DEBUG_KERNEL
-	depends on STACKTRACE
-	select FRAME_POINTER
 	help
 	  Provide fault-injection framework.
 	  For more details, see Documentation/fault-injection/.
@@ -429,3 +427,11 @@ config FAULT_INJECTION_DEBUG_FS
 	depends on FAULT_INJECTION && SYSFS && DEBUG_FS
 	help
 	  Enable configuration of fault-injection capabilities via debugfs.
+
+config FAULT_INJECTION_STACKTRACE_FILTER
+	bool "stacktrace filter for fault-injection capabilities"
+	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
+	select STACKTRACE
+	select FRAME_POINTER
+	help
+	  Provide stacktrace filter for fault-injection capabilities
diff -puN lib/fault-inject.c~fault-injection-split-up-stacktrace-filter-kconfig-option lib/fault-inject.c
--- a/lib/fault-inject.c~fault-injection-split-up-stacktrace-filter-kconfig-option
+++ a/lib/fault-inject.c
@@ -55,7 +55,7 @@ static bool fail_task(struct fault_attr 
 
 #define MAX_STACK_TRACE_DEPTH 32
 
-#if defined(CONFIG_STACKTRACE)
+#ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
 
 static bool fail_stacktrace(struct fault_attr *attr)
 {
@@ -89,17 +89,10 @@ static bool fail_stacktrace(struct fault
 
 static inline bool fail_stacktrace(struct fault_attr *attr)
 {
-	static bool firsttime = true;
-
-	if (firsttime) {
-		printk(KERN_WARNING
-		"This architecture does not implement save_stack_trace()\n");
-		firsttime = false;
-	}
-	return false;
+	return true;
 }
 
-#endif
+#endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
 /*
  * This code is stolen from failmalloc-1.0
@@ -216,6 +209,8 @@ void cleanup_fault_attr_dentries(struct 
 	debugfs_remove(attr->dentries.task_filter_file);
 	attr->dentries.task_filter_file = NULL;
 
+#ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
+
 	debugfs_remove(attr->dentries.stacktrace_depth_file);
 	attr->dentries.stacktrace_depth_file = NULL;
 
@@ -231,6 +226,8 @@ void cleanup_fault_attr_dentries(struct 
 	debugfs_remove(attr->dentries.reject_end_file);
 	attr->dentries.reject_end_file = NULL;
 
+#endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
+
 	if (attr->dentries.dir)
 		WARN_ON(!simple_empty(attr->dentries.dir));
 
@@ -268,6 +265,13 @@ int init_fault_attr_dentries(struct faul
 	attr->dentries.task_filter_file = debugfs_create_bool("task-filter",
 						mode, dir, &attr->task_filter);
 
+	if (!attr->dentries.probability_file || !attr->dentries.interval_file ||
+	    !attr->dentries.times_file || !attr->dentries.space_file ||
+	    !attr->dentries.verbose_file || !attr->dentries.task_filter_file)
+		goto fail;
+
+#ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
+
 	attr->dentries.stacktrace_depth_file =
 		debugfs_create_ul_MAX_STACK_TRACE_DEPTH(
 			"stacktrace-depth", mode, dir, &attr->stacktrace_depth);
@@ -284,18 +288,15 @@ int init_fault_attr_dentries(struct faul
 	attr->dentries.reject_end_file =
 		debugfs_create_ul("reject-end", mode, dir, &attr->reject_end);
 
-
-	if (!attr->dentries.probability_file || !attr->dentries.interval_file
-	    || !attr->dentries.times_file || !attr->dentries.space_file
-	    || !attr->dentries.verbose_file || !attr->dentries.task_filter_file
-	    || !attr->dentries.stacktrace_depth_file
-	    || !attr->dentries.require_start_file
-	    || !attr->dentries.require_end_file
-	    || !attr->dentries.reject_start_file
-	    || !attr->dentries.reject_end_file
-	    )
+	if (!attr->dentries.stacktrace_depth_file ||
+	    !attr->dentries.require_start_file ||
+	    !attr->dentries.require_end_file ||
+	    !attr->dentries.reject_start_file ||
+	    !attr->dentries.reject_end_file)
 		goto fail;
 
+#endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
+
 	return 0;
 fail:
 	cleanup_fault_attr_dentries(attr);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
simplify-the-stacktrace-code.patch
fault-injection-split-up-stacktrace-filter-kconfig-option.patch
kconfig-fault_injection-can-be-selected-only-if-lockdep-is-enabled.patch
