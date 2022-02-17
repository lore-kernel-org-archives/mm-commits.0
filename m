Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0182AC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 17 Feb 2022 01:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbiBQB1f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Feb 2022 20:27:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiBQB1a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Feb 2022 20:27:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE344C2E49
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 17:27:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BC0AB81002
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 01:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF851C004E1;
        Thu, 17 Feb 2022 01:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645061233;
        bh=Mffyy55BvZ6EeoV3XYlTvqfmZGJ0TWfckaU6BObDHnc=;
        h=Date:To:From:Subject:From;
        b=Se2VIYvsN179pfMDCUON3rMFf7BIcXrAP6LpMbnbTVMHRMuDmUygaES5FDmqklTFA
         bXqBTZvyPG1PkCr7jnpBSkKxioOKHVe3NsWdZR3QCw7SDvGQMnKC5j23ptI/Gy1u4S
         ykX2AK1IKNFvj2F4p/ZVxHzgn1EPHZJC0WVIBF5Y=
Date:   Wed, 16 Feb 2022 17:27:12 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
        dave.hansen@linux.intel.com, brouer@redhat.com, aaron.lu@intel.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-limit-number-of-high-order-pages-on-pcp-during-bulk-free.patch added to -mm tree
Message-Id: <20220217012712.EF851C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: limit number of high-order pages on PCP during bulk free
has been added to the -mm tree.  Its filename is
     mm-page_alloc-limit-number-of-high-order-pages-on-pcp-during-bulk-free.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-limit-number-of-high-order-pages-on-pcp-during-bulk-free.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-limit-number-of-high-order-pages-on-pcp-during-bulk-free.patch

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
Subject: mm/page_alloc: limit number of high-order pages on PCP during bulk free

When a PCP is mostly used for frees then high-order pages can exist on PCP
lists for some time.  This is problematic when the allocation pattern is
all allocations from one CPU and all frees from another resulting in
colder pages being used.  When bulk freeing pages, limit the number of
high-order pages that are stored on the PCP lists.

Netperf running on localhost exhibits this pattern and while it does not
matter for some machines, it does matter for others with smaller caches
where cache misses cause problems due to reduced page reuse.  Pages freed
directly to the buddy list may be reused quickly while still cache hot
where as storing on the PCP lists may be cold by the time
free_pcppages_bulk() is called.

Using perf kmem:mm_page_alloc, the 5 most used page frames were

5.17-rc3
  13041 pfn=0x111a30
  13081 pfn=0x5814d0
  13097 pfn=0x108258
  13121 pfn=0x689598
  13128 pfn=0x5814d8

5.17-revert-highpcp
 192009 pfn=0x54c140
 195426 pfn=0x1081d0
 200908 pfn=0x61c808
 243515 pfn=0xa9dc20
 402523 pfn=0x222bb8

5.17-full-series
 142693 pfn=0x346208
 162227 pfn=0x13bf08
 166413 pfn=0x2711e0
 166950 pfn=0x2702f8

The spread is wider as there is still time before pages freed to one PCP
get released with a tradeoff between fast reuse and reduced zone lock
acquisition.

On the machine used to gather the traces, the headline performance was
equivalent.

netperf-tcp
                            5.17.0-rc3             5.17.0-rc3             5.17.0-rc3
                               vanilla  mm-reverthighpcp-v1r1     mm-highpcplimit-v2
Hmean     64         839.93 (   0.00%)      840.77 (   0.10%)      841.02 (   0.13%)
Hmean     128       1614.22 (   0.00%)     1622.07 *   0.49%*     1636.41 *   1.37%*
Hmean     256       2952.00 (   0.00%)     2953.19 (   0.04%)     2977.76 *   0.87%*
Hmean     1024     10291.67 (   0.00%)    10239.17 (  -0.51%)    10434.41 *   1.39%*
Hmean     2048     17335.08 (   0.00%)    17399.97 (   0.37%)    17134.81 *  -1.16%*
Hmean     3312     22628.15 (   0.00%)    22471.97 (  -0.69%)    22422.78 (  -0.91%)
Hmean     4096     25009.50 (   0.00%)    24752.83 *  -1.03%*    24740.41 (  -1.08%)
Hmean     8192     32745.01 (   0.00%)    31682.63 *  -3.24%*    32153.50 *  -1.81%*
Hmean     16384    39759.59 (   0.00%)    36805.78 *  -7.43%*    38948.13 *  -2.04%*

On a 1-socket skylake machine with a small CPU cache that suffers more if
cache misses are too high

netperf-tcp
                            5.17.0-rc3             5.17.0-rc3             5.17.0-rc3
                               vanilla    mm-reverthighpcp-v1     mm-highpcplimit-v2
