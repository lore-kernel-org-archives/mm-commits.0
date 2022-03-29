Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B0BC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 29 Mar 2022 01:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiC2BVx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 21:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiC2BVw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 21:21:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFDD2C10D
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 18:20:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D82B611D0
        for <mm-commits@vger.kernel.org>; Tue, 29 Mar 2022 01:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAECC340EC;
        Tue, 29 Mar 2022 01:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648516810;
        bh=IhAQk/YTgTjM0mksd/kJUPBDwe2zOV2vuEGo+wlSwHM=;
        h=Date:To:From:Subject:From;
        b=pwxqxLNDobYbhJ/hci0haeXvnumbVn/+F6kPDxyFxkMG85Mm1fwYwlvlJwJrZsrUm
         IdtmcEjzYP4u9QDVyOifz3PpRB/ZBjJiskSI85e+A9rDTNwXlGdyOAmDB27LjSa6vk
         YBtrd1haa99OJOnwOflcV+2f9Uuu2QoDEYqr+1qo=
Date:   Mon, 28 Mar 2022 18:20:09 -0700
To:     mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        mhocko@kernel.org, linmiaohe@huawei.com, david@redhat.com,
        osalvador@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-do-not-calculate-nodes-total-pages-and-memmap-pages-when-empty.patch added to -mm tree
Message-Id: <20220329012009.EEAECC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: do not calculate node's total pages and memmap pages when empty
has been added to the -mm tree.  Its filename is
     mm-page_alloc-do-not-calculate-nodes-total-pages-and-memmap-pages-when-empty.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-do-not-calculate-nodes-total-pages-and-memmap-pages-when-empty.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-do-not-calculate-nodes-total-pages-and-memmap-pages-when-empty.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm/page_alloc: do not calculate node's total pages and memmap pages when empty

Patch series "A minor hotplug refactoring".


This patch (of 3):

free_area_init_node() calls calculate_node_totalpages() and
free_area_init_core().  The former to get node's {spanned,present}_pages,
and the latter to calculate, among other things, how many pages per zone
we spent on memmap_pages, which is used to subtract zone's free pages.

On memoryless nodes, it is pointless to perform such a bunch of work, so
make sure we skip the calculations when having a node or empty zone.

Link: https://lkml.kernel.org/r/20220307150725.6810-1-osalvador@suse.de
Link: https://lkml.kernel.org/r/20220307150725.6810-2-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-do-not-calculate-nodes-total-pages-and-memmap-pages-when-empty
+++ a/mm/page_alloc.c
@@ -7321,6 +7321,10 @@ static void __init calculate_node_totalp
 	unsigned long realtotalpages = 0, totalpages = 0;
 	enum zone_type i;
 
+	/* Skip calculation for memoryless nodes */
+	if (node_start_pfn == node_end_pfn)
+		goto no_pages;
+
 	for (i = 0; i < MAX_NR_ZONES; i++) {
 		struct zone *zone = pgdat->node_zones + i;
 		unsigned long zone_start_pfn, zone_end_pfn;
@@ -7353,6 +7357,7 @@ static void __init calculate_node_totalp
 		realtotalpages += real_size;
 	}
 
+no_pages:
 	pgdat->node_spanned_pages = totalpages;
 	pgdat->node_present_pages = realtotalpages;
 	pr_debug("On node %d totalpages: %lu\n", pgdat->node_id, realtotalpages);
@@ -7570,6 +7575,10 @@ static void __init free_area_init_core(s
 		size = zone->spanned_pages;
 		freesize = zone->present_pages;
 
+		/* No pages? Nothing to calculate then. */
+		if (!size)
+			goto no_pages;
+
 		/*
 		 * Adjust freesize so that it accounts for how much memory
 		 * is used by this zone for memmap. This affects the watermark
@@ -7605,6 +7614,7 @@ static void __init free_area_init_core(s
 		 * when the bootmem allocator frees pages into the buddy system.
 		 * And all highmem pages will be managed by the buddy system.
 		 */
+no_pages:
 		zone_init_internals(zone, j, nid, freesize);
 
 		if (!size)
_

Patches currently in -mm which might be from osalvador@suse.de are

mm-untangle-config-dependencies-for-demote-on-reclaim.patch
mm-page_alloc-do-not-calculate-nodes-total-pages-and-memmap-pages-when-empty.patch
mm-memory_hotplug-reset-nodes-state-when-empty-during-offline.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node.patch

