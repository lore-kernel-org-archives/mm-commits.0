Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F22C47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiLAAAl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiLAAAY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E671837FB
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28E6961E6E
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605B1C433B5;
        Thu,  1 Dec 2022 00:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852819;
        bh=vW5OZkUlZOKb+dTdp9a2iOyQoANABkW+c7vQzsNpbUE=;
        h=Date:To:From:Subject:From;
        b=IN8aU2a1Ooj1KFblOHOzZG7Vg5ldOAQEl/ylTUz7Np9+u+PU087H24TCnfjeT9vqU
         ySZfxwa4qxssbXI1KmodjRAsLKH3HGW5mBB5cY8eZlUoNLi0cu3ayWGw+0TxtiLrN3
         44gVGuj8ctAatKY65nztmY+/a9dMhQxWJ+igoCCE=
Date:   Wed, 30 Nov 2022 16:00:18 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        willy@infradead.org, shy828301@gmail.com, ebergen@meta.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-split-khugepaged-stats-from-direct-reclaim-stats.patch removed from -mm tree
Message-Id: <20221201000019.605B1C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: vmscan: split khugepaged stats from direct reclaim stats
has been removed from the -mm tree.  Its filename was
     mm-vmscan-split-khugepaged-stats-from-direct-reclaim-stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: split khugepaged stats from direct reclaim stats
Date: Wed, 26 Oct 2022 14:01:33 -0400

Direct reclaim stats are useful for identifying a potential source for
application latency, as well as spotting issues with kswapd.  However,
khugepaged currently distorts the picture: as a kernel thread it doesn't
impose allocation latencies on userspace, and it explicitly opts out of
kswapd reclaim.  Its activity showing up in the direct reclaim stats is
misleading.  Counting it as kswapd reclaim could also cause confusion when
trying to understand actual kswapd behavior.

Break out khugepaged from the direct reclaim counters into new
pgsteal_khugepaged, pgdemote_khugepaged, pgscan_khugepaged counters.

Test with a huge executable (CONFIG_READ_ONLY_THP_FOR_FS):

pgsteal_kswapd 1342185
pgsteal_direct 0
pgsteal_khugepaged 3623
pgscan_kswapd 1345025
pgscan_direct 0
pgscan_khugepaged 3623

Link: https://lkml.kernel.org/r/20221026180133.377671-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Eric Bergen <ebergen@meta.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    6 ++++
 include/linux/khugepaged.h              |    6 ++++
 include/linux/vm_event_item.h           |    3 ++
 mm/khugepaged.c                         |    5 +++
 mm/memcontrol.c                         |    8 ++++-
 mm/vmscan.c                             |   32 ++++++++++++++++------
 mm/vmstat.c                             |    3 ++
 7 files changed, 53 insertions(+), 10 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-vmscan-split-khugepaged-stats-from-direct-reclaim-stats
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1488,12 +1488,18 @@ PAGE_SIZE multiple when read back.
 	  pgscan_direct (npn)
 		Amount of scanned pages directly  (in an inactive LRU list)
 
+	  pgscan_khugepaged (npn)
+		Amount of scanned pages by khugepaged  (in an inactive LRU list)
+
 	  pgsteal_kswapd (npn)
 		Amount of reclaimed pages by kswapd
 
 	  pgsteal_direct (npn)
 		Amount of reclaimed pages directly
 
+	  pgsteal_khugepaged (npn)
+		Amount of reclaimed pages by khugepaged
+
 	  pgfault (npn)
 		Total number of page faults incurred
 
--- a/include/linux/khugepaged.h~mm-vmscan-split-khugepaged-stats-from-direct-reclaim-stats
+++ a/include/linux/khugepaged.h
@@ -15,6 +15,7 @@ extern void __khugepaged_exit(struct mm_
 extern void khugepaged_enter_vma(struct vm_area_struct *vma,
 				 unsigned long vm_flags);
 extern void khugepaged_min_free_kbytes_update(void);
+extern bool current_is_khugepaged(void);
 #ifdef CONFIG_SHMEM
 extern int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 				   bool install_pmd);
