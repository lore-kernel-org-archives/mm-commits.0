Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA80E446A1
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 03:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729739438; cv=none; b=Kiu9kAeOQopuMCbiWlzuzwCpVmnzmCEKaFpK1ZW1GLy1z7G8p+dZ3jZed5TJ11LnCtQfoQYR6jV5hOZUi9pLig1cRA1bAwDw28jx6gy+nLYqqoqhjIZmyw0yfZk7BbIfUYGnV/31lrU70/bjfLPD66ck+g1YfJAOndJC0ZkdgzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729739438; c=relaxed/simple;
	bh=KMcdJ3TzX/veQCtFbVi3lu2MoRgnxRGgy5i1FnwgG7U=;
	h=Date:To:From:Subject:Message-Id; b=kEroOSPu49DfyXpdbrxBozk1EtrTeDgCVvAaZonSQeRLiRnI8wob2/I3GSV1ObzCV0kjpWnX/4o6d5OKJNNuaxWb3r/i1oPo/86Dq/Zy7LP7RIlj9FzCcyq+JSP/qqrP+NYDdUhz9kN+kHwXJEmcDzfLHTLZuuCzSLSZwNM6dxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tU9wFAiU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tU9wFAiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A570C4CEC6;
	Thu, 24 Oct 2024 03:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729739438;
	bh=KMcdJ3TzX/veQCtFbVi3lu2MoRgnxRGgy5i1FnwgG7U=;
	h=Date:To:From:Subject:From;
	b=tU9wFAiUjGZaFeQt5BRR19wKpWUIxu1z0esrHzHGB5OEvs4EyX8007pyZWa52ipJW
	 YGwAtp83XpAl/5VTz4aawmhIl90eYRY0LUvGki+ZyPECS/LurwhnpDgPyEutvmCA3H
	 YXM0Z20JrZhmsH18kxoS7gnaUon8CVQxspdLAabo=
Date: Wed, 23 Oct 2024 20:10:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,kan.liang@linux.intel.com,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,corbet@lwn.net,colyli@suse.de,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bcache-update-min_heap_callbacks-to-use-default-builtin-swap.patch added to mm-nonmm-unstable branch
Message-Id: <20241024031038.4A570C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bcache: update min_heap_callbacks to use default builtin swap
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bcache-update-min_heap_callbacks-to-use-default-builtin-swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bcache-update-min_heap_callbacks-to-use-default-builtin-swap.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: bcache: update min_heap_callbacks to use default builtin swap
Date: Sun, 20 Oct 2024 12:01:57 +0800

Replace the swp function pointer in the min_heap_callbacks of bcache with
NULL, allowing direct usage of the default builtin swap implementation. 
This modification simplifies the code and improves performance by removing
unnecessary function indirection.

Link: https://lkml.kernel.org/r/20241020040200.939973-8-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Coly Li <colyli@suse.de>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "Liang, Kan" <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Sakai <msakai@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bcache/alloc.c    |   11 ++---------
 drivers/md/bcache/bset.c     |   14 +++-----------
 drivers/md/bcache/extents.c  |   10 +---------
 drivers/md/bcache/movinggc.c |   10 +---------
 4 files changed, 7 insertions(+), 38 deletions(-)

--- a/drivers/md/bcache/alloc.c~bcache-update-min_heap_callbacks-to-use-default-builtin-swap
+++ a/drivers/md/bcache/alloc.c
@@ -189,23 +189,16 @@ static inline bool new_bucket_min_cmp(co
 	return new_bucket_prio(ca, *lhs) < new_bucket_prio(ca, *rhs);
 }
 
