Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488081A3BBD
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 23:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723590946; cv=none; b=isWHJTTfiAaWsDkwmKtH4Y48YbJTIn3vXrla3IFE1X/ezPzOw7PrtsO7EyqB8G5zC46YhSuSxv2Y+VUr2QO96yQ30JxYOTUKr30ytgBiF7ajAsOz3cPeqTO2Fr43zz/1H7J57cKF3Hems0H2mAkU8w50wgaZsrAkzl/vp9zLVYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723590946; c=relaxed/simple;
	bh=NJ0twrMDOWhk3TPWgLuFbKNJdlJfRpz7NDY+6T00uLI=;
	h=Date:To:From:Subject:Message-Id; b=a5XHKjm5ghkMEwp9XfuAUWt+aPyRvIR+7DDziJteQsGvH6V6fdsl8LcmcHagSxArKJSeluP45v64hmg8NuV6zhZsSR2gcjitp7awmFYwyJihAv6b0NgaWSdP5BNuoP0EFHCWkz8I4qjjDnxbmMx5yxFnJnVUW4kk56q8xny01p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FAoYkKYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FAoYkKYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC16C32782;
	Tue, 13 Aug 2024 23:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723590945;
	bh=NJ0twrMDOWhk3TPWgLuFbKNJdlJfRpz7NDY+6T00uLI=;
	h=Date:To:From:Subject:From;
	b=FAoYkKYhcb1VqY66JS04ZdQwD7dgMbXAaGUinV54K7w+9aObwEzK9qSy3SNz429s9
	 QSxutsRlboWD6hTKLV8dhQJjwcKUOXxfJ0NpiQ0RUbc5oICxT9a7HvMNwUva5gTjWQ
	 NqDusBBf1+WiyqKYKJmmIfY9o1IwXRya1ZtTKez4=
Date: Tue, 13 Aug 2024 16:15:44 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hawk@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-use-ratelimited-stats-flush-in-the-reclaim.patch added to mm-unstable branch
Message-Id: <20240813231545.8FC16C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: use ratelimited stats flush in the reclaim
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-use-ratelimited-stats-flush-in-the-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-use-ratelimited-stats-flush-in-the-reclaim.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: use ratelimited stats flush in the reclaim
Date: Tue, 13 Aug 2024 14:53:58 -0700

The Meta prod is seeing large amount of stalls in memcg stats flush from
the memcg reclaim code path.  At the moment, this specific callsite is
doing a synchronous memcg stats flush.  The rstat flush is an expensive
and time consuming operation, so concurrent relaimers will busywait on the
lock potentially for a long time.  Actually this issue is not unique to
Meta and has been observed by Cloudflare [1] as well.  For the Cloudflare
case, the stalls were due to contention between kswapd threads running on
their 8 numa node machines which does not make sense as rstat flush is
global and flush from one kswapd thread should be sufficient for all. 
Simply replace the synchronous flush with the ratelimited one.

One may raise a concern on potentially using 2 sec stale (at worst) stats
for heuristics like desirable inactive:active ratio and preferring
inactive file pages over anon pages but these specific heuristics do not
require very precise stats and also are ignored under severe memory
pressure.

More specifically for this code path, the stats are needed for two
specific heuristics:

1. Deactivate LRUs
2. Cache trim mode

The deactivate LRUs heuristic is to maintain a desirable inactive:active
ratio of the LRUs.  The specific stats needed are WORKINGSET_ACTIVATE* and
the hierarchical LRU size.  The WORKINGSET_ACTIVATE* is needed to check if
there is a refault since last snapshot and the LRU size are needed for the
desirable ratio between inactive and active LRUs.  See the table below on
how the desirable ratio is calculated.

/* total     target    max
 * memory    ratio     inactive
 * -------------------------------------
 *   10MB       1         5MB
 *  100MB       1        50MB
 *    1GB       3       250MB
 *   10GB      10       0.9GB
 *  100GB      31         3GB
 *    1TB     101        10GB
 *   10TB     320        32GB
 */

The desirable ratio only changes at the boundary of 1 GiB, 10 GiB, 100
GiB, 1 TiB and 10 TiB.  There is no need for the precise and accurate LRU
size information to calculate this ratio.  In addition, if deactivation is
skipped for some LRU, the kernel will force deactive on the severe memory
pressure situation.

For the cache trim mode, inactive file LRU size is read and the kernel
scales it down based on the reclaim iteration (file >> sc->priority) and
only checks if it is zero or not.  Again precise information is not
needed.

This patch has been running on Meta fleet for several months and we have
not observed any issues.  Please note that MGLRU is not impacted by this
issue at all as it avoids rstat flushing completely.

Link: https://lore.kernel.org/all/6ee2518b-81dd-4082-bdf5-322883895ffc@kernel.org [1]
Link: https://lkml.kernel.org/r/20240813215358.2259750-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~memcg-use-ratelimited-stats-flush-in-the-reclaim
+++ a/mm/vmscan.c
@@ -2283,10 +2283,11 @@ static void prepare_scan_control(pg_data
 	target_lruvec = mem_cgroup_lruvec(sc->target_mem_cgroup, pgdat);
 
 	/*
-	 * Flush the memory cgroup stats, so that we read accurate per-memcg
-	 * lruvec stats for heuristics.
+	 * Flush the memory cgroup stats in rate-limited way as we don't need
+	 * most accurate stats here. We may switch to regular stats flushing
+	 * in the future once it is cheap enough.
 	 */
-	mem_cgroup_flush_stats(sc->target_mem_cgroup);
+	mem_cgroup_flush_stats_ratelimited(sc->target_mem_cgroup);
 
 	/*
 	 * Determine the scan balance between anon and file LRUs.
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-increase-the-valid-index-range-for-memcg-stats.patch
memcg-replace-memcg-id-idr-with-xarray.patch
memcg-use-ratelimited-stats-flush-in-the-reclaim.patch

