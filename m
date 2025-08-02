Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093C3255248
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160891; cv=none; b=Ob3Zz2sg+rtNfO42lgtZm2FNbiJ4XqFGt4j0kcXG63aUuqU3PX6PMyPhlt00qR3QVezLbDdSMxJoPKLH8vpNyThT7GrwqATlAeR1mbuC6WcK8+izAkoibAbg2Dhbr3JdlqF9U9pOFdC9XfAgoZR7E/6RqrUmeArzxoC/d5QnEtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160891; c=relaxed/simple;
	bh=Fc1Tn/HHNs51JN0eA74wkLFE2+/f849oUrsZAQo+VJc=;
	h=Date:To:From:Subject:Message-Id; b=eAStOAswVI/Zc440OWP9aQlXtuZqdV6ca4D3RTNAj2JMzGffDmRrdLGJzIJd/aZ5E0FxglhbwVZV6GUCNm4P80m4c6kyNz6vDGIcyBTcVOcssvwu41elm3hBq1MlpBKKxYXpqqDmdVxscZRlpkS6cnfrFGrM4d40yFgBgT5guFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fMeRbN6y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fMeRbN6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A46C4CEEF;
	Sat,  2 Aug 2025 18:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160890;
	bh=Fc1Tn/HHNs51JN0eA74wkLFE2+/f849oUrsZAQo+VJc=;
	h=Date:To:From:Subject:From;
	b=fMeRbN6y5tHzNy/FohCMMqvNQRx7+bi9fArPAVt17glgl/hNVPs6d4a9wkLv9UOS4
	 Wrgi++4IomhvVzn62haqNH5sYHthkoubUtb2vCWyrSusB9wMd7GlDTa3s+7BGLg2wu
	 FGQRkCmblv+wtkeIg19YJisGDKFWKBYKCT7Zg9h4=
Date: Sat, 02 Aug 2025 11:54:50 -0700
To: mm-commits@vger.kernel.org,ydfan@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempool-fix-crash-in-mempool_free-for-zero-minimum-pools.patch removed from -mm tree
Message-Id: <20250802185450.D3A46C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mempool: fix crash in mempool_free() for zero-minimum pools
has been removed from the -mm tree.  Its filename was
     mm-mempool-fix-crash-in-mempool_free-for-zero-minimum-pools.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yadan Fan <ydfan@suse.com>
Subject: mm: mempool: fix crash in mempool_free() for zero-minimum pools
Date: Fri, 1 Aug 2025 02:14:45 +0800

The mempool wake-up fix introduced in commit a5867a218d7c ("mm: mempool:
fix wake-up edge case bug for zero-minimum pools") inlined the
add_element() logic in mempool_free() to return the element to the
zero-minimum pool:

pool->elements[pool->curr_nr++] = element;

This causes crash, because mempool_init_node() does not initialize with
real allocation for zero-minimum pool, it only returns ZERO_SIZE_PTR to
the elements array which is unable to be dereferenced, and the
pre-allocation of this array never happened since the while test:

while (pool->curr_nr < pool->min_nr)

can never be satisfied as min_nr is zero, so the pool does not actually
reserve any buffer, the only way so far is to call alloc_fn() to get
buffer from SLUB, but if the memory is under high pressure the alloc_fn()
could never get any buffer, the waiting thread would be in an indefinite
loop of wake-sleep in a period until there is free memory to get.

This patch changes mempool_init_node() to allocate 1 element for the
elements array of zero-minimum pool, so that the pool will have reserved
buffer to use.  This will fix the crash issue and let the waiting thread
can get the reserved element when alloc_fn() failed to get buffer under
high memory pressure.

Also modify add_element() to support zero-minimum pool with simplifying
codes of zero-minimum handling in mempool_free().

Link: https://lkml.kernel.org/r/e01f00f3-58d9-4ca7-af54-bfa42fec9527@suse.com
Fixes: a5867a218d7c ("mm: mempool: fix wake-up edge case bug for zero-minimum pools")
Signed-off-by: Yadan Fan <ydfan@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

--- a/mm/mempool.c~mm-mempool-fix-crash-in-mempool_free-for-zero-minimum-pools
+++ a/mm/mempool.c
@@ -136,7 +136,7 @@ static void kasan_unpoison_element(mempo
 
 static __always_inline void add_element(mempool_t *pool, void *element)
 {
-	BUG_ON(pool->curr_nr >= pool->min_nr);
+	BUG_ON(pool->min_nr != 0 && pool->curr_nr >= pool->min_nr);
 	poison_element(pool, element);
 	if (kasan_poison_element(pool, element))
 		pool->elements[pool->curr_nr++] = element;
@@ -202,16 +202,20 @@ int mempool_init_node(mempool_t *pool, i
 	pool->alloc	= alloc_fn;
 	pool->free	= free_fn;
 	init_waitqueue_head(&pool->wait);
-
-	pool->elements = kmalloc_array_node(min_nr, sizeof(void *),
+	/*
+	 * max() used here to ensure storage for at least 1 element to support
+	 * zero minimum pool
+	 */
+	pool->elements = kmalloc_array_node(max(1, min_nr), sizeof(void *),
 					    gfp_mask, node_id);
 	if (!pool->elements)
 		return -ENOMEM;
 
 	/*
-	 * First pre-allocate the guaranteed number of buffers.
+	 * First pre-allocate the guaranteed number of buffers,
+	 * also pre-allocate 1 element for zero minimum pool.
 	 */
-	while (pool->curr_nr < pool->min_nr) {
+	while (pool->curr_nr < max(1, pool->min_nr)) {
 		void *element;
 
 		element = pool->alloc(gfp_mask, pool->pool_data);
@@ -555,20 +559,12 @@ void mempool_free(void *element, mempool
 	 * wake-up path of previous test. This explicit check ensures the
 	 * allocation of element when both min_nr and curr_nr are 0, and
 	 * any active waiters are properly awakened.
-	 *
-	 * Inline the same logic as previous test, add_element() cannot be
-	 * directly used here since it has BUG_ON to deny if min_nr equals
-	 * curr_nr, so here picked rest of add_element() to use without
-	 * BUG_ON check.
 	 */
 	if (unlikely(pool->min_nr == 0 &&
 		     READ_ONCE(pool->curr_nr) == 0)) {
 		spin_lock_irqsave(&pool->lock, flags);
 		if (likely(pool->curr_nr == 0)) {
-			/* Inline the logic of add_element() */
-			poison_element(pool, element);
-			if (kasan_poison_element(pool, element))
-				pool->elements[pool->curr_nr++] = element;
+			add_element(pool, element);
 			spin_unlock_irqrestore(&pool->lock, flags);
 			if (wq_has_sleeper(&pool->wait))
 				wake_up(&pool->wait);
_

Patches currently in -mm which might be from ydfan@suse.com are


