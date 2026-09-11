Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AAB3E16A8;
	Fri, 11 Sep 2026 16:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789144371; cv=none; b=Uo8lJz1HjcmLs6eujPCNZi4yul431hAPcY93r5r35axayHsC0Mbv7lDQeJ9qMPoFsF2xDt7iwNuHrRMsJxUl1pPJKCukLsPu7B8HWV4SoPGurHY8mbEEk869TPfPW4sOpkg2MW28yZJRxlUI3CgH5Qy5n5JsR7KXktwBIbQTUN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789144371; c=relaxed/simple;
	bh=k5s70adrSYaX7mztg+S8NwlE2lSeMhXesIo6CZUTi/Y=;
	h=Date:To:From:Subject:Message-Id; b=XIRdjtb8++gpvUviRrX+YSSX+NyPTRwM6YpJarVsc5dFL4FJkEQM7Tyz84j6Lz6xu6DHm30VTX539HCldG1G0g2bsG9GQ/c0179DYPLdrSxx/JESr/lPmg5qcBHlZw2klAORFrWbVlylDoGMOaHCk4a2Eh6sikYr2x/qrjLmCJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u9NYF0aQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u9NYF0aQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808DF1F000FF;
	Fri, 11 Sep 2026 16:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789144363;
	bh=R1dfh7IZpg5Bqm42iyC0OinTqyFaI3tgHn8LA1kLEyY=;
	h=Date:To:From:Subject;
	b=u9NYF0aQdRp1tdzGwx8mYEBC2JiYa//7qC/S5Hr+PnPC1fRruEbSKTBAYslEZ2Iu8
	 Aw/OmAZ+ypLVg7XifyfUrb1Li2n/XGlSf9PzvCLqwPOFnPLykcjeCIWdAgAWnEkJKn
	 LNxvDrrtdTww1ux1FRpdGPf0RtzadWXHf8nn8K4s=
Date: Fri, 11 Sep 2026 09:32:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,stable@vger.kernel.org,ritesh.list@gmail.com,mhocko@suse.com,hch@lst.de,hannes@cmpxchg.org,dgc@kernel.org,david@redhat.com,dipiets@amazon.it,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-avoid-direct-compaction-for-costly-__gfp_noretry-allocations.patch added to mm-hotfixes-unstable branch
Message-Id: <20260911163243.808DF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-avoid-direct-compaction-for-costly-__gfp_noretry-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-avoid-direct-compaction-for-costly-__gfp_noretry-allocations.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Salvatore Dipietro <dipiets@amazon.it>
Subject: mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Fri, 11 Sep 2026 14:21:02 +0000

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

For costly-order allocations with __GFP_NORETRY, suppress direct reclaim
for the whole slowpath by computing can_direct_reclaim (and hence
can_compact) as false.  The !can_direct_reclaim check near the top of the
slowpath then short-circuits to nopage: no direct reclaim, no direct
compaction and no drain_all_pages() IPI across every CPU.  kswapd (and in
turn kcompactd) is still woken further down for background
defragmentation, so compaction keeps working for long-term system health
while being removed from the latency-critical direct allocation path.

Allocations that also request __GFP_THISNODE are exempted.  That flag
pairing identifies the local-node-first THP attempt issued by
alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
form transparent huge pages.  __GFP_NOFAIL is exempted as well, so a
must-not-fail allocation is never made to fail.

Test environment:
  Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
             12x 1TB IO2 32000 IOPS RAID0 XFS
  OS:        AL2023
  Kernel:    v7.3-rc1
  Database:  PostgreSQL 18.4
  Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s

Results (average of 3 runs, TPS):
  Config                                       Avg TPS   % vs baseline
  AL2023 stock 6.1 kernel (pre-5d8edfb900d5)   136,942           n/a
  v7.3-rc1 baseline (no patch)                  59,408             -
  v7.3-rc1 + this patch                        161,994       +172.7%

The patch fully recovers the pre-5d8edfb900d5 performance, bringing
throughput back above the pre-regression level and well clear of the ~59k
baseline.  The AL2023 6.1 row runs a kernel that predates commit
5d8edfb900d5 ("iomap: Copy larger chunks from userspace"), so it is not
directly comparable, but it shows the pre-regression level and confirms
that the ~59k baseline is the anomaly and not the norm.

Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
Link: https://lore.kernel.org/all/20260904115629.3993331-1-dipiets@amazon.it/T/#u [v4]
Link: https://lore.kernel.org/20260911142102.2294202-1-dipiets@amazon.it
Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dgc@kernel.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-avoid-direct-compaction-for-costly-__gfp_noretry-allocations
+++ a/mm/page_alloc.c
@@ -4784,10 +4784,22 @@ static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
 {
-	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
+	/*
+	 * Costly __GFP_NORETRY callers have a cheap fallback to a lower order,
+	 * so don't stall them in direct reclaim or direct compaction.  Exempt
+	 * __GFP_THISNODE (the THP attempt from alloc_pages_mpol() needs direct
+	 * compaction) and __GFP_NOFAIL (must not be made to fail).  Don't
+	 * clear __GFP_DIRECT_RECLAIM from gfp_mask instead: that would also
+	 * change the alloc_flags derived by alloc_flags_slowpath().
+	 */
+	const bool costly_noretry = costly_order &&
+		(gfp_mask & __GFP_NORETRY) &&
+		!(gfp_mask & (__GFP_THISNODE | __GFP_NOFAIL));
+	bool can_direct_reclaim = !costly_noretry &&
+		(gfp_mask & __GFP_DIRECT_RECLAIM);
 	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
 	bool nofail = gfp_mask & __GFP_NOFAIL;
-	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
 	struct page *page = NULL;
 	unsigned int alloc_flags;
 	unsigned long did_some_progress;
_

Patches currently in -mm which might be from dipiets@amazon.it are

mm-page_alloc-avoid-direct-compaction-for-costly-__gfp_noretry-allocations.patch

