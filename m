Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B267C2F36
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101518; cv=none; b=W9MeZC1UQiX66yjr82nXn5JdXOug+ezPlktWJY1mRluDIw18a/e0d2yOBfjMFf7oMZSSHOKVyXsD5HaHz46Sryf3Ekebsqcr/dvv/5W9HuD22nwGq/2t5VeUNW1fpG4bual6aNBCnJAc2yNjadPuj2hdbp4YMib3NwDLS6/iG3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101518; c=relaxed/simple;
	bh=EKzucLZDHw8Fm1ifAZRjkA7VVfW1I3dLH7Fk4TBv9D0=;
	h=Date:To:From:Subject:Message-Id; b=BMXUN3EE6XRzC3qDFiIBtuzwm3noIcMl/Powy9YIwGkkThb5soyuVaD9jjNgaYDBzUqSLZ6WVockFSLg3jWW258O6FFmvv3zZRRlU+rf7q/tHVPL+l76M8WMhSrxwBCfUYOfgWMCYcFKoi8yiUPmUaJEwicH7rtPZ04fQcNWyvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ftksrfgm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ftksrfgm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D88FC113CD;
	Fri, 26 Apr 2024 03:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101518;
	bh=EKzucLZDHw8Fm1ifAZRjkA7VVfW1I3dLH7Fk4TBv9D0=;
	h=Date:To:From:Subject:From;
	b=FtksrfgmlawjSidsL/rky37mlYsu+uxN1bUj8v5AHUb+xesqUHdz7bpYFP2MM/aod
	 gjTCKPyKdko6jmVLcOqv4VhEfpfrxwZb+7fXbcRuDTemN3X+C5liZb2dlLrZ9cVEAb
	 47Uo/zie1fHdZE+HVxiMQ5EZ4E7R9+x2IJNE/4Ts=
Date: Thu, 25 Apr 2024 20:18:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,vbabka@suse.cz,mgorman@techsingularity.net,david@redhat.com,baolin.wang@linux.alibaba.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_isolation-prepare-for-hygienic-freelists-fix.patch removed from -mm tree
Message-Id: <20240426031838.7D88FC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_isolation-prepare-for-hygienic-freelists-fix
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-prepare-for-hygienic-freelists-fix.patch

This patch was dropped because it was folded into mm-page_isolation-prepare-for-hygienic-freelists.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-page_isolation-prepare-for-hygienic-freelists-fix
Date: Thu, 21 Mar 2024 10:24:26 -0400

work around older gcc warning

Link: https://lkml.kernel.org/r/20240321142426.GB777580@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_isolation-prepare-for-hygienic-freelists-fix
+++ a/mm/page_alloc.c
@@ -1703,6 +1703,10 @@ bool move_freepages_block_isolate(struct
 				       NULL, NULL))
 		return false;
 
+	/* No splits needed if buddies can't span multiple blocks */
+	if (pageblock_order == MAX_PAGE_ORDER)
+		goto move;
+
 	/* We're a tail block in a larger buddy */
 	pfn = find_large_buddy(start_pfn);
 	if (pfn != start_pfn) {
@@ -1730,7 +1734,7 @@ bool move_freepages_block_isolate(struct
 		split_large_buddy(zone, page, pfn, order);
 		return true;
 	}
-
+move:
 	mt = get_pfnblock_migratetype(page, start_pfn);
 	nr_moved = move_freepages(zone, start_pfn, end_pfn, migratetype);
 	if (!is_migrate_isolate(mt))
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
mm-page_alloc-consolidate-free-page-accounting-fix.patch
mm-page_alloc-consolidate-free-page-accounting-fix-2.patch
mm-page_alloc-batch-vmstat-updates-in-expand.patch

