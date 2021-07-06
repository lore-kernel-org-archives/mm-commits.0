Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45609C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AA8761009
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbhGFTRl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:17:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231909AbhGFTRl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:17:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99A8660C3D;
        Tue,  6 Jul 2021 19:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598901;
        bh=Glopv9bHKGSN9LF4ncAsfP7fG88SGAwzKiTsGjpoRw0=;
        h=Date:From:To:Subject:From;
        b=vSOvnY+/gxHFAmdptASb/TAsBrl54bMNN0O1K/J3H3dKLzP1A94IgTSSGb14nbbr0
         q4YbPiFnDuFdvHsVDCWpX9KkLZIGVozw4TtuC9uwITRtRIJwel1N2hyw/f9MbgwlqC
         1JZFCpKJCSrQrNuTkSDsV4MxloLUbGBHmNxSlsCc=
Date:   Tue, 06 Jul 2021 12:15:01 -0700
From:   akpm@linux-foundation.org
To:     dave.hansen@linux.intel.com, hdanton@sina.com,
        mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 mm-page_alloc-adjust-pcp-high-after-cpu-hotplug-events.patch removed from
 -mm tree
Message-ID: <20210706191501.AiVXtua_a%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: adjust pcp->high after CPU hotplug events
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-adjust-pcp-high-after-cpu-hotplug-events.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuhotplug.h |    2 -
 mm/internal.h              |    2 -
 mm/page_alloc.c            |   38 ++++++++++++++++++++++++-----------
 3 files changed, 29 insertions(+), 13 deletions(-)

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
--- a/mm/page_alloc.c~mm-page_alloc-adjust-pcp-high-after-cpu-hotplug-events
+++ a/mm/page_alloc.c
@@ -6667,7 +6667,7 @@ static int zone_batchsize(struct zone *z
 #endif
 }
 
-static int zone_highsize(struct zone *zone, int batch)
+static int zone_highsize(struct zone *zone, int batch, int cpu_online)
 {
 #ifdef CONFIG_MMU
 	int high;
@@ -6678,9 +6678,10 @@ static int zone_highsize(struct zone *zo
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
@@ -6754,12 +6755,12 @@ static void __zone_set_pageset_high_and_
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
@@ -6789,7 +6790,7 @@ void __meminit setup_zone_pageset(struct
 		per_cpu_pages_init(pcp, pzstats);
 	}
 
-	zone_set_pageset_high_and_batch(zone);
+	zone_set_pageset_high_and_batch(zone, 0);
 }
 
 /*
@@ -8044,6 +8045,7 @@ void __init set_dma_reserve(unsigned lon
 
 static int page_alloc_cpu_dead(unsigned int cpu)
 {
+	struct zone *zone;
 
 	lru_add_drain_cpu(cpu);
 	drain_pages(cpu);
@@ -8064,6 +8066,19 @@ static int page_alloc_cpu_dead(unsigned
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
 
@@ -8089,8 +8104,9 @@ void __init page_alloc_init(void)
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
@@ -8252,7 +8268,7 @@ void setup_per_zone_wmarks(void)
 	 * and high limits or the limits may be inappropriate.
 	 */
 	for_each_zone(zone)
-		zone_pcp_update(zone);
+		zone_pcp_update(zone, 0);
 }
 
 /*
@@ -9053,10 +9069,10 @@ EXPORT_SYMBOL(free_contig_range);
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


