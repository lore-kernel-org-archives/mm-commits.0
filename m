Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D096C47082
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 22:55:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0106E611CB
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 22:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbhEaW4s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 May 2021 18:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231624AbhEaW4s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 May 2021 18:56:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 108D661186;
        Mon, 31 May 2021 22:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622501707;
        bh=ZCDGLjrUGMxvh5F12EGh4soAytK3PUNPmxw/51Yq4aM=;
        h=Date:From:To:Subject:From;
        b=KMvJshI0sNpochL7BdprjqM3Abpxgot3/pG6MM3+gb4x23uoZU9sLnoIgFPEzuGeT
         PL1B8hB24hna7RNmc0w/yBnjgy0yoKCiwhIM4de+ByYPeWWBLo4ze/9q/S4YQABZOz
         SYIsK7U81dBWkO9DsjSMLW3iybl4UW0+mDBu4ZDk=
Date:   Mon, 31 May 2021 15:55:06 -0700
From:   akpm@linux-foundation.org
To:     dave.hansen@linux.intel.com, hdanton@sina.com,
        mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [to-be-updated]
 mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch-fix.patch removed
 from -mm tree
Message-ID: <20210531225506.SEON4wVjz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: disassociate the pcp->high from pcp->batch -fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: disassociate the pcp->high from pcp->batch -fix

Vlastimil Babka noted that __setup_per_zone_wmarks updating pcp->high did
not protect watermark-related sysctl handlers from a parallel memory
hotplug operations.  This patch moves the PCP update to
setup_per_zone_wmarks and updates the PCP high value while protected by
the pcp_batch_high_lock mutex.

This is a fix to the mmotm patch
mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch.patch.  It'll cause
a conflict with
mm-page_alloc-adjust-pcp-high-after-cpu-hotplug-events.patch but the
resolution is simply to change the caller in setup_per_zone_wmarks to
zone_pcp_update(zone, 0)

Link: https://lkml.kernel.org/r/20210527105241.GB30378@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch-fix
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

