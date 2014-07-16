From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch removed from
 -mm tree
Date: Wed, 16 Jul 2014 14:50:45 -0700
Message-ID: <53c6f3b5.D6JGSUJDaVzWOnJB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:47226 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbaGPVuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jul 2014 17:50:46 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so217145qaq.3
        for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2014 14:50:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, bob.liu@oracle.com, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, minchan@kernel.org, ngupta@vflare.org, riel@redhat.com, sergey.senozhatsky@gmail.com, sjennings@variantweb.net, weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zpool: prevent zbud/zsmalloc from unloading when used
has been removed from the -mm tree.  Its filename was
     mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: mm/zpool: prevent zbud/zsmalloc from unloading when used

Add try_module_get() to zpool_create_pool(), and module_put() to
zpool_destroy_pool().  Without module usage counting, the driver module(s)
could be unloaded while their pool(s) were active, resulting in an oops
when zpool tried to access them.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Weijie Yang <weijie.yang@samsung.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zpool.h |    5 +++++
 mm/zbud.c             |    1 +
 mm/zpool.c            |   22 +++++++++++++++-------
 mm/zsmalloc.c         |    1 +
 4 files changed, 22 insertions(+), 7 deletions(-)

diff -puN include/linux/zpool.h~mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used include/linux/zpool.h
--- a/include/linux/zpool.h~mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used
+++ a/include/linux/zpool.h
@@ -176,6 +176,7 @@ u64 zpool_get_total_size(struct zpool *p
  */
 struct zpool_driver {
 	char *type;
+	struct module *owner;
 	struct list_head list;
 
 	void *(*create)(gfp_t gfp, struct zpool_ops *ops);
@@ -203,6 +204,10 @@ void zpool_register_driver(struct zpool_
 /**
  * zpool_unregister_driver() - unregister a zpool implementation.
  * @driver:	driver to unregister.
+ *
+ * Module usage counting is used to prevent using a driver
+ * while/after unloading.  Please only call unregister from
+ * module exit function.
  */
 void zpool_unregister_driver(struct zpool_driver *driver);
 
diff -puN mm/zbud.c~mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used mm/zbud.c
--- a/mm/zbud.c~mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used
+++ a/mm/zbud.c
@@ -184,6 +184,7 @@ static u64 zbud_zpool_total_size(void *p
 
 static struct zpool_driver zbud_zpool_driver = {
 	.type =		"zbud",
+	.owner =	THIS_MODULE,
 	.create =	zbud_zpool_create,
 	.destroy =	zbud_zpool_destroy,
 	.malloc =	zbud_zpool_malloc,
diff -puN mm/zpool.c~mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used mm/zpool.c
--- a/mm/zpool.c~mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used
+++ a/mm/zpool.c
@@ -72,15 +72,24 @@ static struct zpool_driver *zpool_get_dr
 {
 	struct zpool_driver *driver;
 
-	assert_spin_locked(&drivers_lock);
+	spin_lock(&drivers_lock);
 	list_for_each_entry(driver, &drivers_head, list) {
-		if (!strcmp(driver->type, type))
-			return driver;
+		if (!strcmp(driver->type, type)) {
+			bool got = try_module_get(driver->owner);
+			spin_unlock(&drivers_lock);
+			return got ? driver : NULL;
+		}
 	}
 
+	spin_unlock(&drivers_lock);
 	return NULL;
 }
 
+static void zpool_put_driver(struct zpool_driver *driver)
+{
+	module_put(driver->owner);
+}
+
 struct zpool *zpool_create_pool(char *type, gfp_t flags,
 			struct zpool_ops *ops)
 {
@@ -89,15 +98,11 @@ struct zpool *zpool_create_pool(char *ty
 
 	pr_info("creating pool type %s\n", type);
 
-	spin_lock(&drivers_lock);
 	driver = zpool_get_driver(type);
-	spin_unlock(&drivers_lock);
 
 	if (!driver) {
 		request_module(type);
-		spin_lock(&drivers_lock);
 		driver = zpool_get_driver(type);
-		spin_unlock(&drivers_lock);
 	}
 
 	if (!driver) {
@@ -108,6 +113,7 @@ struct zpool *zpool_create_pool(char *ty
 	zpool = kmalloc(sizeof(*zpool), GFP_KERNEL);
 	if (!zpool) {
 		pr_err("couldn't create zpool - out of memory\n");
+		zpool_put_driver(driver);
 		return NULL;
 	}
 
@@ -118,6 +124,7 @@ struct zpool *zpool_create_pool(char *ty
 
 	if (!zpool->pool) {
 		pr_err("couldn't create %s pool\n", type);
+		zpool_put_driver(driver);
 		kfree(zpool);
 		return NULL;
 	}
@@ -139,6 +146,7 @@ void zpool_destroy_pool(struct zpool *zp
 	list_del(&zpool->list);
 	spin_unlock(&pools_lock);
 	zpool->driver->destroy(zpool->pool);
+	zpool_put_driver(zpool->driver);
 	kfree(zpool);
 }
 
diff -puN mm/zsmalloc.c~mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used
+++ a/mm/zsmalloc.c
@@ -303,6 +303,7 @@ u64 zs_zpool_total_size(void *pool)
 
 static struct zpool_driver zs_zpool_driver = {
 	.type =		"zsmalloc",
+	.owner =	THIS_MODULE,
 	.create =	zs_zpool_create,
 	.destroy =	zs_zpool_destroy,
 	.malloc =	zs_zpool_malloc,
_

Patches currently in -mm which might be from ddstreet@ieee.org are

mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes.patch

