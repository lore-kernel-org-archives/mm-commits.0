Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793393563;
	b=Fi9a7Y0+C8Nnw6LTX845ND6gZ/gKTfuaYvmC6tXXhXWtCdtLZ7feRh2wlhjm9RjgO/Ke
	 m/gJJl5XtNygyg8c3AWu7x6wxweOYa98NmAIV03KVxhDnYx6ZJMgI3/KqCUWZGzJ8JRez
	 OqQdSld2NVw9XL1eyQxhsyVzrJ6PxM4DLK4GJqt1IWEaCHeyGKEAqLVzwWT7nQa240rO0
	 +jnIT8y97wrbLmqCm74usgq9p8xLWybvjTloRgb2BTfHwQZZyJ9WCWfbeitXN74Wl+nc3
	 KbIsHJKU7VB0ytB9GP7d9iHHntABrltJcrJylDmkTtzSCKW2r9q9N3ZZ66omSBqdMmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793393563;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=LG4HwaDomco1NmKCyqUSoSQQHm0z7VM3l+L6FdH/auU=;
	b=Dkp7MDddD28SdmhezB4OvAcBA3kLRI5jtvkFwGZHIjBPfHGqp8AHIjW5pAIvUgIBDUbD
	 rZ5rzYq8dBZw5WLZJq97GU8FIse6eT7vSLnjTMwmTWRt2Ruo4mUiDtT+903qktaZ7zTHc
	 ePQu5a8Qlu81d9X9SJr+gYR/CR7weLzx9IYissRWH0CESC4PtgovbOW9u+9r9ExHX3FTA
	 KXp8RBIjCbqVjbw6pjQTTvMOefKepTpwuQab83pAl5G7ETmkBgf7hvMQWYclXo66WIaGP
	 ZXvkSwm/tlLNcRtfOGnodbW6NQJORFcQ4PeTlGuiXKg8d4SX5pU2Mu4bCVZe8gMNGdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Qm24Rlms;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB123606A31C
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 20:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Qm24Rlms
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9D51F000C1;
	Fri, 30 Oct 2026 20:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793393562;
	bh=LG4HwaDomco1NmKCyqUSoSQQHm0z7VM3l+L6FdH/auU=;
	h=Date:To:From:Subject;
	b=Qm24RlmsmjvKsAbpAOsOxD/QBj7sjov/aP3aAmhBw4QJH+f3KlT2S49+pM3JoxoNF
	 B32mgy3cq2QAvEzRzl8/93Sz7zpGCzMepZ6Asgkh0wD8MOvwtUx07GVA4K01IwP9wY
	 7O2vuwPlSQ7H46kxh+s5ftHoY+0grWXYJDeNlx6k=
Date: Fri, 30 Oct 2026 13:52:42 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,nphamcs@gmail.com,
	kasong@tencent.com,hch@lst.de,hannes@cmpxchg.org,chrisl@kernel.org,
	chengming.zhou@linux.dev,alex@ghiti.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-batch-the-writeback-io-of-consecutive-entries.patch added to mm-new branch
Message-Id: <20261030205242.6A9D51F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/zswap: batch the writeback IO of consecutive entries
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-batch-the-writeback-io-of-consecutive-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-batch-the-writeback-io-of-consecutive-entries.patch

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
From: Alexandre Ghiti <alex@ghiti.fr>
Subject: mm/zswap: batch the writeback IO of consecutive entries
Date: Wed, 07 Oct 2026 17:34:43 +0200

Patch series "mm/zswap: batch the writeback IO".

Since commit 8f29aa226f82 ("mm/swap: introduce struct swap_io_ctx"),
reclaim merges the swap writes of folios with consecutive slots into a
single bio, but zswap writeback still issues one IO per entry. Patch 1
makes each zswap LRU walk batch its writeback IO. Patch 2 plugs the
walk, so that the block layer can merge what the batch cannot.

