Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 622FAC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 15 Feb 2022 21:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242967AbiBOVfh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 16:35:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242822AbiBOVfg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 16:35:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B866FBA45
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 13:35:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BAAC6192D
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 21:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000F3C340EB;
        Tue, 15 Feb 2022 21:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644960924;
        bh=dr17z5fM+Kjk6jOusjn2wOyy4K3z1YQmwpCrHBaLSjo=;
        h=Date:To:From:Subject:From;
        b=S2cd0x8mPeCvwpfVp8sJhssr3LHCC/gomBcBQKl3CeVvIC4qD+JYn4mqGlPd8IFJ7
         y2IaBEiKJn/VmQVD1RRsAMT+5Aae68U90odcGa8EBrplgLYuUZdE7bZ5HpAei3oS5+
         PRHJVP+2kwk7o2zQRF/ph2lM+342tQFdoUy5yY3M=
Date:   Tue, 15 Feb 2022 13:35:23 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
        dave.hansen@linux.intel.com, brouer@redhat.com, aaron.lu@intel.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-free-pages-in-a-single-pass-during-bulk-free.patch added to -mm tree
Message-Id: <20220215213524.000F3C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: free pages in a single pass during bulk free
has been added to the -mm tree.  Its filename is
     mm-page_alloc-free-pages-in-a-single-pass-during-bulk-free.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-free-pages-in-a-single-pass-during-bulk-free.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-free-pages-in-a-single-pass-during-bulk-free.patch

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
Subject: mm/page_alloc: free pages in a single pass during bulk free

