Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3101D1DFD6
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 23:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711062766; cv=none; b=iuzRRSHaCIMg3GprHzD5Xi6Fj0NYbEDHEFZ2N/o6XQQMPElsSp1xWaGKvkEISBMG27B4GpvXXBDYACWmlMPfSyUvVJ2Cw98qXkkNOVUGT0Yafa2UIspoObiOfLjWcK3wJ84Xv38f0foTBKF1KJXpuRgqX0KhuMOLLO8OEeZINGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711062766; c=relaxed/simple;
	bh=Hq6pAUQPAB4FD/UrcwwoLT60F5EzoK8G8CAWKdZCkNo=;
	h=Date:To:From:Subject:Message-Id; b=aiTSKXZHM+pKDLXiH9sK//qi+LHLwMPKsbL1rtjEWoFTdRH8gprCyk8FpmPTB+51DVa9IzKHOztQoR3NVYuulpS9z2hit0Py4sI/pWNPgs24hH8QmCnbrdVWbPm5xjK/MHQbiLR4W/Z786mY/OuUcb2PjTmPhR53rtCRaQpMY5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1JbOdh1z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1JbOdh1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F21C433F1;
	Thu, 21 Mar 2024 23:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711062765;
	bh=Hq6pAUQPAB4FD/UrcwwoLT60F5EzoK8G8CAWKdZCkNo=;
	h=Date:To:From:Subject:From;
	b=1JbOdh1zGjJ9rpoKvkN1+qjhuzbdjSAj99lN2m67p/hbrcSHr4kmbc+RVj/Dlvu1R
	 YDnS6YFmWGxRtLqj86LZ6Ke2ryt66Q43uicP7RKrlLsDDDO64ppNAK5Em/8KfxachM
	 I5cTEHvw/arwvmDANzBGWRM1PnooQ3kdwK7+6a5E=
Date: Thu, 21 Mar 2024 16:12:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,vbabka@suse.cz,mgorman@techsingularity.net,david@redhat.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks.patch added to mm-unstable branch
Message-Id: <20240321231245.91F21C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: fix up block types when merging compatible blocks
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks.patch

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
Subject: mm: page_alloc: fix up block types when merging compatible blocks
Date: Wed, 20 Mar 2024 14:02:08 -0400

The buddy allocator coalesces compatible blocks during freeing, but it
doesn't update the types of the subblocks to match.  When an allocation
later breaks the chunk down again, its pieces will be put on freelists of
the wrong type.  This encourages incompatible page mixing (ask for one
type, get another), and thus long-term fragmentation.

Update the subblocks when merging a larger chunk, such that a later
expand() will maintain freelist type hygiene.

Link: https://lkml.kernel.org/r/20240320180429.678181-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Tested-by: "Huang, Ying" <ying.huang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks
+++ a/mm/page_alloc.c
@@ -786,10 +786,17 @@ static inline void __free_one_page(struc
 			 */
 			int buddy_mt = get_pfnblock_migratetype(buddy, buddy_pfn);
 
-			if (migratetype != buddy_mt
-					&& (!migratetype_is_mergeable(migratetype) ||
-						!migratetype_is_mergeable(buddy_mt)))
-				goto done_merging;
+			if (migratetype != buddy_mt) {
+				if (!migratetype_is_mergeable(migratetype) ||
+				    !migratetype_is_mergeable(buddy_mt))
+					goto done_merging;
+				/*
+				 * Match buddy type. This ensures that
+				 * an expand() down the line puts the
+				 * sub-blocks on the right freelists.
+				 */
+				set_pageblock_migratetype(buddy, migratetype);
+			}
 		}
 
 		/*
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

