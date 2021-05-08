Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2514C43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFB24613C5
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbhEHWqE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:46:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229693AbhEHWqD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:46:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88B896100C;
        Sat,  8 May 2021 22:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513900;
        bh=jK0NQPHelZlGn0NxRhUKftIFGG4RTzCSoMHQV4kP5w0=;
        h=Date:From:To:Subject:From;
        b=Tda6knzmOQonF7DiyOtmDScWYA/k3aghBjs8rpA+DmYppaSp9U9X2Vmixcvv/ex9w
         QHdC3Fxe5ZpZqyutfRNOK89XUd8CgnO3pYvq+X2zI85/sVlMw05BhlbD4ZHuu2k237
         w1UL0eXnKN8T3pIogeLXF1JUpRp1//DByiEjiFE4=
Date:   Sat, 08 May 2021 15:45:00 -0700
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        vbabka@suse.cz, willy@infradead.org
Subject:  [merged] mm-page_alloc-rename-gfp_mask-to-gfp.patch
 removed from -mm tree
Message-ID: <20210508224500.XmoN3UrrZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: rename gfp_mask to gfp
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-rename-gfp_mask-to-gfp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from willy@infradead.org are


