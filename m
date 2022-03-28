Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 754BFC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 21:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiC1VLP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 17:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiC1VLO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 17:11:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADB82FFD0
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 14:09:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA039B8121B
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 21:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5ACC340F0;
        Mon, 28 Mar 2022 21:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648501769;
        bh=qq5Bp8MdBxvvskzwSeE/ULPSo1WFjKneX+r2fbNimpg=;
        h=Date:To:From:Subject:From;
        b=WhZtopds8zOQ/pw0qtfdv28KdFR1Ej1de2euJ/SGNndYIKlzR+BRwUj5WkVqsp06R
         14Y6rOYitWT5rM3s22LCK7HWK86I2Afan9rHWw5LQkVPa8mbfCRIsyVPMDF6rMe3+V
         G2mIYHSwylMjTaA+EW0u4iZCNdOXfivnU059e3a0=
Date:   Mon, 28 Mar 2022 14:09:28 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        osalvador@suse.de, mgorman@techsingularity.net,
        linmiaohe@huawei.com, david@redhat.com, richard.weiyang@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone.patch added to -mm tree
Message-Id: <20220328210929.8E5ACC340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: make sure wakeup_kswapd with managed zone
has been added to the -mm tree.  Its filename is
     mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/vmscan: make sure wakeup_kswapd with managed zone

wakeup_kswapd() only wake up kswapd when the zone is managed.

For two callers of wakeup_kswapd(), they are node perspective.

  * wake_all_kswapds
  * numamigrate_isolate_page

If we picked up a !managed zone, this is not we expected.

This patch makes sure we pick up a managed zone for wakeup_kswapd().

Link: https://lkml.kernel.org/r/20220327024101.10378-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c    |    2 +-
 mm/page_alloc.c |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone
+++ a/mm/migrate.c
@@ -2046,7 +2046,7 @@ static int numamigrate_isolate_page(pg_d
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
@@ -4674,6 +4674,8 @@ static void wake_all_kswapds(unsigned in
 
 	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, highest_zoneidx,
 					ac->nodemask) {
+		if (!managed_zone(zone))
+			continue;
 		if (last_pgdat != zone->zone_pgdat) {
 			wakeup_kswapd(zone, gfp_mask, order, highest_zoneidx);
 			last_pgdat = zone->zone_pgdat;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-page_alloc-add-penalty-to-local_node.patch
mm-vmscan-reclaim-only-affects-managed_zones.patch
mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone.patch

