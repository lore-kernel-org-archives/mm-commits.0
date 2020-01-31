From: akpm@linux-foundation.org
Subject: [merged]
 zswap-add-allocation-hysteresis-if-pool-limit-is-hit.patch removed from -mm
 tree
Date: Fri, 31 Jan 2020 15:19:22 -0800
Message-ID: <20200131231922.x_4S5wua0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgAaXTX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:19:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, mm-commits@vger.kernel.org, vitaly.wool@konsulko.com


The patch titled
     Subject: mm/zswap.c: add allocation hysteresis if pool limit is hit
has been removed from the -mm tree.  Its filename was
     zswap-add-allocation-hysteresis-if-pool-limit-is-hit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vitaly Wool <vitaly.wool@konsulko.com>
Subject: mm/zswap.c: add allocation hysteresis if pool limit is hit

zswap will always try to shrink pool when zswap is full.  If there is a
high pressure on zswap it will result in flipping pages in and out zswap
pool without any real benefit, and the overall system performance will
drop.  The previous discussion on this subject [1] ended up with a
suggestion to implement a sort of hysteresis to refuse taking pages into
zswap pool until it has sufficient space if the limit has been hit.  This
is my take on this.

Hysteresis is controlled with a sysfs-configurable parameter (namely,
/sys/kernel/debug/zswap/accept_threhsold_percent).  It specifies the
threshold at which zswap would start accepting pages again after it became
full.  Setting this parameter to 100 disables the hysteresis and sets the
zswap behavior to pre-hysteresis state.

[1] https://lkml.org/lkml/2019/11/8/949

Link: http://lkml.kernel.org/r/20200108200118.15563-1-vitaly.wool@konsulko.com
Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/zswap.rst |   13 +++++
 mm/zswap.c                 |   85 ++++++++++++++++++++++-------------
 2 files changed, 67 insertions(+), 31 deletions(-)

--- a/Documentation/vm/zswap.rst~zswap-add-allocation-hysteresis-if-pool-limit-is-hit
+++ a/Documentation/vm/zswap.rst
@@ -130,6 +130,19 @@ checking for the same-value filled pages
 existing pages which are marked as same-value filled pages remain stored
 unchanged in zswap until they are either loaded or invalidated.
 
+To prevent zswap from shrinking pool when zswap is full and there's a high
+pressure on swap (this will result in flipping pages in and out zswap pool
+without any real benefit but with a performance drop for the system), a
+special parameter has been introduced to implement a sort of hysteresis to
+refuse taking pages into zswap pool until it has sufficient space if the limit
+has been hit. To set the threshold at which zswap would start accepting pages
+again after it became full, use the sysfs ``accept_threhsold_percent``
+attribute, e. g.::
+
+	echo 80 > /sys/module/zswap/parameters/accept_threhsold_percent
+
+Setting this parameter to 100 will disable the hysteresis.
+
 A debugfs interface is provided for various statistic about pool size, number
 of pages stored, same-value filled pages and various counters for the reasons
 pages are rejected.
--- a/mm/zswap.c~zswap-add-allocation-hysteresis-if-pool-limit-is-hit
+++ a/mm/zswap.c
@@ -32,6 +32,7 @@
 #include <linux/swapops.h>
 #include <linux/writeback.h>
 #include <linux/pagemap.h>
+#include <linux/workqueue.h>
 
 /*********************************
 * statistics
@@ -65,6 +66,11 @@ static u64 zswap_reject_kmemcache_fail;
 /* Duplicate store was encountered (rare) */
 static u64 zswap_duplicate_entry;
 
+/* Shrinker work queue */
+static struct workqueue_struct *shrink_wq;
+/* Pool limit was hit, we need to calm down */
+static bool zswap_pool_reached_full;
+
 /*********************************
 * tunables
 **********************************/
