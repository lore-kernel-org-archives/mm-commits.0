Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BBE0C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 13 Jun 2022 19:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347425AbiFMTE1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jun 2022 15:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349883AbiFMTEM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jun 2022 15:04:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091CAE276B
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 09:54:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EF046150C
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 16:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1DCDC34114;
        Mon, 13 Jun 2022 16:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655139274;
        bh=OnJx8RP0qn7cj/QwH3Dlds0KUJ/a/N0oZJ2oc0ziqkg=;
        h=Date:To:From:Subject:From;
        b=ypGCGKZiXCN5IkK8PBb6L/NnwTOxS8xZnTbK2RwBoSBLDU+3lQmsTJueW5SVsizPK
         JPidKTuY11TtFVHIcLjNX3tEsiLUrfu6usPudJ3wBBLC0cBHKx1sgtf26m9++sdnC8
         br0J471kLMq2LrvXVICjV+HH9/VSd2xtoV53lYzc=
Date:   Mon, 13 Jun 2022 09:54:33 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, nsaenzju@redhat.com,
        mtosatti@redhat.com, minchan@kernel.org, mhocko@kernel.org,
        hughd@google.com, mgorman@techsingularity.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-mistaken-page-==-null-check-in-rmqueue.patch added to mm-unstable branch
Message-Id: <20220613165433.E1DCDC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: remove mistaken page == NULL check in rmqueue
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-remove-mistaken-page-==-null-check-in-rmqueue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-mistaken-page-==-null-check-in-rmqueue.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: remove mistaken page == NULL check in rmqueue
Date: Mon, 13 Jun 2022 13:56:19 +0100

If a page allocation fails, the ZONE_BOOSTER_WATERMARK should be tested,
cleared and kswapd woken whether the allocation attempt was via the PCP or
directly via the buddy list.

Remove the page == NULL so the ZONE_BOOSTED_WATERMARK bit is checked
unconditionally.  As it is unlikely that ZONE_BOOSTED_WATERMARK is set,
mark the branch accordingly.

Link: https://lkml.kernel.org/r/20220613125622.18628-5-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-mistaken-page-==-null-check-in-rmqueue
+++ a/mm/page_alloc.c
@@ -3773,12 +3773,10 @@ struct page *rmqueue(struct zone *prefer
 
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
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-add-page-buddy_list-and-page-pcp_list.patch
mm-page_alloc-use-only-one-pcp-list-for-thp-sized-allocations.patch
mm-page_alloc-split-out-buddy-removal-code-from-rmqueue-into-separate-helper.patch
mm-page_alloc-remove-mistaken-page-==-null-check-in-rmqueue.patch
mm-page_alloc-protect-pcp-lists-with-a-spinlock.patch
mm-page_alloc-replace-local_lock-with-normal-spinlock.patch

