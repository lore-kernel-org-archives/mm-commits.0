Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FF72F32
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 00:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740528094; cv=none; b=NdSTicnvZDbWzB2D0yqh8zFv49hXmvqA3X2R+R2o9PtfU2yI3ZbJfFAbepiUGvtl4xHJ263F4TUQHBOZtSTwj/KoFet6LeGnH1LO4xmRRw9eaQRFWv9CeKtqQyAHM2JSzJ0FJ8Q7EV9v+ot3gxLMrtBphD1bdX7/1OYPw2HBtKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740528094; c=relaxed/simple;
	bh=/v94eLhcOSdSqNvKUuXcXvEErxxaZJWkosZQNFy6U2k=;
	h=Date:To:From:Subject:Message-Id; b=eN+0ELrvPsWDjGkH1DdKAKiiifHLjNAhV0nF/+A3Rl6+DwOesJk7V2aaw3eK1W+jaI76z7+5Rrt51/2B26HHvyWUNqDLtw3rp8dSoS29+c/YGbWVz0o6j5BUxJ1w2ga0FnibI3Q0bIUTkbpVhebjyAmBxKmP/ofUhlwaRmPLNuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MUuE5pGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MUuE5pGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E18C4CEDD;
	Wed, 26 Feb 2025 00:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740528094;
	bh=/v94eLhcOSdSqNvKUuXcXvEErxxaZJWkosZQNFy6U2k=;
	h=Date:To:From:Subject:From;
	b=MUuE5pGV23eIbKRTPeWiPEbGktjDBOmhVvIogRAPBiuMXPynv6l+IDa2yh2UlASok
	 IIs3ehWEdtiqdVfJGIP32UNd6XbUiQnwExEdj/z+zUOwQYzdLh6wV62IS9fugA95mk
	 Z4HFZEnGCKBa71oTkVSIKNGTG2IK2Egzqh7epMPM=
Date: Tue, 25 Feb 2025 16:01:33 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,vbabka@suse.cz,mhocko@kernel.org,mgorman@techsingularity.net,hannes@cmpxchg.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-clarify-should_claim_block-commentary.patch added to mm-unstable branch
Message-Id: <20250226000134.03E18C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: clarify should_claim_block() commentary
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-clarify-should_claim_block-commentary.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-clarify-should_claim_block-commentary.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: clarify should_claim_block() commentary
Date: Tue, 25 Feb 2025 15:29:49 +0000

There's lots of text here but it's a little hard to follow, this is an
attempt to break it up and align its structure more closely with the code.

Reword the top-level function comment to just explain what question the
function answers from the point of view of the caller.

Break up the internal logic into different sections that can have their
own commentary describing why that part of the rationale is present.

Note the page_groupy_by_mobility_disabled logic is not explained in the
commentary, that is outside the scope of this patch...

Link: https://lkml.kernel.org/r/20250225-clarify-steal-v3-2-f2550ead0139@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

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
- * reclaimable and unmovable allocations, we claim the whole block regardless of
- * page size, as fragmentation caused by those allocations polluting movable
- * pageblocks is worse than movable allocations stealing from unmovable and
- * reclaimable pageblocks.
+ * When we are falling back to another migratetype during allocation, should we
+ * try to claim an entire block to satisfy further allocations, instead of
+ * polluting multiple pageblocks?
  */
 static bool should_claim_block(unsigned int order, int start_mt)
 {
@@ -1965,6 +1958,26 @@ static bool should_claim_block(unsigned
 		return true;
 
 	/*
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
+	 */
+	if (start_mt == MIGRATE_RECLAIMABLE || start_mt == MIGRATE_UNMOVABLE)
+		return true;
+
+	if (page_group_by_mobility_disabled)
+		return true;
+
+	/*
 	 * Movable pages won't cause permanent fragmentation, so when you alloc
 	 * small pages, you just need to temporarily steal unmovable or
 	 * reclaimable pages that are closest to the request size.  After a
@@ -1972,12 +1985,6 @@ static bool should_claim_block(unsigned
 	 * and the next movable allocation may not need to steal.  Unmovable and
 	 * reclaimable allocations need to actually claim the whole block.
 	 */
-	if (order >= pageblock_order / 2 ||
-		start_mt == MIGRATE_RECLAIMABLE ||
-		start_mt == MIGRATE_UNMOVABLE ||
-		page_group_by_mobility_disabled)
-		return true;
-
 	return false;
 }
 
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-mmu_gather-update-comment-on-rcu-freeing.patch
selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch
selftests-mm-fix-assumption-that-sudo-is-present.patch
selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch
selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch
selftests-mm-uffd-rename-nr_cpus-nr_threads.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch
selftests-mm-skip-map_populate-on-weird-filesystems.patch
selftests-mm-skip-gup_longerm-tests-on-weird-filesystems.patch
mm-page_alloc-warn-on-nr_reserved_highatomic-underflow.patch
mm-page_alloc-clarify-terminology-in-migratetype-fallback-code.patch
mm-page_alloc-clarify-should_claim_block-commentary.patch
scripts-gdb-add-lx_per_cpu_ptr.patch