@@ -109,6 +115,11 @@ module_param_cb(zpool, &zswap_zpool_para
 static unsigned int zswap_max_pool_percent = 20;
 module_param_named(max_pool_percent, zswap_max_pool_percent, uint, 0644);
 
+/* The threshold for accepting new pages after the max_pool_percent was hit */
+static unsigned int zswap_accept_thr_percent = 90; /* of max pool size */
+module_param_named(accept_threshold_percent, zswap_accept_thr_percent,
+		   uint, 0644);
+
 /* Enable/disable handling same-value filled pages (enabled by default) */
 static bool zswap_same_filled_pages_enabled = true;
 module_param_named(same_filled_pages_enabled, zswap_same_filled_pages_enabled,
@@ -123,7 +134,8 @@ struct zswap_pool {
 	struct crypto_comp * __percpu *tfm;
 	struct kref kref;
 	struct list_head list;
-	struct work_struct work;
+	struct work_struct release_work;
+	struct work_struct shrink_work;
 	struct hlist_node node;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
 };
@@ -214,6 +226,13 @@ static bool zswap_is_full(void)
 			DIV_ROUND_UP(zswap_pool_total_size, PAGE_SIZE);
 }
 
+static bool zswap_can_accept(void)
+{
+	return totalram_pages() * zswap_accept_thr_percent / 100 *
+				zswap_max_pool_percent / 100 >
+			DIV_ROUND_UP(zswap_pool_total_size, PAGE_SIZE);
+}
+
 static void zswap_update_total_size(void)
 {
 	struct zswap_pool *pool;
@@ -501,6 +520,16 @@ static struct zswap_pool *zswap_pool_fin
 	return NULL;
 }
 
+static void shrink_worker(struct work_struct *w)
+{
+	struct zswap_pool *pool = container_of(w, typeof(*pool),
+						shrink_work);
+
+	if (zpool_shrink(pool->zpool, 1, NULL))
+		zswap_reject_reclaim_fail++;
+	zswap_pool_put(pool);
+}
+
 static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 {
 	struct zswap_pool *pool;
@@ -551,6 +580,7 @@ static struct zswap_pool *zswap_pool_cre
 	 */
 	kref_init(&pool->kref);
 	INIT_LIST_HEAD(&pool->list);
+	INIT_WORK(&pool->shrink_work, shrink_worker);
 
 	zswap_pool_debug("created", pool);
 
@@ -624,7 +654,8 @@ static int __must_check zswap_pool_get(s
 
 static void __zswap_pool_release(struct work_struct *work)
 {
-	struct zswap_pool *pool = container_of(work, typeof(*pool), work);
+	struct zswap_pool *pool = container_of(work, typeof(*pool),
+						release_work);
 
 	synchronize_rcu();
 
@@ -647,8 +678,8 @@ static void __zswap_pool_empty(struct kr
 
 	list_del_rcu(&pool->list);
 
-	INIT_WORK(&pool->work, __zswap_pool_release);
-	schedule_work(&pool->work);
+	INIT_WORK(&pool->release_work, __zswap_pool_release);
+	schedule_work(&pool->release_work);
 
 	spin_unlock(&zswap_pools_lock);
 }
@@ -942,22 +973,6 @@ end:
 	return ret;
 }
 
-static int zswap_shrink(void)
-{
-	struct zswap_pool *pool;
-	int ret;
-
-	pool = zswap_pool_last_get();
-	if (!pool)
-		return -ENOENT;
-
-	ret = zpool_shrink(pool->zpool, 1, NULL);
-
-	zswap_pool_put(pool);
-
-	return ret;
-}
-
 static int zswap_is_page_same_filled(void *ptr, unsigned long *value)
 {
 	unsigned int pos;
@@ -1011,21 +1026,23 @@ static int zswap_frontswap_store(unsigne
 
 	/* reclaim space if needed */
 	if (zswap_is_full()) {
+		struct zswap_pool *pool;
+
 		zswap_pool_limit_hit++;
-		if (zswap_shrink()) {
-			zswap_reject_reclaim_fail++;
-			ret = -ENOMEM;
-			goto reject;
-		}
+		zswap_pool_reached_full = true;
+		pool = zswap_pool_last_get();
+		if (pool)
+			queue_work(shrink_wq, &pool->shrink_work);
+		ret = -ENOMEM;
+		goto reject;
+	}
 
-		/* A second zswap_is_full() check after
-		 * zswap_shrink() to make sure it's now
-		 * under the max_pool_percent
-		 */
-		if (zswap_is_full()) {
+	if (zswap_pool_reached_full) {
+	       if (!zswap_can_accept()) {
 			ret = -ENOMEM;
 			goto reject;
-		}
+		} else
+			zswap_pool_reached_full = false;
 	}
 
 	/* allocate entry */
@@ -1332,11 +1349,17 @@ static int __init init_zswap(void)
 		zswap_enabled = false;
 	}
 
+	shrink_wq = create_workqueue("zswap-shrink");
+	if (!shrink_wq)
+		goto fallback_fail;
+
 	frontswap_register_ops(&zswap_frontswap_ops);
 	if (zswap_debugfs_init())
 		pr_warn("debugfs initialization failed\n");
 	return 0;
 
+fallback_fail:
+	zswap_pool_destroy(pool);
 hp_fail:
 	cpuhp_remove_state(CPUHP_MM_ZSWP_MEM_PREPARE);
 dstmem_fail:
_

Patches currently in -mm which might be from vitaly.wool@konsulko.com are
