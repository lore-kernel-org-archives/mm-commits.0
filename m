Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB58413AD1C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744948; cv=none; b=gDvs5Dgb8+e9GfZYg66ASx2wTOSwC+r9gDTINkTlm3ieioNZo3oUz7hyoSQ/8VxNB2mHVLbW7wPnV6wxeoSlJqZKDIgAShZQvuydhbBe1uviwFCyXIDJaG+DocmdZ9BzSDYXQl/u4xC6do1tOegegd8sinUmMgGrjA5E/BnGJPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744948; c=relaxed/simple;
	bh=9zMd+hrs70oErW6ZVOxby2cqf9Np02ckA2pfcGnR50g=;
	h=Date:To:From:Subject:Message-Id; b=JGvcgxcltOafUoVifBqnT0b4DkzKivS0y5qfsoi7rrhUcf648mkNIHe8jeSudYMpJKj1VxMDwOHjyJzkBPiQI+KBJmnadYLucxPgQbm1kmn6oA9gGN8hM8Uuns9Ps6SrJ9XDehy9aj3wM/ilenpPjTJO2bJPdk1FbvCyJC4Ru7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N1xEBRxz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N1xEBRxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AC6C4CEF7;
	Sun, 29 Mar 2026 00:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744948;
	bh=9zMd+hrs70oErW6ZVOxby2cqf9Np02ckA2pfcGnR50g=;
	h=Date:To:From:Subject:From;
	b=N1xEBRxz7WxAhYgFTHmQivvBDg5Cz9SPw1wb1czaHGyNHfcxYy5DU4vjw2rDFNp62
	 J8c3YD7BgajJiZBYwyx1U1CaOcjR2/0yR7/9C4mOHQ5lcwbtPYRgkytV3jTO7QcvdB
	 mH5tO6wqeMbcVMFaXlYLRuypSnXeCYWdF2TW/tlU=
Date: Sat, 28 Mar 2026 17:42:28 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,wjl.linux@gmail.com,weixugc@google.com,ryncsn@gmail.com,laoar.shao@gmail.com,bfguo@icloud.com,baohua@kernel.org,axelrasmussen@google.com,lenohou@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-fix-cgroup-oom-during-mglru-state-switching.patch removed from -mm tree
Message-Id: <20260329004228.B3AC6C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: fix cgroup OOM during MGLRU state switching
has been removed from the -mm tree.  Its filename was
     mm-mglru-fix-cgroup-oom-during-mglru-state-switching.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Leno Hou <lenohou@gmail.com>
Subject: mm/mglru: fix cgroup OOM during MGLRU state switching
Date: Thu, 19 Mar 2026 00:30:49 +0800

When the Multi-Gen LRU (MGLRU) state is toggled dynamically, a race
condition exists between the state switching and the memory reclaim path. 
This can lead to unexpected cgroup OOM kills, even when plenty of
reclaimable memory is available.

Problem Description
==================
The issue arises from a "reclaim vacuum" during the transition.

1. When disabling MGLRU, lru_gen_change_state() sets lrugen->enabled to
   false before the pages are drained from MGLRU lists back to traditional
   LRU lists.
2. Concurrent reclaimers in shrink_lruvec() see lrugen->enabled as false
   and skip the MGLRU path.
3. However, these pages might not have reached the traditional LRU lists
   yet, or the changes are not yet visible to all CPUs due to a lack
   of synchronization.
4. get_scan_count() subsequently finds traditional LRU lists empty,
   concludes there is no reclaimable memory, and triggers an OOM kill.

A similar race can occur during enablement, where the reclaimer sees the
new state but the MGLRU lists haven't been populated via fill_evictable()
yet.

Solution
========
Introduce a 'switching' state (`lru_switch`) to bridge the transition.
When transitioning, the system enters this intermediate state where
the reclaimer is forced to attempt both MGLRU and traditional reclaim
paths sequentially. This ensures that folios remain visible to at least
one reclaim mechanism until the transition is fully materialized across
all CPUs.

Race & Mitigation
================
A race window exists between checking the 'draining' state and performing
the actual list operations. For instance, a reclaimer might observe the
draining state as false just before it changes, leading to a suboptimal
reclaim path decision.

However, this impact is effectively mitigated by the kernel's reclaim
retry mechanism (e.g., in do_try_to_free_pages). If a reclaimer pass fails
to find eligible folios due to a state transition race, subsequent retries
in the loop will observe the updated state and correctly direct the scan
to the appropriate LRU lists. This ensures the transient inconsistency
does not escalate into a terminal OOM kill.

This effectively reduce the race window that previously triggered OOMs
under high memory pressure.

This fix has been verified on v7.0.0-rc1; dynamic toggling of MGLRU
functions correctly without triggering unexpected OOM kills.

Link: https://lkml.kernel.org/r/20260319-b4-switch-mglru-v2-v5-1-8898491e5f17@gmail.com
Signed-off-by: Leno Hou <lenohou@gmail.com>
Acked-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Jialing Wang <wjl.linux@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Bingfang Guo <bfguo@icloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   11 +++++++++++
 mm/rmap.c                 |    7 ++++++-
 mm/vmscan.c               |   33 ++++++++++++++++++++++++---------
 3 files changed, 41 insertions(+), 10 deletions(-)

--- a/include/linux/mm_inline.h~mm-mglru-fix-cgroup-oom-during-mglru-state-switching
+++ a/include/linux/mm_inline.h
@@ -102,6 +102,12 @@ static __always_inline enum lru_list fol
 
 #ifdef CONFIG_LRU_GEN
 
