Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBEEAC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 26 Mar 2022 00:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiCZAPo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 20:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiCZAPn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 20:15:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9431E7A47
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 17:14:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A1AE617AD
        for <mm-commits@vger.kernel.org>; Sat, 26 Mar 2022 00:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E84C2BBE4;
        Sat, 26 Mar 2022 00:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648253647;
        bh=/lWh4ghCGcOstY9V5qdMvL4Rv7++8HV5GMil3Okv2RE=;
        h=Date:To:From:Subject:From;
        b=mVoHohjligIBNscx9dBn6bSY/uy/QEpbBZk/Jkx11GufLA3qLHA6tepUdYAd21AmE
         FpSGY3xWaaV59MMbCP3yhyO38jtY8YcrgZE8v0nbh7KHo5UN1Xb/o79VXeIEcXvHlK
         p6oHlNVB66u4DrtIrCKcnxfrsd1qXoV+/DuPurvg=
Date:   Fri, 25 Mar 2022 17:14:06 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        chenwandun@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-simplify-update-of-pgdat-in-wake_all_kswapds.patch added to -mm tree
Message-Id: <20220326001406.E8E84C2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: simplify update of pgdat in wake_all_kswapds
has been added to the -mm tree.  Its filename is
     mm-page_alloc-simplify-update-of-pgdat-in-wake_all_kswapds.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-simplify-update-of-pgdat-in-wake_all_kswapds.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-simplify-update-of-pgdat-in-wake_all_kswapds.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Wandun <chenwandun@huawei.com>
Subject: mm/page_alloc: simplify update of pgdat in wake_all_kswapds

There is no need to update last_pgdat for each zone, only update
last_pgdat when iterating the first zone of a node.

Link: https://lkml.kernel.org/r/20220322115635.2708989-1-chenwandun@huawei.com
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-simplify-update-of-pgdat-in-wake_all_kswapds
+++ a/mm/page_alloc.c
@@ -4674,9 +4674,10 @@ static void wake_all_kswapds(unsigned in
 
 	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, highest_zoneidx,
 					ac->nodemask) {
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

mm-page_alloc-simplify-update-of-pgdat-in-wake_all_kswapds.patch

