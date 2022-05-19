Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BBE3C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 17:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiESRMy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 13:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiESRMx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 13:12:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C51B3EF38
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 10:12:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 951BB616D1
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 17:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19A5C385AA;
        Thu, 19 May 2022 17:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652980372;
        bh=7jLl+7ZCvL/1X05aZ5SB1KbtH6Y1iVMUH95KfTpcedQ=;
        h=Date:To:From:Subject:From;
        b=0+uZaDd8ELXK36U+92bEWHlchzzuMxmyclZ7MFj4htVvnKn99ZWQVKvli6EsRRxrh
         HUxOeK3i/Z/pWruI1ADutsoZurY1BAVl7I5+had4YLb7XtPlQbWBz+C9eMtvhcPwQR
         kK0w7bFLIfQEHuimjVEg85MTYdgR3osgcvTbiYi0=
Date:   Thu, 19 May 2022 10:12:51 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, nsaenzju@redhat.com,
        mtosatti@redhat.com, minchan@kernel.org, mhocko@kernel.org,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-page_alloc-remove-unnecessary-page-==-null-check-in-rmqueue.patch removed from -mm tree
Message-Id: <20220519171251.E19A5C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: remove unnecessary page == NULL check in rmqueue
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-unnecessary-page-==-null-check-in-rmqueue.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: remove unnecessary page == NULL check in rmqueue

The VM_BUG_ON check for a valid page can be avoided with a simple change
in the flow.  The ZONE_BOOSTED_WATERMARK is unlikely in general and even
more unlikely if the page allocation failed so mark the branch unlikely.

Link: https://lkml.kernel.org/r/20220512085043.5234-5-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Tested-by: Minchan Kim <minchan@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-unnecessary-page-==-null-check-in-rmqueue
+++ a/mm/page_alloc.c
@@ -3752,17 +3752,18 @@ struct page *rmqueue(struct zone *prefer
 
 	page = rmqueue_buddy(preferred_zone, zone, order, alloc_flags,
 							migratetype);
-	if (unlikely(!page))
-		return NULL;
 
 out:
 	/* Separate test+clear to avoid unnecessary atomics */
-	if (test_bit(ZONE_BOOSTED_WATERMARK, &zone->flags)) {
+	if (unlikely(test_bit(ZONE_BOOSTED_WATERMARK, &zone->flags))) {
 		clear_bit(ZONE_BOOSTED_WATERMARK, &zone->flags);
 		wakeup_kswapd(zone, 0, 0, zone_idx(zone));
 	}
 
-	VM_BUG_ON_PAGE(page && bad_range(zone, page), page);
+	if (unlikely(!page))
+		return NULL;
+
+	VM_BUG_ON_PAGE(bad_range(zone, page), page);
 	return page;
 }
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-add-page-buddy_list-and-page-pcp_list.patch
mm-page_alloc-use-only-one-pcp-list-for-thp-sized-allocations.patch
mm-page_alloc-split-out-buddy-removal-code-from-rmqueue-into-separate-helper.patch
mm-page_alloc-protect-pcp-lists-with-a-spinlock.patch

