Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E531200C8
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 02:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708396851; cv=none; b=nXJZ54Mrohvf/81Xud/QSTSWJJDa8StQM3I067VFhCTVt/WlsvZc3FAVf1ozyFKPcK+xygSDi10OzrikEdcb7zmgbK79oUaTf1eE9/xURBTeioyijaRdmtA1TfFcpHGEOA/TFMtpWcIzheV7n/Nj8LNFH4hKXTo7XKWt2IlVKck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708396851; c=relaxed/simple;
	bh=CzZv/eQ5xFxCClK7LZSd14oAXU7/vl5AWsr9CqraSGM=;
	h=Date:To:From:Subject:Message-Id; b=oF2UQXQ3FhF4yULY1NElOHm1nHk0gQp2n0xegvot1swZbZshoOmgyoyvHDAshn1N2iyIi5w2byD/O52EIblKtH5t4WcEcvZFhcwn28KKJAGJlV0xBHl99aN3NM3RYhXKEOgKX3NgE8o15/6le4iWglaqLr/f0+hsIKmGBJyUjlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rwoahYS3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rwoahYS3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0737CC433F1;
	Tue, 20 Feb 2024 02:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708396851;
	bh=CzZv/eQ5xFxCClK7LZSd14oAXU7/vl5AWsr9CqraSGM=;
	h=Date:To:From:Subject:From;
	b=rwoahYS3nnJe5/STxf8bQiA7CL9CKzwH1jKtSxM6Z4Nwn939GzjuzFWsxCVE3I+uN
	 kJW6L9xvGTjp9fmPARInn0+RMrRzoAlGEsr723FpWsp9CPhg3aW/sZXm+hqNgW2F4e
	 VvMYNscmnOD3bdTiTmgJojInFdmzSU6khVclKgD8=
Date: Mon, 19 Feb 2024 18:40:50 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch added to mm-unstable branch
Message-Id: <20240220024051.0737CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: change zswap_pool kref to percpu_ref
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch

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

Link: https://lkml.kernel.org/r/20240210-zswap-global-lru-v3-2-200495333595@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

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
@@ -446,11 +453,11 @@ static void __zswap_pool_release(struct
 
 static struct zswap_pool *zswap_pool_current(void);
 
-static void __zswap_pool_empty(struct kref *kref)
+static void __zswap_pool_empty(struct percpu_ref *ref)
 {
 	struct zswap_pool *pool;
 
-	pool = container_of(kref, typeof(*pool), kref);
+	pool = container_of(ref, typeof(*pool), ref);
 
 	spin_lock(&zswap_pools_lock);
 
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
@@ -604,6 +611,17 @@ static int __zswap_param_set(const char
 
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

mm-zswap-invalidate-duplicate-entry-when-zswap_enabled.patch
mm-zswap-make-sure-each-swapfile-always-have-zswap-rb-tree.patch
mm-zswap-split-zswap-rb-tree.patch
mm-zswap-fix-race-between-lru-writeback-and-swapoff.patch
mm-list_lru-remove-list_lru_putback.patch
mm-zswap-add-more-comments-in-shrink_memcg_cb.patch
mm-zswap-invalidate-zswap-entry-when-swap-entry-free.patch
mm-zswap-stop-lru-list-shrinking-when-encounter-warm-region.patch
mm-zswap-remove-duplicate_entry-debug-value.patch
mm-zswap-only-support-zswap_exclusive_loads_enabled.patch
mm-zswap-zswap-entry-doesnt-need-refcount-anymore.patch
mm-zswap-optimize-and-cleanup-the-invalidation-of-duplicate-entry.patch
mm-zsmalloc-fix-migrate_write_lock-when-config_compaction.patch
mm-zsmalloc-remove-migrate_write_lock_nested.patch
mm-zsmalloc-remove-unused-zspage-isolated.patch
mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools.patch
mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch

