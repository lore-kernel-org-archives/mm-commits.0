Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708FDC77B7A
	for <mm-commits@archiver.kernel.org>; Fri, 26 May 2023 18:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbjEZSbC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 May 2023 14:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjEZSbB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 May 2023 14:31:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED28E7
        for <mm-commits@vger.kernel.org>; Fri, 26 May 2023 11:31:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9AD365227
        for <mm-commits@vger.kernel.org>; Fri, 26 May 2023 18:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F214EC433D2;
        Fri, 26 May 2023 18:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685125859;
        bh=PATxn6gQTPr7IzcMtOAe5X6U6pJXDfOkDxSVjSRecsM=;
        h=Date:To:From:Subject:From;
        b=Qs06C1uZnsaWFEOa6iO3UyDmMH1VKqPOBnTX3yZTvH+AqIKwomVmSWfNO5WIhJj+4
         pDV+42r6kCd9AEESQVBN+g2S7bAmUkB6eqLHr3OoMXX9ryzzkzR5/dOlJ+okd+5Two
         m+V/hsoqTEiIoMf6uqeNI/P76nqtYZhANzxFjx8Q=
Date:   Fri, 26 May 2023 11:30:58 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, mhocko@suse.com,
        david@redhat.com, haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-introduce-reset_memoryless_node_totalpages.patch added to mm-unstable branch
Message-Id: <20230526183058.F214EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mm_init.c: introduce reset_memoryless_node_totalpages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-introduce-reset_memoryless_node_totalpages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-introduce-reset_memoryless_node_totalpages.patch

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

memcg-oom-remove-unnecessary-check-in-mem_cgroup_oom_synchronize.patch
memcg-oom-remove-explicit-wakeup-in-mem_cgroup_oom_synchronize.patch
mm-oom-do-not-check-0-mask-in-out_of_memory.patch
mm-memcontrol-fix-typo-in-comment.patch
selftests-cgroup-fix-unexpected-failure-on-test_memcg_low.patch
mm-mm_initc-introduce-reset_memoryless_node_totalpages.patch
mm-mm_initc-do-not-calculate-zone_start_pfn-zone_end_pfn-in-zone_absent_pages_in_node.patch
fork-optimize-memcg_charge_kernel_stack-a-bit.patch

