Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F72383B1
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706596952; cv=none; b=UybLP87faSLffXenjHkyI06DvRUCYDWBMEMa1TqUVOXqqI4X1Ip8lBnzeElmYU4BR/SXqHq5nYKt9S4jLWPZ+J8NtTZHJlmqXukbt8LdPi5GMKj/B8QVPOA+hi0QYxoO9+Vszsvw/lOtxVmSmmT2KsKuers2l4be2ThIj3ZXQxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706596952; c=relaxed/simple;
	bh=fX4P0C+2I/NdPU/3KcVKkv7SLO7T1Z54zk5OymgTdb8=;
	h=Date:To:From:Subject:Message-Id; b=O4FIpOCk02FM1DIJMimtV/9PQ/yMqrYtNyoNjeiiXbujP6znri136e20UKFAVPhDf97Ctd16OfV6pai7vicoqOhdMSsPL8zQs04IeTN90XMxUfgrN+v0lkrOHshVGuHECya+MDTenNs73NNuNz1sFq5enT01beQSiKSCj0Z9ccI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tk/hWpsa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tk/hWpsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F098CC433C7;
	Tue, 30 Jan 2024 06:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706596952;
	bh=fX4P0C+2I/NdPU/3KcVKkv7SLO7T1Z54zk5OymgTdb8=;
	h=Date:To:From:Subject:From;
	b=tk/hWpsawxHpfQaeafprVb5acZrmcxgRZmwYTR2VDcB8bFxIEqEsUlHODbb4RWJyT
	 4yFTaF7hGyOEydWTARRMGubLueziGlL0qvqTG3noYq8Bafa0tW3WjCZ9gFMWbibfgs
	 N3w2JPUrnnf5SHnE6ncQ6+SYRbfzwrrh2C5LX8Mw=
Date: Mon, 29 Jan 2024 22:42:19 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-function-ordering-pool-refcounting.patch added to mm-unstable branch
Message-Id: <20240130064230.F098CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: function ordering: pool refcounting
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-function-ordering-pool-refcounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-function-ordering-pool-refcounting.patch

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
Subject: mm: zswap: function ordering: pool refcounting
Date: Mon, 29 Jan 2024 20:36:47 -0500

Move pool refcounting functions into the pool section. First the
destroy functions, then the get and put which uses them.

__zswap_pool_empty() has an upward reference to the global
zswap_pools, to sanity check it's not the currently active pool that's
being freed. That gets the forward decl for zswap_pool_cuyrrent().

This puts the get and put function above all callers, so kill the
forward decls as well.

Link: https://lkml.kernel.org/r/20240130014208.565554-12-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   94 +++++++++++++++++++++++++--------------------------
 1 file changed, 47 insertions(+), 47 deletions(-)

--- a/mm/zswap.c~mm-zswap-function-ordering-pool-refcounting
+++ a/mm/zswap.c
@@ -278,8 +278,6 @@ static inline struct zswap_tree *swap_zs
 
 static int zswap_writeback_entry(struct zswap_entry *entry,
 				 swp_entry_t swpentry);
-static int zswap_pool_get(struct zswap_pool *pool);
-static void zswap_pool_put(struct zswap_pool *pool);
 
 static bool zswap_is_full(void)
 {
@@ -472,6 +470,53 @@ static void zswap_pool_destroy(struct zs
 	kfree(pool);
 }
 
+static void __zswap_pool_release(struct work_struct *work)
+{
+	struct zswap_pool *pool = container_of(work, typeof(*pool),
+						release_work);
+
+	synchronize_rcu();
+
+	/* nobody should have been able to get a kref... */
+	WARN_ON(kref_get_unless_zero(&pool->kref));
+
+	/* pool is now off zswap_pools list and has no references. */
+	zswap_pool_destroy(pool);
+}
+
+static struct zswap_pool *zswap_pool_current(void);
+
+static void __zswap_pool_empty(struct kref *kref)
+{
+	struct zswap_pool *pool;
+
+	pool = container_of(kref, typeof(*pool), kref);
+
+	spin_lock(&zswap_pools_lock);
+
+	WARN_ON(pool == zswap_pool_current());
+
+	list_del_rcu(&pool->list);
+
+	INIT_WORK(&pool->release_work, __zswap_pool_release);
+	schedule_work(&pool->release_work);
+
+	spin_unlock(&zswap_pools_lock);
+}
+
+static int __must_check zswap_pool_get(struct zswap_pool *pool)
+{
+	if (!pool)
+		return 0;
+
+	return kref_get_unless_zero(&pool->kref);
+}
+
+static void zswap_pool_put(struct zswap_pool *pool)
+{
+	kref_put(&pool->kref, __zswap_pool_empty);
+}
+
 /* should be called under RCU */
 #ifdef CONFIG_MEMCG
 static inline struct mem_cgroup *mem_cgroup_from_entry(struct zswap_entry *entry)
@@ -1122,51 +1167,6 @@ resched:
 	zswap_pool_put(pool);
 }
 
-static int __must_check zswap_pool_get(struct zswap_pool *pool)
-{
-	if (!pool)
-		return 0;
-
-	return kref_get_unless_zero(&pool->kref);
-}
-
-static void __zswap_pool_release(struct work_struct *work)
-{
-	struct zswap_pool *pool = container_of(work, typeof(*pool),
-						release_work);
-
-	synchronize_rcu();
-
-	/* nobody should have been able to get a kref... */
-	WARN_ON(kref_get_unless_zero(&pool->kref));
-
-	/* pool is now off zswap_pools list and has no references. */
-	zswap_pool_destroy(pool);
-}
-
-static void __zswap_pool_empty(struct kref *kref)
-{
-	struct zswap_pool *pool;
-
-	pool = container_of(kref, typeof(*pool), kref);
-
-	spin_lock(&zswap_pools_lock);
-
-	WARN_ON(pool == zswap_pool_current());
-
-	list_del_rcu(&pool->list);
-
-	INIT_WORK(&pool->release_work, __zswap_pool_release);
-	schedule_work(&pool->release_work);
-
-	spin_unlock(&zswap_pools_lock);
-}
-
-static void zswap_pool_put(struct zswap_pool *pool)
-{
-	kref_put(&pool->kref, __zswap_pool_empty);
-}
-
 /*********************************
 * param callbacks
 **********************************/
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

