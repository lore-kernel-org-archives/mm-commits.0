Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D97DC7EE23
	for <mm-commits@archiver.kernel.org>; Fri, 26 May 2023 18:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236460AbjEZSbK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 May 2023 14:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjEZSbD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 May 2023 14:31:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478EFE7
        for <mm-commits@vger.kernel.org>; Fri, 26 May 2023 11:31:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D309B65227
        for <mm-commits@vger.kernel.org>; Fri, 26 May 2023 18:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1111CC433D2;
        Fri, 26 May 2023 18:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685125861;
        bh=6YEPY5/3WGt7kHf4fDlQX4MUhQUswaCWUhE30c+JgeM=;
        h=Date:To:From:Subject:From;
        b=X76e1ufPFizpS4k/DurV2rn3WXGx+4RuG57H12LboAw81DGLfkw5RGj107VHYLyCo
         CSqO7UJo4LncedH9vfBbwMZSxfBDBtzZUHTnEkxH9iQ4hWEzwht86YGF/PZ494Hk4H
         N4exsEphnuFh7yb5lk9wcqGEReMlKZgwTYg1L3FY=
Date:   Fri, 26 May 2023 11:31:00 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, mhocko@suse.com,
        david@redhat.com, haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-do-not-calculate-zone_start_pfn-zone_end_pfn-in-zone_absent_pages_in_node.patch added to mm-unstable branch
Message-Id: <20230526183101.1111CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mm_init.c: do not calculate zone_start_pfn/zone_end_pfn in zone_absent_pages_in_node()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-do-not-calculate-zone_start_pfn-zone_end_pfn-in-zone_absent_pages_in_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-do-not-calculate-zone_start_pfn-zone_end_pfn-in-zone_absent_pages_in_node.patch

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
Subject: mm/mm_init.c: do not calculate zone_start_pfn/zone_end_pfn in zone_absent_pages_in_node()
Date: Fri, 26 May 2023 08:52:51 +0000

In calculate_node_totalpages(), zone_start_pfn/zone_end_pfn are already
calculated in zone_spanned_pages_in_node(), so use them as parameters
instead of node_start_pfn/node_end_pfn and the duplicated calculation
process can de dropped.

Link: https://lkml.kernel.org/r/20230526085251.1977-2-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Haifeng Xu <haifeng.xu@shopee.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-do-not-calculate-zone_start_pfn-zone_end_pfn-in-zone_absent_pages_in_node
+++ a/mm/mm_init.c
@@ -1168,20 +1168,15 @@ unsigned long __init absent_pages_in_ran
 /* Return the number of page frames in holes in a zone on a node */
 static unsigned long __init zone_absent_pages_in_node(int nid,
 					unsigned long zone_type,
-					unsigned long node_start_pfn,
-					unsigned long node_end_pfn)
+					unsigned long zone_start_pfn,
+					unsigned long zone_end_pfn)
 {
-	unsigned long zone_low = arch_zone_lowest_possible_pfn[zone_type];
-	unsigned long zone_high = arch_zone_highest_possible_pfn[zone_type];
-	unsigned long zone_start_pfn, zone_end_pfn;
 	unsigned long nr_absent;
 
-	zone_start_pfn = clamp(node_start_pfn, zone_low, zone_high);
-	zone_end_pfn = clamp(node_end_pfn, zone_low, zone_high);
+	/* zone is empty, we don't have any absent pages */
+	if (zone_start_pfn == zone_end_pfn)
+		return 0;
 
-	adjust_zone_range_for_zone_movable(nid, zone_type,
-			node_start_pfn, node_end_pfn,
-			&zone_start_pfn, &zone_end_pfn);
 	nr_absent = __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
 
 	/*
@@ -1274,7 +1269,7 @@ static void __init calculate_node_totalp
 		struct zone *zone = pgdat->node_zones + i;
 		unsigned long zone_start_pfn, zone_end_pfn;
 		unsigned long spanned, absent;
-		unsigned long size, real_size;
+		unsigned long real_size;
 
 		spanned = zone_spanned_pages_in_node(pgdat->node_id, i,
 						     node_start_pfn,
@@ -1282,23 +1277,22 @@ static void __init calculate_node_totalp
 						     &zone_start_pfn,
 						     &zone_end_pfn);
 		absent = zone_absent_pages_in_node(pgdat->node_id, i,
-						   node_start_pfn,
-						   node_end_pfn);
+						   zone_start_pfn,
+						   zone_end_pfn);
 
-		size = spanned;
-		real_size = size - absent;
+		real_size = spanned - absent;
 
-		if (size)
+		if (spanned)
 			zone->zone_start_pfn = zone_start_pfn;
 		else
 			zone->zone_start_pfn = 0;
-		zone->spanned_pages = size;
+		zone->spanned_pages = spanned;
 		zone->present_pages = real_size;
 #if defined(CONFIG_MEMORY_HOTPLUG)
 		zone->present_early_pages = real_size;
 #endif
 
-		totalpages += size;
+		totalpages += spanned;
 		realtotalpages += real_size;
 	}
 
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

