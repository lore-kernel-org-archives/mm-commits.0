Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087CE367B60
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622900; cv=none; b=HUfk3ocz2RcRLPSvqZMIUSNWFT/LkHS3SxKoEou92wqbkuFTrZUe7Xgo9PLSwzl3FG9CBPd2Y/vZqyK/i5xmkNK37E+InRLboLQ8g9Y4+plIQBNs0R5AiocLk6QKUiMvyf5trV/MsXxJyfq/vIKu+uX7G5rFjMMnqSJQNFqA4tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622900; c=relaxed/simple;
	bh=P1u9XHH+6d0up9bKHHGdgMcVJ3Aiu1JGh6y3nTfIZwI=;
	h=Date:To:From:Subject:Message-Id; b=pAA5vdaWJZ825t/zJk4Ng/y0qoCZ7ss0z09om1h2eLFbmDLOl2NkpyuT4tNBhaqRa5cl2nZIIl41Q26dFnE0PxKDTkFBhqqs0JvNX21+lyF2IEbylz0NZxwxj+AtcLuvpXMKFdI9nDDDhYrRBpi2Pg+p2NYZyNK2ZHMVYeCu2J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UiEIpfmH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UiEIpfmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43661F000E9;
	Tue, 25 Aug 2026 01:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622897;
	bh=2xWoGzCNks4vK2yBNwWa8BraGDgKxFZxC2ZEQmqfoFk=;
	h=Date:To:From:Subject;
	b=UiEIpfmHnsAfFylBp5DAvklxaDePj/MwdSbo7Z8vKD+OZihL5pnNgYxgap51RF9KH
	 9i1dSNNDdl2Up0RBHksqMs8lIBjCP0e+65xeVAo9XpIpeIitHlPVxagg9cPix0xdUB
	 GB8IOZ08DJKgh+55NhRiNAJR/xREfNEDVadOSn0s=
Date: Mon, 24 Aug 2026 18:54:57 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,souravpanda@google.com,shakeel.butt@linux.dev,nphamcs@gmail.com,hawk@kernel.org,hannes@cmpxchg.org,chengming.zhou@linux.dev,yunzhao@cloudflare.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-use-ratelimited-stats-flush-in-zswap_shrinker_count.patch removed from -mm tree
Message-Id: <20260825015457.D43661F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: use ratelimited stats flush in zswap_shrinker_count()
has been removed from the -mm tree.  Its filename was
     mm-zswap-use-ratelimited-stats-flush-in-zswap_shrinker_count.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yunzhao Li <yunzhao@cloudflare.com>
Subject: mm/zswap: use ratelimited stats flush in zswap_shrinker_count()
Date: Thu, 2 Jul 2026 11:07:35 -0700

zswap_shrinker_count() calls mem_cgroup_flush_stats(), which takes the
global cgroup rstat lock synchronously.  On machines with many CPUs and
NUMA nodes, this creates severe lock contention in the kswapd reclaim
path:

  - Multiple kswapd threads (one per NUMA node) run concurrently.
  - do_shrink_slab() invokes zswap_shrinker_count() for each
    memcg-aware shrinker pass.
  - Each call flushes the full cgroup rstat hierarchy under the global
    lock.

On AMD EPYC 9684X machines (96 cores, 192 threads, 12 NUMA nodes) running
production workloads with zswap enabled, perf shows 2.88% of kernel cycles
in osq_lock contention from this path:

     2.88%  [k] osq_lock
              --__mutex_lock.constprop.0
                  --__cgroup_rstat_lock
                      --cgroup_rstat_flush_locked
                          --cgroup_rstat_flush
                              --zswap_shrinker_count
                                  do_shrink_slab
                                  shrink_slab
                                  shrink_node
                                  balance_pgdat
                                  kswapd

84% of kswapd kernel cycles are spent in
shrink_slab -> zswap_shrinker_count -> cgroup_rstat_flush, not in actual
page reclaim (shrink_lruvec).

Controlled A/B on identical hardware and workload:

  shrinker=Y: 2.88% osq_lock, memory PSI 1.58%
  shrinker=N: 0.00% osq_lock, memory PSI 0.57%

eBPF-based rstat lock wait measurement across 8 production metals
confirms the contention splits cleanly along shrinker enablement:

  shrinker=Y: 50-250x more contended lock acquisitions (248/s vs 1.1/s)
  shrinker=N: baseline lock wait (0.0017 s/s vs 1.04 s/s)

zswap_shrinker_count() only produces a heuristic estimate, scaled by
compression ratio via mult_frac(). The actual writeback happens in
zswap_shrinker_scan(). Slightly stale stats are acceptable here.

Switch to mem_cgroup_flush_stats_ratelimited(), which only flushes if
the periodic 2-second flusher is one full cycle late. This matches the
approach already used in prepare_scan_control() (mm/vmscan.c) for the
same reclaim path.

After applying this patch, rstat flush latency and lock wait time on
shrinker=Y machines dropped to the same level as shrinker=N controls,
while the zswap shrinker continues to function (pool size remains
bounded under the max_pool_percent cap).

Previously discussed:
  - Chengming Zhou (Dec 2023): rstat contention from
    zswap_shrinker_count [1]
  - Shakeel Butt (Aug 2024): zswap_shrinker_count still uses sync
    flush [2]
  - Yosry Ahmed (Aug 2024): suggested eliminating in-kernel
    flushers [3]
  - Jesper Dangaard Brouer (Sep 2024): cgroup/rstat V11 patch [4]

Link: https://lore.kernel.org/20260702180908.150136-1-yunzhao@cloudflare.com
Link: https://lore.kernel.org/linux-mm/20231206103935.3440502-1-zhouchengming@bytedance.com/ [1]
Link: https://lore.kernel.org/linux-mm/CALvZod7LFxLCxVpOFH8b2Ppm8T40HPGMKQwX_=NPCWB_mFW+oQ@mail.gmail.com/ [2]
Link: https://lore.kernel.org/linux-mm/CAJD7tkYvFyOSX+rP_FKGBhxvZiCDxtpsNp-c5CGOA-4Bq9oXSg@mail.gmail.com/ [3]
Link: https://lore.kernel.org/linux-mm/172616070094.2055617.17676042522679701515.stgit@firesoul/ [4]
Suggested-by: Jesper Dangaard Brouer <hawk@kernel.org>
Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
Signed-off-by: Yunzhao Li <yunzhao@cloudflare.com>
Tested-by: Yunzhao Li <yunzhao@cloudflare.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Yunzhao Li <yunzhao@cloudflare.com>
Cc: Sourav Panda <souravpanda@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-use-ratelimited-stats-flush-in-zswap_shrinker_count
+++ a/mm/zswap.c
@@ -1219,7 +1219,7 @@ static unsigned long zswap_shrinker_coun
 	 * Without memcg, use the zswap pool-wide metrics.
 	 */
 	if (!mem_cgroup_disabled()) {
-		mem_cgroup_flush_stats(memcg);
+		mem_cgroup_flush_stats_ratelimited(memcg);
 		nr_backing = memcg_page_state(memcg, MEMCG_ZSWAP_B) >> PAGE_SHIFT;
 		nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED);
 	} else {
_

Patches currently in -mm which might be from yunzhao@cloudflare.com are


