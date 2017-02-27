From: akpm@linux-foundation.org
Subject: [patch 02/78] zswap: allow initialization at boot without pool
Date: Mon, 27 Feb 2017 14:26:47 -0800
Message-ID: <58b4a7a7.+/ZQf7y66WaVpXd/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44600 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751510AbdB0W2J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:28:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ddstreet@ieee.org, dan.streetman@canonical.com, mhocko@kernel.org, minchan@kernel.org, sergey.senozhatsky.work@gmail.com, sjenning@redhat.com

From: Dan Streetman <ddstreet@ieee.org>
Subject: zswap: allow initialization at boot without pool

Allow zswap to initialize at boot even if it can't create its pool
due to a failure to create a zpool and/or compressor.  Allow those
to be created later, from the sysfs module param interface.

Link: http://lkml.kernel.org/r/20170124200259.16191-3-ddstreet@ieee.org
Signed-off-by: Dan Streetman <dan.streetman@canonical.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   46 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff -puN mm/zswap.c~zswap-allow-initialization-at-boot-without-pool mm/zswap.c
--- a/mm/zswap.c~zswap-allow-initialization-at-boot-without-pool
+++ a/mm/zswap.c
@@ -185,6 +185,9 @@ static bool zswap_init_started;
 /* fatal error during init */
 static bool zswap_init_failed;
 
+/* init completed, but couldn't create the initial pool */
+static bool zswap_has_pool;
+
 /*********************************
 * helpers and fwd declarations
 **********************************/
@@ -424,7 +427,8 @@ static struct zswap_pool *__zswap_pool_c
 	struct zswap_pool *pool;
 
 	pool = list_first_or_null_rcu(&zswap_pools, typeof(*pool), list);
-	WARN_ON(!pool);
+	WARN_ONCE(!pool && zswap_has_pool,
+		  "%s: no page storage pool!\n", __func__);
 
 	return pool;
 }
@@ -443,7 +447,7 @@ static struct zswap_pool *zswap_pool_cur
 	rcu_read_lock();
 
 	pool = __zswap_pool_current();
-	if (!pool || !zswap_pool_get(pool))
+	if (!zswap_pool_get(pool))
 		pool = NULL;
 
 	rcu_read_unlock();
@@ -459,7 +463,9 @@ static struct zswap_pool *zswap_pool_las
 
 	list_for_each_entry_rcu(pool, &zswap_pools, list)
 		last = pool;
-	if (!WARN_ON(!last) && !zswap_pool_get(last))
+	WARN_ONCE(!last && zswap_has_pool,
+		  "%s: no page storage pool!\n", __func__);
+	if (!zswap_pool_get(last))
 		last = NULL;
 
 	rcu_read_unlock();
@@ -582,6 +588,9 @@ static void zswap_pool_destroy(struct zs
 
 static int __must_check zswap_pool_get(struct zswap_pool *pool)
 {
+	if (!pool)
+		return 0;
+
 	return kref_get_unless_zero(&pool->kref);
 }
 
@@ -639,7 +648,7 @@ static int __zswap_param_set(const char
 	}
 
 	/* no change required */
-	if (!strcmp(s, *(char **)kp->arg))
+	if (!strcmp(s, *(char **)kp->arg) && zswap_has_pool)
 		return 0;
 
 	/* if this is load-time (pre-init) param setting,
@@ -685,6 +694,7 @@ static int __zswap_param_set(const char
 	if (!ret) {
 		put_pool = zswap_pool_current();
 		list_add_rcu(&pool->list, &zswap_pools);
+		zswap_has_pool = true;
 	} else if (pool) {
 		/* add the possibly pre-existing pool to the end of the pools
 		 * list; if it's new (and empty) then it'll be removed and
@@ -692,6 +702,15 @@ static int __zswap_param_set(const char
 		 */
 		list_add_tail_rcu(&pool->list, &zswap_pools);
 		put_pool = pool;
+	} else if (!zswap_has_pool) {
+		/* if initial pool creation failed, and this pool creation also
+		 * failed, maybe both compressor and zpool params were bad.
+		 * Allow changing this param, so pool creation will succeed
+		 * when the other param is changed. We already verified this
+		 * param is ok in the zpool_has_pool() or crypto_has_comp()
+		 * checks above.
+		 */
+		ret = param_set_charp(s, kp);
 	}
 
 	spin_unlock(&zswap_pools_lock);
@@ -724,6 +743,10 @@ static int zswap_enabled_param_set(const
 		pr_err("can't enable, initialization failed\n");
 		return -ENODEV;
 	}
+	if (!zswap_has_pool && zswap_init_started) {
+		pr_err("can't enable, no pool configured\n");
+		return -ENODEV;
+	}
 
 	return param_set_bool(val, kp);
 }
@@ -1205,22 +1228,21 @@ static int __init init_zswap(void)
 		goto hp_fail;
 
 	pool = __zswap_pool_create_fallback();
-	if (!pool) {
+	if (pool) {
+		pr_info("loaded using pool %s/%s\n", pool->tfm_name,
+			zpool_get_type(pool->zpool));
+		list_add(&pool->list, &zswap_pools);
+		zswap_has_pool = true;
+	} else {
 		pr_err("pool creation failed\n");
-		goto pool_fail;
+		zswap_enabled = false;
 	}
-	pr_info("loaded using pool %s/%s\n", pool->tfm_name,
-		zpool_get_type(pool->zpool));
