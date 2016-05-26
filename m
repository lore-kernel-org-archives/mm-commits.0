From: akpm@linux-foundation.org
Subject: [patch 09/10] update "mm/zsmalloc: don't fail if can't create
 debugfs info"
Date: Thu, 26 May 2016 15:16:27 -0700
Message-ID: <574775bb.OqlZevfHte8bKKU1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbcEZWQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2016 18:16:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ddstreet@ieee.org, dan.streetman@canonical.com, minchan@kernel.org, opensource.ganesh@gmail.com, sergey.senozhatsky@gmail.com

From: Dan Streetman <ddstreet@ieee.org>
Subject: update "mm/zsmalloc: don't fail if can't create debugfs info"

Some updates to d34f615720d17c49 ("mm/zsmalloc: don't fail if can't create
debugfs info"):

- add pr_warn to all stat failure cases
- do not prevent module loading on stat failure

Link: http://lkml.kernel.org/r/1463671123-5479-1-git-send-email-ddstreet@ieee.org
Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Reviewed-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Dan Streetman <dan.streetman@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff -puN mm/zsmalloc.c~update-mm-zsmalloc-dont-fail-if-cant-create-debugfs-info mm/zsmalloc.c
--- a/mm/zsmalloc.c~update-mm-zsmalloc-dont-fail-if-cant-create-debugfs-info
+++ a/mm/zsmalloc.c
@@ -45,6 +45,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -483,16 +485,16 @@ static inline unsigned long zs_stat_get(
 
 #ifdef CONFIG_ZSMALLOC_STAT
 
-static int __init zs_stat_init(void)
+static void __init zs_stat_init(void)
 {
-	if (!debugfs_initialized())
-		return -ENODEV;
+	if (!debugfs_initialized()) {
+		pr_warn("debugfs not available, stat dir not created\n");
+		return;
+	}
 
 	zs_stat_root = debugfs_create_dir("zsmalloc", NULL);
 	if (!zs_stat_root)
-		return -ENOMEM;
-
-	return 0;
+		pr_warn("debugfs 'zsmalloc' stat dir creation failed\n");
 }
 
 static void __exit zs_stat_exit(void)
@@ -577,8 +579,10 @@ static void zs_pool_stat_create(struct z
 {
 	struct dentry *entry;
 
-	if (!zs_stat_root)
+	if (!zs_stat_root) {
+		pr_warn("no root stat dir, not creating <%s> stat dir\n", name);
 		return;
+	}
 
 	entry = debugfs_create_dir(name, zs_stat_root);
 	if (!entry) {
@@ -592,7 +596,8 @@ static void zs_pool_stat_create(struct z
 	if (!entry) {
 		pr_warn("%s: debugfs file entry <%s> creation failed\n",
 				name, "classes");
-		return;
+		debugfs_remove_recursive(pool->stat_dentry);
+		pool->stat_dentry = NULL;
 	}
 }
 
@@ -602,9 +607,8 @@ static void zs_pool_stat_destroy(struct
 }
 
 #else /* CONFIG_ZSMALLOC_STAT */
-static int __init zs_stat_init(void)
+static void __init zs_stat_init(void)
 {
-	return 0;
 }
 
 static void __exit zs_stat_exit(void)
@@ -2011,17 +2015,10 @@ static int __init zs_init(void)
 	zpool_register_driver(&zs_zpool_driver);
 #endif
 
-	ret = zs_stat_init();
-	if (ret) {
-		pr_err("zs stat initialization failed\n");
-		goto stat_fail;
-	}
+	zs_stat_init();
+
 	return 0;
 
-stat_fail:
-#ifdef CONFIG_ZPOOL
-	zpool_unregister_driver(&zs_zpool_driver);
-#endif
 notifier_fail:
 	zs_unregister_cpu_notifier();
 
_
