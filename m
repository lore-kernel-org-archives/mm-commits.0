Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DDCBCDB482
	for <mm-commits@archiver.kernel.org>; Mon, 16 Oct 2023 22:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbjJPWtv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Oct 2023 18:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234185AbjJPWtr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2023 18:49:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0695EF2
        for <mm-commits@vger.kernel.org>; Mon, 16 Oct 2023 15:49:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935FCC433C7;
        Mon, 16 Oct 2023 22:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697496585;
        bh=aMM3ZVcggATOKHjHJnCOkhVUOqGWCVpRL81ZJoEN4jw=;
        h=Date:To:From:Subject:From;
        b=vi/oO7D759hSerjd7DksAfvii6HzmSS+kNysTxB+sVBSgf5sj5F+V3+JB5QzZT1f4
         Qf7s3FInjwllkOdV1YhB46EJ0FxF4Y67QBtr8ZkyYqw0TzSFJX2aB7DxjSBcgz0gnl
         V0W8PYoReTSjiZm+C+CmacKJAtIkawo7IjmMwEtA=
Date:   Mon, 16 Oct 2023 15:49:45 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        sudeep.holla@arm.com, pasha.tatashin@soleen.com, mhocko@suse.com,
        mgorman@techsingularity.net, jweiner@redhat.com, david@redhat.com,
        dave.hansen@linux.intel.com, cl@linux.com, arjan@linux.intel.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-scale-the-number-of-pages-that-are-batch-allocated.patch added to mm-unstable branch
Message-Id: <20231016224945.935FCC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: scale the number of pages that are batch allocated
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-scale-the-number-of-pages-that-are-batch-allocated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-scale-the-number-of-pages-that-are-batch-allocated.patch

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
Subject: mm, page_alloc: scale the number of pages that are batch allocated
Date: Mon, 16 Oct 2023 13:29:58 +0800

When a task is allocating a large number of order-0 pages, it may acquire
the zone->lock multiple times allocating pages in batches.  This may
unnecessarily contend on the zone lock when allocating very large number
of pages.  This patch adapts the size of the batch based on the recent
pattern to scale the batch size for subsequent allocations.

On a 2-socket Intel server with 224 logical CPU, we run 8 kbuild instances
in parallel (each with `make -j 28`) in 8 cgroup.  This simulates the
kbuild server that is used by 0-Day kbuild service.  With the patch, the
cycles% of the spinlock contention (mostly for zone lock) decreases from
12.6% to 11.0% (with PCP size == 367).

Link: https://lkml.kernel.org/r/20231016053002.756205-6-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Suggested-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
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

 include/linux/mmzone.h |    3 +-
 mm/page_alloc.c        |   53 +++++++++++++++++++++++++++++++--------
 2 files changed, 45 insertions(+), 11 deletions(-)

--- a/include/linux/mmzone.h~mm-page_alloc-scale-the-number-of-pages-that-are-batch-allocated
+++ a/include/linux/mmzone.h
@@ -709,9 +709,10 @@ struct per_cpu_pages {
 	int high;		/* high watermark, emptying needed */
 	int batch;		/* chunk size for buddy add/remove */
 	u8 flags;		/* protected by pcp->lock */
+	u8 alloc_factor;	/* batch scaling factor during allocate */
 	u8 free_factor;		/* batch scaling factor during free */
 #ifdef CONFIG_NUMA
-	short expire;		/* When 0, remote pagesets are drained */
+	u8 expire;		/* When 0, remote pagesets are drained */
 #endif
 
 	/* Lists of pages, one per migrate type stored on the pcp-lists */
--- a/mm/page_alloc.c~mm-page_alloc-scale-the-number-of-pages-that-are-batch-allocated
+++ a/mm/page_alloc.c
@@ -2409,6 +2409,12 @@ static void free_unref_page_commit(struc
 	int pindex;
 	bool free_high = false;
 
+	/*
+	 * On freeing, reduce the number of pages that are batch allocated.
+	 * See nr_pcp_alloc() where alloc_factor is increased for subsequent
+	 * allocations.
+	 */
+	pcp->alloc_factor >>= 1;
 	__count_vm_events(PGFREE, 1 << order);
 	pindex = order_to_pindex(migratetype, order);
 	list_add(&page->pcp_list, &pcp->lists[pindex]);
@@ -2715,6 +2721,42 @@ struct page *rmqueue_buddy(struct zone *
 	return page;
 }
 
+static int nr_pcp_alloc(struct per_cpu_pages *pcp, int order)
+{
+	int high, batch, max_nr_alloc;
+
+	high = READ_ONCE(pcp->high);
+	batch = READ_ONCE(pcp->batch);
+
+	/* Check for PCP disabled or boot pageset */
+	if (unlikely(high < batch))
+		return 1;
+
+	/*
+	 * Double the number of pages allocated each time there is subsequent
+	 * allocation of order-0 pages without any freeing.
+	 */
+	if (!order) {
+		max_nr_alloc = max(high - pcp->count - batch, batch);
+		batch <<= pcp->alloc_factor;
+		if (batch <= max_nr_alloc &&
+		    pcp->alloc_factor < CONFIG_PCP_BATCH_SCALE_MAX)
+			pcp->alloc_factor++;
+		batch = min(batch, max_nr_alloc);
+	}
+
+	/*
+	 * Scale batch relative to order if batch implies free pages
+	 * can be stored on the PCP. Batch can be 1 for small zones or
+	 * for boot pagesets which should never store free pages as
+	 * the pages may belong to arbitrary zones.
+	 */
+	if (batch > 1)
+		batch = max(batch >> order, 2);
+
+	return batch;
+}
+
 /* Remove page from the per-cpu list, caller must protect the list */
 static inline
 struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
@@ -2727,18 +2769,9 @@ struct page *__rmqueue_pcplist(struct zo
 
 	do {
 		if (list_empty(list)) {
-			int batch = READ_ONCE(pcp->batch);
+			int batch = nr_pcp_alloc(pcp, order);
 			int alloced;
 
-			/*
-			 * Scale batch relative to order if batch implies
-			 * free pages can be stored on the PCP. Batch can
-			 * be 1 for small zones or for boot pagesets which
-			 * should never store free pages as the pages may
-			 * belong to arbitrary zones.
-			 */
-			if (batch > 1)
-				batch = max(batch >> order, 2);
 			alloced = rmqueue_bulk(zone, order,
 					batch, list,
 					migratetype, alloc_flags);
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-fix-draining-remote-pageset.patch
mm-pcp-avoid-to-drain-pcp-when-process-exit.patch
cacheinfo-calculate-size-of-per-cpu-data-cache-slice.patch
mm-pcp-reduce-lock-contention-for-draining-high-order-pages.patch
mm-restrict-the-pcp-batch-scale-factor-to-avoid-too-long-latency.patch
mm-page_alloc-scale-the-number-of-pages-that-are-batch-allocated.patch
mm-add-framework-for-pcp-high-auto-tuning.patch
mm-tune-pcp-high-automatically.patch
mm-pcp-decrease-pcp-high-if-free-pages-high-watermark.patch
mm-pcp-reduce-detecting-time-of-consecutive-high-order-page-freeing.patch

