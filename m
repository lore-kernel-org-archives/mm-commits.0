Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EAE31619E
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486672; cv=none; b=Np57+dwvAPtJyqXiO0A08exw8NcaQmVPmclETDkzTvUPYWSiOPE2hmYxnwtML1IGc1lymmMOpp5x26yzWv0PLubRvbXFZiiJ+tHXbUwTJr45KwfvYsslfISNsSmoUARjkPMyWrtQn1hEksvWdupZO47UkJ3TlDH/0zp6ye4TsVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486672; c=relaxed/simple;
	bh=cuJX77q6NCTl6PQKPNukLDI9fKeykri4z112Xm087bM=;
	h=Date:To:From:Subject:Message-Id; b=h7ACxMYSnzn7cUrMBKjJLqUbl8oRqfpuAm6yPHOk2OyOg1ssgffVNA1H2cXRlfp16MAUGgA7/0LveJHtbLINPUyx71lW6BEl15p+/fVdSBdSyqUjOGJJMuhcGusuFvbivFhUUS3+LsDRwzzGy1e2I+9N4DfQuj6G/npg92DXrDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RUTbDmxE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RUTbDmxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFFEC116C6;
	Tue, 27 Jan 2026 04:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486672;
	bh=cuJX77q6NCTl6PQKPNukLDI9fKeykri4z112Xm087bM=;
	h=Date:To:From:Subject:From;
	b=RUTbDmxEh8ed4y6ITH4YtqXk5A1Wna5REA+DJouxg/3hRY+Tazgn5NsbeG5OgKEQh
	 NfwBaopfXdzWRx/wZY5IPNwSxIEBLGH+79nvtTNMao8oJ2Nonl/jeL6PINQn8ZfAEj
	 MNgMM6T7Rhj23mUk0As37X0X70DU0fA2rV1JjXQ0=
Date: Mon, 26 Jan 2026 20:04:31 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,surenb@google.com,rppt@kernel.org,rientjes@google.com,pfalcato@suse.de,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-simplify-__alloc_pages_slowpath-flow.patch removed from -mm tree
Message-Id: <20260127040432.5AFFEC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: simplify __alloc_pages_slowpath() flow
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-simplify-__alloc_pages_slowpath-flow.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/page_alloc: simplify __alloc_pages_slowpath() flow
Date: Tue, 06 Jan 2026 12:52:38 +0100

The actions done before entering the main retry loop include waking up
kswapds and an allocation attempt with the precise alloc_flags.  Then in
the loop we keep waking up kswapds, and we retry the allocation with flags
potentially further adjusted by being allowed to use reserves (due to e.g.
becoming an OOM killer victim).

We can adjust the retry loop to keep only one instance of waking up
kswapds and allocation attempt.  Introduce the can_retry_reserves variable
for retrying once when we become eligible for reserves.  It is still
useful not to evaluate reserve_flags immediately for the first allocation
attempt, because it's better to first try succeed in a non-preferred zone
above the min watermark before allocating immediately from the preferred
zone below min watermark.

Additionally move the cpuset update checks introduced by e05741fb10c3
("mm/page_alloc.c: avoid infinite retries caused by cpuset race") further
down the retry loop.  It's enough to do the checks only before reaching
any potentially infinite 'goto retry;' loop.

There should be no meaningful functional changes.  The change of exact
moments the retry for reserves and cpuset updates are checked should not
result in different outomes modulo races with concurrent allocator
activity.

Link: https://lkml.kernel.org/r/20260106-thp-thisnode-tweak-v3-3-f5d67c21a193@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-simplify-__alloc_pages_slowpath-flow
+++ a/mm/page_alloc.c
@@ -4708,6 +4708,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	unsigned int zonelist_iter_cookie;
 	int reserve_flags;
 	bool compact_first = false;
+	bool can_retry_reserves = true;
 
 	if (unlikely(nofail)) {
 		/*
@@ -4775,6 +4776,8 @@ restart:
 			goto nopage;
 	}
 
+retry:
+	/* Ensure kswapd doesn't accidentally go to sleep as long as we loop */
 	if (alloc_flags & ALLOC_KSWAPD)
 		wake_all_kswapds(order, gfp_mask, ac);
 
@@ -4786,19 +4789,6 @@ restart:
 	if (page)
 		goto got_pg;
 
-retry:
-	/*
-	 * Deal with possible cpuset update races or zonelist updates to avoid
-	 * infinite retries.
-	 */
-	if (check_retry_cpuset(cpuset_mems_cookie, ac) ||
-	    check_retry_zonelist(zonelist_iter_cookie))
-		goto restart;
-
-	/* Ensure kswapd doesn't accidentally go to sleep as long as we loop */
-	if (alloc_flags & ALLOC_KSWAPD)
-		wake_all_kswapds(order, gfp_mask, ac);
-
 	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
 	if (reserve_flags)
 		alloc_flags = gfp_to_alloc_flags_cma(gfp_mask, reserve_flags) |
@@ -4813,12 +4803,18 @@ retry:
 		ac->nodemask = NULL;
 		ac->preferred_zoneref = first_zones_zonelist(ac->zonelist,
 					ac->highest_zoneidx, ac->nodemask);
-	}
 
-	/* Attempt with potentially adjusted zonelist and alloc_flags */
-	page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac);
-	if (page)
-		goto got_pg;
+		/*
+		 * The first time we adjust anything due to being allowed to
+		 * ignore memory policies or watermarks, retry immediately. This
+		 * allows us to keep the first allocation attempt optimistic so
+		 * it can succeed in a zone that is still above watermarks.
+		 */
+		if (can_retry_reserves) {
+			can_retry_reserves = false;
+			goto retry;
+		}
+	}
 
 	/* Caller is not willing to reclaim, we can't balance anything */
 	if (!can_direct_reclaim)
@@ -4881,6 +4877,15 @@ retry:
 			     !(gfp_mask & __GFP_RETRY_MAYFAIL)))
 		goto nopage;
 
+	/*
+	 * Deal with possible cpuset update races or zonelist updates to avoid
+	 * infinite retries. No "goto retry;" can be placed above this check
+	 * unless it can execute just once.
+	 */
+	if (check_retry_cpuset(cpuset_mems_cookie, ac) ||
+	    check_retry_zonelist(zonelist_iter_cookie))
+		goto restart;
+
 	if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
 				 did_some_progress > 0, &no_progress_loops))
 		goto retry;
_

Patches currently in -mm which might be from vbabka@suse.cz are


