Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57477C47087
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 23:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3809960FDC
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 23:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbhEYXoe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 May 2021 19:44:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231356AbhEYXoe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 May 2021 19:44:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A0316140E;
        Tue, 25 May 2021 23:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621986183;
        bh=pq/RPuYkjSXVX53RESnsGflF/xaM46dUWm5EvJv8WoU=;
        h=Date:From:To:Subject:From;
        b=u/9RPUWBAszfDYnTC75ytdSMv+6AYbg8JMl0R2qxOD9UlgvEKanxReu5GZAtNfd2d
         cug4aHFUtpN/RFiAbOG90G0pHRqcPb9cp5XLK0Ky4bpJccceKuBYEfGpORv/yItsRu
         siDcnTaA4zGDwQrT4z5LvxOV2nadtqKMv/NaIDkw=
Date:   Tue, 25 May 2021 16:43:02 -0700
From:   akpm@linux-foundation.org
To:     dave.hansen@linux.intel.com, hdanton@sina.com,
        mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  +
 mm-page_alloc-adjust-pcp-high-after-cpu-hotplug-events.patch added to -mm
 tree
Message-ID: <20210525234302.CnUZpxhdP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: adjust pcp->high after CPU hotplug events
has been added to the -mm tree.  Its filename is
     mm-page_alloc-adjust-pcp-high-after-cpu-hotplug-events.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-adjust-pcp-high-after-cpu-hotplug-events.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-adjust-pcp-high-after-cpu-hotplug-events.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: adjust pcp->high after CPU hotplug events

The PCP high watermark is based on the number of online CPUs so the
watermarks must be adjusted during CPU hotplug.  At the time of
hot-remove, the number of online CPUs is already adjusted but during
hot-add, a delta needs to be applied to update PCP to the correct value. 
After this patch is applied, the high watermarks are adjusted correctly.

  # grep high: /proc/zoneinfo  | tail -1
              high:  649
  # echo 0 > /sys/devices/system/cpu/cpu4/online
  # grep high: /proc/zoneinfo  | tail -1
              high:  664
  # echo 1 > /sys/devices/system/cpu/cpu4/online
  # grep high: /proc/zoneinfo  | tail -1
              high:  649

Link: https://lkml.kernel.org/r/20210525080119.5455-4-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuhotplug.h |    2 -
 mm/internal.h              |    2 -
 mm/memory_hotplug.c        |    4 +--
 mm/page_alloc.c            |   38 ++++++++++++++++++++++++-----------
 4 files changed, 31 insertions(+), 15 deletions(-)

