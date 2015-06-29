From: akpm@linux-foundation.org
Subject: [merged] zpool-remove-zpool_evict.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:46:41 -0700
Message-ID: <5591aeb1.Yl+ctpTtacMrHtgr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbbF2Uqm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:46:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, minchan@kernel.org, ngupta@vflare.org, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zpool: remove zpool_evict()
has been removed from the -mm tree.  Its filename was
     zpool-remove-zpool_evict.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: zpool: remove zpool_evict()

Remove zpool_evict() helper function.  As zbud is currently the only zpool
implementation that supports eviction, add zpool and zpool_ops references
to struct zbud_pool and directly call zpool_ops->evict(zpool, handle) on
eviction.

Currently zpool provides the zpool_evict helper which locks the zpool list
lock and searches through all pools to find the specific one matching the
caller, and call the corresponding zpool_ops->evict function.  However,
this is unnecessary, as the zbud pool can simply keep a reference to the
zpool that created it, as well as the zpool_ops, and directly call the
zpool_ops->evict function, when it needs to evict a page.  This avoids a
spinlock and list search in zpool for each eviction.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zpool.h |    5 ++---
 mm/zbud.c             |   23 +++++++++++++++++++----
 mm/zpool.c            |   29 +----------------------------
 mm/zsmalloc.c         |    3 ++-
 4 files changed, 24 insertions(+), 36 deletions(-)

diff -puN include/linux/zpool.h~zpool-remove-zpool_evict include/linux/zpool.h
--- a/include/linux/zpool.h~zpool-remove-zpool_evict
+++ a/include/linux/zpool.h
@@ -81,7 +81,8 @@ struct zpool_driver {
 	atomic_t refcount;
 	struct list_head list;
 
-	void *(*create)(char *name, gfp_t gfp, struct zpool_ops *ops);
+	void *(*create)(char *name, gfp_t gfp, struct zpool_ops *ops,
+			struct zpool *zpool);
 	void (*destroy)(void *pool);
 
 	int (*malloc)(void *pool, size_t size, gfp_t gfp,
@@ -102,6 +103,4 @@ void zpool_register_driver(struct zpool_
 
 int zpool_unregister_driver(struct zpool_driver *driver);
 
-int zpool_evict(void *pool, unsigned long handle);
-
 #endif
diff -puN mm/zbud.c~zpool-remove-zpool_evict mm/zbud.c
--- a/mm/zbud.c~zpool-remove-zpool_evict
+++ a/mm/zbud.c
@@ -97,6 +97,10 @@ struct zbud_pool {
 	struct list_head lru;
 	u64 pages_nr;
 	struct zbud_ops *ops;
+#ifdef CONFIG_ZPOOL
+	struct zpool *zpool;
+	struct zpool_ops *zpool_ops;
+#endif
 };
 
 /*
@@ -123,7 +127,10 @@ struct zbud_header {
 
 static int zbud_zpool_evict(struct zbud_pool *pool, unsigned long handle)
 {
-	return zpool_evict(pool, handle);
+	if (pool->zpool && pool->zpool_ops && pool->zpool_ops->evict)
+		return pool->zpool_ops->evict(pool->zpool, handle);
+	else
+		return -ENOENT;
 }
 
 static struct zbud_ops zbud_zpool_ops = {
@@ -131,9 +138,17 @@ static struct zbud_ops zbud_zpool_ops =
 };
 
 static void *zbud_zpool_create(char *name, gfp_t gfp,
-			struct zpool_ops *zpool_ops)
+			       struct zpool_ops *zpool_ops,
+			       struct zpool *zpool)
 {
-	return zbud_create_pool(gfp, zpool_ops ? &zbud_zpool_ops : NULL);
+	struct zbud_pool *pool;
+
+	pool = zbud_create_pool(gfp, zpool_ops ? &zbud_zpool_ops : NULL);
+	if (pool) {
+		pool->zpool = zpool;
+		pool->zpool_ops = zpool_ops;
+	}
+	return pool;
 }
 
 static void zbud_zpool_destroy(void *pool)
@@ -292,7 +307,7 @@ struct zbud_pool *zbud_create_pool(gfp_t
 	struct zbud_pool *pool;
 	int i;
 
-	pool = kmalloc(sizeof(struct zbud_pool), gfp);
+	pool = kzalloc(sizeof(struct zbud_pool), gfp);
 	if (!pool)
 		return NULL;
 	spin_lock_init(&pool->lock);
diff -puN mm/zpool.c~zpool-remove-zpool_evict mm/zpool.c
--- a/mm/zpool.c~zpool-remove-zpool_evict
+++ a/mm/zpool.c
@@ -73,33 +73,6 @@ int zpool_unregister_driver(struct zpool
 }
 EXPORT_SYMBOL(zpool_unregister_driver);
 
-/**
- * zpool_evict() - evict callback from a zpool implementation.
- * @pool:	pool to evict from.
- * @handle:	handle to evict.
- *
- * This can be used by zpool implementations to call the
- * user's evict zpool_ops struct evict callback.
- */
-int zpool_evict(void *pool, unsigned long handle)
-{
-	struct zpool *zpool;
-
-	spin_lock(&pools_lock);
-	list_for_each_entry(zpool, &pools_head, list) {
-		if (zpool->pool == pool) {
-			spin_unlock(&pools_lock);
-			if (!zpool->ops || !zpool->ops->evict)
-				return -EINVAL;
-			return zpool->ops->evict(zpool, handle);
-		}
-	}
-	spin_unlock(&pools_lock);
-
-	return -ENOENT;
-}
-EXPORT_SYMBOL(zpool_evict);
-
 static struct zpool_driver *zpool_get_driver(char *type)
 {
 	struct zpool_driver *driver;
@@ -170,7 +143,7 @@ struct zpool *zpool_create_pool(char *ty
 
 	zpool->type = driver->type;
 	zpool->driver = driver;
-	zpool->pool = driver->create(name, gfp, ops);
+	zpool->pool = driver->create(name, gfp, ops, zpool);
 	zpool->ops = ops;
 
 	if (!zpool->pool) {
diff -puN mm/zsmalloc.c~zpool-remove-zpool_evict mm/zsmalloc.c
--- a/mm/zsmalloc.c~zpool-remove-zpool_evict
+++ a/mm/zsmalloc.c
@@ -309,7 +309,8 @@ static void record_obj(unsigned long han
 
 #ifdef CONFIG_ZPOOL
 
-static void *zs_zpool_create(char *name, gfp_t gfp, struct zpool_ops *zpool_ops)
+static void *zs_zpool_create(char *name, gfp_t gfp, struct zpool_ops *zpool_ops,
+			     struct zpool *zpool)
 {
 	return zs_create_pool(name, gfp);
 }
_

Patches currently in -mm which might be from ddstreet@ieee.org are

origin.patch
linux-next.patch
maintainers-add-zpool.patch

