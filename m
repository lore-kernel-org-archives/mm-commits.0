Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AEBEBE
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560215; cv=none; b=SELml/QdjjaoY89nd2RjVMmTaYnMH2s7NovYcU4f/PuY/0/JFKdIlsAxy6aX6ux1so++B7KGWf6RTgyhulfSKiPWlY52MJlXTufQTiKAz57g0Eq2SuKWp8KuH4wkIg4UN9ff4OYHAscaYJkwRKuGHI/e2HwDOA7vlxy5mjlIJfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560215; c=relaxed/simple;
	bh=fBljt2ejuZZHj6aMli3TexwsBvAEMP/zok6pZb7Pc6U=;
	h=Date:To:From:Subject:Message-Id; b=doPrAiurE4XR0EwFVbpYN/t/tpVoJqvGxrG9CZZiHPTkruKuRqswkV0KOGdea25NGFBVCZWJRG+JFdhG5ccYpWZ14YqZccQ84rbTjI91s0xSM+ZdGfQ4yI7M4l8VL2AGM688mt4dw8NsjbukHLZmrM2A0MfCeRfkNyZ+69QCM4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CIZM/pQZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CIZM/pQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67811C433F1;
	Thu, 22 Feb 2024 00:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560215;
	bh=fBljt2ejuZZHj6aMli3TexwsBvAEMP/zok6pZb7Pc6U=;
	h=Date:To:From:Subject:From;
	b=CIZM/pQZCuB/id5dD38LZ5IbInY3BhGmaTbIa5Ex5HFJIIm17ftonsLx8gtus5wng
	 71YPaXiRFtQtKxRu7K/WDWKrUuwXbmopd+XLtGp1WHjXNpDZSQSl4EgVxPTbafVd8B
	 +3EP7Lfxoiu+a9ayuc42Gk2R9zmrynTFUcONfk5w=
Date: Wed, 21 Feb 2024 16:03:34 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,chrisl@kernel.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-optimize-and-cleanup-the-invalidation-of-duplicate-entry.patch removed from -mm tree
Message-Id: <20240222000335.67811C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: optimize and cleanup the invalidation of duplicate entry
has been removed from the -mm tree.  Its filename was
     mm-zswap-optimize-and-cleanup-the-invalidation-of-duplicate-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: optimize and cleanup the invalidation of duplicate entry
Date: Fri, 9 Feb 2024 04:41:12 +0000

We may encounter duplicate entry in the zswap_store():

1. swap slot that freed to per-cpu swap cache, doesn't invalidate
   the zswap entry, then got reused. This has been fixed.

2. !exclusive load mode, swapin folio will leave its zswap entry
   on the tree, then swapout again. This has been removed.

3. one folio can be dirtied again after zswap_store(), so need to
   zswap_store() again. This should be handled correctly.

So we must invalidate the old duplicate entry before inserting the
new one, which actually doesn't have to be done at the beginning
of zswap_store().

The good point is that we don't need to lock the tree twice in the normal
store success path.  And cleanup the loop as we are here.

Note we still need to invalidate the old duplicate entry when store failed
or zswap is disabled , otherwise the new data in swapfile could be
overwrite by the old data in zswap pool when lru writeback.

Link: https://lkml.kernel.org/r/20240209044112.3883835-1-chengming.zhou@linux.dev
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

--- a/mm/zswap.c~mm-zswap-optimize-and-cleanup-the-invalidation-of-duplicate-entry
+++ a/mm/zswap.c
@@ -1517,19 +1517,8 @@ bool zswap_store(struct folio *folio)
 	if (folio_test_large(folio))
 		return false;
 
-	/*
-	 * If this is a duplicate, it must be removed before attempting to store
-	 * it, otherwise, if the store fails the old page won't be removed from
-	 * the tree, and it might be written back overriding the new data.
-	 */
-	spin_lock(&tree->lock);
-	entry = zswap_rb_search(&tree->rbroot, offset);
-	if (entry)
-		zswap_invalidate_entry(tree, entry);
-	spin_unlock(&tree->lock);
-
 	if (!zswap_enabled)
-		return false;
+		goto check_old;
 
 	objcg = get_obj_cgroup_from_folio(folio);
 	if (objcg && !obj_cgroup_may_zswap(objcg)) {
@@ -1609,14 +1598,12 @@ insert_entry:
 	/* map */
 	spin_lock(&tree->lock);
 	/*
-	 * A duplicate entry should have been removed at the beginning of this
-	 * function. Since the swap entry should be pinned, if a duplicate is
-	 * found again here it means that something went wrong in the swap
-	 * cache.
+	 * The folio may have been dirtied again, invalidate the
+	 * possibly stale entry before inserting the new entry.
 	 */
-	while (zswap_rb_insert(&tree->rbroot, entry, &dupentry) == -EEXIST) {
-		WARN_ON(1);
+	if (zswap_rb_insert(&tree->rbroot, entry, &dupentry) == -EEXIST) {
 		zswap_invalidate_entry(tree, dupentry);
+		WARN_ON(zswap_rb_insert(&tree->rbroot, entry, &dupentry));
 	}
 	if (entry->length) {
 		INIT_LIST_HEAD(&entry->lru);
@@ -1639,6 +1626,17 @@ freepage:
 reject:
 	if (objcg)
 		obj_cgroup_put(objcg);
+check_old:
+	/*
+	 * If the zswap store fails or zswap is disabled, we must invalidate the
+	 * possibly stale entry which was previously stored at this offset.
+	 * Otherwise, writeback could overwrite the new data in the swapfile.
+	 */
+	spin_lock(&tree->lock);
+	entry = zswap_rb_search(&tree->rbroot, offset);
+	if (entry)
+		zswap_invalidate_entry(tree, entry);
+	spin_unlock(&tree->lock);
 	return false;
 
 shrink:
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

