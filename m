Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CCBDC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233988AbiEJEQC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235949AbiEJEPc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:15:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7108F38BE1
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAD8DB81AE7
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A743C385C2;
        Tue, 10 May 2022 04:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155865;
        bh=MqQ/apD/QYeORWPmMD+SU0hlJsshL4fSxQ63GmCHh6E=;
        h=Date:To:From:Subject:From;
        b=Zt1ovm9OxnRCDco/x/FJkF3YXAuepPQxx0xopMHRDZSPZIh1xGIawCVMb1IL8P/0b
         SVQzYaoPpYrfyNq8WuvgQMcx8kEAysuL8e8HjpgOz1ylI18wxhn+Kjokl19NxOu3tY
         F0cM+hokRRZUPkZ4dzHXuoXiq7yWepMsip2qld4c=
Date:   Mon, 09 May 2022 21:11:05 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        osalvador@suse.de, mgorman@techsingularity.net,
        linmiaohe@huawei.com, david@redhat.com, richard.weiyang@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-reclaim-only-affects-managed_zones.patch removed from -mm tree
Message-Id: <20220510041105.8A743C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: reclaim only affects managed_zones
has been removed from the -mm tree.  Its filename was
     mm-vmscan-reclaim-only-affects-managed_zones.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/vmscan: reclaim only affects managed_zones

As mentioned in commit 6aa303defb74 ("mm, vmscan: only allocate and
reclaim from zones with pages managed by the buddy allocator") , reclaim
only affects managed_zones.

Let's adjust the code and comment accordingly.

Link: https://lkml.kernel.org/r/20220327024101.10378-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-reclaim-only-affects-managed_zones
+++ a/mm/vmscan.c
@@ -1031,7 +1031,7 @@ static bool skip_throttle_noprogress(pg_
 	for (i = 0; i < MAX_NR_ZONES; i++) {
 		struct zone *zone = pgdat->node_zones + i;
 
-		if (!populated_zone(zone))
+		if (!managed_zone(zone))
 			continue;
 
 		reclaimable += zone_reclaimable_pages(zone);
@@ -3912,7 +3912,7 @@ static bool pgdat_balanced(pg_data_t *pg
 	}
 
 	/*
-	 * If a node has no populated zone within highest_zoneidx, it does not
+	 * If a node has no managed zone within highest_zoneidx, it does not
 	 * need balancing by definition. This can happen if a zone-restricted
 	 * allocation tries to wake a remote kswapd.
 	 */
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration.patch
mm-vmscan-filter-empty-page_list-at-the-beginning.patch
mm-vmscan-not-use-numa_no_node-as-indicator-of-page-on-different-node.patch

