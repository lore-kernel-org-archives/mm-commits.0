Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 602DDC43603
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A25064E7C
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238896AbhCDA6y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:58:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:39422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354495AbhCDAJY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:09:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC47064E6F;
        Thu,  4 Mar 2021 00:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614816444;
        bh=+uiaRKamYopDO2UumE0Ftm9qVGB10v3GuMPxvC85iKk=;
        h=Date:From:To:Subject:From;
        b=w/3kFNiFrSFUKrwZR+JSkv8l+nL2kPoXGP+EP9wMBrBY6DsevZFet3NfdoX5yxf4+
         HFcbeSV1dASjGP+wSgzMIbN6sB7ve9ckiiWB2zobzt3+DIQQI2I2OZbxZgHSFWOfks
         USBBS70Uf3me+e6O8B3rAu9+HPM49Yfnds6H5Ock=
Date:   Wed, 03 Mar 2021 16:07:23 -0800
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        vbabka@suse.cz, willy@infradead.org
Subject:  + mm-page_alloc-rename-gfp_mask-to-gfp.patch added to -mm
 tree
Message-ID: <20210304000723.AocYunVME%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: rename gfp_mask to gfp
has been added to the -mm tree.  Its filename is
     mm-page_alloc-rename-gfp_mask-to-gfp.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-rename-gfp_mask-to-gfp.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-rename-gfp_mask-to-gfp.patch

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
@@ -4968,7 +4968,7 @@ static inline bool prepare_alloc_pages(g
  * This is the 'heart' of the zoned buddy allocator.
  */
 struct page *
-__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
+__alloc_pages_nodemask(gfp_t gfp, unsigned int order, int preferred_nid,
 							nodemask_t *nodemask)
 {
 	struct page *page;
@@ -4981,13 +4981,13 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
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
 
@@ -4995,7 +4995,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	 * Forbid the first pass from falling back to types that fragment
 	 * memory until all local zones are considered.
 	 */
-	alloc_flags |= alloc_flags_nofragment(ac.preferred_zoneref->zone, gfp_mask);
+	alloc_flags |= alloc_flags_nofragment(ac.preferred_zoneref->zone, gfp);
 
 	/* First allocation attempt */
 	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
@@ -5008,7 +5008,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	 * from a particular context which has been marked by
 	 * memalloc_no{fs,io}_{save,restore}.
 	 */
-	alloc_gfp = current_gfp_context(gfp_mask);
+	alloc_gfp = current_gfp_context(gfp);
 	ac.spread_dirty_pages = false;
 
 	/*
@@ -5020,8 +5020,8 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
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

mm-filemap-use-filemap_read_page-in-filemap_fault.patch
mm-filemap-drop-check-for-truncated-page-after-i-o.patch
mm-page_alloc-rename-alloc_mask-to-alloc_gfp.patch
mm-page_alloc-rename-gfp_mask-to-gfp.patch
mm-page_alloc-combine-__alloc_pages-and-__alloc_pages_nodemask.patch
mm-mempolicy-rename-alloc_pages_current-to-alloc_pages.patch
mm-mempolicy-rewrite-alloc_pages-documentation.patch
mm-mempolicy-rewrite-alloc_pages_vma-documentation.patch
mm-mempolicy-fix-mpol_misplaced-kernel-doc.patch