-static inline void new_bucket_swap(void *l, void *r, void __always_unused *args)
-{
-	struct bucket **lhs = l, **rhs = r;
-
-	swap(*lhs, *rhs);
-}
-
 static void invalidate_buckets_lru(struct cache *ca)
 {
 	struct bucket *b;
 	const struct min_heap_callbacks bucket_max_cmp_callback = {
 		.less = new_bucket_max_cmp,
-		.swp = new_bucket_swap,
+		.swp = NULL,
 	};
 	const struct min_heap_callbacks bucket_min_cmp_callback = {
 		.less = new_bucket_min_cmp,
-		.swp = new_bucket_swap,
+		.swp = NULL,
 	};
 
 	ca->heap.nr = 0;
--- a/drivers/md/bcache/bset.c~bcache-update-min_heap_callbacks-to-use-default-builtin-swap
+++ a/drivers/md/bcache/bset.c
@@ -1093,14 +1093,6 @@ static inline bool new_btree_iter_cmp(co
 	return bkey_cmp(_l->k, _r->k) <= 0;
 }
 
-static inline void new_btree_iter_swap(void *iter1, void *iter2, void __always_unused *args)
-{
-	struct btree_iter_set *_iter1 = iter1;
-	struct btree_iter_set *_iter2 = iter2;
-
-	swap(*_iter1, *_iter2);
-}
-
 static inline bool btree_iter_end(struct btree_iter *iter)
 {
 	return !iter->heap.nr;
@@ -1111,7 +1103,7 @@ void bch_btree_iter_push(struct btree_it
 {
 	const struct min_heap_callbacks callbacks = {
 		.less = new_btree_iter_cmp,
-		.swp = new_btree_iter_swap,
+		.swp = NULL,
 	};
 
 	if (k != end)
@@ -1157,7 +1149,7 @@ static inline struct bkey *__bch_btree_i
 	struct bkey *ret = NULL;
 	const struct min_heap_callbacks callbacks = {
 		.less = cmp,
-		.swp = new_btree_iter_swap,
+		.swp = NULL,
 	};
 
 	if (!btree_iter_end(iter)) {
@@ -1231,7 +1223,7 @@ static void btree_mergesort(struct btree
 		: bch_ptr_invalid;
 	const struct min_heap_callbacks callbacks = {
 		.less = b->ops->sort_cmp,
-		.swp = new_btree_iter_swap,
+		.swp = NULL,
 	};
 
 	/* Heapify the iterator, using our comparison function */
--- a/drivers/md/bcache/extents.c~bcache-update-min_heap_callbacks-to-use-default-builtin-swap
+++ a/drivers/md/bcache/extents.c
@@ -266,20 +266,12 @@ static bool new_bch_extent_sort_cmp(cons
 	return !(c ? c > 0 : _l->k < _r->k);
 }
 
-static inline void new_btree_iter_swap(void *iter1, void *iter2, void __always_unused *args)
-{
-	struct btree_iter_set *_iter1 = iter1;
-	struct btree_iter_set *_iter2 = iter2;
-
-	swap(*_iter1, *_iter2);
-}
-
 static struct bkey *bch_extent_sort_fixup(struct btree_iter *iter,
 					  struct bkey *tmp)
 {
 	const struct min_heap_callbacks callbacks = {
 		.less = new_bch_extent_sort_cmp,
-		.swp = new_btree_iter_swap,
+		.swp = NULL,
 	};
 	while (iter->heap.nr > 1) {
 		struct btree_iter_set *top = iter->heap.data, *i = top + 1;
--- a/drivers/md/bcache/movinggc.c~bcache-update-min_heap_callbacks-to-use-default-builtin-swap
+++ a/drivers/md/bcache/movinggc.c
@@ -190,14 +190,6 @@ static bool new_bucket_cmp(const void *l
 	return GC_SECTORS_USED(*_l) >= GC_SECTORS_USED(*_r);
 }
 
-static void new_bucket_swap(void *l, void *r, void __always_unused *args)
-{
-	struct bucket **_l = l;
-	struct bucket **_r = r;
-
-	swap(*_l, *_r);
-}
-
 static unsigned int bucket_heap_top(struct cache *ca)
 {
 	struct bucket *b;
@@ -212,7 +204,7 @@ void bch_moving_gc(struct cache_set *c)
 	unsigned long sectors_to_move, reserve_sectors;
 	const struct min_heap_callbacks callbacks = {
 		.less = new_bucket_cmp,
-		.swp = new_bucket_swap,
+		.swp = NULL,
 	};
 
 	if (!c->copy_gc_enabled)
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-kconfigdebug-move-int_pow-test-option-to-runtime-testing-section.patch
lib-makefile-make-union-find-compilation-conditional-on-config_cpusets.patch
lib-list_sort-remove-unnecessary-header-includes.patch
tools-lib-list_sort-remove-unnecessary-header-includes.patch
perf-tools-update-expected-diff-for-lib-list_sortc.patch
lib-min_heap-introduce-non-inline-versions-of-min-heap-api-functions.patch
lib-min_heap-optimize-min-heap-by-prescaling-counters-for-better-performance.patch
lib-min_heap-avoid-indirect-function-call-by-providing-default-swap.patch
lib-test_min_heap-update-min_heap_callbacks-to-use-default-builtin-swap.patch
perf-core-update-min_heap_callbacks-to-use-default-builtin-swap.patch
dm-vdo-update-min_heap_callbacks-to-use-default-builtin-swap.patch
bcache-update-min_heap_callbacks-to-use-default-builtin-swap.patch
bcachefs-clean-up-duplicate-min_heap_callbacks-declarations.patch
bcachefs-update-min_heap_callbacks-to-use-default-builtin-swap.patch
documentation-core-api-add-min-heap-api-introduction.patch

