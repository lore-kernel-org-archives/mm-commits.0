Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4849321ABD7
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409718; cv=none; b=MIIQTielJz97PwLA+9M7ZbDztbUuoid9ZM1CUuaJbi3Xh5ddjX6HIf2CNGcEXJPIJM28MD3QUXHasMjxhrPYtnnT8IK6ITXFBtumOifpQsdP3DNebljYX0K//PJMxlmF7+lxzLgnQM5o5lVDjH/7j2XlH+fgiZvFdWcVJD4wWSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409718; c=relaxed/simple;
	bh=wT+UBUSpzMWewItsIs2KzHb5mSsuwuE/HXLwqo9HPgs=;
	h=Date:To:From:Subject:Message-Id; b=C4Dk4lQEHlyGMbJ9yzCy52g1HkfUCbl71A3rOshvbz0YKgTzXXT57uiCjHCuLBpEIMYthcs9O95E47/EgYjAzPKxi4tMbwPLuXOOouF3K807Ln6xlyb3qKoZdz0hE/HMsOWyG2mbTyJ7d4kJg2yiNVGuTREq2prV49zaPqI2yYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v1zAm91n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v1zAm91n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBD4C4CEED;
	Fri, 25 Jul 2025 02:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409718;
	bh=wT+UBUSpzMWewItsIs2KzHb5mSsuwuE/HXLwqo9HPgs=;
	h=Date:To:From:Subject:From;
	b=v1zAm91nKLP0kT2fphLBBg1QYrbTavfDLuO5E8XDrtmeCxbsKAcbdhTMA/GvouNRR
	 0FzcgqQVmRZX5kKi6JgXwKymcEAO0mXcKITEzJf4qSgeN0Jc2/0hYL6b8NGHlad0vn
	 BaChgFqJcbUwO5giXIl8D5uvsc1EOXwhzEbwZgYk=
Date: Thu, 24 Jul 2025 19:15:17 -0700
To: mm-commits@vger.kernel.org,ydfan@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempool-fix-wake-up-edge-case-bug-for-zero-minimum-pools.patch removed from -mm tree
Message-Id: <20250725021518.1BBD4C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mempool: fix wake-up edge case bug for zero-minimum pools
has been removed from the -mm tree.  Its filename was
     mm-mempool-fix-wake-up-edge-case-bug-for-zero-minimum-pools.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yadan Fan <ydfan@suse.com>
Subject: mm: mempool: fix wake-up edge case bug for zero-minimum pools
Date: Sat, 19 Jul 2025 06:06:51 +0800

The mempool wake-up path has a edge case bug that affects pools created
with min_nr=0.  When a thread blocks waiting for memory from an empty pool
(curr_nr == 0), subsequent mempool_free() calls fail to wake the waiting
thread because the condition "curr_nr < min_nr" evaluates to "0 < 0" which
is false, this can cause threads to sleep indefinitely according to the
code logic.

There is at least 2 places where the mempool created with min_nr=0:

1. lib/btree.c:191: mempool_create(0, btree_alloc, btree_free, NULL)
2. drivers/md/dm-verity-fec.c:791:
 mempool_init_slab_pool(&f->extra_pool, 0, f->cache)

Add an explicit check in mempool_free() to handle the min_nr=0 case: when
the pool has zero minimum reserves, is currently empty, and has active
waiters, allocate the element then wake up the sleeper.

Link: https://lkml.kernel.org/r/f28a81ba-615c-481e-86fb-c0bf4115ec89@suse.com
Signed-off-by: Yadan Fan <ydfan@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

--- a/mm/mempool.c~mm-mempool-fix-wake-up-edge-case-bug-for-zero-minimum-pools
+++ a/mm/mempool.c
@@ -540,11 +540,43 @@ void mempool_free(void *element, mempool
 		if (likely(pool->curr_nr < pool->min_nr)) {
 			add_element(pool, element);
 			spin_unlock_irqrestore(&pool->lock, flags);
-			wake_up(&pool->wait);
+			if (wq_has_sleeper(&pool->wait))
+				wake_up(&pool->wait);
 			return;
 		}
 		spin_unlock_irqrestore(&pool->lock, flags);
 	}
+
+	/*
+	 * Handle the min_nr = 0 edge case:
+	 *
+	 * For zero-minimum pools, curr_nr < min_nr (0 < 0) never succeeds,
+	 * so waiters sleeping on pool->wait would never be woken by the
+	 * wake-up path of previous test. This explicit check ensures the
+	 * allocation of element when both min_nr and curr_nr are 0, and
+	 * any active waiters are properly awakened.
+	 *
+	 * Inline the same logic as previous test, add_element() cannot be
+	 * directly used here since it has BUG_ON to deny if min_nr equals
+	 * curr_nr, so here picked rest of add_element() to use without
+	 * BUG_ON check.
+	 */
+	if (unlikely(pool->min_nr == 0 &&
+		     READ_ONCE(pool->curr_nr) == 0)) {
+		spin_lock_irqsave(&pool->lock, flags);
+		if (likely(pool->curr_nr == 0)) {
+			/* Inline the logic of add_element() */
+			poison_element(pool, element);
+			if (kasan_poison_element(pool, element))
+				pool->elements[pool->curr_nr++] = element;
+			spin_unlock_irqrestore(&pool->lock, flags);
+			if (wq_has_sleeper(&pool->wait))
+				wake_up(&pool->wait);
+			return;
+		}
+		spin_unlock_irqrestore(&pool->lock, flags);
+	}
+
 	pool->free(element, pool->pool_data);
 }
 EXPORT_SYMBOL(mempool_free);
_

Patches currently in -mm which might be from ydfan@suse.com are


