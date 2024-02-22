Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4B81118E
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560121; cv=none; b=Detc1mT2waP/7oDehzhHW8z+RwaA8edHK5XTVg12P3g8wRgoa3HG8In9lJiO0obTORfXD5+rjW4Pqgew1Bb9bmWOoo4ulWCSoUtHqoglF2TeHStKzYMZuuzmJlNRuvOEUD4MF4pEvSpJy0BFrJ8YSYiVKmw1aZO4XT76sCCm+AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560121; c=relaxed/simple;
	bh=urFofr/oJmm78ALKIcSHOnlB5Cfu3l2BLqZVq4Na15E=;
	h=Date:To:From:Subject:Message-Id; b=WHj0lhqIU3qIEtDoknIjKheumKik8yeAxzA+M0tvfopfZEX1KJKx8kmxJaO4l9CbuuUdYi5UrDBIZZf4OHAwIrE8SGU2aGL8hM8j/yxHdzlioEwx6teghKBbJaNerIgLX3dweDESu8n/Zyfcu+q9VfLufxUl2vu1RpXAWKBn+Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wNZabcvV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wNZabcvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF077C43390;
	Thu, 22 Feb 2024 00:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560121;
	bh=urFofr/oJmm78ALKIcSHOnlB5Cfu3l2BLqZVq4Na15E=;
	h=Date:To:From:Subject:From;
	b=wNZabcvVRKFnlbke391zoJtt4AYxUkHZHrPQUMJYFmw4m951ELE+xiCVwSm1Ytbve
	 17+nCRsd2l9zni6cOkTBrBNiU9mDpj7NjWSGvTMy7272hfHIeB9vWCs0CtKdsgsHJi
	 HKk5bxu0xssYLW9QrhL2QuJx3QPoSTuwRyzFN2zg=
Date: Wed, 21 Feb 2024 16:02:01 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-function-ordering-pool-refcounting.patch removed from -mm tree
Message-Id: <20240222000201.AF077C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: function ordering: pool refcounting
has been removed from the -mm tree.  Its filename was
     mm-zswap-function-ordering-pool-refcounting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: function ordering: pool refcounting
Date: Mon, 29 Jan 2024 20:36:47 -0500

Move pool refcounting functions into the pool section. First the
destroy functions, then the get and put which uses them.

__zswap_pool_empty() has an upward reference to the global
zswap_pools, to sanity check it's not the currently active pool that's
being freed. That gets the forward decl for zswap_pool_current().

This puts the get and put function above all callers, so kill the
forward decls as well.

Link: https://lkml.kernel.org/r/20240130014208.565554-12-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
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
@@ -1121,51 +1166,6 @@ resched:
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


