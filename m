Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6D02904
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560119; cv=none; b=G7fKjNnmZrJB68QdfYHtsabINInTZcMLoQjR762BPjBJrE4zIoxVxITILGPEMF2rC7L1GlkWq0jpRC/VijfGAg5CSpjS7h0iJrOcF2WHlO1wZB8yKPgrD37crVuU5aB0qpSin0hX0o0nEaJf7Nf3tJgPQnbIKmVkct7C7oW4iq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560119; c=relaxed/simple;
	bh=KDxvCUNRQRiETWlwVk8s8OhHpd/UaiTvpbhM1H7KbIw=;
	h=Date:To:From:Subject:Message-Id; b=H3+hyMA8YU4EuaaVUbSESKOG4xXCH4MtjCqYe7uEPJavj6eKzKZhNXzK3I7/fJ4Li4Y2YuP6Yr3CdrzqKFy9FJbpJLIdKYw0vW7Aw/Tf9C/p6oNRa+q1s2eOrH2xhKB8+nuFxbd/8wdz3w1pvn9DiiB+8e7RuP4ic6SyOzrcKaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tjf+olk2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tjf+olk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C05C43390;
	Thu, 22 Feb 2024 00:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560119;
	bh=KDxvCUNRQRiETWlwVk8s8OhHpd/UaiTvpbhM1H7KbIw=;
	h=Date:To:From:Subject:From;
	b=tjf+olk2WwfIjQ1A1b5SDZtzRrkuEIOyjo7X6bMQ/iAqp6/GYPNgpCzGZTDrngs6e
	 CraOc0ujXusG76KvPSayr+/1LmdpGdfiAw5LRwzde0yDISl6lwEBeFnHKEmq6f953k
	 AWGhMLGkeT6EQJbpG27lNfipiaUrqvdAIeqQLAW8=
Date: Wed, 21 Feb 2024 16:01:58 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-further-cleanup-zswap_store.patch removed from -mm tree
Message-Id: <20240222000159.08C05C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: further cleanup zswap_store()
has been removed from the -mm tree.  Its filename was
     mm-zswap-further-cleanup-zswap_store.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: further cleanup zswap_store()
Date: Mon, 29 Jan 2024 20:36:44 -0500

- Remove dupentry, reusing entry works just fine.
- Rename pool to shrink_pool, as this one actually is confusing.
- Remove page, use folio_nid() and kmap_local_folio() directly.
- Set entry->swpentry in a common path.
- Move value and src to local scope of use.

Link: https://lkml.kernel.org/r/20240130014208.565554-9-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

--- a/mm/zswap.c~mm-zswap-further-cleanup-zswap_store
+++ a/mm/zswap.c
@@ -1541,14 +1541,11 @@ bool zswap_store(struct folio *folio)
 {
 	swp_entry_t swp = folio->swap;
 	pgoff_t offset = swp_offset(swp);
-	struct page *page = &folio->page;
 	struct zswap_tree *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry, *dupentry;
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg = NULL;
-	struct zswap_pool *pool;
-	unsigned long value;
-	u8 *src;
+	struct zswap_pool *shrink_pool;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1563,10 +1560,10 @@ bool zswap_store(struct folio *folio)
 	 * the tree, and it might be written back overriding the new data.
 	 */
 	spin_lock(&tree->lock);
-	dupentry = zswap_rb_search(&tree->rbroot, offset);
-	if (dupentry) {
+	entry = zswap_rb_search(&tree->rbroot, offset);
+	if (entry) {
+		zswap_invalidate_entry(tree, entry);
 		zswap_duplicate_entry++;
-		zswap_invalidate_entry(tree, dupentry);
 	}
 	spin_unlock(&tree->lock);
 
@@ -1598,17 +1595,19 @@ bool zswap_store(struct folio *folio)
 	}
 
 	/* allocate entry */
-	entry = zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
+	entry = zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio));
 	if (!entry) {
 		zswap_reject_kmemcache_fail++;
 		goto reject;
 	}
 
 	if (zswap_same_filled_pages_enabled) {
-		src = kmap_local_page(page);
+		unsigned long value;
+		u8 *src;
+
+		src = kmap_local_folio(folio, 0);
 		if (zswap_is_page_same_filled(src, &value)) {
 			kunmap_local(src);
-			entry->swpentry = swp;
 			entry->length = 0;
 			entry->value = value;
 			atomic_inc(&zswap_same_filled_pages);
@@ -1637,9 +1636,8 @@ bool zswap_store(struct folio *folio)
 	if (!zswap_compress(folio, entry))
 		goto put_pool;
 
-	entry->swpentry = swp;
-
 insert_entry:
+	entry->swpentry = swp;
 	entry->objcg = objcg;
 	if (objcg) {
 		obj_cgroup_charge_zswap(objcg, entry->length);
@@ -1684,9 +1682,9 @@ reject:
 	return false;
 
 shrink:
-	pool = zswap_pool_last_get();
-	if (pool && !queue_work(shrink_wq, &pool->shrink_work))
-		zswap_pool_put(pool);
+	shrink_pool = zswap_pool_last_get();
+	if (shrink_pool && !queue_work(shrink_wq, &shrink_pool->shrink_work))
+		zswap_pool_put(shrink_pool);
 	goto reject;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


