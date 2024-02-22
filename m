Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE374A18
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560125; cv=none; b=I8yB72IfOhD8Ur7WGDCqA4Wzz+C1ajWiRDJyEKIeQJaeNolNyMfNpgEn1o3ezAVI23QRs/fZosAGYgvkNxb7tNQWhTy2c1vCGxRE9q+q7U/42ZH5hkESKw0P9eOo0o0+GSyOXj1jvz+1loP2Q3ve9nGuSF5buuKi/4iaCDGmyFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560125; c=relaxed/simple;
	bh=g9iQr81by1ENJVxpXJS3g3UhLVvmpZG6XLuD/X6SM9I=;
	h=Date:To:From:Subject:Message-Id; b=tfWhr4ZzRj3MIPEA7VOnx6uryRyDBD42E8zPPMTOScQsyUa+vd8hNO3bDBNEnooQSSjk/Vb1d5V5eEQh897JWjRb+Cz8h7YkAP3LFl4HvI38Wivb1OWstdXrm63r7YwVPQykMNB5p3guBsQGW5O/QGCXbGJadqSosvhS8FMZYoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CeRQz/4W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CeRQz/4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21071C43390;
	Thu, 22 Feb 2024 00:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560125;
	bh=g9iQr81by1ENJVxpXJS3g3UhLVvmpZG6XLuD/X6SM9I=;
	h=Date:To:From:Subject:From;
	b=CeRQz/4WwoBE1aEfaJ/+m8qDVlwnSfvwyGo9ZHDMG/FXHrJEqMx9smv19o/wTtR7L
	 QZhNZi28lB9HQF6ObhhdN/bQE8fZUYIo0EagKf6qSZT1NcHEqVhdz9Achn4A71VSb4
	 KVECmnyT4tj6G2+SnOo/K25xiHMX/8H8ueT46RLs=
Date: Wed, 21 Feb 2024 16:02:04 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-function-ordering-move-entry-sections-out-of-lru-section.patch removed from -mm tree
Message-Id: <20240222000205.21071C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: function ordering: move entry sections out of LRU section
has been removed from the -mm tree.  Its filename was
     mm-zswap-function-ordering-move-entry-sections-out-of-lru-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: function ordering: move entry sections out of LRU section
Date: Mon, 29 Jan 2024 20:36:51 -0500

This completes consolidation of the LRU section.

Link: https://lkml.kernel.org/r/20240130014208.565554-16-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
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


