Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BC0378D8D
	for <mm-commits@vger.kernel.org>; Fri, 11 Sep 2026 01:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789090864; cv=none; b=CTWUpRVSFKsa++kMTYh1sMTXztgwq7TI1m6KyOwgHQs3K4PE1T5+Ao6Jy3OxM+h6hpTekr8h0sOzP3fnG3UTE+npW9FkTJGDcxvfz823LoDZc7Yf557HLBsOLOsg3LcL6uKSgwM7LMj0wGTMsOjr5ncQ53DeNo2LoAtaokXtLXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789090864; c=relaxed/simple;
	bh=vI7mf/n61dU2h/knpqG2Zt+O69OVOTad21hmUfDM7YU=;
	h=Date:To:From:Subject:Message-Id; b=QtgVp0vux+GcNP+PAMoRK2CW23sfOHpjxxUjSvuJd2HsxlcXqwKcwUxPfnM8mGhwBX8xmRiuIhVCXG8tvxOETdgyuQXuWUZLmfyUZ3nbvNguccN2p/xFnykysudNNC0Kx6NAJzlpcE5Ph6MvKllNXAe1gFU1bJltI8QQyLCy7XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ebip2Ukk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ebip2Ukk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D1E1F000FF;
	Fri, 11 Sep 2026 01:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789090862;
	bh=g8GXfcWpXjA7fzPhQjDNYGspLivyWmDILTZt5CBIJXg=;
	h=Date:To:From:Subject;
	b=Ebip2Ukk3TiF3mvtHgS9Uz2ueoWEEUvMBYSxKgEik6Io78tXyy6fkgXxp5hp3D87x
	 6O4ZEG3TIwptLE+7WPFzxCK9IdGjTLq4cbrJWvk2CZ2Upe4+HPdgM4C/CIXoG79Fj/
	 jK4/tIjP/+gMH7GCh0Bqiny3bSmTUnsH0D5YGrk4=
Date: Thu, 10 Sep 2026 18:41:02 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chrisl@kernel.org,chengming.zhou@linux.dev,wujianyue000@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-reference-the-pool-by-id-to-shrink-struct-zswap_entry.patch added to mm-new branch
Message-Id: <20260911014102.70D1E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: reference the pool by id to shrink struct zswap_entry
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-reference-the-pool-by-id-to-shrink-struct-zswap_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-reference-the-pool-by-id-to-shrink-struct-zswap_entry.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Suggested-by: Chris Li <chrisl@kernel.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-zswap-release-retired-pools-via-queue_rcu_work-instead-of-synchronize_rcu.patch
mm-zswap-replace-the-zswap_pools-list-with-an-allocating-xarray.patch
mm-zswap-reference-the-pool-by-id-to-shrink-struct-zswap_entry.patch

