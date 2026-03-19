Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3146B37B3F5
	for <mm-commits@vger.kernel.org>; Thu, 19 Mar 2026 22:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773961117; cv=none; b=hYy0r6H2XfXUmeKlHCKfsSKntcrMajQ3tNq0pLP14UA/l4rbUm8PNasDtTNZgAgh11i/TlwE++e0cueKBzA0oun+jAckJ9XUYak3tI1oBA1RrG0iukZ3IJGJXtqtVSUv6SU60vGnV344fhPiXAqRgXvsLEBze0GQtcRMyIRAlh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773961117; c=relaxed/simple;
	bh=mLccU3H5UlesMTLue9WOlOIybYmQITj6m6Yb26zF0kw=;
	h=Date:To:From:Subject:Message-Id; b=FBZV9Bfe+1cTuznoOEEqgCQv6Ox8nHRlbwlKH7f6YJDJ+KjLFYSB8sCk1q8M/U5uWRLUkW3ft/koYTRBpDumkd1l7YDL06g05wi9o50PeWvdrDDyfQDQzejElKETPC2fdQHWRJiB8lHhno6eGmVUxR3QfyQAKaTf7kVQa9Xy5WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f4Sh090m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f4Sh090m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA68DC19424;
	Thu, 19 Mar 2026 22:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773961116;
	bh=mLccU3H5UlesMTLue9WOlOIybYmQITj6m6Yb26zF0kw=;
	h=Date:To:From:Subject:From;
	b=f4Sh090m7n5KjC2EZSRpD3lRZsY8TieNyQKvQhUZ+kJvllqtvEGWjbwtJFwLYz2sH
	 FHhoj8eOI8K1dZPgV/Y3tcHk3zMVCyrU1xiiWgicElSJ5xYdVzc3HgDak3CRRXDIqX
	 t2H03p7MInjKnXBZc4YxscBXf/4akBVeAvE2Gnu4=
Date: Thu, 19 Mar 2026 15:58:36 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,wjl.linux@gmail.com,weixugc@google.com,ryncsn@gmail.com,laoar.shao@gmail.com,bfguo@icloud.com,baohua@kernel.org,axelrasmussen@google.com,lenohou@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-fix-cgroup-oom-during-mglru-state-switching.patch added to mm-new branch
Message-Id: <20260319225836.BA68DC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: fix cgroup OOM during MGLRU state switching
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-fix-cgroup-oom-during-mglru-state-switching.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-fix-cgroup-oom-during-mglru-state-switching.patch

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
Cc: Axel Rasmussen <axelrasmussen@google.com>
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
@@ -886,7 +886,7 @@ static enum folio_references folio_check
 	if (referenced_ptes == -1)
 		return FOLIOREF_KEEP;
 
-	if (lru_gen_enabled()) {
+	if (lru_gen_enabled() && !lru_gen_switching()) {
 		if (!referenced_ptes)
 			return FOLIOREF_RECLAIM;
 
@@ -2286,7 +2286,7 @@ static void prepare_scan_control(pg_data
 	unsigned long file;
 	struct lruvec *target_lruvec;
 
-	if (lru_gen_enabled())
+	if (lru_gen_enabled() && !lru_gen_switching())
 		return;
 
 	target_lruvec = mem_cgroup_lruvec(sc->target_mem_cgroup, pgdat);
@@ -2625,6 +2625,7 @@ static bool can_age_anon_pages(struct lr
 
 #ifdef CONFIG_LRU_GEN
 
+DEFINE_STATIC_KEY_FALSE(lru_switch);
 #ifdef CONFIG_LRU_GEN_ENABLED
 DEFINE_STATIC_KEY_ARRAY_TRUE(lru_gen_caps, NR_LRU_GEN_CAPS);
 #define get_cap(cap)	static_branch_likely(&lru_gen_caps[cap])
@@ -5318,6 +5319,8 @@ static void lru_gen_change_state(bool en
 	if (enabled == lru_gen_enabled())
 		goto unlock;
 
+	static_branch_enable_cpuslocked(&lru_switch);
+
 	if (enabled)
 		static_branch_enable_cpuslocked(&lru_gen_caps[LRU_GEN_CORE]);
 	else
@@ -5348,6 +5351,9 @@ static void lru_gen_change_state(bool en
 
 		cond_resched();
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
+
+	static_branch_disable_cpuslocked(&lru_switch);
+
 unlock:
 	mutex_unlock(&state_mutex);
 	put_online_mems();
@@ -5920,9 +5926,12 @@ static void shrink_lruvec(struct lruvec
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
@@ -6182,10 +6191,13 @@ static void shrink_node(pg_data_t *pgdat
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
@@ -6455,7 +6467,7 @@ static void snapshot_refaults(struct mem
 	struct lruvec *target_lruvec;
 	unsigned long refaults;
 
-	if (lru_gen_enabled())
+	if (lru_gen_enabled() && !lru_gen_switching())
 		return;
 
 	target_lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
@@ -6845,9 +6857,12 @@ static void kswapd_age_node(struct pglis
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

mm-mglru-fix-cgroup-oom-during-mglru-state-switching.patch

