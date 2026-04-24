Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64ED83F7A9E
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 18:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777057166; cv=none; b=d+R0vfKO74fXfV/kkL0dt5RafL1GfjTa8Fv9X6gpErGIOUlmvLl25PLSDfYtSdqywLya7PHwE0xMd14lzqhRyZDb3+FzcXbfP/L7I890XZDcgLk4Rt8ePgEegiNljrszCne0wxsFHuPPpkc0YpPP0eOOVLDTMh+Q2CHz+bJidJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777057166; c=relaxed/simple;
	bh=DZXxnjArV9eYuOA5B7kOHmrHWQq7FzAZ9u7VrsolZ58=;
	h=Date:To:From:Subject:Message-Id; b=Lk6mHFlTFT7XcKM7hZ1U2wrFOlEjdaMNZlNBp4E7wjLPR1E59CoodDIbT1zGEmXMaVCkluHT5eX2m0Fhj/FpcXWuOF3ZKAp7Lds+ZPFvYd0UkMGt0vvjEMoprY/Mh2M+LBcNMbiJpccInLNRs38gXHewloZxecfvl02/by6TShs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cBGV0QsZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cBGV0QsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB61C19425;
	Fri, 24 Apr 2026 18:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777057165;
	bh=DZXxnjArV9eYuOA5B7kOHmrHWQq7FzAZ9u7VrsolZ58=;
	h=Date:To:From:Subject:From;
	b=cBGV0QsZmN2zwEqDv94gmnA3BPeK0OLq3odlyRub4Q80unnS7n2aU/4phRb2yifcT
	 j9EqGHvzmgKjWRYYF51SwS3vFWLqJq8mpg0FmVhVenxV8l/sIWroTlMCseA8Dh0IbT
	 /oHx5kyK1Dcdp955bxjfCnwoApCKQn77iZvDnGaI=
Date: Fri, 24 Apr 2026 11:59:25 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,willy@infradead.org,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,qi.zheng@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kuba@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,edumazet@google.com,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,jp.kobryn@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmpressure-skip-socket-pressure-for-costly-order-reclaim.patch added to mm-new branch
Message-Id: <20260424185925.9FB61C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmpressure: skip socket pressure for costly order reclaim
has been added to the -mm mm-new branch.  Its filename is
     mm-vmpressure-skip-socket-pressure-for-costly-order-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmpressure-skip-socket-pressure-for-costly-order-reclaim.patch

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
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Subject: mm/vmpressure: skip socket pressure for costly order reclaim
Date: Mon, 6 Apr 2026 12:50:14 -0700

When reclaim is triggered by high order allocations on a fragmented
system, vmpressure() can report poor reclaim efficiency even though the
system has plenty of free memory.  This is because many pages are scanned,
but few are found to actually reclaim - the pages are actively in use and
don't need to be freed.  The resulting scan:reclaim ratio causes
vmpressure() to assert socket pressure, throttling TCP throughput
unnecessarily.

Costly order allocations (above PAGE_ALLOC_COSTLY_ORDER) rely heavily on
compaction to succeed, so poor reclaim efficiency at these orders does not
necessarily indicate memory pressure.  The kernel already treats this
order as the boundary where reclaim is no longer expected to succeed and
compaction may take over.

Make vmpressure() order-aware through an additional parameter sourced from
scan_control at existing call sites.  Socket pressure is now only asserted
when order <= PAGE_ALLOC_COSTLY_ORDER.

Memcg reclaim is unaffected since try_to_free_mem_cgroup_pages() always
uses order 0, which passes the filter unconditionally.  Similarly,
vmpressure_prio() now passes order 0 internally when calling vmpressure(),
ensuring critical pressure from low reclaim priority is not suppressed by
the order filter.

The patch was motivated by a case of impacted net throughput in
production.  On one affected host, the memory state at the time showed
~15GB available, zero cgroup pressure, and the following buddyinfo state:

Order FreePages
0:    133,970
1:    29,230
2:    17,351
3:    18,984
7+:   0

Using bpf, it was found that 94% of vmpressure calls on this host were
from order-7 kswapd reclaim.

TCP minimum recv window is rcv_ssthresh:19712.

Before patch:
723 out of 3,843 (19%) TCP connections stuck at minimum recv window

After live-patching and ~30min elapsed:
0 out of 3,470 TCP connections stuck at minimum recv window

Link: https://lore.kernel.org/20260406195014.112521-1-jp.kobryn@linux.dev
Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
Reviewed-by: Rik van Riel <riel@surriel.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmpressure.h |    9 +++++----
 mm/vmpressure.c            |   15 ++++++++++++---
 mm/vmscan.c                |    8 ++++----
 3 files changed, 21 insertions(+), 11 deletions(-)