@@ -57,6 +58,11 @@ static inline int collapse_pte_mapped_th
 static inline void khugepaged_min_free_kbytes_update(void)
 {
 }
+
+static inline bool current_is_khugepaged(void)
+{
+	return false;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #endif /* _LINUX_KHUGEPAGED_H */
--- a/include/linux/vm_event_item.h~mm-vmscan-split-khugepaged-stats-from-direct-reclaim-stats
+++ a/include/linux/vm_event_item.h
@@ -40,10 +40,13 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		PGREUSE,
 		PGSTEAL_KSWAPD,
 		PGSTEAL_DIRECT,
+		PGSTEAL_KHUGEPAGED,
 		PGDEMOTE_KSWAPD,
 		PGDEMOTE_DIRECT,
+		PGDEMOTE_KHUGEPAGED,
 		PGSCAN_KSWAPD,
 		PGSCAN_DIRECT,
+		PGSCAN_KHUGEPAGED,
 		PGSCAN_DIRECT_THROTTLE,
 		PGSCAN_ANON,
 		PGSCAN_FILE,
--- a/mm/khugepaged.c~mm-vmscan-split-khugepaged-stats-from-direct-reclaim-stats
+++ a/mm/khugepaged.c
@@ -2577,6 +2577,11 @@ void khugepaged_min_free_kbytes_update(v
 	mutex_unlock(&khugepaged_mutex);
 }
 
+bool current_is_khugepaged(void)
+{
+	return kthread_func(current) == khugepaged;
+}
+
 static int madvise_collapse_errno(enum scan_result r)
 {
 	/*
--- a/mm/memcontrol.c~mm-vmscan-split-khugepaged-stats-from-direct-reclaim-stats
+++ a/mm/memcontrol.c
@@ -661,8 +661,10 @@ static const unsigned int memcg_vm_event
 	PGPGOUT,
 	PGSCAN_KSWAPD,
 	PGSCAN_DIRECT,
+	PGSCAN_KHUGEPAGED,
 	PGSTEAL_KSWAPD,
 	PGSTEAL_DIRECT,
+	PGSTEAL_KHUGEPAGED,
 	PGFAULT,
 	PGMAJFAULT,
 	PGREFILL,
@@ -1574,10 +1576,12 @@ static void memory_stat_format(struct me
 	/* Accumulated memory events */
 	seq_buf_printf(&s, "pgscan %lu\n",
 		       memcg_events(memcg, PGSCAN_KSWAPD) +
-		       memcg_events(memcg, PGSCAN_DIRECT));
+		       memcg_events(memcg, PGSCAN_DIRECT) +
+		       memcg_events(memcg, PGSCAN_KHUGEPAGED));
 	seq_buf_printf(&s, "pgsteal %lu\n",
 		       memcg_events(memcg, PGSTEAL_KSWAPD) +
-		       memcg_events(memcg, PGSTEAL_DIRECT));
+		       memcg_events(memcg, PGSTEAL_DIRECT) +
+		       memcg_events(memcg, PGSTEAL_KHUGEPAGED));
 
 	for (i = 0; i < ARRAY_SIZE(memcg_vm_event_stat); i++) {
 		if (memcg_vm_event_stat[i] == PGPGIN ||
--- a/mm/vmscan.c~mm-vmscan-split-khugepaged-stats-from-direct-reclaim-stats
+++ a/mm/vmscan.c
@@ -54,6 +54,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/ctype.h>
 #include <linux/debugfs.h>
+#include <linux/khugepaged.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -1047,6 +1048,24 @@ void drop_slab(void)
 		drop_slab_node(nid);
 }
 
+static int reclaimer_offset(void)
+{
+	BUILD_BUG_ON(PGSTEAL_DIRECT - PGSTEAL_KSWAPD !=
+			PGDEMOTE_DIRECT - PGDEMOTE_KSWAPD);
+	BUILD_BUG_ON(PGSTEAL_DIRECT - PGSTEAL_KSWAPD !=
+			PGSCAN_DIRECT - PGSCAN_KSWAPD);
+	BUILD_BUG_ON(PGSTEAL_KHUGEPAGED - PGSTEAL_KSWAPD !=
+			PGDEMOTE_KHUGEPAGED - PGDEMOTE_KSWAPD);
+	BUILD_BUG_ON(PGSTEAL_KHUGEPAGED - PGSTEAL_KSWAPD !=
+			PGSCAN_KHUGEPAGED - PGSCAN_KSWAPD);
+
+	if (current_is_kswapd())
+		return 0;
+	if (current_is_khugepaged())
+		return PGSTEAL_KHUGEPAGED - PGSTEAL_KSWAPD;
+	return PGSTEAL_DIRECT - PGSTEAL_KSWAPD;
+}
+
 static inline int is_page_cache_freeable(struct folio *folio)
 {
 	/*
@@ -1599,10 +1618,7 @@ static unsigned int demote_folio_list(st
 		      (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
 		      &nr_succeeded);
 
-	if (current_is_kswapd())
-		__count_vm_events(PGDEMOTE_KSWAPD, nr_succeeded);
-	else
-		__count_vm_events(PGDEMOTE_DIRECT, nr_succeeded);
+	__count_vm_events(PGDEMOTE_KSWAPD + reclaimer_offset(), nr_succeeded);
 
 	return nr_succeeded;
 }
@@ -2475,7 +2491,7 @@ static unsigned long shrink_inactive_lis
 				     &nr_scanned, sc, lru);
 
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, nr_taken);
-	item = current_is_kswapd() ? PGSCAN_KSWAPD : PGSCAN_DIRECT;
+	item = PGSCAN_KSWAPD + reclaimer_offset();
 	if (!cgroup_reclaim(sc))
 		__count_vm_events(item, nr_scanned);
 	__count_memcg_events(lruvec_memcg(lruvec), item, nr_scanned);
@@ -2492,7 +2508,7 @@ static unsigned long shrink_inactive_lis
 	move_folios_to_lru(lruvec, &folio_list);
 
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
-	item = current_is_kswapd() ? PGSTEAL_KSWAPD : PGSTEAL_DIRECT;
+	item = PGSTEAL_KSWAPD + reclaimer_offset();
 	if (!cgroup_reclaim(sc))
 		__count_vm_events(item, nr_reclaimed);
 	__count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
@@ -4871,7 +4887,7 @@ static int scan_folios(struct lruvec *lr
 			break;
 	}
 
-	item = current_is_kswapd() ? PGSCAN_KSWAPD : PGSCAN_DIRECT;
+	item = PGSCAN_KSWAPD + reclaimer_offset();
 	if (!cgroup_reclaim(sc)) {
 		__count_vm_events(item, isolated);
 		__count_vm_events(PGREFILL, sorted);
@@ -5049,7 +5065,7 @@ retry:
 	if (walk && walk->batched)
 		reset_batch_size(lruvec, walk);
 
-	item = current_is_kswapd() ? PGSTEAL_KSWAPD : PGSTEAL_DIRECT;
+	item = PGSTEAL_KSWAPD + reclaimer_offset();
 	if (!cgroup_reclaim(sc))
 		__count_vm_events(item, reclaimed);
 	__count_memcg_events(memcg, item, reclaimed);
--- a/mm/vmstat.c~mm-vmscan-split-khugepaged-stats-from-direct-reclaim-stats
+++ a/mm/vmstat.c
@@ -1271,10 +1271,13 @@ const char * const vmstat_text[] = {
 	"pgreuse",
 	"pgsteal_kswapd",
 	"pgsteal_direct",
+	"pgsteal_khugepaged",
 	"pgdemote_kswapd",
 	"pgdemote_direct",
+	"pgdemote_khugepaged",
 	"pgscan_kswapd",
 	"pgscan_direct",
+	"pgscan_khugepaged",
 	"pgscan_direct_throttle",
 	"pgscan_anon",
 	"pgscan_file",
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

zswap-fix-writeback-lock-ordering-for-zsmalloc.patch
zpool-clean-out-dead-code.patch

