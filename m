From: akpm@linux-foundation.org
Subject: + zswap-change-zpool-compressor-at-runtime.patch added to -mm
 tree
Date: Wed, 05 Aug 2015 13:14:36 -0700
Message-ID: <55c26eac.HpCcIWe+mvofbNSO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbbHEUOh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2015 16:14:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: change zpool/compressor at runtime
has been added to the -mm tree.  Its filename is
     zswap-change-zpool-compressor-at-runtime.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zswap-change-zpool-compressor-at-runtime.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zswap-change-zpool-compressor-at-runtime.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: zswap: change zpool/compressor at runtime

Update the zpool and compressor parameters to be changeable at runtime. 
When changed, a new pool is created with the requested zpool/compressor,
and added as the current pool at the front of the pool list.  Previous
pools remain in the list only to remove existing compressed pages from. 
The old pool(s) are removed once they become empty.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |  135 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 122 insertions(+), 13 deletions(-)

diff -puN mm/zswap.c~zswap-change-zpool-compressor-at-runtime mm/zswap.c
--- a/mm/zswap.c~zswap-change-zpool-compressor-at-runtime
+++ a/mm/zswap.c
@@ -80,23 +80,39 @@ static u64 zswap_duplicate_entry;
 static bool zswap_enabled;
 module_param_named(enabled, zswap_enabled, bool, 0644);
 
-/* Compressor to be used by zswap (fixed at boot for now) */
+/* Crypto compressor to use */
 #define ZSWAP_COMPRESSOR_DEFAULT "lzo"
-static char *zswap_compressor = ZSWAP_COMPRESSOR_DEFAULT;
-module_param_named(compressor, zswap_compressor, charp, 0444);
-
-/* The maximum percentage of memory that the compressed pool can occupy */
-static unsigned int zswap_max_pool_percent = 20;
-module_param_named(max_pool_percent,
-			zswap_max_pool_percent, uint, 0644);
+static char zswap_compressor[CRYPTO_MAX_ALG_NAME] = ZSWAP_COMPRESSOR_DEFAULT;
+static struct kparam_string zswap_compressor_kparam = {
+	.string =	zswap_compressor,
+	.maxlen =	sizeof(zswap_compressor),
+};
+static int zswap_compressor_param_set(const char *,
+				      const struct kernel_param *);
+static struct kernel_param_ops zswap_compressor_param_ops = {
+	.set =		zswap_compressor_param_set,
+	.get =		param_get_string,
+};
+module_param_cb(compressor, &zswap_compressor_param_ops,
+		&zswap_compressor_kparam, 0644);
 
-/* Compressed storage to use */
+/* Compressed storage zpool to use */
 #define ZSWAP_ZPOOL_DEFAULT "zbud"
-static char *zswap_zpool_type = ZSWAP_ZPOOL_DEFAULT;
-module_param_named(zpool, zswap_zpool_type, charp, 0444);
+static char zswap_zpool_type[32 /* arbitrary */] = ZSWAP_ZPOOL_DEFAULT;
+static struct kparam_string zswap_zpool_kparam = {
+	.string =	zswap_zpool_type,
+	.maxlen =	sizeof(zswap_zpool_type),
+};
+static int zswap_zpool_param_set(const char *, const struct kernel_param *);
+static struct kernel_param_ops zswap_zpool_param_ops = {
+	.set =	zswap_zpool_param_set,
+	.get =	param_get_string,
+};
+module_param_cb(zpool, &zswap_zpool_param_ops, &zswap_zpool_kparam, 0644);
 
-/* zpool is shared by all of zswap backend  */
-static struct zpool *zswap_pool;
+/* The maximum percentage of memory that the compressed pool can occupy */
+static unsigned int zswap_max_pool_percent = 20;
+module_param_named(max_pool_percent, zswap_max_pool_percent, uint, 0644);
 
 /*********************************
 * data structures
@@ -161,6 +177,9 @@ static LIST_HEAD(zswap_pools);
 /* protects zswap_pools list modification */
 static DEFINE_SPINLOCK(zswap_pools_lock);
 
