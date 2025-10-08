Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8996D286413
	for <mm-commits@vger.kernel.org>; Wed,  8 Oct 2025 01:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759887596; cv=none; b=IuwPeMammOK6FTYSGlFLXuGpw/zQzY+HyoIB3Q/LvpUrW1Z3fjMbUe20Li8BRs2zQNspoOnyb6LG4pwS018HV63Wc9MFtLVu6/YCoJRQEEVyH5ouMzsvtfXwJpVjxn4Tr8yBiTZ2tHlGdXD5GeR2XjCDsp4fsttzc5lRXQSB55Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759887596; c=relaxed/simple;
	bh=L4UfsAM3/eVijnEPoRhoLgX9lb6PgQfrnsPEM03LFMU=;
	h=Date:To:From:Subject:Message-Id; b=l0bvPtAhNTbzkcktC0SykYKdz7wc+rj13MUmHqndgU0fNRR6yS2vSBK2gwm90fFMu/kvL17X1SBMQG9A8idEPxQiP5VDeyiL8w1ab79GpbocWr2yJDAO1TpFBtPuEpUTdfKUpM4/YDNb+mFpGJhw1hfdZtrR29MIA6LmNLvjf8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RT8+t/kz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RT8+t/kz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13498C4CEF1;
	Wed,  8 Oct 2025 01:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759887596;
	bh=L4UfsAM3/eVijnEPoRhoLgX9lb6PgQfrnsPEM03LFMU=;
	h=Date:To:From:Subject:From;
	b=RT8+t/kzOou0ZO0L4baIW8YENZN/QNMIVrKun+2CQHtsFAv5rutZZLTMWMcWLuaL3
	 9Jz1n2BvzHxMKPW3niy7y/qB9TeLKFxbYETufb+kR17HYrMrSo7tNypC7ncmJJZmCZ
	 VrDld8tgb3H3kTrdnAeuboase3pcMK2t9ehYgYpk=
Date: Tue, 07 Oct 2025 18:39:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jackmanb@google.com,iamjoonsoo.kim@lge.com,hannes@cmpxchg.org,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-fix-the-range-to-pageblock_pfn_to_page.patch added to mm-new branch
Message-Id: <20251008013956.13498C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/compaction: fix the range to pageblock_pfn_to_page()
has been added to the -mm mm-new branch.  Its filename is
     mm-compaction-fix-the-range-to-pageblock_pfn_to_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-fix-the-range-to-pageblock_pfn_to_page.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/compaction: fix the range to pageblock_pfn_to_page()
Date: Thu, 2 Oct 2025 03:31:40 +0000

The function pageblock_pfn_to_page() must confirm that the target range is
contained entirely within the current zone.

Originally, when pageblock_pfn_to_page() was introduced by commit
7d49d8868336, it operated on a single range, [pfn, block_end_pfn], for
both range checking and isolation.

