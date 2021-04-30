Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B77C43461
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D141961482
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhD3GCB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:02:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230202AbhD3GCB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:02:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55CC1614A7;
        Fri, 30 Apr 2021 06:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762473;
        bh=t5mDfLqShd/5mEMShqEsdyqcfWmnpMXynDtKsWekNPA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XT37lrcHxS4PGRsUil/2aDEWmj8Opk3CmY2rgSaC+yzh+VavR2cWo4So40Lo3uWYP
         T0//VzyphvRuajB6hjg7LbmnJq8lWa0tEG0BcJFR48Aezw5vzWjwAtDh5XlOvz6+8v
         yW4w6S0AGHtumz4Yum0AjfFAX2aLbTHLbOjytz+U=
Date:   Thu, 29 Apr 2021 23:01:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 156/178] mm/page_alloc: rename gfp_mask to gfp
Message-ID: <20210430060113.rJ1cqIr2a%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_alloc: rename gfp_mask to gfp

Shorten some overly-long lines by renaming this identifier.

Link: https://lkml.kernel.org/r/20210225150642.2582252-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-rename-gfp_mask-to-gfp
+++ a/mm/page_alloc.c
@@ -5014,7 +5014,7 @@ static inline bool prepare_alloc_pages(g
  * This is the 'heart' of the zoned buddy allocator.
  */
 struct page *
-__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
+__alloc_pages_nodemask(gfp_t gfp, unsigned int order, int preferred_nid,
 							nodemask_t *nodemask)
 {
 	struct page *page;
@@ -5027,13 +5027,13 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	 * so bail out early if the request is out of bound.
 	 */
 	if (unlikely(order >= MAX_ORDER)) {
-		WARN_ON_ONCE(!(gfp_mask & __GFP_NOWARN));
+		WARN_ON_ONCE(!(gfp & __GFP_NOWARN));
 		return NULL;
 	}
 
-	gfp_mask &= gfp_allowed_mask;
-	alloc_gfp = gfp_mask;
-	if (!prepare_alloc_pages(gfp_mask, order, preferred_nid, nodemask, &ac,
+	gfp &= gfp_allowed_mask;
+	alloc_gfp = gfp;
+	if (!prepare_alloc_pages(gfp, order, preferred_nid, nodemask, &ac,
 			&alloc_gfp, &alloc_flags))
 		return NULL;
 
@@ -5041,7 +5041,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	 * Forbid the first pass from falling back to types that fragment
 	 * memory until all local zones are considered.
 	 */
-	alloc_flags |= alloc_flags_nofragment(ac.preferred_zoneref->zone, gfp_mask);
+	alloc_flags |= alloc_flags_nofragment(ac.preferred_zoneref->zone, gfp);
 
 	/* First allocation attempt */
 	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
@@ -5054,7 +5054,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	 * from a particular context which has been marked by
 	 * memalloc_no{fs,io}_{save,restore}.
 	 */
-	alloc_gfp = current_gfp_context(gfp_mask);
+	alloc_gfp = current_gfp_context(gfp);
 	ac.spread_dirty_pages = false;
 
 	/*
@@ -5066,8 +5066,8 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	page = __alloc_pages_slowpath(alloc_gfp, order, &ac);
 
 out:
-	if (memcg_kmem_enabled() && (gfp_mask & __GFP_ACCOUNT) && page &&
-	    unlikely(__memcg_kmem_charge_page(page, gfp_mask, order) != 0)) {
+	if (memcg_kmem_enabled() && (gfp & __GFP_ACCOUNT) && page &&
+	    unlikely(__memcg_kmem_charge_page(page, gfp, order) != 0)) {
 		__free_pages(page, order);
 		page = NULL;
 	}
_
