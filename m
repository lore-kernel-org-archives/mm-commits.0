Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4551C43331
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A035364EDB
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237925AbhCDA6x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:58:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:41532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236938AbhCDAID (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:08:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27E6B64EDF;
        Thu,  4 Mar 2021 00:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614816441;
        bh=Ow3RY9qCbcbJwvg5+fHV5L7BXYCYNJgR1LTLHe1bAI0=;
        h=Date:From:To:Subject:From;
        b=TgG1Y3pYtdoid8TzGIuhRWT20Wyw2IMN+VQrKa3Qn1S5xr8IQMZI7aj3wrAz3gMga
         Cc/Sm9gSpSZ8pqOkdqvC/UtUI1exD+0PcwQXPC6Qoa1Zavz1wq+euevw/8pjWcQ1tj
         6Ek1k8rpdZVErnfP2iekTKmkc83MsSTo+0wCtozY=
Date:   Wed, 03 Mar 2021 16:07:20 -0800
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        vbabka@suse.cz, willy@infradead.org
Subject:  + mm-page_alloc-rename-alloc_mask-to-alloc_gfp.patch
 added to -mm tree
Message-ID: <20210304000720.4Vitp23yM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: rename alloc_mask to alloc_gfp
has been added to the -mm tree.  Its filename is
     mm-page_alloc-rename-alloc_mask-to-alloc_gfp.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-rename-alloc_mask-to-alloc_gfp.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-rename-alloc_mask-to-alloc_gfp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-rename-alloc_mask-to-alloc_gfp
+++ a/mm/page_alloc.c
@@ -4920,7 +4920,7 @@ got_pg:
 
 static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 		int preferred_nid, nodemask_t *nodemask,
-		struct alloc_context *ac, gfp_t *alloc_mask,
+		struct alloc_context *ac, gfp_t *alloc_gfp,
 		unsigned int *alloc_flags)
 {
 	ac->highest_zoneidx = gfp_zone(gfp_mask);
@@ -4929,7 +4929,7 @@ static inline bool prepare_alloc_pages(g
 	ac->migratetype = gfp_migratetype(gfp_mask);
 
 	if (cpusets_enabled()) {
-		*alloc_mask |= __GFP_HARDWALL;
+		*alloc_gfp |= __GFP_HARDWALL;
 		/*
 		 * When we are in the interrupt context, it is irrelevant
 		 * to the current task context. It means that any node ok.
@@ -4973,7 +4973,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 {
 	struct page *page;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
-	gfp_t alloc_mask; /* The gfp_t that was actually used for allocation */
+	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
 	struct alloc_context ac = { };
 
 	/*
@@ -4986,8 +4986,9 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	}
 
 	gfp_mask &= gfp_allowed_mask;
-	alloc_mask = gfp_mask;
-	if (!prepare_alloc_pages(gfp_mask, order, preferred_nid, nodemask, &ac, &alloc_mask, &alloc_flags))
+	alloc_gfp = gfp_mask;
+	if (!prepare_alloc_pages(gfp_mask, order, preferred_nid, nodemask, &ac,
+			&alloc_gfp, &alloc_flags))
 		return NULL;
 
 	/*
@@ -4997,7 +4998,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	alloc_flags |= alloc_flags_nofragment(ac.preferred_zoneref->zone, gfp_mask);
 
 	/* First allocation attempt */
-	page = get_page_from_freelist(alloc_mask, order, alloc_flags, &ac);
+	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
 	if (likely(page))
 		goto out;
 
@@ -5007,7 +5008,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	 * from a particular context which has been marked by
 	 * memalloc_no{fs,io}_{save,restore}.
 	 */
-	alloc_mask = current_gfp_context(gfp_mask);
+	alloc_gfp = current_gfp_context(gfp_mask);
 	ac.spread_dirty_pages = false;
 
 	/*
@@ -5016,7 +5017,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	 */
 	ac.nodemask = nodemask;
 
-	page = __alloc_pages_slowpath(alloc_mask, order, &ac);
+	page = __alloc_pages_slowpath(alloc_gfp, order, &ac);
 
 out:
 	if (memcg_kmem_enabled() && (gfp_mask & __GFP_ACCOUNT) && page &&
@@ -5025,7 +5026,7 @@ out:
 		page = NULL;
 	}
 
-	trace_mm_page_alloc(page, order, alloc_mask, ac.migratetype);
+	trace_mm_page_alloc(page, order, alloc_gfp, ac.migratetype);
 
 	return page;
 }
_

Patches currently in -mm which might be from willy@infradead.org are

mm-filemap-use-filemap_read_page-in-filemap_fault.patch
mm-filemap-drop-check-for-truncated-page-after-i-o.patch
mm-page_alloc-rename-alloc_mask-to-alloc_gfp.patch
mm-page_alloc-rename-gfp_mask-to-gfp.patch
mm-page_alloc-combine-__alloc_pages-and-__alloc_pages_nodemask.patch
mm-mempolicy-rename-alloc_pages_current-to-alloc_pages.patch
mm-mempolicy-rewrite-alloc_pages-documentation.patch
mm-mempolicy-rewrite-alloc_pages_vma-documentation.patch
mm-mempolicy-fix-mpol_misplaced-kernel-doc.patch

