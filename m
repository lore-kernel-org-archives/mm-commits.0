Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2690B79CB
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 23:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711062781; cv=none; b=sFEK+PMEqLRpae9Lz6Wa+AO8C8KmllfmABksS3ik70PDRy2gB7cxM4nwm/Z3p3OI4AT7ISi2YZySrwoPmb3JtXmulQEZ4qJEGApqJULJNo5TNKrE+hy5PeuL5RpolGKO4m1JWVxIJGLZin+axJP7BNxadCGbPFtc7bUkQk87+Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711062781; c=relaxed/simple;
	bh=RCRdnWwQh4pUnF7xr60/ljhJJvmw2RaIXmPcdBqJwTk=;
	h=Date:To:From:Subject:Message-Id; b=IPPAhSUbfShXerg2jXgcSw1M/jBdyxINTU3fmIXTLYnk7znDv2mvyU5B4NNRTecq4nZm92OizcsvQjdpIen2HGShJlke9I7JYZz3D3iGobVbQPV6YbA/qRhKjTUuyFLCgTzMDpBDYBfZXpVnZpc9hNehaw4uJdLzFt+zdGuKAQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yYNGl9pZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yYNGl9pZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87BDC433C7;
	Thu, 21 Mar 2024 23:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711062781;
	bh=RCRdnWwQh4pUnF7xr60/ljhJJvmw2RaIXmPcdBqJwTk=;
	h=Date:To:From:Subject:From;
	b=yYNGl9pZj1G+5PqwvY1RAP6CPunzFszQbk9oJEdwd9X6+JmOqUQMJa75IwLrsD3Uw
	 uwlylTgbcNXBS7qn2bL0s8Pu88qBMkxSkJYkSSPTZI3hFEKxCMh6qtaP//QMklJI6G
	 lLjt+LbHaMvT/navYR2pqYuNR3h1eUXXs89fsdg4=
Date: Thu, 21 Mar 2024 16:13:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,vbabka@suse.cz,mgorman@techsingularity.net,david@redhat.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-prepare-for-hygienic-freelists-fix.patch added to mm-unstable branch
Message-Id: <20240321231300.E87BDC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_isolation-prepare-for-hygienic-freelists-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_isolation-prepare-for-hygienic-freelists-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-prepare-for-hygienic-freelists-fix.patch

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
Subject: mm-page_isolation-prepare-for-hygienic-freelists-fix
Date: Thu, 21 Mar 2024 10:24:26 -0400

work around older gcc warning

Link: https://lkml.kernel.org/r/20240321142426.GB777580@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
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

