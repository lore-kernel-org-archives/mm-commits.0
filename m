Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F2E414439
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525523; cv=none; b=EKrUf6bk0wIXUEymQSimONRLFDu/d36le4+y7yMu46u02ZTEGTC4N+/nzo8I6LFmb0TqwTbgFZrQzSf6y/9tWJ2y9ikdwV+Fw6nEb4S+KIIeZJEKjxxe5gshdvrSavqltteV8RGkZ/LZVTyVjqLlp8qt7zf8IF2LUvQFC238LTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525523; c=relaxed/simple;
	bh=TvJjKMU2Uq9CAfAzADu8IqiaMGuIII0eu+kPFE2/DTI=;
	h=Date:To:From:Subject:Message-Id; b=IpF0pzcHHKe29pEimgidYouO9grM0r6SM4BSkP9i3GxHuRvYo3kdjOyMOi/FX97mF1hUqsHsHr5vM+bNLBSFHNEtIYNRYQJG/I+dfIfWHIVAdyFMMl6L9qEtAMiJJxQqyOWhdpZrMm+m39JyJsXiQhwupvz0iL4iRab0rBVe0fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vwPuwIHm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vwPuwIHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152B41F000FF;
	Fri,  9 Oct 2026 05:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525522;
	bh=uHe74b7cCqM1Xl/LTRRs4VTNtmEJpMG0Q4ioZz79y/M=;
	h=Date:To:From:Subject;
	b=vwPuwIHmAunFQDWSkHnll34dMAnffS+Nc7qhyjROrxn8euDxndtj6AKKSDdVhvJGU
	 bazq6/9HLfxB5ywDqhgwni2twjOQiaWMDc9bvzH7uELiwp7kSUJjkAuUIkMFnenFLB
	 CQ6QErPKhQUs5BM3DVIHr4Kf37vy8WiL5544LHn8=
Date: Thu, 08 Oct 2026 22:58:41 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chrisl@kernel.org,chengming.zhou@linux.dev,wujianyue000@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-reference-the-pool-by-id-to-shrink-struct-zswap_entry.patch removed from -mm tree
Message-Id: <20261009055842.152B41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: reference the pool by id to shrink struct zswap_entry
has been removed from the -mm tree.  Its filename was
     mm-zswap-reference-the-pool-by-id-to-shrink-struct-zswap_entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jianyue Wu <wujianyue000@gmail.com>
Subject: mm/zswap: reference the pool by id to shrink struct zswap_entry
Date: Sun, 06 Sep 2026 15:47:19 +0800

struct zswap_entry is one allocation per stored page, so its size is pure
overhead.  It currently embeds an 8-byte pool pointer, even though the
live pools now sit in an allocating xarray keyed by a small integer id
that fits in a u8.

Replace the per-entry pool pointer with that u8 id and resolve it through
the xarray with xa_load().  xa_load() does its own RCU-protected lookup,
so the caller needs no rcu_read_lock() section of its own.  The resolved
pool stays valid because a live entry pins it via percpu_ref (taken in
zswap_store_page()), so its id cannot be reused.  A live entry never uses
the reserved id 0, so a zeroed id resolves to NULL and trips a WARN rather
than aliasing a live pool.

The u8 fits in the padding after the bool referenced field, shrinking the
entry from 56 to 48 bytes on 64-bit.  This raises objs_per_slab from 73 to
85 and saves about 2MiB of metadata per 1GiB of data held in zswap.

Link: https://lore.kernel.org/20260906-shrink_zswap_entry_v6-v6-3-ac4cf61565fb@gmail.com
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Chris Li <chrisl@kernel.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
---

 mm/zswap.c |   37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

--- a/mm/zswap.c~mm-zswap-reference-the-pool-by-id-to-shrink-struct-zswap_entry
+++ a/mm/zswap.c
@@ -194,7 +194,7 @@ static struct shrinker *zswap_shrinker;
  *              writeback logic. The entry is only reclaimed by the writeback
  *              logic if referenced is unset. See comments in the shrinker
  *              section for context.
