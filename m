Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E085474F
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 00:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771546696; cv=none; b=Ti3GjpGR6r0HGahD7kPtGbNpdoZIvo8tMzQDWVIR/9hdsjC7HwV6zSLQ2ETDcMFloYGy05sLF5yWEu9DqNQFkgOT9eXox88ocPa74Jc13fmmqndST/Uecv4KPjXnObqYpRo1Zcjx5IER5gg+RPdtz39Qq9OTn0knikexcgGLbFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771546696; c=relaxed/simple;
	bh=T+HwYKxjWzkoFmPhO8yvlhZ97JBgOrgMNGFNpd5nLD0=;
	h=Date:To:From:Subject:Message-Id; b=XN1kQjvamJaEClNYhpOFqdm9FseVp4GDNjAVIqzleNADpNPOM15fc+HM49NtxtBG3zbrU5pQvGPCw5RwK+TYI7F3RgKja+XaUTfUmnL4ijDUxy16t0t9IpLlkc1Hxx8eovISbPR6CvXLGtBqhZWkdyWMxHRGmByGRFcN4YvVrtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wtTvZx0i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wtTvZx0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C351C116C6;
	Fri, 20 Feb 2026 00:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771546695;
	bh=T+HwYKxjWzkoFmPhO8yvlhZ97JBgOrgMNGFNpd5nLD0=;
	h=Date:To:From:Subject:From;
	b=wtTvZx0i3Bv27spnZxjas5IYMjF2WP4CkL4oaobVxVHME2CZOn/xXBweEex/TeiiP
	 qgz+cxz3Z5yQOPT976B3ZlftngbYLB371lPg1zcZciIpHmOTeGd3tAYAd4oTbhx/gE
	 W5pTTzotOBdGvoFtgh+XWEpIj1COkkz5W+VbLAFU=
Date: Thu, 19 Feb 2026 16:18:14 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,ying.huang@linux.alibaba.com,xuanzhuo@linux.alibaba.com,weixugc@google.com,vbabka@suse.cz,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,rakie.kim@sk.com,muchun.song@linux.dev,mst@redhat.com,mhocko@suse.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jasowang@redhat.com,hannes@cmpxchg.org,gourry@gourry.net,eperezma@redhat.com,david@kernel.org,byungchul@sk.com,axelrasmussen@google.com,apopple@nvidia.com,jp.kobryn@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-pgscan-pgsteal-pgrefill-to-node-stats.patch added to mm-new branch
Message-Id: <20260220001815.8C351C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: move pgscan, pgsteal, pgrefill to node stats
has been added to the -mm mm-new branch.  Its filename is
     mm-move-pgscan-pgsteal-pgrefill-to-node-stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-pgscan-pgsteal-pgrefill-to-node-stats.patch

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
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Subject: mm: move pgscan, pgsteal, pgrefill to node stats
Date: Thu, 19 Feb 2026 15:58:46 -0800

There are situations where reclaim kicks in on a system with free memory. 
One possible cause is a NUMA imbalance scenario where one or more nodes
are under pressure.  It would help if we could easily identify such nodes.

Move the pgscan, pgsteal, and pgrefill counters from vm_event_item to
node_stat_item to provide per-node reclaim visibility.  With these
counters as node stats, the values are now displayed in the per-node
section of /proc/zoneinfo, which allows for quick identification of the
affected nodes.

/proc/vmstat continues to report the same counters, aggregated across all
nodes.  But the ordering of these items within the readout changes as they
move from the vm events section to the node stats section.

Memcg accounting of these counters is preserved.  The relocated counters
remain visible in memory.stat alongside the existing aggregate pgscan and
pgsteal counters.

However, this change affects how the global counters are accumulated. 
Previously, the global event count update was gated on !cgroup_reclaim(),
excluding memcg-based reclaim from /proc/vmstat.  Now that
mod_lruvec_state() is being used to update the counters, the global
counters will include all reclaim.  This is consistent with how pgdemote
counters are already tracked.

Finally, the virtio_balloon driver is updated to use
global_node_page_state() to fetch the counters, as they are no longer
accessible through the vm_events array.

