Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0368C5FB8D
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247820; cv=none; b=Uq3dmonx2/3/03Ht7gv+s22/nnRo6GiK7zIrJ6478jx6k/+60kBKoVDJAIWf2JALWh544fvNDGTgTPnNlkykF47W/1+TRmypf0E05JHQbgXqfmWU86Qa1G40bnyh+aEWARAVMlWeFekK++a78JFspalqvjoY/3BqUSMUST3/X8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247820; c=relaxed/simple;
	bh=M0ASFF9jC2eJyZrmqcoiFPM/aQ9yqi1efi2K39DGl+M=;
	h=Date:To:From:Subject:Message-Id; b=gDZX7j0b7NQz4NBK613cNH3DYH/QF69YetWDJGLxyd8f5ld3xNS26AGytURGOyEpHWWwPpiLj3xYU5kQfsFEfJ2bjk1oMW6xR4CvAe6CG1C4M+t1j6G+wsp02drA0f+jLfHmNx+OhznZHp3umf8fi+5I09J4LP8Nx0dZ3qDH5Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FNl12XkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FNl12XkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D10C4CEC2;
	Mon,  2 Sep 2024 03:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247819;
	bh=M0ASFF9jC2eJyZrmqcoiFPM/aQ9yqi1efi2K39DGl+M=;
	h=Date:To:From:Subject:From;
	b=FNl12XkLihyK7mR/oAS3E749Cqd7IsiE+n2tTvHBlxzOqAf5w9MF7LqS2zRfxSlDP
	 GYCXVxGmBS+rO+/WhWXO6bQN/3Q7qI+5B3X+j8X59/Z8ppLBwepI7ost+V08egtd3B
	 MJ+AFjqDIfhQc/5oNchA/mWoikNbxiyEaKBlVnEo=
Date: Sun, 01 Sep 2024 20:30:19 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,hawk@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-use-ratelimited-stats-flush-in-the-reclaim.patch removed from -mm tree
Message-Id: <20240902033019.C7D10C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: use ratelimited stats flush in the reclaim
has been removed from the -mm tree.  Its filename was
     memcg-use-ratelimited-stats-flush-in-the-reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~memcg-use-ratelimited-stats-flush-in-the-reclaim
+++ a/mm/vmscan.c
@@ -2264,10 +2264,11 @@ static void prepare_scan_control(pg_data
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


