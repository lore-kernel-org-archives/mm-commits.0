Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD9D33CE8A
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 20:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999235; cv=none; b=NQt5tRuO55oXJ8OZqQsLc7rNAAZAuj/hn6Z8OCw6zQVDQnRvx/9lOU/hP3KkX6K62emi3M1ppnvTAAeR1RSdBNhT/6bFAzJCX7R17o3FVTNVSB8IEDQb3D1KNS3C3MteSGzNOG5vIzL/EaHGxbQRIvDVLA78Je+7Ai2G/rgcP/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999235; c=relaxed/simple;
	bh=kKlKmvZ7qAZV5wqfLPJf7eZnB8Msltmm1eLGCdSc5Js=;
	h=Date:To:From:Subject:Message-Id; b=LWtKplNGtHcmnp96P6U9wZt34SDavyYmaTi0WXeQFHSOBeLcyuIbZHSKg94zZV9x4ApZwdF9YpszUWqgl4HjjAFe9RfLEE4mFou1Y+DqClgvCnap5TnThWRHXYZ0lCxGfOWx6s2KU6txjKxv8o4Yx9ShxLw/V6Nt7D0hsPP7g4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cr3LkWCJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cr3LkWCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E861F000E9;
	Thu, 28 May 2026 20:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779999234;
	bh=bqsvjfvjlJ57YxWUIB/VxA9n4dmzM2g58Ky88xrxlfg=;
	h=Date:To:From:Subject;
	b=cr3LkWCJfSL7SH8FpvNbpoAoClF9r53KyBhW/vsbq7svncFe4XhxtTrnWQmOpemDZ
	 c85FTyXlXlrxHn+SE5MBk8gGTO8Hfr5nzByAWwsbQx/QN48gpR510sXauF0jMIw5y9
	 aBkrZNzKjerBLuBrkbDa7k0gwxQuDjeleppW3daA=
Date: Thu, 28 May 2026 13:13:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,fujunjie1@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-respect-cpusets-when-checking-retry-suitability.patch added to mm-new branch
Message-Id: <20260528201353.E6E861F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/compaction: respect cpusets when checking retry suitability
has been added to the -mm mm-new branch.  Its filename is
     mm-compaction-respect-cpusets-when-checking-retry-suitability.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-respect-cpusets-when-checking-retry-suitability.patch

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
From: fujunjie <fujunjie1@qq.com>
Subject: mm/compaction: respect cpusets when checking retry suitability
Date: Tue, 26 May 2026 12:22:41 +0000

should_compact_retry() handles COMPACT_SKIPPED by asking
compaction_zonelist_suitable() whether reclaim can make a later compaction
attempt worthwhile.  That answer is used for the current allocation, so it
should follow the same zone eligibility rules as the allocation itself.

When cpusets are enabled, allocator slowpath decisions are marked with
ALLOC_CPUSET.  The allocation path, direct compaction and reclaim retry
all skip zones rejected by __cpuset_zone_allowed().

compaction_zonelist_suitable() does not apply that filter.  It only walks
ac->zonelist/ac->nodemask, so it can return true because a zone that is
not usable for the current allocation would pass __compaction_suitable().

That does not let the allocation use the disallowed zone.  Later
allocation and direct compaction paths still apply cpuset filtering. 
However, it can make should_compact_retry() retry based on memory that
this allocation cannot use.

Pass gfp_mask down and apply the same ALLOC_CPUSET check in
compaction_zonelist_suitable().  This keeps the retry decision aligned
with the zones that the allocation is allowed to use.

A temporary debugfs probe was also used to call the old and new
compaction_zonelist_suitable() predicates in the same two-node NUMA guest.
The task was restricted to mems=0 while ac->nodemask covered nodes 0-1. 
After putting pressure on node0, node0 failed __compaction_suitable() for
order-10 and node1 passed it, but node1 was rejected by
__cpuset_zone_allowed().  In that state the old predicate returned true
and the patched predicate returned false.

