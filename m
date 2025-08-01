Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C3A21D59C
	for <mm-commits@vger.kernel.org>; Fri,  1 Aug 2025 20:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754081881; cv=none; b=SgeoX8xnfYhyHK/ZBNilchsckkW3KTNyr6gx71SXAcTB1ECUaC4MnsR21S1rIsr8QYIp9KqI5YeKDF221U3MyoGWpl9xLy8vtUhJVfS0rvKPJzGUSXPbWxmGkO124L5/UdVoNZEESvExUGMxDE3YVQzBPB4CQoCqiTkkrFIZ6oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754081881; c=relaxed/simple;
	bh=d9sBpSKWFTNU2OH6dZ5Lown/8Hb8ZvM/9T5NzHVmS+w=;
	h=Date:To:From:Subject:Message-Id; b=GuM5Rjtfam7tv7kkfibLzTBr4d2jBgJNIZOhN8xvTVyD/fZ1j3qOzoIpdsj/9SXcX+1psr6v2Gd1bcD1bowh6POVb8twF7Thhih+lSG6v6qMmxg25IThnfV0xq/WG6RuEwQBtPfXPoVX+Cf5M8yS/AXl67/Nv3OnsG+WuxTUykw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f+FsvWnP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f+FsvWnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0831C4CEE7;
	Fri,  1 Aug 2025 20:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754081881;
	bh=d9sBpSKWFTNU2OH6dZ5Lown/8Hb8ZvM/9T5NzHVmS+w=;
	h=Date:To:From:Subject:From;
	b=f+FsvWnPjja/jAeORCBbQRaziG1/ih3PZ5BibER+NzZMVtsqJgX4MeZaA8+9Cu/xC
	 9P3+EnjwGqNIGxOOMEPsJdOGdpK10yy9NVUp+qlVR4LfUfX1sL7fnWHk+r9XDuxbuf
	 0f/ukbULZk1uiVcPb0NEuy+X5HYbdbv/qYyhfeDY=
Date: Fri, 01 Aug 2025 13:58:00 -0700
To: mm-commits@vger.kernel.org,ydfan@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempool-fix-crash-in-mempool_free-for-zero-minimum-pools.patch added to mm-unstable branch
Message-Id: <20250801205800.F0831C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mempool: fix crash in mempool_free() for zero-minimum pools
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempool-fix-crash-in-mempool_free-for-zero-minimum-pools.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempool-fix-crash-in-mempool_free-for-zero-minimum-pools.patch

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

mm-mempool-fix-crash-in-mempool_free-for-zero-minimum-pools.patch

