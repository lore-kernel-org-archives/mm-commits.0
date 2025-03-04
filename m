Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1628079F5
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 04:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741062714; cv=none; b=BROScV8XXopPF1d625Cj+srpYJyW4Wg3ToFfg2sp7LctXhR3qDCIID9IH+R0v1TcIki2Gi8wCLDfFI5AzZzgV0XOrWExYKlPhzkUTocxkLhZoCOWXgvwMLEHQrtwdbIVKM15J49UDCNHGWdz68So+hiZsVVtDDZBXIBkTkK+E6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741062714; c=relaxed/simple;
	bh=+aPCCltZhLqHRM8jI5a7MAmM96bxOQAxvYOrs3W4P7U=;
	h=Date:To:From:Subject:Message-Id; b=nUGLxRxgYAe96m+fZk9vou+DtOdyHHMYJKqAuLxa3Ae+9Z1M0kEENGfUSPzebjrAbhOPC3/ZWbcm9KMrZHEwgWTYDqoS8+rJDQYnmlGteS/zXXManXjdSd4PoDF+keJFOzf3AB6o35r73olxRdhPE1bhr0Z7j5ntJi7/KkkcaSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gu+FtoBa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gu+FtoBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717C3C4CEE5;
	Tue,  4 Mar 2025 04:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741062713;
	bh=+aPCCltZhLqHRM8jI5a7MAmM96bxOQAxvYOrs3W4P7U=;
	h=Date:To:From:Subject:From;
	b=gu+FtoBaQLGnNAxbb3445EsUBCoyL8gWbXxiKeM8AhSk1YnNHEicjsYnKcWjMKO6r
	 T4VdqD1TFrjl0xt1KTK6mOnegt7u6DeTqEBMkl4edbnpN0L0Vx0/Ajy4qoCYaxlmeq
	 4Uu7fS+r5TjnoDFoBtlEpeSmDzLGYaJZ8ffUDFUE=
Date: Mon, 03 Mar 2025 20:31:52 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,vbabka@suse.cz,mhocko@kernel.org,mgorman@techsingularity.net,hannes@cmpxchg.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-clarify-should_claim_block-commentary.patch added to mm-unstable branch
Message-Id: <20250304043153.717C3C4CEE5@smtp.kernel.org>
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
@@ -1973,16 +1973,9 @@ static inline bool boost_watermark(struc
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
@@ -1997,19 +1990,32 @@ static bool should_try_claim_block(unsig
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