Kernel build (defconfig, -j4) in a 600M memory.max cgroup with the zswap
shrinker enabled, swapping to an NVMe partition with iocost enabled,
next to a sibling fio random writer with 10 times its io.weight. Mean
+- stddev:

                                  before          after
  patch 1  build time (s)        2269 +- 50      2203 +- 62
           pages per request     1.08 +- 0.00    1.30 +- 0.02
  patch 2  build time (s)        2188 +- 45      2104 +- 75
           pages per request     1.30 +- 0.01    1.35 +- 0.02


This patch (of 2):

Commit 8f29aa226f82 ("mm/swap: introduce struct swap_io_ctx") introduced a
simple way to batch the swap writes of folios with consecutive slots into a
single bio. zswap writeback does not use it: zswap_writeback_entry()
submits a context of its own for every entry, so every entry written back
becomes its own IO.

So let the two functions that walk the zswap LRU, zswap_shrinker_scan()
and shrink_memcg(), own the context and submit it once the walk is done.

Kernel build (defconfig, -j4) in a 600M memory.max cgroup with the zswap
shrinker enabled, swapping to an NVMe partition with iocost enabled. It
runs alone, and next to a sibling fio random writer with 10 times its
io.weight so that iocost throttles it. Mean +- stddev, counters from the
build's cgroup:

Alone:

                                unbatched       batched
  build time (s)                1066 +- 9     1061 +- 2   -0.5%
  write requests (k)            748 +- 47     596 +- 26   -20.4%
  pages per write request    1.07 +- 0.01  1.30 +- 0.01   +21.2%
  iocost debt (s)             15.0 +- 2.7   12.1 +- 1.2   -19.5%
  iocost wait (s)              7.5 +- 1.2    7.2 +- 1.1   -3.6%
  IO full pressure (s)        19.0 +- 1.8   18.2 +- 0.9   -4.2%

Next to the writer:

                                unbatched       batched
  build time (s)               2269 +- 50    2203 +- 62   -2.9%
  write requests (k)            714 +- 31     605 +- 24   -15.2%
  pages per write request    1.08 +- 0.00  1.30 +- 0.02   +20.3%
  iocost debt (s)               685 +- 25     646 +- 26   -5.7%
  iocost wait (s)               655 +- 26     632 +- 23   -3.6%
  IO full pressure (s)          655 +- 31     624 +- 30   -4.7%

Link: https://lore.kernel.org/20261007153507.50715-1-alex@ghiti.fr
Link: https://lore.kernel.org/20261007153507.50715-2-alex@ghiti.fr
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
---

 mm/zswap.c |   47 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 11 deletions(-)

