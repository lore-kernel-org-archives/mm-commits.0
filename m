From: akpm@linux-foundation.org
Subject: [merged] mm-zsmalloc-constify-struct-zs_pool-name.patch removed
 from -mm tree
Date: Mon, 09 Nov 2015 11:45:04 -0800
Message-ID: <5640f7c0.ffjyzX6TsvUISxqE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbbKITpE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:45:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, ddstreet@ieee.org, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zsmalloc: constify struct zs_pool name
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-constify-struct-zs_pool-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey SENOZHATSKY <sergey.senozhatsky@gmail.com>
Subject: mm: zsmalloc: constify struct zs_pool name

Constify `struct zs_pool' ->name.

[akpm@inux-foundation.org: constify zpool_create_pool()'s `type' arg also]
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zpool.h    |    6 ++++--
 include/linux/zsmalloc.h |    2 +-
 mm/zbud.c                |    2 +-
 mm/zpool.c               |    4 ++--
 mm/zsmalloc.c            |   10 +++++-----
 5 files changed, 13 insertions(+), 11 deletions(-)

diff -puN include/linux/zpool.h~mm-zsmalloc-constify-struct-zs_pool-name include/linux/zpool.h
--- a/include/linux/zpool.h~mm-zsmalloc-constify-struct-zs_pool-name
+++ a/include/linux/zpool.h
@@ -38,7 +38,7 @@ enum zpool_mapmode {
 
 bool zpool_has_pool(char *type);
 
-struct zpool *zpool_create_pool(char *type, char *name,
+struct zpool *zpool_create_pool(const char *type, const char *name,
 			gfp_t gfp, const struct zpool_ops *ops);
 
 const char *zpool_get_type(struct zpool *pool);
@@ -83,7 +83,9 @@ struct zpool_driver {
 	atomic_t refcount;
 	struct list_head list;
 
-	void *(*create)(char *name, gfp_t gfp, const struct zpool_ops *ops,
+	void *(*create)(const char *name,
+			gfp_t gfp,
+			const struct zpool_ops *ops,
 			struct zpool *zpool);
 	void (*destroy)(void *pool);
 
diff -puN include/linux/zsmalloc.h~mm-zsmalloc-constify-struct-zs_pool-name include/linux/zsmalloc.h
--- a/include/linux/zsmalloc.h~mm-zsmalloc-constify-struct-zs_pool-name
+++ a/include/linux/zsmalloc.h
@@ -41,7 +41,7 @@ struct zs_pool_stats {
 
 struct zs_pool;
 
-struct zs_pool *zs_create_pool(char *name, gfp_t flags);
+struct zs_pool *zs_create_pool(const char *name, gfp_t flags);
 void zs_destroy_pool(struct zs_pool *pool);
 
 unsigned long zs_malloc(struct zs_pool *pool, size_t size);
diff -puN mm/zbud.c~mm-zsmalloc-constify-struct-zs_pool-name mm/zbud.c
--- a/mm/zbud.c~mm-zsmalloc-constify-struct-zs_pool-name
+++ a/mm/zbud.c
@@ -137,7 +137,7 @@ static const struct zbud_ops zbud_zpool_
 	.evict =	zbud_zpool_evict
 };
 
-static void *zbud_zpool_create(char *name, gfp_t gfp,
+static void *zbud_zpool_create(const char *name, gfp_t gfp,
 			       const struct zpool_ops *zpool_ops,
 			       struct zpool *zpool)
 {
diff -puN mm/zpool.c~mm-zsmalloc-constify-struct-zs_pool-name mm/zpool.c
--- a/mm/zpool.c~mm-zsmalloc-constify-struct-zs_pool-name
+++ a/mm/zpool.c
@@ -72,7 +72,7 @@ int zpool_unregister_driver(struct zpool
 EXPORT_SYMBOL(zpool_unregister_driver);
 
 /* this assumes @type is null-terminated. */
-static struct zpool_driver *zpool_get_driver(char *type)
+static struct zpool_driver *zpool_get_driver(const char *type)
 {
 	struct zpool_driver *driver;
 
@@ -150,7 +150,7 @@ EXPORT_SYMBOL(zpool_has_pool);
  *
  * Returns: New zpool on success, NULL on failure.
  */
-struct zpool *zpool_create_pool(char *type, char *name, gfp_t gfp,
+struct zpool *zpool_create_pool(const char *type, const char *name, gfp_t gfp,
 		const struct zpool_ops *ops)
 {
 	struct zpool_driver *driver;
diff -puN mm/zsmalloc.c~mm-zsmalloc-constify-struct-zs_pool-name mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-constify-struct-zs_pool-name
+++ a/mm/zsmalloc.c
@@ -237,7 +237,7 @@ struct link_free {
 };
 
 struct zs_pool {
-	char *name;
+	const char *name;
 
 	struct size_class **size_class;
 	struct kmem_cache *handle_cachep;
@@ -311,7 +311,7 @@ static void record_obj(unsigned long han
 
 #ifdef CONFIG_ZPOOL
 
-static void *zs_zpool_create(char *name, gfp_t gfp,
+static void *zs_zpool_create(const char *name, gfp_t gfp,
 			     const struct zpool_ops *zpool_ops,
 			     struct zpool *zpool)
 {
@@ -548,7 +548,7 @@ static const struct file_operations zs_s
 	.release        = single_release,
 };
 
-static int zs_pool_stat_create(char *name, struct zs_pool *pool)
+static int zs_pool_stat_create(const char *name, struct zs_pool *pool)
 {
 	struct dentry *entry;
 
@@ -588,7 +588,7 @@ static void __exit zs_stat_exit(void)
 {
 }
 
-static inline int zs_pool_stat_create(char *name, struct zs_pool *pool)
+static inline int zs_pool_stat_create(const char *name, struct zs_pool *pool)
 {
 	return 0;
 }
@@ -1866,7 +1866,7 @@ static int zs_register_shrinker(struct z
  * On success, a pointer to the newly created pool is returned,
  * otherwise NULL.
  */
-struct zs_pool *zs_create_pool(char *name, gfp_t flags)
+struct zs_pool *zs_create_pool(const char *name, gfp_t flags)
 {
 	int i;
 	struct zs_pool *pool;
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are


