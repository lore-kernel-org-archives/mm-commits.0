Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A5E381A0
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706596864; cv=none; b=h1SbYCdr4ekLViESuVyaFZ39x04NJyYmDpFs0Xwa7b4F3Uu86HRYeECxVTgX4KPF5MLPN+0DSuJjXvW2Hx/pegL07mJow8TCgBN37n9i7cqBHsQ78774BfVEe0H+NnebzybGux9rLaZ7ldMnqcJNd1yA1LbBquVwO19NmoX9JJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706596864; c=relaxed/simple;
	bh=jz9ULw/6w67VKe/pFXob1veZfU34s9BWT0rNaCQyEo0=;
	h=Date:To:From:Subject:Message-Id; b=Rfkcnxe9RMP6eo+WBzsoEhYKeu5YKyXOJDuFGLsI2i4qDIxYBhXlu9gzNJDSKdV877NDE44IWpohvvE/DfZi7cE1Af589y6GVIq+h9j9Tba8hF4hcjXLZbJga4IHAaz2yTL8WKPp6vmUD2m8rW8hm0Q/VHa6WHQ1FRWKT6qTFk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aQI6HuQL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aQI6HuQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D6BC433F1;
	Tue, 30 Jan 2024 06:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706596863;
	bh=jz9ULw/6w67VKe/pFXob1veZfU34s9BWT0rNaCQyEo0=;
	h=Date:To:From:Subject:From;
	b=aQI6HuQLzZ5aP1FsgY27B5eqMPB9oQ/OJoIYPfWcZHTb9cFUMr+7Iai4Ivt5aPjvP
	 vX9/CIyWCon24vvKUuxJhQFZVZjvkbHWMfJtoVsWAwYY+Dm9RrUzR3/YH9AX2G2a9J
	 ZDJKlhiE9VgHad+HR/pNGbuNr2LZQGKTgB8Izp2M=
Date: Mon, 29 Jan 2024 22:40:50 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-further-cleanup-zswap_store.patch added to mm-unstable branch
Message-Id: <20240130064102.83D6BC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: further cleanup zswap_store()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-further-cleanup-zswap_store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-further-cleanup-zswap_store.patch

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
Subject: mm: zswap: further cleanup zswap_store()
Date: Mon, 29 Jan 2024 20:36:44 -0500

- Remove dupentry, reusing entry works just fine.
- Rename pool to shrink_pool, as this one actually is confusing.
- Remove page, use folio_nid() and kmap_local_folio() directly.
- Set entry->swpentry in a common path.
- Move value and src to local scope of use.

Link: https://lkml.kernel.org/r/20240130014208.565554-9-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

--- a/mm/zswap.c~mm-zswap-further-cleanup-zswap_store
+++ a/mm/zswap.c
@@ -1542,14 +1542,11 @@ bool zswap_store(struct folio *folio)
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
@@ -1567,10 +1564,10 @@ bool zswap_store(struct folio *folio)
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
 	objcg = get_obj_cgroup_from_folio(folio);
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

