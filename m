From: akpm@linux-foundation.org
Subject: [patch 075/119] mm/zsmalloc: simplify shrinker
 init/destroy
Date: Wed, 31 Jan 2018 16:18:40 -0800
Message-ID: <20180201001840.8OX4szu56%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35474 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755806AbeBAASm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:18:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akaraliou.dev@gmail.com, akpm@linux-foundation.org, mhocko@kernel.org, minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org

From: Aliaksei Karaliou <akaraliou.dev@gmail.com>
Subject: mm/zsmalloc: simplify shrinker init/destroy

Structure zs_pool has special flag to indicate success of shrinker
initialization.  unregister_shrinker() has improved and can detect by
itself whether actual deinitialization should be performed or not, so
extra flag becomes redundant.

[akpm@linux-foundation.org: update comment (Aliaksei), remove unneeded cast]
Link: http://lkml.kernel.org/r/1513680552-9798-1-git-send-email-akaraliou.dev@gmail.com
Signed-off-by: Aliaksei Karaliou <akaraliou.dev@gmail.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-simplify-shrinker-init-destroy mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-simplify-shrinker-init-destroy
+++ a/mm/zsmalloc.c
@@ -46,6 +46,7 @@
 #include <linux/vmalloc.h>
 #include <linux/preempt.h>
 #include <linux/spinlock.h>
+#include <linux/shrinker.h>
 #include <linux/types.h>
 #include <linux/debugfs.h>
 #include <linux/zsmalloc.h>
@@ -257,11 +258,7 @@ struct zs_pool {
 
 	/* Compact classes */
 	struct shrinker shrinker;
-	/*
-	 * To signify that register_shrinker() was successful
-	 * and unregister_shrinker() will not Oops.
-	 */
-	bool shrinker_enabled;
+
 #ifdef CONFIG_ZSMALLOC_STAT
 	struct dentry *stat_dentry;
 #endif
@@ -2324,10 +2321,7 @@ static unsigned long zs_shrinker_count(s
 
 static void zs_unregister_shrinker(struct zs_pool *pool)
 {
-	if (pool->shrinker_enabled) {
-		unregister_shrinker(&pool->shrinker);
-		pool->shrinker_enabled = false;
-	}
+	unregister_shrinker(&pool->shrinker);
 }
 
 static int zs_register_shrinker(struct zs_pool *pool)
@@ -2426,11 +2420,13 @@ struct zs_pool *zs_create_pool(const cha
 		goto err;
 
 	/*
-	 * Not critical, we still can use the pool
-	 * and user can trigger compaction manually.
+	 * Not critical since shrinker is only used to trigger internal
+	 * defragmentation of the pool which is pretty optional thing.  If
+	 * registration fails we still can use the pool normally and user can
+	 * trigger compaction manually. Thus, ignore return code.
 	 */
-	if (zs_register_shrinker(pool) == 0)
-		pool->shrinker_enabled = true;
+	zs_register_shrinker(pool);
+
 	return pool;
 
 err:
_
