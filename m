Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AA8BA57
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 23:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711062764; cv=none; b=Y9+rLE7/0dcrDOyxRC674yx0DNqL0bODDETH/qnao2ZR01xGxu4dV0ctro+AgZypjIVkU6vmtcFXsrAnURyUf6LM2NUGyqLa+Qykneg55ObRCkckvGqSJM6/rEihJUOvLpzXgKP/baQkguwIh66PU6CSv9mXoV/djtwxS9/xzwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711062764; c=relaxed/simple;
	bh=DlXrU28KtrNdSgrbdIAWJ6gYVhLjg78yo0OuKseSeN8=;
	h=Date:To:From:Subject:Message-Id; b=Gqgoq92o6AVWy3eL8p7CTDbeoVXL0uOAi9j1Qu72AvBxbYz/jurvDc4/+Nkvo6Z0yupG3Q1AfrGr6S19xPz445kKbiThGx45jll7IuuL4ys8wnTswvLmJiGW3tsfYGkkH7Minm6hyZAc6jZezRcYMrpFxw+8cDPDqhfq3WEhDWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KcDeODOR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KcDeODOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FB1C43394;
	Thu, 21 Mar 2024 23:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711062763;
	bh=DlXrU28KtrNdSgrbdIAWJ6gYVhLjg78yo0OuKseSeN8=;
	h=Date:To:From:Subject:From;
	b=KcDeODOR7yAa7gJdQD3YaLC5efNzAbvoZMQqfZOYieOuBVvpPh76XbZU3qBSK9Pc0
	 ydy5/vU61Iw6xM3qh4u0YKYgSNBq9eWM+FoA26rRdCJxOe/puYJw7ZIuxOFtIP2omd
	 5OeQAIZwV2PV+WITnKoZ+crEdmOX/7hmYexaKoPE=
Date: Thu, 21 Mar 2024 16:12:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,vbabka@suse.cz,mgorman@techsingularity.net,david@redhat.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-optimize-free_unref_folios.patch added to mm-unstable branch
Message-Id: <20240321231243.A4FB1C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: optimize free_unref_folios()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-optimize-free_unref_folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-optimize-free_unref_folios.patch

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
Subject: mm: page_alloc: optimize free_unref_folios()
Date: Wed, 20 Mar 2024 14:02:07 -0400

Move direct freeing of isolated pages to the lock-breaking block in the
second loop.  This saves an unnecessary migratetype reassessment.

Minor comment and local variable scoping cleanups.

Link: https://lkml.kernel.org/r/20240320180429.678181-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: "Huang, Ying" <ying.huang@intel.com>
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

