Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2BA79CB
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 23:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711062769; cv=none; b=rNEtg5YumYov9wsaCm+s1TiUX80NnKzb4NjD8QJpWaGA4W0yiCOMvOA9qsCQpEN/KIuyhDerjlceyKkcKE25yf4WsXrw1974Qta8jMVQnHNF9t21CEw9Vvmym109HwUcBRXFvqGYTk1/ER07UP3LQ5KloNS95uphvOcr4QvN6B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711062769; c=relaxed/simple;
	bh=heVayYuS3jYcD8mrydVG/2Ifa0fZZo7EkLnn7y/EwVQ=;
	h=Date:To:From:Subject:Message-Id; b=MwLjlllqYnR3pGlfVQf4YQJPO+U7sCcJ2wRcZtNxCGIeWYcZpMMnqYpL4C/x7ZNnkEecQWEOwbf4fxVQfpm/pQXBdBzYkmGC/3AHev4Iy19GoVc+T67Swj9y7O+i4WHB+ybgHygxc+R/sjzFoOSvxnc1OxALpzWn547+8sWv8K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GaCExkw3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GaCExkw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20336C433C7;
	Thu, 21 Mar 2024 23:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711062769;
	bh=heVayYuS3jYcD8mrydVG/2Ifa0fZZo7EkLnn7y/EwVQ=;
	h=Date:To:From:Subject:From;
	b=GaCExkw3CcJMu3WmNw+T8jOP51MwU949uS3fOMatG0BagczGQOlDfqHeea+clYqkx
	 q0q1m91f0lQK25/tptcrEcORV1dc4IPJjiAk/M9bAoV2MynItX8J4nyNBRnPOUOAVU
	 YoqWGsSvrAoCn2fcKmw6JgFgYOXy1j1LfQdIEvjQ=
Date: Thu, 21 Mar 2024 16:12:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,vbabka@suse.cz,mgorman@techsingularity.net,david@redhat.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-move_freepages_block-range-error.patch added to mm-unstable branch
Message-Id: <20240321231249.20336C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: fix move_freepages_block() range error
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-fix-move_freepages_block-range-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-move_freepages_block-range-error.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: fix move_freepages_block() range error
Date: Wed, 20 Mar 2024 14:02:10 -0400

When a block is partially outside the zone of the cursor page, the
function cuts the range to the pivot page instead of the zone start.  This
can leave large parts of the block behind, which encourages incompatible
page mixing down the line (ask for one type, get another), and thus
long-term fragmentation.

This triggers reliably on the first block in the DMA zone, whose start_pfn
is 1.  The block is stolen, but everything before the pivot page (which
was often hundreds of pages) is left on the old list.

Link: https://lkml.kernel.org/r/20240320180429.678181-6-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-move_freepages_block-range-error
+++ a/mm/page_alloc.c
@@ -1650,9 +1650,15 @@ int move_freepages_block(struct zone *zo
 	start_pfn = pageblock_start_pfn(pfn);
 	end_pfn = pageblock_end_pfn(pfn) - 1;
 
-	/* Do not cross zone boundaries */
+	/*
+	 * The caller only has the lock for @zone, don't touch ranges
+	 * that straddle into other zones. While we could move part of
+	 * the range that's inside the zone, this call is usually
+	 * accompanied by other operations such as migratetype updates
+	 * which also should be locked.
+	 */
 	if (!zone_spans_pfn(zone, start_pfn))
-		start_pfn = pfn;
+		return 0;
 	if (!zone_spans_pfn(zone, end_pfn))
 		return 0;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-cachestat-fix-two-shmem-bugs.patch
mm-zswap-fix-writeback-shinker-gfp_noio-gfp_nofs-recursion.patch
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
mm-page_isolation-prepare-for-hygienic-freelists-fix.patch
mm-page_alloc-consolidate-free-page-accounting.patch

