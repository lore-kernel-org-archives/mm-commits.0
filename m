Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAB0381B4
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706596938; cv=none; b=RS0zS0U67spPmECiMpQXFFMmHosKUWROqpIr3SFdHnxmj7aQhkLfMxl/3GGypbH/MsP/0Lp8fJ+9XGe5y4NP61LYq2fHNujQYgAPEHPPKR7BZLrBIOVjB3axMMxYoNjdb9VR+SwSiEyjqI6KUJfqwncUXDLQW4YXKklU1Z4iAZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706596938; c=relaxed/simple;
	bh=3YJIWVrnAO9kGwne2wwYKr/dBQxV/lOtsH8MjqphUFE=;
	h=Date:To:From:Subject:Message-Id; b=UIQGAFjmN/nwzb54FyX9GT9EvNnzrh7FHaETNxLggeXZqAFq/6K8DDmF9bUbusU/yNmj4V9fUrzFCBWydXd0SOoEeUi7iYPlciWFFZY5vTUGs0LpNDlUDGVVCDNzi47T6QfPJkVo9WHCwgsLzKzxaVOh2cpxMnzmwY9zWUffuRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ht2+XLu4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ht2+XLu4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA91FC433F1;
	Tue, 30 Jan 2024 06:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706596938;
	bh=3YJIWVrnAO9kGwne2wwYKr/dBQxV/lOtsH8MjqphUFE=;
	h=Date:To:From:Subject:From;
	b=ht2+XLu4s3b5JbjQ/1b8kp+4DwoT96OfQ3PLrHk8E98edfxvHI7ryfDdUX0j2C6Sl
	 QsRjGmHMcUN5b+wNhfrvff6iiR8DGUoHvpz8PhJN6wjZ6f5souimutHjXrN5/vnC+X
	 y9I5JtV/4c4QB97tGZMZ+kcGAg5XgvE65Vuv2uWc=
Date: Mon, 29 Jan 2024 22:42:04 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-function-ordering-pool-params.patch added to mm-unstable branch
Message-Id: <20240130064215.CA91FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: function ordering: pool params
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-function-ordering-pool-params.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-function-ordering-pool-params.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: function ordering: pool params
Date: Mon, 29 Jan 2024 20:36:49 -0500

Patch series "mm: zswap: cleanups".

Cleanups and maintenance items that accumulated while reviewing zswap
patches.


This patch (of 20):

The parameters primarily control pool attributes. Move those
operations up to the pool section.

Link: https://lkml.kernel.org/r/20240130014208.565554-1-hannes@cmpxchg.org
Link: https://lkml.kernel.org/r/20240130014208.565554-14-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |  312 +++++++++++++++++++++++++--------------------------
 1 file changed, 156 insertions(+), 156 deletions(-)

--- a/mm/zswap.c~mm-zswap-function-ordering-pool-params
+++ a/mm/zswap.c
@@ -590,6 +590,162 @@ static struct zswap_pool *zswap_pool_fin
 	return NULL;
 }
 
