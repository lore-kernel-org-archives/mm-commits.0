Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672155;
	b=ICbcpW6bneZsAda979SSWp6tUds7trTqz/SIR8ypaX3lpUzr1p4YCd0td7hxJpYxPuYW
	 wxckNIrhhlZB7c89C4Lr3n1ZdwnDGCqRNKTMwAVIodWpZacUVHv8MACwXbd6NyLTLpxti
	 D48eeVhPRK5QdC4EeYrHov6/D7OANJ3royYjIu+e2WQIrTwtM3l1SALeL4SVZHh+MgiSF
	 bJ6jx4meAdF/82b9hVCngT2ON+M0TvS+2t11xWTR4kcAAsZP8gTXg4uwNbREkgcPLuAQ6
	 rPQoUoYHuzW8UudLo/BEtwgkUDSBLe1QTX4LNH/Z2QmE5+TS3AlWpY5Y2LIpNKcguZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672155;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=93iug8tCHREjg7Dj+yIFiqs61s615qlHdMeG92XoR2w=;
	b=AkWcgbSBbtLhbzDjqz+Yo3OMbEJL/OzaHHtP8ItDFMRgORqguqanFUFRZ3aWeKmmqk6X
	 k7BZu62VnhvwYrvnQ2O+0bnf5xfOHuJu7WMmgimtUS8+qz3sCUMOVnODQbMcuW5WtoTWG
	 CV15dcrH58wXVFLgznpCdQ27qTWh4uEV4hVOh/Uo1fAmgngOgCnbG2+5hz2TJkzj+VWh9
	 ObmU6dLfA+0O+HYvocTaoeERD6zwHd/bdk9ZhduhbL1OiGSpc/LGla/pjGIy8SOhR2iy1
	 ubo/2CNzh1TJSGoQoovE3m6h+iA8DADnOafCteAc79+eD2jsvyqbdZ1eBqnty/lLHDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=e6Qs79ZG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CB3606A324
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 02:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=e6Qs79ZG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464801F000C1;
	Tue,  3 Nov 2026 02:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672155;
	bh=93iug8tCHREjg7Dj+yIFiqs61s615qlHdMeG92XoR2w=;
	h=Date:To:From:Subject;
	b=e6Qs79ZG+hLGOsCRsE/BQWLhlllj7RZbRQ3U6M/Xyoi0gzKlcfhPMUMwOsl0goI91
	 4eRbT32aR7qxRMVFIkgcyysMykHr1vLaAlyOlhNvH/QY3WoYa+Ukk7ArHDJqVk5uuY
	 ba32YjekxM7JnX12y+TDL3Bhv54AA2rEUQC7m1CI=
Date: Mon, 02 Nov 2026 18:15:54 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,
	vbabka@kernel.org,surenb@google.com,shivankg@amd.com,rvvandan@amazon.com,
	ritesh.list@gmail.com,mhocko@suse.com,hch@lst.de,hannes@cmpxchg.org,
	djwong@kernel.org,dipietro.salvatore@gmail.com,d@ilvokhin.com,dgc@kernel.org,
	david@kernel.org,brendan.jackman@linux.dev,brauner@kernel.org,
	blakgeof@amazon.com,alisaidi@amazon.com,abuehaze@amazon.com,
	dipiets@amazon.it,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-avoid-direct-reclaim-and-compaction-for-costly-__gfp_noretry-allocations.patch removed from -mm tree
Message-Id: <20261103021555.464801F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY allocations
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-avoid-direct-reclaim-and-compaction-for-costly-__gfp_noretry-allocations.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Salvatore Dipietro <dipiets@amazon.it>
Subject: mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY allocations
Date: Thu, 1 Oct 2026 08:21:51 +0000

Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
introduced high-order folio allocations in the iomap buffered write path. 
When memory is fragmented, each failed costly-order allocation enters
__alloc_pages_slowpath() which runs direct reclaim, direct compaction and
drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL pgbench
(simple-update) with 1024 clients on a 96-vCPU arm64 system.

