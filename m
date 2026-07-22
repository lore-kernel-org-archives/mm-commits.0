Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F193B635A
	for <mm-commits@vger.kernel.org>; Wed, 22 Jul 2026 23:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784762549; cv=none; b=ikOon/9Pu0Xg9/uHcFdi7cV99pmH+9T0C3j/Y2bmS9MM+AuQP1h4+BP2m+R5q9Tfl26WwyZbroKAsbfsWK7Db62Iv6BGUFejsLAYSZu9aSLpZpqtUcauwSiY0E2jYK7i/FPX56XpwDdoVyB1qbamC899beZyiUERzt122Cy/lR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784762549; c=relaxed/simple;
	bh=o2TjWulxEqsHRXc4OXpvfnDZNSw6R80IOR12oQ6B/m4=;
	h=Date:To:From:Subject:Message-Id; b=OJpsUAPEMd6XXh78OFY2rmI4rC9db69kZ9/itazLVhN4rCBXz1KRdVlt28We16r505tAAx4E9BtwHRX3Ry2b7dDU6eFx7Me1J/MTGM2lxWOwqOtUo63O5vRhmhPs/YYRxp09j0NXqFKjDGJgigS9iYHgp76RZrzX3oHOQt2QbKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LNAs5O1V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LNAs5O1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5521F000E9;
	Wed, 22 Jul 2026 23:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784762547;
	bh=MjooJKAFifDdc70lxwnDc1gArNA7ak9EQkcwBsZBzTA=;
	h=Date:To:From:Subject;
	b=LNAs5O1V5YHXSEEI6ZdAkslVhNnLwHhsm6tEPFULUKZBmd17rbwbr/2UnHQ1gPWIY
	 7lNSibQJliOPFLlHu+yRBHoDadWl/u2O8z9Tvv9zuAKuaPYsF2zrTsSa0BTCHwJ5Xb
	 2u8v7ynT3ivVpqhN6ngiQG6hJ9TirB/bYC0jJSEw=
Date: Wed, 22 Jul 2026 16:22:27 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,gourry@gourry.net,david@kernel.org,brendan.jackman@linux.dev,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-support-non-movable-compaction-for-pageblock-requests.patch added to mm-new branch
Message-Id: <20260722232227.BD5521F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: compaction: support non-movable compaction for pageblock requests
has been added to the -mm mm-new branch.  Its filename is
     mm-compaction-support-non-movable-compaction-for-pageblock-requests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-support-non-movable-compaction-for-pageblock-requests.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: compaction: support non-movable compaction for pageblock requests
Date: Wed, 22 Jul 2026 10:56:45 -0400

While trying to fix a reclaim storm in defrag_mode, I noticed that
non-movable direct compaction is extremely inefficient.

When searching for space to evacuate, compaction only allows blocks of the
same type as the incoming request.  This is to prevent migratetype
pollution, where a small non-movable request frees space in a movable
block and provokes the allocator to fall back and pollute it.

This protection is reasonable on one hand, but the downside is that it
makes non-movable direct compaction nearly useless: if we get the type
annotations right, by definition there aren't any movable pages inside the
non-movable blocks it is allowed to scan.

With defrag_mode, the goal is the production of whole blocks, which are
essentially type neutral: __rmqueue_claim() will convert them wholesale on
alloc.  This makes type mixing and pollution a non-issue.

Fix the pollution gates to take the requested order into account, and
allow whole-block requests to scan blocks of other types.

The only exception is CMA blocks.  That type is sticky and these blocks
cannot be claimed to other types.  Continue to be strict with them, and
allow only explicit ALLOC_CMA requests and kcompactd to evacuate them.

Link: https://lore.kernel.org/20260722150006.3848560-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   46 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 7 deletions(-)

--- a/mm/compaction.c~mm-compaction-support-non-movable-compaction-for-pageblock-requests
+++ a/mm/compaction.c
@@ -1381,12 +1381,44 @@ static bool suitable_migration_source(st
 	if (pageblock_skip_persistent(page))
 		return false;
 
-	if ((cc->mode != MIGRATE_ASYNC) || !cc->direct_compaction)
+	/*
+	 * Background compaction produces blocks for the zone at
+	 * large, with no particular allocation context. Allow all
+	 * block types, including CMA.
+	 */
+	if (!cc->direct_compaction)
 		return true;
 
 	block_mt = get_pageblock_migratetype(page);
 
-	if (cc->migratetype == MIGRATE_MOVABLE)
+	/*
+	 * CMA pages can only be taken by ALLOC_CMA requests. For anybody
+	 * else, vacating a CMA block consumes free pages the caller
+	 * could have used, and produces free pages it cannot.
+	 */
+	if (is_migrate_cma(block_mt) && !(cc->alloc_flags & ALLOC_CMA))
+		return false;
+
+	/*
+	 * Per default, scans are restricted to blocks compatible with
+	 * the request, to prevent cross-contamination. Once
+	 * compaction priority escalates to synchronous scans, though,
+	 * scan all blocks to try to make forward progress. For
+	 * movable request, this likely helps little: there shouldn't
+	 * be many migratable pages inside non-movable blocks besides
+	 * allocator fallbacks. For non-movable requests, this helps a
+	 * lot, as they can finally scan movable blocks.
+	 */
+	if (cc->mode != MIGRATE_ASYNC)
+		return true;
+
+	/*
+	 * Prevent <pageblock_order unmovable/reclaimable requests from
+	 * polluting movable blocks through fallbacks. Whole-block production
+	 * (directly requested, or defrag_mode) is exempt as the allocator
+	 * claims and converts these.
+	 */
+	if (cc->migratetype == MIGRATE_MOVABLE || cc->order >= pageblock_order)
 		return is_migrate_movable(block_mt);
 	else
 		return block_mt == cc->migratetype;
@@ -1972,12 +2004,12 @@ static unsigned long fast_find_migratebl
 		return pfn;
 
 	/*
-	 * Only allow kcompactd and direct requests for movable pages to
-	 * quickly clear out a MOVABLE pageblock for allocation. This
-	 * reduces the risk that a large movable pageblock is freed for
-	 * an unmovable/reclaimable small allocation.
+	 * Prevent <pageblock_order unmovable/reclaimable requests from
+	 * polluting movable blocks through fallbacks. Whole-block production
+	 * is exempt as the allocator claims and converts these.
 	 */
-	if (cc->direct_compaction && cc->migratetype != MIGRATE_MOVABLE)
+	if (cc->direct_compaction && cc->migratetype != MIGRATE_MOVABLE &&
+	    cc->order < pageblock_order)
 		return pfn;
 
 	/*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-mempolicy-fix-automatic-numa-balancing-for-shmem.patch
mm-gfp_types-fix-__gfp_account-gfp_kernel_account-documentation.patch
mm-page_alloc-__gfp_fs-lockdep-annotation-for-direct-compaction.patch
mm-compaction-support-non-movable-compaction-for-pageblock-requests.patch
mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode.patch