- * pool - the zswap_pool the entry's data is in
+ * pool_idx - id of the zswap_pool that the entry's data is in.
  * handle - zsmalloc allocation handle that stores the compressed page data
  * objcg - the obj_cgroup that the compressed memory is charged to
  * lru - handle to the pool's lru used to evict pages.
@@ -203,12 +203,22 @@ struct zswap_entry {
 	swp_entry_t swpentry;
 	unsigned int length;
 	bool referenced;
-	struct zswap_pool *pool;
+	u8 pool_idx;
 	unsigned long handle;
 	struct obj_cgroup *objcg;
 	struct list_head lru;
 };
 
+/*
+ * No RCU section is needed around the returned pointer: a stored entry pins
+ * its pool via percpu_ref (taken in zswap_store_page()), so the id cannot be
+ * reused under us.  Callers WARN and handle a NULL from a corrupt pool_idx.
+ */
+static struct zswap_pool *zswap_entry_pool(struct zswap_entry *entry)
+{
+	return xa_load(&zswap_pools, entry->pool_idx);
+}
+
 static struct xarray *zswap_trees[MAX_SWAPFILES];
 static unsigned int nr_zswap_trees[MAX_SWAPFILES];
 
@@ -766,9 +776,13 @@ static void zswap_entry_cache_free(struc
  */
 static void zswap_entry_free(struct zswap_entry *entry)
 {
+	struct zswap_pool *pool = zswap_entry_pool(entry);
+
 	zswap_lru_del(entry);
-	zs_free(entry->pool->zs_pool, entry->handle);
-	zswap_pool_put(entry->pool);
+	if (!WARN_ON_ONCE(!pool)) {
+		zs_free(pool->zs_pool, entry->handle);
+		zswap_pool_put(pool);
+	}
 	if (entry->objcg) {
 		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
 		obj_cgroup_put(entry->objcg);
@@ -924,12 +938,15 @@ unlock:
 
 static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 {
-	struct zswap_pool *pool = entry->pool;
+	struct zswap_pool *pool = zswap_entry_pool(entry);
 	struct scatterlist input[2]; /* zsmalloc returns an SG list 1-2 entries */
 	struct scatterlist output;
 	struct crypto_acomp_ctx *acomp_ctx;
 	int ret = 0, dlen;
 
+	if (WARN_ON_ONCE(!pool))
+		return false;
+
 	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
 	mutex_lock(&acomp_ctx->mutex);
 	zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
@@ -965,7 +982,7 @@ static bool zswap_decompress(struct zswa
 	pr_alert_ratelimited("Decompression error from zswap (%d:%lu %s %u->%d)\n",
 						swp_type(entry->swpentry),
 						swp_offset(entry->swpentry),
-						entry->pool->tfm_name,
+						pool->tfm_name,
 						entry->length, dlen);
 	return false;
 }
@@ -1423,6 +1440,13 @@ static bool zswap_store_page(struct foli
 	if (!zswap_compress(folio, index, entry, pool))
 		goto compress_failed;
 
+	/*
+	 * Set pool_idx before the xa_store() below publishes the entry, or a
+	 * concurrent reader could resolve a stale pool_idx left by slab reuse
+	 * to an unrelated live pool.
+	 */
+	entry->pool_idx = pool->idx;
+
 	old = xa_store(swap_zswap_tree(page_swpentry),
 		       swp_offset(page_swpentry),
 		       entry, GFP_KERNEL);
@@ -1468,7 +1492,6 @@ static bool zswap_store_page(struct foli
 	 *    The publishing order matters to prevent writeback from seeing
 	 *    an incoherent entry.
 	 */
-	entry->pool = pool;
 	entry->swpentry = page_swpentry;
 	entry->objcg = objcg;
 	entry->referenced = true;
_

Patches currently in -mm which might be from wujianyue000@gmail.com are


