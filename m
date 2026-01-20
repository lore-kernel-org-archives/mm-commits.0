Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D396F3A4F24
	for <mm-commits@vger.kernel.org>; Tue, 20 Jan 2026 20:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768941071; cv=none; b=YBo3Y9SkGqVNSsO2WL21+gSA2b6v+kYXf6r9ZDJleNJgvs4MqlTKim4NR+Ej4VTJ7BldeIJe9vRg1TXqoY/LZABO8gKXb+HPlZFfLwlu2kMgz8p6g9A0XNjspqD4g36pgu26KdPmskEdPKDRzoCx1zBy8BplnyaMHrF/vQZtXv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768941071; c=relaxed/simple;
	bh=1Q8wl6ppXik1+QAzEoPaMlZ7G1KZj63QRJLLvgtcYmY=;
	h=Date:To:From:Subject:Message-Id; b=tf72aYXTwOBe2gfPi83rTQP5o3R0aUBMF9BOcd5xPsigX3gTjvUe7LHV+INZOiunKt6T3VBgqhFXZVV9Hhk9j2njKWbRCW35DYZM2bIBm++luzp+gQXq1JbU9KfUXFZHPMWr0hmQmP4FJ+fsDYUF2zJCQXe20hpEUs918+woz04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZcKvucwu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZcKvucwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429A4C16AAE;
	Tue, 20 Jan 2026 20:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768941071;
	bh=1Q8wl6ppXik1+QAzEoPaMlZ7G1KZj63QRJLLvgtcYmY=;
	h=Date:To:From:Subject:From;
	b=ZcKvucwuHwxx3voml4kr7PMU/PJgyuiAwmqY80WILG20ORN4DRKuj3HdaSKkU9ivG
	 WeXQWadjvcFsD7Kd/T6zoGKhUjzh++Co/nIZPzP5svtwsPeRipAr1FyR/kVZgXZBjy
	 bE7LdCGDUWaAux4GLAkMsNWFFmSEdj+s+d91zMaA=
Date: Tue, 20 Jan 2026 12:31:10 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jiayuan.chen@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,jiayuan.chen@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-mitigate-spurious-kswapd_failures-reset-from-direct-reclaim.patch added to mm-unstable branch
Message-Id: <20260120203111.429A4C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: mitigate spurious kswapd_failures reset from direct reclaim
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-mitigate-spurious-kswapd_failures-reset-from-direct-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-mitigate-spurious-kswapd_failures-reset-from-direct-reclaim.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Jiayuan Chen <jiayuan.chen@shopee.com>
Subject: mm/vmscan: mitigate spurious kswapd_failures reset from direct reclaim
Date: Tue, 20 Jan 2026 10:43:48 +0800

Patch series "mm/vmscan: add tracepoint and reason for kswapd_failures
reset", v4.

Currently, kswapd_failures is reset in multiple places (kswapd,
direct reclaim, PCP freeing, memory-tiers), but there's no way to
trace when and why it was reset, making it difficult to debug
memory reclaim issues.

This patch:

1. Introduce kswapd_clear_hopeless() as a wrapper function to
   centralize kswapd_failures reset logic.

2. Introduce kswapd_test_hopeless() to encapsulate hopeless node
   checks, replacing all open-coded kswapd_failures comparisons.

3. Add kswapd_clear_hopeless_reason enum to distinguish reset sources:
   - KSWAPD_CLEAR_HOPELESS_KSWAPD: reset from kswapd context
   - KSWAPD_CLEAR_HOPELESS_DIRECT: reset from direct reclaim
   - KSWAPD_CLEAR_HOPELESS_PCP: reset from PCP page freeing
   - KSWAPD_CLEAR_HOPELESS_OTHER: reset from other paths

4. Add tracepoints for better observability:
   - mm_vmscan_kswapd_clear_hopeless: traces each reset with reason
   - mm_vmscan_kswapd_reclaim_fail: traces each kswapd reclaim failure

Test results:

