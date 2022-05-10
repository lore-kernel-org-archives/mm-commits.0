Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E6FCC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236072AbiEJEUL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235984AbiEJESa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:18:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DCA15A744
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53D5A615E8
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97B6C385A6;
        Tue, 10 May 2022 04:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156059;
        bh=cBQMam5RRWPGVOzIgaFYJemOjacsLApOIut1Awp2wFw=;
        h=Date:To:From:Subject:From;
        b=JlaOnHWLHkJUOZJlOx9efqMDQw47V9v/29rR6lfr8oPAwQPO+Q0Xg2wWuBqClyyab
         lAprGgaCsG2Dix7ud0uziGHqoQuz3ETRsgV9FoYFyYoumP2frbEY3R9HSnFpnXN+M8
         wR1wQEiuziKw5ltazAtk+/JE56X3NBNxlqZecT/o=
Date:   Mon, 09 May 2022 21:14:19 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        akpm@linux-foundation.org, chenwandun@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-simplify-update-of-pgdat-in-wake_all_kswapds.patch removed from -mm tree
Message-Id: <20220510041419.A97B6C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: simplify update of pgdat in wake_all_kswapds
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-simplify-update-of-pgdat-in-wake_all_kswapds.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Chen Wandun <chenwandun@huawei.com>
Subject: mm/page_alloc: simplify update of pgdat in wake_all_kswapds

There is no need to update last_pgdat for each zone, only update
last_pgdat when iterating the first zone of a node.

Link: https://lkml.kernel.org/r/20220322115635.2708989-1-chenwandun@huawei.com
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-simplify-update-of-pgdat-in-wake_all_kswapds
+++ a/mm/page_alloc.c
@@ -4631,9 +4631,10 @@ static void wake_all_kswapds(unsigned in
 					ac->nodemask) {
 		if (!managed_zone(zone))
 			continue;
-		if (last_pgdat != zone->zone_pgdat)
+		if (last_pgdat != zone->zone_pgdat) {
 			wakeup_kswapd(zone, gfp_mask, order, highest_zoneidx);
-		last_pgdat = zone->zone_pgdat;
+			last_pgdat = zone->zone_pgdat;
+		}
 	}
 }
 
_

Patches currently in -mm which might be from chenwandun@huawei.com are


