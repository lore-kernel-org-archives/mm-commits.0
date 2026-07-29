Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7093939A2
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298509; cv=none; b=ZyrQ15qv1RntwJ1YDMk+6bEgflu4VvoOHwIf2coy7EmUAmGPIss35DTxFijFhEge9Juelsg42e5hWkqxMi2znDQyUaLn6gk5vSi3Rfd7jMXEMvJ+BHxdDAQyz24UoE907bkbQ1y/YL47XWgME8jwRk+kZe49oD0T2MT2jMwqqts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298509; c=relaxed/simple;
	bh=zGaiRUatGmotsoJpGOMbkKlcHRh8nwgCIOGNHPBWrmk=;
	h=Date:To:From:Subject:Message-Id; b=KaSDLT+04Odajch71hBMcOY8WeatpeTB7ZiHuBIBmdqYQX6kvvWpiuoHGcmpBvhx1h71dcWlBYU8wor9KkaElg1VLVuYajGsk2p7lL0myGRXUfYym4OWiSDrkbUIPf3PRoKOTEwuUiEFmAdNmjQcgHk95VN/+6VRP8MTdvRlOAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SNQHYypI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SNQHYypI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE241F000E9;
	Wed, 29 Jul 2026 04:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298507;
	bh=/CGWYOAu7c0h9Oaubm33Y3YIEb2NLwqLUPss3YOtd8s=;
	h=Date:To:From:Subject;
	b=SNQHYypIZNAR9lGTc+RLgxZr92rmFOzbGxxrRTWn8NZUjNoelHADaMUmsJ4Z9IUuv
	 KC5XOoM5nNQG1l1trgugkyU/+PZJtrh6UzLx583xbEkhSCrXaBS/qSU1/ItTI3GDah
	 w8M+pYnKD8hcA1c4N8AIU2W/yMCCiXhFhRIaVujk=
Date: Tue, 28 Jul 2026 21:15:06 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,riel@surriel.com,nphamcs@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch removed from -mm tree
Message-Id: <20260729041507.1EE241F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap_state: remove unnecessary lru_add_drain() from readahead
has been removed from the -mm tree.  Its filename was
     mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-add-softleaf_to_pmd-and-convert-existing-callers.patch
mm-extract-mm_prepare_for_swap_entries-helper.patch
fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch
mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch
mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch
mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch
mm-vmpressure-move-v1-userspace-eventfd-code-into-memcontrol-v1c.patch
mm-migrate_device-pin-large-folios-before-splitting.patch
mm-mempolicy-skip-non-present-pmds-when-queueing-folios.patch
mm-madvise-skip-device-private-pmds-in-cold-and-pageout-walks.patch
mm-huge_memory-skip-device-private-pmds-in-madvise_free_huge_pmd.patch
mm-vmstat-mm-memcontrol-add-_monotonic-vmstat-readers.patch
mm-vmscan-reduce-lru_lock-contention-via-vmstat-derived-scan-balance-cost.patch

