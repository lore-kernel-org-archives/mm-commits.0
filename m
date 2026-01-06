Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CF9340263
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 18:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722872; cv=none; b=YU+499JmgF1odhuYBD89ATfhKqYV1MWVY5BMh/y6/0P1iVgjjEJ3IqGUYxFmE0vP0f/0Wfs8UmkD0stHmYMXbBf9tulfy4Nw3qX1eFAxYfSrMXktJnpyutv/eZY6r0Qipq1K1nXpPFWJQXq/5kNkBBPbmSquvhP6l1VUdIyKjSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722872; c=relaxed/simple;
	bh=XQ4UpHczerWM7NGQlaluLiSVGo4Y4V5KBrvaZ+7h5aU=;
	h=Date:To:From:Subject:Message-Id; b=nUMzBinRm8ViZbwMFWOcIlNCPFLDfh9JOorfRdcgTviiuBXGVIcjoSkeY5n1g4k+hVj/1AxtZpyQ/fiqok3EfhcdNCqAQSZFyBo+DyvUHQrucuLmJxiz/dKqEs/EUQQ/kNfoHUZS0GVmLPrVrRLwuuv/ShjxJMktWC0rWQ2dQg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sTmEmiWk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sTmEmiWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8361BC116C6;
	Tue,  6 Jan 2026 18:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767722872;
	bh=XQ4UpHczerWM7NGQlaluLiSVGo4Y4V5KBrvaZ+7h5aU=;
	h=Date:To:From:Subject:From;
	b=sTmEmiWkQZNlixL2vA7rl5S0S8bjUoRWLqsxzULEAwONX2/kb81cFyKmaHqv8UW3l
	 lz3xZ8RXkq+b1eoVtWqpjIcw6rZiDpvIt+/rAQL+zb67Jo9oNIAKYzyA1xbcEtOKoV
	 u4KfYAYtl94SZIPXKElTOVTvW+0Wchn8H6yRXozs=
Date: Tue, 06 Jan 2026 10:07:51 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,surenb@google.com,rppt@kernel.org,rientjes@google.com,pfalcato@suse.de,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-simplify-__alloc_pages_slowpath-flow.patch added to mm-new branch
Message-Id: <20260106180752.8361BC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: simplify __alloc_pages_slowpath() flow
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-simplify-__alloc_pages_slowpath-flow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-simplify-__alloc_pages_slowpath-flow.patch

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
@@ -4716,6 +4716,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	unsigned int zonelist_iter_cookie;
 	int reserve_flags;
 	bool compact_first = false;
+	bool can_retry_reserves = true;
 
 	if (unlikely(nofail)) {
 		/*
@@ -4783,6 +4784,8 @@ restart:
 			goto nopage;
 	}
 
+retry:
+	/* Ensure kswapd doesn't accidentally go to sleep as long as we loop */
 	if (alloc_flags & ALLOC_KSWAPD)
 		wake_all_kswapds(order, gfp_mask, ac);
 
@@ -4794,19 +4797,6 @@ restart:
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
@@ -4821,12 +4811,18 @@ retry:
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
@@ -4889,6 +4885,15 @@ retry:
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

mm-page_alloc-prevent-pcp-corruption-with-smp=n.patch
mm-page_alloc-thp-prevent-reclaim-for-__gfp_thisnode-thp-allocations.patch
mm-page_alloc-ignore-the-exact-initial-compaction-result.patch
mm-page_alloc-refactor-the-initial-compaction-handling.patch
mm-page_alloc-simplify-__alloc_pages_slowpath-flow.patch

