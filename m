From: akpm@linux-foundation.org
Subject: [merged] mm-zpool-add-name-argument-to-create-zpool.patch removed from -mm tree
Date: Fri, 13 Feb 2015 12:21:28 -0800
Message-ID: <54de5cc8.ugTcFiCHfgVk1kM0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbBMUV3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:21:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, ddstreet@ieee.org, minchan@kernel.org, ngupta@vflare.org, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zpool: add name argument to create zpool
has been removed from the -mm tree.  Its filename was
     mm-zpool-add-name-argument-to-create-zpool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: mm/zpool: add name argument to create zpool

Currently the underlay of zpool: zsmalloc/zbud, do not know who creates
them.  There is not a method to let zsmalloc/zbud find which caller they
belong to.

Now we want to add statistics collection in zsmalloc.  We need to name the
debugfs dir for each pool created.  The way suggested by Minchan Kim is to
use a name passed by caller(such as zram) to create the zsmalloc pool.

    /sys/kernel/debug/zsmalloc/zram0

This patch adds an argument `name' to zs_create_pool() and other related
functions.

Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 +++++---
 include/linux/zpool.h         |    5 +++--
 include/linux/zsmalloc.h      |    2 +-
 mm/zbud.c                     |    3 ++-
 mm/zpool.c                    |    6 ++++--
 mm/zsmalloc.c                 |    6 +++---
 mm/zswap.c                    |    5 +++--
 7 files changed, 21 insertions(+), 14 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~mm-zpool-add-name-argument-to-create-zpool drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~mm-zpool-add-name-argument-to-create-zpool
+++ a/drivers/block/zram/zram_drv.c
@@ -327,9 +327,10 @@ static void zram_meta_free(struct zram_m
 	kfree(meta);
 }
 
-static struct zram_meta *zram_meta_alloc(u64 disksize)
+static struct zram_meta *zram_meta_alloc(int device_id, u64 disksize)
 {
 	size_t num_pages;
+	char pool_name[8];
 	struct zram_meta *meta = kmalloc(sizeof(*meta), GFP_KERNEL);
 
 	if (!meta)
@@ -342,7 +343,8 @@ static struct zram_meta *zram_meta_alloc
 		goto out_error;
 	}
 
-	meta->mem_pool = zs_create_pool(GFP_NOIO | __GFP_HIGHMEM);
+	snprintf(pool_name, sizeof(pool_name), "zram%d", device_id);
+	meta->mem_pool = zs_create_pool(pool_name, GFP_NOIO | __GFP_HIGHMEM);
 	if (!meta->mem_pool) {
 		pr_err("Error creating memory pool\n");
 		goto out_error;
@@ -783,7 +785,7 @@ static ssize_t disksize_store(struct dev
 		return -EINVAL;
 
 	disksize = PAGE_ALIGN(disksize);
-	meta = zram_meta_alloc(disksize);
+	meta = zram_meta_alloc(zram->disk->first_minor, disksize);
 	if (!meta)
 		return -ENOMEM;
 
diff -puN include/linux/zpool.h~mm-zpool-add-name-argument-to-create-zpool include/linux/zpool.h
--- a/include/linux/zpool.h~mm-zpool-add-name-argument-to-create-zpool
+++ a/include/linux/zpool.h
@@ -36,7 +36,8 @@ enum zpool_mapmode {
 	ZPOOL_MM_DEFAULT = ZPOOL_MM_RW
 };
 
-struct zpool *zpool_create_pool(char *type, gfp_t gfp, struct zpool_ops *ops);
+struct zpool *zpool_create_pool(char *type, char *name,
+			gfp_t gfp, struct zpool_ops *ops);
 
 char *zpool_get_type(struct zpool *pool);
 
@@ -80,7 +81,7 @@ struct zpool_driver {
 	atomic_t refcount;
 	struct list_head list;
 
-	void *(*create)(gfp_t gfp, struct zpool_ops *ops);
+	void *(*create)(char *name, gfp_t gfp, struct zpool_ops *ops);
 	void (*destroy)(void *pool);
 
 	int (*malloc)(void *pool, size_t size, gfp_t gfp,
diff -puN include/linux/zsmalloc.h~mm-zpool-add-name-argument-to-create-zpool include/linux/zsmalloc.h
--- a/include/linux/zsmalloc.h~mm-zpool-add-name-argument-to-create-zpool
+++ a/include/linux/zsmalloc.h
@@ -36,7 +36,7 @@ enum zs_mapmode {
 
 struct zs_pool;
 
-struct zs_pool *zs_create_pool(gfp_t flags);
+struct zs_pool *zs_create_pool(char *name, gfp_t flags);
 void zs_destroy_pool(struct zs_pool *pool);
 
 unsigned long zs_malloc(struct zs_pool *pool, size_t size);
diff -puN mm/zbud.c~mm-zpool-add-name-argument-to-create-zpool mm/zbud.c
--- a/mm/zbud.c~mm-zpool-add-name-argument-to-create-zpool
+++ a/mm/zbud.c
@@ -130,7 +130,8 @@ static struct zbud_ops zbud_zpool_ops =
 	.evict =	zbud_zpool_evict
 };
 
-static void *zbud_zpool_create(gfp_t gfp, struct zpool_ops *zpool_ops)
+static void *zbud_zpool_create(char *name, gfp_t gfp,
+			struct zpool_ops *zpool_ops)
 {
 	return zbud_create_pool(gfp, zpool_ops ? &zbud_zpool_ops : NULL);
 }
diff -puN mm/zpool.c~mm-zpool-add-name-argument-to-create-zpool mm/zpool.c
--- a/mm/zpool.c~mm-zpool-add-name-argument-to-create-zpool
+++ a/mm/zpool.c
@@ -129,6 +129,7 @@ static void zpool_put_driver(struct zpoo
 /**
  * zpool_create_pool() - Create a new zpool
  * @type	The type of the zpool to create (e.g. zbud, zsmalloc)
+ * @name	The name of the zpool (e.g. zram0, zswap)
  * @gfp		The GFP flags to use when allocating the pool.
  * @ops		The optional ops callback.
  *
@@ -140,7 +141,8 @@ static void zpool_put_driver(struct zpoo
  *
  * Returns: New zpool on success, NULL on failure.
  */
-struct zpool *zpool_create_pool(char *type, gfp_t gfp, struct zpool_ops *ops)
+struct zpool *zpool_create_pool(char *type, char *name, gfp_t gfp,
+		struct zpool_ops *ops)
 {
 	struct zpool_driver *driver;
 	struct zpool *zpool;
@@ -168,7 +170,7 @@ struct zpool *zpool_create_pool(char *ty
 
 	zpool->type = driver->type;
 	zpool->driver = driver;
-	zpool->pool = driver->create(gfp, ops);
+	zpool->pool = driver->create(name, gfp, ops);
 	zpool->ops = ops;
 
 	if (!zpool->pool) {
diff -puN mm/zsmalloc.c~mm-zpool-add-name-argument-to-create-zpool mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zpool-add-name-argument-to-create-zpool
+++ a/mm/zsmalloc.c
@@ -246,9 +246,9 @@ struct mapping_area {
 
 #ifdef CONFIG_ZPOOL
 
-static void *zs_zpool_create(gfp_t gfp, struct zpool_ops *zpool_ops)
+static void *zs_zpool_create(char *name, gfp_t gfp, struct zpool_ops *zpool_ops)
 {
-	return zs_create_pool(gfp);
+	return zs_create_pool(name, gfp);
 }
 
 static void zs_zpool_destroy(void *pool)
@@ -1148,7 +1148,7 @@ EXPORT_SYMBOL_GPL(zs_free);
  * On success, a pointer to the newly created pool is returned,
  * otherwise NULL.
  */
-struct zs_pool *zs_create_pool(gfp_t flags)
+struct zs_pool *zs_create_pool(char *name, gfp_t flags)
 {
 	int i;
 	struct zs_pool *pool;
diff -puN mm/zswap.c~mm-zpool-add-name-argument-to-create-zpool mm/zswap.c
--- a/mm/zswap.c~mm-zpool-add-name-argument-to-create-zpool
+++ a/mm/zswap.c
@@ -906,11 +906,12 @@ static int __init init_zswap(void)
 
 	pr_info("loading zswap\n");
 
-	zswap_pool = zpool_create_pool(zswap_zpool_type, gfp, &zswap_zpool_ops);
+	zswap_pool = zpool_create_pool(zswap_zpool_type, "zswap", gfp,
+					&zswap_zpool_ops);
 	if (!zswap_pool && strcmp(zswap_zpool_type, ZSWAP_ZPOOL_DEFAULT)) {
 		pr_info("%s zpool not available\n", zswap_zpool_type);
 		zswap_zpool_type = ZSWAP_ZPOOL_DEFAULT;
-		zswap_pool = zpool_create_pool(zswap_zpool_type, gfp,
+		zswap_pool = zpool_create_pool(zswap_zpool_type, "zswap", gfp,
 					&zswap_zpool_ops);
 	}
 	if (!zswap_pool) {
_

Patches currently in -mm which might be from opensource.ganesh@gmail.com are

origin.patch