$ trace-cmd record -e vmscan:mm_vmscan_kswapd_clear_hopeless -e vmscan:mm_vmscan_kswapd_reclaim_fail
$ # generate memory pressure
$ trace-cmd report
cpus=4
 kswapd0-71    [000]    27.216563: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=1
 kswapd0-71    [000]    27.217169: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=2
 kswapd0-71    [000]    27.217764: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=3
 kswapd0-71    [000]    27.218353: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=4
 kswapd0-71    [000]    27.218993: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=5
 kswapd0-71    [000]    27.219744: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=6
 kswapd0-71    [000]    27.220488: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=7
 kswapd0-71    [000]    27.221206: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=8
 kswapd0-71    [000]    27.221806: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=9
 kswapd0-71    [000]    27.222634: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=10
 kswapd0-71    [000]    27.223286: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=11
 kswapd0-71    [000]    27.223894: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=12
 kswapd0-71    [000]    27.224712: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=13
 kswapd0-71    [000]    27.225424: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=14
 kswapd0-71    [000]    27.226082: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=15
 kswapd0-71    [000]    27.226810: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=16
 kswapd1-72    [002]    27.386869: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=1
 kswapd1-72    [002]    27.387435: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=2
 kswapd1-72    [002]    27.388016: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=3
 kswapd1-72    [002]    27.388586: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=4
 kswapd1-72    [002]    27.389155: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=5
 kswapd1-72    [002]    27.389723: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=6
 kswapd1-72    [002]    27.390292: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=7
 kswapd1-72    [002]    27.392364: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=8
 kswapd1-72    [002]    27.392934: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=9
 kswapd1-72    [002]    27.393504: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=10
 kswapd1-72    [002]    27.394073: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=11
 kswapd1-72    [002]    27.394899: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=12
 kswapd1-72    [002]    27.395472: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=13
 kswapd1-72    [002]    27.396055: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=14
 kswapd1-72    [002]    27.396628: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=15
 kswapd1-72    [002]    27.397199: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=16
kworker/u18:0-40    [002]    27.410151: mm_vmscan_kswapd_clear_hopeless: nid=0 reason=DIRECT
 kswapd0-71    [000]    27.439454: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=1
 kswapd0-71    [000]    27.440048: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=2
 kswapd0-71    [000]    27.440634: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=3
 kswapd0-71    [000]    27.441211: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=4
 kswapd0-71    [000]    27.441787: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=5
 kswapd0-71    [000]    27.442363: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=6
 kswapd0-71    [000]    27.443030: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=7
 kswapd0-71    [000]    27.443725: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=8
 kswapd0-71    [000]    27.444315: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=9
 kswapd0-71    [000]    27.444898: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=10
 kswapd0-71    [000]    27.445476: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=11
 kswapd0-71    [000]    27.446053: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=12
 kswapd0-71    [000]    27.446646: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=13
 kswapd0-71    [000]    27.447230: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=14
 kswapd0-71    [000]    27.447812: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=15
 kswapd0-71    [000]    27.448391: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=16
 ann-423   [003]    28.028285: mm_vmscan_kswapd_clear_hopeless: nid=0 reason=PCP


This patch (of 2):

When kswapd fails to reclaim memory, kswapd_failures is incremented.  Once
it reaches MAX_RECLAIM_RETRIES, kswapd stops running to avoid futile
reclaim attempts.  However, any successful direct reclaim unconditionally
resets kswapd_failures to 0, which can cause problems.

We observed an issue in production on a multi-NUMA system where a process
allocated large amounts of anonymous pages on a single NUMA node, causing
its watermark to drop below high and evicting most file pages:

$ numastat -m
Per-node system memory usage (in MBs):
                          Node 0          Node 1           Total
                 --------------- --------------- ---------------
MemTotal               128222.19       127983.91       256206.11
MemFree                  1414.48         1432.80         2847.29
MemUsed                126807.71       126551.11       252358.82
SwapCached                  0.00            0.00            0.00
Active                  29017.91        25554.57        54572.48
Inactive                92749.06        95377.00       188126.06
Active(anon)            28998.96        23356.47        52355.43
Inactive(anon)          92685.27        87466.11       180151.39
Active(file)               18.95         2198.10         2217.05
Inactive(file)             63.79         7910.89         7974.68

With swap disabled, only file pages can be reclaimed.  When kswapd is
woken (e.g., via wake_all_kswapds()), it runs continuously but cannot
raise free memory above the high watermark since reclaimable file pages
are insufficient.  Normally, kswapd would eventually stop after
kswapd_failures reaches MAX_RECLAIM_RETRIES.

