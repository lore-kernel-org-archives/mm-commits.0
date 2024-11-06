Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D41315442D
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854756; cv=none; b=uMLdDN6PBE64LLx6VzSIc4g8LE/TpGVSQ1dlNgfiNAzBrzVWzDGRtcAo3kKmFtAfa0lohz0uDI4w0EaH7Nr5/4hFR6tUeHMGwQawxy81o6CI727MotmiD5/7uLt1+jN+z24FJR5OO05oMsXCKl8D4z8AplcrH8NDBCEv/uMC63k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854756; c=relaxed/simple;
	bh=1SROUV1D1JYx6oZLsamlqcvhYDgQl044FXTRTj8h/A4=;
	h=Date:To:From:Subject:Message-Id; b=fVzEBKMqByganUC7OuZ/keRhEPJS+avMHgz+z5VtIpRRVmU343xSjUwuM++BoUeD2YJH0hgzOxRUZ9mH5vat2tkIQN6asOPpVa/IoiR2zSaKWeMgksdMogCPdvsxWfaudIyLiE3vRG0/OLoHdK0Biyfmc4xy5Isy+E9RHd9tqWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mIsDfAdk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mIsDfAdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE96C4CECF;
	Wed,  6 Nov 2024 00:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854756;
	bh=1SROUV1D1JYx6oZLsamlqcvhYDgQl044FXTRTj8h/A4=;
	h=Date:To:From:Subject:From;
	b=mIsDfAdkgGr79rFxeEvM3ycrG1uy0x8xWPU7iC5THkgWVdD0p1zukrlay535UU3G5
	 9rFDN6/IgcoR/PMiDDKyTaverh8TvLrtewJ13001NzvDBRY7jxGyKUyYnNwVU2+aJh
	 HtAeMgXuTt6Hgp8X1/nPYuBUpOHFubarB2lF+fVA=
Date: Tue, 05 Nov 2024 16:59:15 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,wajdi.k.feghali@intel.com,ryan.roberts@arm.com,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,kanchana.p.sridhar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-zswap_store_page-will-initialize-entry-after-adding-to-xarray.patch removed from -mm tree
Message-Id: <20241106005916.2DE96C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: zswap_store_page() will initialize entry after adding to xarray.
has been removed from the -mm tree.  Its filename was
     mm-zswap-zswap_store_page-will-initialize-entry-after-adding-to-xarray.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Subject: mm: zswap: zswap_store_page() will initialize entry after adding to xarray.
Date: Wed, 2 Oct 2024 10:33:29 -0700

This incorporates Yosry's suggestions in [1] for further simplifying
zswap_store_page().  If the page is successfully compressed and added to
the xarray, we get the pool/objcg refs, and initialize all the entry's
members.  Only after this, we add it to the zswap LRU.

In the time between the entry's addition to the xarray and it's member
initialization, we are protected against concurrent stores/loads/swapoff
through the folio lock, and are protected against writeback because the
entry is not on the LRU yet.

This way, we don't have to drop the pool/objcg refs, now that the entry
initialization is centralized to the successful page store code path.

zswap_compress() is modified to take a zswap_pool parameter in keeping
with this simplification (as against obtaining this from entry->pool).

[1]: https://lore.kernel.org/all/CAJD7tkZh6ufHQef5HjXf_F5b5LC1EATexgseD=4WvrO+a6Ni6w@mail.gmail.com/

Link: https://lkml.kernel.org/r/20241002173329.213722-1-kanchana.p.sridhar@intel.com
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wajdi Feghali <wajdi.k.feghali@intel.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   56 +++++++++++++++++++++++----------------------------
 1 file changed, 26 insertions(+), 30 deletions(-)

--- a/mm/zswap.c~mm-zswap-zswap_store_page-will-initialize-entry-after-adding-to-xarray
+++ a/mm/zswap.c
@@ -881,7 +881,8 @@ static int zswap_cpu_comp_dead(unsigned
 	return 0;
 }
 
