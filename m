Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B641138F80
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706597031; cv=none; b=sjkpU2jedwS74J0chWeb8XOyrXOdYHySc0INtP79J0wNw8nwfj0XxnAO4HRFG3l8OL1oIVUSyKHWNcWZMq7+q7yTW+Fi4LaCL4Cq8mtCKkiSaDS2m1Miz+ZD5pbmN8cpGv/KZQdyLJWxwpvetWb6jD8/40WCL2CnAdoA8xMlBiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706597031; c=relaxed/simple;
	bh=UjwaXvRn03TCnb87xSnNPnoWkGVkb/gxCMXgc0HqE2U=;
	h=Date:To:From:Subject:Message-Id; b=hYcHEhE8/fUOWucK+ZDXyzvMizjZiCYBFn386vjrZcTAtbr/EbGRk652EtAIkrU0tsDlb/FkPR+E019RJNYSiD4GLMoDxSDAWB2eFR1jd6fbz/QveaxYaKaM7TgyAavleyZcCX0GQW+3VK3TGc2Wg2whKplcV8xx0OuhrS2aTFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j9D4tCoQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j9D4tCoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA3DC433C7;
	Tue, 30 Jan 2024 06:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706597031;
	bh=UjwaXvRn03TCnb87xSnNPnoWkGVkb/gxCMXgc0HqE2U=;
	h=Date:To:From:Subject:From;
	b=j9D4tCoQsZkzkfqDLZ9cpbx2WTHiglj1rNEzfOZT+YgYKwxUudKiNCa78WxBhJkB+
	 SmQ1wH/CNiT9PUI7Ux1ROKrYtpFUp0WDxbBMw8qWluSFEZt6BU97dSijGEZ4luAhdy
	 rbRC9V4v9aSf79TBEyoq5GD0KWK78w5d2MSAaTyE=
Date: Mon, 29 Jan 2024 22:43:36 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-function-ordering-writeback.patch added to mm-unstable branch
Message-Id: <20240130064349.0EA3DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: function ordering: writeback
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-function-ordering-writeback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-function-ordering-writeback.patch

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
Subject: mm: zswap: function ordering: writeback
Date: Mon, 29 Jan 2024 20:36:55 -0500

Shrinking needs writeback. Naturally, move the writeback code above
the shrinking code. Delete the forward decl.

Link: https://lkml.kernel.org/r/20240130014208.565554-20-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |  183 +++++++++++++++++++++++++--------------------------
 1 file changed, 90 insertions(+), 93 deletions(-)

--- a/mm/zswap.c~mm-zswap-function-ordering-writeback
+++ a/mm/zswap.c
@@ -276,9 +276,6 @@ static inline struct zswap_tree *swap_zs
 	pr_debug("%s pool %s/%s\n", msg, (p)->tfm_name,		\
 		 zpool_get_type((p)->zpools[0]))
 
-static int zswap_writeback_entry(struct zswap_entry *entry,
-				 swp_entry_t swpentry);
-
 static bool zswap_is_full(void)
 {
 	return totalram_pages() * zswap_max_pool_percent / 100 <
@@ -1164,6 +1161,96 @@ static void zswap_decompress(struct zswa
 }
 
 /*********************************
+* writeback code
+**********************************/
+/*
+ * Attempts to free an entry by adding a folio to the swap cache,
+ * decompressing the entry data into the folio, and issuing a
+ * bio write to write the folio back to the swap device.
+ *
+ * This can be thought of as a "resumed writeback" of the folio
+ * to the swap device.  We are basically resuming the same swap
+ * writeback path that was intercepted with the zswap_store()
+ * in the first place.  After the folio has been decompressed into
+ * the swap cache, the compressed version stored by zswap can be
+ * freed.
+ */
+static int zswap_writeback_entry(struct zswap_entry *entry,
+				 swp_entry_t swpentry)
+{
+	struct zswap_tree *tree;
+	struct folio *folio;
+	struct mempolicy *mpol;
+	bool folio_was_allocated;
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_NONE,
+	};
+
+	/* try to allocate swap cache folio */
+	mpol = get_task_policy(current);
+	folio = __read_swap_cache_async(swpentry, GFP_KERNEL, mpol,
+				NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
+	if (!folio)
+		return -ENOMEM;
+
+	/*
+	 * Found an existing folio, we raced with swapin or concurrent
+	 * shrinker. We generally writeback cold folios from zswap, and
+	 * swapin means the folio just became hot, so skip this folio.
+	 * For unlikely concurrent shrinker case, it will be unlinked
+	 * and freed when invalidated by the concurrent shrinker anyway.
+	 */
+	if (!folio_was_allocated) {
+		folio_put(folio);
+		return -EEXIST;
+	}
+
+	/*
+	 * folio is locked, and the swapcache is now secured against
+	 * concurrent swapping to and from the slot. Verify that the
+	 * swap entry hasn't been invalidated and recycled behind our
+	 * backs (our zswap_entry reference doesn't prevent that), to
+	 * avoid overwriting a new swap folio with old compressed data.
+	 */
+	tree = swap_zswap_tree(swpentry);
+	spin_lock(&tree->lock);
+	if (zswap_rb_search(&tree->rbroot, swp_offset(swpentry)) != entry) {
+		spin_unlock(&tree->lock);
+		delete_from_swap_cache(folio);
+		folio_unlock(folio);
+		folio_put(folio);
+		return -ENOMEM;
+	}
+
+	/* Safe to deref entry after the entry is verified above. */
+	zswap_entry_get(entry);
+	spin_unlock(&tree->lock);
+
+	zswap_decompress(entry, &folio->page);
+
+	count_vm_event(ZSWPWB);
+	if (entry->objcg)
+		count_objcg_event(entry->objcg, ZSWPWB);
+
+	spin_lock(&tree->lock);
+	zswap_invalidate_entry(tree, entry);
+	zswap_entry_put(entry);
+	spin_unlock(&tree->lock);
+
+	/* folio is up to date */
+	folio_mark_uptodate(folio);
+
+	/* move it to the tail of the inactive list after end_writeback */
+	folio_set_reclaim(folio);
+
+	/* start writeback */
+	__swap_writepage(folio, &wbc);
+	folio_put(folio);
+
+	return 0;
+}
+
+/*********************************
 * shrinker functions
 **********************************/
 static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_one *l,
@@ -1419,96 +1506,6 @@ resched:
 	zswap_pool_put(pool);
 }
 
