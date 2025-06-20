Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09394322E;
	Fri, 20 Jun 2025 03:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750391353; cv=none; b=gcyBQyVoGZcy8HG0E10zZvrMAXGEkHNwsIOjteSb7s8X6sLgt0c8Cl2e13AywWxrfvSykmYT/WYEI1EzWMbF9QGpJTmOpCb6KqYR7fsv0Ps4SBXXL3FrY/xwHICZJHkWeT+BY2Y3wxdk78jsEGhiqc77/IVbk9m81hPMgTEkIHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750391353; c=relaxed/simple;
	bh=reIwi/1t48AtCx/6ffZfxfQdi0W+chWYuWIhk+7xuCI=;
	h=Date:To:From:Subject:Message-Id; b=KRNRalxXe8XUq6fxK2aZZtXdkG0YRer3oxF0n/nFlaj6v7OT7DMMUDPcwnoLB2Vn7GyNkXEjwMUvArLwCDtZc+JWwOnXIGez3v4ILDB3X31iQUycl9J7IHLEb2BH/paWGeCegLrYvcmBOpFhOwyG2nAgrhQFOrVUrgJ+EDXkkl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eShzxgZu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eShzxgZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF01DC4CEED;
	Fri, 20 Jun 2025 03:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750391352;
	bh=reIwi/1t48AtCx/6ffZfxfQdi0W+chWYuWIhk+7xuCI=;
	h=Date:To:From:Subject:From;
	b=eShzxgZujx/oWOGyzOCLMfxtOkPJwObmF7DPyaKje/4JFYuNR7mHkCc334IifPpmV
	 oeZ6M8RZSfbcU80bTiXBSHvvk+9EgQFDsHtQCD/S9m3AvXU7Znf/SqiclHiOhzpXgd
	 hS3kd71eCkrZeBnRVZe7uKmNsmVC3RH29H1g3lv8=
Date: Thu, 19 Jun 2025 20:49:12 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,robertpang@google.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,colyli@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-bcache-update-min_heap_callbacks-to-use-default-builtin-swap.patch removed from -mm tree
Message-Id: <20250620034912.CF01DC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "bcache: update min_heap_callbacks to use default builtin swap"
has been removed from the -mm tree.  Its filename was
     revert-bcache-update-min_heap_callbacks-to-use-default-builtin-swap.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: Revert "bcache: update min_heap_callbacks to use default builtin swap"
Date: Sun, 15 Jun 2025 04:23:51 +0800

Patch series "bcache: Revert min_heap migration due to performance
regression".

This patch series reverts the migration of bcache from its original heap
implementation to the generic min_heap library.  While the original change
aimed to simplify the code and improve maintainability, it introduced a
severe performance regression in real-world scenarios.

As reported by Robert, systems using bcache now suffer from periodic
latency spikes, with P100 (max) latency increasing from 600 ms to 2.4
seconds every 5 minutes.  This degrades bcache's value as a low-latency
caching layer, and leads to frequent timeouts and application stalls in
production environments.