+static inline bool lru_gen_switching(void)
+{
+	DECLARE_STATIC_KEY_FALSE(lru_switch);
+
+	return static_branch_unlikely(&lru_switch);
+}
 #ifdef CONFIG_LRU_GEN_ENABLED
 static inline bool lru_gen_enabled(void)
 {
@@ -315,6 +321,11 @@ static inline bool lru_gen_enabled(void)
 {
 	return false;
 }
+
+static inline bool lru_gen_switching(void)
+{
+	return false;
+}
 
 static inline bool lru_gen_in_fault(void)
 {
--- a/mm/rmap.c~mm-mglru-fix-cgroup-oom-during-mglru-state-switching
+++ a/mm/rmap.c
@@ -973,7 +973,12 @@ static bool folio_referenced_one(struct
 			nr = folio_pte_batch(folio, pvmw.pte, pteval, max_nr);
 		}
 
-		if (lru_gen_enabled() && pvmw.pte) {
+		/*
+		 * When LRU is switching, we don’t know where the surrounding folios
+		 * are. —they could be on active/inactive lists or on MGLRU. So the
+		 * simplest approach is to disable this look-around optimization.
+		 */
+		if (lru_gen_enabled() && !lru_gen_switching() && pvmw.pte) {
 			if (lru_gen_look_around(&pvmw, nr))
 				referenced++;
 		} else if (pvmw.pte) {
--- a/mm/vmscan.c~mm-mglru-fix-cgroup-oom-during-mglru-state-switching
+++ a/mm/vmscan.c
@@ -905,7 +905,7 @@ static enum folio_references folio_check
 	if (referenced_ptes == -1)
 		return FOLIOREF_KEEP;
 
-	if (lru_gen_enabled()) {
+	if (lru_gen_enabled() && !lru_gen_switching()) {
 		if (!referenced_ptes)
 			return FOLIOREF_RECLAIM;
 
@@ -2308,7 +2308,7 @@ static void prepare_scan_control(pg_data
 	unsigned long file;
 	struct lruvec *target_lruvec;
 
-	if (lru_gen_enabled())
+	if (lru_gen_enabled() && !lru_gen_switching())
 		return;
 
 	target_lruvec = mem_cgroup_lruvec(sc->target_mem_cgroup, pgdat);
@@ -2647,6 +2647,7 @@ static bool can_age_anon_pages(struct lr
 
 #ifdef CONFIG_LRU_GEN
 
+DEFINE_STATIC_KEY_FALSE(lru_switch);
 #ifdef CONFIG_LRU_GEN_ENABLED
 DEFINE_STATIC_KEY_ARRAY_TRUE(lru_gen_caps, NR_LRU_GEN_CAPS);
 #define get_cap(cap)	static_branch_likely(&lru_gen_caps[cap])
@@ -5181,6 +5182,8 @@ static void lru_gen_change_state(bool en
 	if (enabled == lru_gen_enabled())
 		goto unlock;
 
+	static_branch_enable_cpuslocked(&lru_switch);
+
 	if (enabled)
 		static_branch_enable_cpuslocked(&lru_gen_caps[LRU_GEN_CORE]);
 	else
@@ -5211,6 +5214,9 @@ static void lru_gen_change_state(bool en
 
 		cond_resched();
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
+
+	static_branch_disable_cpuslocked(&lru_switch);
+
 unlock:
 	mutex_unlock(&state_mutex);
 	put_online_mems();
@@ -5783,9 +5789,12 @@ static void shrink_lruvec(struct lruvec
 	bool proportional_reclaim;
 	struct blk_plug plug;
 
-	if (lru_gen_enabled() && !root_reclaim(sc)) {
+	if ((lru_gen_enabled() || lru_gen_switching()) && !root_reclaim(sc)) {
 		lru_gen_shrink_lruvec(lruvec, sc);
-		return;
+
+		if (!lru_gen_switching())
+			return;
+
 	}
 
 	get_scan_count(lruvec, sc, nr);
@@ -6045,10 +6054,13 @@ static void shrink_node(pg_data_t *pgdat
 	struct lruvec *target_lruvec;
 	bool reclaimable = false;
 
-	if (lru_gen_enabled() && root_reclaim(sc)) {
+	if ((lru_gen_enabled() || lru_gen_switching()) && root_reclaim(sc)) {
 		memset(&sc->nr, 0, sizeof(sc->nr));
 		lru_gen_shrink_node(pgdat, sc);
-		return;
+
+		if (!lru_gen_switching())
+			return;
+
 	}
 
 	target_lruvec = mem_cgroup_lruvec(sc->target_mem_cgroup, pgdat);
@@ -6318,7 +6330,7 @@ static void snapshot_refaults(struct mem
 	struct lruvec *target_lruvec;
 	unsigned long refaults;
 
-	if (lru_gen_enabled())
+	if (lru_gen_enabled() && !lru_gen_switching())
 		return;
 
 	target_lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
@@ -6708,9 +6720,12 @@ static void kswapd_age_node(struct pglis
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 
-	if (lru_gen_enabled()) {
+	if (lru_gen_enabled() || lru_gen_switching()) {
 		lru_gen_age_node(pgdat, sc);
-		return;
+
+		if (!lru_gen_switching())
+			return;
+
 	}
 
 	lruvec = mem_cgroup_lruvec(NULL, pgdat);
_

Patches currently in -mm which might be from lenohou@gmail.com are


