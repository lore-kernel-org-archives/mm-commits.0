Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11394C47088
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 23:43:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5ACF61404
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 23:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhEYXoh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 May 2021 19:44:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231356AbhEYXoh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 May 2021 19:44:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E657B60FDC;
        Tue, 25 May 2021 23:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621986186;
        bh=1vYcQgYDZnZuM6B5dDcup4GVod4RaSmUzJF0r9pMZNg=;
        h=Date:From:To:Subject:From;
        b=yUJbTgXLwMI5R1WsMzR9kMaO8iUxNiyrKWmgT5DOnj3AphExzutWsPLM/Es0lEeiH
         2iDkw3doD4/BCtvL+mq13OYwh1L7+Opig6bJiY6s4Dw+0KlMsI3FwliAQJtMkWWO5R
         CroK/h1yiOJOAeyADN5ETCZgwNKCqCvn46cyBTe0=
Date:   Tue, 25 May 2021 16:43:05 -0700
From:   akpm@linux-foundation.org
To:     dave.hansen@linux.intel.com, hdanton@sina.com,
        mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  +
 mm-page_alloc-scale-the-number-of-pages-that-are-batch-freed.patch added to
 -mm tree
Message-ID: <20210525234305.4I2jsAssZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: scale the number of pages that are batch freed
has been added to the -mm tree.  Its filename is
     mm-page_alloc-scale-the-number-of-pages-that-are-batch-freed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-scale-the-number-of-pages-that-are-batch-freed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-scale-the-number-of-pages-that-are-batch-freed.patch

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
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
@@ -3267,18 +3267,47 @@ static bool free_unref_page_prepare(stru
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
@@ -3530,7 +3559,14 @@ static struct page *rmqueue_pcplist(stru
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
@@ -6701,6 +6737,7 @@ static void per_cpu_pages_init(struct pe
 	 */
 	pcp->high = BOOT_PAGESET_HIGH;
 	pcp->batch = BOOT_PAGESET_BATCH;
+	pcp->free_factor = 0;
 }
 
 static void __zone_set_pageset_high_and_batch(struct zone *zone, unsigned long high,
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

