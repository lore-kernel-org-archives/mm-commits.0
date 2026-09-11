Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7F7378D8D
	for <mm-commits@vger.kernel.org>; Fri, 11 Sep 2026 01:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789090860; cv=none; b=tzH+alM5H6CWfjT0112d7flXiCkK1DDgoaC+Zl9JtfkbvXBcGTx6jawcmN/XCsP6Oa6CE+/FcZrGJUbm4YhnugUWzDkCwTqt5VKx7Apc84hSZeM6MjsdLNHl0iDNECgCh/nE4Ac/AruoYmU9o6PO1mW0HSRMQK4EVuLvAQ7JIDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789090860; c=relaxed/simple;
	bh=se77+gjV7WRwGdqKCVBgdAgy79nsDDUDUihUC1SDEi8=;
	h=Date:To:From:Subject:Message-Id; b=MyK51bssPkyr1ufDhWxQUGjJqQMQBeS1OG/0XXpo+sOvdd19W8ulh9FyJI7GgLYZXomOeKA6sQmnqv4YjdRRxuUXfKn0tDw1AQu6Ut8UbbScMPboCsQ3/6vcU5zw0fbDAq6gsPZD4u+AZR2ALdckD6jRT7eYjIhtAODmV7Mi95A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dtuwLiz3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dtuwLiz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193D61F000FF;
	Fri, 11 Sep 2026 01:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789090858;
	bh=FC3jsoZ3vfIrJtrL5lbej0XD6giOxo+MmdBITkQEbm0=;
	h=Date:To:From:Subject;
	b=dtuwLiz3szEpdktQcr8viJYNsilwtfC5hexgU/Cil5U3RX8d/InkUTP/LGCPQeb/M
	 WBBIlUW/m9+8ydzBTo54o0JH3NinLvkOz4AIBWvuvRncHzpdwrsPuhqPkJQjKOiesw
	 iheJfrgorV70atATmwcVvq8p1F0BgtSwqOz501ww=
Date: Thu, 10 Sep 2026 18:40:57 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chrisl@kernel.org,chengming.zhou@linux.dev,wujianyue000@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-release-retired-pools-via-queue_rcu_work-instead-of-synchronize_rcu.patch added to mm-new branch
Message-Id: <20260911014058.193D61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: release retired pools via queue_rcu_work() instead of synchronize_rcu()
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-release-retired-pools-via-queue_rcu_work-instead-of-synchronize_rcu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-release-retired-pools-via-queue_rcu_work-instead-of-synchronize_rcu.patch

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
Subject: mm/zswap: release retired pools via queue_rcu_work() instead of synchronize_rcu()
Date: Sun, 06 Sep 2026 15:47:17 +0800

Patch series "mm/zswap: shrink zswap_entry via a pool id", v6.

Every stored page has a struct zswap_entry, so its size is pure per-page
overhead.  On 64-bit it is currently 56 bytes, of which 8 bytes are a
pointer to the owning zswap_pool.

Only a handful of pools are ever live: a new pool is created only when the
compressor is (re)set, and pools are reused across compressor switches.  A
list cannot look a pool up by id.  An allocating xarray can, which lets
each zswap_entry store a u8 instead of a pointer.

This series:

  1. Releases retired pools with queue_rcu_work() instead of a worker
     calling synchronize_rcu(), so the release worker no longer blocks
     on an RCU grace period.
  2. Replaces the zswap_pools list with an allocating xarray
     (XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_BH) and a separate RCU-protected
     current-pool pointer, giving each pool a stable small id.  Ids
     start at 1.  The reserved id 0 is never allocated, so looking it
     up resolves to NULL.  The table grows as needed up to 255 live
     pools (u8 pool_idx), not a fixed slot array.
  3. Stores that u8 pool id in each zswap_entry instead of the pool
     pointer.  The u8 fits in padding after the bool referenced field.

On 64-bit that shrinks the entry from 56 to 48 bytes, which fits 73 to 85
objects in a 4K slab (~2MiB of metadata saved per 1GiB of data held in
zswap).

