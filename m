Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EA73A257A
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 21:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783027677; cv=none; b=tTpcYQyZM8QzzNWAACEIfsBpyTErv2Ee28IYoJHp+r+vn61ZcZN9wyNLFatNi2qM460t9ee6mtoBoxxEt8/ZKCMgY9Uciz/Ryt+UQfOAB0YJ7zjWZHrFwPc3t9tuT9/cqHTtAPPUfKGY/D5p3Vj55SxQFHDmTPPRMlvLkGuZctU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783027677; c=relaxed/simple;
	bh=vjbAdDWRz7zs0yAOGO6te7Z5a8ZHQU9tl9zVwv1ZTIU=;
	h=Date:To:From:Subject:Message-Id; b=il1DlEKQLNqigigfWAuqkJ8P9LBkS0Imt8hrZlNwTkkmmc41jcxVJvss2bAnuu9Mr9XFq3z42920DMGauufE4tld34M8ropHudZKftMgL62N4NjiFq8YDko+1BGXTWTyTik7q0ZFhNJmFTkjaS7WRGHbAoH9+KHE8pUiwJ2oLOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qsrV2Ifx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qsrV2Ifx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2761F000E9;
	Thu,  2 Jul 2026 21:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783027676;
	bh=70li3Ab8d/gl/LH4BymOLcr/hMB+goMLQmhTjbhmWMw=;
	h=Date:To:From:Subject;
	b=qsrV2IfxNvWjVpS3lDLUauI355fTjv7uxfCw+ht0n0gefu4EgbdnYCTc86Y5TUtI2
	 EyaY/eqwoctQbqZA2J0eaWt/ayP6AZ45nCCzNBEymkx8P7xJe603Et4gal3l8o61we
	 kN0CvAgt3JdW/qZjv7CbsynP+C7LtWYiSluPzMHI=
Date: Thu, 02 Jul 2026 14:27:55 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,souravpanda@google.com,shakeel.butt@linux.dev,nphamcs@gmail.com,hawk@kernel.org,hannes@cmpxchg.org,chengming.zhou@linux.dev,yunzhao@cloudflare.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-use-ratelimited-stats-flush-in-zswap_shrinker_count.patch added to mm-new branch
Message-Id: <20260702212756.3D2761F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: use ratelimited stats flush in zswap_shrinker_count()
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-use-ratelimited-stats-flush-in-zswap_shrinker_count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-use-ratelimited-stats-flush-in-zswap_shrinker_count.patch

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
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
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
@@ -1217,7 +1217,7 @@ static unsigned long zswap_shrinker_coun
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

mm-zswap-use-ratelimited-stats-flush-in-zswap_shrinker_count.patch

