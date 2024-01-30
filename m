Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80AB38DE8
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706596973; cv=none; b=lX9oPyqTLa45abaooT5fBuw93rBwY5mT0/LzIOGmcSfcqV6wPeYb1JEeuZ0FHNAxPxyzxscDSAqKgQuyTF01GrO4kwM/d8dbv7YMaoTpuPWoGSQcekR3cljvkXP3oKSWYYvnMQGUW/9eezFb33acB15t14m0eXogYys1z94M//c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706596973; c=relaxed/simple;
	bh=+annadYu/lk/A3uPZh+m2fBww/q8tAC/PukItrhhxws=;
	h=Date:To:From:Subject:Message-Id; b=SyrWsW9QqiBtO5vVDZHU7HvhZtjGEV282VvPzY3rPYMXg1wZ/0A9nxC6gyzzy+7nuPLPW5frZOEIzCbsu93WnMEgMZuEj1QQjWTaBu47pSOB6WJbfuJz+FaCqS4EXV4n7ZooQMeo/cd9mzkXKMIXE2NfkWbkRl2wLxBNAuvrxg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nvSbBenu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nvSbBenu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF589C433F1;
	Tue, 30 Jan 2024 06:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706596973;
	bh=+annadYu/lk/A3uPZh+m2fBww/q8tAC/PukItrhhxws=;
	h=Date:To:From:Subject:From;
	b=nvSbBenu5V5fH7TfwF05Insbuj8gh0dpbrr0VZuQceOfenkwBU6z2EyPA+QdMZDea
	 Pr+lsoi49E8s867jS6Wu0ybNm11DIWd76mmvF9FDO0nehgOePt75djedsUfE551Ijz
	 xzQrtlx/gPActN7CoRYXOWXUDyhoKJnziKYUKXkA=
Date: Mon, 29 Jan 2024 22:42:33 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-function-ordering-move-entry-sections-out-of-lru-section.patch added to mm-unstable branch
Message-Id: <20240130064251.EF589C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: function ordering: move entry sections out of LRU section
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-function-ordering-move-entry-sections-out-of-lru-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-function-ordering-move-entry-sections-out-of-lru-section.patch

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
Subject: mm: zswap: function ordering: move entry sections out of LRU section
Date: Mon, 29 Jan 2024 20:36:51 -0500

This completes consolidation of the LRU section.

Link: https://lkml.kernel.org/r/20240130014208.565554-16-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |  101 ++++++++++++++++++++++++---------------------------
 1 file changed, 49 insertions(+), 52 deletions(-)

--- a/mm/zswap.c~mm-zswap-function-ordering-move-entry-sections-out-of-lru-section
+++ a/mm/zswap.c
@@ -768,58 +768,6 @@ static inline int entry_to_nid(struct zs
 	return page_to_nid(virt_to_page(entry));
 }
 
-void zswap_lruvec_state_init(struct lruvec *lruvec)
-{
-	atomic_long_set(&lruvec->zswap_lruvec_state.nr_zswap_protected, 0);
-}
-
-void zswap_folio_swapin(struct folio *folio)
-{
-	struct lruvec *lruvec;
-
-	if (folio) {
-		lruvec = folio_lruvec(folio);
-		atomic_long_inc(&lruvec->zswap_lruvec_state.nr_zswap_protected);
-	}
-}
-
-void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg)
-{
-	struct zswap_pool *pool;
-
-	/* lock out zswap pools list modification */
-	spin_lock(&zswap_pools_lock);
-	list_for_each_entry(pool, &zswap_pools, list) {
-		if (pool->next_shrink == memcg)
-			pool->next_shrink = mem_cgroup_iter(NULL, pool->next_shrink, NULL);
-	}
-	spin_unlock(&zswap_pools_lock);
-}
-
-/*********************************
-* zswap entry functions
-**********************************/
-static struct kmem_cache *zswap_entry_cache;
-
-static struct zswap_entry *zswap_entry_cache_alloc(gfp_t gfp, int nid)
-{
-	struct zswap_entry *entry;
-	entry = kmem_cache_alloc_node(zswap_entry_cache, gfp, nid);
-	if (!entry)
-		return NULL;
-	entry->refcount = 1;
-	RB_CLEAR_NODE(&entry->rbnode);
-	return entry;
-}
-
-static void zswap_entry_cache_free(struct zswap_entry *entry)
-{
-	kmem_cache_free(zswap_entry_cache, entry);
-}
-
-/*********************************
-* lru functions
-**********************************/
 static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entry *entry)
 {
 	atomic_long_t *nr_zswap_protected;
@@ -872,6 +820,55 @@ static void zswap_lru_del(struct list_lr
 	rcu_read_unlock();
 }
 
+void zswap_lruvec_state_init(struct lruvec *lruvec)
+{
+	atomic_long_set(&lruvec->zswap_lruvec_state.nr_zswap_protected, 0);
+}
+
+void zswap_folio_swapin(struct folio *folio)
+{
+	struct lruvec *lruvec;
+
+	if (folio) {
+		lruvec = folio_lruvec(folio);
+		atomic_long_inc(&lruvec->zswap_lruvec_state.nr_zswap_protected);
+	}
+}
+
+void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg)
+{
+	struct zswap_pool *pool;
+
+	/* lock out zswap pools list modification */
+	spin_lock(&zswap_pools_lock);
+	list_for_each_entry(pool, &zswap_pools, list) {
+		if (pool->next_shrink == memcg)
+			pool->next_shrink = mem_cgroup_iter(NULL, pool->next_shrink, NULL);
+	}
+	spin_unlock(&zswap_pools_lock);
+}
+
+/*********************************
+* zswap entry functions
+**********************************/
+static struct kmem_cache *zswap_entry_cache;
+
+static struct zswap_entry *zswap_entry_cache_alloc(gfp_t gfp, int nid)
+{
+	struct zswap_entry *entry;
+	entry = kmem_cache_alloc_node(zswap_entry_cache, gfp, nid);
+	if (!entry)
+		return NULL;
+	entry->refcount = 1;
+	RB_CLEAR_NODE(&entry->rbnode);
+	return entry;
+}
+
+static void zswap_entry_cache_free(struct zswap_entry *entry)
+{
+	kmem_cache_free(zswap_entry_cache, entry);
+}
+
 /*********************************
 * rbtree functions
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

