Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F8AEFA3740
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 20:18:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbiJ0USS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 16:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235512AbiJ0USR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 16:18:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D7B8D233
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 13:18:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EC65B82638
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 20:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323AEC433D6;
        Thu, 27 Oct 2022 20:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666901889;
        bh=ZGRgIxmSoS7njs+KJ6Tvk3SUd7CeJ6ExT3f9E5cGsbk=;
        h=Date:To:From:Subject:From;
        b=OW2XS4X6fpsXCYJWrVwpJLHOBfKDfO8Dqz0fRMjJir8dBNOfBT98igYKgZd/a+oLq
         Vx7rriRsM8cMD6rNmufjJ0WpWF7hbNnaaow3z49mvtMTVSbrT2N4W5EDVgwxyyDJUO
         GEP6TZ9OzKIBQnBFHiGQL34QBivsj7GbEp95p0uc=
Date:   Thu, 27 Oct 2022 13:18:08 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shy828301@gmail.com, ebergen@meta.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-split-khugepaged-stats-from-direct-reclaim-stats.patch added to mm-unstable branch
Message-Id: <20221027201809.323AEC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: split khugepaged stats from direct reclaim stats
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-split-khugepaged-stats-from-direct-reclaim-stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-split-khugepaged-stats-from-direct-reclaim-stats.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
@@ -2528,6 +2528,11 @@ void khugepaged_min_free_kbytes_update(v
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
@@ -4859,7 +4875,7 @@ static int scan_folios(struct lruvec *lr
 			break;
 	}
 
-	item = current_is_kswapd() ? PGSCAN_KSWAPD : PGSCAN_DIRECT;
+	item = PGSCAN_KSWAPD + reclaimer_offset();
 	if (!cgroup_reclaim(sc)) {
 		__count_vm_events(item, isolated);
 		__count_vm_events(PGREFILL, sorted);
@@ -5017,7 +5033,7 @@ static int evict_folios(struct lruvec *l
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

mm-vmscan-make-rotations-a-secondary-factor-in-balancing-anon-vs-file.patch
mm-vmscan-split-khugepaged-stats-from-direct-reclaim-stats.patch
mm-vmscan-fix-extreme-overreclaim-and-swap-floods.patch

