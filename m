Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347CB35F5EF
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 19:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772306555; cv=none; b=nklJQ1nFNkJ65x2H5M3oirBRJ+NIxQhrhv2+E6K8wD/m55MUNVCa43JQ0+/dOy5W/eokuxYj5OCNhu5NdEA+eVnp3aVbbThYfH2ZT0fzbAqcvgUTxzAx4bLV174Fir4H7HTJqU9CcUzJg0t5Fyq0g9tMDemqpRxRt6dbkSs5Pvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772306555; c=relaxed/simple;
	bh=m4IvEtybZ2wVISJWnxD/CZhtfxWKhYaorPALdazg2rk=;
	h=Date:To:From:Subject:Message-Id; b=hM+OShE3hNrWKf2teay4xNFlp4MjE28ourVEJmX89+l7siE5PPYzch/jrk2RxyOB1tk2yxQs7w4CwwEqyunn9knB6i1CfM7m3jCF9AOat/4dTnA/J3X1rdtAXJmJHHQ2Lm6y5Q1e1v+ygy6uGQcBZ/TQh1DxB8B7I0ET2lzAj0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=On+iRVAI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="On+iRVAI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85F3C116D0;
	Sat, 28 Feb 2026 19:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772306554;
	bh=m4IvEtybZ2wVISJWnxD/CZhtfxWKhYaorPALdazg2rk=;
	h=Date:To:From:Subject:From;
	b=On+iRVAI8ZHGckOqvgx+p2yGgkWrx6OlPQwseVBsWXJcGdVElZVVpoQn/7BCbsF6u
	 EzqI383uFHcHtAPOgGgCYHCf2DYkoxcfImZkSosLLL/IGHrqf2LAmNADdx7kOawK/9
	 Eerfje6S9Rz3OXJUwovZQZx9bC9NEfbyKqXByyhI=
Date: Sat, 28 Feb 2026 11:22:34 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuzhao@google.com,yuanchu@google.com,wjl.linux@gmail.com,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,laoar.shao@gmail.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,21cnbao@gmail.com,lenohou@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-mglru-fix-cgroup-oom-during-mglru-state-switching.patch removed from -mm tree
Message-Id: <20260228192234.A85F3C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: fix cgroup OOM during MGLRU state switching
has been removed from the -mm tree.  Its filename was
     mm-mglru-fix-cgroup-oom-during-mglru-state-switching.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Leno Hou <lenohou@gmail.com>
Subject: mm/mglru: fix cgroup OOM during MGLRU state switching
Date: Sun, 1 Mar 2026 00:10:08 +0800

When the Multi-Gen LRU (MGLRU) state is toggled dynamically, a race
condition exists between the state switching and the memory reclaim path. 
This can lead to unexpected cgroup OOM kills, even when plenty of
reclaimable memory is available.

*** Problem Description ***

The issue arises from a "reclaim vacuum" during the transition:

1. When disabling MGLRU, lru_gen_change_state() sets lrugen->enabled to
   false before the pages are drained from MGLRU lists back to
   traditional LRU lists.
2. Concurrent reclaimers in shrink_lruvec() see lrugen->enabled as false
   and skip the MGLRU path.
3. However, these pages might not have reached the traditional LRU lists
   yet, or the changes are not yet visible to all CPUs due to a lack of
   synchronization.
4. get_scan_count() subsequently finds traditional LRU lists empty,
   concludes there is no reclaimable memory, and triggers an OOM kill.

A similar race can occur during enablement, where the reclaimer sees the
new state but the MGLRU lists haven't been populated via fill_evictable()
yet.

*** Solution ***

Introduce a 'draining' state to bridge the gap during transitions:

- Use smp_store_release() and smp_load_acquire() to ensure the visibility
  of 'enabled' and 'draining' flags across CPUs.
- Modify shrink_lruvec() to allow a "joint reclaim" period. If an lruvec
  is in the 'draining' state, the reclaimer will attempt to scan MGLRU
  lists first, and then fall through to traditional LRU lists instead
  of returning early. This ensures that folios are visible to at least
  one reclaim path at any given time.

*** Reproduction ***

The issue was consistently reproduced on v6.1.157 and v6.18.3 using
a high-pressure memory cgroup (v1) environment.