--- a/include/linux/cpuhotplug.h~mm-page_alloc-adjust-pcp-high-after-cpu-hotplug-events
+++ a/include/linux/cpuhotplug.h
@@ -54,7 +54,7 @@ enum cpuhp_state {
 	CPUHP_MM_MEMCQ_DEAD,
 	CPUHP_PERCPU_CNT_DEAD,
 	CPUHP_RADIX_DEAD,
-	CPUHP_PAGE_ALLOC_DEAD,
+	CPUHP_PAGE_ALLOC,
 	CPUHP_NET_DEV_DEAD,
 	CPUHP_PCI_XGENE_DEAD,
 	CPUHP_IOMMU_IOVA_DEAD,
--- a/mm/internal.h~mm-page_alloc-adjust-pcp-high-after-cpu-hotplug-events
+++ a/mm/internal.h
@@ -206,7 +206,7 @@ extern int user_min_free_kbytes;
 extern void free_unref_page(struct page *page);
 extern void free_unref_page_list(struct list_head *list);
 
-extern void zone_pcp_update(struct zone *zone);
+extern void zone_pcp_update(struct zone *zone, int cpu_online);
 extern void zone_pcp_reset(struct zone *zone);
 extern void zone_pcp_disable(struct zone *zone);
 extern void zone_pcp_enable(struct zone *zone);
--- a/mm/memory_hotplug.c~mm-page_alloc-adjust-pcp-high-after-cpu-hotplug-events
+++ a/mm/memory_hotplug.c
@@ -961,7 +961,7 @@ int __ref online_pages(unsigned long pfn
 	node_states_set_node(nid, &arg);
 	if (need_zonelists_rebuild)
 		build_all_zonelists(NULL);
-	zone_pcp_update(zone);
+	zone_pcp_update(zone, 0);
 
 	/* Basic onlining is complete, allow allocation of onlined pages. */
 	undo_isolate_page_range(pfn, pfn + nr_pages, MIGRATE_MOVABLE);
@@ -1835,7 +1835,7 @@ int __ref offline_pages(unsigned long st
 		zone_pcp_reset(zone);
 		build_all_zonelists(NULL);
 	} else
-		zone_pcp_update(zone);
+		zone_pcp_update(zone, 0);
 
 	node_states_clear_node(node, &arg);
 	if (arg.status_change_nid >= 0) {
--- a/mm/page_alloc.c~mm-page_alloc-adjust-pcp-high-after-cpu-hotplug-events
+++ a/mm/page_alloc.c
@@ -6631,7 +6631,7 @@ static int zone_batchsize(struct zone *z
 #endif
 }
 
-static int zone_highsize(struct zone *zone, int batch)
+static int zone_highsize(struct zone *zone, int batch, int cpu_online)
 {
 #ifdef CONFIG_MMU
 	int high;
@@ -6642,9 +6642,10 @@ static int zone_highsize(struct zone *zo
 	 * so that if they are full then background reclaim will not be
 	 * started prematurely. The value is split across all online CPUs
 	 * local to the zone. Note that early in boot that CPUs may not be
-	 * online yet.
+	 * online yet and that during CPU hotplug that the cpumask is not
+	 * yet updated when a CPU is being onlined.
 	 */
-	nr_local_cpus = max(1U, cpumask_weight(cpumask_of_node(zone_to_nid(zone))));
+	nr_local_cpus = max(1U, cpumask_weight(cpumask_of_node(zone_to_nid(zone)))) + cpu_online;
 	high = low_wmark_pages(zone) / nr_local_cpus;
 
 	/*
@@ -6718,12 +6719,12 @@ static void __zone_set_pageset_high_and_
  * Calculate and set new high and batch values for all per-cpu pagesets of a
  * zone based on the zone's size.
  */
-static void zone_set_pageset_high_and_batch(struct zone *zone)
+static void zone_set_pageset_high_and_batch(struct zone *zone, int cpu_online)
 {
 	int new_high, new_batch;
 
 	new_batch = max(1, zone_batchsize(zone));
-	new_high = zone_highsize(zone, new_batch);
+	new_high = zone_highsize(zone, new_batch, cpu_online);
 
 	if (zone->pageset_high == new_high &&
 	    zone->pageset_batch == new_batch)
@@ -6753,7 +6754,7 @@ void __meminit setup_zone_pageset(struct
 		per_cpu_pages_init(pcp, pzstats);
 	}
 
-	zone_set_pageset_high_and_batch(zone);
+	zone_set_pageset_high_and_batch(zone, 0);
 }
 
 /*
@@ -8007,6 +8008,7 @@ void __init set_dma_reserve(unsigned lon
 
 static int page_alloc_cpu_dead(unsigned int cpu)
 {
+	struct zone *zone;
 
 	lru_add_drain_cpu(cpu);
 	drain_pages(cpu);
@@ -8027,6 +8029,19 @@ static int page_alloc_cpu_dead(unsigned
 	 * race with what we are doing.
 	 */
 	cpu_vm_stats_fold(cpu);
+
+	for_each_populated_zone(zone)
+		zone_pcp_update(zone, 0);
+
+	return 0;
+}
+
+static int page_alloc_cpu_online(unsigned int cpu)
+{
+	struct zone *zone;
+
+	for_each_populated_zone(zone)
+		zone_pcp_update(zone, 1);
 	return 0;
 }
 
@@ -8052,8 +8067,9 @@ void __init page_alloc_init(void)
 		hashdist = 0;
 #endif
 
-	ret = cpuhp_setup_state_nocalls(CPUHP_PAGE_ALLOC_DEAD,
-					"mm/page_alloc:dead", NULL,
+	ret = cpuhp_setup_state_nocalls(CPUHP_PAGE_ALLOC,
+					"mm/page_alloc:pcp",
+					page_alloc_cpu_online,
 					page_alloc_cpu_dead);
 	WARN_ON(ret < 0);
 }
@@ -8191,7 +8207,7 @@ static void __setup_per_zone_wmarks(void
 		 * The watermark size have changed so update the pcpu batch
 		 * and high limits or the limits may be inappropriate.
 		 */
-		zone_set_pageset_high_and_batch(zone);
+		zone_set_pageset_high_and_batch(zone, 0);
 
 		spin_unlock_irqrestore(&zone->lock, flags);
 	}
@@ -9014,10 +9030,10 @@ EXPORT_SYMBOL(free_contig_range);
  * The zone indicated has a new number of managed_pages; batch sizes and percpu
  * page high values need to be recalculated.
  */
-void __meminit zone_pcp_update(struct zone *zone)
+void zone_pcp_update(struct zone *zone, int cpu_online)
 {
 	mutex_lock(&pcp_batch_high_lock);
-	zone_set_pageset_high_and_batch(zone);
+	zone_set_pageset_high_and_batch(zone, cpu_online);
 	mutex_unlock(&pcp_batch_high_lock);
 }
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-split-per-cpu-page-lists-and-zone-stats.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch
mm-vmstat-convert-numa-statistics-to-basic-numa-counters.patch
mm-vmstat-inline-numa-event-counter-updates.patch
mm-page_alloc-batch-the-accounting-updates-in-the-bulk-allocator.patch
mm-page_alloc-reduce-duration-that-irqs-are-disabled-for-vm-counters.patch
mm-page_alloc-explicitly-acquire-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-avoid-conflating-irqs-disabled-with-zone-lock.patch
mm-page_alloc-update-pgfree-outside-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-delete-vmpercpu_pagelist_fraction.patch
mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch.patch
mm-page_alloc-adjust-pcp-high-after-cpu-hotplug-events.patch
mm-page_alloc-scale-the-number-of-pages-that-are-batch-freed.patch
mm-page_alloc-limit-the-number-of-pages-on-pcp-lists-when-reclaim-is-active.patch
mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction.patch
mm-vmscan-remove-kerneldoc-like-comment-from-isolate_lru_pages.patch
mm-vmalloc-include-header-for-prototype-of-set_iounmap_nonlazy.patch
mm-page_alloc-make-should_fail_alloc_page-a-static-function-should_fail_alloc_page-static.patch
mm-mapping_dirty_helpers-remove-double-note-in-kerneldoc.patch
mm-early_ioremap-add-prototype-for-early_memremap_pgprot_adjust.patch
mm-memcontrolc-fix-kerneldoc-comment-for-mem_cgroup_calculate_protection.patch
mm-memory_hotplug-fix-kerneldoc-comment-for-__try_online_node.patch
mm-memory_hotplug-fix-kerneldoc-comment-for-__remove_memory.patch
mm-zbud-add-kerneldoc-fields-for-zbud_pool.patch
mm-z3fold-add-kerneldoc-fields-for-z3fold_pool.patch
mm-swap-make-swap_address_space-an-inline-function.patch
mm-mmap_lock-remove-dead-code-for-config_tracing-configurations.patch
mm-page_alloc-move-prototype-for-find_suitable_fallback.patch
mm-swap-make-node_data-an-inline-function-on-config_flatmem.patch