--- a/mm/zswap.c~mm-zswap-batch-the-writeback-io-of-consecutive-entries
+++ a/mm/zswap.c
@@ -1048,6 +1048,21 @@ static bool zswap_decompress(struct zswa
 /*********************************
 * writeback code
 **********************************/
+/* State shared by all the entries written back by one LRU walk. */
+struct zswap_shrink_ctl {
+	/*
+	 * Collects the writeback of consecutive entries into as few IOs as
+	 * possible. The owner of the walk must submit what is left in it
+	 * once it is done.
+	 */
+	struct swap_io_ctx io_ctx;
+	/*
+	 * If not NULL, stop the walk when writeback finds a folio already in
+	 * the swap cache, and set it to true.
+	 */
+	bool *encountered_page_in_swapcache;
+};
+
 /*
  * Attempts to free an entry by adding a folio to the swap cache,
  * decompressing the entry data into the folio, and issuing a
@@ -1059,8 +1074,12 @@ static bool zswap_decompress(struct zswa
  * in the first place.  After the folio has been decompressed into
  * the swap cache, the compressed version stored by zswap can be
  * freed.
+ *
+ * The folio is only added to @ctx here, it is up to the owner of @ctx to
+ * submit the IO.
  */
-static int zswap_writeback_entry(struct zswap_entry *entry,
+static int zswap_writeback_entry(struct swap_io_ctx *ctx,
+				 struct zswap_entry *entry,
 				 swp_entry_t swpentry)
 {
 	struct xarray *tree;
@@ -1068,7 +1087,6 @@ static int zswap_writeback_entry(struct
 	struct folio *folio;
 	struct mempolicy *mpol;
 	struct swap_info_struct *si;
-	struct swap_io_ctx ctx = {};
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
@@ -1140,8 +1158,7 @@ static int zswap_writeback_entry(struct
 	folio_put(folio);
 
 	/* start writeback */
-	__swap_writeout(&ctx, folio);
-	swap_write_submit(&ctx);
+	__swap_writeout(ctx, folio);
 
 	return 0;
 
@@ -1181,7 +1198,7 @@ static enum lru_status shrink_memcg_cb(s
 				       void *arg)
 {
 	struct zswap_entry *entry = container_of(item, struct zswap_entry, lru);
-	bool *encountered_page_in_swapcache = (bool *)arg;
+	struct zswap_shrink_ctl *ctl = arg;
 	swp_entry_t swpentry;
 	enum lru_status ret = LRU_REMOVED_RETRY;
 	int writeback_result;
@@ -1236,7 +1253,7 @@ static enum lru_status shrink_memcg_cb(s
 	 */
 	spin_unlock(&l->lock);
 
-	writeback_result = zswap_writeback_entry(entry, swpentry);
+	writeback_result = zswap_writeback_entry(&ctl->io_ctx, entry, swpentry);
 
 	if (writeback_result) {
 		zswap_reject_reclaim_fail++;
@@ -1247,9 +1264,9 @@ static enum lru_status shrink_memcg_cb(s
 		 * into the warmer region. We should terminate shrinking (if we're in the dynamic
 		 * shrinker context).
 		 */
-		if (writeback_result == -EEXIST && encountered_page_in_swapcache) {
+		if (writeback_result == -EEXIST && ctl->encountered_page_in_swapcache) {
 			ret = LRU_STOP;
-			*encountered_page_in_swapcache = true;
+			*ctl->encountered_page_in_swapcache = true;
 		}
 	} else {
 		zswap_written_back_pages++;
@@ -1261,8 +1278,11 @@ static enum lru_status shrink_memcg_cb(s
 static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 		struct shrink_control *sc)
 {
-	unsigned long shrink_ret;
 	bool encountered_page_in_swapcache = false;
+	struct zswap_shrink_ctl ctl = {
+		.encountered_page_in_swapcache = &encountered_page_in_swapcache,
+	};
+	unsigned long shrink_ret;
 
 	if (!zswap_shrinker_enabled ||
 			!mem_cgroup_zswap_writeback_enabled(sc->memcg)) {
@@ -1271,7 +1291,9 @@ static unsigned long zswap_shrinker_scan
 	}
 
 	shrink_ret = list_lru_shrink_walk(&zswap_list_lru, sc, &shrink_memcg_cb,
-		&encountered_page_in_swapcache);
+		&ctl);
+
+	swap_write_submit(&ctl.io_ctx);
 
 	if (encountered_page_in_swapcache)
 		return SHRINK_STOP;
@@ -1377,6 +1399,7 @@ static struct shrinker *zswap_alloc_shri
  */
 static int shrink_memcg(struct mem_cgroup *memcg)
 {
+	struct zswap_shrink_ctl ctl = {};
 	int nid, shrunk = 0, scanned = 0;
 
 	if (!mem_cgroup_zswap_writeback_enabled(memcg))
@@ -1393,10 +1416,12 @@ static int shrink_memcg(struct mem_cgrou
 		unsigned long nr_to_walk = SWAP_CLUSTER_MAX;
 
 		shrunk += list_lru_walk_one(&zswap_list_lru, nid, memcg,
-					    &shrink_memcg_cb, NULL, &nr_to_walk);
+					    &shrink_memcg_cb, &ctl, &nr_to_walk);
 		scanned += SWAP_CLUSTER_MAX - nr_to_walk;
 	}
 
+	swap_write_submit(&ctl.io_ctx);
+
 	/* Nothing was scanned: every LRU under @memcg was empty. */
 	if (!scanned)
 		return -ENOENT;
_

Patches currently in -mm which might be from alex@ghiti.fr are

mm-zswap-batch-the-writeback-io-of-consecutive-entries.patch
mm-zswap-plug-the-writeback-io-of-an-lru-walk.patch

