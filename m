Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218D58634E
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188519; cv=none; b=eBpe7K5yRDauAQ2tAq4uLyOx4F8s12O9pIkGPYlpGuf2P6f2D8c5djLdy1hRhv7UxzypkiBOR7JQgL6R6Hf5mb5Qlz8yGCxlFSTre8woktzszEZ/GGQqLkZuh8CXbL+gfl8F53538g4r1qruZW76SKxC5x2riSTP1/ghp6whBjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188519; c=relaxed/simple;
	bh=G11wD/pGyFcL2AoaQAMw2kRyOb8TYbCuEpN1aFPKzIg=;
	h=Date:To:From:Subject:Message-Id; b=rlfYkiHz+6WvSHX+Oo8fQIpG/gWMOJbGr1eWoBgwdyqpY4423tP6qcs01DEKpJWYdCelCXIEEBWgdqK4Vatl+VCGQwqpb62zFWwsmo8bnlax44dzb4jg2uCmlTjzPNLKF7DkiixJJi0LJgy7/GmDzaZuxwdLS/nEM0iFVD/Erw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oKc0xEBG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oKc0xEBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFDEC4CEEC;
	Mon, 17 Mar 2025 05:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188519;
	bh=G11wD/pGyFcL2AoaQAMw2kRyOb8TYbCuEpN1aFPKzIg=;
	h=Date:To:From:Subject:From;
	b=oKc0xEBGLG9kGufdL4fJW45678ZjUGsy9gGuz6SmUliXRp8eh4BQfltVyUcuiCwaT
	 N2eX5TQaClWLBRDWU7nzzFqkdEdYREKJrQ4pZ4qL1Icw3fAWEWAUrA14lv+3pYdrEa
	 O1foGrQgAPJ/gjD8CfFK3vglgNbuRyovkSP0yVh0=
Date: Sun, 16 Mar 2025 22:15:18 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,vbabka@suse.cz,mhocko@kernel.org,mgorman@techsingularity.net,hannes@cmpxchg.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-clarify-should_claim_block-commentary.patch removed from -mm tree
Message-Id: <20250317051518.EAFDEC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: clarify should_claim_block() commentary
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-clarify-should_claim_block-commentary.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: clarify should_claim_block() commentary
Date: Fri, 28 Feb 2025 09:52:18 +0000

There's lots of text here but it's a little hard to follow, this is an
attempt to break it up and align its structure more closely with the code.

Reword the top-level function comment to just explain what question the
function answers from the point of view of the caller.

Break up the internal logic into different sections that can have their
own commentary describing why that part of the rationale is present.

Note the page_group_by_mobility_disabled logic is not explained in the
commentary, that is outside the scope of this patch...

Link: https://lkml.kernel.org/r/20250228-clarify-steal-v4-2-cb2ef1a4e610@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   46 ++++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-clarify-should_claim_block-commentary
+++ a/mm/page_alloc.c
@@ -1941,16 +1941,9 @@ static inline bool boost_watermark(struc
 }
 
 /*
- * When we are falling back to another migratetype during allocation, try to
- * claim entire blocks to satisfy further allocations, instead of polluting
- * multiple pageblocks.
- *
- * If we are stealing a relatively large buddy page, it is likely there will be
- * more free pages in the pageblock, so try to claim the whole block. For
- * reclaimable and unmovable allocations, we try to claim the whole block
- * regardless of page size, as fragmentation caused by those allocations
- * polluting movable pageblocks is worse than movable allocations stealing from
- * unmovable and reclaimable pageblocks.
+ * When we are falling back to another migratetype during allocation, should we
+ * try to claim an entire block to satisfy further allocations, instead of
+ * polluting multiple pageblocks?
  */
 static bool should_try_claim_block(unsigned int order, int start_mt)
 {
@@ -1965,19 +1958,32 @@ static bool should_try_claim_block(unsig
 		return true;
 
 	/*
-	 * Movable pages won't cause permanent fragmentation, so when you alloc
-	 * small pages, you just need to temporarily steal unmovable or
-	 * reclaimable pages that are closest to the request size.  After a
-	 * while, memory compaction may occur to form large contiguous pages,
-	 * and the next movable allocation may not need to steal.  Unmovable and
-	 * reclaimable allocations need to actually claim the whole block.
+	 * Above a certain threshold, always try to claim, as it's likely there
+	 * will be more free pages in the pageblock.
+	 */
+	if (order >= pageblock_order / 2)
+		return true;
+
+	/*
+	 * Unmovable/reclaimable allocations would cause permanent
+	 * fragmentations if they fell back to allocating from a movable block
+	 * (polluting it), so we try to claim the whole block regardless of the
+	 * allocation size. Later movable allocations can always steal from this
+	 * block, which is less problematic.
 	 */
-	if (order >= pageblock_order / 2 ||
-		start_mt == MIGRATE_RECLAIMABLE ||
-		start_mt == MIGRATE_UNMOVABLE ||
-		page_group_by_mobility_disabled)
+	if (start_mt == MIGRATE_RECLAIMABLE || start_mt == MIGRATE_UNMOVABLE)
 		return true;
 
+	if (page_group_by_mobility_disabled)
+		return true;
+
+	/*
+	 * Movable pages won't cause permanent fragmentation, so when you alloc
+	 * small pages, we just need to temporarily steal unmovable or
+	 * reclaimable pages that are closest to the request size. After a
+	 * while, memory compaction may occur to form large contiguous pages,
+	 * and the next movable allocation may not need to steal.
+	 */
 	return false;
 }
 
_

Patches currently in -mm which might be from jackmanb@google.com are

scripts-gdb-add-lx_per_cpu_ptr.patch

