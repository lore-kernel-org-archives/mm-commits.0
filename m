Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D62BC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C1A561D0D
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbhF2Cor (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:44:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231864AbhF2Coq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:44:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26C93611AE;
        Tue, 29 Jun 2021 02:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934539;
        bh=DARc/yGv/6Sre6e5DF6wj46V4atgCBNr2rP5BBydF2M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XUa54tqSHeZpCu3YUY6K78SSRooUxBTjsLn2xlO0V9BSnMrivF0GJNXA/ot4H2OJr
         MV0NXl2V8hOtwlDjp+MwlZHHYtdZkaQe1rEArefSeV/7s5C5tII/oLfCoeN2lSs0fa
         EmXHTHhkvjBlvaU1C1PNyqv3fzpcRGPO7M31VaoM=
Date:   Mon, 28 Jun 2021 19:42:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dave.hansen@linux.intel.com,
        hdanton@sina.com, linux-mm@kvack.org, mgorman@techsingularity.net,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 173/192] mm/page_alloc: scale the number of pages
 that are batch freed
Message-ID: <20210629024218.27SMI0erQ%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: scale the number of pages that are batch freed

When a task is freeing a large number of order-0 pages, it may acquire the
zone->lock multiple times freeing pages in batches.  This may
unnecessarily contend on the zone lock when freeing very large number of
pages.  This patch adapts the size of the batch based on the recent
pattern to scale the batch size for subsequent frees.

As the machines I used were not large enough to test this are not large
enough to illustrate a problem, a debugging patch shows patterns like the
following (slightly editted for clarity)

Baseline vanilla kernel
  time-unmap-14426   [...] free_pcppages_bulk: free   63 count  378 high  378
  time-unmap-14426   [...] free_pcppages_bulk: free   63 count  378 high  378
  time-unmap-14426   [...] free_pcppages_bulk: free   63 count  378 high  378
  time-unmap-14426   [...] free_pcppages_bulk: free   63 count  378 high  378
  time-unmap-14426   [...] free_pcppages_bulk: free   63 count  378 high  378

With patches
  time-unmap-7724    [...] free_pcppages_bulk: free  126 count  814 high  814
  time-unmap-7724    [...] free_pcppages_bulk: free  252 count  814 high  814
  time-unmap-7724    [...] free_pcppages_bulk: free  504 count  814 high  814
  time-unmap-7724    [...] free_pcppages_bulk: free  751 count  814 high  814
  time-unmap-7724    [...] free_pcppages_bulk: free  751 count  814 high  814

Link: https://lkml.kernel.org/r/20210525080119.5455-5-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +-
 mm/page_alloc.c        |   41 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 41 insertions(+), 3 deletions(-)

--- a/include/linux/mmzone.h~mm-page_alloc-scale-the-number-of-pages-that-are-batch-freed
+++ a/include/linux/mmzone.h
@@ -343,8 +343,9 @@ struct per_cpu_pages {
 	int count;		/* number of pages in the list */
 	int high;		/* high watermark, emptying needed */
 	int batch;		/* chunk size for buddy add/remove */
+	short free_factor;	/* batch scaling factor during free */
 #ifdef CONFIG_NUMA
-	int expire;		/* When 0, remote pagesets are drained */
+	short expire;		/* When 0, remote pagesets are drained */
 #endif
 
 	/* Lists of pages, one per migrate type stored on the pcp-lists */
--- a/mm/page_alloc.c~mm-page_alloc-scale-the-number-of-pages-that-are-batch-freed
+++ a/mm/page_alloc.c
@@ -3278,18 +3278,47 @@ static bool free_unref_page_prepare(stru
 	return true;
 }
 
+static int nr_pcp_free(struct per_cpu_pages *pcp, int high, int batch)
+{
+	int min_nr_free, max_nr_free;
+
+	/* Check for PCP disabled or boot pageset */
+	if (unlikely(high < batch))
+		return 1;
+
+	/* Leave at least pcp->batch pages on the list */
+	min_nr_free = batch;
+	max_nr_free = high - batch;
+
+	/*
+	 * Double the number of pages freed each time there is subsequent
+	 * freeing of pages without any allocation.
+	 */
+	batch <<= pcp->free_factor;
+	if (batch < max_nr_free)
+		pcp->free_factor++;
+	batch = clamp(batch, min_nr_free, max_nr_free);
+
+	return batch;
+}
+
 static void free_unref_page_commit(struct page *page, unsigned long pfn,
 				   int migratetype)
 {
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
+	int high;
 
 	__count_vm_event(PGFREE);
 	pcp = this_cpu_ptr(zone->per_cpu_pageset);
 	list_add(&page->lru, &pcp->lists[migratetype]);
 	pcp->count++;
-	if (pcp->count >= READ_ONCE(pcp->high))
-		free_pcppages_bulk(zone, READ_ONCE(pcp->batch), pcp);
+	high = READ_ONCE(pcp->high);
+	if (pcp->count >= high) {
+		int batch = READ_ONCE(pcp->batch);
+
+		free_pcppages_bulk(zone, nr_pcp_free(pcp, high, batch), pcp);
+	}
 }
 
 /*
@@ -3541,7 +3570,14 @@ static struct page *rmqueue_pcplist(stru
 	unsigned long flags;
 
 	local_lock_irqsave(&pagesets.lock, flags);
+
+	/*
+	 * On allocation, reduce the number of pages that are batch freed.
+	 * See nr_pcp_free() where free_factor is increased for subsequent
+	 * frees.
+	 */
 	pcp = this_cpu_ptr(zone->per_cpu_pageset);
+	pcp->free_factor >>= 1;
 	list = &pcp->lists[migratetype];
 	page = __rmqueue_pcplist(zone,  migratetype, alloc_flags, pcp, list);
 	local_unlock_irqrestore(&pagesets.lock, flags);
@@ -6737,6 +6773,7 @@ static void per_cpu_pages_init(struct pe
 	 */
 	pcp->high = BOOT_PAGESET_HIGH;
 	pcp->batch = BOOT_PAGESET_BATCH;
+	pcp->free_factor = 0;
 }
 
 static void __zone_set_pageset_high_and_batch(struct zone *zone, unsigned long high,
_
