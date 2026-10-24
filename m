Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832472;
	b=bvHIOHJdJ5vRVAFqi/9NSWa9gsJYbnn2MCb6t93H4w/SG+SIWed829Geb4d4pi0Mp//b
	 cPDfs3kQaFFiPTMW+Mo/SG3Jy7pp66v/4obj1EVxNLylbJA3gJ4tKUpi3yZRfL4a//H0/
	 Sd0PemJONRcSX7AnI4yKjurIT545PP+t7ROj4wCylyQXyIburWv/5rKTIFQv1q+zYXaOQ
	 /d006jd0orF8ZtZReEXSKakQpzfvVknCK104F5NrItGLfHRhExiYHnAjE1NiVMpgRY+we
	 NYYn4U1FlfzWMKMjgfuM1IOzWLCCbtMFnZIPw4PW4uKBlvxZd1BW8X2CpywwmZSK9kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832472;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=iiCmLtEq8Hu+sMvT6bOf/AnIIsNXMyXoF1OXquPQJOg=;
	b=FrSkUAfOeS+akDAbWaJoRoX5jUiCtDTSYUUFmFARNZ/iwpqcgdMTVhZn2qzTAwfMQ9hr
	 ce7wZSLtyOTl4y+pIPRWlty0TEpMhbaO6rj2ffhZWw/xYAgvTu66eOgvFc3tAWfiiAP9b
	 PuTAzkeoxFcDvCk5aiXA15ByfeMWQBYgKDIxg8+wwnQ/ImeBRrj8o9JkSBXQWDGxuICNQ
	 /L79sutUGQBFFxudCX9rzL7Ocrr2UHs8iDqmWEImDPo/G/3bw3GYF58T2VqBxs41BxMBm
	 f0gNjV4XAV235p3Ockf50Lvw1twk21Vdh+3BrPj/tbUq03SuUvRa8COgV1jpJTa3AIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="oPiK/hAt";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACC0606A31B;
	Sat, 24 Oct 2026 09:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oPiK/hAt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047391F01828;
	Sat, 24 Oct 2026 09:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832472;
	bh=iiCmLtEq8Hu+sMvT6bOf/AnIIsNXMyXoF1OXquPQJOg=;
	h=Date:To:From:Subject;
	b=oPiK/hAtcPLotTSOVVXf4O2IUCtxbCdwbWlufTcrHfsWqcvzdhGdD7B3spixyiWoh
	 gRPtzLHvMg9VEuGre16ZB6Etb3oYGTfNr5eA3HizHcm31BVFLeNS9O6+G6zNdUsR5X
	 3eqy504xHS4g+jb1dhyirerxDkTIElIkuGyQFpLI=
Date: Sat, 24 Oct 2026 02:01:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,mhocko@suse.com,harry@kernel.org,hannes@cmpxchg.org,david@kernel.org,brendan.jackman@linux.dev,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch removed from -mm tree
Message-Id: <20261024090112.047391F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: page_alloc: make defrag_mode retries follow the promoted order
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm: page_alloc: make defrag_mode retries follow the promoted order
Date: Tue, 13 Oct 2026 18:37:20 +0100

Since commit 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim storm
in defrag_mode"), direct reclaim and compaction for non-movable requests
under defrag_mode run at pageblock_order, to produce the whole blocks that
ALLOC_NOFRAGMENT needs.  The retry decisions that follow still use the
request order.  An order-0 request can therefore retry indefinitely
without ever reaching the ALLOC_NOFRAGMENT fallback:

- Reclaim at pageblock_order gives up after one pass as soon as a zone
  looks compaction_ready(), and do_try_to_free_pages() then returns 1
  even though nothing was reclaimed. It returns before the retry that
  would reclaim memory.low-protected cgroups, so when most memory is
  protected, the pass that did run finds next to nothing.

- Compaction at pageblock_order fails or is deferred.

- should_reclaim_retry() takes the reported progress as progress for
  the order-0 request and resets no_progress_loops. The request
  retries.

Order 1-3 requests loop the same way, and should_compact_retry() also
checks their pageblock_order compaction result against the request order.

On a production host (64G, defrag_mode, memory.low covering most of the
workload), 95% of direct reclaim runs were order-9 runs that returned 1
with nothing reclaimed, at up to 60k runs per second.  Across ~200M
should_reclaim_retry() calls in a day, no_progress_loops never left 0. 
The spinning allocations were SLUB slab refills for inode and dentry
caches.  The time spent registers as memory pressure, and pressure-based
OOM killing takes down both workloads and system services.

For promoted requests:

- Reclaim progress does not reset no_progress_loops, as for costly
  orders.

- should_compact_retry() checks the compaction result at the promoted
  order and does not retry COMPACT_SKIPPED, since the request can fall
  back. The compaction priority floor and the COMPACT_SUCCESS retry
  limit stay those of the request order, so a non-costly request still
  gets its COMPACT_PRIO_SYNC_FULL pass before it falls back.

When a promoted request takes the fallback, reset the retry counters, so
that the fallback attempt gets a full retry budget before the OOM killer
is considered.  A request whose reclaim was not promoted spent its budget
on the request itself and keeps its counters, as Usama Arif pointed out.

__alloc_pages_slowpath() computes the promoted order once per iteration
and keeps it in alloc_context for direct reclaim, direct compaction and
the two retry helpers, so no callee has to recompute it.  Harry Yoo asked
for the promoted order to be explicit rather than derived in each callee,
and Vlastimil Babka suggested alloc_context over new function parameters.

In a VM reproducer (32G, defrag_mode, inode churn under memory.low):

                                        before    after
    should_reclaim_retry() calls           63M     293k
    peak memory pressure (PSI some avg10)  99%      12%

