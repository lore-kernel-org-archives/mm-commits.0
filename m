Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669AE3368B6
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622319; cv=none; b=pdnpoG7WIz5LStn/tIeQkhontyQGMv8AIjwb4N2MfvV2+2eeH1Ikh5DS5XVuCEl6Y/pMEk7aQfgY/fmh+2WTiT7/unihhO3ooY/vMns5ui7B80KEJRkr9dpbUso0GEfAxjkIQbzk5FhuK0zr+iXmhcm3APLrrv0ttw+XsaAvpBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622319; c=relaxed/simple;
	bh=BD+eo92A5GMqNNh9wmGGlZlJtHWV2NG44qq6AVQTLYk=;
	h=Date:To:From:Subject:Message-Id; b=WIxoh4d6J3MGKNtbmoWYkm3g2vMXSGzNUwycUilvHXhLFJxFOLkdMFXbviyOilBjOsMgRhJqeHA1eE48bevPg/z2GOMpiP6AsjPahRzbcoQaHO2ceGo0nMEOvb3AikJWx0IGxFhhG0Q/uwV33DsrIJGwm6zoU0N7644/hrkrhLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YSn4O2QM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YSn4O2QM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C9B1F00A3A;
	Tue, 25 Aug 2026 01:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622315;
	bh=HvWCEnbfanR4759Dk/8GIn7P+0cuRwOrsmC/pF/JyoM=;
	h=Date:To:From:Subject;
	b=YSn4O2QMRKq98JezXMlE205UUPhOmd191E2j1wkWPrGXcxrZ0JHF3ymu3SDA62QIc
	 oroXPeiScNMPjI+/M80arVGAPzYZvrNQMnCbNZlf4uJ0T5OP6fciX1ww54OZp/msG6
	 GLhW/HFOcVebytqOzVJnyeh5Jx9AmwD2RvDaFR5o=
Date: Mon, 24 Aug 2026 18:45:15 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,axelrasmussen@google.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-add-pgrotate_anon-and-pgrotate_file-vmstat-counters.patch removed from -mm tree
Message-Id: <20260825014515.D5C9B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: add pgrotate_anon and pgrotate_file vmstat counters
has been removed from the -mm tree.  Its filename was
     mm-vmscan-add-pgrotate_anon-and-pgrotate_file-vmstat-counters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm/vmscan: add pgrotate_anon and pgrotate_file vmstat counters
Date: Mon, 27 Jul 2026 09:23:24 -0700

Reclaim can spend substantial work on an LRU type without immediately
reclaiming or demoting a corresponding amount of memory.  Record this work
in PGROTATE_ANON and PGROTATE_FILE.

For classic LRU reclaim:

  - Inactive-list reclaim adds nr_scanned - nr_reclaimed to the
    corresponding anon/file counter when isolation succeeds.
  - Active-list reclaim adds referenced executable file folios that
    are retained on the active list to PGROTATE_FILE. Active anon
    reclaim does not contribute this component.

For MGLRU, add the number of initially isolated pages that remain
unreclaimed after both the initial and retry passes to the counter for the
selected anon/file type.

These counters are distinct from the existing pgrotated vm event. 
pgrotated records an actual move to the inactive-list tail, primarily
after reclaim-marked writeback completes or failed invalidation leaves a
folio for accelerated reclaim.  PGROTATE_ANON and PGROTATE_FILE measure
reclaim cost and do not imply that a folio moved to an LRU tail.

A subsequent patch will consume these counters for anon/file scan
balancing.

Link: https://lore.kernel.org/20260727162550.2032-3-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 mm/memcontrol.c        |    2 ++
 mm/vmscan.c            |   14 +++++++++++++-
 mm/vmstat.c            |    2 ++
 4 files changed, 19 insertions(+), 1 deletion(-)