However, commit e1409c325fdc ("mm/compaction: pass only pageblock aligned
range to pageblock_pfn_to_page") changed this behavior, causing the
function to operate on two different ranges:

[block_start_pfn, block_end_pfn] is used to check if the range is in the
same zone.

[pfn, block_end_pfn] is used for page isolation.

This split logic fails when start_pfn < zone_start_pfn, even if both are
within the same pageblock.  In this scenario, the checking range
[block_start_pfn, block_end_pfn] is used, which incorrectly misses the
pages before zone_start_pfn.

         start_pfn     zone_start_pfn
    +----+-------------+-------------------+
    block_start_pfn                        block_end_pfn

This oversight allows the range check to pass, even though the isolation
step ([pfn, block_end_pfn]) may attempt to isolate pages belonging to two
different zones.

To fix this, we should revert to using the same range ([block_start_pfn,
block_end_pfn]) for both checking and isolation in each iteration.

Link: https://lkml.kernel.org/r/20251002033140.24462-3-richard.weiyang@gmail.com
Fixes: e1409c325fdc ("mm/compaction: pass only pageblock aligned range to pageblock_pfn_to_page")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

--- a/mm/compaction.c~mm-compaction-fix-the-range-to-pageblock_pfn_to_page
+++ a/mm/compaction.c
@@ -1320,27 +1320,22 @@ int
 isolate_migratepages_range(struct compact_control *cc, unsigned long start_pfn,
 							unsigned long end_pfn)
 {
-	unsigned long pfn, block_start_pfn, block_end_pfn;
+	unsigned long block_start_pfn, block_end_pfn;
 	int ret = 0;
 
 	/* Scan block by block. First and last block may be incomplete */
-	pfn = start_pfn;
-	block_start_pfn = pageblock_start_pfn(pfn);
-	if (block_start_pfn < cc->zone->zone_start_pfn)
-		block_start_pfn = cc->zone->zone_start_pfn;
-	block_end_pfn = pageblock_end_pfn(pfn);
+	block_start_pfn = start_pfn;
+	block_end_pfn = pageblock_end_pfn(start_pfn);
 
-	for (; pfn < end_pfn; pfn = block_end_pfn,
-				block_start_pfn = block_end_pfn,
+	for (; block_start_pfn < end_pfn; block_start_pfn = block_end_pfn,
 				block_end_pfn += pageblock_nr_pages) {
 
 		block_end_pfn = min(block_end_pfn, end_pfn);
 
-		if (!pageblock_pfn_to_page(block_start_pfn,
-					block_end_pfn, cc->zone))
+		if (!pageblock_pfn_to_page(block_start_pfn, block_end_pfn, cc->zone))
 			continue;
 
-		ret = isolate_migratepages_block(cc, pfn, block_end_pfn,
+		ret = isolate_migratepages_block(cc, block_start_pfn, block_end_pfn,
 						 ISOLATE_UNEVICTABLE);
 
 		if (ret)
@@ -2046,7 +2041,6 @@ static isolate_migrate_t isolate_migrate
 {
 	unsigned long block_start_pfn;
 	unsigned long block_end_pfn;
-	unsigned long low_pfn;
 	struct page *page;
 	const isolate_mode_t isolate_mode =
 		(sysctl_compact_unevictable_allowed ? ISOLATE_UNEVICTABLE : 0) |
@@ -2058,20 +2052,17 @@ static isolate_migrate_t isolate_migrate
 	 * initialized by compact_zone(). The first failure will use
 	 * the lowest PFN as the starting point for linear scanning.
 	 */
-	low_pfn = fast_find_migrateblock(cc);
-	block_start_pfn = pageblock_start_pfn(low_pfn);
-	if (block_start_pfn < cc->zone->zone_start_pfn)
-		block_start_pfn = cc->zone->zone_start_pfn;
+	block_start_pfn = fast_find_migrateblock(cc);
 
 	/*
 	 * fast_find_migrateblock() has already ensured the pageblock is not
 	 * set with a skipped flag, so to avoid the isolation_suitable check
 	 * below again, check whether the fast search was successful.
 	 */
-	fast_find_block = low_pfn != cc->migrate_pfn && !cc->fast_search_fail;
+	fast_find_block = block_start_pfn != cc->migrate_pfn && !cc->fast_search_fail;
 
 	/* Only scan within a pageblock boundary */
-	block_end_pfn = pageblock_end_pfn(low_pfn);
+	block_end_pfn = pageblock_end_pfn(block_start_pfn);
 
 	/*
 	 * Iterate over whole pageblocks until we find the first suitable.
@@ -2079,7 +2070,7 @@ static isolate_migrate_t isolate_migrate
 	 */
 	for (; block_end_pfn <= cc->free_pfn;
 			fast_find_block = false,
-			cc->migrate_pfn = low_pfn = block_end_pfn,
+			cc->migrate_pfn = block_end_pfn,
 			block_start_pfn = block_end_pfn,
 			block_end_pfn += pageblock_nr_pages) {
 
@@ -2088,7 +2079,7 @@ static isolate_migrate_t isolate_migrate
 		 * many pageblocks unsuitable, so periodically check if we
 		 * need to schedule.
 		 */
-		if (!(low_pfn % (COMPACT_CLUSTER_MAX * pageblock_nr_pages)))
+		if (!(block_start_pfn % (COMPACT_CLUSTER_MAX * pageblock_nr_pages)))
 			cond_resched();
 
 		page = pageblock_pfn_to_page(block_start_pfn,
@@ -2109,8 +2100,8 @@ static isolate_migrate_t isolate_migrate
 		 * before making it "skip" so other compaction instances do
 		 * not scan the same block.
 		 */
-		if ((pageblock_aligned(low_pfn) ||
-		     low_pfn == cc->zone->zone_start_pfn) &&
+		if ((pageblock_aligned(block_start_pfn) ||
+		     block_start_pfn == cc->zone->zone_start_pfn) &&
 		    !fast_find_block && !isolation_suitable(cc, page))
 			continue;
 
@@ -2128,7 +2119,7 @@ static isolate_migrate_t isolate_migrate
 		}
 
 		/* Perform the isolation */
-		if (isolate_migratepages_block(cc, low_pfn, block_end_pfn,
+		if (isolate_migratepages_block(cc, block_start_pfn, block_end_pfn,
 						isolate_mode))
 			return ISOLATE_ABORT;
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-compaction-check-the-range-to-pageblock_pfn_to_page-is-within-the-zone-first.patch
mm-compaction-fix-the-range-to-pageblock_pfn_to_page.patch

