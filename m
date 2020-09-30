Return-Path: <SRS0=jIyd=DH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DAA8C4741F
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 22:29:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA8342076A
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 22:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601504987;
	bh=+oZbuEfbhYktbYzxoK4BaArzWcM2e/wx3Z/7mkDF+Dw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=PKziwyuB3VyoCPM3O6wLfCTb+Ot1b2W/pC6lurk9y+KyzdFwlbrWb9xClfqVK0dpu
	 FKn08AL21TAE+SRirWkrhYRo46869VBfm1H19dBrhDnI7+KwWBPxQIVM7vsdfN40A8
	 0INRiN1q/yQFyIMGrcy0r/Rtc2kYiZhlPAGhhaxI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbgI3W3r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Sep 2020 18:29:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730310AbgI3W3q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Sep 2020 18:29:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBF4A20719;
        Wed, 30 Sep 2020 22:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601504986;
        bh=+oZbuEfbhYktbYzxoK4BaArzWcM2e/wx3Z/7mkDF+Dw=;
        h=Date:From:To:Subject:From;
        b=xhIV0+XwrhtdLcUzB3fPiqAQ4axkyJyI+uuDEMs4v8Dq9UqNFnYL8Zj2gR6ODd2DN
         Cv9ZH+Ql41n2+Ovu/uUG224sNIGtMxpzrgg+uBlHoTD1Up8noj2K+kreFvj/OUXOZy
         W7uH+c3UA5VFRI1mSrp+E0St/FVAeVTAlducsMZU=
Date:   Wed, 30 Sep 2020 15:29:45 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, iamjoonsoo.kim@lge.com,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?mm-page=5Falloc-handle-a-missing-case-for-memalloc=5Fnocma?=
 =?US-ASCII?Q?=5Fsave-restore-apis.patch?= added to -mm tree
Message-ID: <20200930222945.MEBzYUxZP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: handle a missing case for memalloc_nocma_{save/restore} APIs
has been added to the -mm tree.  Its filename is
     mm-page_alloc-handle-a-missing-case-for-memalloc_nocma_save-restore-apis.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-handle-a-missing-case-for-memalloc_nocma_save-restore-apis.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-handle-a-missing-case-for-memalloc_nocma_save-restore-apis.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_alloc: handle a missing case for memalloc_nocma_{save/restore} APIs

memalloc_nocma_{save/restore} APIs can be used to skip page allocation on
CMA area, but, there is a missing case and the page on CMA area could be
allocated even if APIs are used.  This patch handles this case to fix the
potential issue.

For now, these APIs are used to prevent long-term pinning on the CMA page.
When the long-term pinning is requested on the CMA page, it is migrated
to the non-CMA page before pinning.  This non-CMA page is allocated by
using memalloc_nocma_{save/restore} APIs.  If APIs doesn't work as
intended, the CMA page is allocated and it is pinned for a long time. 
This long-term pin for the CMA page causes cma_alloc() failure and it
could result in wrong behaviour on the device driver who uses the
cma_alloc().

Missing case is an allocation from the pcplist.  MIGRATE_MOVABLE pcplist
could have the pages on CMA area so we need to skip it if ALLOC_CMA isn't
specified.

Link: https://lkml.kernel.org/r/1601429472-12599-1-git-send-email-iamjoonsoo.kim@lge.com
Fixes: 8510e69c8efe (mm/page_alloc: fix memalloc_nocma_{save/restore} APIs)
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-handle-a-missing-case-for-memalloc_nocma_save-restore-apis
+++ a/mm/page_alloc.c
@@ -3368,9 +3368,16 @@ struct page *rmqueue(struct zone *prefer
 	struct page *page;
 
 	if (likely(order == 0)) {
-		page = rmqueue_pcplist(preferred_zone, zone, gfp_flags,
+		/*
+		 * MIGRATE_MOVABLE pcplist could have the pages on CMA area and
+		 * we need to skip it when CMA area isn't allowed.
+		 */
+		if (!IS_ENABLED(CONFIG_CMA) || alloc_flags & ALLOC_CMA ||
+				migratetype != MIGRATE_MOVABLE) {
+			page = rmqueue_pcplist(preferred_zone, zone, gfp_flags,
 					migratetype, alloc_flags);
-		goto out;
+			goto out;
+		}
 	}
 
 	/*
@@ -3382,7 +3389,13 @@ struct page *rmqueue(struct zone *prefer
 
 	do {
 		page = NULL;
-		if (alloc_flags & ALLOC_HARDER) {
+		/*
+		 * order-0 request can reach here when the pcplist is skipped
+		 * due to non-CMA allocation context. HIGHATOMIC area is
+		 * reserved for high-order atomic allocation, so order-0
+		 * request should skip it.
+		 */
+		if (order > 0 && alloc_flags & ALLOC_HARDER) {
 			page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
 			if (page)
 				trace_mm_page_alloc_zone_locked(page, order, migratetype);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-page_alloc-handle-a-missing-case-for-memalloc_nocma_save-restore-apis.patch
mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target.patch

