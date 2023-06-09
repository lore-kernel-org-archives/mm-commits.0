Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51AF0C7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbjFIXd3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbjFIXcU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CC649C1
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 396EF60D2C
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88903C433D2;
        Fri,  9 Jun 2023 23:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353390;
        bh=LTEIBgVUAZenSEsPpV4xXjwB0+MyCYdhvG0pYMjnSrE=;
        h=Date:To:From:Subject:From;
        b=z66JA3r2NqjuJOrYbxFjZXDyKXmBs6GYJyu0Iz7zPrWh4ybJkj2A4k8IM+EQzz+EY
         wVWPiBRRRTZLHoz1vJMBftTKv/ft6jDU0CA3H9jpvgajRPfnTpojmFqxRvCgQTHHmO
         NwBV1gs79o6VAIKG2SDCsBUvPBPAsnuJoOcBIsvs=
Date:   Fri, 09 Jun 2023 16:29:49 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, mhocko@suse.com,
        david@redhat.com, haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-introduce-reset_memoryless_node_totalpages.patch removed from -mm tree
Message-Id: <20230609232950.88903C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mm_init.c: introduce reset_memoryless_node_totalpages()
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-introduce-reset_memoryless_node_totalpages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: mm/mm_init.c: introduce reset_memoryless_node_totalpages()
Date: Fri, 26 May 2023 08:52:50 +0000

Currently, no matter whether a node actually has memory or not,
calculate_node_totalpages() is used to account number of pages in
zone/node.  However, for node without memory, these unnecessary
calculations can be skipped.  All the zone/node page counts can be set to
0 directly.  So introduce reset_memoryless_node_totalpages() to perform
this action.

Furthermore, calculate_node_totalpages() only gets called for the node
with memory.

Link: https://lkml.kernel.org/r/20230526085251.1977-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-introduce-reset_memoryless_node_totalpages
+++ a/mm/mm_init.c
@@ -1176,10 +1176,6 @@ static unsigned long __init zone_absent_
 	unsigned long zone_start_pfn, zone_end_pfn;
 	unsigned long nr_absent;
 
-	/* When hotadd a new node from cpu_up(), the node should be empty */
-	if (!node_start_pfn && !node_end_pfn)
-		return 0;
-
 	zone_start_pfn = clamp(node_start_pfn, zone_low, zone_high);
 	zone_end_pfn = clamp(node_end_pfn, zone_low, zone_high);
 
@@ -1229,9 +1225,6 @@ static unsigned long __init zone_spanned
 {
 	unsigned long zone_low = arch_zone_lowest_possible_pfn[zone_type];
 	unsigned long zone_high = arch_zone_highest_possible_pfn[zone_type];
-	/* When hotadd a new node from cpu_up(), the node should be empty */
-	if (!node_start_pfn && !node_end_pfn)
-		return 0;
 
 	/* Get the start and end of the zone */
 	*zone_start_pfn = clamp(node_start_pfn, zone_low, zone_high);
@@ -1252,6 +1245,24 @@ static unsigned long __init zone_spanned
 	return *zone_end_pfn - *zone_start_pfn;
 }
 
+static void __init reset_memoryless_node_totalpages(struct pglist_data *pgdat)
+{
+	struct zone *z;
+
+	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++) {
+		z->zone_start_pfn = 0;
+		z->spanned_pages = 0;
+		z->present_pages = 0;
+#if defined(CONFIG_MEMORY_HOTPLUG)
+		z->present_early_pages = 0;
+#endif
+	}
+
+	pgdat->node_spanned_pages = 0;
+	pgdat->node_present_pages = 0;
+	pr_debug("On node %d totalpages: 0\n", pgdat->node_id);
+}
+
 static void __init calculate_node_totalpages(struct pglist_data *pgdat,
 						unsigned long node_start_pfn,
 						unsigned long node_end_pfn)
@@ -1704,11 +1715,13 @@ static void __init free_area_init_node(i
 		pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
 			(u64)start_pfn << PAGE_SHIFT,
 			end_pfn ? ((u64)end_pfn << PAGE_SHIFT) - 1 : 0);
+
+		calculate_node_totalpages(pgdat, start_pfn, end_pfn);
 	} else {
 		pr_info("Initmem setup node %d as memoryless\n", nid);
-	}
 
-	calculate_node_totalpages(pgdat, start_pfn, end_pfn);
+		reset_memoryless_node_totalpages(pgdat);
+	}
 
 	alloc_node_mem_map(pgdat);
 	pgdat_set_deferred_range(pgdat);
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

mm-mm_initc-drop-nid-parameter-from-check_for_memory.patch
mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat.patch
mm-mm_initc-remove-reset_node_present_pages.patch
fork-optimize-memcg_charge_kernel_stack-a-bit.patch

