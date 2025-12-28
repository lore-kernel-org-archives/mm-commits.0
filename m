Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3144C6D
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 19:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766951230; cv=none; b=TrGv+j3dCK7vMw4FWpANqiRhWALTlLqF1LOIZdrdqvV28E2bzPT4GGh8uOvo4St2sKSAoBZ//N3nKOfIb7tZoqK2IymqgPkKuHibus8Z9+QRiAN4OFtZPqCRQkjidsQ0jSpAK79j1mG0v2hIn8H+ZwzWCccYqw/UmYH6mUxvzmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766951230; c=relaxed/simple;
	bh=FQ/mMEoKC46sdHcQf9jgIlawABECfuLmYCEkqUQ8+qE=;
	h=Date:To:From:Subject:Message-Id; b=iCzjsPqUThKrfKkjrXNEU4y0SPgEXMhHi4kS0CXukyMVA24alQ9ekVbf3FGwPvU/5beo0bcxqBM+urF3OsG7mZ0MY9br+jKacHP07DpW04voaFL7RfIb/uIjFnXCbFarWPZLLJC3jr+7C/1msA/CcWD2zekJ+10m5yiHKvQd3dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AeA/PonN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AeA/PonN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1345C4CEFB;
	Sun, 28 Dec 2025 19:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766951229;
	bh=FQ/mMEoKC46sdHcQf9jgIlawABECfuLmYCEkqUQ8+qE=;
	h=Date:To:From:Subject:From;
	b=AeA/PonNM+QPvfAPUHjTrqNIz2g4e1Fe6gKjRx1VIfZ3CCaEOVZHJXWu9UEDj0VAP
	 jIoqgadOlVzHfFZpmMvCg84RroFl1jHNbVnf1/kyw3PZMmJQoR1cVVEI9W+I5ueGPC
	 9TP7fMYT1KckY9q8/r59qozAEYWupVX13HAvsX2c=
Date: Sun, 28 Dec 2025 11:47:09 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,jiayuan.chen@shopee.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,jiayuan.chen@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-mitigate-spurious-kswapd_failures-reset-from-direct-reclaim.patch added to mm-new branch
Message-Id: <20251228194709.C1345C4CEFB@smtp.kernel.org>
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
From: Jiayuan Chen <jiayuan.chen@linux.dev>
Subject: mm/vmscan: mitigate spurious kswapd_failures reset from direct reclaim
Date: Fri, 26 Dec 2025 16:00:42 +0800


This is v2 of this patch series. For v1, see [1].

When kswapd fails to reclaim memory, kswapd_failures is incremented.
Once it reaches MAX_RECLAIM_RETRIES, kswapd stops running to avoid
futile reclaim attempts. However, any successful direct reclaim
unconditionally resets kswapd_failures to 0, which can cause problems.

We observed an issue in production on a multi-NUMA system where a
process allocated large amounts of anonymous pages on a single NUMA
node, causing its watermark to drop below high and evicting most file
pages:

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

With swap disabled, only file pages can be reclaimed. When kswapd is
woken (e.g., via wake_all_kswapds()), it runs continuously but cannot
raise free memory above the high watermark since reclaimable file pages
are insufficient. Normally, kswapd would eventually stop after
kswapd_failures reaches MAX_RECLAIM_RETRIES.

However, containers on this machine have memory.high set in their
cgroup. Business processes continuously trigger the high limit, causing
frequent direct reclaim that keeps resetting kswapd_failures to 0. This
prevents kswapd from ever stopping.

The key insight is that direct reclaim triggered by cgroup memory.high
performs aggressive scanning to throttle the allocating process. With
sufficiently aggressive scanning, even hot pages will eventually be
reclaimed, making direct reclaim "successful" at freeing some memory.
However, this success does not mean the node has reached a balanced
state - the freed memory may still be insufficient to bring free pages
above the high watermark. Unconditionally resetting kswapd_failures in
this case keeps kswapd alive indefinitely.

The result is that kswapd runs endlessly. Unlike direct reclaim which
only reclaims from the allocating cgroup, kswapd scans the entire node's
memory. This causes hot file pages from all workloads on the node to be
evicted, not just those from the cgroup triggering memory.high. These
pages constantly refault, generating sustained heavy IO READ pressure
across the entire system.

Fix this by only resetting kswapd_failures when the node is actually
balanced. This allows both kswapd and direct reclaim to clear
kswapd_failures upon successful reclaim, but only when the reclaim
actually resolves the memory pressure (i.e., the node becomes balanced).

[1] https://lore.kernel.org/all/20251222122022.254268-1-jiayuan.chen@linux.dev/
Link: https://lkml.kernel.org/r/20251226080042.291657-1-jiayuan.chen@linux.dev
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-mitigate-spurious-kswapd_failures-reset-from-direct-reclaim
+++ a/mm/vmscan.c
@@ -2659,6 +2659,20 @@ static bool can_age_anon_pages(struct lr
 			  lruvec_memcg(lruvec));
 }
 
+/*
+ * Reset kswapd_failures only when the node is balanced. Without this
+ * check, successful direct reclaim (e.g., from cgroup memory.high
+ * throttling) can keep resetting kswapd_failures even when the node
+ * cannot be balanced, causing kswapd to run endlessly.
+ */
+static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx);
+static inline void reset_kswapd_failures(struct pglist_data *pgdat,
+					 struct scan_control *sc)
+{
+	if (pgdat_balanced(pgdat, sc->order, sc->reclaim_idx))
+		atomic_set(&pgdat->kswapd_failures, 0);
+}
+
 #ifdef CONFIG_LRU_GEN
 
 #ifdef CONFIG_LRU_GEN_ENABLED
@@ -5076,7 +5090,7 @@ static void lru_gen_shrink_node(struct p
 	blk_finish_plug(&plug);
 done:
 	if (sc->nr_reclaimed > reclaimed)
-		atomic_set(&pgdat->kswapd_failures, 0);
+		reset_kswapd_failures(pgdat, sc);
 }
 
 /******************************************************************************
@@ -6150,7 +6164,7 @@ again:
 	 * successful direct reclaim run will revive a dormant kswapd.
 	 */
 	if (reclaimable)
-		atomic_set(&pgdat->kswapd_failures, 0);
+		reset_kswapd_failures(pgdat, sc);
 	else if (sc->cache_trim_mode)
 		sc->cache_trim_mode_failed = 1;
 }
_

Patches currently in -mm which might be from jiayuan.chen@linux.dev are

mm-vmscan-mitigate-spurious-kswapd_failures-reset-from-direct-reclaim.patch

