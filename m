Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B907C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 21:09:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiC1VLL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 17:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiC1VLK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 17:11:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C807B2F3A4
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 14:09:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A0246141C
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 21:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9527C340F0;
        Mon, 28 Mar 2022 21:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648501767;
        bh=m39i+rN1rXXey3+iF20GXf7zYpcvWqZeaFvuxMg5Al8=;
        h=Date:To:From:Subject:From;
        b=A1d8JgZT4xiC+b9QMWCNLQ91noGIT0Da2oWieMcYRDnqoVdUOL399aKhKapSjAJsH
         /bJ1OO48j8Rp2/CnpTaIzo1v3rNgrf+iM6pJD4DUv2ZloAzmCYQ98pzdjjtc1KAOMk
         MCUIQ6vGNbrsRu6NZUJ1L56GyvpqVzW8miBSKKEM=
Date:   Mon, 28 Mar 2022 14:09:26 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        osalvador@suse.de, mgorman@techsingularity.net,
        linmiaohe@huawei.com, david@redhat.com, richard.weiyang@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-reclaim-only-affects-managed_zones.patch added to -mm tree
Message-Id: <20220328210927.A9527C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: reclaim only affects managed_zones
has been added to the -mm tree.  Its filename is
     mm-vmscan-reclaim-only-affects-managed_zones.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-reclaim-only-affects-managed_zones.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-reclaim-only-affects-managed_zones.patch

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

mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-page_alloc-add-penalty-to-local_node.patch
mm-vmscan-reclaim-only-affects-managed_zones.patch
mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone.patch

