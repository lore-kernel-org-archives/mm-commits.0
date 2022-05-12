Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49640C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 19:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241392AbiELToh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 15:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356709AbiELTod (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 15:44:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49F72469EF
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 12:44:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39FC261D82
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 19:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE6CC34100;
        Thu, 12 May 2022 19:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652384671;
        bh=eVssbCNgv8q00lCJWq5fnZ2uYw84EmnMba0lAsqCouM=;
        h=Date:To:From:Subject:From;
        b=FC8c1D8PqEEFWEOSPo1v+gN0xlvGr9UxI9kgmxj03FnxyyPWUGEtvFFSujIcYQZVc
         akjoVyQ7DP+bVx79V7D+voyh94IMPPmGXlGg1LCuK9MJoK1O6OK1pH/lQXXW/RNz9Y
         yyFFO+VIbRyiPAERI06JzQd5VrvxYp3E5ehyuNvo=
Date:   Thu, 12 May 2022 12:44:30 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, nsaenzju@redhat.com,
        mtosatti@redhat.com, minchan@kernel.org, mhocko@kernel.org,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-split-out-buddy-removal-code-from-rmqueue-into-separate-helper.patch added to mm-unstable branch
Message-Id: <20220512194431.8DE6CC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: split out buddy removal code from rmqueue into separate helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-split-out-buddy-removal-code-from-rmqueue-into-separate-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-split-out-buddy-removal-code-from-rmqueue-into-separate-helper.patch

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
Subject: mm/page_alloc: split out buddy removal code from rmqueue into separate helper

This is a preparation page to allow the buddy removal code to be reused in
a later patch.

No functional change.

Link: https://lkml.kernel.org/r/20220512085043.5234-4-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Tested-by: Minchan Kim <minchan@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   87 ++++++++++++++++++++++++++--------------------
 1 file changed, 50 insertions(+), 37 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-split-out-buddy-removal-code-from-rmqueue-into-separate-helper
+++ a/mm/page_alloc.c
@@ -3612,6 +3612,46 @@ static inline void zone_statistics(struc
 #endif
 }
 
+static __always_inline
+struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
+			   unsigned int order, unsigned int alloc_flags,
+			   int migratetype)
+{
+	struct page *page;
+	unsigned long flags;
+
+	do {
+		page = NULL;
+		spin_lock_irqsave(&zone->lock, flags);
+		/*
+		 * order-0 request can reach here when the pcplist is skipped
+		 * due to non-CMA allocation context. HIGHATOMIC area is
+		 * reserved for high-order atomic allocation, so order-0
+		 * request should skip it.
+		 */
+		if (order > 0 && alloc_flags & ALLOC_HARDER) {
+			page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
+			if (page)
+				trace_mm_page_alloc_zone_locked(page, order, migratetype);
+		}
+		if (!page) {
+			page = __rmqueue(zone, order, migratetype, alloc_flags);
+			if (!page) {
+				spin_unlock_irqrestore(&zone->lock, flags);
+				return NULL;
+			}
+		}
+		__mod_zone_freepage_state(zone, -(1 << order),
+					  get_pcppage_migratetype(page));
+		spin_unlock_irqrestore(&zone->lock, flags);
+	} while (check_new_pages(page, order));
+
+	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
+	zone_statistics(preferred_zone, zone, 1);
+
+	return page;
+}
+
 /* Remove page from the per-cpu list, caller must protect the list */
 static inline
 struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
@@ -3692,9 +3732,14 @@ struct page *rmqueue(struct zone *prefer
 			gfp_t gfp_flags, unsigned int alloc_flags,
 			int migratetype)
 {
-	unsigned long flags;
 	struct page *page;
 
+	/*
+	 * We most definitely don't want callers attempting to
+	 * allocate greater than order-1 page units with __GFP_NOFAIL.
+	 */
+	WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));
+
 	if (likely(pcp_allowed_order(order))) {
 		/*
 		 * MIGRATE_MOVABLE pcplist could have the pages on CMA area and
@@ -3708,38 +3753,10 @@ struct page *rmqueue(struct zone *prefer
 		}
 	}
 
-	/*
-	 * We most definitely don't want callers attempting to
-	 * allocate greater than order-1 page units with __GFP_NOFAIL.
-	 */
-	WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));
-
-	do {
-		page = NULL;
-		spin_lock_irqsave(&zone->lock, flags);
-		/*
-		 * order-0 request can reach here when the pcplist is skipped
-		 * due to non-CMA allocation context. HIGHATOMIC area is
-		 * reserved for high-order atomic allocation, so order-0
-		 * request should skip it.
-		 */
-		if (order > 0 && alloc_flags & ALLOC_HARDER) {
-			page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
-			if (page)
-				trace_mm_page_alloc_zone_locked(page, order, migratetype);
-		}
-		if (!page) {
-			page = __rmqueue(zone, order, migratetype, alloc_flags);
-			if (!page)
-				goto failed;
-		}
-		__mod_zone_freepage_state(zone, -(1 << order),
-					  get_pcppage_migratetype(page));
-		spin_unlock_irqrestore(&zone->lock, flags);
-	} while (check_new_pages(page, order));
-
-	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
-	zone_statistics(preferred_zone, zone, 1);
+	page = rmqueue_buddy(preferred_zone, zone, order, alloc_flags,
+							migratetype);
+	if (unlikely(!page))
+		return NULL;
 
 out:
 	/* Separate test+clear to avoid unnecessary atomics */
@@ -3750,10 +3767,6 @@ out:
 
 	VM_BUG_ON_PAGE(page && bad_range(zone, page), page);
 	return page;
-
-failed:
-	spin_unlock_irqrestore(&zone->lock, flags);
-	return NULL;
 }
 
 #ifdef CONFIG_FAIL_PAGE_ALLOC
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-add-page-buddy_list-and-page-pcp_list.patch
mm-page_alloc-use-only-one-pcp-list-for-thp-sized-allocations.patch
mm-page_alloc-split-out-buddy-removal-code-from-rmqueue-into-separate-helper.patch
mm-page_alloc-remove-unnecessary-page-==-null-check-in-rmqueue.patch
mm-page_alloc-protect-pcp-lists-with-a-spinlock.patch

