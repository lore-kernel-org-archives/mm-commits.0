Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B2836E466
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027615; cv=none; b=phwbZf30ACParBtJOtdPW1JmZalrzd78q2CEm81C1iLdW9xiBSj64fHiNwajOAoZWHOa+LUydlKlYeNvXZit6M8JlJM53/RBLM59Xzj9rNQxTQzUb1n7CekU45LLHI3wTU4npx36nnBV2JnIc87G6j2XrCsc2lYeziZ+nNh6YYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027615; c=relaxed/simple;
	bh=/DSiNIRnsjA/5LTBb8JVU8WpWUDp2k+ZnavaLiCBv9A=;
	h=Date:To:From:Subject:Message-Id; b=b4oObyU4sShTFziZERLhgpdqgjLSq1G13+nn8ZJqMp/J9az6YZ+c+MVnhYrhliu9XV/gLO/W1WaLs6CSze9YWdkYCZamHpB2P4zek//fpqhWXFBVo5flj/l1n6EVw3O4nn6LQLXQab/WYz4UY59pcsxBN3R+Ln33ybrb6ly9FX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o3gCdJ0x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o3gCdJ0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4C41F00898;
	Fri, 29 May 2026 04:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027614;
	bh=4m7rPEj56FA7IaDLCVKgHvq5JEiCRj27vFrqiLQH6a4=;
	h=Date:To:From:Subject;
	b=o3gCdJ0xeO8gWNFbJpj2AxbPQGmIe3c2unsjtJrrSl2/9T1kd2FbWQ9mmtDJpSCa4
	 GrPXvQeubyJwHXJZSQxN3It7Yl9hrCEv9bzbH0Xuk6GccKVeoI+b9Eg9AT57Up2EmL
	 PBnBxi0orG8Qdrn+tc/VU5KNFfjAXIt8DZDasJqA=
Date: Thu, 28 May 2026 21:06:53 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,willy@infradead.org,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,qi.zheng@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kuba@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,edumazet@google.com,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,jp.kobryn@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmpressure-skip-socket-pressure-for-costly-order-reclaim.patch removed from -mm tree
Message-Id: <20260529040654.3E4C41F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmpressure: skip socket pressure for costly order reclaim
has been removed from the -mm tree.  Its filename was
     mm-vmpressure-skip-socket-pressure-for-costly-order-reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -5071,8 +5071,8 @@ static int shrink_one(struct lruvec *lru
 	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
 
 	if (!sc->proactive)
-		vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned - scanned,
-			   sc->nr_reclaimed - reclaimed);
+		vmpressure(sc->gfp_mask, sc->order, memcg, false,
+			   sc->nr_scanned - scanned, sc->nr_reclaimed - reclaimed);
 
 	flush_reclaim_state(sc);
 
@@ -6175,7 +6175,7 @@ static void shrink_node_memcgs(pg_data_t
 
 		/* Record the group's reclaim efficiency */
 		if (!sc->proactive)
-			vmpressure(sc->gfp_mask, memcg, false,
+			vmpressure(sc->gfp_mask, sc->order, memcg, false,
 				   sc->nr_scanned - scanned,
 				   sc->nr_reclaimed - reclaimed);
 
@@ -6220,7 +6220,7 @@ again:
 
 	/* Record the subtree's reclaim efficiency */
 	if (!sc->proactive)
-		vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
+		vmpressure(sc->gfp_mask, sc->order, sc->target_mem_cgroup, true,
 			   sc->nr_scanned - nr_scanned, nr_node_reclaimed);
 
 	if (nr_node_reclaimed)
_

Patches currently in -mm which might be from jp.kobryn@linux.dev are

mm-compaction-cap-compact_gap-at-compact_cluster_max.patch

