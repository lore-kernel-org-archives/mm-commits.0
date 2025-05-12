Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC97C2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011125; cv=none; b=faR55HQlm3NRbmNXEZNU1mQ7V03AJzYp7YXjcA+ezq1LNjnpY1WcJFJXclHEvqf7qJnkI1yvfWlmO0gFj2GQAUp7rN0YYBUFcSd0RNMv55KXT8uHPUd5Sqlfz5l+lRQsjSD55rN3Yn7b6JV9vZKeuIV1r1FOiRsMwWkF5iObTow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011125; c=relaxed/simple;
	bh=j+VPuwQYFooO9BG4DeGSlKmbgUxg/2Q6QkrbTb2mv88=;
	h=Date:To:From:Subject:Message-Id; b=LLYrURWIx9SI2cxoz8bl9mGaV7PXSm1/lbXCrWKv6VNLhBW1JzGlCNJoiSsznAz3gYNl4ov2wYmSkVagZGZbjHa/3dNfYC6mWgWJbyyGfVlGKTL+U++tEs4bO6bjat+1igiSdz1PRNnGB2vPb5DalrQbnAb9fLsTi+mG+kN5810=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aKkXYzwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aKkXYzwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1910C4CEE4;
	Mon, 12 May 2025 00:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011125;
	bh=j+VPuwQYFooO9BG4DeGSlKmbgUxg/2Q6QkrbTb2mv88=;
	h=Date:To:From:Subject:From;
	b=aKkXYzwFaVih+N+aBWp5XTeCeojtBoYAJ492H1Sj8TlbkI0sgm4r4+5zC68tSYa7c
	 ValJcTvI/GssC3U27aH0R1Cc5CeCfKOZWOvVHwlUave7v9Wscot2NvGHLhf2Qs5bPd
	 DKTzHsHYIAPCyRodyXPKGVwRHo+1VfaAe/3Gfczo=
Date: Sun, 11 May 2025 17:52:05 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-optimize-memcg_rstat_updated.patch removed from -mm tree
Message-Id: <20250512005205.B1910C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: optimize memcg_rstat_updated
has been removed from the -mm tree.  Its filename was
     memcg-optimize-memcg_rstat_updated.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: optimize memcg_rstat_updated
Date: Wed, 9 Apr 2025 19:57:52 -0700

Currently the kernel maintains the stats updates per-memcg which is needed
to implement stats flushing threshold.  On the update side, the update is
added to the per-cpu per-memcg update of the given memcg and all of its
ancestors.  However when the given memcg has passed the flushing
threshold, all of its ancestors should have passed the threshold as well. 
There is no need to traverse up the memcg tree to maintain the stats
updates.

Perf profile collected from our fleet shows that memcg_rstat_updated is
one of the most expensive memcg function i.e.  a lot of cumulative CPU is
being spent on it.  So, even small micro optimizations matter a lot.  This
patch is microbenchmarked with multiple instances of netperf on a single
machine with locally running netserver and we see couple of percentage of
improvement.

Link: https://lkml.kernel.org/r/20250410025752.92159-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c~memcg-optimize-memcg_rstat_updated
+++ a/mm/memcontrol.c
@@ -592,18 +592,20 @@ static inline void memcg_rstat_updated(s
 	cgroup_rstat_updated(memcg->css.cgroup, cpu);
 	statc = this_cpu_ptr(memcg->vmstats_percpu);
 	for (; statc; statc = statc->parent) {
+		/*
+		 * If @memcg is already flushable then all its ancestors are
+		 * flushable as well and also there is no need to increase
+		 * stats_updates.
+		 */
+		if (memcg_vmstats_needs_flush(statc->vmstats))
+			break;
+
 		stats_updates = READ_ONCE(statc->stats_updates) + abs(val);
 		WRITE_ONCE(statc->stats_updates, stats_updates);
 		if (stats_updates < MEMCG_CHARGE_BATCH)
 			continue;
 
-		/*
-		 * If @memcg is already flush-able, increasing stats_updates is
-		 * redundant. Avoid the overhead of the atomic update.
-		 */
-		if (!memcg_vmstats_needs_flush(statc->vmstats))
-			atomic64_add(stats_updates,
-				     &statc->vmstats->stats_updates);
+		atomic64_add(stats_updates, &statc->vmstats->stats_updates);
 		WRITE_ONCE(statc->stats_updates, 0);
 	}
 }
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-introduce-non-blocking-limit-setting-option.patch
memcg-introduce-non-blocking-limit-setting-option-v3.patch
memcg-simplify-consume_stock.patch
memcg-separate-local_trylock-for-memcg-and-obj.patch
memcg-completely-decouple-memcg-and-obj-stocks.patch
memcg-no-irq-disable-for-memcg-stock-lock.patch

