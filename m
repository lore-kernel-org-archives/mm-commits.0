Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0A52904
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560129; cv=none; b=i1oEU66Nx813dxp04XrDYqrJMUYMF2aJhPwWYsz+6PUbl+QOtZwUZPj1bIKTBmCiAoNPPH7crRYDXf659aZ0EsulJ8wc0bt8yDwecHSqZ40VhiG7qpSn363OSMM69BrniutttrsAV/DQKfcEMFbE5yhZWPTnwWzxPJ1MnBvNCDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560129; c=relaxed/simple;
	bh=87inFCVKD9ikk9dB70K/ALsWrlqEhB9Zmyxe8uWQv8w=;
	h=Date:To:From:Subject:Message-Id; b=AZ2PoWAJjAHV81nwykoTZAV4eZmlsWsSDIkZ2UdGMOTaNg0sutvTQMz7jhk3aAyNfkgEszxz3OORxkraMQREz6fc3MAgvw4lxEQEMb6rN9+4P4VHJOayl1Qc7l8uQDJCiPLqnQCSZYqNisXdjbyO+38AJEY/NWHuVALxFymtIGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rnVKrXg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rnVKrXg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80773C433F1;
	Thu, 22 Feb 2024 00:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560129;
	bh=87inFCVKD9ikk9dB70K/ALsWrlqEhB9Zmyxe8uWQv8w=;
	h=Date:To:From:Subject:From;
	b=rnVKrXg5r0eCglPMqJJVXMb3K3MSsgV9oPB0NE54rHjnzhgZkXThcVAjiNbGV4yjH
	 53Z6lsU1Mn0Wip8Z17PJy7P3BqSbiuAb7+Fj1My5f/SZfmAFjwCqVFnmbCeguMDwwL
	 FxwREpUSWHigtfi3KqS80qjh8Tr5/hBMuU2BA5E4=
Date: Wed, 21 Feb 2024 16:02:08 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-function-ordering-shrink_memcg_cb.patch removed from -mm tree
Message-Id: <20240222000209.80773C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: function ordering: shrink_memcg_cb
has been removed from the -mm tree.  Its filename was
     mm-zswap-function-ordering-shrink_memcg_cb.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: function ordering: shrink_memcg_cb
Date: Mon, 29 Jan 2024 20:36:56 -0500

shrink_memcg_cb() is called by the shrinker and is based on
zswap_writeback_entry(). Move it in between. Save one fwd decl.

Link: https://lkml.kernel.org/r/20240130014208.565554-21-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |  125 ++++++++++++++++++++++++---------------------------
 1 file changed, 61 insertions(+), 64 deletions(-)

