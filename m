From: akpm@linux-foundation.org
Subject: [merged] fault-injection-use-debugfs_remove_recursive.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:29:42 -0700
Message-ID: <201107271928.p6RJST5q003308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755029Ab1G0T2u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:28:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fault-injection: use debugfs_remove_recursive
has been removed from the -mm tree.  Its filename was
     fault-injection-use-debugfs_remove_recursive.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fault-injection: use debugfs_remove_recursive
From: Akinobu Mita <akinobu.mita@gmail.com>

Use debugfs_remove_recursive() to simplify initialization and
deinitialization of fault injection debugfs files.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fault-inject.h |   18 -----
 lib/fault-inject.c           |  115 +++++++--------------------------
 mm/failslab.c                |    2 
 mm/page_alloc.c              |    2 
 4 files changed, 30 insertions(+), 107 deletions(-)

diff -puN include/linux/fault-inject.h~fault-injection-use-debugfs_remove_recursive include/linux/fault-inject.h
--- a/include/linux/fault-inject.h~fault-injection-use-debugfs_remove_recursive
+++ a/include/linux/fault-inject.h
@@ -27,23 +27,7 @@ struct fault_attr {
 	unsigned long count;
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
-
-	struct {
-		struct dentry *dir;
-
-		struct dentry *probability_file;
-		struct dentry *interval_file;
-		struct dentry *times_file;
-		struct dentry *space_file;
-		struct dentry *verbose_file;
-		struct dentry *task_filter_file;
-		struct dentry *stacktrace_depth_file;
-		struct dentry *require_start_file;
-		struct dentry *require_end_file;
-		struct dentry *reject_start_file;
-		struct dentry *reject_end_file;
-	} dentries;
-
+	struct dentry *dir;
 #endif
 };
 
diff -puN lib/fault-inject.c~fault-injection-use-debugfs_remove_recursive lib/fault-inject.c
--- a/lib/fault-inject.c~fault-injection-use-debugfs_remove_recursive
+++ a/lib/fault-inject.c
@@ -199,48 +199,7 @@ static struct dentry *debugfs_create_ato
 
 void cleanup_fault_attr_dentries(struct fault_attr *attr)
 {
-	debugfs_remove(attr->dentries.probability_file);
-	attr->dentries.probability_file = NULL;
-
-	debugfs_remove(attr->dentries.interval_file);
-	attr->dentries.interval_file = NULL;
-
-	debugfs_remove(attr->dentries.times_file);
-	attr->dentries.times_file = NULL;
-
-	debugfs_remove(attr->dentries.space_file);
-	attr->dentries.space_file = NULL;
-
-	debugfs_remove(attr->dentries.verbose_file);
-	attr->dentries.verbose_file = NULL;
-
-	debugfs_remove(attr->dentries.task_filter_file);
-	attr->dentries.task_filter_file = NULL;
-
-#ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
-
-	debugfs_remove(attr->dentries.stacktrace_depth_file);
-	attr->dentries.stacktrace_depth_file = NULL;
-
-	debugfs_remove(attr->dentries.require_start_file);
-	attr->dentries.require_start_file = NULL;
-
-	debugfs_remove(attr->dentries.require_end_file);
-	attr->dentries.require_end_file = NULL;
-
-	debugfs_remove(attr->dentries.reject_start_file);
-	attr->dentries.reject_start_file = NULL;
-
-	debugfs_remove(attr->dentries.reject_end_file);
-	attr->dentries.reject_end_file = NULL;
-
-#endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
-
-	if (attr->dentries.dir)
-		WARN_ON(!simple_empty(attr->dentries.dir));
-
-	debugfs_remove(attr->dentries.dir);
-	attr->dentries.dir = NULL;
+	debugfs_remove_recursive(attr->dir);
 }
 
 int init_fault_attr_dentries(struct fault_attr *attr, const char *name)
