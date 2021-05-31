Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01EBFC47080
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 22:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CECA96127C
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 22:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbhEaW5T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 May 2021 18:57:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231624AbhEaW5S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 May 2021 18:57:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90849611CB;
        Mon, 31 May 2021 22:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622501738;
        bh=dy2HXOz0gdBf6lEWLT/Uhz/NbS2AHA65jSAMmLeciGw=;
        h=Date:From:To:Subject:From;
        b=Khy+5WVlA7YKK8eIBU5XRhsp4bkA96JBz8JnhJunL3gc9THBaIqlCd9SWX2kYHJc/
         dMUyJh63erwhsgNDAIgh5zJOR/gl/z4uTLQjRCg09Crhr0I481hrP7y2Bw6FVUkpJ0
         5LJY4FkckTLlEuqj0iKTkHEZ0U96rMHXxsC4WXwQ=
Date:   Mon, 31 May 2021 15:55:38 -0700
From:   akpm@linux-foundation.org
To:     mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        vbabka@suse.cz
Subject:  +
 mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch-fix-2.patch added to
 -mm tree
Message-ID: <20210531225538.wHCWvlugq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: disassociate the pcp->high from pcp->batch -fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch-fix-2.patch

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
Subject: mm/page_alloc: disassociate the pcp->high from pcp->batch -fix

Vlastimil Babka noted that __setup_per_zone_wmarks updating pcp->high did
not protect watermark-related sysctl handlers from a parallel memory
hotplug operations.  This patch moves the PCP update to
setup_per_zone_wmarks and updates the PCP high value while protected by
the pcp_batch_high_lock mutex.  As a side-effect, the zone_pcp_update
calls during memory hotplug operations becomes redundant and can be
removed.

This is a fix to the mmotm patch
mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch.patch.  It'll cause
a conflict with
mm-page_alloc-adjust-pcp-high-after-cpu-hotplug-events.patch but the
resolution is simple as the zone_pcp_update callers in
setup_per_zone_wmarks no longer exist.

Link: https://lkml.kernel.org/r/20210528105925.GN30378@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    6 +++---
 mm/page_alloc.c     |   14 ++++++++------
 2 files changed, 11 insertions(+), 9 deletions(-)

--- a/mm/memory_hotplug.c~mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch-fix-2
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
--- a/mm/page_alloc.c~mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch-fix-2
+++ a/mm/page_alloc.c
@@ -8198,12 +8198,6 @@ static void __setup_per_zone_wmarks(void
 		zone->_watermark[WMARK_LOW]  = min_wmark_pages(zone) + tmp;
 		zone->_watermark[WMARK_HIGH] = min_wmark_pages(zone) + tmp * 2;
 
-		/*
-		 * The watermark size have changed so update the pcpu batch
-		 * and high limits or the limits may be inappropriate.
-		 */
-		zone_set_pageset_high_and_batch(zone);
-
 		spin_unlock_irqrestore(&zone->lock, flags);
 	}
 
@@ -8220,11 +8214,19 @@ static void __setup_per_zone_wmarks(void
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

mm-page_alloc-split-per-cpu-page-lists-and-zone-stats.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix.patch
mm-vmstat-convert-numa-statistics-to-basic-numa-counters.patch
mm-vmstat-inline-numa-event-counter-updates.patch
mm-page_alloc-batch-the-accounting-updates-in-the-bulk-allocator.patch
mm-page_alloc-reduce-duration-that-irqs-are-disabled-for-vm-counters.patch
mm-page_alloc-explicitly-acquire-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-avoid-conflating-irqs-disabled-with-zone-lock.patch
mm-page_alloc-update-pgfree-outside-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-delete-vmpercpu_pagelist_fraction.patch
mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch.patch
mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch-fix-2.patch
mm-page_alloc-adjust-pcp-high-after-cpu-hotplug-events.patch
mm-page_alloc-scale-the-number-of-pages-that-are-batch-freed.patch
mm-page_alloc-limit-the-number-of-pages-on-pcp-lists-when-reclaim-is-active.patch
mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction.patch
mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction-fix.patch
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