--- a/include/linux/mmzone.h~mm-vmscan-add-pgrotate_anon-and-pgrotate_file-vmstat-counters
+++ a/include/linux/mmzone.h
@@ -323,6 +323,8 @@ enum node_stat_item {
 	PGSCAN_PROACTIVE,
 	PGSCAN_ANON,
 	PGSCAN_FILE,
+	PGROTATE_ANON,
+	PGROTATE_FILE,
 	PGREFILL,
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
--- a/mm/memcontrol.c~mm-vmscan-add-pgrotate_anon-and-pgrotate_file-vmstat-counters
+++ a/mm/memcontrol.c
@@ -425,6 +425,8 @@ static const unsigned int memcg_node_sta
 	PGSCAN_PROACTIVE,
 	PGSCAN_ANON,
 	PGSCAN_FILE,
+	PGROTATE_ANON,
+	PGROTATE_FILE,
 	PGREFILL,
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
--- a/mm/vmscan.c~mm-vmscan-add-pgrotate_anon-and-pgrotate_file-vmstat-counters
+++ a/mm/vmscan.c
@@ -2038,6 +2038,9 @@ static unsigned long shrink_inactive_lis
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
 	mod_lruvec_state(lruvec, item, nr_reclaimed);
 	mod_lruvec_state(lruvec, PGSTEAL_ANON + file, nr_reclaimed);
+	if (nr_scanned > nr_reclaimed)
+		mod_lruvec_state(lruvec, PGROTATE_ANON + file,
+				 nr_scanned - nr_reclaimed);
 
 	lruvec_lock_irq(lruvec);
 	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
@@ -2147,6 +2150,8 @@ static void shrink_active_list(unsigned
 	count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
 	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
+	if (nr_rotated)
+		mod_lruvec_state(lruvec, PGROTATE_ANON + file, nr_rotated);
 
 	lruvec_lock_irq(lruvec);
 	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
@@ -4828,7 +4833,8 @@ static int evict_folios(unsigned long nr
 	struct reclaim_stat stat;
 	struct lru_gen_mm_walk *walk;
 	int scanned, reclaimed;
-	int isolated = 0, type, type_scanned;
+	int isolated = 0, nr_isolated = 0, type, type_scanned;
+	unsigned long total_reclaimed = 0;
 	bool skip_retry = false;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
@@ -4840,6 +4846,7 @@ static int evict_folios(unsigned long nr
 
 	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
 				 &list, &isolated, &type, &type_scanned);
+	nr_isolated = isolated;
 
 	/* Scanning may have emptied the oldest gen, flush it */
 	if (scanned)
@@ -4852,6 +4859,7 @@ static int evict_folios(unsigned long nr
 retry:
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
 	sc->nr_reclaimed += reclaimed;
+	total_reclaimed += reclaimed;
 	/* Retry pass is only meant for clean folios without new isolation */
 	if (isolated)
 		handle_reclaim_writeback(isolated, pgdat, sc, &stat);
@@ -4903,6 +4911,10 @@ retry:
 		goto retry;
 	}
 
+	if (nr_isolated > total_reclaimed)
+		mod_lruvec_state(lruvec, PGROTATE_ANON + type,
+				 nr_isolated - total_reclaimed);
+
 	return scanned;
 }
 
--- a/mm/vmstat.c~mm-vmscan-add-pgrotate_anon-and-pgrotate_file-vmstat-counters
+++ a/mm/vmstat.c
@@ -1301,6 +1301,8 @@ const char * const vmstat_text[] = {
 	[I(PGSCAN_PROACTIVE)]			= "pgscan_proactive",
 	[I(PGSCAN_ANON)]			= "pgscan_anon",
 	[I(PGSCAN_FILE)]			= "pgscan_file",
+	[I(PGROTATE_ANON)]			= "pgrotate_anon",
+	[I(PGROTATE_FILE)]			= "pgrotate_file",
 	[I(PGREFILL)]				= "pgrefill",
 #ifdef CONFIG_HUGETLB_PAGE
 	[I(NR_HUGETLB)]				= "nr_hugetlb",
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-huge_memory-transfer-the-pmd-dirty-bit-to-the-folio-on-zap.patch

