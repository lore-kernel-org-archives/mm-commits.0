Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EECF3C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235937AbiEJEPy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236076AbiEJEPd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:15:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDF23FDB8
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB290B81AF4
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E6BC385C2;
        Tue, 10 May 2022 04:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155867;
        bh=W8YgjKyuXlTtNL85/cxZwD8raAdvtgEGubHvZpufGNo=;
        h=Date:To:From:Subject:From;
        b=MVAboswAtaQwA5ws1e4Yva1vBWnb8hl9IGh9HQ2Fq5SWvnbfhJTgM7NCKP1ovxZaY
         U0P4yrc40cK5dG7mYxIo5be/oDbw/wbvhXzKjPHFuXwkPcafw3XClTRElclthYRGkk
         MK011ZYlX+1gELs9ovbRFP2PR/EwyaI1VX6nw0zA=
Date:   Mon, 09 May 2022 21:11:07 -0700
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-sc-reclaim_idx-must-be-a-valid-zone-index.patch removed from -mm tree
Message-Id: <20220510041107.92E6BC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: sc->reclaim_idx must be a valid zone index
has been removed from the -mm tree.  Its filename was
     mm-vmscan-sc-reclaim_idx-must-be-a-valid-zone-index.patch

This patch was dropped because it was merged into mm-stable

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

mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration.patch
mm-vmscan-filter-empty-page_list-at-the-beginning.patch
mm-vmscan-not-use-numa_no_node-as-indicator-of-page-on-different-node.patch