Hmean     64         938.95 (   0.00%)      941.50 *   0.27%*      943.61 *   0.50%*
Hmean     128       1843.10 (   0.00%)     1857.58 *   0.79%*     1861.09 *   0.98%*
Hmean     256       3573.07 (   0.00%)     3667.45 *   2.64%*     3674.91 *   2.85%*
Hmean     1024     13206.52 (   0.00%)    13487.80 *   2.13%*    13393.21 *   1.41%*
Hmean     2048     22870.23 (   0.00%)    23337.96 *   2.05%*    23188.41 *   1.39%*
Hmean     3312     31001.99 (   0.00%)    32206.50 *   3.89%*    31863.62 *   2.78%*
Hmean     4096     35364.59 (   0.00%)    36490.96 *   3.19%*    36112.54 *   2.11%*
Hmean     8192     48497.71 (   0.00%)    49954.05 *   3.00%*    49588.26 *   2.25%*
Hmean     16384    58410.86 (   0.00%)    60839.80 *   4.16%*    62282.96 *   6.63%*

Note that this was a machine that did not benefit from caching high-order
pages and performance is almost restored with the series applied.  It's
not fully restored as cache misses are still higher.  This is a trade-off
between optimising for a workload that does all allocs on one CPU and
frees on another or more general workloads that need high-order pages for
SLUB and benefit from avoiding zone->lock for every SLUB refill/drain.

Link: https://lkml.kernel.org/r/20220217002227.5739-7-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-limit-number-of-high-order-pages-on-pcp-during-bulk-free
+++ a/mm/page_alloc.c
@@ -3355,10 +3355,15 @@ static bool free_unref_page_prepare(stru
 	return true;
 }
 
-static int nr_pcp_free(struct per_cpu_pages *pcp, int high, int batch)
+static int nr_pcp_free(struct per_cpu_pages *pcp, int high, int batch,
+		       bool free_high)
 {
 	int min_nr_free, max_nr_free;
 
+	/* Free everything if batch freeing high-order pages. */
+	if (unlikely(free_high))
+		return pcp->count;
+
 	/* Check for PCP disabled or boot pageset */
 	if (unlikely(high < batch))
 		return 1;
@@ -3379,11 +3384,12 @@ static int nr_pcp_free(struct per_cpu_pa
 	return batch;
 }
 
-static int nr_pcp_high(struct per_cpu_pages *pcp, struct zone *zone)
+static int nr_pcp_high(struct per_cpu_pages *pcp, struct zone *zone,
+		       bool free_high)
 {
 	int high = READ_ONCE(pcp->high);
 
-	if (unlikely(!high))
+	if (unlikely(!high || free_high))
 		return 0;
 
 	if (!test_bit(ZONE_RECLAIM_ACTIVE, &zone->flags))
@@ -3403,17 +3409,27 @@ static void free_unref_page_commit(struc
 	struct per_cpu_pages *pcp;
 	int high;
 	int pindex;
+	bool free_high;
 
 	__count_vm_event(PGFREE);
 	pcp = this_cpu_ptr(zone->per_cpu_pageset);
 	pindex = order_to_pindex(migratetype, order);
 	list_add(&page->lru, &pcp->lists[pindex]);
 	pcp->count += 1 << order;
-	high = nr_pcp_high(pcp, zone);
+
+	/*
+	 * As high-order pages other than THP's stored on PCP can contribute
+	 * to fragmentation, limit the number stored when PCP is heavily
+	 * freeing without allocation. The remainder after bulk freeing
+	 * stops will be drained from vmstat refresh context.
+	 */
+	free_high = (pcp->free_factor && order && order <= PAGE_ALLOC_COSTLY_ORDER);
+
+	high = nr_pcp_high(pcp, zone, free_high);
 	if (pcp->count >= high) {
 		int batch = READ_ONCE(pcp->batch);
 
-		free_pcppages_bulk(zone, nr_pcp_free(pcp, high, batch), pcp, pindex);
+		free_pcppages_bulk(zone, nr_pcp_free(pcp, high, batch, free_high), pcp, pindex);
 	}
 }
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-fetch-the-correct-pcp-buddy-during-bulk-free.patch
mm-page_alloc-track-range-of-active-pcp-lists-during-bulk-free.patch
mm-page_alloc-simplify-how-many-pages-are-selected-per-pcp-list-during-bulk-free.patch
mm-page_alloc-drain-the-requested-list-first-during-bulk-free.patch
mm-page_alloc-free-pages-in-a-single-pass-during-bulk-free.patch
mm-page_alloc-limit-number-of-high-order-pages-on-pcp-during-bulk-free.patch

