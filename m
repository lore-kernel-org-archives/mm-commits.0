Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9661378D8D
	for <mm-commits@vger.kernel.org>; Fri, 11 Sep 2026 01:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789090862; cv=none; b=CzYJB9ECR1NzoPRJhGcfs1/ns8tTF8qBkcEdp+JphhWROqXtqBUn1BIc0P8QvQuyQ6GU19I8S4y9M5xLCNIGv+ypnxHZC576eb1Ui3rOgvaWAoB0LXdx6l/4HEfqh3xWiVbC1WYOiJ4gEL5E5TWNtG0cd7siNodAR0jqRzf3EvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789090862; c=relaxed/simple;
	bh=T3gApMpKG+JMCC0s1jV0h4MPkIT1MLDtUHs/vo52eO4=;
	h=Date:To:From:Subject:Message-Id; b=myahW0xeAmkx0Mq5H5vl/ulyV0HgBZMRjhx9KhWQH7FlRDTOCc/Oe5DNPj1zQwug+3fxj2ytQ4pw8zfN6rHcsAkI0bwfG7Ph7wDMBFCrzLpkSvGPq89jrxUArZyzEzYoVw+P8ucz2YvEpVogAJFn8HdIvBLvR6PYSVAYq7rYi3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VQcQSTcP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VQcQSTcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4794F1F000FF;
	Fri, 11 Sep 2026 01:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789090860;
	bh=9bdKAGoTsIXQBuT8kk+gMsmynS9fGtifs4AS8YJI2R4=;
	h=Date:To:From:Subject;
	b=VQcQSTcPgITHqdbwTN0mQfD7KFMaa6bxoCGWqap7z40vLIVJtKt7fBikGEoq/eqMk
	 wPEX13WbDOrxlf+B85DoCshZHwIKnvzIOEuWYOcxu3s5TtST+5+QrP0DddL6igGm/Z
	 awDwet8dA6IRWeZnGMUELJKjDFWC3ppj/ndLwzss=
Date: Thu, 10 Sep 2026 18:40:59 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chrisl@kernel.org,chengming.zhou@linux.dev,wujianyue000@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-replace-the-zswap_pools-list-with-an-allocating-xarray.patch added to mm-new branch
Message-Id: <20260911014100.4794F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: replace the zswap_pools list with an allocating xarray
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-replace-the-zswap_pools-list-with-an-allocating-xarray.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-replace-the-zswap_pools-list-with-an-allocating-xarray.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jianyue Wu <wujianyue000@gmail.com>
Subject: mm/zswap: replace the zswap_pools list with an allocating xarray
Date: Sun, 06 Sep 2026 15:47:18 +0800

Originally zswap kept its pools on an RCU list whose head also served as
the current pool.  Convert the pool table to an allocating xarray keyed by
a small integer id, and track the current pool with a separate
RCU-protected pointer.

The xarray gives each pool a stable id for a later zswap_entry shrink. 
XA_FLAGS_ALLOC1 starts ids at 1, so id 0 remains reserved.  The id range
is bounded by ZSWAP_MAX_POOL_ID because the later entry field is a u8.

Keep compressor switching close to the previous flow: look up an existing
pool with xa_for_each(), resurrect it if reused, or create a new one. 
zswap_pool_create() allocates the pool's id and publishes it into the
xarray as its final step, so the create call either fully publishes or
fully unwinds on failure.  Publishing makes the pool live, so a caller
that later fails (e.g.  param_set_charp()) must still kill the pool to
erase it from the xarray.

Compressor switches update zswap_current_pool with rcu_assign_pointer(),
serialized by the module parameter lock, so no xa_lock is needed for that
update.  The pool walk above is lockless under RCU.  xa_lock is taken only
to allocate (xa_alloc_bh()) and erase (xa_erase_bh()) xarray entries.

Link: https://lore.kernel.org/20260906-shrink_zswap_entry_v6-v6-2-ac4cf61565fb@gmail.com
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |  122 +++++++++++++++++++++++++++------------------------
 1 file changed, 66 insertions(+), 56 deletions(-)

--- a/mm/zswap.c~mm-zswap-replace-the-zswap_pools-list-with-an-allocating-xarray
+++ a/mm/zswap.c
@@ -34,6 +34,7 @@
 #include <linux/writeback.h>
 #include <linux/pagemap.h>
 #include <linux/workqueue.h>
+#include <linux/xarray.h>
 #include <linux/list_lru.h>
 #include <linux/zsmalloc.h>
 
@@ -154,12 +155,23 @@ struct zswap_pool {
 	struct zs_pool *zs_pool;
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
 	struct percpu_ref ref;
-	struct list_head list;
 	struct rcu_work release_rwork;
 	struct hlist_node node;
+	u8 idx;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
 };
 
