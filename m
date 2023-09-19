Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BFACE79A8
	for <mm-commits@archiver.kernel.org>; Tue, 19 Sep 2023 20:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbjISUWO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Sep 2023 16:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjISUWK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Sep 2023 16:22:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B7ABE;
        Tue, 19 Sep 2023 13:22:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D7FC433C7;
        Tue, 19 Sep 2023 20:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695154924;
        bh=e7S7nVIr3nALEilcG/xKD2sdIhh9bFdJNA9D3o6VlVg=;
        h=Date:To:From:Subject:From;
        b=KEI9aY3RrTvAzJSyFZaIoFkdvUZuxblrICcNoqiu8x/6VWv6xlZKA7fmcYo178vfS
         HKS8yZRXJOesEhxYGHLH+Kx0dApnbHB5mwLfpYigXo7a31Za+rqc5vU6bJ9k5mbeeE
         hd7zc2X1X30GqP5STZ6oRlS8vcUo9Iv0orIP2DcI=
Date:   Tue, 19 Sep 2023 13:22:03 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        joe.liu@mediatek.com, hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-fix-cma-and-highatomic-landing-on-the-wrong-buddy-list.patch removed from -mm tree
Message-Id: <20230919202204.00D7FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_alloc: fix CMA and HIGHATOMIC landing on the wrong buddy list
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-cma-and-highatomic-landing-on-the-wrong-buddy-list.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: fix CMA and HIGHATOMIC landing on the wrong buddy list
Date: Mon, 11 Sep 2023 14:11:08 -0400

Commit 4b23a68f9536 ("mm/page_alloc: protect PCP lists with a spinlock")
bypasses the pcplist on lock contention and returns the page directly to
the buddy list of the page's migratetype.

For pages that don't have their own pcplist, such as CMA and HIGHATOMIC,
the migratetype is temporarily updated such that the page can hitch a ride
on the MOVABLE pcplist.  Their true type is later reassessed when flushing
in free_pcppages_bulk().  However, when lock contention is detected after
the type was already overridden, the bypass will then put the page on the
wrong buddy list.

Once on the MOVABLE buddy list, the page becomes eligible for fallbacks
and even stealing.  In the case of HIGHATOMIC, otherwise ineligible
allocations can dip into the highatomic reserves.  In the case of CMA, the
page can be lost from the CMA region permanently.

Use a separate pcpmigratetype variable for the pcplist override.  Use the
original migratetype when going directly to the buddy.  This fixes the bug
and should make the intentions more obvious in the code.

Originally sent here to address the HIGHATOMIC case:
https://lore.kernel.org/lkml/20230821183733.106619-4-hannes@cmpxchg.org/

Changelog updated in response to the CMA-specific bug report.

[mgorman@techsingularity.net: updated changelog]
Link: https://lkml.kernel.org/r/20230911181108.GA104295@cmpxchg.org
Fixes: 4b23a68f9536 ("mm/page_alloc: protect PCP lists with a spinlock")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Joe Liu <joe.liu@mediatek.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-cma-and-highatomic-landing-on-the-wrong-buddy-list
+++ a/mm/page_alloc.c
@@ -2400,7 +2400,7 @@ void free_unref_page(struct page *page,
 	struct per_cpu_pages *pcp;
 	struct zone *zone;
 	unsigned long pfn = page_to_pfn(page);
-	int migratetype;
+	int migratetype, pcpmigratetype;
 
 	if (!free_unref_page_prepare(page, pfn, order))
 		return;
@@ -2408,24 +2408,24 @@ void free_unref_page(struct page *page,
 	/*
 	 * We only track unmovable, reclaimable and movable on pcp lists.
 	 * Place ISOLATE pages on the isolated list because they are being
-	 * offlined but treat HIGHATOMIC as movable pages so we can get those
-	 * areas back if necessary. Otherwise, we may have to free
+	 * offlined but treat HIGHATOMIC and CMA as movable pages so we can
+	 * get those areas back if necessary. Otherwise, we may have to free
 	 * excessively into the page allocator
 	 */
-	migratetype = get_pcppage_migratetype(page);
+	migratetype = pcpmigratetype = get_pcppage_migratetype(page);
 	if (unlikely(migratetype >= MIGRATE_PCPTYPES)) {
 		if (unlikely(is_migrate_isolate(migratetype))) {
 			free_one_page(page_zone(page), page, pfn, order, migratetype, FPI_NONE);
 			return;
 		}
-		migratetype = MIGRATE_MOVABLE;
+		pcpmigratetype = MIGRATE_MOVABLE;
 	}
 
 	zone = page_zone(page);
 	pcp_trylock_prepare(UP_flags);
 	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (pcp) {
-		free_unref_page_commit(zone, pcp, page, migratetype, order);
+		free_unref_page_commit(zone, pcp, page, pcpmigratetype, order);
 		pcp_spin_unlock(pcp);
 	} else {
 		free_one_page(zone, page, pfn, order, migratetype, FPI_NONE);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