-static bool zswap_compress(struct page *page, struct zswap_entry *entry)
+static bool zswap_compress(struct page *page, struct zswap_entry *entry,
+			   struct zswap_pool *pool)
 {
 	struct crypto_acomp_ctx *acomp_ctx;
 	struct scatterlist input, output;
@@ -893,7 +894,7 @@ static bool zswap_compress(struct page *
 	gfp_t gfp;
 	u8 *dst;
 
-	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
+	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
 
 	mutex_lock(&acomp_ctx->mutex);
 
@@ -926,7 +927,7 @@ static bool zswap_compress(struct page *
 	if (comp_ret)
 		goto unlock;
 
-	zpool = entry->pool->zpool;
+	zpool = pool->zpool;
 	gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
 	if (zpool_malloc_support_movable(zpool))
 		gfp |= __GFP_HIGHMEM | __GFP_MOVABLE;
@@ -1414,32 +1415,21 @@ static ssize_t zswap_store_page(struct p
 				struct obj_cgroup *objcg,
 				struct zswap_pool *pool)
 {
+	swp_entry_t page_swpentry = page_swap_entry(page);
 	struct zswap_entry *entry, *old;
 
 	/* allocate entry */
 	entry = zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
 	if (!entry) {
 		zswap_reject_kmemcache_fail++;
-		goto reject;
+		return -EINVAL;
 	}
 
-	/* zswap_store() already holds a ref on 'objcg' and 'pool' */
-	if (objcg)
-		obj_cgroup_get(objcg);
-	zswap_pool_get(pool);
-
-	/* if entry is successfully added, it keeps the reference */
-	entry->pool = pool;
+	if (!zswap_compress(page, entry, pool))
+		goto compress_failed;
 
-	if (!zswap_compress(page, entry))
-		goto put_pool_objcg;
-
-	entry->swpentry = page_swap_entry(page);
-	entry->objcg = objcg;
-	entry->referenced = true;
-
-	old = xa_store(swap_zswap_tree(entry->swpentry),
-		       swp_offset(entry->swpentry),
+	old = xa_store(swap_zswap_tree(page_swpentry),
+		       swp_offset(page_swpentry),
 		       entry, GFP_KERNEL);
 	if (xa_is_err(old)) {
 		int err = xa_err(old);
@@ -1458,6 +1448,16 @@ static ssize_t zswap_store_page(struct p
 		zswap_entry_free(old);
 
 	/*
+	 * The entry is successfully compressed and stored in the tree, there is
+	 * no further possibility of failure. Grab refs to the pool and objcg.
+	 * These refs will be dropped by zswap_entry_free() when the entry is
+	 * removed from the tree.
+	 */
+	zswap_pool_get(pool);
+	if (objcg)
+		obj_cgroup_get(objcg);
+
+	/*
 	 * We finish initializing the entry while it's already in xarray.
 	 * This is safe because:
 	 *
@@ -1467,25 +1467,21 @@ static ssize_t zswap_store_page(struct p
 	 *    The publishing order matters to prevent writeback from seeing
 	 *    an incoherent entry.
 	 */
+	entry->pool = pool;
+	entry->swpentry = page_swpentry;
+	entry->objcg = objcg;
+	entry->referenced = true;
 	if (entry->length) {
 		INIT_LIST_HEAD(&entry->lru);
 		zswap_lru_add(&zswap_list_lru, entry);
 	}
 
-	/*
-	 * We shouldn't have any possibility of failure after the entry is
-	 * added in the xarray. The pool/objcg refs obtained here will only
-	 * be dropped if/when zswap_entry_free() gets called.
-	 */
 	return entry->length;
 
 store_failed:
-	zpool_free(entry->pool->zpool, entry->handle);
-put_pool_objcg:
-	zswap_pool_put(pool);
-	obj_cgroup_put(objcg);
+	zpool_free(pool->zpool, entry->handle);
+compress_failed:
 	zswap_entry_cache_free(entry);
-reject:
 	return -EINVAL;
 }
 
_

Patches currently in -mm which might be from kanchana.p.sridhar@intel.com are