+/*
+ * Live pools keyed by id (1..ZSWAP_MAX_POOL_ID).  XA_FLAGS_ALLOC1 keeps id 0
+ * reserved so it is never handed to a live pool.  XA_FLAGS_LOCK_BH makes the
+ * xa_lock softirq-safe: it is taken from __zswap_pool_empty(), which runs from
+ * a percpu_ref release callback in softirq context.
+ */
+#define ZSWAP_FIRST_POOL_ID 1
+#define ZSWAP_MAX_POOL_ID U8_MAX
+static DEFINE_XARRAY_FLAGS(zswap_pools, XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_BH);
+static struct zswap_pool __rcu *zswap_current_pool;
+
 /* Global LRU lists shared by all zswap pools. */
 static struct list_lru zswap_list_lru;
 
@@ -200,10 +212,6 @@ struct zswap_entry {
 static struct xarray *zswap_trees[MAX_SWAPFILES];
 static unsigned int nr_zswap_trees[MAX_SWAPFILES];
 
-/* RCU-protected iteration */
-static LIST_HEAD(zswap_pools);
-/* protects zswap_pools list modification */
-static DEFINE_SPINLOCK(zswap_pools_lock);
 /* pool counter to provide unique names to zsmalloc */
 static atomic_t zswap_pools_count = ATOMIC_INIT(0);
 
@@ -280,6 +288,7 @@ static struct zswap_pool *zswap_pool_cre
 	struct zswap_pool *pool;
 	char name[38]; /* 'zswap' + 32 char (max) num + \0 */
 	int ret, cpu;
+	u32 id;
 
 	if (!zswap_has_pool && !strcmp(compressor, ZSWAP_PARAM_UNSET))
 		return NULL;
@@ -325,7 +334,22 @@ static struct zswap_pool *zswap_pool_cre
 			      PERCPU_REF_ALLOW_REINIT, GFP_KERNEL);
 	if (ret)
 		goto ref_fail;
-	INIT_LIST_HEAD(&pool->list);
+
+	/*
+	 * Publish only after the pool is fully built, so lockless walkers
+	 * never see a half-initialized pool.  The _bh variant pairs with the
+	 * softirq-context xa_lock taken in __zswap_pool_empty().
+	 */
+	ret = xa_alloc_bh(&zswap_pools, &id, pool,
+			  XA_LIMIT(ZSWAP_FIRST_POOL_ID, ZSWAP_MAX_POOL_ID),
+			  GFP_KERNEL);
+	if (ret) {
+		if (ret == -EBUSY)
+			pr_err("cannot allocate pool id (max %d live pools)\n",
+			       ZSWAP_MAX_POOL_ID - ZSWAP_FIRST_POOL_ID + 1);
+		goto xa_fail;
+	}
+	pool->idx = id;
 
 	zswap_pool_debug("created", pool);
 
@@ -333,6 +357,8 @@ static struct zswap_pool *zswap_pool_cre
 
 	return pool;
 
+xa_fail:
+	percpu_ref_exit(&pool->ref);
 ref_fail:
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
 
@@ -393,28 +419,22 @@ static void __zswap_pool_release(struct
 	WARN_ON(!percpu_ref_is_zero(&pool->ref));
 	percpu_ref_exit(&pool->ref);
 
-	/* pool is now off zswap_pools list and has no references. */
+	/* The pool is no longer in zswap_pools and has no references. */
 	zswap_pool_destroy(pool);
 }
 
-static struct zswap_pool *zswap_pool_current(void);
-
 static void __zswap_pool_empty(struct percpu_ref *ref)
 {
 	struct zswap_pool *pool;
 
 	pool = container_of(ref, typeof(*pool), ref);
 
-	spin_lock_bh(&zswap_pools_lock);
-
-	WARN_ON(pool == zswap_pool_current());
+	WARN_ON(pool == rcu_access_pointer(zswap_current_pool));
 
-	list_del_rcu(&pool->list);
+	xa_erase_bh(&zswap_pools, pool->idx);
 
 	INIT_RCU_WORK(&pool->release_rwork, __zswap_pool_release);
 	queue_rcu_work(system_percpu_wq, &pool->release_rwork);
-
-	spin_unlock_bh(&zswap_pools_lock);
 }
 
 static int __must_check zswap_pool_tryget(struct zswap_pool *pool)
@@ -440,20 +460,13 @@ static struct zswap_pool *__zswap_pool_c
 {
 	struct zswap_pool *pool;
 
-	pool = list_first_or_null_rcu(&zswap_pools, typeof(*pool), list);
+	pool = rcu_dereference(zswap_current_pool);
 	WARN_ONCE(!pool && zswap_has_pool,
 		  "%s: no page storage pool!\n", __func__);
 
 	return pool;
 }
 
