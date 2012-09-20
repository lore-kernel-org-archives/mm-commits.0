From: akpm@linux-foundation.org
Subject: + memory-hotplug-fix-zone-stat-mismatch.patch added to -mm tree
Date: Thu, 20 Sep 2012 14:42:05 -0700
Message-ID: <20120920214205.BD672100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:33230 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab2ITVmH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Sep 2012 17:42:07 -0400
Received: by ggnq2 with SMTP id q2so131089ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 20 Sep 2012 14:42:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, isimatu.yasuaki@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, wency@cn.fujitsu.com


The patch titled
     Subject: memory-hotplug: fix zone stat mismatch
has been added to the -mm tree.  Its filename is
     memory-hotplug-fix-zone-stat-mismatch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: memory-hotplug: fix zone stat mismatch

During memory-hotplug, I found NR_ISOLATED_[ANON|FILE] are increasing,
causing the kernel to hang.  When the system doesn't have enough free
pages, it enters reclaim but never reclaim any pages due to
too_many_isolated()==true and loops forever.

The cause is that when we do memory-hotadd after memory-remove,
__zone_pcp_update() clears a zone's ZONE_STAT_ITEMS in setup_pageset()
although the vm_stat_diff of all CPUs still have values.

In addtion, when we offline all pages of the zone, we reset them in
zone_pcp_reset without draining so we loss some zone stat item.

Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    4 ++++
 mm/page_alloc.c        |    7 +++++++
 mm/vmstat.c            |   12 ++++++++++++
 3 files changed, 23 insertions(+)

diff -puN include/linux/vmstat.h~memory-hotplug-fix-zone-stat-mismatch include/linux/vmstat.h
--- a/include/linux/vmstat.h~memory-hotplug-fix-zone-stat-mismatch
+++ a/include/linux/vmstat.h
@@ -198,6 +198,8 @@ extern void __dec_zone_state(struct zone
 void refresh_cpu_vm_stats(int);
 void refresh_zone_stat_thresholds(void);
 
+void drain_zonestat(struct zone *zone, struct per_cpu_pageset *);
+
 int calculate_pressure_threshold(struct zone *zone);
 int calculate_normal_threshold(struct zone *zone);
 void set_pgdat_percpu_threshold(pg_data_t *pgdat,
@@ -251,6 +253,8 @@ static inline void __dec_zone_page_state
 static inline void refresh_cpu_vm_stats(int cpu) { }
 static inline void refresh_zone_stat_thresholds(void) { }
 
+static inline void drain_zonestat(struct zone *zone,
+			struct per_cpu_pageset *pset) { }
 #endif		/* CONFIG_SMP */
 
 static inline void __mod_zone_freepage_state(struct zone *zone, int nr_pages,
diff -puN mm/page_alloc.c~memory-hotplug-fix-zone-stat-mismatch mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-fix-zone-stat-mismatch
+++ a/mm/page_alloc.c
@@ -5908,6 +5908,7 @@ static int __meminit __zone_pcp_update(v
 		local_irq_save(flags);
 		if (pcp->count > 0)
 			free_pcppages_bulk(zone, pcp->count, pcp);
+		drain_zonestat(zone, pset);
 		setup_pageset(pset, batch);
 		local_irq_restore(flags);
 	}
@@ -5924,10 +5925,16 @@ void __meminit zone_pcp_update(struct zo
 void zone_pcp_reset(struct zone *zone)
 {
 	unsigned long flags;
+	int cpu;
+	struct per_cpu_pageset *pset;
 
 	/* avoid races with drain_pages()  */
 	local_irq_save(flags);
 	if (zone->pageset != &boot_pageset) {
+		for_each_online_cpu(cpu) {
+			pset = per_cpu_ptr(zone->pageset, cpu);
+			drain_zonestat(zone, pset);
+		}
 		free_percpu(zone->pageset);
 		zone->pageset = &boot_pageset;
 	}
diff -puN mm/vmstat.c~memory-hotplug-fix-zone-stat-mismatch mm/vmstat.c
--- a/mm/vmstat.c~memory-hotplug-fix-zone-stat-mismatch
+++ a/mm/vmstat.c
@@ -495,6 +495,18 @@ void refresh_cpu_vm_stats(int cpu)
 			atomic_long_add(global_diff[i], &vm_stat[i]);
 }
 
+void drain_zonestat(struct zone *zone, struct per_cpu_pageset *pset)
+{
+	int i;
+
+	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
+		if (pset->vm_stat_diff[i]) {
+			int v = pset->vm_stat_diff[i];
+			pset->vm_stat_diff[i] = 0;
+			atomic_long_add(v, &zone->vm_stat[i]);
+			atomic_long_add(v, &vm_stat[i]);
+		}
+}
 #endif
 
 #ifdef CONFIG_NUMA
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
linux-next.patch
mm-remove-__gfp_no_kswapd.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch
mm-fix-tracing-in-free_pcppages_bulk.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-fix-counting-of-isolated-pages.patch
cma-count-free-cma-pages.patch
cma-count-free-cma-pages-fix.patch
cma-fix-watermark-checking.patch
mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch
mm-remain-migratetype-in-freed-page.patch
memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-memblock-reduce-overhead-in-binary-search.patch
mm-memblock-use-existing-interface-to-set-nid.patch
mm-memblock-cleanup-early_node_map-related-comments.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-compaction-check-lock-contention-first-before-taking-lock.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
memory-hotplug-dont-replace-lowmem-pages-with-highmem.patch
mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch
mm-enable-config_compaction-by-default.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range.patch
trace-events-kmem-dont-call-page_to_pfn-if-page-is-null.patch
memory-hotplug-fix-zone-stat-mismatch.patch

