Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67DB19E83C
	for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2025 21:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752700801; cv=none; b=rUcZwd8MPP78FV5rSthxJTzqozHBW/0bQSMWf1PHqfVVNgvRN15LykrExBi+mAmiaM31GKmsFNCDr4+dGCFDuUIwrfIFKa/6GkGjzAoeNSSOyjPOEsdJUkIhiXjKjLOd025APgGCDaxuO4wZE9000LT/vLfwgZ/P6+860WdQOT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752700801; c=relaxed/simple;
	bh=vZygl8S0e75OTjU12t42TWmFkzcHEO3/Xz9d9sGrZVU=;
	h=Date:To:From:Subject:Message-Id; b=WeqQDKvaMOKquyDGfEFJXvt4sZ3kITeCQSQOUySR+nF+zwAg5NbPCI5UE9ZYJxBuAMovgOl3b+lTIHVfCT+DKvRC42Akeuz2t+f1otUFDirA1bISHrn4oP3BzAdeErRIErejaCiUzqMYesHJRB8K5XqptoMvGC1JIsdQhZW3Tuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F/w5Cx4C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F/w5Cx4C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4441AC4CEE7;
	Wed, 16 Jul 2025 21:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752700801;
	bh=vZygl8S0e75OTjU12t42TWmFkzcHEO3/Xz9d9sGrZVU=;
	h=Date:To:From:Subject:From;
	b=F/w5Cx4CmIi0MzuE/6yMuGfCuTcVJxch+kzDXD59rSaz5icuMA6iDx2lSyEXHjerY
	 y11VIwKvdPF2M0QLKJQvSNgy3PzuUSzfYygmO3hEmTapp5RQCFbemsEXIcIgGnZE8u
	 m6QjYCRhjxABWmo1BiF3IhYbwczJRfP5vriNKcBs=
Date: Wed, 16 Jul 2025 14:20:00 -0700
To: mm-commits@vger.kernel.org,ydfan@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempool-fix-wake-up-edge-case-bug-for-zero-minimum-pools.patch added to mm-new branch
Message-Id: <20250716212001.4441AC4CEE7@smtp.kernel.org>
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
Date: Wed, 16 Jul 2025 23:37:30 +0800

The mempool wake-up mechanism has a edge case bug that affects pools
created with min_nr=0. When a thread blocks waiting for memory from an
empty pool (curr_nr == 0), subsequent mempool_free() calls fail to wake
the waiting thread because the condition "curr_nr < min_nr" evaluates
to "0 < 0" which is false, this causes threads to sleep indefinitely.

There is at least 2 places where the mempool created with min_nr=0:

1. lib/btree.c:191: mempool_create(0, btree_alloc, btree_free, NULL)
2. drivers/md/dm-verity-fec.c:791:
    mempool_init_slab_pool(&f->extra_pool, 0, f->cache)

Add an explicit check in mempool_free() to handle the min_nr=0 case:
when the pool has zero minimum reserves, is currently empty, and has
active waiters, wake them up. The wq_has_sleeper() avoids unnecessary
wake-ups when no threads are waiting.

Link: https://lkml.kernel.org/r/8c0cdb71-8d21-497e-b793-c43ce3a16345@suse.com
Signed-off-by: Yadan Fan <ydfan@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/mm/mempool.c~mm-mempool-fix-wake-up-edge-case-bug-for-zero-minimum-pools
+++ a/mm/mempool.c
@@ -545,6 +545,22 @@ void mempool_free(void *element, mempool
 		}
 		spin_unlock_irqrestore(&pool->lock, flags);
 	}
+	/*
+	 * Handle the min_nr = 0 edge case:
+	 * For zero-minimum pools, curr_nr < min_nr (0 < 0) never succeeds,
+	 * so waiters sleeping on pool->wait would never be woken by the
+	 * normal wake-up path. This explicit check ensures that when
+	 * pool->min_nr == 0 and pool->curr_nr == 0, any active waiters
+	 * are properly awakened.
+	 * The wq_has_sleeper() avoids unnecessary wake-ups when no
+	 * threads are waiting.
+	 */
+	if (unlikely(pool->min_nr == 0 &&
+		     READ_ONCE(pool->curr_nr) == 0 &&
+		     wq_has_sleeper(&pool->wait))) {
+		wake_up(&pool->wait);
+	}�   
+
 	pool->free(element, pool->pool_data);
 }
 EXPORT_SYMBOL(mempool_free);
_

Patches currently in -mm which might be from ydfan@suse.com are

mm-mempool-fix-wake-up-edge-case-bug-for-zero-minimum-pools.patch