-static struct zswap_pool *zswap_pool_current(void)
-{
-	assert_spin_locked(&zswap_pools_lock);
-
-	return __zswap_pool_current();
-}
-
 static struct zswap_pool *zswap_pool_current_get(void)
 {
 	struct zswap_pool *pool;
@@ -469,23 +482,28 @@ static struct zswap_pool *zswap_pool_cur
 	return pool;
 }
 
-/* type and compressor must be null-terminated */
+/* compressor must be null-terminated */
 static struct zswap_pool *zswap_pool_find_get(char *compressor)
 {
 	struct zswap_pool *pool;
+	unsigned long id;
 
-	assert_spin_locked(&zswap_pools_lock);
-
-	list_for_each_entry_rcu(pool, &zswap_pools, list) {
+	/*
+	 * __zswap_pool_empty() can erase from zswap_pools in softirq while we
+	 * walk.  rcu_read_lock() keeps the walk consistent and each pool alive
+	 * across tryget().  xa_for_each()'s own RCU does not span the loop body.
+	 */
+	rcu_read_lock();
+	xa_for_each(&zswap_pools, id, pool) {
 		if (strcmp(pool->tfm_name, compressor))
 			continue;
 		/* if we can't get it, it's about to be destroyed */
-		if (!zswap_pool_tryget(pool))
-			continue;
-		return pool;
+		if (zswap_pool_tryget(pool))
+			break;
 	}
+	rcu_read_unlock();
 
-	return NULL;
+	return pool;
 }
 
 static unsigned long zswap_max_pages(void)
@@ -502,9 +520,14 @@ unsigned long zswap_total_pages(void)
 {
 	struct zswap_pool *pool;
 	unsigned long total = 0;
+	unsigned long id;
 
+	/*
+	 * rcu_read_lock() keeps each pool alive across zs_get_total_pages().
+	 * xa_for_each()'s own RCU does not span the loop body.
+	 */
 	rcu_read_lock();
-	list_for_each_entry_rcu(pool, &zswap_pools, list)
+	xa_for_each(&zswap_pools, id, pool)
 		total += zs_get_total_pages(pool->zs_pool);
 	rcu_read_unlock();
 
@@ -561,20 +584,13 @@ static int zswap_compressor_param_set(co
 		return -ENOENT;
 	}
 
-	spin_lock_bh(&zswap_pools_lock);
-
 	pool = zswap_pool_find_get(s);
-	if (pool) {
+	if (!pool) {
+		pool = zswap_pool_create(s);
+	} else {
 		zswap_pool_debug("using existing", pool);
-		WARN_ON(pool == zswap_pool_current());
-		list_del_rcu(&pool->list);
-	}
-
-	spin_unlock_bh(&zswap_pools_lock);
+		WARN_ON(pool == rcu_access_pointer(zswap_current_pool));
 
-	if (!pool)
-		pool = zswap_pool_create(s);
-	else {
 		/*
 		 * Restore the initial ref dropped by percpu_ref_kill()
 		 * when the pool was decommissioned and switch it again
@@ -591,24 +607,18 @@ static int zswap_compressor_param_set(co
 	else
 		ret = -EINVAL;
 
-	spin_lock_bh(&zswap_pools_lock);
-
+	/*
+	 * Compressor switches are serialized by the kernel param lock, so this
+	 * is the only writer of zswap_current_pool: no xa_lock needed.
+	 */
 	if (!ret) {
-		put_pool = zswap_pool_current();
-		list_add_rcu(&pool->list, &zswap_pools);
+		put_pool = rcu_access_pointer(zswap_current_pool);
+		rcu_assign_pointer(zswap_current_pool, pool);
 		zswap_has_pool = true;
 	} else if (pool) {
-		/*
-		 * Add the possibly pre-existing pool to the end of the pools
-		 * list; if it's new (and empty) then it'll be removed and
-		 * destroyed by the put after we drop the lock
-		 */
-		list_add_tail_rcu(&pool->list, &zswap_pools);
 		put_pool = pool;
 	}
 
-	spin_unlock_bh(&zswap_pools_lock);
-
 	/*
 	 * Drop the ref from either the old current pool,
 	 * or the new pool we failed to add
@@ -1816,7 +1826,7 @@ static int zswap_setup(void)
 	pool = __zswap_pool_create_fallback();
 	if (pool) {
 		pr_info("loaded using pool %s\n", pool->tfm_name);
-		list_add_rcu(&pool->list, &zswap_pools);
+		rcu_assign_pointer(zswap_current_pool, pool);
 		zswap_has_pool = true;
 	} else {
 		pr_err("pool creation failed\n");
_

Patches currently in -mm which might be from wujianyue000@gmail.com are

mm-zswap-release-retired-pools-via-queue_rcu_work-instead-of-synchronize_rcu.patch
mm-zswap-replace-the-zswap_pools-list-with-an-allocating-xarray.patch
mm-zswap-reference-the-pool-by-id-to-shrink-struct-zswap_entry.patch

