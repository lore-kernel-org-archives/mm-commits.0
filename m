Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C566C7EE25
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 17:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbjFGRwB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jun 2023 13:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbjFGRv5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jun 2023 13:51:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6E31FD6
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 10:51:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADA3C64250
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 17:51:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08365C433EF;
        Wed,  7 Jun 2023 17:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686160314;
        bh=knOlC3yT1rREjZWX03EUXVLiavpxPtViefKTEBWLLWo=;
        h=Date:To:From:Subject:From;
        b=ypgxAqf903ILDMPm0pMNBgEbXPou6sgJUvWr7iPtv7TPTatMHc0Mc/vf2tYu0TXim
         6FjiL6QVU7aE0ZZ3BqwDTy1co9ENPdKjN5Jp4nzGr0jHFOJFP2DpbiP6ZZeCtqFT83
         MV73S3ocKdrvL8iACUqGDcu3c2+zGWlZdJPMhroc=
Date:   Wed, 07 Jun 2023 10:51:53 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, osalvador@suse.de,
        mhocko@kernel.org, david@redhat.com, haifeng.xu@shopee.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-remove-reset_node_present_pages.patch added to mm-unstable branch
Message-Id: <20230607175154.08365C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mm_init.c: remove reset_node_present_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-remove-reset_node_present_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-remove-reset_node_present_pages.patch

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
Subject: mm/mm_init.c: remove reset_node_present_pages()
Date: Wed, 7 Jun 2023 02:50:56 +0000

reset_node_present_pages() only get called in hotadd_init_pgdat(), move
the action that clear present pages to free_area_init_core_hotplug(), so
the helper can be removed.

Link: https://lkml.kernel.org/r/20230607025056.1348-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   18 ------------------
 mm/mm_init.c        |   15 +++++++++++++--
 2 files changed, 13 insertions(+), 20 deletions(-)

--- a/mm/memory_hotplug.c~mm-mm_initc-remove-reset_node_present_pages
+++ a/mm/memory_hotplug.c
@@ -1156,16 +1156,6 @@ failed_addition:
 	return ret;
 }
 
-static void reset_node_present_pages(pg_data_t *pgdat)
-{
-	struct zone *z;
-
-	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
-		z->present_pages = 0;
-
-	pgdat->node_present_pages = 0;
-}
-
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
 static pg_data_t __ref *hotadd_init_pgdat(int nid)
 {
@@ -1188,14 +1178,6 @@ static pg_data_t __ref *hotadd_init_pgda
 	 */
 	build_all_zonelists(pgdat);
 
-	/*
-	 * When memory is hot-added, all the memory is in offline state. So
-	 * clear all zones' present_pages because they will be updated in
-	 * online_pages() and offline_pages().
-	 * TODO: should be in free_area_init_core_hotplug?
-	 */
-	reset_node_present_pages(pgdat);
-
 	return pgdat;
 }
 
--- a/mm/mm_init.c~mm-mm_initc-remove-reset_node_present_pages
+++ a/mm/mm_init.c
@@ -1509,6 +1509,8 @@ void __ref free_area_init_core_hotplug(s
 	pgdat->kswapd_order = 0;
 	pgdat->kswapd_highest_zoneidx = 0;
 	pgdat->node_start_pfn = 0;
+	pgdat->node_present_pages = 0;
+
 	for_each_online_cpu(cpu) {
 		struct per_cpu_nodestat *p;
 
@@ -1516,8 +1518,17 @@ void __ref free_area_init_core_hotplug(s
 		memset(p, 0, sizeof(*p));
 	}
 
-	for (z = 0; z < MAX_NR_ZONES; z++)
-		zone_init_internals(&pgdat->node_zones[z], z, nid, 0);
+	/*
+	 * When memory is hot-added, all the memory is in offline state. So
+	 * clear all zones' present_pages and managed_pages because they will
+	 * be updated in online_pages() and offline_pages().
+	 */
+	for (z = 0; z < MAX_NR_ZONES; z++) {
+		struct zone *zone = pgdat->node_zones + z;
+
+		zone->present_pages = 0;
+		zone_init_internals(zone, z, nid, 0);
+	}
 }
 #endif
 
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
mm-mm_initc-drop-nid-parameter-from-check_for_memory.patch
mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat.patch
mm-mm_initc-remove-reset_node_present_pages.patch
fork-optimize-memcg_charge_kernel_stack-a-bit.patch

