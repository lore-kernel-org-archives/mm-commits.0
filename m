Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BB37CF33
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103952; cv=none; b=dJEF+KPX/lG0VUs7zK99Pc0GWXttwD7u4c4xpNcKBB2rJG4rgTOXV2hrbLHTL14JePNVoQaq+W4Nv7knoLK37/1Wo564ytCJ5v+G4SZmjr9XJ2QDrAOCAOomkWo36r4X6Agr7ZMSbOccElGb7B5YN0UEERWQJVrixN23xNi+1Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103952; c=relaxed/simple;
	bh=jo0ciWNGC3UFpBP11mNR7hjAN9xWL3IJY+2QkaU8RlM=;
	h=Date:To:From:Subject:Message-Id; b=tznOtrMppqwVm2qd5wBJA1pZtJKmJW52Iy8LZMEP1B2knFq+i2Fg+Y0KTFZhgCgr9Z57pzw33kUXTHqmC1w7oOICYlxACkdJbeJ+tGnLl289x+pDqEx8//cVk4Yb+lcJB45k3QZsK+k5YpycuChkzoPUa3UTaNfa8xjsf5eI1yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HT5lXw7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HT5lXw7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB109C116B1;
	Fri, 26 Apr 2024 03:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103952;
	bh=jo0ciWNGC3UFpBP11mNR7hjAN9xWL3IJY+2QkaU8RlM=;
	h=Date:To:From:Subject:From;
	b=HT5lXw7cWqZY0+HJGzg5Vbw/ul9mwP800bZZwxK+rdvr4xa1lQgDIJ1T2IsjtwoRW
	 QrWARu4tBBmS0wARpImDikVyRjeUmQY41KkQQPjjGxRhTg5cKuuuJC6ECsO2KQM72g
	 8mSdBucTRBPXbdkz0B667P1uJn4gFX4s9+d/tDFY=
Date: Thu, 25 Apr 2024 20:59:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,vbabka@suse.cz,mgorman@techsingularity.net,david@redhat.com,baolin.wang@linux.alibaba.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-optimize-free_unref_folios.patch removed from -mm tree
Message-Id: <20240426035912.AB109C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: optimize free_unref_folios()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-optimize-free_unref_folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: optimize free_unref_folios()
Date: Wed, 20 Mar 2024 14:02:07 -0400

Move direct freeing of isolated pages to the lock-breaking block in the
second loop.  This saves an unnecessary migratetype reassessment.

Minor comment and local variable scoping cleanups.

Link: https://lkml.kernel.org/r/20240320180429.678181-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-optimize-free_unref_folios
+++ a/mm/page_alloc.c
@@ -2493,7 +2493,7 @@ void free_unref_folios(struct folio_batc
 	unsigned long __maybe_unused UP_flags;
 	struct per_cpu_pages *pcp = NULL;
 	struct zone *locked_zone = NULL;
-	int i, j, migratetype;
+	int i, j;
 
 	/* Prepare folios for freeing */
 	for (i = 0, j = 0; i < folios->nr; i++) {
@@ -2505,14 +2505,15 @@ void free_unref_folios(struct folio_batc
 			folio_undo_large_rmappable(folio);
 		if (!free_pages_prepare(&folio->page, order))
 			continue;
-
 		/*
-		 * Free isolated folios and orders not handled on the PCP
-		 * directly to the allocator, see comment in free_unref_page.
+		 * Free orders not handled on the PCP directly to the
+		 * allocator.
 		 */
-		migratetype = get_pfnblock_migratetype(&folio->page, pfn);
-		if (!pcp_allowed_order(order) ||
-		    is_migrate_isolate(migratetype)) {
+		if (!pcp_allowed_order(order)) {
+			int migratetype;
+
+			migratetype = get_pfnblock_migratetype(&folio->page,
+							       pfn);
 			free_one_page(folio_zone(folio), &folio->page, pfn,
 					order, migratetype, FPI_NONE);
 			continue;
@@ -2529,15 +2530,29 @@ void free_unref_folios(struct folio_batc
 		struct zone *zone = folio_zone(folio);
 		unsigned long pfn = folio_pfn(folio);
 		unsigned int order = (unsigned long)folio->private;
+		int migratetype;
 
 		folio->private = NULL;
 		migratetype = get_pfnblock_migratetype(&folio->page, pfn);
 
 		/* Different zone requires a different pcp lock */
-		if (zone != locked_zone) {
+		if (zone != locked_zone ||
+		    is_migrate_isolate(migratetype)) {
 			if (pcp) {
 				pcp_spin_unlock(pcp);
 				pcp_trylock_finish(UP_flags);
+				locked_zone = NULL;
+				pcp = NULL;
+			}
+
+			/*
+			 * Free isolated pages directly to the
+			 * allocator, see comment in free_unref_page.
+			 */
+			if (is_migrate_isolate(migratetype)) {
+				free_one_page(zone, &folio->page, pfn,
+					      order, migratetype, FPI_NONE);
+				continue;
 			}
 
 			/*
@@ -2550,7 +2565,6 @@ void free_unref_folios(struct folio_batc
 				pcp_trylock_finish(UP_flags);
 				free_one_page(zone, &folio->page, pfn,
 					      order, migratetype, FPI_NONE);
-				locked_zone = NULL;
 				continue;
 			}
 			locked_zone = zone;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


