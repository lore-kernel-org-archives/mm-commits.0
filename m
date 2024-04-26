Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5A92F36
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101558; cv=none; b=h50hh7smMiRjSZwvxnUj1MfRa+NLT1iz25X+cuNTT6omNG3PC8uIa+DjhvmqUXQtsp/VxhMLyVHyNQLRii/SNwyo66mKQqlJ3pb4tFRVRycTdyJEPyVM0cwUQFIxwSch+XRg+gYC7698GFVJCVBj/gSZMm9LX0UxlN0/2OhmVm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101558; c=relaxed/simple;
	bh=w/Pj7kjY/RZnfHsfZveNf/ZuNRRW1VWy5qSRCRMYckw=;
	h=Date:To:From:Subject:Message-Id; b=Y1EOcODWr1Up24iFU4ebFmo0lZpVksFE13PPS8j5E5B7EK5NlNem3XsKDiw/dSMCh/W0FBK8CHGA5W4I9lXNfChatfv2IhCpxgLUCTnBJTVX0IA1c3+TBLy5qfPrv5e3uNoRZkO8VtpBZNg9RMzqY2aJQgpNyzj6gq8SfjjaSxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RqTLlvVi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RqTLlvVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F086C113CD;
	Fri, 26 Apr 2024 03:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101558;
	bh=w/Pj7kjY/RZnfHsfZveNf/ZuNRRW1VWy5qSRCRMYckw=;
	h=Date:To:From:Subject:From;
	b=RqTLlvViCDBQxVZFRTeW5cq1cHH144lYgEpsq6f30qGhpsfKMTooceNwG7NDkSoC7
	 3StuOTvFgbZVu0GU4TNKeMpY6HnizVOQHL5JYU3jTK6aev7X8PLmLukCAE28AW3ilq
	 u6e8tP9wNkzy54DSPhl1+UAM+1ai5cVJHslUhgl4=
Date: Thu, 25 Apr 2024 20:19:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,vbabka@suse.cz,mgorman@techsingularity.net,david@redhat.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-consolidate-free-page-accounting-fix.patch removed from -mm tree
Message-Id: <20240426031918.3F086C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: consolidate free page accounting fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-consolidate-free-page-accounting-fix.patch

This patch was dropped because it was folded into mm-page_alloc-consolidate-free-page-accounting.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: consolidate free page accounting fix
Date: Wed, 27 Mar 2024 12:19:17 -0400

undo unrelated drive-by line wrap

Link: https://lkml.kernel.org/r/20240327185736.GA7597@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_isolation.c~mm-page_alloc-consolidate-free-page-accounting-fix
+++ a/mm/page_isolation.c
@@ -252,8 +252,7 @@ static void unset_migratetype_isolate(st
 		 * Isolating this block already succeeded, so this
 		 * should not fail on zone boundaries.
 		 */
-		WARN_ON_ONCE(!move_freepages_block_isolate(zone, page,
-							   migratetype));
+		WARN_ON_ONCE(!move_freepages_block_isolate(zone, page, migratetype));
 	} else {
 		set_pageblock_migratetype(page, migratetype);
 		__putback_isolated_page(page, order, migratetype);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-zswap-optimize-zswap-pool-size-tracking.patch
mm-zpool-return-pool-size-in-pages.patch
mm-page_alloc-remove-pcppage-migratetype-caching.patch
mm-page_alloc-optimize-free_unref_folios.patch
mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks.patch
mm-page_alloc-move-free-pages-when-converting-block-during-isolation.patch
mm-page_alloc-fix-move_freepages_block-range-error.patch
mm-page_alloc-fix-freelist-movement-during-block-conversion.patch
mm-page_alloc-close-migratetype-race-between-freeing-and-stealing.patch
mm-page_isolation-prepare-for-hygienic-freelists.patch
mm-page_alloc-consolidate-free-page-accounting.patch
mm-page_alloc-consolidate-free-page-accounting-fix-2.patch
mm-page_alloc-batch-vmstat-updates-in-expand.patch

