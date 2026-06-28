Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16F330C63A
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 06:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782629154; cv=none; b=DaHBnJmb4qedJ2FiJxLaucvHkbaubSIjdR4u2FAzvO6kG7KObjun3u/yu8MqNS+foIEXc8co+a67fGHUzXwHcsqwWhETsRbqI4iu9ROKtz8G8r8v4dsChIHqq0+lnXmzh2gzbDgSR2fokBmWCduVkyKPs22/CBsR482QgGzYYGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782629154; c=relaxed/simple;
	bh=OiKyhcWJLRM2kWhGgZs7pWMIEa8T/2/aI0/BAIL2QVA=;
	h=Date:To:From:Subject:Message-Id; b=sepEv2JgE5Xp62teev9Ee2BwRn9R6+/8eMg8Hrgmhr74rno6bGCH3x+99HcEnr/mqRdoD3hVMxXiFz+acmxSsFNUXKW/i0dkEM8VdqNGK03u3P9ZABbGUPIZEtRK90f7VDUClWhLGIdbCdoFjuqK8dODplYT0GxVplZ99mU+o2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xPMZVty9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xPMZVty9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0061F000E9;
	Sun, 28 Jun 2026 06:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782629152;
	bh=epDm0iHWK/4DYq0BnEVn4jErh6wMHARZvmNDEGJlsjQ=;
	h=Date:To:From:Subject;
	b=xPMZVty9GNJzNqFSYQQDAT+iIC31tX0ilcvSpwbkBpWY2hp5HFHXxIFS4LeidBLbj
	 5OZNRn5Pvquga7WYjXjzG/Q3RNltQODpTLKxjStPaQWeB9ZTvWaZ+njquvhgW2nDj0
	 Q31cJ5dbCnz/DYkbe2o22i5kGE0rK4Ick4LJBYFU=
Date: Sat, 27 Jun 2026 23:45:52 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,riel@surriel.com,nphamcs@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch added to mm-new branch
Message-Id: <20260628064552.8E0061F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap_state: remove unnecessary lru_add_drain() from readahead
has been added to the -mm mm-new branch.  Its filename is
     mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch

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
From: Usama Arif <usama.arif@linux.dev>
Subject: mm/swap_state: remove unnecessary lru_add_drain() from readahead
Date: Mon, 8 Jun 2026 07:32:42 -0700

swap_cluster_readahead() and swap_vma_readahead() end the readahead loop
with an explicit lru_add_drain() call.  That drain is a leftover from
2.6.12 era code and serves no functional purpose for the callers:

- do_swap_page() ignores LRU residency for the readahead folios;
  it only needs the target folio it called swapin_readahead() for,
  and if the write-fault path needs the target folio on the LRU to count
  references accurately, it runs its own lru_add_drain() at the
  wp_can_reuse_anon_folio() and do_swap_page() sites.

- shmem_swapin_cluster() immediately locks the  returned folio, waits
  for writeback, then operates on it - LRU residency of either the target
  or the readahead folios is irrelevant.

- try_to_unuse() likewise locks the folio and calls unuse_pte() without
  depending on LRU presence.

Folios newly added to the swap cache by the readahead loop sit in the
per-CPU LRU folio_batch and will be drained naturally as the batch fills
(FOLIO_BATCH_SIZE),by the next reclaim/compaction lru_add_drain_all() and
so on.  The unconditional drain only synchronously flushes a partial batch
and forces contention on lruvec_lock.

On a 176-CPU production host running a memory-pressured workload, this
path was observed to call folio_batch_move_lru() from
swap_cluster_readahead() ~28K/min, a very large source of LRU lock
traffic.

This is a direct continuation of the cleanup started in commit
1aa43598c03b ("mm: remove unnecessary calls to lru_add_drain") which
removed the equivalent drain from free_pages_and_swap_cache() with the
same rationale.  A detailed reasoning for this is present in [1].

Remove both drains.

Link: https://lore.kernel.org/20260608143242.2869392-1-usama.arif@linux.dev
Link: https://lore.kernel.org/all/dca2824e8e88e826c6b260a831d79089b5b9c79d.camel@surriel.com/T/#u [1]
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/swap_state.c~mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead
+++ a/mm/swap_state.c
@@ -836,7 +836,6 @@ struct folio *swap_cluster_readahead(swp
 	}
 	blk_finish_plug(&plug);
 	swap_read_unplug(splug);
-	lru_add_drain();	/* Push any new pages onto the LRU now */
 skip:
 	/* The page was likely read above, so no need for plugging here */
 	return swap_cache_read_folio(entry, gfp_mask, mpol, ilx, NULL, false);
@@ -951,7 +950,6 @@ static struct folio *swap_vma_readahead(
 		pte_unmap(pte);
 	blk_finish_plug(&plug);
 	swap_read_unplug(splug);
-	lru_add_drain();
 skip:
 	/* The folio was likely read above, so no need for plugging here */
 	folio = swap_cache_read_folio(targ_entry, gfp_mask, mpol, targ_ilx,
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch

