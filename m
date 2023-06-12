Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3FBC7EE2F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 20:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238719AbjFLU45 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 16:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237309AbjFLU4p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 16:56:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E374239
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 13:52:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54BCE62BE7
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 20:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58DFC433D2;
        Mon, 12 Jun 2023 20:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686603084;
        bh=ahSsSVsMB0h9H/Ycf9dfTbNsHrRSBIBk+RIrOoPyNg4=;
        h=Date:To:From:Subject:From;
        b=ATxCk1v7F9PVjdo16EKT49GHuhfeIwycrqheSB9BKTz8U3liWGSxDIUZGhixNuNi6
         8lO2u1WDzn+eeQlHBv2BD4C87Vm9UR3bsHZ2OR8xezExjsTYnk1rzyLjUIQhKF5xkP
         GF7phi2Lorev80dKLAAw3vZmaX3pLAffjVSu1IIY=
Date:   Mon, 12 Jun 2023 13:51:24 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com,
        senozhatsky@chromium.org, nphamcs@gmail.com, minchan@kernel.org,
        hannes@cmpxchg.org, ddstreet@ieee.org, cerasuolodomenico@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-add-pool-shrinking-mechanism.patch added to mm-unstable branch
Message-Id: <20230612205124.A58DFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zswap: add pool shrinking mechanism
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-add-pool-shrinking-mechanism.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-add-pool-shrinking-mechanism.patch

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
From: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Subject: mm: zswap: add pool shrinking mechanism
Date: Mon, 12 Jun 2023 11:38:09 +0200

Patch series "mm: zswap: move writeback LRU from zpool to zswap", v3.

This series aims to improve the zswap reclaim mechanism by reorganizing
the LRU management. In the current implementation, the LRU is maintained
within each zpool driver, resulting in duplicated code across the three
drivers. The proposed change consists in moving the LRU management from
the individual implementations up to the zswap layer.

The primary objective of this refactoring effort is to simplify the
codebase. By unifying the reclaim loop and consolidating LRU handling
within zswap, we can eliminate redundant code and improve
maintainability. Additionally, this change enables the reclamation of
stored pages in their actual LRU order. Presently, the zpool drivers
link backing pages in an LRU, causing compressed pages with different
LRU positions to be written back simultaneously.

The series consists of several patches. The first patch implements the
LRU and the reclaim loop in zswap, but it is not used yet because all
three driver implementations are marked as zpool_evictable.
The following three commits modify each zpool driver to be not
zpool_evictable, allowing the use of the reclaim loop in zswap.
As the drivers removed their shrink functions, the zpool interface is
then trimmed by removing zpool_evictable, zpool_ops, and zpool_shrink.
Finally, the code in zswap is further cleaned up by simplifying the
writeback function and removing the now unnecessary zswap_header.


This patch (of 7):

Each zpool driver (zbud, z3fold and zsmalloc) implements its own shrink
function, which is called from zpool_shrink.  However, with this commit, a
unified shrink function is added to zswap.  The ultimate goal is to
eliminate the need for zpool_shrink once all zpool implementations have
dropped their shrink code.

To ensure the functionality of each commit, this change focuses solely on
adding the mechanism itself.  No modifications are made to the backends,
meaning that functionally, there are no immediate changes.  The zswap
mechanism will only come into effect once the backends have removed their
shrink code.  The subsequent commits will address the modifications needed
in the backends.

Link: https://lkml.kernel.org/r/20230612093815.133504-1-cerasuolodomenico@gmail.com
Link: https://lkml.kernel.org/r/20230612093815.133504-2-cerasuolodomenico@gmail.com
Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Tested-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   97 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 92 insertions(+), 5 deletions(-)

--- a/mm/zswap.c~mm-zswap-add-pool-shrinking-mechanism
+++ a/mm/zswap.c
@@ -154,6 +154,12 @@ struct crypto_acomp_ctx {
 	struct mutex *mutex;
 };
 
