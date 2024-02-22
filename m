Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CBF17981
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560198; cv=none; b=Oo8J27hTI9ceXo1Nk5V0ToS8Wa+Cd5SvjtdHLAZP4Il7OS7M3AvwRMmaMM4Rd+1h94pBTXooIM8DeHD7r029b07gUdnGdtDy0pxJaL/ZvU0yMEOsc9QqptdWmdRG6Xp4LcjbK2DQ55I0KB5BG7XUUDoOcw2UINum23zpdV1Mo9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560198; c=relaxed/simple;
	bh=GhYdvtsX3ZGSQLNwyfkwuy5r/5OCiPHmYRfUud50BaA=;
	h=Date:To:From:Subject:Message-Id; b=MOyVSaQIy5k9KCKlSuRiyQpRb4EzdUISSNG+OWQqUzv/+m8adpY05h25Jb2U1minLRBuKVQylCT/gU2kGBsa6yFWHXZf6DP0KXAKQkU06t6VLWrox4uYuT442fQZDFPmihW5NtB4Q+ilxoUNBC+74QmGtvZQTaDPaKEV9BUjnj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WQ3pM4HV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WQ3pM4HV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A622C43394;
	Thu, 22 Feb 2024 00:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560198;
	bh=GhYdvtsX3ZGSQLNwyfkwuy5r/5OCiPHmYRfUud50BaA=;
	h=Date:To:From:Subject:From;
	b=WQ3pM4HVMNVHK8JganAqOunESFSfbY6S8mDa/6qWi2G8P80gdZqMqaNuf2wA1/Yhw
	 4VRCOjnLEVGNF1wKSyl0oJcTwwPerzNA0+wVeFCH8IkUx1kns8os2CyvT3TlQgwEtm
	 YH3DT37Z8ydf9VoMdVzmeAjCrxFBSTvRpz6Ua048=
Date: Wed, 21 Feb 2024 16:03:17 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-zswap-entry-doesnt-need-refcount-anymore.patch removed from -mm tree
Message-Id: <20240222000318.7A622C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: zswap entry doesn't need refcount anymore
has been removed from the -mm tree.  Its filename was
     mm-zswap-zswap-entry-doesnt-need-refcount-anymore.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: zswap entry doesn't need refcount anymore
Date: Sun, 04 Feb 2024 03:06:04 +0000

Since we don't need to leave zswap entry on the zswap tree anymore,
we should remove it from tree once we find it from the tree.

Then after using it, we can directly free it, no concurrent path
can find it from tree. Only the shrinker can see it from lru list,
which will also double check under tree lock, so no race problem.

So we don't need refcount in zswap entry anymore and don't need to
take the spinlock for the second time to invalidate it.

The side effect is that zswap_entry_free() maybe not happen in tree
spinlock, but it's ok since nothing need to be protected by the lock.

Link: https://lkml.kernel.org/r/20240201-b4-zswap-invalidate-entry-v2-6-99d4084260a0@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   63 ++++++++-------------------------------------------
 1 file changed, 11 insertions(+), 52 deletions(-)

