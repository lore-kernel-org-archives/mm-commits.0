Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9BF4C25B6F
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbjJYXvN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234816AbjJYXti (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:49:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A60170D
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:49:27 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2708C433C9;
        Wed, 25 Oct 2023 23:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277767;
        bh=P0o5lO+0f/SzftGeiqfWtBeCW86AHaZrW0yKMCwi3PM=;
        h=Date:To:From:Subject:From;
        b=FKVy9Yep8wK+LQWf7yujlWb2QEU/DfQmCZ7g3zOY7zbrpxJsGSrmgM6/x387hpSH0
         8JSoxu47kzI5b2e+y/97K2m0YNNqy5OcQUVn/3ALG9v/Rr3vXBElFb55lEDMvydCGy
         iXaAV+z++Nf7D6mkDzUNz8RT92nTNokLOe7CraZQ=
Date:   Wed, 25 Oct 2023 16:49:27 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        ying.huang@intel.com, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com, tj@kernel.org,
        surenb@google.com, sidhartha.kumar@oracle.com, shy828301@gmail.com,
        nphamcs@gmail.com, mike.kravetz@oracle.com, mhocko@suse.com,
        mgorman@techsingularity.net, gregkh@linuxfoundation.org,
        david@redhat.com, cl@linux.com, ak@linux.intel.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-page_rmappable_folio-wrapper.patch removed from -mm tree
Message-Id: <20231025234927.B2708C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add page_rmappable_folio() wrapper
has been removed from the -mm tree.  Its filename was
     mm-add-page_rmappable_folio-wrapper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: add page_rmappable_folio() wrapper
Date: Tue, 3 Oct 2023 02:25:33 -0700 (PDT)

folio_prep_large_rmappable() is being used repeatedly along with a
conversion from page to folio, a check non-NULL, a check order > 1: wrap
it all up into struct folio *page_rmappable_folio(struct page *).

Link: https://lkml.kernel.org/r/8d92c6cf-eebe-748-e29c-c8ab224c741@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun heo <tj@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    9 +++++++++
 mm/mempolicy.c  |   17 +++--------------
 mm/page_alloc.c |    8 ++------
 3 files changed, 14 insertions(+), 20 deletions(-)

--- a/mm/internal.h~mm-add-page_rmappable_folio-wrapper
+++ a/mm/internal.h
@@ -415,6 +415,15 @@ static inline void folio_set_order(struc
 
 void folio_undo_large_rmappable(struct folio *folio);
 
+static inline struct folio *page_rmappable_folio(struct page *page)
+{
+	struct folio *folio = (struct folio *)page;
+
+	if (folio && folio_order(folio) > 1)
+		folio_prep_large_rmappable(folio);
+	return folio;
+}
+
 static inline void prep_compound_head(struct page *page, unsigned int order)
 {
 	struct folio *folio = (struct folio *)page;
--- a/mm/mempolicy.c~mm-add-page_rmappable_folio-wrapper
+++ a/mm/mempolicy.c
@@ -2122,10 +2122,7 @@ struct folio *vma_alloc_folio(gfp_t gfp,
 		mpol_cond_put(pol);
 		gfp |= __GFP_COMP;
 		page = alloc_page_interleave(gfp, order, nid);
-		folio = (struct folio *)page;
-		if (folio && order > 1)
-			folio_prep_large_rmappable(folio);
-		goto out;
+		return page_rmappable_folio(page);
 	}
 
 	if (pol->mode == MPOL_PREFERRED_MANY) {
@@ -2135,10 +2132,7 @@ struct folio *vma_alloc_folio(gfp_t gfp,
 		gfp |= __GFP_COMP;
 		page = alloc_pages_preferred_many(gfp, order, node, pol);
 		mpol_cond_put(pol);
-		folio = (struct folio *)page;
-		if (folio && order > 1)
-			folio_prep_large_rmappable(folio);
-		goto out;
+		return page_rmappable_folio(page);
 	}
 
 	if (unlikely(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && hugepage)) {
@@ -2232,12 +2226,7 @@ EXPORT_SYMBOL(alloc_pages);
 
 struct folio *folio_alloc(gfp_t gfp, unsigned order)
 {
-	struct page *page = alloc_pages(gfp | __GFP_COMP, order);
-	struct folio *folio = (struct folio *)page;
-
-	if (folio && order > 1)
-		folio_prep_large_rmappable(folio);
-	return folio;
+	return page_rmappable_folio(alloc_pages(gfp | __GFP_COMP, order));
 }
 EXPORT_SYMBOL(folio_alloc);
 
--- a/mm/page_alloc.c~mm-add-page_rmappable_folio-wrapper
+++ a/mm/page_alloc.c
@@ -4598,12 +4598,8 @@ struct folio *__folio_alloc(gfp_t gfp, u
 		nodemask_t *nodemask)
 {
 	struct page *page = __alloc_pages(gfp | __GFP_COMP, order,
-			preferred_nid, nodemask);
-	struct folio *folio = (struct folio *)page;
-
-	if (folio && order > 1)
-		folio_prep_large_rmappable(folio);
-	return folio;
+					preferred_nid, nodemask);
+	return page_rmappable_folio(page);
 }
 EXPORT_SYMBOL(__folio_alloc);
 
_

Patches currently in -mm which might be from hughd@google.com are


