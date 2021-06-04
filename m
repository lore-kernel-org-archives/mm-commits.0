Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6362C47082
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 00:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBE496140B
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 00:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhFDAeF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Jun 2021 20:34:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFDAeF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Jun 2021 20:34:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 029FF6140A;
        Fri,  4 Jun 2021 00:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622766729;
        bh=r06NMO7zj0zmJe/jgOcSWE6RmjOKY4ls7XQtscF3WIE=;
        h=Date:From:To:Subject:From;
        b=rMyBItIyXUBdxgp+rR5lpKNjtEtbcbU31NDPwwZSWcADPFZTimnXbv+MbkZue4+uA
         hpsLctm0o9yY+PWZMj2EcXMAxbolwbfb9r7mAv8CACsQL9ODKVRAYNGoHvrAdy3dnp
         TzVc8P2Jw5JeBFjRfECI4vBAvvahLvvFXC2kMKBk=
Date:   Thu, 03 Jun 2021 17:32:08 -0700
From:   akpm@linux-foundation.org
To:     brouer@redhat.com, dave.hansen@linux.intel.com,
        mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  + mm-page_alloc-move-free_the_page.patch added to -mm
 tree
Message-ID: <20210604003208.il6CkJNU7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: move free_the_page
has been added to the -mm tree.  Its filename is
     mm-page_alloc-move-free_the_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-move-free_the_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-move-free_the_page.patch

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
Subject: mm/page_alloc: move free_the_page

Patch series "Allow high order pages to be stored on PCP", v2.

The per-cpu page allocator (PCP) only handles order-0 pages.  With the
series "Use local_lock for pcp protection and reduce stat overhead" and
"Calculate pcp->high based on zone sizes and active CPUs", it's now
feasible to store high-order pages on PCP lists.

This small series allows PCP to store "cheap" orders where cheap is
determined by PAGE_ALLOC_COSTLY_ORDER and THP-sized allocations.


This patch (of 2):

In the next page, free_compount_page is going to use the common helper
free_the_page.  This patch moves the definition to ease review.  No
functional change.

Link: https://lkml.kernel.org/r/20210603142220.10851-1-mgorman@techsingularity.net
Link: https://lkml.kernel.org/r/20210603142220.10851-2-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-move-free_the_page
+++ a/mm/page_alloc.c
@@ -687,6 +687,14 @@ out:
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 
+static inline void free_the_page(struct page *page, unsigned int order)
+{
+	if (order == 0)		/* Via pcp? */
+		free_unref_page(page);
+	else
+		__free_pages_ok(page, order, FPI_NONE);
+}
+
 /*
  * Higher-order pages are called "compound pages".  They are structured thusly:
  *
@@ -5345,14 +5353,6 @@ unsigned long get_zeroed_page(gfp_t gfp_
 }
 EXPORT_SYMBOL(get_zeroed_page);
 
-static inline void free_the_page(struct page *page, unsigned int order)
-{
-	if (order == 0)		/* Via pcp? */
-		free_unref_page(page);
-	else
-		__free_pages_ok(page, order, FPI_NONE);
-}
-
 /**
  * __free_pages - Free pages allocated with alloc_pages().
  * @page: The page pointer returned from alloc_pages().
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
mm-page_alloc-move-free_the_page.patch
mm-page_alloc-allow-high-order-pages-to-be-stored-on-the-per-cpu-lists.patch
mm-vmscan-remove-kerneldoc-like-comment-from-isolate_lru_pages.patch
mm-vmalloc-include-header-for-prototype-of-set_iounmap_nonlazy.patch
mm-page_alloc-make-should_fail_alloc_page-a-static-function-should_fail_alloc_page-static.patch
mm-mapping_dirty_helpers-remove-double-note-in-kerneldoc.patch
mm-memcontrolc-fix-kerneldoc-comment-for-mem_cgroup_calculate_protection.patch
mm-memory_hotplug-fix-kerneldoc-comment-for-__try_online_node.patch
mm-memory_hotplug-fix-kerneldoc-comment-for-__remove_memory.patch
mm-zbud-add-kerneldoc-fields-for-zbud_pool.patch
mm-z3fold-add-kerneldoc-fields-for-z3fold_pool.patch
mm-swap-make-swap_address_space-an-inline-function.patch
mm-mmap_lock-remove-dead-code-for-config_tracing-configurations.patch
mm-page_alloc-move-prototype-for-find_suitable_fallback.patch
mm-swap-make-node_data-an-inline-function-on-config_flatmem.patch

