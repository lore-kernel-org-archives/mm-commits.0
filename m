Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2856CC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236070AbiEJEPr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236057AbiEJEPc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:15:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799753E5DD
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8F4FB817CC
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98998C385C7;
        Tue, 10 May 2022 04:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155866;
        bh=/npXT1TNuLjLbKCVG+JH2wqpgpk2Zzkd+dY+tp7ZppI=;
        h=Date:To:From:Subject:From;
        b=rThtmBdNMC4wyuOEiivrEvAydu/t3RJnL3TZ7B+DCGzmHmErcjOfJkfpd67TfAbCJ
         dOMk3nskqYR/yp2MY0Xmudw09fZ7EeN4XFCoAAbs/KWwSeZ/NXvdwGkamVHyrzUHtM
         8bnQyCR4q5SKFPaDeehpmMLLgtGd4Ndjdzm9EKSs=
Date:   Mon, 09 May 2022 21:11:06 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        osalvador@suse.de, mgorman@techsingularity.net,
        linmiaohe@huawei.com, david@redhat.com, richard.weiyang@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone.patch removed from -mm tree
Message-Id: <20220510041106.98998C385C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: make sure wakeup_kswapd with managed zone
has been removed from the -mm tree.  Its filename was
     mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/vmscan: make sure wakeup_kswapd with managed zone

wakeup_kswapd() only wake up kswapd when the zone is managed.

For two callers of wakeup_kswapd(), they are node perspective.

  * wake_all_kswapds
  * numamigrate_isolate_page

If we picked up a !managed zone, this is not we expected.

This patch makes sure we pick up a managed zone for wakeup_kswapd().  And
it also use managed_zone in migrate_balanced_pgdat() to get the proper
zone.

[richard.weiyang@gmail.com: adjust the usage in migrate_balanced_pgdat()]
  Link: https://lkml.kernel.org/r/20220329010901.1654-2-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20220327024101.10378-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c    |    6 +++---
 mm/page_alloc.c |    2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/mm/migrate.c~mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone
+++ a/mm/migrate.c
@@ -1969,7 +1969,7 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid,
 #ifdef CONFIG_NUMA_BALANCING
 /*
  * Returns true if this is a safe migration target node for misplaced NUMA
- * pages. Currently it only checks the watermarks which crude
+ * pages. Currently it only checks the watermarks which is crude.
  */
 static bool migrate_balanced_pgdat(struct pglist_data *pgdat,
 				   unsigned long nr_migrate_pages)
@@ -1979,7 +1979,7 @@ static bool migrate_balanced_pgdat(struc
 	for (z = pgdat->nr_zones - 1; z >= 0; z--) {
 		struct zone *zone = pgdat->node_zones + z;
 
-		if (!populated_zone(zone))
+		if (!managed_zone(zone))
 			continue;
 
 		/* Avoid waking kswapd by allocating pages_to_migrate pages. */
@@ -2032,7 +2032,7 @@ static int numamigrate_isolate_page(pg_d
 		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING))
 			return 0;
 		for (z = pgdat->nr_zones - 1; z >= 0; z--) {
-			if (populated_zone(pgdat->node_zones + z))
+			if (managed_zone(pgdat->node_zones + z))
 				break;
 		}
 		wakeup_kswapd(pgdat->node_zones + z, 0, order, ZONE_MOVABLE);
--- a/mm/page_alloc.c~mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone
+++ a/mm/page_alloc.c
@@ -4629,6 +4629,8 @@ static void wake_all_kswapds(unsigned in
 
 	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, highest_zoneidx,
 					ac->nodemask) {
+		if (!managed_zone(zone))
+			continue;
 		if (last_pgdat != zone->zone_pgdat)
 			wakeup_kswapd(zone, gfp_mask, order, highest_zoneidx);
 		last_pgdat = zone->zone_pgdat;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration.patch
mm-vmscan-filter-empty-page_list-at-the-beginning.patch
mm-vmscan-not-use-numa_no_node-as-indicator-of-page-on-different-node.patch

