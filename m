Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188AD383A2
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706596894; cv=none; b=Bf8yTi4mk/QqZailaNYw0YJJrcJwgNPgwpYWF00BXlHXdhjI5PzdEysnV3gr2bGeRESnELR65nXp4NdMb/yp8kvF2dpaSTAEn4x/lF4BlyFGrjAfC55FXwYpbNQGOc8j01QFbbK1+dBKUshPnCygdjizB2fe8G+/dJ4uIiHadnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706596894; c=relaxed/simple;
	bh=qB+gtwydb6IcJeTHK/xLrQAYyxaqY7GiOPDRtQTXP4I=;
	h=Date:To:From:Subject:Message-Id; b=Pzmax7c8+LpImObFSU/A/w6TSBk7OPfnPtGaJpzgl09AiGqpZHGTXqwFV38LS0oCzw9ozWCQzp38EqDI3UwIPVKy1mTBiUIp78LJ9AgGJUPFYAZ57pyLuNtmlTng7odI9xEOdQzAIXsm79diss3hHthByX62vHG5xL3ABE0mEOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f7AOcAzv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f7AOcAzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B95EC433F1;
	Tue, 30 Jan 2024 06:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706596893;
	bh=qB+gtwydb6IcJeTHK/xLrQAYyxaqY7GiOPDRtQTXP4I=;
	h=Date:To:From:Subject:From;
	b=f7AOcAzvm0HC2UwpSuNoMf094Xq4ImjvujP2mNTrq7iArX1PXylC3VfVBcG2gXagM
	 rUKQY/PYvWBPyglkX9uMMTrhCUFCIY0Y13qpLh2+sQIw1bSn6Ol37uRO3ioJUcrabc
	 s974uD6+JOLaBn6rhORSmOyAkhDlC2YLhe6UoBA0=
Date: Mon, 29 Jan 2024 22:41:20 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-function-ordering-pool-alloc-free.patch added to mm-unstable branch
Message-Id: <20240130064131.2B95EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: function ordering: pool alloc & free
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-function-ordering-pool-alloc-free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-function-ordering-pool-alloc-free.patch

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
Subject: mm: zswap: function ordering: pool alloc & free
Date: Mon, 29 Jan 2024 20:36:46 -0500

The function ordering in zswap.c is a little chaotic, which requires
jumping in unexpected directions when following related code. This is
a series of patches that brings the file into the following order:

- pool functions
- lru functions
- rbtree functions
- zswap entry functions
- compression/backend functions
- writeback & shrinking functions
- store, load, invalidate, swapon, swapoff
- debugfs
- init

But it has to be split up such the moving still produces halfway
readable diffs.

In this patch, move pool allocation and freeing functions.

Link: https://lkml.kernel.org/r/20240130014208.565554-11-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |  297 ++++++++++++++++++++++++++-------------------------
 1 file changed, 152 insertions(+), 145 deletions(-)

--- a/mm/zswap.c~mm-zswap-function-ordering-pool-alloc-free
+++ a/mm/zswap.c
@@ -320,6 +320,158 @@ static void zswap_update_total_size(void
 	zswap_pool_total_size = total;
 }
 