+/* used by param callback function */
+static bool zswap_init_started;
+
 /*********************************
 * helpers and fwd declarations
 **********************************/
@@ -657,6 +676,94 @@ static void zswap_pool_put(struct zswap_
 	kref_put(&pool->kref, __zswap_pool_empty);
 }
 
+/*********************************
+* param callbacks
+**********************************/
+
+static int __zswap_param_set(const char *val, const struct kernel_param *kp,
+			     char *type, char *compressor)
+{
+	struct zswap_pool *pool, *put_pool = NULL;
+	char str[kp->str->maxlen], *s;
+	int ret;
+
+	strlcpy(str, val, kp->str->maxlen);
+	s = strim(str);
+
+	/* if this is load-time (pre-init) param setting,
+	 * don't create a pool; that's done during init.
+	 */
+	if (!zswap_init_started)
+		return param_set_copystring(s, kp);
+
+	/* no change required */
+	if (!strncmp(kp->str->string, s, kp->str->maxlen))
+		return 0;
+
+	if (!type) {
+		type = s;
+		if (!zpool_has_pool(type)) {
+			pr_err("zpool %s not available\n", type);
+			return -ENOENT;
+		}
+	} else if (!compressor) {
+		compressor = s;
+		if (!crypto_has_comp(compressor, 0, 0)) {
+			pr_err("compressor %s not available\n", compressor);
+			return -ENOENT;
+		}
+	}
+
+	spin_lock(&zswap_pools_lock);
+
+	pool = zswap_pool_find_get(type, compressor);
+	if (pool) {
+		zswap_pool_debug("using existing", pool);
+		list_del_rcu(&pool->list);
+	} else {
+		spin_unlock(&zswap_pools_lock);
+		pool = zswap_pool_create(type, compressor);
+		spin_lock(&zswap_pools_lock);
+	}
+
+	if (pool)
+		ret = param_set_copystring(s, kp);
+	else
+		ret = -EINVAL;
+
+	if (!ret) {
+		put_pool = zswap_pool_current();
+		list_add_rcu(&pool->list, &zswap_pools);
+	} else if (pool) {
+		/* add the possibly pre-existing pool to the end of the pools
+		 * list; if it's new (and empty) then it'll be removed and
+		 * destroyed by the put after we drop the lock
+		 */
+		list_add_tail_rcu(&pool->list, &zswap_pools);
+		put_pool = pool;
+	}
+
+	spin_unlock(&zswap_pools_lock);
+
+	/* drop the ref from either the old current pool,
+	 * or the new pool we failed to add
+	 */
+	if (put_pool)
+		zswap_pool_put(put_pool);
+
+	return ret;
+}
+
+static int zswap_compressor_param_set(const char *val,
+				      const struct kernel_param *kp)
+{
+	return __zswap_param_set(val, kp, zswap_zpool_type, NULL);
+}
+
+static int zswap_zpool_param_set(const char *val,
+				 const struct kernel_param *kp)
+{
+	return __zswap_param_set(val, kp, NULL, zswap_compressor);
 }
 
 /*********************************
@@ -1116,6 +1223,8 @@ static int __init init_zswap(void)
 {
 	struct zswap_pool *pool;
 
+	zswap_init_started = true;
+
 	if (zswap_entry_cache_create()) {
 		pr_err("entry cache creation failed\n");
 		goto cache_fail;
_

Patches currently in -mm which might be from ddstreet@ieee.org are

zpool-add-zpool_has_pool.patch
zswap-dynamic-pool-creation.patch
zswap-change-zpool-compressor-at-runtime.patch
mm-zpool-constify-the-zpool_ops.patch
mm-zbud-constify-the-zbud_ops.patch
linux-next.patch

