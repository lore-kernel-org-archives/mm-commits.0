Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9DC38DF9
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706597061; cv=none; b=WtqIfMytHWqTILvXXIMdXEyZEnXfleel88lx+uKeBkZIBDDuv7Ufc9Xi0NhCXwj2omR178SnnSeA+PQDf1inxhPTgAcaHCg+XZdgm9mhVCTarkOxMJ4e+ldYnpLK1DFi2+iGzWnuXDsVbTUO+yw3PCWzY5JsLKxJxNe+SItI1JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706597061; c=relaxed/simple;
	bh=FScH5b7BYwyUKqafFvJC4BzCMuRvSaHORtTXhclZedE=;
	h=Date:To:From:Subject:Message-Id; b=UiFR2db0MBSifDFrib52tcBoPj5qPAXM/VsnOg5kSNxkWTDXLYO2NaDUcE9WSlzTOuH1IBu5yF6r0S0bFeIBmorSxVL7dQcWTwKfYxSYeGaiVSTJTe71SbLWtrk+GTqUeTsEmQAUmrholrxeVJtWc/7OlGRuGMQht439uPYQ05g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZSyNdh9l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZSyNdh9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D14C433C7;
	Tue, 30 Jan 2024 06:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706597061;
	bh=FScH5b7BYwyUKqafFvJC4BzCMuRvSaHORtTXhclZedE=;
	h=Date:To:From:Subject:From;
	b=ZSyNdh9lQ/N9Y9Mx0uwiscuYW6P0cjoEo9U7uhbatTwcUTP2lb/8EEF+QfNYVjKaP
	 8Jb8to+fzJs0NzVxdzU51LITC2eO46MjzmhLZuHiR+p8oacsHcaJb8wtFmiccMKZpQ
	 X60jlUtUjU2Xo2zBSwYZrkxSSJsRxo/Za16U25DE=
Date: Mon, 29 Jan 2024 22:44:06 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-function-ordering-shrink_memcg_cb.patch added to mm-unstable branch
Message-Id: <20240130064419.C9D14C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: function ordering: shrink_memcg_cb
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-function-ordering-shrink_memcg_cb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-function-ordering-shrink_memcg_cb.patch

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
Subject: mm: zswap: function ordering: shrink_memcg_cb
Date: Mon, 29 Jan 2024 20:36:56 -0500

shrink_memcg_cb() is called by the shrinker and is based on
zswap_writeback_entry(). Move it in between. Save one fwd decl.

Link: https://lkml.kernel.org/r/20240130014208.565554-21-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
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

