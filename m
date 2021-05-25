Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06CFAC4707F
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 23:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6CF56140E
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 23:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbhEYXoc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 May 2021 19:44:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231356AbhEYXoc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 May 2021 19:44:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFD2D61404;
        Tue, 25 May 2021 23:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621986181;
        bh=iSerhAI/dIjc4NKDRSL73EFWb95uRA/93FomRArhX60=;
        h=Date:From:To:Subject:From;
        b=kwozUsPj0KFwZADZ6UUGaMz60m0nbExNz9OYXxJipszhxGOxs1bwUY9VhTUWVK383
         f+/2L+Az+STrs0kreozmaLgeNHBK4EVbr2+orYJtqCNo+1yExctNZqobqXGeSI3w7U
         D1hNoAf9Z+skSgjRazJfjTHW6q3b+eOqg+f7vZHA=
Date:   Tue, 25 May 2021 16:43:00 -0700
From:   akpm@linux-foundation.org
To:     dave.hansen@linux.intel.com, hdanton@sina.com,
        mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  +
 mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch.patch added to -mm
 tree
Message-ID: <20210525234300.vIfcG5Dhn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: disassociate the pcp->high from pcp->batch
has been added to the -mm tree.  Its filename is
     mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch.patch

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

Link: https://lkml.kernel.org/r/20210525080119.5455-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   60 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 18 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch
+++ a/mm/page_alloc.c
@@ -2164,14 +2164,6 @@ void __init page_alloc_init_late(void)
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
@@ -6597,13 +6589,12 @@ static int zone_batchsize(struct zone *z
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
@@ -6640,6 +6631,34 @@ static int zone_batchsize(struct zone *z
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
@@ -6701,11 +6720,10 @@ static void __zone_set_pageset_high_and_
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
@@ -8169,6 +8187,12 @@ static void __setup_per_zone_wmarks(void
 		zone->_watermark[WMARK_LOW]  = min_wmark_pages(zone) + tmp;
 		zone->_watermark[WMARK_HIGH] = min_wmark_pages(zone) + tmp * 2;
 
+		/*
+		 * The watermark size have changed so update the pcpu batch
+		 * and high limits or the limits may be inappropriate.
+		 */
+		zone_set_pageset_high_and_batch(zone);
+
 		spin_unlock_irqrestore(&zone->lock, flags);
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