-/*********************************
-* writeback code
-**********************************/
-/*
- * Attempts to free an entry by adding a folio to the swap cache,
- * decompressing the entry data into the folio, and issuing a
- * bio write to write the folio back to the swap device.
- *
- * This can be thought of as a "resumed writeback" of the folio
- * to the swap device.  We are basically resuming the same swap
- * writeback path that was intercepted with the zswap_store()
- * in the first place.  After the folio has been decompressed into
- * the swap cache, the compressed version stored by zswap can be
- * freed.
- */
-static int zswap_writeback_entry(struct zswap_entry *entry,
-				 swp_entry_t swpentry)
-{
-	struct zswap_tree *tree;
-	struct folio *folio;
-	struct mempolicy *mpol;
-	bool folio_was_allocated;
-	struct writeback_control wbc = {
-		.sync_mode = WB_SYNC_NONE,
-	};
-
-	/* try to allocate swap cache folio */
-	mpol = get_task_policy(current);
-	folio = __read_swap_cache_async(swpentry, GFP_KERNEL, mpol,
-				NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
-	if (!folio)
-		return -ENOMEM;
-
-	/*
-	 * Found an existing folio, we raced with swapin or concurrent
-	 * shrinker. We generally writeback cold folios from zswap, and
-	 * swapin means the folio just became hot, so skip this folio.
-	 * For unlikely concurrent shrinker case, it will be unlinked
-	 * and freed when invalidated by the concurrent shrinker anyway.
-	 */
-	if (!folio_was_allocated) {
-		folio_put(folio);
-		return -EEXIST;
-	}
-
-	/*
-	 * folio is locked, and the swapcache is now secured against
-	 * concurrent swapping to and from the slot. Verify that the
-	 * swap entry hasn't been invalidated and recycled behind our
-	 * backs (our zswap_entry reference doesn't prevent that), to
-	 * avoid overwriting a new swap folio with old compressed data.
-	 */
-	tree = swap_zswap_tree(swpentry);
-	spin_lock(&tree->lock);
-	if (zswap_rb_search(&tree->rbroot, swp_offset(swpentry)) != entry) {
-		spin_unlock(&tree->lock);
-		delete_from_swap_cache(folio);
-		folio_unlock(folio);
-		folio_put(folio);
-		return -ENOMEM;
-	}
-
-	/* Safe to deref entry after the entry is verified above. */
-	zswap_entry_get(entry);
-	spin_unlock(&tree->lock);
-
-	zswap_decompress(entry, &folio->page);
-
-	count_vm_event(ZSWPWB);
-	if (entry->objcg)
-		count_objcg_event(entry->objcg, ZSWPWB);
-
-	spin_lock(&tree->lock);
-	zswap_invalidate_entry(tree, entry);
-	zswap_entry_put(entry);
-	spin_unlock(&tree->lock);
-
-	/* folio is up to date */
-	folio_mark_uptodate(folio);
-
-	/* move it to the tail of the inactive list after end_writeback */
-	folio_set_reclaim(folio);
-
-	/* start writeback */
-	__swap_writepage(folio, &wbc);
-	folio_put(folio);
-
-	return 0;
-}
-
 static int zswap_is_page_same_filled(void *ptr, unsigned long *value)
 {
 	unsigned long *page;
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

