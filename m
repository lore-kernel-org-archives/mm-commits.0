Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF794C60E
	for <mm-commits@vger.kernel.org>; Mon, 29 Jan 2024 06:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706509303; cv=none; b=tQcW0sgc8sYQ6IdAieRNQbnOwNsKW4AAeMI+GFLHauiCaXib2mK/k7dVyFHO/M+jCJtfBsk8ANPWsJMVY/cg0f4bI2mgueLliAR0BuG41iusEevTr8GVbPZYuj7XKmrObj0IHfAPj5CjO4GDSZ40zjPlM7Qb/2Cwni80iSwf60s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706509303; c=relaxed/simple;
	bh=2rl5qc6bl2iq4mO2gW5KmiKMNWx4rJVH8P4RDYnY0m4=;
	h=Date:To:From:Subject:Message-Id; b=prlwFonXHL5VefVkd8JCxmvl1YT56hB1x+BQMczGibc9BE5wa7yzwZ8HsLEiiyh6dDLFcyy2WwTku3D9B9rhlDWRyn9jQgd/MN1knn1ASyzm/QJGm1pma/kDhAiTRwaOiWyjF3qpf3ujn7ukhXr+MlWF52DtNHnaPayibyZ00Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NhOxfWGY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NhOxfWGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3401C433C7;
	Mon, 29 Jan 2024 06:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706509302;
	bh=2rl5qc6bl2iq4mO2gW5KmiKMNWx4rJVH8P4RDYnY0m4=;
	h=Date:To:From:Subject:From;
	b=NhOxfWGYWBI+sh/UMnDg+KH7EKJni4HCgvKzHUMH95RS8PGOII0nQHUDjUcbEP0aQ
	 yTzD+rZpI+n3X6+GwKi1l5/H121z6SIzxh+LwAQcI1r0AbLge2w1hTSGPAd4VqUEBW
	 ZRydd9mbkzObEOn+qGlLHKbsL73RwtjYNAuUIqFg=
Date: Sun, 28 Jan 2024 22:21:39 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,chriscli@google.com,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-race-between-lru-writeback-and-swapoff.patch added to mm-unstable branch
Message-Id: <20240129062141.F3401C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: fix race between lru writeback and swapoff
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-fix-race-between-lru-writeback-and-swapoff.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-fix-race-between-lru-writeback-and-swapoff.patch

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
Subject: mm/zswap: fix race between lru writeback and swapoff
Date: Sun, 28 Jan 2024 13:28:50 +0000

LRU writeback has race problem with swapoff, as spotted by Yosry [1]:

CPU1			CPU2
shrink_memcg_cb		swap_off
  list_lru_isolate	  zswap_invalidate
			  zswap_swapoff
			    kfree(tree)
  // UAF
  spin_lock(&tree->lock)

The problem is that the entry in lru list can't protect the tree from
being swapoff and freed, and the entry also can be invalidated and freed
concurrently after we unlock the lru lock.

We can fix it by moving the swap cache allocation ahead before referencing
the tree, then check invalidate race with tree lock, only after that we
can safely deref the entry.  Note we couldn't deref entry or tree anymore
after we unlock the folio, since we depend on this to hold on swapoff.

So this patch moves all tree and entry usage to zswap_writeback_entry(),
we only use the copied swpentry on the stack to allocate swap cache and if
returned with folio locked we can reference the tree safely.  Then we can
check invalidate race with tree lock, the following things is much the
same like zswap_load().

Since we can't deref the entry after zswap_writeback_entry(), we can't use
zswap_lru_putback() anymore, instead we rotate the entry in the beginning.
And it will be unlinked and freed when invalidated if writeback success.

Another change is we don't update the memcg nr_zswap_protected in the
-ENOMEM and -EEXIST cases anymore.  -EEXIST case means we raced with
swapin or concurrent shrinker action, since swapin already have memcg
nr_zswap_protected updated, don't need double counts here.  For concurrent
shrinker, the folio will be writeback and freed anyway.  -ENOMEM case is
extremely rare and doesn't happen spuriously either, so don't bother
distinguishing this case.

