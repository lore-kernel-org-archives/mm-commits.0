Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84363E7F153
	for <mm-commits@archiver.kernel.org>; Wed, 27 Sep 2023 02:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbjI0Cqj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Sep 2023 22:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbjI0Col (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Sep 2023 22:44:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673281781A
        for <mm-commits@vger.kernel.org>; Tue, 26 Sep 2023 15:17:23 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F98FC43397;
        Tue, 26 Sep 2023 20:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695761974;
        bh=wmJBFk18U1uYNfNEzYOCR1OD/uJPGDJNeqVy/J97m3w=;
        h=Date:To:From:Subject:From;
        b=cbqWhwLuxYinm/K3moTMcct5K5tymPAR29qxxlajv93S0/svh2RADFCckKsXIGTnk
         d7UcMASP8jRlvoB+8EIGL8hP0+Fguq7cfj6v8oi1VIVaakK+jlyoHS8FcagGSXA8hb
         fC+cdA/s1QjjKeiS5OAk2kKZ30fMHjYt4wBwLv1c=
Date:   Tue, 26 Sep 2023 13:59:32 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        sudeep.holla@arm.com, pasha.tatashin@soleen.com, mhocko@suse.com,
        mgorman@techsingularity.net, jweiner@redhat.com, david@redhat.com,
        dave.hansen@linux.intel.com, cl@linux.com, arjan@linux.intel.com,
        akpm@linux-foundation.org, ying.huang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pcp-reduce-detecting-time-of-consecutive-high-order-page-freeing.patch added to mm-unstable branch
Message-Id: <20230926205934.2F98FC43397@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, pcp: reduce detecting time of consecutive high order page freeing
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pcp-reduce-detecting-time-of-consecutive-high-order-page-freeing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pcp-reduce-detecting-time-of-consecutive-high-order-page-freeing.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, pcp: reduce detecting time of consecutive high order page freeing
Date: Tue, 26 Sep 2023 14:09:11 +0800

In current PCP auto-tuning design, if the number of pages allocated is
much more than that of pages freed on a CPU, the PCP high may become the
maximal value even if the allocating/freeing depth is small, for example,
in the sender of network workloads.  If a CPU was used as sender
originally, then it is used as receiver after context switching, we need
to fill the whole PCP with maximal high before triggering PCP draining for
consecutive high order freeing.  This will hurt the performance of some
network workloads.

To solve the issue, in this patch, we will track the consecutive page
freeing with a counter in stead of relying on PCP draining.  So, we can
detect consecutive page freeing much earlier.

On a 2-socket Intel server with 128 logical CPU, we tested
SCTP_STREAM_MANY test case of netperf test suite with 64-pair processes. 
With the patch, the network bandwidth improves 3.1%.  This restores the
performance drop caused by PCP auto-tuning.

Link: https://lkml.kernel.org/r/20230926060911.266511-11-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 mm/page_alloc.c        |   23 +++++++++++------------
 2 files changed, 12 insertions(+), 13 deletions(-)

--- a/include/linux/mmzone.h~mm-pcp-reduce-detecting-time-of-consecutive-high-order-page-freeing
+++ a/include/linux/mmzone.h
@@ -701,10 +701,10 @@ struct per_cpu_pages {
 	int batch;		/* chunk size for buddy add/remove */
 	u8 flags;		/* protected by pcp->lock */
 	u8 alloc_factor;	/* batch scaling factor during allocate */
-	u8 free_factor;		/* batch scaling factor during free */
 #ifdef CONFIG_NUMA
 	u8 expire;		/* When 0, remote pagesets are drained */
 #endif
+	short free_count;	/* consecutive free count */
 
 	/* Lists of pages, one per migrate type stored on the pcp-lists */
 	struct list_head lists[NR_PCP_LISTS];
--- a/mm/page_alloc.c~mm-pcp-reduce-detecting-time-of-consecutive-high-order-page-freeing
+++ a/mm/page_alloc.c
@@ -2405,13 +2405,10 @@ static int nr_pcp_free(struct per_cpu_pa
 	max_nr_free = high - batch;
 
 	/*
-	 * Double the number of pages freed each time there is subsequent
-	 * freeing of pages without any allocation.
+	 * Increase the batch number to the number of the consecutive
+	 * freed pages to reduce zone lock contention.
 	 */
-	batch <<= pcp->free_factor;
-	if (batch <= max_nr_free && pcp->free_factor < PCP_BATCH_SCALE_MAX)
-		pcp->free_factor++;
-	batch = clamp(batch, min_nr_free, max_nr_free);
+	batch = clamp_t(int, pcp->free_count, min_nr_free, max_nr_free);
 
 	return batch;
 }
@@ -2438,7 +2435,7 @@ static int nr_pcp_high(struct per_cpu_pa
 	 * stored on pcp lists
 	 */
 	if (test_bit(ZONE_RECLAIM_ACTIVE, &zone->flags)) {
-		pcp->high = max(high - (batch << pcp->free_factor), high_min);
+		pcp->high = max(high - pcp->free_count, high_min);
 		return min(batch << 2, pcp->high);
 	}
 
@@ -2446,10 +2443,10 @@ static int nr_pcp_high(struct per_cpu_pa
 		return high;
 
 	if (test_bit(ZONE_BELOW_HIGH, &zone->flags)) {
-		pcp->high = max(high - (batch << pcp->free_factor), high_min);
+		pcp->high = max(high - pcp->free_count, high_min);
 		high = max(pcp->count, high_min);
 	} else if (pcp->count >= high) {
-		int need_high = (batch << pcp->free_factor) + batch;
+		int need_high = pcp->free_count + batch;
 
 		/* pcp->high should be large enough to hold batch freed pages */
 		if (pcp->high < need_high)
@@ -2486,7 +2483,7 @@ static void free_unref_page_commit(struc
 	 * stops will be drained from vmstat refresh context.
 	 */
 	if (order && order <= PAGE_ALLOC_COSTLY_ORDER) {
-		free_high = (pcp->free_factor &&
+		free_high = (pcp->free_count >= batch &&
 			     (pcp->flags & PCPF_PREV_FREE_HIGH_ORDER) &&
 			     (!(pcp->flags & PCPF_FREE_HIGH_BATCH) ||
 			      pcp->count >= READ_ONCE(batch)));
@@ -2494,6 +2491,8 @@ static void free_unref_page_commit(struc
 	} else if (pcp->flags & PCPF_PREV_FREE_HIGH_ORDER) {
 		pcp->flags &= ~PCPF_PREV_FREE_HIGH_ORDER;
 	}
+	if (pcp->free_count < (batch << PCP_BATCH_SCALE_MAX))
+		pcp->free_count += (1 << order);
 	high = nr_pcp_high(pcp, zone, batch, free_high);
 	if (pcp->count >= high) {
 		free_pcppages_bulk(zone, nr_pcp_free(pcp, batch, high, free_high),
@@ -2891,7 +2890,7 @@ static struct page *rmqueue_pcplist(stru
 	 * See nr_pcp_free() where free_factor is increased for subsequent
 	 * frees.
 	 */
-	pcp->free_factor >>= 1;
+	pcp->free_count >>= 1;
 	list = &pcp->lists[order_to_pindex(migratetype, order)];
 	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
 	pcp_spin_unlock(pcp);
@@ -5513,7 +5512,7 @@ static void per_cpu_pages_init(struct pe
 	pcp->high_min = BOOT_PAGESET_HIGH;
 	pcp->high_max = BOOT_PAGESET_HIGH;
 	pcp->batch = BOOT_PAGESET_BATCH;
-	pcp->free_factor = 0;
+	pcp->free_count = 0;
 }
 
 static void __zone_set_pageset_high_and_batch(struct zone *zone, unsigned long high_min,
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-fix-draining-remote-pageset.patch
memory-tiering-add-abstract-distance-calculation-algorithms-management.patch
acpi-hmat-refactor-hmat_register_target_initiators.patch
acpi-hmat-calculate-abstract-distance-with-hmat.patch
dax-kmem-calculate-abstract-distance-with-general-interface.patch
mm-pcp-avoid-to-drain-pcp-when-process-exit.patch
cacheinfo-calculate-per-cpu-data-cache-size.patch
mm-pcp-reduce-lock-contention-for-draining-high-order-pages.patch
mm-restrict-the-pcp-batch-scale-factor-to-avoid-too-long-latency.patch
mm-page_alloc-scale-the-number-of-pages-that-are-batch-allocated.patch
mm-add-framework-for-pcp-high-auto-tuning.patch
mm-tune-pcp-high-automatically.patch
mm-pcp-decrease-pcp-high-if-free-pages-high-watermark.patch
mm-pcp-avoid-to-reduce-pcp-high-unnecessarily.patch
mm-pcp-reduce-detecting-time-of-consecutive-high-order-page-freeing.patch

