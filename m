Return-Path: <SRS0=eNRM=DK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 483EBC4727D
	for <mm-commits@archiver.kernel.org>; Sat,  3 Oct 2020 05:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 032CD206A1
	for <mm-commits@archiver.kernel.org>; Sat,  3 Oct 2020 05:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601702508;
	bh=D/KlL5qjU4zcABe3P7gUESlayHaVyqERVhGdqHnMIKc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=u472fZqUYoRF6PtDOQdjiF4lHYXk41JzEJ+8caPVv7KfFDOR3evFaSMwyV1RmHDYg
	 m3g+aLdfTsWVuOyOaLIL8VWcdtm85GrzqHj3/I+35vsIn9ajuT5rG3JxfQCr6JbnSE
	 89s+vZJ0lIx4/wCZ74ONFb34QKNe8EBdNPGbb7MU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725616AbgJCFVr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 3 Oct 2020 01:21:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgJCFVr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 3 Oct 2020 01:21:47 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BC25206F8;
        Sat,  3 Oct 2020 05:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601702505;
        bh=D/KlL5qjU4zcABe3P7gUESlayHaVyqERVhGdqHnMIKc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZM+TuTOgPwN8K+j7RMFX8yqd6u2zgc55fiTHHbeh+jjyxeVlJO+GjdGZ3Hbbx7GOM
         LjJyxHsmHrU7/tEDGuV/ambO1zywM/Q7x8gDJG82ngfDLt/ZMwlxo22m5PUwRG80Gj
         ylMLjDJ/Bd6y+AbV9EQQMFZYo/AAfaSC52qeKO7A=
Date:   Fri, 02 Oct 2020 22:21:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 2/3] mm/page_alloc: handle a missing case for
 memalloc_nocma_{save/restore} APIs
Message-ID: <20201003052145.Z2AMT6sas%akpm@linux-foundation.org>
In-Reply-To: <20201002222038.4f81529dcd31eb8328d562a6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -3367,9 +3367,16 @@ struct page *rmqueue(struct zone *prefer
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
@@ -3381,7 +3388,13 @@ struct page *rmqueue(struct zone *prefer
 
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
