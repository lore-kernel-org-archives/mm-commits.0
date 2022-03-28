Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D804C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 22:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiC1W5Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 18:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiC1W5P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 18:57:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3381613AA37
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 15:55:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1232B8116B
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 22:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8FDC340EC;
        Mon, 28 Mar 2022 22:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648508130;
        bh=G634CHAUH3vE/66KkVP+rQmDwNGW1nOu+0U//81kY40=;
        h=Date:To:From:Subject:From;
        b=tR4Gcdh+YBnyf+DD0UKYrhi4Qtbf3/LpIXbzzjUerkKRtu7ROw2dYczknCuvJqB8D
         5cHwKayYBpK9KEtDk0LItAgqyJwqGxA8A4c1fYfixActZ9fMlLTYg6PHl61VTXPMqb
         JIE2ap7Oxr7R5v0S35BW9bZoLPmFNogxZ5z/KHm8=
Date:   Mon, 28 Mar 2022 15:55:29 -0700
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-sc-reclaim_idx-must-be-a-valid-zone-index.patch added to -mm tree
Message-Id: <20220328225530.6A8FDC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: sc->reclaim_idx must be a valid zone index
has been added to the -mm tree.  Its filename is
     mm-vmscan-sc-reclaim_idx-must-be-a-valid-zone-index.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-sc-reclaim_idx-must-be-a-valid-zone-index.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-sc-reclaim_idx-must-be-a-valid-zone-index.patch

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
Subject: mm/vmscan: sc->reclaim_idx must be a valid zone index

lruvec_lru_size() is only used in get_scan_count(), so the only possible
zone_idx is sc->reclaim_idx.  Since sc->reclaim_idx is ensured to be a
valid zone idex, we can remove the extra check for zone iteration.

Link: https://lkml.kernel.org/r/20220317234624.23358-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-sc-reclaim_idx-must-be-a-valid-zone-index
+++ a/mm/vmscan.c
@@ -587,7 +587,7 @@ unsigned long zone_reclaimable_pages(str
  * lruvec_lru_size -  Returns the number of pages on the given LRU list.
  * @lruvec: lru vector
  * @lru: lru to use
- * @zone_idx: zones to consider (use MAX_NR_ZONES for the whole LRU list)
+ * @zone_idx: zones to consider (use MAX_NR_ZONES - 1 for the whole LRU list)
  */
 static unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru,
 				     int zone_idx)
@@ -595,7 +595,7 @@ static unsigned long lruvec_lru_size(str
 	unsigned long size = 0;
 	int zid;
 
-	for (zid = 0; zid <= zone_idx && zid < MAX_NR_ZONES; zid++) {
+	for (zid = 0; zid <= zone_idx; zid++) {
 		struct zone *zone = &lruvec_pgdat(lruvec)->node_zones[zid];
 
 		if (!managed_zone(zone))
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-vmscan-reclaim-only-affects-managed_zones.patch
mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone.patch
mm-vmscan-sc-reclaim_idx-must-be-a-valid-zone-index.patch

