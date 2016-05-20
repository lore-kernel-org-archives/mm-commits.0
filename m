From: akpm@linux-foundation.org
Subject: [patch 071/162] mm/zsmalloc: don't fail if can't create debugfs
 info
Date: Fri, 20 May 2016 16:59:56 -0700
Message-ID: <573fa4fc.DtRE/uTIe7luq5Hg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbcETX76 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:59:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ddstreet@ieee.org, dan.streetman@canonical.com, minchan@kernel.org, sergey.senozhatsky@gmail.com

From: Dan Streetman <ddstreet@ieee.org>
Subject: mm/zsmalloc: don't fail if can't create debugfs info

Change the return type of zs_pool_stat_create() to void, and
remove the logic to abort pool creation if the stat debugfs
dir/file could not be created.

The debugfs stat file is for debugging/information only, and doesn't
affect operation of zsmalloc; there is no reason to abort creating
the pool if the stat file can't be created.  This was seen with
zswap, which used the same name for all pool creations, which caused
zsmalloc to fail to create a second pool for zswap if
CONFIG_ZSMALLOC_STAT was enabled.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Dan Streetman <dan.streetman@canonical.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-dont-fail-if-cant-create-debugfs-info mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-dont-fail-if-cant-create-debugfs-info
+++ a/mm/zsmalloc.c
@@ -573,17 +573,17 @@ static const struct file_operations zs_s
 	.release        = single_release,
 };
 
-static int zs_pool_stat_create(struct zs_pool *pool, const char *name)
+static void zs_pool_stat_create(struct zs_pool *pool, const char *name)
 {
 	struct dentry *entry;
 
 	if (!zs_stat_root)
-		return -ENODEV;
+		return;
 
 	entry = debugfs_create_dir(name, zs_stat_root);
 	if (!entry) {
 		pr_warn("debugfs dir <%s> creation failed\n", name);
-		return -ENOMEM;
+		return;
 	}
 	pool->stat_dentry = entry;
 
@@ -592,10 +592,8 @@ static int zs_pool_stat_create(struct zs
 	if (!entry) {
 		pr_warn("%s: debugfs file entry <%s> creation failed\n",
 				name, "classes");
-		return -ENOMEM;
+		return;
 	}
-
-	return 0;
 }
 
 static void zs_pool_stat_destroy(struct zs_pool *pool)
@@ -613,9 +611,8 @@ static void __exit zs_stat_exit(void)
 {
 }
 
-static inline int zs_pool_stat_create(struct zs_pool *pool, const char *name)
+static inline void zs_pool_stat_create(struct zs_pool *pool, const char *name)
 {
-	return 0;
 }
 
 static inline void zs_pool_stat_destroy(struct zs_pool *pool)
@@ -623,7 +620,6 @@ static inline void zs_pool_stat_destroy(
 }
 #endif
 
