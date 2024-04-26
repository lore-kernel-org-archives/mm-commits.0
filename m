Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D1E7D071
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103956; cv=none; b=V0qylktiuYbDyacN7uhgA/4Gxti9PHScZVA+9ZUhmK74YDpgCYEH842XIX3GQ6XWaSQ7heovC/wpDvkqPKLDjSW0PYG+7psV/MgzfsMF8Vv37nfivxSOXervMjUulGsy1tSPlDilWDI6AepNcrgWimMavy7EF7t9QzmYLgzWeyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103956; c=relaxed/simple;
	bh=SlY0NiWvqakKHQIhr8yi4YD+W06kgkiOWfgiF0Oo9I0=;
	h=Date:To:From:Subject:Message-Id; b=rhJVzJMEqK5oWyr1/U7ZR64oaqzKWJCXXWQbbTKcIY+CHR/sMQYhrnybYLCi3Yk60CFosBzC4ZwEAzSdWFoHGFrpmzEa0B5ZISUGs7dfY1bwQzcGJmkJq1jvTn9MQFQNpss3B07+NLNQMmBKUS8qTQ0UnYb0RS3HDKmexoAJBNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nJl0EiE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nJl0EiE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0EAC113CD;
	Fri, 26 Apr 2024 03:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103956;
	bh=SlY0NiWvqakKHQIhr8yi4YD+W06kgkiOWfgiF0Oo9I0=;
	h=Date:To:From:Subject:From;
	b=nJl0EiE5PuTsnNB2oCSEUvFLlG4+bt5kOK/Dc3CXAyljgfjzzF+B+ewqtHIxWHt3F
	 TpTpS8AQyd3hhtygpkdMPgHxd91rj++raiurPOQRF8JrZoWwZkwigFe7Pqm26uYeT3
	 vl41hWWpL93rgF2IPhKG9MPco9rsedYQ3hjpSq7o=
Date: Thu, 25 Apr 2024 20:59:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,vbabka@suse.cz,mgorman@techsingularity.net,david@redhat.com,baolin.wang@linux.alibaba.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-fix-move_freepages_block-range-error.patch removed from -mm tree
Message-Id: <20240426035916.3D0EAC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: fix move_freepages_block() range error
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-move_freepages_block-range-error.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
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