--- a/mm/zswap.c~mm-zswap-function-ordering-shrink_memcg_cb
+++ a/mm/zswap.c
@@ -1254,7 +1254,67 @@ static int zswap_writeback_entry(struct
 * shrinker functions
 **********************************/
 static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_one *l,
-				       spinlock_t *lock, void *arg);
+				       spinlock_t *lock, void *arg)
+{
+	struct zswap_entry *entry = container_of(item, struct zswap_entry, lru);
+	bool *encountered_page_in_swapcache = (bool *)arg;
+	swp_entry_t swpentry;
+	enum lru_status ret = LRU_REMOVED_RETRY;
+	int writeback_result;
+
+	/*
+	 * Rotate the entry to the tail before unlocking the LRU,
+	 * so that in case of an invalidation race concurrent
+	 * reclaimers don't waste their time on it.
+	 *
+	 * If writeback succeeds, or failure is due to the entry
+	 * being invalidated by the swap subsystem, the invalidation
+	 * will unlink and free it.
+	 *
+	 * Temporary failures, where the same entry should be tried
+	 * again immediately, almost never happen for this shrinker.
+	 * We don't do any trylocking; -ENOMEM comes closest,
+	 * but that's extremely rare and doesn't happen spuriously
+	 * either. Don't bother distinguishing this case.
+	 *
+	 * But since they do exist in theory, the entry cannot just
+	 * be unlinked, or we could leak it. Hence, rotate.
+	 */
+	list_move_tail(item, &l->list);
+
+	/*
+	 * Once the lru lock is dropped, the entry might get freed. The
+	 * swpentry is copied to the stack, and entry isn't deref'd again
+	 * until the entry is verified to still be alive in the tree.
+	 */
+	swpentry = entry->swpentry;
+
+	/*
+	 * It's safe to drop the lock here because we return either
+	 * LRU_REMOVED_RETRY or LRU_RETRY.
+	 */
+	spin_unlock(lock);
+
+	writeback_result = zswap_writeback_entry(entry, swpentry);
+
+	if (writeback_result) {
+		zswap_reject_reclaim_fail++;
+		ret = LRU_RETRY;
+
+		/*
+		 * Encountering a page already in swap cache is a sign that we are shrinking
+		 * into the warmer region. We should terminate shrinking (if we're in the dynamic
+		 * shrinker context).
+		 */
+		if (writeback_result == -EEXIST && encountered_page_in_swapcache)
+			*encountered_page_in_swapcache = true;
+	} else {
+		zswap_written_back_pages++;
+	}
+
+	spin_lock(lock);
+	return ret;
+}
 
 static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 		struct shrink_control *sc)
@@ -1354,69 +1414,6 @@ static void zswap_alloc_shrinker(struct
 	pool->shrinker->seeks = DEFAULT_SEEKS;
 }
 
-static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_one *l,
-				       spinlock_t *lock, void *arg)
-{
-	struct zswap_entry *entry = container_of(item, struct zswap_entry, lru);
-	bool *encountered_page_in_swapcache = (bool *)arg;
-	swp_entry_t swpentry;
-	enum lru_status ret = LRU_REMOVED_RETRY;
-	int writeback_result;
-
-	/*
-	 * Rotate the entry to the tail before unlocking the LRU,
-	 * so that in case of an invalidation race concurrent
-	 * reclaimers don't waste their time on it.
-	 *
-	 * If writeback succeeds, or failure is due to the entry
-	 * being invalidated by the swap subsystem, the invalidation
-	 * will unlink and free it.
-	 *
-	 * Temporary failures, where the same entry should be tried
-	 * again immediately, almost never happen for this shrinker.
-	 * We don't do any trylocking; -ENOMEM comes closest,
-	 * but that's extremely rare and doesn't happen spuriously
-	 * either. Don't bother distinguishing this case.
-	 *
-	 * But since they do exist in theory, the entry cannot just
-	 * be unlinked, or we could leak it. Hence, rotate.
-	 */
-	list_move_tail(item, &l->list);
-
-	/*
-	 * Once the lru lock is dropped, the entry might get freed. The
-	 * swpentry is copied to the stack, and entry isn't deref'd again
-	 * until the entry is verified to still be alive in the tree.
-	 */
-	swpentry = entry->swpentry;
-
-	/*
-	 * It's safe to drop the lock here because we return either
-	 * LRU_REMOVED_RETRY or LRU_RETRY.
-	 */
-	spin_unlock(lock);
-
-	writeback_result = zswap_writeback_entry(entry, swpentry);
-
-	if (writeback_result) {
-		zswap_reject_reclaim_fail++;
-		ret = LRU_RETRY;
-
-		/*
-		 * Encountering a page already in swap cache is a sign that we are shrinking
-		 * into the warmer region. We should terminate shrinking (if we're in the dynamic
-		 * shrinker context).
-		 */
-		if (writeback_result == -EEXIST && encountered_page_in_swapcache)
-			*encountered_page_in_swapcache = true;
-	} else {
-		zswap_written_back_pages++;
-	}
-
-	spin_lock(lock);
-	return ret;
-}
-
 static int shrink_memcg(struct mem_cgroup *memcg)
 {
 	struct zswap_pool *pool;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