File creation runs 5.7x faster.

[kas@kernel.org: s/order_nofrag_promoted/order_defrag_promoted/, per hannes]
  Link: https://lore.kernel.org/atDL-nSFP2KVU7cI@thinkstation
Link: https://lore.kernel.org/as5q14OsbK2CmOrh@thinkstation
Fixes: 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim storm in defrag_mode")
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Assisted-by: LLM
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
---

 mm/page_alloc.c |   65 +++++++++++++++++++++++++++-------------------
 mm/page_alloc.h |    2 +
 2 files changed, 41 insertions(+), 26 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order
+++ a/mm/page_alloc.c
@@ -4117,6 +4117,12 @@ out:
 	return page;
 }
 
+static inline bool order_defrag_promoted(unsigned int order,
+					 const struct alloc_context *ac)
+{
+	return ac->reclaim_compact_order != order;
+}
+
 /*
  * Maximum number of compaction retries with a progress before OOM
  * killer is consider as the only way to move forward.
@@ -4139,22 +4145,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		.order = order,
 		.page = NULL,
 	};
-	int compact_order = order;
-
-	/*
-	 * If fallbacks are not permitted (defrag_mode), we either
-	 * need to reclaim space in a block of matching type, or clear
-	 * out an entire block to allow __rmqueue_claim() to convert.
-	 *
-	 * Reclaim by itself is primarily freeing space in movable
-	 * blocks, since that's where the LRU pages live. So this
-	 * works for movable requests, but not for others.
-	 *
-	 * For those, promote the order to help make blocks, instead
-	 * of spinning in reclaim alone unproductively.
-	 */
-	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
-		compact_order = max(order, pageblock_order);
+	int compact_order = ac->reclaim_compact_order;
 
 	if (!compact_order)
 		return NULL;
@@ -4247,7 +4238,7 @@ should_compact_retry(gfp_t gfp_mask, str
 	int retries = *compaction_retries;
 	enum compact_priority priority = *compact_priority;
 
-	if (!order)
+	if (!ac->reclaim_compact_order)
 		return false;
 
 	if (fatal_signal_pending(current))
@@ -4256,10 +4247,12 @@ should_compact_retry(gfp_t gfp_mask, str
 	/*
 	 * Compaction was skipped due to a lack of free order-0
 	 * migration targets. Continue if reclaim can help.
+	 * Promoted requests fall back instead.
 	 */
 	if (compact_result == COMPACT_SKIPPED) {
-		ret = compaction_zonelist_suitable(ac, order, alloc_flags,
-						   gfp_mask);
+		if (!order_defrag_promoted(order, ac))
+			ret = compaction_zonelist_suitable(ac, order,
+							   alloc_flags, gfp_mask);
 		goto out;
 	}
 
@@ -4458,11 +4451,7 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 	struct page *page = NULL;
 	unsigned long pflags;
 	bool drained = false;
-	int reclaim_order = order;
-
-	/* Match the slowpath compaction promotion in __alloc_pages_direct_compact */
-	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
-		reclaim_order = max(order, pageblock_order);
+	int reclaim_order = ac->reclaim_compact_order;
 
 	psi_memstall_enter(&pflags);
 	*did_some_progress = __perform_reclaim(gfp_mask, reclaim_order, ac);
@@ -4638,9 +4627,12 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 	/*
 	 * Costly allocations might have made a progress but this doesn't mean
 	 * their order will become available due to high fragmentation so
-	 * always increment the no progress counter for them
+	 * always increment the no progress counter for them. The same goes for
+	 * promoted requests: their reclaim reports progress when it backs off
+	 * for compaction without freeing anything.
 	 */
-	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER)
+	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER &&
+	    !order_defrag_promoted(order, ac))
 		*no_progress_loops = 0;
 	else
 		(*no_progress_loops)++;
@@ -4924,6 +4916,22 @@ retry:
 	/* If allocation has taken excessively long, warn about it */
 	check_alloc_stall_warn(gfp_mask, ac->nodemask, order, alloc_start_time);
 
+	/*
+	 * If fallbacks are not permitted (defrag_mode), we either
+	 * need to reclaim space in a block of matching type, or clear
+	 * out an entire block to allow __rmqueue_claim() to convert.
+	 *
+	 * Reclaim by itself is primarily freeing space in movable
+	 * blocks, since that's where the LRU pages live. So this
+	 * works for movable requests, but not for others.
+	 *
+	 * For those, promote the order to help make blocks, instead
+	 * of spinning in reclaim alone unproductively.
+	 */
+	ac->reclaim_compact_order = order;
+	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
+		ac->reclaim_compact_order = max(order, pageblock_order);
+
 	/* Try direct reclaim and then allocating */
 	if (!compact_first) {
 		page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags,
@@ -5005,6 +5013,11 @@ retry:
 	/* Reclaim/compaction failed to prevent the fallback */
 	if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT)) {
 		alloc_flags &= ~ALLOC_NOFRAGMENT;
+		/* Retries went into making blocks, start the fallback afresh */
+		if (order_defrag_promoted(order, ac)) {
+			no_progress_loops = 0;
+			compaction_retries = 0;
+		}
 		goto retry;
 	}
 
--- a/mm/page_alloc.h~mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order
+++ a/mm/page_alloc.h
@@ -93,6 +93,8 @@ struct alloc_context {
 	bool spread_dirty_pages;
 	/* Only flags that are global to the whole allocation go here. */
 	unsigned int alloc_flags;
+	/* Set by __alloc_pages_slowpath() before reclaim and compaction */
+	unsigned int reclaim_compact_order;
 };
 
 /*
_

Patches currently in -mm which might be from kas@kernel.org are