The 255-id cap counts every pool still in the xarray.  Switching
compressor kills the old pool, but that pool stays in the table until its
last entry drops the pool's ref, so a draining pool still occupies an id. 
The id is reused only after xa_erase.  Switching back to a compressor
whose pool is still in the table resurrects it instead of allocating a new
id.  If every id is occupied, creating a pool for another compressor fails
and the switch is rejected.

Pool table locking: xa_for_each() walks and the current-pool pointer use
an explicit rcu_read_lock(), because xa_for_each()'s own RCU does not span
the loop body.  xa_load() takes RCU around the lookup itself, so
zswap_entry_pool() needs no extra rcu_read_lock().  The returned pool
stays valid because a live entry pins it via percpu_ref, so the id cannot
be reused under it.  xa_lock is taken only in xa_alloc_bh() and
xa_erase_bh().

Benchmark (x86_64, compressor=lzo, MADV_PAGEOUT store + fault-in load):

  - e2e store+load median latency: no measurable regression vs baseline
    at matched stored_delta

Each store, free, and decompress looks up the pool with xa_load() instead
of following a pointer.  With only a handful of live pools the xarray walk
is short.


This patch (of 3):

When a pool's last reference is dropped, __zswap_pool_empty() removes it
from the pool list and schedules __zswap_pool_release(), which calls
synchronize_rcu() to wait for readers before tearing the pool down.

synchronize_rcu() is a synchronous, potentially long wait.  Replace it
with queue_rcu_work(): __zswap_pool_empty() hands the pool to
queue_rcu_work(), which waits for a grace period asynchronously and then
runs __zswap_pool_release() from a worker for the sleepable teardown
(__zswap_pool_empty() can run in atomic context and must not block).  The
grace-period guarantee is unchanged; the retirement path just no longer
blocks on it.

Link: https://lore.kernel.org/20260906-shrink_zswap_entry_v6-v6-0-ac4cf61565fb@gmail.com
Link: https://lore.kernel.org/20260906-shrink_zswap_entry_v6-v6-1-ac4cf61565fb@gmail.com
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/zswap.c~mm-zswap-release-retired-pools-via-queue_rcu_work-instead-of-synchronize_rcu
+++ a/mm/zswap.c
@@ -155,7 +155,7 @@ struct zswap_pool {
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
 	struct percpu_ref ref;
 	struct list_head list;
-	struct work_struct release_work;
+	struct rcu_work release_rwork;
 	struct hlist_node node;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
 };
@@ -386,10 +386,8 @@ static void zswap_pool_destroy(struct zs
 
 static void __zswap_pool_release(struct work_struct *work)
 {
-	struct zswap_pool *pool = container_of(work, typeof(*pool),
-						release_work);
-
-	synchronize_rcu();
+	struct zswap_pool *pool = container_of(to_rcu_work(work),
+					       typeof(*pool), release_rwork);
 
 	/* nobody should have been able to get a ref... */
 	WARN_ON(!percpu_ref_is_zero(&pool->ref));
@@ -413,8 +411,8 @@ static void __zswap_pool_empty(struct pe
 
 	list_del_rcu(&pool->list);
 
-	INIT_WORK(&pool->release_work, __zswap_pool_release);
-	schedule_work(&pool->release_work);
+	INIT_RCU_WORK(&pool->release_rwork, __zswap_pool_release);
+	queue_rcu_work(system_percpu_wq, &pool->release_rwork);
 
 	spin_unlock_bh(&zswap_pools_lock);
 }
_

Patches currently in -mm which might be from wujianyue000@gmail.com are

mm-zswap-release-retired-pools-via-queue_rcu_work-instead-of-synchronize_rcu.patch
mm-zswap-replace-the-zswap_pools-list-with-an-allocating-xarray.patch
mm-zswap-reference-the-pool-by-id-to-shrink-struct-zswap_entry.patch