+/*********************************
+* pool functions
+**********************************/
+
+static void zswap_alloc_shrinker(struct zswap_pool *pool);
+static void shrink_worker(struct work_struct *w);
+
+static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
+{
+	int i;
+	struct zswap_pool *pool;
+	char name[38]; /* 'zswap' + 32 char (max) num + \0 */
+	gfp_t gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
+	int ret;
+
+	if (!zswap_has_pool) {
+		/* if either are unset, pool initialization failed, and we
+		 * need both params to be set correctly before trying to
+		 * create a pool.
+		 */
+		if (!strcmp(type, ZSWAP_PARAM_UNSET))
+			return NULL;
+		if (!strcmp(compressor, ZSWAP_PARAM_UNSET))
+			return NULL;
+	}
+
+	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
+	if (!pool)
+		return NULL;
+
+	for (i = 0; i < ZSWAP_NR_ZPOOLS; i++) {
+		/* unique name for each pool specifically required by zsmalloc */
+		snprintf(name, 38, "zswap%x",
+			 atomic_inc_return(&zswap_pools_count));
+
+		pool->zpools[i] = zpool_create_pool(type, name, gfp);
+		if (!pool->zpools[i]) {
+			pr_err("%s zpool not available\n", type);
+			goto error;
+		}
+	}
+	pr_debug("using %s zpool\n", zpool_get_type(pool->zpools[0]));
+
+	strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
+
+	pool->acomp_ctx = alloc_percpu(*pool->acomp_ctx);
+	if (!pool->acomp_ctx) {
+		pr_err("percpu alloc failed\n");
+		goto error;
+	}
+
+	ret = cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
+				       &pool->node);
+	if (ret)
+		goto error;
+
+	zswap_alloc_shrinker(pool);
+	if (!pool->shrinker)
+		goto error;
+
+	pr_debug("using %s compressor\n", pool->tfm_name);
+
+	/* being the current pool takes 1 ref; this func expects the
+	 * caller to always add the new pool as the current pool
+	 */
+	kref_init(&pool->kref);
+	INIT_LIST_HEAD(&pool->list);
+	if (list_lru_init_memcg(&pool->list_lru, pool->shrinker))
+		goto lru_fail;
+	shrinker_register(pool->shrinker);
+	INIT_WORK(&pool->shrink_work, shrink_worker);
+	atomic_set(&pool->nr_stored, 0);
+
+	zswap_pool_debug("created", pool);
+
+	return pool;
+
+lru_fail:
+	list_lru_destroy(&pool->list_lru);
+	shrinker_free(pool->shrinker);
+error:
+	if (pool->acomp_ctx)
+		free_percpu(pool->acomp_ctx);
+	while (i--)
+		zpool_destroy_pool(pool->zpools[i]);
+	kfree(pool);
+	return NULL;
+}
+
+static struct zswap_pool *__zswap_pool_create_fallback(void)
+{
+	bool has_comp, has_zpool;
+
+	has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
+	if (!has_comp && strcmp(zswap_compressor,
+				CONFIG_ZSWAP_COMPRESSOR_DEFAULT)) {
+		pr_err("compressor %s not available, using default %s\n",
+		       zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT);
+		param_free_charp(&zswap_compressor);
+		zswap_compressor = CONFIG_ZSWAP_COMPRESSOR_DEFAULT;
+		has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
+	}
+	if (!has_comp) {
+		pr_err("default compressor %s not available\n",
+		       zswap_compressor);
+		param_free_charp(&zswap_compressor);
+		zswap_compressor = ZSWAP_PARAM_UNSET;
+	}
+
+	has_zpool = zpool_has_pool(zswap_zpool_type);
+	if (!has_zpool && strcmp(zswap_zpool_type,
+				 CONFIG_ZSWAP_ZPOOL_DEFAULT)) {
+		pr_err("zpool %s not available, using default %s\n",
+		       zswap_zpool_type, CONFIG_ZSWAP_ZPOOL_DEFAULT);
+		param_free_charp(&zswap_zpool_type);
+		zswap_zpool_type = CONFIG_ZSWAP_ZPOOL_DEFAULT;
+		has_zpool = zpool_has_pool(zswap_zpool_type);
+	}
+	if (!has_zpool) {
+		pr_err("default zpool %s not available\n",
+		       zswap_zpool_type);
+		param_free_charp(&zswap_zpool_type);
+		zswap_zpool_type = ZSWAP_PARAM_UNSET;
+	}
+
+	if (!has_comp || !has_zpool)
+		return NULL;
+
+	return zswap_pool_create(zswap_zpool_type, zswap_compressor);
+}
+
+static void zswap_pool_destroy(struct zswap_pool *pool)
+{
+	int i;
+
+	zswap_pool_debug("destroying", pool);
+
+	shrinker_free(pool->shrinker);
+	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
+	free_percpu(pool->acomp_ctx);
+	list_lru_destroy(&pool->list_lru);
+
+	spin_lock(&zswap_pools_lock);
+	mem_cgroup_iter_break(NULL, pool->next_shrink);
+	pool->next_shrink = NULL;
+	spin_unlock(&zswap_pools_lock);
+
+	for (i = 0; i < ZSWAP_NR_ZPOOLS; i++)
+		zpool_destroy_pool(pool->zpools[i]);
+	kfree(pool);
+}
+
 /* should be called under RCU */
 #ifdef CONFIG_MEMCG
 static inline struct mem_cgroup *mem_cgroup_from_entry(struct zswap_entry *entry)
@@ -970,151 +1122,6 @@ resched:
 	zswap_pool_put(pool);
 }
 
