Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8229C3B5F63;
	Fri,  7 Aug 2026 02:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068155; cv=none; b=TzfiIFRHtLTJbJiGd++dsZCS+Z624tEDlYlaQ6SGLneVIzwX1QUCMT5u53PyUrXuNRossKKLiOza8jcKMZ5Y1KEE0I78yeOj6XivN7voC4iMqHn+7lr2S2OlM8uFyoENHlI8+5Fgapa8IWRGUzMHDJe2eGiMb6PKjAdGH8DnoXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068155; c=relaxed/simple;
	bh=pIRDE0yVefb3plqNChcS9Ws2XGE3F2mPNm4yKQa2Gh8=;
	h=Date:To:From:Subject:Message-Id; b=Y8UDMX7y/tfg2MrR2JuyYSFsKucnPD6EgSVaAlKupg7+Myuaf6JH+N6QTRSHmVV6WjhCUKgivjGI5Gk2sCVOL16ecP3FHrcpwDH/xiEOKTJd6ulmTX5KLV49u9cd+rx+KBPHirc8/J6pUIfIJL91yPGD9HqGdlZMWybNj7KWDUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KRZVvnFT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KRZVvnFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587B81F000E9;
	Fri,  7 Aug 2026 02:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068154;
	bh=DWtzUpOmTbx8p5Fg23JlK5WkAgabAPcpX6IbPMBILI8=;
	h=Date:To:From:Subject;
	b=KRZVvnFT1/qUe/9zfgHg/J1UEcx4EEqXf2rBbMq1G8HxXzap6At8wWXXTx0QUDdqY
	 yn4opB8b9PvPWOxMuDSrg2VTu0UulLzlGEycbZjo0GAwndR4uVSgX9G/cGkdgJ6X0Q
	 /7ETy/w9jEc6EQ3ZBuLZnylmSGfgf3oO8CpUgZ4I=
Date: Thu, 06 Aug 2026 19:02:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gourry@gourry.net,david@kernel.org,brendan.jackman@linux.dev,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode.patch removed from -mm tree
Message-Id: <20260807020234.587B81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: fix non-movable reclaim storm in defrag_mode
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: fix non-movable reclaim storm in defrag_mode
Date: Wed, 22 Jul 2026 10:56:47 -0400

As we deployed defrag_mode into Meta production, pressure spikes and
excessive swapping were observed on some workloads.  Tracing confirmed
that this is unmovable/reclaimable requests spinning in the allocator and
direct reclaim, causing excessive amounts of swap.

The initial plan for defrag_mode was to rely on kswapd/kcompactd to
produce blocks, and if those are overwhelmed under high pressure, let the
allocator fall back (__rmqueue_steal()) after its retry loops.  However,
that retrying results in more reclaim on some of these workloads than we'd
hoped, sometimes excessively so, spurred on by the !costly order
conditions in should_reclaim_retry().

The storms are dependent on the request type.  Reclaim will inevitably
make room in existing movable blocks, since that's where the LRU pages
live.  So if movable requests retry on reclaim, they make progress.

When non-movable requests spin in reclaim that isn't productive.  They
cannot use the individually freed pages, and the process is unlikely to
accidentally free whole blocks to meet the ALLOC_NOFRAGMENT bar.  They
spin and overreclaim excessively, which tanks performance and triggers
userspace guards like swap exhaustion or pressure based OOM.

To fix this, send non-movable requests, regardless of order, into
pageblock reclaim/compaction.  This way, they help move things along to
meet the ALLOC_NOFRAGMENT bar.  After this patch, the reclaim storms and
excess OOM rates are no longer observed in production.

The longer-term plan is still to have all requests, including the movable
ones, help make blocks to spread the cost of defragmenting more evenly and
fairly; combined with proper watermarking to reduce allocation latencies
in the common case.  However, doing this naively unearths scaling and
concurrency limitations in compaction that need to be addressed first. 
Promoting just non-movables for now is the minimally viable bug fix for
the above issue.

