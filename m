Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCF84A0F;
	Mon,  2 Sep 2024 00:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725238782; cv=none; b=R0WHP6alA5trKeKtU27oqpXcHKAwUVzmSXfmByBM8xyuXESHGairq2YnKVwlzcFvxbn0HUIIts47/AvijlOz3S7BDsXkWoITZHDbIy9X0yRVTSjgIgoqGm+ydSKWYPLVA5HK0K8zddIRPwaV0HhiNaORRTkUMOlWuOvG6sjGHJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725238782; c=relaxed/simple;
	bh=0tlLdwRwpKKnGCsOnz6QGLEAFlxyO2V8Ctv+eTe9ABg=;
	h=Date:To:From:Subject:Message-Id; b=GDmsoU9E3kQH7CGknSil+IEwnziLubB3ugXOgYrcg4qlyyWjQkGd4cahiPTkf5KLleXZA6YJ1IOHQP3MuRi8ZUv01LwZom12vTJU0KVWlMFGpXQH3u9ejBdqBIq6sjJDqksed6CBmNqjSga1M73kpWUWjRipfPo8zbh/n8Ba60Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cDBvPZas; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cDBvPZas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D12C4CEC3;
	Mon,  2 Sep 2024 00:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725238782;
	bh=0tlLdwRwpKKnGCsOnz6QGLEAFlxyO2V8Ctv+eTe9ABg=;
	h=Date:To:From:Subject:From;
	b=cDBvPZasf4Zo8A482CH/NXea+RBM91KdT9MBLQV0hDd4DckEGqIEQtD20NHOnhWn+
	 tBB1mYOyc0sCFOesLWLfEs9fqm9D5pHqhNcDgBZb7IpRu1/gae9QIyo+tBdODaChvw
	 xyo95tFHuZeRPl2juuZkJ4NVlrJhXkdRHgbrjRyE=
Date: Sun, 01 Sep 2024 17:59:41 -0700
To: mm-commits@vger.kernel.org,zhaoyang.huang@unisoc.com,yuzhao@google.com,willy@infradead.org,vbabka@suse.cz,stable@vger.kernel.org,riel@surriel.com,leitao@debian.org,huangzhaoyang@gmail.com,hannes@cmpxchg.org,david@redhat.com,bharata@amd.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-mm-skip-cma-pages-when-they-are-not-available.patch removed from -mm tree
Message-Id: <20240902005942.17D12C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "mm: skip CMA pages when they are not available"
has been removed from the -mm tree.  Its filename was
     revert-mm-skip-cma-pages-when-they-are-not-available.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usamaarif642@gmail.com>
Subject: Revert "mm: skip CMA pages when they are not available"
Date: Wed, 21 Aug 2024 20:26:07 +0100

This reverts commit 5da226dbfce3 ("mm: skip CMA pages when they are not
available") and b7108d66318a ("Multi-gen LRU: skip CMA pages when they are
not eligible").

lruvec->lru_lock is highly contended and is held when calling
isolate_lru_folios.  If the lru has a large number of CMA folios
consecutively, while the allocation type requested is not MIGRATE_MOVABLE,
isolate_lru_folios can hold the lock for a very long time while it skips
those.  For FIO workload, ~150million order=0 folios were skipped to
isolate a few ZONE_DMA folios [1].  This can cause lockups [1] and high
memory pressure for extended periods of time [2].

Remove skipping CMA for MGLRU as well, as it was introduced in sort_folio
for the same resaon as 5da226dbfce3a2f44978c2c7cf88166e69a6788b.

[1] https://lore.kernel.org/all/CAOUHufbkhMZYz20aM_3rHZ3OcK4m2puji2FGpUpn_-DevGk3Kg@mail.gmail.com/
[2] https://lore.kernel.org/all/ZrssOrcJIDy8hacI@gmail.com/

[usamaarif642@gmail.com: also revert b7108d66318a, per Johannes]
  Link: https://lkml.kernel.org/r/9060a32d-b2d7-48c0-8626-1db535653c54@gmail.com
  Link: https://lkml.kernel.org/r/357ac325-4c61-497a-92a3-bdbd230d5ec9@gmail.com
Link: https://lkml.kernel.org/r/9060a32d-b2d7-48c0-8626-1db535653c54@gmail.com
Fixes: 5da226dbfce3 ("mm: skip CMA pages when they are not available")
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

--- a/mm/vmscan.c~revert-mm-skip-cma-pages-when-they-are-not-available
+++ a/mm/vmscan.c
@@ -1604,25 +1604,6 @@ static __always_inline void update_lru_s
 
 }
 
-#ifdef CONFIG_CMA
-/*
- * It is waste of effort to scan and reclaim CMA pages if it is not available
- * for current allocation context. Kswapd can not be enrolled as it can not
- * distinguish this scenario by using sc->gfp_mask = GFP_KERNEL
- */
-static bool skip_cma(struct folio *folio, struct scan_control *sc)
-{
-	return !current_is_kswapd() &&
-			gfp_migratetype(sc->gfp_mask) != MIGRATE_MOVABLE &&
-			folio_migratetype(folio) == MIGRATE_CMA;
-}
-#else
-static bool skip_cma(struct folio *folio, struct scan_control *sc)
-{
-	return false;
-}
-#endif
-
 /*
  * Isolating page from the lruvec to fill in @dst list by nr_to_scan times.
  *
@@ -1669,8 +1650,7 @@ static unsigned long isolate_lru_folios(
 		nr_pages = folio_nr_pages(folio);
 		total_scan += nr_pages;
 
-		if (folio_zonenum(folio) > sc->reclaim_idx ||
-				skip_cma(folio, sc)) {
+		if (folio_zonenum(folio) > sc->reclaim_idx) {
 			nr_skipped[folio_zonenum(folio)] += nr_pages;
 			move_to = &folios_skipped;
 			goto move;
@@ -4320,7 +4300,7 @@ static bool sort_folio(struct lruvec *lr
 	}
 
 	/* ineligible */
-	if (zone > sc->reclaim_idx || skip_cma(folio, sc)) {
+	if (zone > sc->reclaim_idx) {
 		gen = folio_inc_gen(lruvec, folio, false);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-store-zero-pages-to-be-swapped-out-in-a-bitmap.patch
mm-remove-code-to-handle-same-filled-pages.patch
mm-introduce-a-pageflag-for-partially-mapped-folios.patch
mm-split-underused-thps.patch
mm-add-sysfs-entry-to-disable-splitting-underused-thps.patch

