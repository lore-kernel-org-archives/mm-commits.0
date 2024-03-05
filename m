Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228F9F9DB
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600518; cv=none; b=hAsx/mqSHSbVizclUyVOB6ZD9B6yQ5LEXbnAUyTvP/teieJVAW+JVtXj3cNSy8N/VEs/scqSk2CuTe9ETDOYSvNZRDJ+6qI+6LThT+hw2xdPPNwxkP2m3KRgWiYEbht72gdxlCyDBICVFoGhM+hu5lkx2wEW0zQi7DkPFoVPwZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600518; c=relaxed/simple;
	bh=KLnfsMvEiMqtpIgSn1UPvhJ5teKl9GCpQxOQ7F7HnwA=;
	h=Date:To:From:Subject:Message-Id; b=jzsnnvEQYw8KcbgKZ/uhLvfXcz7Q8x6XDbwj8MeRlUb7+0srj2uUq9XF4wQpILwizLM9UaaX5ShAirJdIQYCMhPL78p1iKi3J18rbrvhkAikGoOe3PTopkDazg/1fW/xEBUvx6l3lzBg+lo8qR2P0UoAggKmVrU6JF9IIlWsSQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HlSpuujd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HlSpuujd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96479C433F1;
	Tue,  5 Mar 2024 01:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600517;
	bh=KLnfsMvEiMqtpIgSn1UPvhJ5teKl9GCpQxOQ7F7HnwA=;
	h=Date:To:From:Subject:From;
	b=HlSpuujdU5SadwZ5fmgoj/n30oFoezj6ALHTX3UwNiZi/2F7+quhh8tGz67Lv0QOc
	 Mjcrm3bY32Ean30TpMsWGs5LPw2qBmpBFBYUcpXmmUNqVBmcbwfDj7ikAj6rP33zku
	 yC+Iqb78fANSpv/svcy8YEj7Ip6evp01SSsc+iH8=
Date: Mon, 04 Mar 2024 17:01:57 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch removed from -mm tree
Message-Id: <20240305010157.96479C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: change zswap_pool kref to percpu_ref
has been removed from the -mm tree.  Its filename was
     mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: change zswap_pool kref to percpu_ref
Date: Fri, 16 Feb 2024 08:55:05 +0000

All zswap entries will take a reference of zswap_pool when zswap_store(),
and drop it when free.  Change it to use the percpu_ref is better for
scalability performance.

Although percpu_ref use a bit more memory which should be ok for our use
case, since we almost have only one zswap_pool to be using.  The
performance gain is for zswap_store/load hotpath.

Testing kernel build (32 threads) in tmpfs with memory.max=2GB.  (zswap
shrinker and writeback enabled with one 50GB swapfile, on a 128 CPUs
x86-64 machine, below is the average of 5 runs)

        mm-unstable  zswap-global-lru
real    63.20        63.12
user    1061.75      1062.95
sys     268.74       264.44

[chengming.zhou@linux.dev: fix zswap_pools_lock usages after changing to percpu_ref]
  Link: https://lkml.kernel.org/r/20240228154954.3028626-1-chengming.zhou@linux.dev
Link: https://lkml.kernel.org/r/20240210-zswap-global-lru-v3-2-200495333595@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   48 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 15 deletions(-)