The primary cause of this regression is the behavior of the generic
min_heap implementation's bottom-up sift_down, which performs up to 2 *
log2(n) comparisons when many elements are equal.  The original top-down
variant used by bcache only required O(1) comparisons in such cases.  The
issue was further exacerbated by commit 92a8b224b833 ("lib/min_heap:
introduce non-inline versions of min heap API functions"), which
introduced non-inlined versions of the min_heap API, adding function call
overhead to a performance-critical hot path.


This patch (of 3):

This reverts commit 3d8a9a1c35227c3f1b0bd132c9f0a80dbda07b65.

Although removing the custom swap function simplified the code, this
change is part of a broader migration to the generic min_heap API that
introduced significant performance regressions in bcache.

As reported by Robert, bcache now suffers from latency spikes, with P100
(max) latency increasing from 600 ms to 2.4 seconds every 5 minutes. 
These regressions degrade bcache's effectiveness as a low-latency cache
layer and lead to frequent timeouts and application stalls in production
environments.

This revert is part of a series of changes to restore previous performance
by undoing the min_heap transition.

Link: https://lkml.kernel.org/r/20250614202353.1632957-1-visitorckw@gmail.com
Link: https://lore.kernel.org/lkml/CAJhEC05+0S69z+3+FB2Cd0hD+pCRyWTKLEOsc8BOmH73p1m+KQ@mail.gmail.com
Link: https://lkml.kernel.org/r/20250614202353.1632957-2-visitorckw@gmail.com
Fixes: 866898efbb25 ("bcache: remove heap-related macros and switch to generic min_heap")
Fixes: 92a8b224b833 ("lib/min_heap: introduce non-inline versions of min heap API functions")
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reported-by: Robert Pang <robertpang@google.com>
Closes: https://lore.kernel.org/linux-bcache/CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com
Acked-by: Coly Li <colyli@kernel.org>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bcache/alloc.c    |   11 +++++++++--
 drivers/md/bcache/bset.c     |   14 +++++++++++---
 drivers/md/bcache/extents.c  |   10 +++++++++-
 drivers/md/bcache/movinggc.c |   10 +++++++++-
 4 files changed, 38 insertions(+), 7 deletions(-)

--- a/drivers/md/bcache/alloc.c~revert-bcache-update-min_heap_callbacks-to-use-default-builtin-swap
+++ a/drivers/md/bcache/alloc.c
@@ -189,16 +189,23 @@ static inline bool new_bucket_min_cmp(co
 	return new_bucket_prio(ca, *lhs) < new_bucket_prio(ca, *rhs);
 }
 
+static inline void new_bucket_swap(void *l, void *r, void __always_unused *args)
+{
+	struct bucket **lhs = l, **rhs = r;
+
+	swap(*lhs, *rhs);
+}
+
 static void invalidate_buckets_lru(struct cache *ca)
 {
 	struct bucket *b;
 	const struct min_heap_callbacks bucket_max_cmp_callback = {
 		.less = new_bucket_max_cmp,
-		.swp = NULL,
+		.swp = new_bucket_swap,
 	};
 	const struct min_heap_callbacks bucket_min_cmp_callback = {
 		.less = new_bucket_min_cmp,
-		.swp = NULL,
+		.swp = new_bucket_swap,
 	};
 
 	ca->heap.nr = 0;
--- a/drivers/md/bcache/bset.c~revert-bcache-update-min_heap_callbacks-to-use-default-builtin-swap
+++ a/drivers/md/bcache/bset.c
@@ -1093,6 +1093,14 @@ static inline bool new_btree_iter_cmp(co
 	return bkey_cmp(_l->k, _r->k) <= 0;
 }
 
+static inline void new_btree_iter_swap(void *iter1, void *iter2, void __always_unused *args)
+{
+	struct btree_iter_set *_iter1 = iter1;
+	struct btree_iter_set *_iter2 = iter2;
+
+	swap(*_iter1, *_iter2);
+}
+
 static inline bool btree_iter_end(struct btree_iter *iter)
 {
 	return !iter->heap.nr;
@@ -1103,7 +1111,7 @@ void bch_btree_iter_push(struct btree_it
 {
 	const struct min_heap_callbacks callbacks = {
 		.less = new_btree_iter_cmp,
-		.swp = NULL,
+		.swp = new_btree_iter_swap,
 	};
 
 	if (k != end)
@@ -1149,7 +1157,7 @@ static inline struct bkey *__bch_btree_i
 	struct bkey *ret = NULL;
 	const struct min_heap_callbacks callbacks = {
 		.less = cmp,
-		.swp = NULL,
+		.swp = new_btree_iter_swap,
 	};
 
 	if (!btree_iter_end(iter)) {
@@ -1223,7 +1231,7 @@ static void btree_mergesort(struct btree
 		: bch_ptr_invalid;
 	const struct min_heap_callbacks callbacks = {
 		.less = b->ops->sort_cmp,
-		.swp = NULL,
+		.swp = new_btree_iter_swap,
 	};
 
 	/* Heapify the iterator, using our comparison function */
--- a/drivers/md/bcache/extents.c~revert-bcache-update-min_heap_callbacks-to-use-default-builtin-swap
+++ a/drivers/md/bcache/extents.c
@@ -266,12 +266,20 @@ static bool new_bch_extent_sort_cmp(cons
 	return !(c ? c > 0 : _l->k < _r->k);
 }
 
+static inline void new_btree_iter_swap(void *iter1, void *iter2, void __always_unused *args)
+{
+	struct btree_iter_set *_iter1 = iter1;
+	struct btree_iter_set *_iter2 = iter2;
+
+	swap(*_iter1, *_iter2);
+}
+
 static struct bkey *bch_extent_sort_fixup(struct btree_iter *iter,
 					  struct bkey *tmp)
 {
 	const struct min_heap_callbacks callbacks = {
 		.less = new_bch_extent_sort_cmp,
-		.swp = NULL,
+		.swp = new_btree_iter_swap,
 	};
 	while (iter->heap.nr > 1) {
 		struct btree_iter_set *top = iter->heap.data, *i = top + 1;
--- a/drivers/md/bcache/movinggc.c~revert-bcache-update-min_heap_callbacks-to-use-default-builtin-swap
+++ a/drivers/md/bcache/movinggc.c
@@ -190,6 +190,14 @@ static bool new_bucket_cmp(const void *l
 	return GC_SECTORS_USED(*_l) >= GC_SECTORS_USED(*_r);
 }
 
+static void new_bucket_swap(void *l, void *r, void __always_unused *args)
+{
+	struct bucket **_l = l;
+	struct bucket **_r = r;
+
+	swap(*_l, *_r);
+}
+
 static unsigned int bucket_heap_top(struct cache *ca)
 {
 	struct bucket *b;
@@ -204,7 +212,7 @@ void bch_moving_gc(struct cache_set *c)
 	unsigned long sectors_to_move, reserve_sectors;
 	const struct min_heap_callbacks callbacks = {
 		.less = new_bucket_cmp,
-		.swp = NULL,
+		.swp = new_bucket_swap,
 	};
 
 	if (!c->copy_gc_enabled)
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-math-gcd-use-static-key-to-select-implementation-at-runtime.patch
riscv-optimize-gcd-code-size-when-config_riscv_isa_zbb-is-disabled.patch
riscv-optimize-gcd-performance-on-risc-v-without-zbb-extension.patch

