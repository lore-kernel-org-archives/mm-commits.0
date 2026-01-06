Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0689334D386
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 18:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722868; cv=none; b=trEPOny18+F9cGn9O+cXIeaQ6R3P0L9u7OaXA9wwpFxzXV9PZry99jKIEpHpony3KJTtxic/1Au+EoY6KQnXi0ultipyAVVos72EvJc2SobOkfZg09EG0EvBVhVFSwHBiuHB6k1Lr2ooDr08qpYEOzI0p1bQ2G9X+0pafcXBrI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722868; c=relaxed/simple;
	bh=zIP4y6NxTDI/JTVo0wyztRq11SiutvocuWBxau4Xev8=;
	h=Date:To:From:Subject:Message-Id; b=oQSZ7sCRZa2gRh0xHmhiIK+RNUSJ5mNNq4mmKqYl5xRzKw4sm/8B/aWUnHuELGWryQOba2x9wDAkBuCZLJSpxY7lfVDWDthZtK8R/4JXmxgOgnxRLXD1+cdzZYApLg4PxzlAnjx/thY7fhBBDQJW5Wibcd0OwulMSuXnB81/lo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=myQmylLI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="myQmylLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA398C116C6;
	Tue,  6 Jan 2026 18:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767722867;
	bh=zIP4y6NxTDI/JTVo0wyztRq11SiutvocuWBxau4Xev8=;
	h=Date:To:From:Subject:From;
	b=myQmylLISkbow1tQbiCGIZpIKTI5DDRbuKeTWM2f7jLLge2/RAm6IupQCyuBbxN98
	 F0Ek6ZdggwPsH5Ht6yszLm6MnsZ2M9tRy9Tst7v6wXJVllDEPhERjMqzDNAp40ZRCg
	 kwn0NbRQBIDn099AeruHOfXS4awHb6y+BbgshPBY=
Date: Tue, 06 Jan 2026 10:07:47 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,surenb@google.com,rppt@kernel.org,rientjes@google.com,pfalcato@suse.de,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-ignore-the-exact-initial-compaction-result.patch added to mm-new branch
Message-Id: <20260106180747.AA398C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: ignore the exact initial compaction result
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-ignore-the-exact-initial-compaction-result.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-ignore-the-exact-initial-compaction-result.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/page_alloc: ignore the exact initial compaction result
Date: Tue, 06 Jan 2026 12:52:36 +0100

Patch series "tweaks for __alloc_pages_slowpath()", v3.


This patch (of 3):

For allocations that are of costly order and __GFP_NORETRY (and can
perform compaction) we attempt direct compaction first.  If that fails, we
continue with a single round of direct reclaim+compaction (as for other
__GFP_NORETRY allocations, except the compaction is of lower priority),
with two exceptions that fail immediately:

- __GFP_THISNODE is specified, to prevent zone_reclaim_mode-like
  behavior for e.g. THP page faults

- compaction failed because it was deferred (i.e. has been failing
  recently so further attempts are not done for a while) or skipped,
  which means there are insufficient free base pages to defragment to
  begin with

Upon closer inspection, the second condition has a somewhat flawed
reasoning.  If there are not enough base pages and reclaim could create
them, we instead fail.  When there are enough base pages and compaction
has already ran and failed, we proceed and hope that reclaim and the
subsequent compaction attempt will succeed.  But it's unclear why they
should and whether it will be as inexpensive as intended.

It might make therefore more sense to just fail unconditionally after the
initial compaction attempt.  However that would change the semantics of
__GFP_NORETRY to attempt reclaim at least once.

Alternatively we can remove the compaction result checks and proceed with
the single reclaim and (lower priority) compaction attempt, leaving only
the __GFP_THISNODE exception for failing immediately.

Link: https://lkml.kernel.org/r/20260106-thp-thisnode-tweak-v3-0-f5d67c21a193@suse.cz
Link: https://lkml.kernel.org/r/20260106-thp-thisnode-tweak-v3-1-f5d67c21a193@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   34 ++++++----------------------------
 1 file changed, 6 insertions(+), 28 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-ignore-the-exact-initial-compaction-result
+++ a/mm/page_alloc.c
@@ -4806,43 +4806,21 @@ restart:
 		 */
 		if (costly_order && (gfp_mask & __GFP_NORETRY)) {
 			/*
-			 * If allocating entire pageblock(s) and compaction
-			 * failed because all zones are below low watermarks
-			 * or is prohibited because it recently failed at this
-			 * order, fail immediately unless the allocator has
-			 * requested compaction and reclaim retry.
-			 *
-			 * Reclaim is
-			 *  - potentially very expensive because zones are far
-			 *    below their low watermarks or this is part of very
-			 *    bursty high order allocations,
-			 *  - not guaranteed to help because isolate_freepages()
-			 *    may not iterate over freed pages as part of its
-			 *    linear scan, and
-			 *  - unlikely to make entire pageblocks free on its
-			 *    own.
-			 */
-			if (compact_result == COMPACT_SKIPPED ||
-			    compact_result == COMPACT_DEFERRED)
-				goto nopage;
-
-			/*
 			 * THP page faults may attempt local node only first,
 			 * but are then allowed to only compact, not reclaim,
 			 * see alloc_pages_mpol().
 			 *
-			 * Compaction can fail for other reasons than those
-			 * checked above and we don't want such THP allocations
-			 * to put reclaim pressure on a single node in a
-			 * situation where other nodes might have plenty of
-			 * available memory.
+			 * Compaction has failed above and we don't want such
+			 * THP allocations to put reclaim pressure on a single
+			 * node in a situation where other nodes might have
+			 * plenty of available memory.
 			 */
 			if (gfp_mask & __GFP_THISNODE)
 				goto nopage;
 
 			/*
-			 * Looks like reclaim/compaction is worth trying, but
-			 * sync compaction could be very expensive, so keep
+			 * Proceed with single round of reclaim/compaction, but
+			 * since sync compaction could be very expensive, keep
 			 * using async compaction.
 			 */
 			compact_priority = INIT_COMPACT_PRIORITY;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-prevent-pcp-corruption-with-smp=n.patch
mm-page_alloc-thp-prevent-reclaim-for-__gfp_thisnode-thp-allocations.patch
mm-page_alloc-ignore-the-exact-initial-compaction-result.patch
mm-page_alloc-refactor-the-initial-compaction-handling.patch
mm-page_alloc-simplify-__alloc_pages_slowpath-flow.patch