free_pcppages_bulk() has taken two passes through the pcp lists since
commit 0a5f4e5b4562 ("mm/free_pcppages_bulk: do not hold lock when picking
pages to free") due to deferring the cost of selecting PCP lists until the
zone lock is held.  Now that list selection is simpler, the main cost
during selection is bulkfree_pcp_prepare() which in the normal case is a
simple check and prefetching.  As the list manipulations have cost in
itself, go back to freeing pages in a single pass.

The series up to this point was evaulated using a trunc microbenchmark
that is truncating sparse files stored in page cache (mmtests config
config-io-trunc).  Sparse files were used to limit filesystem interaction.

The results versus a revert of storing high-order pages in the PCP lists is

1-socket Skylake
                              5.17.0-rc3             5.17.0-rc3             5.17.0-rc3
                                 vanilla    mm-reverthighpcp-v1r1     mm-highpcpopt-v1
Min       elapsed      540.00 (   0.00%)      530.00 (   1.85%)      530.00 (   1.85%)
Amean     elapsed      543.00 (   0.00%)      530.00 *   2.39%*      530.00 *   2.39%*
Stddev    elapsed        4.83 (   0.00%)        0.00 ( 100.00%)        0.00 ( 100.00%)
CoeffVar  elapsed        0.89 (   0.00%)        0.00 ( 100.00%)        0.00 ( 100.00%)
Max       elapsed      550.00 (   0.00%)      530.00 (   3.64%)      530.00 (   3.64%)
BAmean-50 elapsed      540.00 (   0.00%)      530.00 (   1.85%)      530.00 (   1.85%)
BAmean-95 elapsed      542.22 (   0.00%)      530.00 (   2.25%)      530.00 (   2.25%)
BAmean-99 elapsed      542.22 (   0.00%)      530.00 (   2.25%)      530.00 (   2.25%)

2-socket CascadeLake
                              5.17.0-rc3             5.17.0-rc3             5.17.0-rc3
                                 vanilla    mm-reverthighpcp-v1       mm-highpcpopt-v1
Min       elapsed      510.00 (   0.00%)      500.00 (   1.96%)      500.00 (   1.96%)
Amean     elapsed      529.00 (   0.00%)      521.00 (   1.51%)      516.00 *   2.46%*
Stddev    elapsed       16.63 (   0.00%)       12.87 (  22.64%)        9.66 (  41.92%)
CoeffVar  elapsed        3.14 (   0.00%)        2.47 (  21.46%)        1.87 (  40.45%)
Max       elapsed      550.00 (   0.00%)      540.00 (   1.82%)      530.00 (   3.64%)
BAmean-50 elapsed      516.00 (   0.00%)      512.00 (   0.78%)      510.00 (   1.16%)
BAmean-95 elapsed      526.67 (   0.00%)      518.89 (   1.48%)      514.44 (   2.32%)
BAmean-99 elapsed      526.67 (   0.00%)      518.89 (   1.48%)      514.44 (   2.32%)

The original motivation for multi-passes was will-it-scale page_fault1
using $nr_cpu processes.

2-socket CascadeLake (40 cores, 80 CPUs HT enabled)
                                                    5.17.0-rc3                 5.17.0-rc3
                                                       vanilla         mm-highpcpopt-v1r4
Hmean     page_fault1-processes-2        2694662.26 (   0.00%)      2696801.07 (   0.08%)
Hmean     page_fault1-processes-5        6425819.34 (   0.00%)      6426573.21 (   0.01%)
Hmean     page_fault1-processes-8        9642169.10 (   0.00%)      9647444.94 (   0.05%)
Hmean     page_fault1-processes-12      12167502.10 (   0.00%)     12073323.10 *  -0.77%*
Hmean     page_fault1-processes-21      15636859.03 (   0.00%)     15587449.50 *  -0.32%*
Hmean     page_fault1-processes-30      25157348.61 (   0.00%)     25111707.15 *  -0.18%*
Hmean     page_fault1-processes-48      27694013.85 (   0.00%)     27728568.63 (   0.12%)
Hmean     page_fault1-processes-79      25928742.64 (   0.00%)     25920933.41 (  -0.03%) <---
Hmean     page_fault1-processes-110     25730869.75 (   0.00%)     25695727.57 *  -0.14%*
Hmean     page_fault1-processes-141     25626992.42 (   0.00%)     25675346.68 *   0.19%*
Hmean     page_fault1-processes-172     25611651.35 (   0.00%)     25650940.14 *   0.15%*
Hmean     page_fault1-processes-203     25577298.75 (   0.00%)     25584848.65 (   0.03%)
Hmean     page_fault1-processes-234     25580686.07 (   0.00%)     25601794.52 *   0.08%*
Hmean     page_fault1-processes-265     25570215.47 (   0.00%)     25553191.25 (  -0.07%)
Hmean     page_fault1-processes-296     25549488.62 (   0.00%)     25530311.58 (  -0.08%)
Hmean     page_fault1-processes-320     25555149.05 (   0.00%)     25585059.83 (   0.12%)

The differences are mostly within the noise and the difference close to
$nr_cpus is negligible.

Link: https://lkml.kernel.org/r/20220215145111.27082-5-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   57 +++++++++++++++++-----------------------------
 1 file changed, 22 insertions(+), 35 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-free-pages-in-a-single-pass-during-bulk-free
+++ a/mm/page_alloc.c
@@ -1455,14 +1455,21 @@ static void free_pcppages_bulk(struct zo
 	unsigned int order;
 	int prefetch_nr = READ_ONCE(pcp->batch);
 	bool isolated_pageblocks;
-	struct page *page, *tmp;
-	LIST_HEAD(head);
+	struct page *page;
 
 	/*
 	 * Ensure proper count is passed which otherwise would stuck in the
 	 * below while (list_empty(list)) loop.
 	 */
 	count = min(pcp->count, count);
+
+	/*
+	 * local_lock_irq held so equivalent to spin_lock_irqsave for
+	 * both PREEMPT_RT and non-PREEMPT_RT configurations.
+	 */
+	spin_lock(&zone->lock);
+	isolated_pageblocks = has_isolate_pageblock(zone);
+
 	while (count > 0) {
 		struct list_head *list;
 		int nr_pages;
@@ -1485,7 +1492,11 @@ static void free_pcppages_bulk(struct zo
 		nr_pages = 1 << order;
 		BUILD_BUG_ON(MAX_ORDER >= (1<<NR_PCP_ORDER_WIDTH));
 		do {
+			int mt;
+
 			page = list_last_entry(list, struct page, lru);
+			mt = get_pcppage_migratetype(page);
+
 			/* must delete to avoid corrupting pcp list */
 			list_del(&page->lru);
 			count -= nr_pages;
@@ -1494,12 +1505,6 @@ static void free_pcppages_bulk(struct zo
 			if (bulkfree_pcp_prepare(page))
 				continue;
 
-			/* Encode order with the migratetype */
-			page->index <<= NR_PCP_ORDER_WIDTH;
-			page->index |= order;
-
-			list_add_tail(&page->lru, &head);
-
 			/*
 			 * We are going to put the page back to the global
 			 * pool, prefetch its buddy to speed up later access
@@ -1513,36 +1518,18 @@ static void free_pcppages_bulk(struct zo
 				prefetch_buddy(page, order);
 				prefetch_nr--;
 			}
-		} while (count > 0 && !list_empty(list));
-	}
 
-	/*
-	 * local_lock_irq held so equivalent to spin_lock_irqsave for
-	 * both PREEMPT_RT and non-PREEMPT_RT configurations.
-	 */
-	spin_lock(&zone->lock);
-	isolated_pageblocks = has_isolate_pageblock(zone);
+			/* MIGRATE_ISOLATE page should not go to pcplists */
+			VM_BUG_ON_PAGE(is_migrate_isolate(mt), page);
+			/* Pageblock could have been isolated meanwhile */
+			if (unlikely(isolated_pageblocks))
+				mt = get_pageblock_migratetype(page);
 
-	/*
-	 * Use safe version since after __free_one_page(),
-	 * page->lru.next will not point to original list.
-	 */
-	list_for_each_entry_safe(page, tmp, &head, lru) {
-		int mt = get_pcppage_migratetype(page);
-
-		/* mt has been encoded with the order (see above) */
-		order = mt & NR_PCP_ORDER_MASK;
-		mt >>= NR_PCP_ORDER_WIDTH;
-
-		/* MIGRATE_ISOLATE page should not go to pcplists */
-		VM_BUG_ON_PAGE(is_migrate_isolate(mt), page);
-		/* Pageblock could have been isolated meanwhile */
-		if (unlikely(isolated_pageblocks))
-			mt = get_pageblock_migratetype(page);
-
-		__free_one_page(page, page_to_pfn(page), zone, order, mt, FPI_NONE);
-		trace_mm_page_pcpu_drain(page, order, mt);
+			__free_one_page(page, page_to_pfn(page), zone, order, mt, FPI_NONE);
+			trace_mm_page_pcpu_drain(page, order, mt);
+		} while (count > 0 && !list_empty(list));
 	}
+
 	spin_unlock(&zone->lock);
 }
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-fetch-the-correct-pcp-buddy-during-bulk-free.patch
mm-page_alloc-track-range-of-active-pcp-lists-during-bulk-free.patch
mm-page_alloc-simplify-how-many-pages-are-selected-per-pcp-list-during-bulk-free.patch
mm-page_alloc-free-pages-in-a-single-pass-during-bulk-free.patch
mm-page_alloc-limit-number-of-high-order-pages-on-pcp-during-bulk-free.patch

