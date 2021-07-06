Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B67C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:14:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D064B6103E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbhGFTRi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231913AbhGFTRi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:17:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 999366008E;
        Tue,  6 Jul 2021 19:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598898;
        bh=nre4GWBfnIJzSZMwljmgFbIppviOxrUmQsvLcj8mDGI=;
        h=Date:From:To:Subject:From;
        b=RILJ2AD2HauBKyQT5At92nOKnkhXP1Km/bUu928NzuCO2dM4miKNWh5YMIJcO6bii
         KXzXVlIkokHQweE7JYa/OUwzDRb+zVuJ778NSF1Q0W9hb7YKoe79RUl2wFTI1IJd4f
         NzjAR3+JMxEtHiJFt4Lp52GB852lXVJKaGoddpFI=
Date:   Tue, 06 Jul 2021 12:14:58 -0700
From:   akpm@linux-foundation.org
To:     dave.hansen@linux.intel.com, hdanton@sina.com,
        mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch.patch removed from
 -mm tree
Message-ID: <20210706191458.QLYacN8LM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: disassociate the pcp->high from pcp->batch
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: disassociate the pcp->high from pcp->batch

The pcp high watermark is based on the batch size but there is no
relationship between them other than it is convenient to use early in
boot.

This patch takes the first step and bases pcp->high on the zone low
watermark split across the number of CPUs local to a zone while the batch
size remains the same to avoid increasing allocation latencies.  The
intent behind the default pcp->high is "set the number of PCP pages such
that if they are all full that background reclaim is not started
prematurely".

Note that in this patch the pcp->high values are adjusted after memory
hotplug events, min_free_kbytes adjustments and watermark scale factor
adjustments but not CPU hotplug events which is handled later in the
series.

On a test KVM instance;

Before grep -E "high:|batch" /proc/zoneinfo | tail -2
              high:  378
              batch: 63

After grep -E "high:|batch" /proc/zoneinfo | tail -2
              high:  649
              batch: 63

[mgorman@techsingularity.net:  fix __setup_per_zone_wmarks for parallel memory
hotplug]
  Link: https://lkml.kernel.org/r/20210528105925.GN30378@techsingularity.net
Link: https://lkml.kernel.org/r/20210525080119.5455-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    6 ++--
 mm/page_alloc.c     |   62 +++++++++++++++++++++++++++++-------------
 2 files changed, 47 insertions(+), 21 deletions(-)

--- a/mm/memory_hotplug.c~mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch
+++ a/mm/memory_hotplug.c
@@ -961,7 +961,6 @@ int __ref online_pages(unsigned long pfn
 	node_states_set_node(nid, &arg);
 	if (need_zonelists_rebuild)
 		build_all_zonelists(NULL);
-	zone_pcp_update(zone);
 
 	/* Basic onlining is complete, allow allocation of onlined pages. */
 	undo_isolate_page_range(pfn, pfn + nr_pages, MIGRATE_MOVABLE);
@@ -974,6 +973,7 @@ int __ref online_pages(unsigned long pfn
 	 */
 	shuffle_zone(zone);
 
+	/* reinitialise watermarks and update pcp limits */
 	init_per_zone_wmark_min();
 
 	kswapd_run(nid);
@@ -1829,13 +1829,13 @@ int __ref offline_pages(unsigned long st
 	adjust_managed_page_count(pfn_to_page(start_pfn), -nr_pages);
 	adjust_present_page_count(zone, -nr_pages);
 
+	/* reinitialise watermarks and update pcp limits */
 	init_per_zone_wmark_min();
 
 	if (!populated_zone(zone)) {
 		zone_pcp_reset(zone);
 		build_all_zonelists(NULL);
-	} else
-		zone_pcp_update(zone);
+	}
 
 	node_states_clear_node(node, &arg);
 	if (arg.status_change_nid >= 0) {
--- a/mm/page_alloc.c~mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch
+++ a/mm/page_alloc.c
@@ -2175,14 +2175,6 @@ void __init page_alloc_init_late(void)
 	wait_for_completion(&pgdat_init_all_done_comp);
 
 	/*
-	 * The number of managed pages has changed due to the initialisation
-	 * so the pcpu batch and high limits needs to be updated or the limits
-	 * will be artificially small.
-	 */
-	for_each_populated_zone(zone)
-		zone_pcp_update(zone);
-
-	/*
 	 * We initialized the rest of the deferred pages.  Permanently disable
 	 * on-demand struct page initialization.
 	 */
@@ -6633,13 +6625,12 @@ static int zone_batchsize(struct zone *z
 	int batch;
 
 	/*
-	 * The per-cpu-pages pools are set to around 1000th of the
-	 * size of the zone.
+	 * The number of pages to batch allocate is either ~0.1%
+	 * of the zone or 1MB, whichever is smaller. The batch
+	 * size is striking a balance between allocation latency
+	 * and zone lock contention.
 	 */
-	batch = zone_managed_pages(zone) / 1024;
-	/* But no more than a meg. */
-	if (batch * PAGE_SIZE > 1024 * 1024)
-		batch = (1024 * 1024) / PAGE_SIZE;
+	batch = min(zone_managed_pages(zone) >> 10, (1024 * 1024) / PAGE_SIZE);
 	batch /= 4;		/* We effectively *= 4 below */
 	if (batch < 1)
 		batch = 1;
@@ -6676,6 +6667,34 @@ static int zone_batchsize(struct zone *z
 #endif
 }
 
+static int zone_highsize(struct zone *zone, int batch)
+{
+#ifdef CONFIG_MMU
+	int high;
+	int nr_local_cpus;
+
+	/*
+	 * The high value of the pcp is based on the zone low watermark
+	 * so that if they are full then background reclaim will not be
+	 * started prematurely. The value is split across all online CPUs
+	 * local to the zone. Note that early in boot that CPUs may not be
+	 * online yet.
+	 */
+	nr_local_cpus = max(1U, cpumask_weight(cpumask_of_node(zone_to_nid(zone))));
+	high = low_wmark_pages(zone) / nr_local_cpus;
+
+	/*
+	 * Ensure high is at least batch*4. The multiple is based on the
+	 * historical relationship between high and batch.
+	 */
+	high = max(high, batch << 2);
+
+	return high;
+#else
+	return 0;
+#endif
+}
+
 /*
  * pcp->high and pcp->batch values are related and generally batch is lower
  * than high. They are also related to pcp->count such that count is lower
@@ -6737,11 +6756,10 @@ static void __zone_set_pageset_high_and_
  */
 static void zone_set_pageset_high_and_batch(struct zone *zone)
 {
-	unsigned long new_high, new_batch;
+	int new_high, new_batch;
 
-	new_batch = zone_batchsize(zone);
-	new_high = 6 * new_batch;
-	new_batch = max(1UL, 1 * new_batch);
+	new_batch = max(1, zone_batchsize(zone));
+	new_high = zone_highsize(zone, new_batch);
 
 	if (zone->pageset_high == new_high &&
 	    zone->pageset_batch == new_batch)
@@ -8222,11 +8240,19 @@ static void __setup_per_zone_wmarks(void
  */
 void setup_per_zone_wmarks(void)
 {
+	struct zone *zone;
 	static DEFINE_SPINLOCK(lock);
 
 	spin_lock(&lock);
 	__setup_per_zone_wmarks();
 	spin_unlock(&lock);
+
+	/*
+	 * The watermark size have changed so update the pcpu batch
+	 * and high limits or the limits may be inappropriate.
+	 */
+	for_each_zone(zone)
+		zone_pcp_update(zone);
 }
 
 /*
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


