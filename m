Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E107D7D07D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103954; cv=none; b=sQtLjcOwT+1+K7zb0t2B6unpw55040hN2Zsl1Zr3N39PKunHNveUbB/nEzR4f42gys0Laptwkv84ZcOWj8jf6fZyIWJQJhufGV0la8b2Ab0aWJiIymuQ6txryWF0U93f+pYmc6H0sbYQfIACRPyxemyZIvNehnnBiUXKAYYdzHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103954; c=relaxed/simple;
	bh=Kdsoow+b6y2LKld1QxuufFyZK/lsrdcQCEs/oNKkOT0=;
	h=Date:To:From:Subject:Message-Id; b=GNBqkFg+6qCQIWstnwYUbD8tAafEYz8xRB45yvLJwJljRo7EBE9Ro050YWsEV8UZMBBpYdQiPX0LyObbjKK83XtU6Ree2n42n5qT32NZj0JXifypY++q5Vint/KNSjzsHAh/YjlIoe2zSJhFUz55HM9iTYc7Di1aBw7juLyRrB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jfJHFD2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jfJHFD2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C0BC113CD;
	Fri, 26 Apr 2024 03:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103953;
	bh=Kdsoow+b6y2LKld1QxuufFyZK/lsrdcQCEs/oNKkOT0=;
	h=Date:To:From:Subject:From;
	b=jfJHFD2IfUmlJ1bgw7BNFv23QYdShQSTxKhIbw6eA34gwMwMUCjnz3DLa97JkBoPN
	 LdrLnQ3/mtuItYG5djDojNSHvQflD7pzbEeNeT+UZ9ggy9pyFHODM3bKI87M7+49JF
	 w7Z1046qct84bfZplFo2bRsVGsNEbFF/StjDriNw=
Date: Thu, 25 Apr 2024 20:59:13 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,vbabka@suse.cz,mgorman@techsingularity.net,david@redhat.com,baolin.wang@linux.alibaba.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks.patch removed from -mm tree
Message-Id: <20240426035913.B8C0BC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: fix up block types when merging compatible blocks
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
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


