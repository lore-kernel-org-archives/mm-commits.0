Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9271F5F6
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 01:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976493; cv=none; b=TGBc8QN/ycXYV22+kc1ENVqHIXnm2zYAerKgVgtxx3UN0wKfk/FNY5kWvNUcxsrdP2pH0DVnctQkTIAP3ZkH0OggHSQxy3hKtmUmJ0wmlkDUM3PM4Wk3cVXcZ0y+LUR2pm3bS6WYDV/MRyESr1ZwDz9Szuj2AEka0ym90fs+eGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976493; c=relaxed/simple;
	bh=jeY5lXulTm0nhYBCgsY0b3ZdN2arGcr6T2t/9NdQczU=;
	h=Date:To:From:Subject:Message-Id; b=LhIQ9/glqQwcW6H/CZJ+N/lG1Tsm040lW6ayliY+CvSWe/uwcT8xtL2IC44rrmhoFiWO2APxmwOHcvxxn9RLAMsamfRHxGNTRW73XPcOV9NKyqrCZ6HjMwOsT5x0kBzijwe/Qf0C/havZfvv9E2A22Rtoj51G7D6VBpFiTVZHLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DpaMAi0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DpaMAi0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4C2C4CEE3;
	Sun, 20 Jul 2025 01:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976493;
	bh=jeY5lXulTm0nhYBCgsY0b3ZdN2arGcr6T2t/9NdQczU=;
	h=Date:To:From:Subject:From;
	b=DpaMAi0SsnjU9YGAvQ6lrTHEoW6k8oPWB2DCzEA2ecRbyp7oJHc1LaeC56YxEo70B
	 S33FiZIyG2Q4HpBOQNVbx2I9cxuVLqt9PZoKAIULZRWH1dtS21AUtZbuAU8yfC0nih
	 6jD3hN5eMrSjicDP/cxRRxMZeVivkMdBZvKi5Mrs=
Date: Sat, 19 Jul 2025 18:54:52 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@redhat.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq-fix.patch removed from -mm tree
Message-Id: <20250720015453.4E4C2C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: optimize lru_note_cost() by adding lru_note_cost_unlock_irq() fix
has been removed from the -mm tree.  Its filename was
     mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq-fix.patch

This patch was dropped because it was folded into mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: optimize lru_note_cost() by adding lru_note_cost_unlock_irq() fix
Date: Tue, 15 Jul 2025 13:48:25 -0700 (PDT)

Delete the comment from above the deleted spin_lock_irq(): it was all to
justify the first iteration's spin_lock_irq(), none suitable for moving
down to where the parent's spin_lock_irq() is now done.

Link: https://lkml.kernel.org/r/dbf9352a-1ed9-a021-c0c7-9309ac73e174@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/swap.c~mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq-fix
+++ a/mm/swap.c
@@ -259,13 +259,6 @@ void lru_note_cost_unlock_irq(struct lru
 	for (;;) {
 		unsigned long lrusize;
 
-		/*
-		 * Hold lruvec->lru_lock is safe here, since
-		 * 1) The pinned lruvec in reclaim, or
-		 * 2) From a pre-LRU page during refault (which also holds the
-		 *    rcu lock, so would be safe even if the page was on the LRU
-		 *    and could move simultaneously to a new lruvec).
-		 */
 		/* Record cost event */
 		if (file)
 			lruvec->file_cost += cost;
_

Patches currently in -mm which might be from hughd@google.com are

mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq.patch
mm-shmem-hold-shmem_swaplist-spinlock-not-mutex-much-less.patch
mm-shmem-writeout-free-swap-if-swap_writeout-reactivates.patch
mm-shmem-writeout-free-swap-if-swap_writeout-reactivates-fix.patch

