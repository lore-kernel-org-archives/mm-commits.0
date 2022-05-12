Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0031C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 19:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356709AbiELToj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 15:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358154AbiELToh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 15:44:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D8D2469C3
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 12:44:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6DECB825F1
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 19:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899D2C385B8;
        Thu, 12 May 2022 19:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652384673;
        bh=wB2XmvHfoE7Ogq80jcXHEtCm3z+9Imor7mzZqYEVdNA=;
        h=Date:To:From:Subject:From;
        b=bjTl7Pv2Vt33MmQRPDtuwU6F1vJ+TCaMBMJvx26GbGV6Ry9LL6mTuO+uzXfT3UMB4
         XNwNYcWH4VJsnQuf1vlCMhslLkP1Y9PQCpccMyLrM4ijxiJwQtk1Ot9w4Vuac7qLRV
         9ekGeXipz8ehZocEjB6UZ5YxcyX/Ee0zCZlnEGB4=
Date:   Thu, 12 May 2022 12:44:32 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, nsaenzju@redhat.com,
        mtosatti@redhat.com, minchan@kernel.org, mhocko@kernel.org,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-unnecessary-page-==-null-check-in-rmqueue.patch added to mm-unstable branch
Message-Id: <20220512194433.899D2C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: remove unnecessary page == NULL check in rmqueue
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-remove-unnecessary-page-==-null-check-in-rmqueue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-unnecessary-page-==-null-check-in-rmqueue.patch

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
Subject: mm/page_alloc: remove unnecessary page == NULL check in rmqueue

The VM_BUG_ON check for a valid page can be avoided with a simple change
in the flow.  The ZONE_BOOSTED_WATERMARK is unlikely in general and even
more unlikely if the page allocation failed so mark the branch unlikely.

Link: https://lkml.kernel.org/r/20220512085043.5234-5-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Tested-by: Minchan Kim <minchan@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-unnecessary-page-==-null-check-in-rmqueue
+++ a/mm/page_alloc.c
@@ -3755,17 +3755,18 @@ struct page *rmqueue(struct zone *prefer
 
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
mm-page_alloc-remove-unnecessary-page-==-null-check-in-rmqueue.patch
mm-page_alloc-protect-pcp-lists-with-a-spinlock.patch

