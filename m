Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DB4381B4
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706596923; cv=none; b=JIvaHpumxwfsFlQl5GVaicWYKs7FFI7e+5g8IKwFsQV9d48czn2lzSz4wThxJelgv+F93QXDumi+nPetwHiTUhBSfV5n4OrpTV6CK5C8iwb3pkZoOyBz+QIVl7L0MPItHrKxHcB8wLiqOmHWIphwthqG52Jgs9fAYayTVQhPgOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706596923; c=relaxed/simple;
	bh=NLFUIy32hM136HdA+DE+yf/qlq0Y1OuGIXk6dCpRdNo=;
	h=Date:To:From:Subject:Message-Id; b=sZaDqHnCDaqLBQXDx3+05iOn4b21MGidiIyV9nWxfrBOOZYNzheaNCIDv6Ts9YmmfoNono1G/nGHpLh8dUHlXDNEpHhft4iHHNRVJn3XZnpcIYAGEX9NXs1GBUa8Iraf2DO0cXcm/bOWnc5azVnii1jYrWffvUiy8if3PwWuzBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MRsGc25W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MRsGc25W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358CDC433C7;
	Tue, 30 Jan 2024 06:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706596923;
	bh=NLFUIy32hM136HdA+DE+yf/qlq0Y1OuGIXk6dCpRdNo=;
	h=Date:To:From:Subject:From;
	b=MRsGc25WvxxBXMto8CDb+LJanvFT+9DBnFXBpLF5sma80aDZ+BKFPihyKk6M5w4Lo
	 o6roZ+k8j8veQ66moQjO38+bB1FY6UvsSal1Y0xF9+dtHbCMOAP8Nz3AFJEv9uGBH9
	 myJZoBYj1J0KLaIeU/TWcVW/tO3AeAv0Zj9i6euQ=
Date: Mon, 29 Jan 2024 22:41:49 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-function-ordering-zswap_pools.patch added to mm-unstable branch
Message-Id: <20240130064201.358CDC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: function ordering: zswap_pools
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-function-ordering-zswap_pools.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-function-ordering-zswap_pools.patch

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
Subject: mm: zswap: function ordering: zswap_pools
Date: Mon, 29 Jan 2024 20:36:48 -0500

Move the operations against the global zswap_pools list (current pool,
last, find) to the pool section.

Link: https://lkml.kernel.org/r/20240130014208.565554-13-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
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
@@ -938,83 +1011,6 @@ static int zswap_cpu_comp_dead(unsigned
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