Link: https://lkml.kernel.org/r/20260219235846.161910-1-jp.kobryn@linux.dev
Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c |    8 ++--
 include/linux/mmzone.h          |   13 ++++++
 include/linux/vm_event_item.h   |   13 ------
 mm/memcontrol.c                 |   56 ++++++++++++++++++++----------
 mm/vmscan.c                     |   39 ++++++--------------
 mm/vmstat.c                     |   26 ++++++-------
 6 files changed, 82 insertions(+), 73 deletions(-)

--- a/drivers/virtio/virtio_balloon.c~mm-move-pgscan-pgsteal-pgrefill-to-node-stats
+++ a/drivers/virtio/virtio_balloon.c
@@ -369,13 +369,13 @@ static inline unsigned int update_balloo
 	update_stat(vb, idx++, VIRTIO_BALLOON_S_ALLOC_STALL, stall);
 
 	update_stat(vb, idx++, VIRTIO_BALLOON_S_ASYNC_SCAN,
-		    pages_to_bytes(events[PGSCAN_KSWAPD]));
+		    pages_to_bytes(global_node_page_state(PGSCAN_KSWAPD)));
 	update_stat(vb, idx++, VIRTIO_BALLOON_S_DIRECT_SCAN,
-		    pages_to_bytes(events[PGSCAN_DIRECT]));
+		    pages_to_bytes(global_node_page_state(PGSCAN_DIRECT)));
 	update_stat(vb, idx++, VIRTIO_BALLOON_S_ASYNC_RECLAIM,
-		    pages_to_bytes(events[PGSTEAL_KSWAPD]));
+		    pages_to_bytes(global_node_page_state(PGSTEAL_KSWAPD)));
 	update_stat(vb, idx++, VIRTIO_BALLOON_S_DIRECT_RECLAIM,
-		    pages_to_bytes(events[PGSTEAL_DIRECT]));
+		    pages_to_bytes(global_node_page_state(PGSTEAL_DIRECT)));
 
 #ifdef CONFIG_HUGETLB_PAGE
 	update_stat(vb, idx++, VIRTIO_BALLOON_S_HTLB_PGALLOC,
--- a/include/linux/mmzone.h~mm-move-pgscan-pgsteal-pgrefill-to-node-stats
+++ a/include/linux/mmzone.h
@@ -255,6 +255,19 @@ enum node_stat_item {
 	PGDEMOTE_DIRECT,
 	PGDEMOTE_KHUGEPAGED,
 	PGDEMOTE_PROACTIVE,
+	PGSTEAL_KSWAPD,
+	PGSTEAL_DIRECT,
+	PGSTEAL_KHUGEPAGED,
+	PGSTEAL_PROACTIVE,
+	PGSTEAL_ANON,
+	PGSTEAL_FILE,
+	PGSCAN_KSWAPD,
+	PGSCAN_DIRECT,
+	PGSCAN_KHUGEPAGED,
+	PGSCAN_PROACTIVE,
+	PGSCAN_ANON,
+	PGSCAN_FILE,
+	PGREFILL,
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
 #endif
--- a/include/linux/vm_event_item.h~mm-move-pgscan-pgsteal-pgrefill-to-node-stats
+++ a/include/linux/vm_event_item.h
@@ -38,21 +38,8 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		PGFREE, PGACTIVATE, PGDEACTIVATE, PGLAZYFREE,
 		PGFAULT, PGMAJFAULT,
 		PGLAZYFREED,
-		PGREFILL,
 		PGREUSE,
-		PGSTEAL_KSWAPD,
-		PGSTEAL_DIRECT,
-		PGSTEAL_KHUGEPAGED,
-		PGSTEAL_PROACTIVE,
-		PGSCAN_KSWAPD,
-		PGSCAN_DIRECT,
-		PGSCAN_KHUGEPAGED,
-		PGSCAN_PROACTIVE,
 		PGSCAN_DIRECT_THROTTLE,
-		PGSCAN_ANON,
-		PGSCAN_FILE,
-		PGSTEAL_ANON,
-		PGSTEAL_FILE,
 #ifdef CONFIG_NUMA
 		PGSCAN_ZONE_RECLAIM_SUCCESS,
 		PGSCAN_ZONE_RECLAIM_FAILED,
--- a/mm/memcontrol.c~mm-move-pgscan-pgsteal-pgrefill-to-node-stats
+++ a/mm/memcontrol.c
@@ -331,6 +331,19 @@ static const unsigned int memcg_node_sta
 	PGDEMOTE_DIRECT,
 	PGDEMOTE_KHUGEPAGED,
 	PGDEMOTE_PROACTIVE,
+	PGSTEAL_KSWAPD,
+	PGSTEAL_DIRECT,
+	PGSTEAL_KHUGEPAGED,
+	PGSTEAL_PROACTIVE,
+	PGSTEAL_ANON,
+	PGSTEAL_FILE,
+	PGSCAN_KSWAPD,
+	PGSCAN_DIRECT,
+	PGSCAN_KHUGEPAGED,
+	PGSCAN_PROACTIVE,
+	PGSCAN_ANON,
+	PGSCAN_FILE,
+	PGREFILL,
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
 #endif
@@ -444,17 +457,8 @@ static const unsigned int memcg_vm_event
 #endif
 	PSWPIN,
 	PSWPOUT,
-	PGSCAN_KSWAPD,
-	PGSCAN_DIRECT,
-	PGSCAN_KHUGEPAGED,
-	PGSCAN_PROACTIVE,
-	PGSTEAL_KSWAPD,
-	PGSTEAL_DIRECT,
-	PGSTEAL_KHUGEPAGED,
-	PGSTEAL_PROACTIVE,
 	PGFAULT,
 	PGMAJFAULT,
-	PGREFILL,
 	PGACTIVATE,
 	PGDEACTIVATE,
 	PGLAZYFREE,
@@ -1401,6 +1405,15 @@ static const struct memory_stat memory_s
 	{ "pgdemote_direct",		PGDEMOTE_DIRECT		},
 	{ "pgdemote_khugepaged",	PGDEMOTE_KHUGEPAGED	},
 	{ "pgdemote_proactive",		PGDEMOTE_PROACTIVE	},
+	{ "pgsteal_kswapd",		PGSTEAL_KSWAPD		},
+	{ "pgsteal_direct",		PGSTEAL_DIRECT		},
+	{ "pgsteal_khugepaged",		PGSTEAL_KHUGEPAGED	},
+	{ "pgsteal_proactive",		PGSTEAL_PROACTIVE	},
+	{ "pgscan_kswapd",		PGSCAN_KSWAPD		},
+	{ "pgscan_direct",		PGSCAN_DIRECT		},
+	{ "pgscan_khugepaged",		PGSCAN_KHUGEPAGED	},
+	{ "pgscan_proactive",		PGSCAN_PROACTIVE	},
+	{ "pgrefill",			PGREFILL		},
 #ifdef CONFIG_NUMA_BALANCING
 	{ "pgpromote_success",		PGPROMOTE_SUCCESS	},
 #endif
@@ -1444,6 +1457,15 @@ static int memcg_page_state_output_unit(
 	case PGDEMOTE_DIRECT:
 	case PGDEMOTE_KHUGEPAGED:
 	case PGDEMOTE_PROACTIVE:
+	case PGSTEAL_KSWAPD:
+	case PGSTEAL_DIRECT:
+	case PGSTEAL_KHUGEPAGED:
+	case PGSTEAL_PROACTIVE:
+	case PGSCAN_KSWAPD:
+	case PGSCAN_DIRECT:
+	case PGSCAN_KHUGEPAGED:
+	case PGSCAN_PROACTIVE:
+	case PGREFILL:
 #ifdef CONFIG_NUMA_BALANCING
 	case PGPROMOTE_SUCCESS:
 #endif
@@ -1562,15 +1584,15 @@ static void memcg_stat_format(struct mem
 
 	/* Accumulated memory events */
 	memcg_seq_buf_print_stat(s, NULL, "pgscan", ' ',
-				 memcg_events(memcg, PGSCAN_KSWAPD) +
-				 memcg_events(memcg, PGSCAN_DIRECT) +
-				 memcg_events(memcg, PGSCAN_PROACTIVE) +
-				 memcg_events(memcg, PGSCAN_KHUGEPAGED));
+				 memcg_page_state(memcg, PGSCAN_KSWAPD) +
+				 memcg_page_state(memcg, PGSCAN_DIRECT) +
+				 memcg_page_state(memcg, PGSCAN_PROACTIVE) +
+				 memcg_page_state(memcg, PGSCAN_KHUGEPAGED));
 	memcg_seq_buf_print_stat(s, NULL, "pgsteal", ' ',
-				 memcg_events(memcg, PGSTEAL_KSWAPD) +
-				 memcg_events(memcg, PGSTEAL_DIRECT) +
-				 memcg_events(memcg, PGSTEAL_PROACTIVE) +
-				 memcg_events(memcg, PGSTEAL_KHUGEPAGED));
+				 memcg_page_state(memcg, PGSTEAL_KSWAPD) +
+				 memcg_page_state(memcg, PGSTEAL_DIRECT) +
+				 memcg_page_state(memcg, PGSTEAL_PROACTIVE) +
+				 memcg_page_state(memcg, PGSTEAL_KHUGEPAGED));
 
 	for (i = 0; i < ARRAY_SIZE(memcg_vm_event_stat); i++) {
 #ifdef CONFIG_MEMCG_V1
--- a/mm/vmscan.c~mm-move-pgscan-pgsteal-pgrefill-to-node-stats
+++ a/mm/vmscan.c
@@ -1984,7 +1984,7 @@ static unsigned long shrink_inactive_lis
 	unsigned long nr_taken;
 	struct reclaim_stat stat;
 	bool file = is_file_lru(lru);
-	enum vm_event_item item;
+	enum node_stat_item item;
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	bool stalled = false;
 
@@ -2010,10 +2010,8 @@ static unsigned long shrink_inactive_lis
 
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, nr_taken);
 	item = PGSCAN_KSWAPD + reclaimer_offset(sc);
-	if (!cgroup_reclaim(sc))
-		__count_vm_events(item, nr_scanned);
-	count_memcg_events(lruvec_memcg(lruvec), item, nr_scanned);
-	__count_vm_events(PGSCAN_ANON + file, nr_scanned);
+	mod_lruvec_state(lruvec, item, nr_scanned);
+	mod_lruvec_state(lruvec, PGSCAN_ANON + file, nr_scanned);
 
 	spin_unlock_irq(&lruvec->lru_lock);
 
@@ -2030,10 +2028,8 @@ static unsigned long shrink_inactive_lis
 					stat.nr_demoted);
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
-	if (!cgroup_reclaim(sc))
-		__count_vm_events(item, nr_reclaimed);
-	count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
-	__count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
+	mod_lruvec_state(lruvec, item, nr_reclaimed);
+	mod_lruvec_state(lruvec, PGSTEAL_ANON + file, nr_reclaimed);
 
 	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
 					nr_scanned - nr_reclaimed);
