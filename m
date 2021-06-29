Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B0F4C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4336561D0C
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhF2Cot (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:44:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231931AbhF2Cos (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:44:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DAC061D0D;
        Tue, 29 Jun 2021 02:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934542;
        bh=3TPyWZOAYQ771nYRTVmpG0s8z6bYcQvnUjgP2fdA94o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xsL3IJgbelBIEyUEZ+8o2BfT2qxCKu9VUnpxWjB+y2Z34oKcSgFfWLFg1xr4Z3oof
         ajQhnRkDY6LHHUz/f2/2wTz5TzrxNyDI//V3qICxpOctaXX2A1JF/cBQg0BU0BBX9U
         cXqmi7oMJXhmTu3MGJgUe7x+i+VJhVCu898heWbE=
Date:   Mon, 28 Jun 2021 19:42:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dave.hansen@linux.intel.com,
        hdanton@sina.com, linux-mm@kvack.org, mgorman@techsingularity.net,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 174/192] mm/page_alloc: limit the number of pages
 on PCP lists when reclaim is active
Message-ID: <20210629024221.MBFxyK24o%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: limit the number of pages on PCP lists when reclaim is active

When kswapd is active then direct reclaim is potentially active.  In
either case, it is possible that a zone would be balanced if pages were
not trapped on PCP lists.  Instead of draining remote pages, simply limit
the size of the PCP lists while kswapd is active.

Link: https://lkml.kernel.org/r/20210525080119.5455-6-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@kernel.org>
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
@@ -3302,6 +3302,23 @@ static int nr_pcp_free(struct per_cpu_pa
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
@@ -3313,7 +3330,7 @@ static void free_unref_page_commit(struc
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