[1] https://lore.kernel.org/all/CAJD7tkasHsRnT_75-TXsEe58V9_OW6m3g6CF7Kmsvz8CKRG_EA@mail.gmail.com/

Link: https://lkml.kernel.org/r/20240126-zswap-writeback-race-v2-2-b10479847099@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Li <chriscli@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |  114 +++++++++++++++++++++------------------------------
 1 file changed, 49 insertions(+), 65 deletions(-)

--- a/mm/zswap.c~mm-zswap-fix-race-between-lru-writeback-and-swapoff
+++ a/mm/zswap.c
@@ -277,7 +277,7 @@ static inline struct zswap_tree *swap_zs
 		 zpool_get_type((p)->zpools[0]))
 
 static int zswap_writeback_entry(struct zswap_entry *entry,
-				 struct zswap_tree *tree);
+				 swp_entry_t swpentry);
 static int zswap_pool_get(struct zswap_pool *pool);
 static void zswap_pool_put(struct zswap_pool *pool);
 
@@ -445,27 +445,6 @@ static void zswap_lru_del(struct list_lr
 	rcu_read_unlock();
 }
 
-static void zswap_lru_putback(struct list_lru *list_lru,
-		struct zswap_entry *entry)
-{
-	int nid = entry_to_nid(entry);
-	spinlock_t *lock = &list_lru->node[nid].lock;
-	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
-
-	rcu_read_lock();
-	memcg = mem_cgroup_from_entry(entry);
-	spin_lock(lock);
-	/* we cannot use list_lru_add here, because it increments node's lru count */
-	list_lru_putback(list_lru, &entry->lru, nid, memcg);
-	spin_unlock(lock);
-
-	lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(entry_to_nid(entry)));
-	/* increment the protection area to account for the LRU rotation. */
-	atomic_long_inc(&lruvec->zswap_lruvec_state.nr_zswap_protected);
-	rcu_read_unlock();
-}
-
 /*********************************
 * rbtree functions
 **********************************/
