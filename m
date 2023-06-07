Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9267CC7EE25
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 03:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235157AbjFGDgL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jun 2023 23:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234983AbjFGDgI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jun 2023 23:36:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD16B0
        for <mm-commits@vger.kernel.org>; Tue,  6 Jun 2023 20:36:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B46A2639D3
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 03:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006A5C433D2;
        Wed,  7 Jun 2023 03:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686108963;
        bh=11vxVeMXOrJaVnoKToK+1ygaed3BtpMLd8R6nCKEdUo=;
        h=Date:To:From:Subject:From;
        b=xQOKk5hqIIjvmCufGISVpRCIiuFVFn0YQXc/ihCCw2upVGcPJCXOL43G0zsDh4Bj4
         h6pbu0bu3Vp8wn2ny3Pmj68L0SvmogfzGrCrJ6S/M2C0d725Cun7x86J5KFbS8UaVp
         qg00G9dYIFPtELWvZXig46VLas8C15xiNUs/gNuA=
Date:   Tue, 06 Jun 2023 20:36:02 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, mhocko@kernel.org,
        haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-drop-nid-parameter-from-check_for_memory.patch added to mm-unstable branch
Message-Id: <20230607033603.006A5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mm_init.c: drop 'nid' parameter from check_for_memory()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-drop-nid-parameter-from-check_for_memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-drop-nid-parameter-from-check_for_memory.patch

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
Subject: mm/mm_init.c: drop 'nid' parameter from check_for_memory()
Date: Wed, 7 Jun 2023 03:24:02 +0000

The node_id in pgdat has already been set in free_area_init_node(),
so use it internally instead of passing a redundant parameter.

Link: https://lkml.kernel.org/r/20230607032402.4679-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-drop-nid-parameter-from-check_for_memory
+++ a/mm/mm_init.c
@@ -1735,7 +1735,7 @@ static void __init free_area_init_node(i
 }
 
 /* Any regular or high memory on that node ? */
-static void check_for_memory(pg_data_t *pgdat, int nid)
+static void check_for_memory(pg_data_t *pgdat)
 {
 	enum zone_type zone_type;
 
@@ -1743,9 +1743,9 @@ static void check_for_memory(pg_data_t *
 		struct zone *zone = &pgdat->node_zones[zone_type];
 		if (populated_zone(zone)) {
 			if (IS_ENABLED(CONFIG_HIGHMEM))
-				node_set_state(nid, N_HIGH_MEMORY);
+				node_set_state(pgdat->node_id, N_HIGH_MEMORY);
 			if (zone_type <= ZONE_NORMAL)
-				node_set_state(nid, N_NORMAL_MEMORY);
+				node_set_state(pgdat->node_id, N_NORMAL_MEMORY);
 			break;
 		}
 	}
@@ -1897,7 +1897,7 @@ void __init free_area_init(unsigned long
 		/* Any memory on that node */
 		if (pgdat->node_present_pages)
 			node_set_state(nid, N_MEMORY);
-		check_for_memory(pgdat, nid);
+		check_for_memory(pgdat);
 	}
 
 	memmap_init();
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

memcg-oom-remove-unnecessary-check-in-mem_cgroup_oom_synchronize.patch
memcg-oom-remove-explicit-wakeup-in-mem_cgroup_oom_synchronize.patch
mm-oom-do-not-check-0-mask-in-out_of_memory.patch
mm-memcontrol-fix-typo-in-comment.patch
selftests-cgroup-fix-unexpected-failure-on-test_memcg_low.patch
mm-mm_initc-introduce-reset_memoryless_node_totalpages.patch
mm-mm_initc-do-not-calculate-zone_start_pfn-zone_end_pfn-in-zone_absent_pages_in_node.patch
mm-mm_initc-remove-free_area_init_memoryless_node.patch
mm-mm_initc-move-set_pageblock_order-to-free_area_init.patch
mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat.patch
mm-mm_initc-remove-reset_node_present_pages.patch
mm-mm_initc-drop-nid-parameter-from-check_for_memory.patch
fork-optimize-memcg_charge_kernel_stack-a-bit.patch