Link: https://lore.kernel.org/tencent_F59F2BA2CC5779308E10DF54593C736D3E0A@qq.com
Fixes: 435b3894e742 ("mm:page_alloc: fix the NULL ac->nodemask in __alloc_pages_slowpath()")
Signed-off-by: fujunjie <fujunjie1@qq.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    2 +-
 mm/compaction.c            |    6 +++++-
 mm/page_alloc.c            |   15 +++++++++------
 3 files changed, 15 insertions(+), 8 deletions(-)

--- a/include/linux/compaction.h~mm-compaction-respect-cpusets-when-checking-retry-suitability
+++ a/include/linux/compaction.h
@@ -101,7 +101,7 @@ extern void compaction_defer_reset(struc
 				bool alloc_success);
 
 bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
-					int alloc_flags);
+					int alloc_flags, gfp_t gfp_mask);
 
 extern void __meminit kcompactd_run(int nid);
 extern void __meminit kcompactd_stop(int nid);
--- a/mm/compaction.c~mm-compaction-respect-cpusets-when-checking-retry-suitability
+++ a/mm/compaction.c
@@ -2448,7 +2448,7 @@ bool compaction_suitable(struct zone *zo
 
 /* Used by direct reclaimers */
 bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
-		int alloc_flags)
+		int alloc_flags, gfp_t gfp_mask)
 {
 	struct zone *zone;
 	struct zoneref *z;
@@ -2461,6 +2461,10 @@ bool compaction_zonelist_suitable(struct
 				ac->highest_zoneidx, ac->nodemask) {
 		unsigned long available;
 
+		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
+		    !__cpuset_zone_allowed(zone, gfp_mask))
+			continue;
+
 		/*
 		 * Do not consider all the reclaimable memory because we do not
 		 * want to trash just for a single high order allocation which
--- a/mm/page_alloc.c~mm-compaction-respect-cpusets-when-checking-retry-suitability
+++ a/mm/page_alloc.c
@@ -4198,7 +4198,8 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 }
 
 static inline bool
-should_compact_retry(struct alloc_context *ac, int order, int alloc_flags,
+should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
+		     int alloc_flags,
 		     enum compact_result compact_result,
 		     enum compact_priority *compact_priority,
 		     int *compaction_retries)
@@ -4220,7 +4221,8 @@ should_compact_retry(struct alloc_contex
 	 * migration targets. Continue if reclaim can help.
 	 */
 	if (compact_result == COMPACT_SKIPPED) {
-		ret = compaction_zonelist_suitable(ac, order, alloc_flags);
+		ret = compaction_zonelist_suitable(ac, order, alloc_flags,
+						   gfp_mask);
 		goto out;
 	}
 
@@ -4273,7 +4275,8 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 }
 
 static inline bool
-should_compact_retry(struct alloc_context *ac, int order, int alloc_flags,
+should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
+		     int alloc_flags,
 		     enum compact_result compact_result,
 		     enum compact_priority *compact_priority,
 		     int *compaction_retries)
@@ -4940,9 +4943,9 @@ retry:
 	 * of free memory (see __compaction_suitable)
 	 */
 	if (did_some_progress > 0 && can_compact &&
-			should_compact_retry(ac, order, alloc_flags,
-				compact_result, &compact_priority,
-				&compaction_retries))
+	    should_compact_retry(gfp_mask, ac, order, alloc_flags,
+				 compact_result, &compact_priority,
+				 &compaction_retries))
 		goto retry;
 
 	/* Reclaim/compaction failed to prevent the fallback */
_

Patches currently in -mm which might be from fujunjie1@qq.com are

mm-madvise-reject-invalid-process_madvise-advice-for-zero-length-vectors.patch
mm-filemap-count-only-the-faulting-address-as-a-mmap-hit.patch
mm-filemap-do-not-count-fault_flag_tried-retries-as-mmap-hits.patch
mm-compaction-respect-cpusets-when-checking-retry-suitability.patch

