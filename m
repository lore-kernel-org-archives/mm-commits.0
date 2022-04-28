Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18DDBC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 28 Apr 2022 21:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346159AbiD1Vyz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Apr 2022 17:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352651AbiD1Vyt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2022 17:54:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BA447568
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 14:51:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09DE061FB9
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 21:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D198C385A9;
        Thu, 28 Apr 2022 21:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651182680;
        bh=SIVKJGuXJ4JavhE0AI1/L+00Aes/f+cvDqpGQWK/M5A=;
        h=Date:To:From:Subject:From;
        b=sCWWD2iYxkU+Pb7nx9nHQVl4Pox9SB4Ghyd62QrB7z34w4PEpGWlthvIONGBZLHQY
         vPG1hHjgKx3O89MCN/hMiV29GIvSeadne3jp9jONmTNu1A43px8K1zA5hQ3OfHzReJ
         PG+MImfUArHu54MpX3n1H6LqaSc6KiVy470Vm2Ys=
Date:   Thu, 28 Apr 2022 14:51:19 -0700
To:     mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        mhocko@kernel.org, linmiaohe@huawei.com, david@redhat.com,
        osalvador@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_alloc-do-not-calculate-nodes-total-pages-and-memmap-pages-when-empty.patch removed from -mm tree
Message-Id: <20220428215120.5D198C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: do not calculate node's total pages and memmap pages when empty
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-do-not-calculate-nodes-total-pages-and-memmap-pages-when-empty.patch

This patch was dropped because an updated version will be merged

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
@@ -7291,6 +7291,10 @@ static void __init calculate_node_totalp
 	unsigned long realtotalpages = 0, totalpages = 0;
 	enum zone_type i;
 
+	/* Skip calculation for memoryless nodes */
+	if (node_start_pfn == node_end_pfn)
+		goto no_pages;
+
 	for (i = 0; i < MAX_NR_ZONES; i++) {
 		struct zone *zone = pgdat->node_zones + i;
 		unsigned long zone_start_pfn, zone_end_pfn;
@@ -7323,6 +7327,7 @@ static void __init calculate_node_totalp
 		realtotalpages += real_size;
 	}
 
+no_pages:
 	pgdat->node_spanned_pages = totalpages;
 	pgdat->node_present_pages = realtotalpages;
 	pr_debug("On node %d totalpages: %lu\n", pgdat->node_id, realtotalpages);
@@ -7540,6 +7545,10 @@ static void __init free_area_init_core(s
 		size = zone->spanned_pages;
 		freesize = zone->present_pages;
 
+		/* No pages? Nothing to calculate then. */
+		if (!size)
+			goto no_pages;
+
 		/*
 		 * Adjust freesize so that it accounts for how much memory
 		 * is used by this zone for memmap. This affects the watermark
@@ -7575,6 +7584,7 @@ static void __init free_area_init_core(s
 		 * when the bootmem allocator frees pages into the buddy system.
 		 * And all highmem pages will be managed by the buddy system.
 		 */
+no_pages:
 		zone_init_internals(zone, j, nid, freesize);
 
 		if (!size)
_

Patches currently in -mm which might be from osalvador@suse.de are

mm-memory_hotplug-reset-nodes-state-when-empty-during-offline.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node.patch

