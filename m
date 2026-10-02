Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BE82874F8;
	Fri,  2 Oct 2026 01:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790904604; cv=none; b=Wi8x9jzxEk2xwoacv4KcMZn6gwRelCD0d5IUfLe/lzq/ndEiS3tN2AlvHCsJ8MEKyeIvi4XFEINhWDEiL/G756nXyeaRg1u2vSTjiBHjf01BEYuVG/vAyDv7C2jONXarXsqFsVuU1I2iNouRtTWmT/0+3VaXq7LeU2Uqf5muFA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790904604; c=relaxed/simple;
	bh=YHcJK20MkvTL8VT+wTvdO4jx6Fh8zLZ6yi5suOuHOr0=;
	h=Date:To:From:Subject:Message-Id; b=XGjB7qAtsNUR/x1pNeHfyH7MGnZ/LEuQ/RnQWvzKb9AO7l7Kng6Sl52PD5/Tmv7LAB5W99x6dBSFDWSrJwYUUUSacLpptGbSE3Y1p3/2JIpnQW4By4LHbxdkYlgmTSsqxtKRIOt8h89nzrsfWYtpb7kQ/CgOaFPdoOG8z41Tp+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oGfZc0v+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oGfZc0v+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733871F000FF;
	Fri,  2 Oct 2026 01:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790904599;
	bh=DFCFwn0lVwzhR9lhKaUYtjvyJ8EpyTZcpewRwJFXmmY=;
	h=Date:To:From:Subject;
	b=oGfZc0v+wxQj7mB76I+yQlBPyC1Uv9kLeyi0jDi1uzvSWIGp/MnZU/RIFskCvyNT8
	 Vi5JD11+zX4r2rWnpuXwNo0P2YLWjpv7TYfQTM05o9nvC/PJATGmIdqbcha+qq7nF+
	 LZ4fxvYZYGV6vl+IZ7qZpZxZlyo67UUHpqEq/QtU=
Date: Thu, 01 Oct 2026 18:29:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@kernel.org,stable@vger.kernel.org,ritesh.list@gmail.com,mhocko@suse.com,hch@lst.de,hannes@cmpxchg.org,dgc@kernel.org,david@redhat.com,dipiets@amazon.it,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_alloc-avoid-direct-compaction-for-costly-__gfp_noretry-allocations.patch removed from -mm tree
Message-Id: <20261002012959.733871F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-avoid-direct-compaction-for-costly-__gfp_noretry-allocations.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Salvatore Dipietro <dipiets@amazon.it>
Subject: mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Fri, 4 Sep 2026 11:56:28 +0000

Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
introduced high-order folio allocations in the iomap buffered write path. 
When memory is fragmented, each failed costly-order allocation enters
__alloc_pages_slowpath() which runs direct compaction and
drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL pgbench
(simple-update) with 1024 clients on a 96-vCPU arm64 system.

The root issue is that direct compaction is too expensive for hot
allocation paths that have fallbacks to smaller allocations. 
__filemap_get_folio_mpol() already marks higher-order allocations with
__GFP_NORETRY | __GFP_NOWARN, signalling that the caller can handle
failure.  However, the page allocator still attempts full direct
compaction for costly orders with __GFP_NORETRY, which is unnecessarily
aggressive when the caller will simply retry at a lower order.

For costly-order allocations with __GFP_NORETRY, clear
__GFP_DIRECT_RECLAIM at the very start of the slowpath, before
can_direct_reclaim, can_compact and the nofail checks are evaluated.  This
makes the entire slowpath treat the request as non-blocking: no direct
reclaim, no direct compaction and no drain_all_pages() IPI across every
CPU.  kswapd (and in turn kcompactd) is still woken further down for
background defragmentation, so compaction keeps working for long-term
system health while being removed from the latency-critical direct
allocation path.

Allocations that also request __GFP_THISNODE are exempted.  That flag
pairing identifies the local-node-first THP attempt issued by
alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
form transparent huge pages.

Test environment:
  Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
             12x 1TB IO2 32000 IOPS RAID0 XFS
  OS:        AL2023
  Kernel:    v7.3-rc1
  Database:  PostgreSQL 18.4
  Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s

Results (average of 3 runs, TPS):

  Config                   Avg TPS      % vs Baseline
  baseline (no patch)       59,408       -
  With this patch          155,409      +161.6%

Link: https://lore.kernel.org/20260904115629.3993331-1-dipiets@amazon.it
Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Dave Chinner <dgc@kernel.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/page_alloc.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-avoid-direct-compaction-for-costly-__gfp_noretry-allocations
+++ a/mm/page_alloc.c
@@ -4784,10 +4784,10 @@ static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
 {
-	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
-	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
-	bool nofail = gfp_mask & __GFP_NOFAIL;
 	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
+	bool can_direct_reclaim;
+	bool can_compact;
+	bool nofail;
 	struct page *page = NULL;
 	unsigned int alloc_flags;
 	unsigned long did_some_progress;
@@ -4802,6 +4802,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	bool can_retry_reserves = true;
 	unsigned long alloc_start_time = jiffies;
 
+	/*
+	 * Costly __GFP_NORETRY callers have a cheap fallback, so don't stall
+	 * them in reclaim or compaction. __GFP_THISNODE callers are exempt.
+	 */
+	if (costly_order && (gfp_mask & __GFP_NORETRY) &&
+	    !(gfp_mask & __GFP_THISNODE))
+		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
+
+	can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+	can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
+	nofail = gfp_mask & __GFP_NOFAIL;
+
 	if (unlikely(nofail)) {
 		/*
 		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
_

Patches currently in -mm which might be from dipiets@amazon.it are