--- a/mm/zswap.c~mm-zswap-change-zswap_pool-kref-to-percpu_ref
+++ a/mm/zswap.c
@@ -173,7 +173,7 @@ struct crypto_acomp_ctx {
 struct zswap_pool {
 	struct zpool *zpools[ZSWAP_NR_ZPOOLS];
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
-	struct kref kref;
+	struct percpu_ref ref;
 	struct list_head list;
 	struct work_struct release_work;
 	struct hlist_node node;
@@ -305,6 +305,7 @@ static void zswap_update_total_size(void
 /*********************************
 * pool functions
 **********************************/
+static void __zswap_pool_empty(struct percpu_ref *ref);
 
 static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 {
@@ -358,13 +359,18 @@ static struct zswap_pool *zswap_pool_cre
 	/* being the current pool takes 1 ref; this func expects the
 	 * caller to always add the new pool as the current pool
 	 */
-	kref_init(&pool->kref);
+	ret = percpu_ref_init(&pool->ref, __zswap_pool_empty,
+			      PERCPU_REF_ALLOW_REINIT, GFP_KERNEL);
+	if (ret)
+		goto ref_fail;
 	INIT_LIST_HEAD(&pool->list);
 
 	zswap_pool_debug("created", pool);
 
 	return pool;
 
+ref_fail:
+	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
@@ -437,8 +443,9 @@ static void __zswap_pool_release(struct
 
 	synchronize_rcu();
 
-	/* nobody should have been able to get a kref... */
-	WARN_ON(kref_get_unless_zero(&pool->kref));
+	/* nobody should have been able to get a ref... */
+	WARN_ON(!percpu_ref_is_zero(&pool->ref));
+	percpu_ref_exit(&pool->ref);
 
 	/* pool is now off zswap_pools list and has no references. */
 	zswap_pool_destroy(pool);
@@ -446,13 +453,13 @@ static void __zswap_pool_release(struct
 
 static struct zswap_pool *zswap_pool_current(void);
 
-static void __zswap_pool_empty(struct kref *kref)
+static void __zswap_pool_empty(struct percpu_ref *ref)
 {
 	struct zswap_pool *pool;
 
-	pool = container_of(kref, typeof(*pool), kref);
+	pool = container_of(ref, typeof(*pool), ref);
 
-	spin_lock(&zswap_pools_lock);
+	spin_lock_bh(&zswap_pools_lock);
 
 	WARN_ON(pool == zswap_pool_current());
 
@@ -461,7 +468,7 @@ static void __zswap_pool_empty(struct kr
 	INIT_WORK(&pool->release_work, __zswap_pool_release);
 	schedule_work(&pool->release_work);
 
-	spin_unlock(&zswap_pools_lock);
+	spin_unlock_bh(&zswap_pools_lock);
 }
 
 static int __must_check zswap_pool_get(struct zswap_pool *pool)
@@ -469,12 +476,12 @@ static int __must_check zswap_pool_get(s
 	if (!pool)
 		return 0;
 
-	return kref_get_unless_zero(&pool->kref);
+	return percpu_ref_tryget(&pool->ref);
 }
 
 static void zswap_pool_put(struct zswap_pool *pool)
 {
-	kref_put(&pool->kref, __zswap_pool_empty);
+	percpu_ref_put(&pool->ref);
 }
 
 static struct zswap_pool *__zswap_pool_current(void)
@@ -591,7 +598,7 @@ static int __zswap_param_set(const char
 		return -EINVAL;
 	}
 
-	spin_lock(&zswap_pools_lock);
+	spin_lock_bh(&zswap_pools_lock);
 
 	pool = zswap_pool_find_get(type, compressor);
 	if (pool) {
@@ -600,17 +607,28 @@ static int __zswap_param_set(const char
 		list_del_rcu(&pool->list);
 	}
 
-	spin_unlock(&zswap_pools_lock);
+	spin_unlock_bh(&zswap_pools_lock);
 
 	if (!pool)
 		pool = zswap_pool_create(type, compressor);
+	else {
+		/*
+		 * Restore the initial ref dropped by percpu_ref_kill()
+		 * when the pool was decommissioned and switch it again
+		 * to percpu mode.
+		 */
+		percpu_ref_resurrect(&pool->ref);
+
+		/* Drop the ref from zswap_pool_find_get(). */
+		zswap_pool_put(pool);
+	}
 
 	if (pool)
 		ret = param_set_charp(s, kp);
 	else
 		ret = -EINVAL;
 
-	spin_lock(&zswap_pools_lock);
+	spin_lock_bh(&zswap_pools_lock);
 
 	if (!ret) {
 		put_pool = zswap_pool_current();
@@ -625,7 +643,7 @@ static int __zswap_param_set(const char
 		put_pool = pool;
 	}
 
-	spin_unlock(&zswap_pools_lock);
+	spin_unlock_bh(&zswap_pools_lock);
 
 	if (!zswap_has_pool && !pool) {
 		/* if initial pool creation failed, and this pool creation also
@@ -642,7 +660,7 @@ static int __zswap_param_set(const char
 	 * or the new pool we failed to add
 	 */
 	if (put_pool)
-		zswap_pool_put(put_pool);
+		percpu_ref_kill(&put_pool->ref);
 
 	return ret;
 }
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are


