From: akpm@linux-foundation.org
Subject: [merged]
 zpool-remove-redundant-zpool-type-string-const-ify-zpool_get_type.patch
 removed from -mm tree
Date: Mon, 09 Nov 2015 11:45:02 -0800
Message-ID: <5640f7be.7ZSTHsWHgDBoVVzx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57163 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbbKITpC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:45:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zpool: remove redundant zpool->type string, const-ify zpool_get_type
has been removed from the -mm tree.  Its filename was
     zpool-remove-redundant-zpool-type-string-const-ify-zpool_get_type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: zpool: remove redundant zpool->type string, const-ify zpool_get_type

Make the return type of zpool_get_type const; the string belongs to the
zpool driver and should not be modified.  Remove the redundant type field
in the struct zpool; it is private to zpool.c and isn't needed since
->driver->type can be used directly.  Add comments indicating strings must
be null-terminated.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zpool.h |    2 +-
 mm/zpool.c            |   14 ++++++++------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN include/linux/zpool.h~zpool-remove-redundant-zpool-type-string-const-ify-zpool_get_type include/linux/zpool.h
--- a/include/linux/zpool.h~zpool-remove-redundant-zpool-type-string-const-ify-zpool_get_type
+++ a/include/linux/zpool.h
@@ -41,7 +41,7 @@ bool zpool_has_pool(char *type);
 struct zpool *zpool_create_pool(char *type, char *name,
 			gfp_t gfp, const struct zpool_ops *ops);
 
-char *zpool_get_type(struct zpool *pool);
+const char *zpool_get_type(struct zpool *pool);
 
 void zpool_destroy_pool(struct zpool *pool);
 
diff -puN mm/zpool.c~zpool-remove-redundant-zpool-type-string-const-ify-zpool_get_type mm/zpool.c
--- a/mm/zpool.c~zpool-remove-redundant-zpool-type-string-const-ify-zpool_get_type
+++ a/mm/zpool.c
@@ -18,8 +18,6 @@
 #include <linux/zpool.h>
 
 struct zpool {
-	char *type;
-
 	struct zpool_driver *driver;
 	void *pool;
 	const struct zpool_ops *ops;
@@ -73,6 +71,7 @@ int zpool_unregister_driver(struct zpool
 }
 EXPORT_SYMBOL(zpool_unregister_driver);
 
+/* this assumes @type is null-terminated. */
 static struct zpool_driver *zpool_get_driver(char *type)
 {
 	struct zpool_driver *driver;
@@ -113,6 +112,8 @@ static void zpool_put_driver(struct zpoo
  * not be loaded, and calling @zpool_create_pool() with the pool type will
  * fail.
  *
+ * The @type string must be null-terminated.
+ *
  * Returns: true if @type pool is available, false if not
  */
 bool zpool_has_pool(char *type)
@@ -145,6 +146,8 @@ EXPORT_SYMBOL(zpool_has_pool);
  *
  * Implementations must guarantee this to be thread-safe.
  *
+ * The @type and @name strings must be null-terminated.
+ *
  * Returns: New zpool on success, NULL on failure.
  */
 struct zpool *zpool_create_pool(char *type, char *name, gfp_t gfp,
@@ -174,7 +177,6 @@ struct zpool *zpool_create_pool(char *ty
 		return NULL;
 	}
 
-	zpool->type = driver->type;
 	zpool->driver = driver;
 	zpool->pool = driver->create(name, gfp, ops, zpool);
 	zpool->ops = ops;
@@ -208,7 +210,7 @@ struct zpool *zpool_create_pool(char *ty
  */
 void zpool_destroy_pool(struct zpool *zpool)
 {
-	pr_debug("destroying pool type %s\n", zpool->type);
+	pr_debug("destroying pool type %s\n", zpool->driver->type);
 
 	spin_lock(&pools_lock);
 	list_del(&zpool->list);
@@ -228,9 +230,9 @@ void zpool_destroy_pool(struct zpool *zp
  *
  * Returns: The type of zpool.
  */
-char *zpool_get_type(struct zpool *zpool)
+const char *zpool_get_type(struct zpool *zpool)
 {
-	return zpool->type;
+	return zpool->driver->type;
 }
 
 /**
_

Patches currently in -mm which might be from ddstreet@ieee.org are


