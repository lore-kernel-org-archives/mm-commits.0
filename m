Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E862F37
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 20:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758487441; cv=none; b=dqabYw5hwRFAFDFT0yl6xcu7EX7Tbnow4CArLlb/JZNcAAuP9Lce9w9dgX4dGLlU5WP73Znwx7PLi1wGnvIFa0qaZvXkeNuL5oB8U+TB4eVmeM6bM+WUdf5BlyVUUEirFs9Q76SwgNBbbMFxCzWVsq6fuZMQZB0rCNchMrI/Y+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758487441; c=relaxed/simple;
	bh=iViCCwz2rmtY8QPwPz+1ZocqTsEQSJBrFOlKMBHWPbA=;
	h=Date:To:From:Subject:Message-Id; b=npx4qlrxCJIW8V0vjs3f1L5vwyQyZF/vcbA3JR0RrvQqw+InnCNcc9mpMtKscWAXF64Jm6qJrM52mTrBFbixMVWt5LuxAOb+v818e9oRbma4KhjZzJqaPNQH63fOaTBUoDhOoR8dAfgCPM4+clbORSqhhLnvjNkibFCvRe7yZWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MfIM7JA1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MfIM7JA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B73C4CEE7;
	Sun, 21 Sep 2025 20:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758487440;
	bh=iViCCwz2rmtY8QPwPz+1ZocqTsEQSJBrFOlKMBHWPbA=;
	h=Date:To:From:Subject:From;
	b=MfIM7JA14LH5BfdRa5/ff12YcKLEgkI+ZwxZXrBIcjw26Nb0mKkQODD2pwq4oLseX
	 WVhvV66YSJiGLPoaLehnzyPgY7SelFaHBfZYF3fCcWZv9BtuuWTv0XURp0XL17HJF/
	 gEOgYil8IzKGsFfVnKUUjhAi7E5DqdVrm/wnOOzM=
Date: Sun, 21 Sep 2025 13:44:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,flyinrm@gmail.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch removed from -mm tree
Message-Id: <20250921204400.95B73C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix
has been removed from the -mm tree.  Its filename was
     mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch

This patch was dropped because it was folded into mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix
Date: Mon Sep  8 04:59:47 PM PDT 2025

tweak whitespace

Cc: Chanwon Park <flyinrm@gmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   42 +++++++++++++++++++++---------------------
 mm/show_mem.c   |    4 ++--
 2 files changed, 23 insertions(+), 23 deletions(-)

--- a/mm/page_alloc.c~mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix
+++ a/mm/page_alloc.c
@@ -2860,29 +2860,29 @@ static void free_frozen_page_commit(stru
 		 */
 		return;
 	}
+
 	high = nr_pcp_high(pcp, zone, batch, free_high);
-	if (pcp->count >= high) {
-		free_pcppages_bulk(zone, nr_pcp_free(pcp, batch, high, free_high),
-				   pcp, pindex);
-		if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&
-		    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
-				      ZONE_MOVABLE, 0)) {
-			struct pglist_data *pgdat = zone->zone_pgdat;
-			clear_bit(ZONE_BELOW_HIGH, &zone->flags);
+	if (pcp->count < high)
+		return;
 
-			/*
-			 * Assume that memory pressure on this node is gone
-			 * and may be in a reclaimable state. If a memory
-			 * fallback node exists, direct reclaim may not have
-			 * been triggered, leaving 'hopeless node' stay in
-			 * that state for a while. Let kswapd work again by
-			 * resetting kswapd_failures.
-			 */
-			if (atomic_read(&pgdat->kswapd_failures)
-			    >= MAX_RECLAIM_RETRIES &&
-			    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
-				atomic_set(&pgdat->kswapd_failures, 0);
-		}
+	free_pcppages_bulk(zone, nr_pcp_free(pcp, batch, high, free_high),
+			   pcp, pindex);
+	if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&
+	    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
+			      ZONE_MOVABLE, 0)) {
+		struct pglist_data *pgdat = zone->zone_pgdat;
+		clear_bit(ZONE_BELOW_HIGH, &zone->flags);
+
+		/*
+		 * Assume that memory pressure on this node is gone and may be
+		 * in a reclaimable state. If a memory fallback node exists,
+		 * direct reclaim may not have been triggered, causing a
+		 * 'hopeless node' to stay in that state for a while.  Let
+		 * kswapd work again by resetting kswapd_failures.
+		 */
+		if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES &&
+		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
+			atomic_set(&pgdat->kswapd_failures, 0);
 	}
 }
 
--- a/mm/show_mem.c~mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix
+++ a/mm/show_mem.c
@@ -278,8 +278,8 @@ static void show_free_areas(unsigned int
 #endif
 			K(node_page_state(pgdat, NR_PAGETABLE)),
 			K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
-			str_yes_no(atomic_read(&pgdat->kswapd_failures)
-				   >= MAX_RECLAIM_RETRIES),
+			str_yes_no(atomic_read(&pgdat->kswapd_failures) >=
+				   MAX_RECLAIM_RETRIES),
 			K(node_page_state(pgdat, NR_BALLOON_PAGES)));
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled.patch
include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines.patch
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix.patch
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix-fix.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete-fix.patch
mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes.patch