--- a/include/linux/vmpressure.h~mm-vmpressure-skip-socket-pressure-for-costly-order-reclaim
+++ a/include/linux/vmpressure.h
@@ -30,8 +30,8 @@ struct vmpressure {
 struct mem_cgroup;
 
 #ifdef CONFIG_MEMCG
-extern void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
-		       unsigned long scanned, unsigned long reclaimed);
+void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg, bool tree,
+		unsigned long scanned, unsigned long reclaimed);
 extern void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio);
 
 extern void vmpressure_init(struct vmpressure *vmpr);
@@ -44,8 +44,9 @@ extern int vmpressure_register_event(str
 extern void vmpressure_unregister_event(struct mem_cgroup *memcg,
 					struct eventfd_ctx *eventfd);
 #else
-static inline void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
-			      unsigned long scanned, unsigned long reclaimed) {}
+static inline void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg,
+			      bool tree, unsigned long scanned,
+			      unsigned long reclaimed) {}
 static inline void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg,
 				   int prio) {}
 #endif /* CONFIG_MEMCG */
--- a/mm/vmpressure.c~mm-vmpressure-skip-socket-pressure-for-costly-order-reclaim
+++ a/mm/vmpressure.c
@@ -218,6 +218,7 @@ static void vmpressure_work_fn(struct wo
 /**
  * vmpressure() - Account memory pressure through scanned/reclaimed ratio
  * @gfp:	reclaimer's gfp mask
+ * @order:	allocation order being reclaimed for
  * @memcg:	cgroup memory controller handle
  * @tree:	legacy subtree mode
  * @scanned:	number of pages scanned
@@ -236,7 +237,7 @@ static void vmpressure_work_fn(struct wo
  *
  * This function does not return any value.
  */
-void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
+void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg, bool tree,
 		unsigned long scanned, unsigned long reclaimed)
 {
 	struct vmpressure *vmpr;
@@ -307,7 +308,15 @@ void vmpressure(gfp_t gfp, struct mem_cg
 
 		level = vmpressure_calc_level(scanned, reclaimed);
 
-		if (level > VMPRESSURE_LOW) {
+		/*
+		 * Once we go above COSTLY_ORDER, reclaim relies heavily on
+		 * compaction to make progress. Reclaim efficiency was never a
+		 * great proxy for pressure to begin with, but it's outright
+		 * misleading with these high orders. Don't throttle sockets
+		 * because somebody is attempting something crazy like an order-7
+		 * and predictably struggling.
+		 */
+		if (level > VMPRESSURE_LOW && order <= PAGE_ALLOC_COSTLY_ORDER) {
 			/*
 			 * Let the socket buffer allocator know that
 			 * we are having trouble reclaiming LRU pages.
@@ -348,7 +357,7 @@ void vmpressure_prio(gfp_t gfp, struct m
 	 * to the vmpressure() basically means that we signal 'critical'
 	 * level.
 	 */
-	vmpressure(gfp, memcg, true, vmpressure_win, 0);
+	vmpressure(gfp, 0, memcg, true, vmpressure_win, 0);
 }
 
 #define MAX_VMPRESSURE_ARGS_LEN	(strlen("critical") + strlen("hierarchy") + 2)
--- a/mm/vmscan.c~mm-vmpressure-skip-socket-pressure-for-costly-order-reclaim
+++ a/mm/vmscan.c
@@ -5026,8 +5026,8 @@ static int shrink_one(struct lruvec *lru
 	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
 
 	if (!sc->proactive)
-		vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned - scanned,
-			   sc->nr_reclaimed - reclaimed);
+		vmpressure(sc->gfp_mask, sc->order, memcg, false,
+			   sc->nr_scanned - scanned, sc->nr_reclaimed - reclaimed);
 
 	flush_reclaim_state(sc);
 
@@ -6131,7 +6131,7 @@ static void shrink_node_memcgs(pg_data_t
 
 		/* Record the group's reclaim efficiency */
 		if (!sc->proactive)
-			vmpressure(sc->gfp_mask, memcg, false,
+			vmpressure(sc->gfp_mask, sc->order, memcg, false,
 				   sc->nr_scanned - scanned,
 				   sc->nr_reclaimed - reclaimed);
 
@@ -6176,7 +6176,7 @@ again:
 
 	/* Record the subtree's reclaim efficiency */
 	if (!sc->proactive)
-		vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
+		vmpressure(sc->gfp_mask, sc->order, sc->target_mem_cgroup, true,
 			   sc->nr_scanned - nr_scanned, nr_node_reclaimed);
 
 	if (nr_node_reclaimed)
_

Patches currently in -mm which might be from jp.kobryn@linux.dev are

mm-vmpressure-skip-socket-pressure-for-costly-order-reclaim.patch