Reproduction steps:
1. Create a 16GB memcg and populate it with 10GB file cache (5GB active)
   and 8GB active anonymous memory.
2. Toggle MGLRU state while performing new memory allocations to force
   direct reclaim.

Reproduction script:

#!/bin/bash
# Fixed reproduction for memcg OOM during MGLRU toggle
set -euo pipefail

MGLRU_FILE="/sys/kernel/mm/lru_gen/enabled"
CGROUP_PATH="/sys/fs/cgroup/memory/memcg_oom_test"

# Switch MGLRU dynamically in the background
switch_mglru() {
    local orig_val=$(cat "$MGLRU_FILE")
    if [[ "$orig_val" != "0x0000" ]]; then
        echo n > "$MGLRU_FILE" &
    else
        echo y > "$MGLRU_FILE" &
    fi
}

# Setup 16G memcg
mkdir -p "$CGROUP_PATH"
echo $((16 * 1024 * 1024 * 1024)) > "$CGROUP_PATH/memory.limit_in_bytes"
echo $$ > "$CGROUP_PATH/cgroup.procs"

# 1. Build memory pressure (File + Anon)
dd if=/dev/urandom of=/tmp/test_file bs=1M count=10240
dd if=/tmp/test_file of=/dev/null bs=1M # Warm up cache

stress-ng --vm 1 --vm-bytes 8G --vm-keep -t 600 &
sleep 5

# 2. Trigger switch and concurrent allocation
switch_mglru
stress-ng --vm 1 --vm-bytes 2G --vm-populate --timeout 5s || echo "OOM Triggered"

# Check OOM counter
grep oom_kill "$CGROUP_PATH/memory.oom_control"

Link: https://lkml.kernel.org/r/20260228161008.707-1-lenohou@gmail.com
Signed-off-by: Leno Hou <lenohou@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Jialing Wang <wjl.linux@gmail.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 mm/vmscan.c            |   14 +++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

--- a/include/linux/mmzone.h~mm-mglru-fix-cgroup-oom-during-mglru-state-switching
+++ a/include/linux/mmzone.h
@@ -577,6 +577,8 @@ struct lru_gen_folio {
 	atomic_long_t refaulted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS];
 	/* whether the multi-gen LRU is enabled */
 	bool enabled;
+	/* whether the multi-gen LRU is draining to LRU */
+	bool draining;
 	/* the memcg generation this lru_gen_folio belongs to */
 	u8 gen;
 	/* the list segment this lru_gen_folio belongs to */
--- a/mm/vmscan.c~mm-mglru-fix-cgroup-oom-during-mglru-state-switching
+++ a/mm/vmscan.c
@@ -5305,7 +5305,8 @@ static void lru_gen_change_state(bool en
 			VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
 			VM_WARN_ON_ONCE(!state_is_valid(lruvec));
 
-			lruvec->lrugen.enabled = enabled;
+			smp_store_release(&lruvec->lrugen.enabled, enabled);
+			smp_store_release(&lruvec->lrugen.draining, true);
 
 			while (!(enabled ? fill_evictable(lruvec) : drain_evictable(lruvec))) {
 				lruvec_unlock_irq(lruvec);
@@ -5313,6 +5314,8 @@ static void lru_gen_change_state(bool en
 				lruvec_lock_irq(lruvec);
 			}
 
+			smp_store_release(&lruvec->lrugen.draining, false);
+
 			lruvec_unlock_irq(lruvec);
 		}
 
@@ -5889,10 +5892,15 @@ static void shrink_lruvec(struct lruvec
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	bool proportional_reclaim;
 	struct blk_plug plug;
+	bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
+	bool lru_draining = smp_load_acquire(&lruvec->lrugen.draining);
 
-	if (lru_gen_enabled() && !root_reclaim(sc)) {
+	if (lrugen_enabled || lru_draining && !root_reclaim(sc)) {
 		lru_gen_shrink_lruvec(lruvec, sc);
-		return;
+
+		if (!lru_draining)
+			return;
+
 	}
 
 	get_scan_count(lruvec, sc, nr);
_

Patches currently in -mm which might be from lenohou@gmail.com are