-static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
-{
-	int i;
-	struct zswap_pool *pool;
-	char name[38]; /* 'zswap' + 32 char (max) num + \0 */
-	gfp_t gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
-	int ret;
-
-	if (!zswap_has_pool) {
-		/* if either are unset, pool initialization failed, and we
-		 * need both params to be set correctly before trying to
-		 * create a pool.
-		 */
-		if (!strcmp(type, ZSWAP_PARAM_UNSET))
-			return NULL;
-		if (!strcmp(compressor, ZSWAP_PARAM_UNSET))
-			return NULL;
-	}
-
-	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
-	if (!pool)
-		return NULL;
-
-	for (i = 0; i < ZSWAP_NR_ZPOOLS; i++) {
-		/* unique name for each pool specifically required by zsmalloc */
-		snprintf(name, 38, "zswap%x",
-			 atomic_inc_return(&zswap_pools_count));
-
-		pool->zpools[i] = zpool_create_pool(type, name, gfp);
-		if (!pool->zpools[i]) {
-			pr_err("%s zpool not available\n", type);
-			goto error;
-		}
-	}
-	pr_debug("using %s zpool\n", zpool_get_type(pool->zpools[0]));
-
-	strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
-
-	pool->acomp_ctx = alloc_percpu(*pool->acomp_ctx);
-	if (!pool->acomp_ctx) {
-		pr_err("percpu alloc failed\n");
-		goto error;
-	}
-
-	ret = cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
-				       &pool->node);
-	if (ret)
-		goto error;
-
-	zswap_alloc_shrinker(pool);
-	if (!pool->shrinker)
-		goto error;
-
-	pr_debug("using %s compressor\n", pool->tfm_name);
-
-	/* being the current pool takes 1 ref; this func expects the
-	 * caller to always add the new pool as the current pool
-	 */
-	kref_init(&pool->kref);
-	INIT_LIST_HEAD(&pool->list);
-	if (list_lru_init_memcg(&pool->list_lru, pool->shrinker))
-		goto lru_fail;
-	shrinker_register(pool->shrinker);
-	INIT_WORK(&pool->shrink_work, shrink_worker);
-	atomic_set(&pool->nr_stored, 0);
-
-	zswap_pool_debug("created", pool);
-
-	return pool;
-
-lru_fail:
-	list_lru_destroy(&pool->list_lru);
-	shrinker_free(pool->shrinker);
-error:
-	if (pool->acomp_ctx)
-		free_percpu(pool->acomp_ctx);
-	while (i--)
-		zpool_destroy_pool(pool->zpools[i]);
-	kfree(pool);
-	return NULL;
-}
-
-static struct zswap_pool *__zswap_pool_create_fallback(void)
-{
-	bool has_comp, has_zpool;
-
-	has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
-	if (!has_comp && strcmp(zswap_compressor,
-				CONFIG_ZSWAP_COMPRESSOR_DEFAULT)) {
-		pr_err("compressor %s not available, using default %s\n",
-		       zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT);
-		param_free_charp(&zswap_compressor);
-		zswap_compressor = CONFIG_ZSWAP_COMPRESSOR_DEFAULT;
-		has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
-	}
-	if (!has_comp) {
-		pr_err("default compressor %s not available\n",
-		       zswap_compressor);
-		param_free_charp(&zswap_compressor);
-		zswap_compressor = ZSWAP_PARAM_UNSET;
-	}
-
-	has_zpool = zpool_has_pool(zswap_zpool_type);
-	if (!has_zpool && strcmp(zswap_zpool_type,
-				 CONFIG_ZSWAP_ZPOOL_DEFAULT)) {
-		pr_err("zpool %s not available, using default %s\n",
-		       zswap_zpool_type, CONFIG_ZSWAP_ZPOOL_DEFAULT);
-		param_free_charp(&zswap_zpool_type);
-		zswap_zpool_type = CONFIG_ZSWAP_ZPOOL_DEFAULT;
-		has_zpool = zpool_has_pool(zswap_zpool_type);
-	}
-	if (!has_zpool) {
-		pr_err("default zpool %s not available\n",
-		       zswap_zpool_type);
-		param_free_charp(&zswap_zpool_type);
-		zswap_zpool_type = ZSWAP_PARAM_UNSET;
-	}
-
-	if (!has_comp || !has_zpool)
-		return NULL;
-
-	return zswap_pool_create(zswap_zpool_type, zswap_compressor);
-}
-
-static void zswap_pool_destroy(struct zswap_pool *pool)
-{
-	int i;
-
-	zswap_pool_debug("destroying", pool);
-
-	shrinker_free(pool->shrinker);
-	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
-	free_percpu(pool->acomp_ctx);
-	list_lru_destroy(&pool->list_lru);
-
-	spin_lock(&zswap_pools_lock);
-	mem_cgroup_iter_break(NULL, pool->next_shrink);
-	pool->next_shrink = NULL;
-	spin_unlock(&zswap_pools_lock);
-
-	for (i = 0; i < ZSWAP_NR_ZPOOLS; i++)
-		zpool_destroy_pool(pool->zpools[i]);
-	kfree(pool);
-}
-
 static int __must_check zswap_pool_get(struct zswap_pool *pool)
 {
 	if (!pool)
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

