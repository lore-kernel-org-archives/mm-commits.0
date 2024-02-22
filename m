Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDF38480
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560123; cv=none; b=fmd2KuSgWAoZdRjytbCXSCEDva2bRzIjTlvledHBnSUs2/l6NTxD3xPPQ0vcxvyvEbvUn9nVewuQPE5Pq1nPnNmZWeStoWIltMzxWuIi7kwQY7FH5Sh+ObNI7EQ8Am4l16OE/PhR4Dj9VGNzvm3MrYxHkp1XhRYsM/jcU7js4hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560123; c=relaxed/simple;
	bh=T9hvXgs025a6GwTsjvXh5fpO6AhbBPek7tDVHrMuffo=;
	h=Date:To:From:Subject:Message-Id; b=tROpKEP//Z8nazgSw+7VvIhRZqLL0y/h9KeZdkDQzWdgO9oyPK1uhvJW+aJXmC/cvqPjYNbm9H/jzf8VYomPMN0LjQRNw9FWr1gmAI4e/9wfYzTA+gqipwMoRpUoWvPyPg2rIaBrGN7X0cjJDlYwexUtU/F5iHMwNDk+nvLh0SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zcsr4HO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zcsr4HO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E1EC433C7;
	Thu, 22 Feb 2024 00:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560122;
	bh=T9hvXgs025a6GwTsjvXh5fpO6AhbBPek7tDVHrMuffo=;
	h=Date:To:From:Subject:From;
	b=Zcsr4HO194BrnWYGKna9RTCt/emaPc9MOrfk9x3ehPlnqU7tfA0Mxj9q2sexHaz3z
	 EMx+8Wizw6XTE2KEwkSiJJ/GJjlGkoI2Zd7WIscSxE12XLl7gqR1AqvMM/srAgAX+1
	 Ie6DPy6wenatYOvNj7LF3LbdzfHOaO7NeNUMUT5Q=
Date: Wed, 21 Feb 2024 16:02:02 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-function-ordering-zswap_pools.patch removed from -mm tree
Message-Id: <20240222000202.95E1EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: function ordering: zswap_pools
has been removed from the -mm tree.  Its filename was
     mm-zswap-function-ordering-zswap_pools.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: function ordering: zswap_pools
Date: Mon, 29 Jan 2024 20:36:48 -0500

Move the operations against the global zswap_pools list (current pool,
last, find) to the pool section.

Link: https://lkml.kernel.org/r/20240130014208.565554-13-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |  150 ++++++++++++++++++++++++---------------------------
 1 file changed, 73 insertions(+), 77 deletions(-)

--- a/mm/zswap.c~mm-zswap-function-ordering-zswap_pools
+++ a/mm/zswap.c
@@ -517,6 +517,79 @@ static void zswap_pool_put(struct zswap_
 	kref_put(&pool->kref, __zswap_pool_empty);
 }
 
+static struct zswap_pool *__zswap_pool_current(void)
+{
+	struct zswap_pool *pool;
+
+	pool = list_first_or_null_rcu(&zswap_pools, typeof(*pool), list);
+	WARN_ONCE(!pool && zswap_has_pool,
+		  "%s: no page storage pool!\n", __func__);
+
+	return pool;
+}
+
+static struct zswap_pool *zswap_pool_current(void)
+{
+	assert_spin_locked(&zswap_pools_lock);
+
+	return __zswap_pool_current();
+}
+
+static struct zswap_pool *zswap_pool_current_get(void)
+{
+	struct zswap_pool *pool;
+
+	rcu_read_lock();
+
+	pool = __zswap_pool_current();
+	if (!zswap_pool_get(pool))
+		pool = NULL;
+
+	rcu_read_unlock();
+
+	return pool;
+}
+
+static struct zswap_pool *zswap_pool_last_get(void)
+{
+	struct zswap_pool *pool, *last = NULL;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(pool, &zswap_pools, list)
+		last = pool;
+	WARN_ONCE(!last && zswap_has_pool,
+		  "%s: no page storage pool!\n", __func__);
+	if (!zswap_pool_get(last))
+		last = NULL;
+
+	rcu_read_unlock();
+
+	return last;
+}
+
+/* type and compressor must be null-terminated */
+static struct zswap_pool *zswap_pool_find_get(char *type, char *compressor)
+{
+	struct zswap_pool *pool;
+
+	assert_spin_locked(&zswap_pools_lock);
+
+	list_for_each_entry_rcu(pool, &zswap_pools, list) {
+		if (strcmp(pool->tfm_name, compressor))
+			continue;
+		/* all zpools share the same type */
+		if (strcmp(zpool_get_type(pool->zpools[0]), type))
+			continue;
+		/* if we can't get it, it's about to be destroyed */
+		if (!zswap_pool_get(pool))
+			continue;
+		return pool;
+	}
+
+	return NULL;
+}
+
 /* should be called under RCU */
 #ifdef CONFIG_MEMCG
 static inline struct mem_cgroup *mem_cgroup_from_entry(struct zswap_entry *entry)
@@ -937,83 +1010,6 @@ static int zswap_cpu_comp_dead(unsigned
 	return 0;
 }
 
-/*********************************
-* pool functions
-**********************************/
-
-static struct zswap_pool *__zswap_pool_current(void)
-{
-	struct zswap_pool *pool;
-
-	pool = list_first_or_null_rcu(&zswap_pools, typeof(*pool), list);
-	WARN_ONCE(!pool && zswap_has_pool,
-		  "%s: no page storage pool!\n", __func__);
-
-	return pool;
-}
-
-static struct zswap_pool *zswap_pool_current(void)
-{
-	assert_spin_locked(&zswap_pools_lock);
-
-	return __zswap_pool_current();
-}
-
-static struct zswap_pool *zswap_pool_current_get(void)
-{
-	struct zswap_pool *pool;
-
-	rcu_read_lock();
-
-	pool = __zswap_pool_current();
-	if (!zswap_pool_get(pool))
-		pool = NULL;
-
-	rcu_read_unlock();
-
-	return pool;
-}
-
-static struct zswap_pool *zswap_pool_last_get(void)
-{
-	struct zswap_pool *pool, *last = NULL;
-
-	rcu_read_lock();
-
-	list_for_each_entry_rcu(pool, &zswap_pools, list)
-		last = pool;
-	WARN_ONCE(!last && zswap_has_pool,
-		  "%s: no page storage pool!\n", __func__);
-	if (!zswap_pool_get(last))
-		last = NULL;
-
-	rcu_read_unlock();
-
-	return last;
-}
-
-/* type and compressor must be null-terminated */
-static struct zswap_pool *zswap_pool_find_get(char *type, char *compressor)
-{
-	struct zswap_pool *pool;
-
-	assert_spin_locked(&zswap_pools_lock);
-
-	list_for_each_entry_rcu(pool, &zswap_pools, list) {
-		if (strcmp(pool->tfm_name, compressor))
-			continue;
-		/* all zpools share the same type */
-		if (strcmp(zpool_get_type(pool->zpools[0]), type))
-			continue;
-		/* if we can't get it, it's about to be destroyed */
-		if (!zswap_pool_get(pool))
-			continue;
-		return pool;
-	}
-
-	return NULL;
-}
-
 static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_one *l,
 				       spinlock_t *lock, void *arg)
 {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