[brendan.jackman@linux.dev: fix try_to_compact_pages() kerneldoc]
  Link: https://lore.kernel.org/DK7NM9RPUJOD.11PNJJ5N2OBED@linux.dev
Link: https://lore.kernel.org/20260722150006.3848560-5-hannes@cmpxchg.org
Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: "Brendan Jackman" <brendan.jackman@linux.dev>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 mm/internal.h   |    6 ++++++
 mm/page_alloc.c |   31 ++++++++++++++++++++++++++-----
 3 files changed, 33 insertions(+), 6 deletions(-)

--- a/mm/compaction.c~mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode
+++ a/mm/compaction.c
@@ -2823,7 +2823,7 @@ static enum compact_result compact_zone_
 /**
  * try_to_compact_pages - Direct compact to satisfy a high-order allocation
  * @gfp_mask: The GFP mask of the current allocation
- * @order: The order of the current allocation
+ * @order: The order to try to make available
  * @alloc_flags: The allocation flags of the current allocation
  * @ac: The context of current allocation
  * @prio: Determines how hard direct compaction should try to succeed
--- a/mm/internal.h~mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode
+++ a/mm/internal.h
@@ -870,6 +870,12 @@ struct compact_control {
 struct capture_control {
 	struct zone *zone;
 	int migratetype;
+	/*
+	 * Allocation request order. May differ from the compaction
+	 * order: defrag_mode promotes sub-block allocations to
+	 * pageblock-order compaction; capture still matches at the
+	 * original allocation order so prep_new_page() is consistent.
+	 */
 	int order;
 	struct page *page;
 };
--- a/mm/page_alloc.c~mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode
+++ a/mm/page_alloc.c
@@ -4149,8 +4149,24 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		.order = order,
 		.page = NULL,
 	};
+	int compact_order = order;
 
-	if (!order)
+	/*
+	 * If fallbacks are not permitted (defrag_mode), we either
+	 * need to reclaim space in a block of matching type, or clear
+	 * out an entire block to allow __rmqueue_claim() to convert.
+	 *
+	 * Reclaim by itself is primarily freeing space in movable
+	 * blocks, since that's where the LRU pages live. So this
+	 * works for movable requests, but not for others.
+	 *
+	 * For those, promote the order to help make blocks, instead
+	 * of spinning in reclaim alone unproductively.
+	 */
+	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
+		compact_order = max(order, pageblock_order);
+
+	if (!compact_order)
 		return NULL;
 
 	psi_memstall_enter(&pflags);
@@ -4166,8 +4182,8 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	barrier();
 	WRITE_ONCE(current->capture_control, &capc);
 
-	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
-							       prio, &capc);
+	*compact_result = try_to_compact_pages(gfp_mask, compact_order,
+					       alloc_flags, ac, prio, &capc);
 
 	/*
 	 * Make sure we hide capture control first before we read the captured
@@ -4212,7 +4228,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		struct zone *zone = page_zone(page);
 
 		zone->compact_blockskip_flush = false;
-		compaction_defer_reset(zone, order, true);
+		compaction_defer_reset(zone, compact_order, true);
 		count_vm_event(COMPACTSUCCESS);
 		return page;
 	}
@@ -4452,9 +4468,14 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 	struct page *page = NULL;
 	unsigned long pflags;
 	bool drained = false;
+	int reclaim_order = order;
+
+	/* Match the slowpath compaction promotion in __alloc_pages_direct_compact */
+	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
+		reclaim_order = max(order, pageblock_order);
 
 	psi_memstall_enter(&pflags);
-	*did_some_progress = __perform_reclaim(gfp_mask, order, ac);
+	*did_some_progress = __perform_reclaim(gfp_mask, reclaim_order, ac);
 	if (unlikely(!(*did_some_progress)))
 		goto out;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-mempolicy-fix-automatic-numa-balancing-for-shmem.patch