@@ -860,40 +839,47 @@ static enum lru_status shrink_memcg_cb(s
 {
 	struct zswap_entry *entry = container_of(item, struct zswap_entry, lru);
 	bool *encountered_page_in_swapcache = (bool *)arg;
-	struct zswap_tree *tree;
-	pgoff_t swpoffset;
+	swp_entry_t swpentry;
 	enum lru_status ret = LRU_REMOVED_RETRY;
 	int writeback_result;
 
 	/*
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
 	 * Once the lru lock is dropped, the entry might get freed. The
-	 * swpoffset is copied to the stack, and entry isn't deref'd again
+	 * swpentry is copied to the stack, and entry isn't deref'd again
 	 * until the entry is verified to still be alive in the tree.
 	 */
-	swpoffset = swp_offset(entry->swpentry);
-	tree = swap_zswap_tree(entry->swpentry);
-	list_lru_isolate(l, item);
+	swpentry = entry->swpentry;
+
 	/*
 	 * It's safe to drop the lock here because we return either
 	 * LRU_REMOVED_RETRY or LRU_RETRY.
 	 */
 	spin_unlock(lock);
 
-	/* Check for invalidate() race */
-	spin_lock(&tree->lock);
-	if (entry != zswap_rb_search(&tree->rbroot, swpoffset))
-		goto unlock;
-
-	/* Hold a reference to prevent a free during writeback */
-	zswap_entry_get(entry);
-	spin_unlock(&tree->lock);
-
-	writeback_result = zswap_writeback_entry(entry, tree);
+	writeback_result = zswap_writeback_entry(entry, swpentry);
 
-	spin_lock(&tree->lock);
 	if (writeback_result) {
 		zswap_reject_reclaim_fail++;
-		zswap_lru_putback(&entry->pool->list_lru, entry);
 		ret = LRU_RETRY;
 
 		/*
@@ -903,27 +889,10 @@ static enum lru_status shrink_memcg_cb(s
 		 */
 		if (writeback_result == -EEXIST && encountered_page_in_swapcache)
 			*encountered_page_in_swapcache = true;
-
-		goto put_unlock;
+	} else {
+		zswap_written_back_pages++;
 	}
-	zswap_written_back_pages++;
 
-	if (entry->objcg)
-		count_objcg_event(entry->objcg, ZSWPWB);
-
-	count_vm_event(ZSWPWB);
-	/*
-	 * Writeback started successfully, the page now belongs to the
-	 * swapcache. Drop the entry from zswap - unless invalidate already
-	 * took it out while we had the tree->lock released for IO.
-	 */
-	zswap_invalidate_entry(tree, entry);
-
-put_unlock:
-	/* Drop local reference */
-	zswap_entry_put(entry);
-unlock:
-	spin_unlock(&tree->lock);
 	spin_lock(lock);
 	return ret;
 }
@@ -1408,9 +1377,9 @@ static void __zswap_load(struct zswap_en
  * freed.
  */
 static int zswap_writeback_entry(struct zswap_entry *entry,
-				 struct zswap_tree *tree)
+				 swp_entry_t swpentry)
 {
-	swp_entry_t swpentry = entry->swpentry;
+	struct zswap_tree *tree;
 	struct folio *folio;
 	struct mempolicy *mpol;
 	bool folio_was_allocated;
@@ -1426,9 +1395,11 @@ static int zswap_writeback_entry(struct
 		return -ENOMEM;
 
 	/*
-	 * Found an existing folio, we raced with load/swapin. We generally
-	 * writeback cold folios from zswap, and swapin means the folio just
-	 * became hot. Skip this folio and let the caller find another one.
+	 * Found an existing folio, we raced with swapin or concurrent
+	 * shrinker. We generally writeback cold folios from zswap, and
+	 * swapin means the folio just became hot, so skip this folio.
+	 * For unlikely concurrent shrinker case, it will be unlinked
+	 * and freed when invalidated by the concurrent shrinker anyway.
 	 */
 	if (!folio_was_allocated) {
 		folio_put(folio);
@@ -1442,18 +1413,31 @@ static int zswap_writeback_entry(struct
 	 * backs (our zswap_entry reference doesn't prevent that), to
 	 * avoid overwriting a new swap folio with old compressed data.
 	 */
+	tree = swap_zswap_tree(swpentry);
 	spin_lock(&tree->lock);
-	if (zswap_rb_search(&tree->rbroot, swp_offset(entry->swpentry)) != entry) {
+	if (zswap_rb_search(&tree->rbroot, swp_offset(swpentry)) != entry) {
 		spin_unlock(&tree->lock);
 		delete_from_swap_cache(folio);
 		folio_unlock(folio);
 		folio_put(folio);
 		return -ENOMEM;
 	}
+
+	/* Safe to deref entry after the entry is verified above. */
+	zswap_entry_get(entry);
 	spin_unlock(&tree->lock);
 
 	__zswap_load(entry, &folio->page);
 
+	count_vm_event(ZSWPWB);
+	if (entry->objcg)
+		count_objcg_event(entry->objcg, ZSWPWB);
+
+	spin_lock(&tree->lock);
+	zswap_invalidate_entry(tree, entry);
+	zswap_entry_put(entry);
+	spin_unlock(&tree->lock);
+
 	/* folio is up to date */
 	folio_mark_uptodate(folio);
 
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-make-sure-each-swapfile-always-have-zswap-rb-tree.patch
mm-zswap-split-zswap-rb-tree.patch
mm-zswap-dont-return-lru_skip-if-we-have-dropped-lru-lock.patch
mm-zswap-fix-race-between-lru-writeback-and-swapoff.patch
mm-list_lru-remove-list_lru_putback.patch

