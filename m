Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 373E7C43470
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D8C96157E
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhD3GB6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhD3GB6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:01:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AD1561482;
        Fri, 30 Apr 2021 06:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762470;
        bh=x6RInYzUP7MqBhvljx9i+VOIeuOtjKJC47njKfWjWkw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Dcp54EDhKmcccaj1d5H3s3JQvPM48TwNtkZ7Yhm4+c8jRGmSHJ6BKriF1ABWwBoWo
         OukNVlP5PT9qCtnlKu0q/Z7axFn2BiXW0gaWHs6qnS5gD49VOzEei6VOBJARTjOFMX
         bvtehV531nBwFosQODIaZD1yTt0Wy/sluT4EjSmY=
Date:   Thu, 29 Apr 2021 23:01:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 155/178] mm/page_alloc: rename alloc_mask to
 alloc_gfp
Message-ID: <20210430060110.HBiAc3R-r%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_alloc: rename alloc_mask to alloc_gfp

Patch series "Rationalise __alloc_pages wrappers", v3.

I was poking around the __alloc_pages variants trying to understand why
they each exist, and couldn't really find a good justification for keeping
__alloc_pages and __alloc_pages_nodemask as separate functions.  That led
to getting rid of alloc_pages_current() and then I noticed the
documentation was bad, and then I noticed the mempolicy documentation
wasn't included.

Anyway, this is all cleanups & doc fixes.


This patch (of 7):

We have two masks involved -- the nodemask and the gfp mask, so alloc_mask
is an unclear name.

Link: https://lkml.kernel.org/r/20210225150642.2582252-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-rename-alloc_mask-to-alloc_gfp
+++ a/mm/page_alloc.c
@@ -4966,7 +4966,7 @@ got_pg:
 
 static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 		int preferred_nid, nodemask_t *nodemask,
-		struct alloc_context *ac, gfp_t *alloc_mask,
+		struct alloc_context *ac, gfp_t *alloc_gfp,
 		unsigned int *alloc_flags)
 {
 	ac->highest_zoneidx = gfp_zone(gfp_mask);
@@ -4975,7 +4975,7 @@ static inline bool prepare_alloc_pages(g
 	ac->migratetype = gfp_migratetype(gfp_mask);
 
 	if (cpusets_enabled()) {
-		*alloc_mask |= __GFP_HARDWALL;
+		*alloc_gfp |= __GFP_HARDWALL;
 		/*
 		 * When we are in the interrupt context, it is irrelevant
 		 * to the current task context. It means that any node ok.
@@ -5019,7 +5019,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 {
 	struct page *page;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
-	gfp_t alloc_mask; /* The gfp_t that was actually used for allocation */
+	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
 	struct alloc_context ac = { };
 
 	/*
@@ -5032,8 +5032,9 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	}
 
 	gfp_mask &= gfp_allowed_mask;
-	alloc_mask = gfp_mask;
-	if (!prepare_alloc_pages(gfp_mask, order, preferred_nid, nodemask, &ac, &alloc_mask, &alloc_flags))
+	alloc_gfp = gfp_mask;
+	if (!prepare_alloc_pages(gfp_mask, order, preferred_nid, nodemask, &ac,
+			&alloc_gfp, &alloc_flags))
 		return NULL;
 
 	/*
@@ -5043,7 +5044,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	alloc_flags |= alloc_flags_nofragment(ac.preferred_zoneref->zone, gfp_mask);
 
 	/* First allocation attempt */
-	page = get_page_from_freelist(alloc_mask, order, alloc_flags, &ac);
+	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
 	if (likely(page))
 		goto out;
 
@@ -5053,7 +5054,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	 * from a particular context which has been marked by
 	 * memalloc_no{fs,io}_{save,restore}.
 	 */
-	alloc_mask = current_gfp_context(gfp_mask);
+	alloc_gfp = current_gfp_context(gfp_mask);
 	ac.spread_dirty_pages = false;
 
 	/*
@@ -5062,7 +5063,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	 */
 	ac.nodemask = nodemask;
 
-	page = __alloc_pages_slowpath(alloc_mask, order, &ac);
+	page = __alloc_pages_slowpath(alloc_gfp, order, &ac);
 
 out:
 	if (memcg_kmem_enabled() && (gfp_mask & __GFP_ACCOUNT) && page &&
@@ -5071,7 +5072,7 @@ out:
 		page = NULL;
 	}
 
-	trace_mm_page_alloc(page, order, alloc_mask, ac.migratetype);
+	trace_mm_page_alloc(page, order, alloc_gfp, ac.migratetype);
 
 	return page;
 }
_
