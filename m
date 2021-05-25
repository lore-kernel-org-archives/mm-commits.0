Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C180C47089
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 23:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ECC261408
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 23:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbhEYXoj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 May 2021 19:44:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231356AbhEYXoj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 May 2021 19:44:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAA5761402;
        Tue, 25 May 2021 23:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621986189;
        bh=tq7R0BxWnLc8HqNLm9l9m8ZOSW6+fOXD8aw275Ve7aM=;
        h=Date:From:To:Subject:From;
        b=nvSg462Eyv0WayFXvX/u/WvXOvINrnpdfBOXiwLy3ioRmJtoQL3cUtbdPZ6SBX3A7
         LWL5Rji3ptvKsldzcbzUXmueFFS28SBt7wJCqFjYawioumkjVFU8PDv3G7MTw700z2
         byuydFCEpyWAT+QoYtOZyMz3FzWWsa1HOElNTaM8=
Date:   Tue, 25 May 2021 16:43:08 -0700
From:   akpm@linux-foundation.org
To:     dave.hansen@linux.intel.com, hdanton@sina.com,
        mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?mm-page=5Falloc-limit-the-number-of-pages-on-pcp-lists-when?=
 =?US-ASCII?Q?-reclaim-is-active.patch?= added to -mm tree
Message-ID: <20210525234308.uIlz4tinL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: limit the number of pages on PCP lists when reclaim is active
has been added to the -mm tree.  Its filename is
     mm-page_alloc-limit-the-number-of-pages-on-pcp-lists-when-reclaim-is-active.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-limit-the-number-of-pages-on-pcp-lists-when-reclaim-is-active.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-limit-the-number-of-pages-on-pcp-lists-when-reclaim-is-active.patch

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
Subject: mm/page_alloc: limit the number of pages on PCP lists when reclaim is active

When kswapd is active then direct reclaim is potentially active.  In
either case, it is possible that a zone would be balanced if pages were
not trapped on PCP lists.  Instead of draining remote pages, simply limit
the size of the PCP lists while kswapd is active.

Link: https://lkml.kernel.org/r/20210525080119.5455-6-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 +
 mm/page_alloc.c        |   19 ++++++++++++++++++-
 mm/vmscan.c            |   35 +++++++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+), 1 deletion(-)

--- a/include/linux/mmzone.h~mm-page_alloc-limit-the-number-of-pages-on-pcp-lists-when-reclaim-is-active
+++ a/include/linux/mmzone.h
@@ -647,6 +647,7 @@ enum zone_flags {
 	ZONE_BOOSTED_WATERMARK,		/* zone recently boosted watermarks.
 					 * Cleared when kswapd is woken.
 					 */
+	ZONE_RECLAIM_ACTIVE,		/* kswapd may be scanning the zone. */
 };
 
 static inline unsigned long zone_managed_pages(struct zone *zone)
--- a/mm/page_alloc.c~mm-page_alloc-limit-the-number-of-pages-on-pcp-lists-when-reclaim-is-active
+++ a/mm/page_alloc.c
@@ -3291,6 +3291,23 @@ static int nr_pcp_free(struct per_cpu_pa
 	return batch;
 }
 
+static int nr_pcp_high(struct per_cpu_pages *pcp, struct zone *zone)
+{
+	int high = READ_ONCE(pcp->high);
+
+	if (unlikely(!high))
+		return 0;
+
+	if (!test_bit(ZONE_RECLAIM_ACTIVE, &zone->flags))
+		return high;
+
+	/*
+	 * If reclaim is active, limit the number of pages that can be
+	 * stored on pcp lists
+	 */
+	return min(READ_ONCE(pcp->batch) << 2, high);
+}
+
 static void free_unref_page_commit(struct page *page, unsigned long pfn,
 				   int migratetype)
 {
@@ -3302,7 +3319,7 @@ static void free_unref_page_commit(struc
 	pcp = this_cpu_ptr(zone->per_cpu_pageset);
 	list_add(&page->lru, &pcp->lists[migratetype]);
 	pcp->count++;
-	high = READ_ONCE(pcp->high);
+	high = nr_pcp_high(pcp, zone);
 	if (pcp->count >= high) {
 		int batch = READ_ONCE(pcp->batch);
 
--- a/mm/vmscan.c~mm-page_alloc-limit-the-number-of-pages-on-pcp-lists-when-reclaim-is-active
+++ a/mm/vmscan.c
@@ -3722,6 +3722,38 @@ static bool kswapd_shrink_node(pg_data_t
 	return sc->nr_scanned >= sc->nr_to_reclaim;
 }
 
+/* Page allocator PCP high watermark is lowered if reclaim is active. */
+static inline void
+update_reclaim_active(pg_data_t *pgdat, int highest_zoneidx, bool active)
+{
+	int i;
+	struct zone *zone;
+
+	for (i = 0; i <= highest_zoneidx; i++) {
+		zone = pgdat->node_zones + i;
+
+		if (!managed_zone(zone))
+			continue;
+
+		if (active)
+			set_bit(ZONE_RECLAIM_ACTIVE, &zone->flags);
+		else
+			clear_bit(ZONE_RECLAIM_ACTIVE, &zone->flags);
+	}
+}
+
+static inline void
+set_reclaim_active(pg_data_t *pgdat, int highest_zoneidx)
+{
+	update_reclaim_active(pgdat, highest_zoneidx, true);
+}
+
+static inline void
+clear_reclaim_active(pg_data_t *pgdat, int highest_zoneidx)
+{
+	update_reclaim_active(pgdat, highest_zoneidx, false);
+}
+
 /*
  * For kswapd, balance_pgdat() will reclaim pages across a node from zones
  * that are eligible for use by the caller until at least one zone is
@@ -3774,6 +3806,7 @@ static int balance_pgdat(pg_data_t *pgda
 	boosted = nr_boost_reclaim;
 
 restart:
+	set_reclaim_active(pgdat, highest_zoneidx);
 	sc.priority = DEF_PRIORITY;
 	do {
 		unsigned long nr_reclaimed = sc.nr_reclaimed;
@@ -3907,6 +3940,8 @@ restart:
 		pgdat->kswapd_failures++;
 
 out:
+	clear_reclaim_active(pgdat, highest_zoneidx);
+
 	/* If reclaim was boosted, account for the reclaim done in this pass */
 	if (boosted) {
 		unsigned long flags;
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