@@ -2120,9 +2116,7 @@ static void shrink_active_list(unsigned
 
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, nr_taken);
 
-	if (!cgroup_reclaim(sc))
-		__count_vm_events(PGREFILL, nr_scanned);
-	count_memcg_events(lruvec_memcg(lruvec), PGREFILL, nr_scanned);
+	mod_lruvec_state(lruvec, PGREFILL, nr_scanned);
 
 	spin_unlock_irq(&lruvec->lru_lock);
 
@@ -4542,7 +4536,7 @@ static int scan_folios(unsigned long nr_
 {
 	int i;
 	int gen;
-	enum vm_event_item item;
+	enum node_stat_item item;
 	int sorted = 0;
 	int scanned = 0;
 	int isolated = 0;
@@ -4550,7 +4544,6 @@ static int scan_folios(unsigned long nr_
 	int scan_batch = min(nr_to_scan, MAX_LRU_BATCH);
 	int remaining = scan_batch;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
 	VM_WARN_ON_ONCE(!list_empty(list));
 
@@ -4601,13 +4594,9 @@ static int scan_folios(unsigned long nr_
 	}
 
 	item = PGSCAN_KSWAPD + reclaimer_offset(sc);
-	if (!cgroup_reclaim(sc)) {
-		__count_vm_events(item, isolated);
-		__count_vm_events(PGREFILL, sorted);
-	}
-	count_memcg_events(memcg, item, isolated);
-	count_memcg_events(memcg, PGREFILL, sorted);
-	__count_vm_events(PGSCAN_ANON + type, isolated);
+	mod_lruvec_state(lruvec, item, isolated);
+	mod_lruvec_state(lruvec, PGREFILL, sorted);
+	mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batch,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
@@ -4692,7 +4681,7 @@ static int evict_folios(unsigned long nr
 	LIST_HEAD(clean);
 	struct folio *folio;
 	struct folio *next;
-	enum vm_event_item item;
+	enum node_stat_item item;
 	struct reclaim_stat stat;
 	struct lru_gen_mm_walk *walk;
 	bool skip_retry = false;
@@ -4756,10 +4745,8 @@ retry:
 					stat.nr_demoted);
 
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
-	if (!cgroup_reclaim(sc))
-		__count_vm_events(item, reclaimed);
-	count_memcg_events(memcg, item, reclaimed);
-	__count_vm_events(PGSTEAL_ANON + type, reclaimed);
+	mod_lruvec_state(lruvec, item, reclaimed);
+	mod_lruvec_state(lruvec, PGSTEAL_ANON + type, reclaimed);
 
 	spin_unlock_irq(&lruvec->lru_lock);
 
--- a/mm/vmstat.c~mm-move-pgscan-pgsteal-pgrefill-to-node-stats
+++ a/mm/vmstat.c
@@ -1276,6 +1276,19 @@ const char * const vmstat_text[] = {
 	[I(PGDEMOTE_DIRECT)]			= "pgdemote_direct",
 	[I(PGDEMOTE_KHUGEPAGED)]		= "pgdemote_khugepaged",
 	[I(PGDEMOTE_PROACTIVE)]			= "pgdemote_proactive",
+	[I(PGSTEAL_KSWAPD)]			= "pgsteal_kswapd",
+	[I(PGSTEAL_DIRECT)]			= "pgsteal_direct",
+	[I(PGSTEAL_KHUGEPAGED)]			= "pgsteal_khugepaged",
+	[I(PGSTEAL_PROACTIVE)]			= "pgsteal_proactive",
+	[I(PGSTEAL_ANON)]			= "pgsteal_anon",
+	[I(PGSTEAL_FILE)]			= "pgsteal_file",
+	[I(PGSCAN_KSWAPD)]			= "pgscan_kswapd",
+	[I(PGSCAN_DIRECT)]			= "pgscan_direct",
+	[I(PGSCAN_KHUGEPAGED)]			= "pgscan_khugepaged",
+	[I(PGSCAN_PROACTIVE)]			= "pgscan_proactive",
+	[I(PGSCAN_ANON)]			= "pgscan_anon",
+	[I(PGSCAN_FILE)]			= "pgscan_file",
+	[I(PGREFILL)]				= "pgrefill",
 #ifdef CONFIG_HUGETLB_PAGE
 	[I(NR_HUGETLB)]				= "nr_hugetlb",
 #endif
@@ -1318,21 +1331,8 @@ const char * const vmstat_text[] = {
 	[I(PGMAJFAULT)]				= "pgmajfault",
 	[I(PGLAZYFREED)]			= "pglazyfreed",
 
-	[I(PGREFILL)]				= "pgrefill",
 	[I(PGREUSE)]				= "pgreuse",
-	[I(PGSTEAL_KSWAPD)]			= "pgsteal_kswapd",
-	[I(PGSTEAL_DIRECT)]			= "pgsteal_direct",
-	[I(PGSTEAL_KHUGEPAGED)]			= "pgsteal_khugepaged",
-	[I(PGSTEAL_PROACTIVE)]			= "pgsteal_proactive",
-	[I(PGSCAN_KSWAPD)]			= "pgscan_kswapd",
-	[I(PGSCAN_DIRECT)]			= "pgscan_direct",
-	[I(PGSCAN_KHUGEPAGED)]			= "pgscan_khugepaged",
-	[I(PGSCAN_PROACTIVE)]			= "pgscan_proactive",
 	[I(PGSCAN_DIRECT_THROTTLE)]		= "pgscan_direct_throttle",
-	[I(PGSCAN_ANON)]			= "pgscan_anon",
-	[I(PGSCAN_FILE)]			= "pgscan_file",
-	[I(PGSTEAL_ANON)]			= "pgsteal_anon",
-	[I(PGSTEAL_FILE)]			= "pgsteal_file",
 
 #ifdef CONFIG_NUMA
 	[I(PGSCAN_ZONE_RECLAIM_SUCCESS)]	= "zone_reclaim_success",
_

Patches currently in -mm which might be from jp.kobryn@linux.dev are

mm-move-pgscan-pgsteal-pgrefill-to-node-stats.patch