@@ -248,66 +207,46 @@ int init_fault_attr_dentries(struct faul
 	mode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
 	struct dentry *dir;
 
-	memset(&attr->dentries, 0, sizeof(attr->dentries));
-
 	dir = debugfs_create_dir(name, NULL);
 	if (!dir)
-		goto fail;
-	attr->dentries.dir = dir;
-
-	attr->dentries.probability_file =
-		debugfs_create_ul("probability", mode, dir, &attr->probability);
-
-	attr->dentries.interval_file =
-		debugfs_create_ul("interval", mode, dir, &attr->interval);
-
-	attr->dentries.times_file =
-		debugfs_create_atomic_t("times", mode, dir, &attr->times);
+		return -ENOMEM;
 
-	attr->dentries.space_file =
-		debugfs_create_atomic_t("space", mode, dir, &attr->space);
+	attr->dir = dir;
 
-	attr->dentries.verbose_file =
-		debugfs_create_ul("verbose", mode, dir, &attr->verbose);
-
-	attr->dentries.task_filter_file = debugfs_create_bool("task-filter",
-						mode, dir, &attr->task_filter);
-
-	if (!attr->dentries.probability_file || !attr->dentries.interval_file ||
-	    !attr->dentries.times_file || !attr->dentries.space_file ||
-	    !attr->dentries.verbose_file || !attr->dentries.task_filter_file)
+	if (!debugfs_create_ul("probability", mode, dir, &attr->probability))
+		goto fail;
+	if (!debugfs_create_ul("interval", mode, dir, &attr->interval))
+		goto fail;
+	if (!debugfs_create_atomic_t("times", mode, dir, &attr->times))
+		goto fail;
+	if (!debugfs_create_atomic_t("space", mode, dir, &attr->space))
+		goto fail;
+	if (!debugfs_create_ul("verbose", mode, dir, &attr->verbose))
+		goto fail;
+	if (!debugfs_create_bool("task-filter", mode, dir, &attr->task_filter))
 		goto fail;
 
 #ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
 
-	attr->dentries.stacktrace_depth_file =
-		debugfs_create_stacktrace_depth(
-			"stacktrace-depth", mode, dir, &attr->stacktrace_depth);
-
-	attr->dentries.require_start_file =
-		debugfs_create_ul("require-start", mode, dir, &attr->require_start);
-
-	attr->dentries.require_end_file =
-		debugfs_create_ul("require-end", mode, dir, &attr->require_end);
-
-	attr->dentries.reject_start_file =
-		debugfs_create_ul("reject-start", mode, dir, &attr->reject_start);
-
-	attr->dentries.reject_end_file =
-		debugfs_create_ul("reject-end", mode, dir, &attr->reject_end);
-
-	if (!attr->dentries.stacktrace_depth_file ||
-	    !attr->dentries.require_start_file ||
-	    !attr->dentries.require_end_file ||
-	    !attr->dentries.reject_start_file ||
-	    !attr->dentries.reject_end_file)
+	if (!debugfs_create_stacktrace_depth("stacktrace-depth", mode, dir,
+				&attr->stacktrace_depth))
+		goto fail;
+	if (!debugfs_create_ul("require-start", mode, dir,
+				&attr->require_start))
+		goto fail;
+	if (!debugfs_create_ul("require-end", mode, dir, &attr->require_end))
+		goto fail;
+	if (!debugfs_create_ul("reject-start", mode, dir, &attr->reject_start))
+		goto fail;
+	if (!debugfs_create_ul("reject-end", mode, dir, &attr->reject_end))
 		goto fail;
 
 #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
 	return 0;
 fail:
-	cleanup_fault_attr_dentries(attr);
+	debugfs_remove_recursive(attr->dir);
+
 	return -ENOMEM;
 }
 
diff -puN mm/failslab.c~fault-injection-use-debugfs_remove_recursive mm/failslab.c
--- a/mm/failslab.c~fault-injection-use-debugfs_remove_recursive
+++ a/mm/failslab.c
@@ -45,7 +45,7 @@ static int __init failslab_debugfs_init(
 	err = init_fault_attr_dentries(&failslab.attr, "failslab");
 	if (err)
 		return err;
-	dir = failslab.attr.dentries.dir;
+	dir = failslab.attr.dir;
 
 	failslab.ignore_gfp_wait_file =
 		debugfs_create_bool("ignore-gfp-wait", mode, dir,
diff -puN mm/page_alloc.c~fault-injection-use-debugfs_remove_recursive mm/page_alloc.c
--- a/mm/page_alloc.c~fault-injection-use-debugfs_remove_recursive
+++ a/mm/page_alloc.c
@@ -1424,7 +1424,7 @@ static int __init fail_page_alloc_debugf
 				       "fail_page_alloc");
 	if (err)
 		return err;
-	dir = fail_page_alloc.attr.dentries.dir;
+	dir = fail_page_alloc.attr.dir;
 
 	fail_page_alloc.ignore_gfp_wait_file =
 		debugfs_create_bool("ignore-gfp-wait", mode, dir,
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory.patch
linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch

