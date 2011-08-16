From: akpm@linux-foundation.org
Subject: [merged] fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:50:21 -0700
Message-ID: <201108161847.p7GIlSaZ015090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129Ab1HPSsX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:48:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, axboe@kernel.dk, cl@linux-foundation.org, mpm@selenic.com, penberg@kernel.org, per.forlin@linaro.org, rdunlap@xenotime.net, sfr@canb.auug.org.au, mm-commits@vg


The patch titled
     fault-injection: add ability to export fault_attr in arbitrary directory
has been removed from the -mm tree.  Its filename was
     fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fault-injection: add ability to export fault_attr in arbitrary directory
From: Akinobu Mita <akinobu.mita@gmail.com>

init_fault_attr_dentries() is used to export fault_attr via debugfs.  But
it can only export it in debugfs root directory.

Per Forlin is working on mmc_fail_request which adds support to inject
data errors after a completed host transfer in MMC subsystem.

The fault_attr for mmc_fail_request should be defined per mmc host and
export it in debugfs directory per mmc host like
/sys/kernel/debug/mmc0/mmc_fail_request.

init_fault_attr_dentries() doesn't help for mmc_fail_request.  So this
introduces fault_create_debugfs_attr() which is able to create a directory
in the arbitrary directory and replace init_fault_attr_dentries().

[akpm@linux-foundation.org: extraneous semicolon, per Randy]
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Tested-by: Per Forlin <per.forlin@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fault-injection/fault-injection.txt |    3 -
 block/blk-core.c                                  |    6 ++-
 block/blk-timeout.c                               |    5 ++-
 include/linux/fault-inject.h                      |   18 +++-------
 lib/fault-inject.c                                |   20 ++++--------
 mm/failslab.c                                     |   14 ++++----
 mm/page_alloc.c                                   |   13 +++----
 7 files changed, 33 insertions(+), 46 deletions(-)

diff -puN Documentation/fault-injection/fault-injection.txt~fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory Documentation/fault-injection/fault-injection.txt
--- a/Documentation/fault-injection/fault-injection.txt~fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory
+++ a/Documentation/fault-injection/fault-injection.txt
@@ -143,8 +143,7 @@ o provide a way to configure fault attri
   failslab, fail_page_alloc, and fail_make_request use this way.
   Helper functions:
 
-	init_fault_attr_dentries(entries, attr, name);
-	void cleanup_fault_attr_dentries(entries);
+	fault_create_debugfs_attr(name, parent, attr);
 
 - module parameters
 