+/*********************************
+* param callbacks
+**********************************/
+
+static bool zswap_pool_changed(const char *s, const struct kernel_param *kp)
+{
+	/* no change required */
+	if (!strcmp(s, *(char **)kp->arg) && zswap_has_pool)
+		return false;
+	return true;
+}
+
+/* val must be a null-terminated string */
+static int __zswap_param_set(const char *val, const struct kernel_param *kp,
+			     char *type, char *compressor)
+{
+	struct zswap_pool *pool, *put_pool = NULL;
+	char *s = strstrip((char *)val);
+	int ret = 0;
+	bool new_pool = false;
+
+	mutex_lock(&zswap_init_lock);
+	switch (zswap_init_state) {
+	case ZSWAP_UNINIT:
+		/* if this is load-time (pre-init) param setting,
+		 * don't create a pool; that's done during init.
+		 */
+		ret = param_set_charp(s, kp);
+		break;
+	case ZSWAP_INIT_SUCCEED:
+		new_pool = zswap_pool_changed(s, kp);
+		break;
+	case ZSWAP_INIT_FAILED:
+		pr_err("can't set param, initialization failed\n");
+		ret = -ENODEV;
+	}
+	mutex_unlock(&zswap_init_lock);
+
+	/* no need to create a new pool, return directly */
+	if (!new_pool)
+		return ret;
+
+	if (!type) {
+		if (!zpool_has_pool(s)) {
+			pr_err("zpool %s not available\n", s);
+			return -ENOENT;
+		}
+		type = s;
+	} else if (!compressor) {
+		if (!crypto_has_acomp(s, 0, 0)) {
+			pr_err("compressor %s not available\n", s);
+			return -ENOENT;
+		}
+		compressor = s;
+	} else {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	spin_lock(&zswap_pools_lock);
+
+	pool = zswap_pool_find_get(type, compressor);
+	if (pool) {
+		zswap_pool_debug("using existing", pool);
+		WARN_ON(pool == zswap_pool_current());
+		list_del_rcu(&pool->list);
+	}
+
+	spin_unlock(&zswap_pools_lock);
+
+	if (!pool)
+		pool = zswap_pool_create(type, compressor);
+
+	if (pool)
+		ret = param_set_charp(s, kp);
+	else
+		ret = -EINVAL;
+
+	spin_lock(&zswap_pools_lock);
+
+	if (!ret) {
+		put_pool = zswap_pool_current();
+		list_add_rcu(&pool->list, &zswap_pools);
+		zswap_has_pool = true;
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
+	if (!zswap_has_pool && !pool) {
+		/* if initial pool creation failed, and this pool creation also
+		 * failed, maybe both compressor and zpool params were bad.
+		 * Allow changing this param, so pool creation will succeed
+		 * when the other param is changed. We already verified this
+		 * param is ok in the zpool_has_pool() or crypto_has_acomp()
+		 * checks above.
+		 */
+		ret = param_set_charp(s, kp);
+	}
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
+}
+
+static int zswap_enabled_param_set(const char *val,
+				   const struct kernel_param *kp)
+{
+	int ret = -ENODEV;
+
+	/* if this is load-time (pre-init) param setting, only set param. */
+	if (system_state != SYSTEM_RUNNING)
+		return param_set_bool(val, kp);
+
+	mutex_lock(&zswap_init_lock);
+	switch (zswap_init_state) {
+	case ZSWAP_UNINIT:
+		if (zswap_setup())
+			break;
+		fallthrough;
+	case ZSWAP_INIT_SUCCEED:
+		if (!zswap_has_pool)
+			pr_err("can't enable, no pool configured\n");
+		else
+			ret = param_set_bool(val, kp);
+		break;
+	case ZSWAP_INIT_FAILED:
+		pr_err("can't enable, initialization failed\n");
+	}
+	mutex_unlock(&zswap_init_lock);
+
+	return ret;
+}
+
 /* should be called under RCU */
 #ifdef CONFIG_MEMCG
 static inline struct mem_cgroup *mem_cgroup_from_entry(struct zswap_entry *entry)
@@ -1163,162 +1319,6 @@ resched:
 	zswap_pool_put(pool);
 }
 
-/*********************************
-* param callbacks
-**********************************/
-
-static bool zswap_pool_changed(const char *s, const struct kernel_param *kp)
-{
-	/* no change required */
-	if (!strcmp(s, *(char **)kp->arg) && zswap_has_pool)
-		return false;
-	return true;
-}
-
-/* val must be a null-terminated string */
-static int __zswap_param_set(const char *val, const struct kernel_param *kp,
-			     char *type, char *compressor)
-{
-	struct zswap_pool *pool, *put_pool = NULL;
-	char *s = strstrip((char *)val);
-	int ret = 0;
-	bool new_pool = false;
-
-	mutex_lock(&zswap_init_lock);
-	switch (zswap_init_state) {
-	case ZSWAP_UNINIT:
-		/* if this is load-time (pre-init) param setting,
-		 * don't create a pool; that's done during init.
-		 */
-		ret = param_set_charp(s, kp);
-		break;
-	case ZSWAP_INIT_SUCCEED:
-		new_pool = zswap_pool_changed(s, kp);
-		break;
-	case ZSWAP_INIT_FAILED:
-		pr_err("can't set param, initialization failed\n");
-		ret = -ENODEV;
-	}
-	mutex_unlock(&zswap_init_lock);
-
-	/* no need to create a new pool, return directly */
-	if (!new_pool)
-		return ret;
-
-	if (!type) {
-		if (!zpool_has_pool(s)) {
-			pr_err("zpool %s not available\n", s);
-			return -ENOENT;
-		}
-		type = s;
-	} else if (!compressor) {
-		if (!crypto_has_acomp(s, 0, 0)) {
-			pr_err("compressor %s not available\n", s);
-			return -ENOENT;
-		}
-		compressor = s;
-	} else {
-		WARN_ON(1);
-		return -EINVAL;
-	}
-
-	spin_lock(&zswap_pools_lock);
-
-	pool = zswap_pool_find_get(type, compressor);
-	if (pool) {
-		zswap_pool_debug("using existing", pool);
-		WARN_ON(pool == zswap_pool_current());
-		list_del_rcu(&pool->list);
-	}
-
-	spin_unlock(&zswap_pools_lock);
-
-	if (!pool)
-		pool = zswap_pool_create(type, compressor);
-
-	if (pool)
-		ret = param_set_charp(s, kp);
-	else
-		ret = -EINVAL;
-
-	spin_lock(&zswap_pools_lock);
-
-	if (!ret) {
-		put_pool = zswap_pool_current();
-		list_add_rcu(&pool->list, &zswap_pools);
-		zswap_has_pool = true;
-	} else if (pool) {
-		/* add the possibly pre-existing pool to the end of the pools
-		 * list; if it's new (and empty) then it'll be removed and
-		 * destroyed by the put after we drop the lock
-		 */
-		list_add_tail_rcu(&pool->list, &zswap_pools);
-		put_pool = pool;
-	}
-
-	spin_unlock(&zswap_pools_lock);
-
-	if (!zswap_has_pool && !pool) {
-		/* if initial pool creation failed, and this pool creation also
-		 * failed, maybe both compressor and zpool params were bad.
-		 * Allow changing this param, so pool creation will succeed
-		 * when the other param is changed. We already verified this
-		 * param is ok in the zpool_has_pool() or crypto_has_acomp()
-		 * checks above.
-		 */
-		ret = param_set_charp(s, kp);
-	}
-
-	/* drop the ref from either the old current pool,
-	 * or the new pool we failed to add
-	 */
-	if (put_pool)
-		zswap_pool_put(put_pool);
-
-	return ret;
-}
-
-static int zswap_compressor_param_set(const char *val,
-				      const struct kernel_param *kp)
-{
-	return __zswap_param_set(val, kp, zswap_zpool_type, NULL);
-}
-
-static int zswap_zpool_param_set(const char *val,
-				 const struct kernel_param *kp)
-{
-	return __zswap_param_set(val, kp, NULL, zswap_compressor);
-}
-
-static int zswap_enabled_param_set(const char *val,
-				   const struct kernel_param *kp)
-{
-	int ret = -ENODEV;
-
-	/* if this is load-time (pre-init) param setting, only set param. */
-	if (system_state != SYSTEM_RUNNING)
-		return param_set_bool(val, kp);
-
-	mutex_lock(&zswap_init_lock);
-	switch (zswap_init_state) {
-	case ZSWAP_UNINIT:
-		if (zswap_setup())
-			break;
-		fallthrough;
-	case ZSWAP_INIT_SUCCEED:
-		if (!zswap_has_pool)
-			pr_err("can't enable, no pool configured\n");
-		else
-			ret = param_set_bool(val, kp);
-		break;
-	case ZSWAP_INIT_FAILED:
-		pr_err("can't enable, initialization failed\n");
-	}
-	mutex_unlock(&zswap_init_lock);
-
-	return ret;
-}
-
 static bool zswap_compress(struct folio *folio, struct zswap_entry *entry)
 {
 	struct crypto_acomp_ctx *acomp_ctx;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-zswap-fix-objcg-use-after-free-in-entry-destruction.patch
mm-zswap-rename-zswap_free_entry-to-zswap_entry_free.patch
mm-zswap-inline-and-remove-zswap_entry_find_get.patch
mm-zswap-move-zswap_invalidate_entry-to-related-functions.patch
mm-zswap-warn-when-referencing-a-dead-entry.patch
mm-zswap-clean-up-zswap_entry_put.patch
mm-zswap-rename-__zswap_load-to-zswap_decompress.patch
mm-zswap-break-out-zwap_compress.patch
mm-zswap-further-cleanup-zswap_store.patch
mm-zswap-simplify-zswap_invalidate.patch
mm-zswap-function-ordering-pool-alloc-free.patch
mm-zswap-function-ordering-pool-refcounting.patch
mm-zswap-function-ordering-zswap_pools.patch
mm-zswap-function-ordering-pool-params.patch
mm-zswap-function-ordering-public-lru-api.patch
mm-zswap-function-ordering-move-entry-sections-out-of-lru-section.patch
mm-zswap-function-ordering-move-entry-section-out-of-tree-section.patch
mm-zswap-function-ordering-compress-decompress-functions.patch
mm-zswap-function-ordering-per-cpu-compression-infra.patch
mm-zswap-function-ordering-writeback.patch
mm-zswap-function-ordering-shrink_memcg_cb.patch

