Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEF11C861E
	for <mm-commits@vger.kernel.org>; Sat, 19 Jul 2025 23:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752969482; cv=none; b=EPOE2zC+8RH0Q+Wcb0vvTo4kSgd0MUQWrsxfjnwT9QzGYlWYs5L+CHejtmvQrR5Xo4QqG7ns9fLMefzotkQCUmEFK/FEv4OlhiZO5ix5kMBgRxUWvfRcP4xlRO6gt8IfD2T2WUyHWWRzIToS5q3zQ3Dvp+b44MUXL4Zn/pjDXQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752969482; c=relaxed/simple;
	bh=2jPJpuBe98SlG9uRgeBepZ4lKiyuihuu8o/Wq/J1q+Q=;
	h=Date:To:From:Subject:Message-Id; b=TGKbFj4qCriKOlLVgdOQ9ude/mOHLkUy7gofNpevMmpt+iB+Do9ax7Rlgf3/M1+bdeFKa56Uke6LW9F28rriRE8RGobKeWss/F5wmpp6vOi0JvdR4WjrTUR97Lp1og2lO6+75HA4Nnqlgdq0NldDjiwtAhXd2RYTTfgerdeGqKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lXgmLYey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lXgmLYey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD9CC4CEE3;
	Sat, 19 Jul 2025 23:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752969482;
	bh=2jPJpuBe98SlG9uRgeBepZ4lKiyuihuu8o/Wq/J1q+Q=;
	h=Date:To:From:Subject:From;
	b=lXgmLYeyWYBZ1w4E2fvOmSBntoGeTI7HD3F6nSk7PVkNzuzxtVbtd7fKIR19jt0Qc
	 z1nUyZl+hfoAFtH8KP9LFsw8exQN8LjxzFlVHQyMeaAL6NwDz48fmAD+tfk5rcQ3wF
	 Y9CyDhr6Iy+na7x72vM969XoqhT0B4JVjKrylFJI=
Date: Sat, 19 Jul 2025 16:58:01 -0700
To: mm-commits@vger.kernel.org,ydfan@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempool-fix-wake-up-edge-case-bug-for-zero-minimum-pools.patch added to mm-new branch
Message-Id: <20250719235801.EAD9CC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mempool: fix wake-up edge case bug for zero-minimum pools
has been added to the -mm mm-new branch.  Its filename is
     mm-mempool-fix-wake-up-edge-case-bug-for-zero-minimum-pools.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempool-fix-wake-up-edge-case-bug-for-zero-minimum-pools.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

mm-mempool-fix-wake-up-edge-case-bug-for-zero-minimum-pools.patch

