Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96514EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjHUUl2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbjHUUki (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161871B6
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2202A64B00
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752A6C433C7;
        Mon, 21 Aug 2023 20:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650415;
        bh=qajTxo1BFmzF5boFE6kc51ovxqTpRSa540ufS0rqGtc=;
        h=Date:To:From:Subject:From;
        b=16tLt3fxkAV5tMExb72JCN87xpJkKMBKStvZZvaI9p44yPiaxvq0WaRtLH2V4C2Zz
         G40Si5Fxjv6YDMbpIeRJXm80ZvpBg/qYTGJfvkDiX5pCQnKJwaQwixXRSnUeWouwFF
         qCRlBgnEG3MkcwRm6adqWYv6Auu6gnOfx0i9RceA=
Date:   Mon, 21 Aug 2023 13:40:14 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        david@redhat.com, baolin.wang@linux.alibaba.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-correct-last_migrated_pfn-update-in-compact_zone.patch removed from -mm tree
Message-Id: <20230821204015.752A6C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/compaction: correct last_migrated_pfn update in compact_zone
has been removed from the -mm tree.  Its filename was
     mm-compaction-correct-last_migrated_pfn-update-in-compact_zone.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/compaction: correct last_migrated_pfn update in compact_zone
Date: Fri, 4 Aug 2023 19:04:48 +0800

We record start pfn of last isolated page block with last_migrated_pfn. And
then:

1. We check if we mark the page block skip for exclusive access in
   isolate_migratepages_block by test if next migrate pfn is still in last
   isolated page block.  If so, we will set finish_pageblock to do the
   rescan.

2. We check if a full cc->order block is scanned by test if last scan
   range passes the cc->order block boundary.  If so, we flush the pages
   were freed.

We treat cc->migrate_pfn before isolate_migratepages as the start pfn of
last isolated page range.  However, we always align migrate_pfn to page
block or move to another page block in fast_find_migrateblock or in
linearly scan forward in isolate_migratepages before do page isolation in
isolate_migratepages_block.

Update last_migrated_pfn with pageblock_start_pfn(cc->migrate_pfn - 1)
after scan to correctly set start pfn of last isolated page range. To
avoid that:

1. Miss a rescan with finish_pageblock set as last_migrate_pfn does
   not point to right pageblock and the migrate will not be in pageblock
   of last_migrate_pfn as it should be.

2. Wrongly issue flush by test cc->order block boundary with wrong
   last_migrate_pfn.

Link: https://lkml.kernel.org/r/20230804110454.2935878-3-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-correct-last_migrated_pfn-update-in-compact_zone
+++ a/mm/compaction.c
@@ -2507,7 +2507,8 @@ rescan:
 			goto check_drain;
 		case ISOLATE_SUCCESS:
 			update_cached = false;
-			last_migrated_pfn = iteration_start_pfn;
+			last_migrated_pfn = max(cc->zone->zone_start_pfn,
+				pageblock_start_pfn(cc->migrate_pfn - 1));
 		}
 
 		err = migrate_pages(&cc->migratepages, compaction_alloc,
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