However, containers on this machine have memory.high set in their cgroup. 
Business processes continuously trigger the high limit, causing frequent
direct reclaim that keeps resetting kswapd_failures to 0.  This prevents
kswapd from ever stopping.

The key insight is that direct reclaim triggered by cgroup memory.high
performs aggressive scanning to throttle the allocating process.  With
sufficiently aggressive scanning, even hot pages will eventually be
reclaimed, making direct reclaim "successful" at freeing some memory. 
However, this success does not mean the node has reached a balanced state
- the freed memory may still be insufficient to bring free pages above the
high watermark.  Unconditionally resetting kswapd_failures in this case
keeps kswapd alive indefinitely.

The result is that kswapd runs endlessly.  Unlike direct reclaim which
only reclaims from the allocating cgroup, kswapd scans the entire node's
memory.  This causes hot file pages from all workloads on the node to be
evicted, not just those from the cgroup triggering memory.high.  These
pages constantly refault, generating sustained heavy IO READ pressure
across the entire system.

Fix this by only resetting kswapd_failures when the node is actually
balanced.  This allows both kswapd and direct reclaim to clear
kswapd_failures upon successful reclaim, but only when the reclaim
actually resolves the memory pressure (i.e., the node becomes balanced).

Link: https://lkml.kernel.org/r/20260120024402.387576-1-jiayuan.chen@linux.dev
Link: https://lkml.kernel.org/r/20260120024402.387576-2-jiayuan.chen@linux.dev
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 mm/vmscan.c            |   22 ++++++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

--- a/include/linux/mmzone.h~mm-vmscan-mitigate-spurious-kswapd_failures-reset-from-direct-reclaim
+++ a/include/linux/mmzone.h
@@ -1536,6 +1536,8 @@ static inline unsigned long pgdat_end_pf
 void build_all_zonelists(pg_data_t *pgdat);
 void wakeup_kswapd(struct zone *zone, gfp_t gfp_mask, int order,
 		   enum zone_type highest_zoneidx);
+void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
+			       unsigned int order, int highest_zoneidx);
 bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 			 int highest_zoneidx, unsigned int alloc_flags,
 			 long free_pages);
--- a/mm/vmscan.c~mm-vmscan-mitigate-spurious-kswapd_failures-reset-from-direct-reclaim
+++ a/mm/vmscan.c
@@ -5064,7 +5064,7 @@ static void lru_gen_shrink_node(struct p
 	blk_finish_plug(&plug);
 done:
 	if (sc->nr_reclaimed > reclaimed)
-		atomic_set(&pgdat->kswapd_failures, 0);
+		kswapd_try_clear_hopeless(pgdat, sc->order, sc->reclaim_idx);
 }
 
 /******************************************************************************
@@ -6131,7 +6131,7 @@ again:
 	 * successful direct reclaim run will revive a dormant kswapd.
 	 */
 	if (reclaimable)
-		atomic_set(&pgdat->kswapd_failures, 0);
+		kswapd_try_clear_hopeless(pgdat, sc->order, sc->reclaim_idx);
 	else if (sc->cache_trim_mode)
 		sc->cache_trim_mode_failed = 1;
 }
@@ -7390,6 +7390,24 @@ void wakeup_kswapd(struct zone *zone, gf
 	wake_up_interruptible(&pgdat->kswapd_wait);
 }
 
+static void kswapd_clear_hopeless(pg_data_t *pgdat)
+{
+	atomic_set(&pgdat->kswapd_failures, 0);
+}
+
+/*
+ * Reset kswapd_failures only when the node is balanced. Without this
+ * check, successful direct reclaim (e.g., from cgroup memory.high
+ * throttling) can keep resetting kswapd_failures even when the node
+ * cannot be balanced, causing kswapd to run endlessly.
+ */
+void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
+			       unsigned int order, int highest_zoneidx)
+{
+	if (pgdat_balanced(pgdat, order, highest_zoneidx))
+		kswapd_clear_hopeless(pgdat);
+}
+
 #ifdef CONFIG_HIBERNATION
 /*
  * Try to free `nr_to_reclaim' of memory, system-wide, and return the number of
_

Patches currently in -mm which might be from jiayuan.chen@shopee.com are

mm-vmscan-mitigate-spurious-kswapd_failures-reset-from-direct-reclaim.patch
mm-vmscan-add-tracepoint-and-reason-for-kswapd_failures-reset.patch

