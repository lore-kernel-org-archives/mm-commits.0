Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B84D339360;
	Wed, 22 Jul 2026 23:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784762555; cv=none; b=CLZmqFrsP3dgVpUfKoOIe5fQi0G7iRT/uMYixK6aQN4Pm6khkZIYIS8rSOvQiEQ0Zq00uw/dtaRLyXhL/uXkAWiHBsHeBOj8w4uZRsvXAYWNgc1xOeRfhPA3MkzgRscvH+r9YBEox+bgVeoDvFnaOxChKhbKlxF7LVzBsoPrHAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784762555; c=relaxed/simple;
	bh=mbNHPmwMvqfSpxIj2j8jFtsHC3I4heKcRd003Bbv+TU=;
	h=Date:To:From:Subject:Message-Id; b=id2O603tiRDS736olUKHwD7VS8fGFD0lhDg5RMvCD3BnxnsRFyefDoyIQpIrC8hjh/AMhE7djlUPy+wuOTgS+ENzoSprrA/KHuBTXsEtZHClY+J41O/wIHwbgXD3+CazdnypdW70q/ijmHu1O5mdtxOTa7xoAUxY2ZBVt81qLBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KM9NA5oY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KM9NA5oY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9711F000E9;
	Wed, 22 Jul 2026 23:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784762553;
	bh=TTsjC+Q5+bPPpLa1d2qYEq3uRxWgn1SrMXE9bmBWVVA=;
	h=Date:To:From:Subject;
	b=KM9NA5oYYT+CvslWWYCTlq7923UQU16lYEZphiDB4Tg77PIFwfULGcsUwCzyKiFyO
	 XX+nERKICDKTIN5fnYzxFNZQoOU3bV2++WeNV6eG/OGTGIx33cbg6j0kFTWywOpLRS
	 YTUrH5pL9SoxRXt2zyDAj65Xq/ftdVNl9vhtt+Ng=
Date: Wed, 22 Jul 2026 16:22:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,gourry@gourry.net,david@kernel.org,brendan.jackman@linux.dev,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode.patch added to mm-new branch
Message-Id: <20260722232233.8E9711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: fix non-movable reclaim storm in defrag_mode
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode.patch

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

Link: https://lore.kernel.org/20260722150006.3848560-5-hannes@cmpxchg.org
Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    6 ++++++
 mm/page_alloc.c |   31 ++++++++++++++++++++++++++-----
 2 files changed, 32 insertions(+), 5 deletions(-)

--- a/mm/internal.h~mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode
+++ a/mm/internal.h
@@ -874,6 +874,12 @@ struct compact_control {
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
@@ -4207,8 +4207,24 @@ __alloc_pages_direct_compact(gfp_t gfp_m
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
@@ -4224,8 +4240,8 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	barrier();
 	WRITE_ONCE(current->capture_control, &capc);
 
-	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
-							       prio, &capc);
+	*compact_result = try_to_compact_pages(gfp_mask, compact_order,
+					       alloc_flags, ac, prio, &capc);
 
 	/*
 	 * Make sure we hide capture control first before we read the captured
@@ -4270,7 +4286,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		struct zone *zone = page_zone(page);
 
 		zone->compact_blockskip_flush = false;
-		compaction_defer_reset(zone, order, true);
+		compaction_defer_reset(zone, compact_order, true);
 		count_vm_event(COMPACTSUCCESS);
 		return page;
 	}
@@ -4510,9 +4526,14 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
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
mm-gfp_types-fix-__gfp_account-gfp_kernel_account-documentation.patch
mm-page_alloc-__gfp_fs-lockdep-annotation-for-direct-compaction.patch
mm-compaction-support-non-movable-compaction-for-pageblock-requests.patch
mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode.patch