+/*
+ * The lock ordering is zswap_tree.lock -> zswap_pool.lru_lock.
+ * The only case where lru_lock is not acquired while holding tree.lock is
+ * when a zswap_entry is taken off the lru for writeback, in that case it
+ * needs to be verified that it's still valid in the tree.
+ */
 struct zswap_pool {
 	struct zpool *zpool;
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
@@ -163,6 +169,8 @@ struct zswap_pool {
 	struct work_struct shrink_work;
 	struct hlist_node node;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
+	struct list_head lru;
+	spinlock_t lru_lock;
 };
 
 /*
@@ -180,10 +188,12 @@ struct zswap_pool {
  *            be held while changing the refcount.  Since the lock must
  *            be held, there is no reason to also make refcount atomic.
  * length - the length in bytes of the compressed page data.  Needed during
- *          decompression. For a same value filled page length is 0.
+ *          decompression. For a same value filled page length is 0, and both
+ *          pool and lru are invalid and must be ignored.
  * pool - the zswap_pool the entry's data is in
  * handle - zpool allocation handle that stores the compressed page data
  * value - value of the same-value filled pages which have same content
+ * lru - handle to the pool's lru used to evict pages.
  */
 struct zswap_entry {
 	struct rb_node rbnode;
@@ -196,6 +206,7 @@ struct zswap_entry {
 		unsigned long value;
 	};
 	struct obj_cgroup *objcg;
+	struct list_head lru;
 };
 
 struct zswap_header {
@@ -368,6 +379,12 @@ static void zswap_free_entry(struct zswa
 	if (!entry->length)
 		atomic_dec(&zswap_same_filled_pages);
 	else {
+		/* zpool_evictable will be removed once all 3 backends have migrated */
+		if (!zpool_evictable(entry->pool->zpool)) {
+			spin_lock(&entry->pool->lru_lock);
+			list_del(&entry->lru);
+			spin_unlock(&entry->pool->lru_lock);
+		}
 		zpool_free(entry->pool->zpool, entry->handle);
 		zswap_pool_put(entry->pool);
 	}
@@ -588,14 +605,72 @@ static struct zswap_pool *zswap_pool_fin
 	return NULL;
 }
 
+static int zswap_reclaim_entry(struct zswap_pool *pool)
+{
+	struct zswap_header *zhdr;
+	struct zswap_entry *entry;
+	struct zswap_tree *tree;
+	pgoff_t swpoffset;
+	int ret;
+
+	/* Get an entry off the LRU */
+	spin_lock(&pool->lru_lock);
+	if (list_empty(&pool->lru)) {
+		spin_unlock(&pool->lru_lock);
+		return -EINVAL;
+	}
+	entry = list_last_entry(&pool->lru, struct zswap_entry, lru);
+	list_del_init(&entry->lru);
+	zhdr = zpool_map_handle(pool->zpool, entry->handle, ZPOOL_MM_RO);
+	tree = zswap_trees[swp_type(zhdr->swpentry)];
+	zpool_unmap_handle(pool->zpool, entry->handle);
+	/*
+	 * Once the lru lock is dropped, the entry might get freed. The
+	 * swpoffset is copied to the stack, and entry isn't deref'd again
+	 * until the entry is verified to still be alive in the tree.
+	 */
+	swpoffset = swp_offset(zhdr->swpentry);
+	spin_unlock(&pool->lru_lock);
+
+	/* Check for invalidate() race */
+	spin_lock(&tree->lock);
+	if (entry != zswap_rb_search(&tree->rbroot, swpoffset)) {
+		ret = -EAGAIN;
+		goto unlock;
+	}
+	/* Hold a reference to prevent a free during writeback */
+	zswap_entry_get(entry);
+	spin_unlock(&tree->lock);
+
+	ret = zswap_writeback_entry(pool->zpool, entry->handle);
+
+	spin_lock(&tree->lock);
+	if (ret) {
+		/* Writeback failed, put entry back on LRU */
+		spin_lock(&pool->lru_lock);
+		list_move(&entry->lru, &pool->lru);
+		spin_unlock(&pool->lru_lock);
+	}
+
+	/* Drop local reference */
+	zswap_entry_put(tree, entry);
+unlock:
+	spin_unlock(&tree->lock);
+	return ret ? -EAGAIN : 0;
+}
+
 static void shrink_worker(struct work_struct *w)
 {
 	struct zswap_pool *pool = container_of(w, typeof(*pool),
 						shrink_work);
 	int ret, failures = 0;
 
+	/* zpool_evictable will be removed once all 3 backends have migrated */
 	do {
-		ret = zpool_shrink(pool->zpool, 1, NULL);
+		if (zpool_evictable(pool->zpool))
+			ret = zpool_shrink(pool->zpool, 1, NULL);
+		else
+			ret = zswap_reclaim_entry(pool);
 		if (ret) {
 			zswap_reject_reclaim_fail++;
 			if (ret != -EAGAIN)
@@ -659,6 +734,8 @@ static struct zswap_pool *zswap_pool_cre
 	 */
 	kref_init(&pool->kref);
 	INIT_LIST_HEAD(&pool->list);
+	INIT_LIST_HEAD(&pool->lru);
+	spin_lock_init(&pool->lru_lock);
 	INIT_WORK(&pool->shrink_work, shrink_worker);
 
 	zswap_pool_debug("created", pool);
@@ -1281,7 +1358,7 @@ static int zswap_frontswap_store(unsigne
 	}
 
 	/* store */
-	hlen = zpool_evictable(entry->pool->zpool) ? sizeof(zhdr) : 0;
+	hlen = sizeof(zhdr);
 	gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
 	if (zpool_malloc_support_movable(entry->pool->zpool))
 		gfp |= __GFP_HIGHMEM | __GFP_MOVABLE;
@@ -1324,6 +1401,12 @@ insert_entry:
 			zswap_entry_put(tree, dupentry);
 		}
 	} while (ret == -EEXIST);
+	/* zpool_evictable will be removed once all 3 backends have migrated */
+	if (entry->length && !zpool_evictable(entry->pool->zpool)) {
+		spin_lock(&entry->pool->lru_lock);
+		list_add(&entry->lru, &entry->pool->lru);
+		spin_unlock(&entry->pool->lru_lock);
+	}
 	spin_unlock(&tree->lock);
 
 	/* update stats */
@@ -1405,8 +1488,7 @@ static int zswap_frontswap_load(unsigned
 	/* decompress */
 	dlen = PAGE_SIZE;
 	src = zpool_map_handle(entry->pool->zpool, entry->handle, ZPOOL_MM_RO);
-	if (zpool_evictable(entry->pool->zpool))
-		src += sizeof(struct zswap_header);
+	src += sizeof(struct zswap_header);
 
 	if (!zpool_can_sleep_mapped(entry->pool->zpool)) {
 		memcpy(tmp, src, entry->length);
@@ -1439,6 +1521,11 @@ freeentry:
 	if (!ret && zswap_exclusive_loads_enabled) {
 		zswap_invalidate_entry(tree, entry);
 		*exclusive = true;
+	} else if (entry->length && !zpool_evictable(entry->pool->zpool)) {
+		/* zpool_evictable will be removed once all 3 backends have migrated */
+		spin_lock(&entry->pool->lru_lock);
+		list_move(&entry->lru, &entry->pool->lru);
+		spin_unlock(&entry->pool->lru_lock);
 	}
 	spin_unlock(&tree->lock);
 
_

Patches currently in -mm which might be from cerasuolodomenico@gmail.com are

mm-zswap-add-pool-shrinking-mechanism.patch
mm-zswap-remove-page-reclaim-logic-from-zbud.patch
mm-zswap-remove-page-reclaim-logic-from-z3fold.patch
mm-zswap-remove-page-reclaim-logic-from-zsmalloc.patch
mm-zswap-remove-shrink-from-zpool-interface.patch
mm-zswap-simplify-writeback-function.patch
mm-zswap-remove-zswap_header.patch

