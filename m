Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD94C31A8F
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 23:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711062767; cv=none; b=Fzpvq2L7oJYpkLxupqRBd+Du85lFyScldCJUIMmoJCpSvH50V+P2EtGZtbESIjpOAWUq4L73P7nUrDe/1pD348a0lrJ2BkCaL3hvEeqq+V3FjqlpLipgH8sMMdnjq+tiP8lkBCRp2mjHzU0lvZQ0vR1ScCSTvisr1Mlwxi2qYKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711062767; c=relaxed/simple;
	bh=l3o9fctimhrFfGbLkuimRq3r7Iq1x+6DYCFUKuf4JH8=;
	h=Date:To:From:Subject:Message-Id; b=R+gOpgwHO4MC35puWNuaUHfoQwv8TFX1xTMETpHX1xQvJfBaP+LBqtxAZdWvJTgDihpyaG2tPqVdP7+bffqGWPnuEaZjDysy6KR1V7b3rZjfuANtSprRukrggpobgzysslV94jcStMp7Ak/YHLhdUxeIAoBvzZjZ27Zd+OGol68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E44EzllE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E44EzllE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DA0C43390;
	Thu, 21 Mar 2024 23:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711062767;
	bh=l3o9fctimhrFfGbLkuimRq3r7Iq1x+6DYCFUKuf4JH8=;
	h=Date:To:From:Subject:From;
	b=E44EzllEVgGQuxDg/vLfNFuD/6i2RRH+dW0X5creGeFYzZHPXyE5X2YWSPa4lxWZE
	 FoW0Rvjhp6DU8njLRjOZkiLt+9MesGWnw+5nF4M8biNLfzyzKdUMB4ksBMuvrK7ycm
	 mo7uVVkUQuAgGsvuOTpNUeetIGv3NNb4axee+vK4=
Date: Thu, 21 Mar 2024 16:12:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,vbabka@suse.cz,mgorman@techsingularity.net,david@redhat.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-move-free-pages-when-converting-block-during-isolation.patch added to mm-unstable branch
Message-Id: <20240321231247.59DA0C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: move free pages when converting block during isolation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-move-free-pages-when-converting-block-during-isolation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-move-free-pages-when-converting-block-during-isolation.patch

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
Subject: mm: page_alloc: move free pages when converting block during isolation
Date: Wed, 20 Mar 2024 14:02:09 -0400

When claiming a block during compaction isolation, move any remaining free
pages to the correct freelists as well, instead of stranding them on the
wrong list.  Otherwise, this encourages incompatible page mixing down the
line, and thus long-term fragmentation.

Link: https://lkml.kernel.org/r/20240320180429.678181-5-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Tested-by: "Huang, Ying" <ying.huang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-move-free-pages-when-converting-block-during-isolation
+++ a/mm/page_alloc.c
@@ -2653,9 +2653,12 @@ int __isolate_free_page(struct page *pag
 			 * Only change normal pageblocks (i.e., they can merge
 			 * with others)
 			 */
-			if (migratetype_is_mergeable(mt))
+			if (migratetype_is_mergeable(mt)) {
 				set_pageblock_migratetype(page,
 							  MIGRATE_MOVABLE);
+				move_freepages_block(zone, page,
+						     MIGRATE_MOVABLE, NULL);
+			}
 		}
 	}
 
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