--- a/mm/zswap.c~mm-zswap-zswap-entry-doesnt-need-refcount-anymore
+++ a/mm/zswap.c
@@ -193,12 +193,6 @@ struct zswap_pool {
  *
  * rbnode - links the entry into red-black tree for the appropriate swap type
  * swpentry - associated swap entry, the offset indexes into the red-black tree
- * refcount - the number of outstanding reference to the entry. This is needed
- *            to protect against premature freeing of the entry by code
- *            concurrent calls to load, invalidate, and writeback.  The lock
- *            for the zswap_tree structure that contains the entry must
- *            be held while changing the refcount.  Since the lock must
- *            be held, there is no reason to also make refcount atomic.
  * length - the length in bytes of the compressed page data.  Needed during
  *          decompression. For a same value filled page length is 0, and both
  *          pool and lru are invalid and must be ignored.
@@ -211,7 +205,6 @@ struct zswap_pool {
 struct zswap_entry {
 	struct rb_node rbnode;
 	swp_entry_t swpentry;
-	int refcount;
 	unsigned int length;
 	struct zswap_pool *pool;
 	union {
@@ -222,11 +215,6 @@ struct zswap_entry {
 	struct list_head lru;
 };
 
-/*
- * The tree lock in the zswap_tree struct protects a few things:
- * - the rbtree
- * - the refcount field of each entry in the tree
- */
 struct zswap_tree {
 	struct rb_root rbroot;
 	spinlock_t lock;
@@ -890,14 +878,10 @@ static int zswap_rb_insert(struct rb_roo
 	return 0;
 }
 
-static bool zswap_rb_erase(struct rb_root *root, struct zswap_entry *entry)
+static void zswap_rb_erase(struct rb_root *root, struct zswap_entry *entry)
 {
-	if (!RB_EMPTY_NODE(&entry->rbnode)) {
-		rb_erase(&entry->rbnode, root);
-		RB_CLEAR_NODE(&entry->rbnode);
-		return true;
-	}
-	return false;
+	rb_erase(&entry->rbnode, root);
+	RB_CLEAR_NODE(&entry->rbnode);
 }
 
 /*********************************
@@ -911,7 +895,6 @@ static struct zswap_entry *zswap_entry_c
 	entry = kmem_cache_alloc_node(zswap_entry_cache, gfp, nid);
 	if (!entry)
 		return NULL;
-	entry->refcount = 1;
 	RB_CLEAR_NODE(&entry->rbnode);
 	return entry;
 }
@@ -954,33 +937,15 @@ static void zswap_entry_free(struct zswa
 	zswap_update_total_size();
 }
 
-/* caller must hold the tree lock */
-static void zswap_entry_get(struct zswap_entry *entry)
-{
-	WARN_ON_ONCE(!entry->refcount);
-	entry->refcount++;
-}
-
-/* caller must hold the tree lock */
-static void zswap_entry_put(struct zswap_entry *entry)
-{
-	WARN_ON_ONCE(!entry->refcount);
-	if (--entry->refcount == 0) {
-		WARN_ON_ONCE(!RB_EMPTY_NODE(&entry->rbnode));
-		zswap_entry_free(entry);
-	}
-}
-
 /*
- * If the entry is still valid in the tree, drop the initial ref and remove it
- * from the tree. This function must be called with an additional ref held,
- * otherwise it may race with another invalidation freeing the entry.
+ * The caller hold the tree lock and search the entry from the tree,
+ * so it must be on the tree, remove it from the tree and free it.
  */
 static void zswap_invalidate_entry(struct zswap_tree *tree,
 				   struct zswap_entry *entry)
 {
-	if (zswap_rb_erase(&tree->rbroot, entry))
-		zswap_entry_put(entry);
+	zswap_rb_erase(&tree->rbroot, entry);
+	zswap_entry_free(entry);
 }
 
 /*********************************
@@ -1219,7 +1184,7 @@ static int zswap_writeback_entry(struct
 	}
 
 	/* Safe to deref entry after the entry is verified above. */
-	zswap_entry_get(entry);
+	zswap_rb_erase(&tree->rbroot, entry);
 	spin_unlock(&tree->lock);
 
 	zswap_decompress(entry, &folio->page);
@@ -1228,10 +1193,7 @@ static int zswap_writeback_entry(struct
 	if (entry->objcg)
 		count_objcg_event(entry->objcg, ZSWPWB);
 
-	spin_lock(&tree->lock);
-	zswap_invalidate_entry(tree, entry);
-	zswap_entry_put(entry);
-	spin_unlock(&tree->lock);
+	zswap_entry_free(entry);
 
 	/* folio is up to date */
 	folio_mark_uptodate(folio);
@@ -1703,7 +1665,7 @@ bool zswap_load(struct folio *folio)
 		spin_unlock(&tree->lock);
 		return false;
 	}
-	zswap_entry_get(entry);
+	zswap_rb_erase(&tree->rbroot, entry);
 	spin_unlock(&tree->lock);
 
 	if (entry->length)
@@ -1718,10 +1680,7 @@ bool zswap_load(struct folio *folio)
 	if (entry->objcg)
 		count_objcg_event(entry->objcg, ZSWPIN);
 
-	spin_lock(&tree->lock);
-	zswap_invalidate_entry(tree, entry);
-	zswap_entry_put(entry);
-	spin_unlock(&tree->lock);
+	zswap_entry_free(entry);
 
 	folio_mark_dirty(folio);
 
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zsmalloc-fix-migrate_write_lock-when-config_compaction.patch
mm-zsmalloc-remove-migrate_write_lock_nested.patch
mm-zsmalloc-remove-unused-zspage-isolated.patch
mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools.patch
mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch
mm-zsmalloc-remove-set_zspage_mapping.patch
mm-zsmalloc-remove_zspage-dont-need-fullness-parameter.patch
mm-zsmalloc-remove-get_zspage_mapping.patch
maintainers-add-chengming-zhou-as-a-zswap-reviewer.patch