The root issue is that direct reclaim and direct compaction are too
expensive for hot allocation paths that have fallbacks to smaller
allocations.  __filemap_get_folio_mpol() already marks higher-order
allocations with __GFP_NORETRY | __GFP_NOWARN, signalling that the caller
can handle failure.  However, the page allocator still enters the full
blocking slowpath for costly orders with __GFP_NORETRY, which is
unnecessarily aggressive when the caller will simply retry at a lower
order.

For costly-order allocations with __GFP_NORETRY, clear
__GFP_DIRECT_RECLAIM at the very start of the slowpath, before
can_direct_reclaim, can_compact and the nofail checks are evaluated.  This
makes the entire slowpath treat the request as non-blocking: no direct
reclaim, no direct compaction and no drain_all_pages() IPI across every
CPU.  Reclaim and compaction move to the background instead: kswapd is
still woken for reclaim, and it wakes kcompactd for defragmentation.  The
system keeps its long-term health while the latency-critical direct
allocation path no longer stalls.

Allocations that also request __GFP_THISNODE are exempted.  That flag
pairing identifies the local-node-first THP attempt issued by
alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
form transparent huge pages.

Clearing __GFP_DIRECT_RECLAIM makes these allocations reach the
!can_direct_reclaim bailout, which since commit 4c0ed883e051
("mm/page_alloc: fix defrag_mode for non-reclaimable allocations") drops
ALLOC_NOFRAGMENT and retries instead of failing when defrag_mode is on. 
With vm.defrag_mode=1 a __GFP_NORETRY allocation could therefore succeed
by fragmenting another migratetype's pageblock.  That is the wrong trade
for a caller that has already communicated it can handle failure and has a
cheap lower-order fallback, so exclude __GFP_NORETRY from the relaxation. 
The exclusion is not restricted to costly orders: any __GFP_NORETRY caller
has said it can cope with failure, so failing is preferable to fragmenting
for all of them.

Test environment:
  Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
             12x 1TB IO2 32000 IOPS RAID0 XFS
  OS:        AL2023
  Kernel:    v7.3-rc1
  Database:  PostgreSQL 18.4
  Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s

Results (average of 3 runs, TPS):

  Config                                       Avg TPS   % vs baseline
  v7.3-rc1 baseline (vm.defrag_mode=0)          58,602               -
  v7.3-rc1 + this patch (vm.defrag_mode=0)     157,246         +168.3%
  v7.3-rc1 baseline (vm.defrag_mode=1)         109,012               -
  v7.3-rc1 + this patch (vm.defrag_mode=1)     157,778          +44.7%

Link: https://lore.kernel.org/20261001082152.2879289-1-dipiets@amazon.it
Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
Link: https://lore.kernel.org/all/20260904115629.3993331-1-dipiets@amazon.it/T/#u [v4]
Link: https://lore.kernel.org/all/20260911142102.2294202-1-dipiets@amazon.it/T/#u [v5]
Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Dave Chinner <dgc@kernel.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
Cc: Ali Saidi <alisaidi@amazon.com>
Cc: Geoff Blake <blakgeof@amazon.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <dipietro.salvatore@gmail.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: <rvvandan@amazon.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Garg, Shivank" <shivankg@amd.com>
---

 mm/page_alloc.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-avoid-direct-reclaim-and-compaction-for-costly-__gfp_noretry-allocations
+++ a/mm/page_alloc.c
@@ -4773,10 +4773,10 @@ static inline struct page *
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
@@ -4791,6 +4791,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
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
 		 * We don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
@@ -4907,8 +4919,11 @@ retry:
 		 * Reclaim/compaction cannot run, so defrag_mode's strategy
 		 * of enforcing ALLOC_NOFRAGMENT cannot be fulfilled. Allow
 		 * fallbacks rather than failing the allocation outright.
+		 * Not for __GFP_NORETRY: those have a cheap lower order
+		 * fallback, so failing beats fragmenting.
 		 */
 		if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT) &&
+		    !(gfp_mask & __GFP_NORETRY) &&
 		    (gfp_mask & __GFP_KSWAPD_RECLAIM)) {
 			alloc_flags &= ~ALLOC_NOFRAGMENT;
 			goto retry;
_

Patches currently in -mm which might be from dipiets@amazon.it are


