Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F6D2C235E
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 23:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768520378; cv=none; b=UDFsgVk3FHGxXccO7UhW9s3BECB2zB/OuJzzlliu/KGlMgMQm2/cIk28DtYRzagMeA9t1Gx8wXjXQLXo/p+4QFPrtJGPJ3Y4iAfSHUqsGdTim5n44FH6NevlDXezLMiZYLerUBnmPF5VV3vRrmNN5dc+7VIAtqyqkkmiSXNoHCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768520378; c=relaxed/simple;
	bh=zaWU4Th/wvbBD/PzrKjum8hiEdIVE76LGDA+hfssl/Y=;
	h=Date:To:From:Subject:Message-Id; b=lcEGq0oim/uwsWvW+LIW8Zf3xKWmXpN8/BzHXoT/RIWY0BAc89q/GZrPv24OVdU8ayW3kuKs0DKS3cjGqjHIFnDhGUIBV4GZwTWWV5fvAFK6zqGnyzBO5lSskk/HKRzFe7goiawvAqf0J83aMKt/DTUb3uMjFQflXcNPXHDa368=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T9G2oF3c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T9G2oF3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D97C116D0;
	Thu, 15 Jan 2026 23:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768520378;
	bh=zaWU4Th/wvbBD/PzrKjum8hiEdIVE76LGDA+hfssl/Y=;
	h=Date:To:From:Subject:From;
	b=T9G2oF3cVlOT683Amx5zECHqN7VQdqy+tIPwWLKhCrdaPx72P4R0kemAmai1GQtXm
	 bTa6AkWSTOnc6oULvgZeQQDB3Gtg0GWTeSamlIx6Yl8p0GbkY4m52m9Y57mH1URK5v
	 0ABYVumvo1O/L8nPHMY8OIjcF9950fTJP2k2gTOU=
Date: Thu, 15 Jan 2026 15:39:37 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jiayuan.chen@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,jiayuan.chen@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-mitigate-spurious-kswapd_failures-reset-from-direct-reclaim.patch added to mm-new branch
Message-Id: <20260115233938.03D97C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: mitigate spurious kswapd_failures reset from direct reclaim
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-mitigate-spurious-kswapd_failures-reset-from-direct-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-mitigate-spurious-kswapd_failures-reset-from-direct-reclaim.patch

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
From: Jiayuan Chen <jiayuan.chen@shopee.com>
Subject: mm/vmscan: mitigate spurious kswapd_failures reset from direct reclaim
Date: Wed, 14 Jan 2026 15:40:35 +0800

Patch series "mm/vmscan: mitigate spurious kswapd_failures reset and add
tracepoints", v3.

== Problem ==

We observed an issue in production on a multi-NUMA system where kswapd
runs endlessly, causing sustained heavy IO READ pressure across the entire
system.

The root cause is that direct reclaim triggered by cgroup memory.high
keeps resetting kswapd_failures to 0, even when the node cannot be
balanced.  This prevents kswapd from ever stopping after reaching
MAX_RECLAIM_RETRIES.

bash
bpftrace -e '
 #include <linux/mmzone.h>
 #include <linux/shrinker.h>
kprobe:balance_pgdat {
	$pgdat = (struct pglist_data *)arg0;
	if ($pgdat->kswapd_failures > 0) {
		printf("[node %d] [%lu] kswapd end, kswapd_failures %d\n",
                       $pgdat->node_id, jiffies, $pgdat->kswapd_failures);
	}
}
tracepoint:vmscan:mm_vmscan_direct_reclaim_end {
	printf("[cpu %d] [%ul] reset kswapd_failures %d \n", cpu, jiffies,
               args.nr_reclaimed)
}
'

The trace results showed that when kswapd_failures reaches 15, continuous
direct reclaim keeps resetting it to 0.  This was accompanied by a flood
of kswapd_failures log entries, and shortly after, we observed massive
refaults occurring.

== Solution ==

Patch 1 fixes the issue by only resetting kswapd_failures when the node
is actually balanced. This introduces pgdat_try_reset_kswapd_failures()
as a wrapper that checks pgdat_balanced() before resetting.

Patch 2 extends the wrapper to track why kswapd_failures was reset,
adding tracepoints for better observability:
  - mm_vmscan_reset_kswapd_failures: traces each reset with reason
  - mm_vmscan_kswapd_reclaim_fail: traces each kswapd reclaim failure


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

Link: https://lkml.kernel.org/r/20260114074049.229935-1-jiayuan.chen@linux.dev
Link: https://lkml.kernel.org/r/20260114074049.229935-2-jiayuan.chen@linux.dev
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-mitigate-spurious-kswapd_failures-reset-from-direct-reclaim
+++ a/mm/vmscan.c
@@ -2650,6 +2650,25 @@ static bool can_age_anon_pages(struct lr
 			  lruvec_memcg(lruvec));
 }
 
+static void pgdat_reset_kswapd_failures(pg_data_t *pgdat)
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
+static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx);
+static inline void pgdat_try_reset_kswapd_failures(struct pglist_data *pgdat,
+						   struct scan_control *sc)
+{
+	if (pgdat_balanced(pgdat, sc->order, sc->reclaim_idx))
+		pgdat_reset_kswapd_failures(pgdat);
+}
+
 #ifdef CONFIG_LRU_GEN
 
 #ifdef CONFIG_LRU_GEN_ENABLED
@@ -5221,7 +5240,7 @@ static void lru_gen_shrink_node(struct p
 	blk_finish_plug(&plug);
 done:
 	if (sc->nr_reclaimed > reclaimed)
-		atomic_set(&pgdat->kswapd_failures, 0);
+		pgdat_try_reset_kswapd_failures(pgdat, sc);
 }
 
 /******************************************************************************
@@ -6288,7 +6307,7 @@ again:
 	 * successful direct reclaim run will revive a dormant kswapd.
 	 */
 	if (reclaimable)
-		atomic_set(&pgdat->kswapd_failures, 0);
+		pgdat_try_reset_kswapd_failures(pgdat, sc);
 	else if (sc->cache_trim_mode)
 		sc->cache_trim_mode_failed = 1;
 }
_

Patches currently in -mm which might be from jiayuan.chen@shopee.com are

mm-vmscan-mitigate-spurious-kswapd_failures-reset-from-direct-reclaim.patch
mm-vmscan-add-tracepoint-and-reason-for-kswapd_failures-reset.patch