diff -puN block/blk-core.c~fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory block/blk-core.c
--- a/block/blk-core.c~fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory
+++ a/block/blk-core.c
@@ -1368,8 +1368,10 @@ static bool should_fail_request(struct h
 
 static int __init fail_make_request_debugfs(void)
 {
-	return init_fault_attr_dentries(&fail_make_request,
-					"fail_make_request");
+	struct dentry *dir = fault_create_debugfs_attr("fail_make_request",
+						NULL, &fail_make_request);
+
+	return IS_ERR(dir) ? PTR_ERR(dir) : 0;
 }
 
 late_initcall(fail_make_request_debugfs);
diff -puN block/blk-timeout.c~fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory block/blk-timeout.c
--- a/block/blk-timeout.c~fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory
+++ a/block/blk-timeout.c
@@ -28,7 +28,10 @@ int blk_should_fake_timeout(struct reque
 
 static int __init fail_io_timeout_debugfs(void)
 {
-	return init_fault_attr_dentries(&fail_io_timeout, "fail_io_timeout");
+	struct dentry *dir = fault_create_debugfs_attr("fail_io_timeout",
+						NULL, &fail_io_timeout);
+
+	return IS_ERR(dir) ? PTR_ERR(dir) : 0;
 }
 
 late_initcall(fail_io_timeout_debugfs);
diff -puN include/linux/fault-inject.h~fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory include/linux/fault-inject.h
--- a/include/linux/fault-inject.h~fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory
+++ a/include/linux/fault-inject.h
@@ -25,10 +25,6 @@ struct fault_attr {
 	unsigned long reject_end;
 
 	unsigned long count;
-
-#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
-	struct dentry *dir;
-#endif
 };
 
 #define FAULT_ATTR_INITIALIZER {				\
@@ -45,19 +41,15 @@ bool should_fail(struct fault_attr *attr
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
 
-int init_fault_attr_dentries(struct fault_attr *attr, const char *name);
-void cleanup_fault_attr_dentries(struct fault_attr *attr);
+struct dentry *fault_create_debugfs_attr(const char *name,
+			struct dentry *parent, struct fault_attr *attr);
 
 #else /* CONFIG_FAULT_INJECTION_DEBUG_FS */
 
-static inline int init_fault_attr_dentries(struct fault_attr *attr,
-					  const char *name)
-{
-	return -ENODEV;
-}
-
-static inline void cleanup_fault_attr_dentries(struct fault_attr *attr)
+static inline struct dentry *fault_create_debugfs_attr(const char *name,
+			struct dentry *parent, struct fault_attr *attr)
 {
+	return ERR_PTR(-ENODEV);
 }
 
 #endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
diff -puN lib/fault-inject.c~fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory lib/fault-inject.c
--- a/lib/fault-inject.c~fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory
+++ a/lib/fault-inject.c
@@ -197,21 +197,15 @@ static struct dentry *debugfs_create_ato
 	return debugfs_create_file(name, mode, parent, value, &fops_atomic_t);
 }
 
-void cleanup_fault_attr_dentries(struct fault_attr *attr)
-{
-	debugfs_remove_recursive(attr->dir);
-}
-
-int init_fault_attr_dentries(struct fault_attr *attr, const char *name)
+struct dentry *fault_create_debugfs_attr(const char *name,
+			struct dentry *parent, struct fault_attr *attr)
 {
 	mode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
 	struct dentry *dir;
 
-	dir = debugfs_create_dir(name, NULL);
+	dir = debugfs_create_dir(name, parent);
 	if (!dir)
-		return -ENOMEM;
-
-	attr->dir = dir;
+		return ERR_PTR(-ENOMEM);
 
 	if (!debugfs_create_ul("probability", mode, dir, &attr->probability))
 		goto fail;
@@ -243,11 +237,11 @@ int init_fault_attr_dentries(struct faul
 
 #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
-	return 0;
+	return dir;
 fail:
-	debugfs_remove_recursive(attr->dir);
+	debugfs_remove_recursive(dir);
 
-	return -ENOMEM;
+	return ERR_PTR(-ENOMEM);
 }
 
 #endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
diff -puN mm/failslab.c~fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory mm/failslab.c
--- a/mm/failslab.c~fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory
+++ a/mm/failslab.c
@@ -34,23 +34,23 @@ __setup("failslab=", setup_failslab);
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
 static int __init failslab_debugfs_init(void)
 {
+	struct dentry *dir;
 	mode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
-	int err;
 
-	err = init_fault_attr_dentries(&failslab.attr, "failslab");
-	if (err)
-		return err;
+	dir = fault_create_debugfs_attr("failslab", NULL, &failslab.attr);
+	if (IS_ERR(dir))
+		return PTR_ERR(dir);
 
-	if (!debugfs_create_bool("ignore-gfp-wait", mode, failslab.attr.dir,
+	if (!debugfs_create_bool("ignore-gfp-wait", mode, dir,
 				&failslab.ignore_gfp_wait))
 		goto fail;
-	if (!debugfs_create_bool("cache-filter", mode, failslab.attr.dir,
+	if (!debugfs_create_bool("cache-filter", mode, dir,
 				&failslab.cache_filter))
 		goto fail;
 
 	return 0;
 fail:
-	cleanup_fault_attr_dentries(&failslab.attr);
+	debugfs_remove_recursive(dir);
 
 	return -ENOMEM;
 }
diff -puN mm/page_alloc.c~fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory mm/page_alloc.c
--- a/mm/page_alloc.c~fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory
+++ a/mm/page_alloc.c
@@ -1409,14 +1409,11 @@ static int __init fail_page_alloc_debugf
 {
 	mode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
 	struct dentry *dir;
-	int err;
 
-	err = init_fault_attr_dentries(&fail_page_alloc.attr,
-				       "fail_page_alloc");
-	if (err)
-		return err;
-
-	dir = fail_page_alloc.attr.dir;
+	dir = fault_create_debugfs_attr("fail_page_alloc", NULL,
+					&fail_page_alloc.attr);
+	if (IS_ERR(dir))
+		return PTR_ERR(dir);
 
 	if (!debugfs_create_bool("ignore-gfp-wait", mode, dir,
 				&fail_page_alloc.ignore_gfp_wait))
@@ -1430,7 +1427,7 @@ static int __init fail_page_alloc_debugf
 
 	return 0;
 fail:
-	cleanup_fault_attr_dentries(&fail_page_alloc.attr);
+	debugfs_remove_recursive(dir);
 
 	return -ENOMEM;
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch

