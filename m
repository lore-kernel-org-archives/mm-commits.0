Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F2EC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 678172054F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196263;
	bh=A5cH1NAQnmGLu37kkURza4E/9mYH4+bZUF+n/yvzJ1E=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=gmgP1ojBgUFiJC2zRsdWu9j8y74n72WIge8diQjWjIPMWaRzbiXGNdfRnc8wg/hDg
	 ZJAlNDZcsNOB5GF0fL0x8Qlx76BMmc7rtuILd32OMDJfXxrAchu/5Fzds6logX3pVb
	 PFTcr9lNblGyFGVOa5csHJusdfJCHaScfRLLGUBA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgHLBhn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:37:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBhm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:37:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D3F9207DA;
        Wed, 12 Aug 2020 01:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196262;
        bh=A5cH1NAQnmGLu37kkURza4E/9mYH4+bZUF+n/yvzJ1E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PiB0g5zi6MG3fn+J5Xd/KQlusstn50YYRUwPdnRiqLPdju5dnvTsxZ5xBQ1OnC7YO
         WEMWLb0Pf8XbYCu7bgQUwLoUcJrcsV51CwyKdP/qgS3WgLJJjpIhkTMRfGDRDmfZ7N
         TvWdj8QZQJNNUzy41vgFT5MGhchPL5r12a+vtORY=
Date:   Tue, 11 Aug 2020 18:37:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com, guro@fb.com,
        hch@infradead.org, iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 140/165] mm/gup: use a standard migration target
 allocation callback
Message-ID: <20200812013741.E5avAOyH9%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/gup: use a standard migration target allocation callback

There is a well-defined migration target allocation callback. Use it.

Link: http://lkml.kernel.org/r/1596180906-8442-3-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   54 +++++------------------------------------------------
 1 file changed, 6 insertions(+), 48 deletions(-)

--- a/mm/gup.c~mm-gup-use-a-standard-migration-target-allocation-callback
+++ a/mm/gup.c
@@ -1609,52 +1609,6 @@ static bool check_dax_vmas(struct vm_are
 }
 
 #ifdef CONFIG_CMA
-static struct page *new_non_cma_page(struct page *page, unsigned long private)
-{
-	/*
-	 * We want to make sure we allocate the new page from the same node
-	 * as the source page.
-	 */
-	int nid = page_to_nid(page);
-	/*
-	 * Trying to allocate a page for migration. Ignore allocation
-	 * failure warnings. We don't force __GFP_THISNODE here because
-	 * this node here is the node where we have CMA reservation and
-	 * in some case these nodes will have really less non CMA
-	 * allocation memory.
-	 *
-	 * Note that CMA region is prohibited by allocation scope.
-	 */
-	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_NOWARN;
-
-	if (PageHighMem(page))
-		gfp_mask |= __GFP_HIGHMEM;
-
-#ifdef CONFIG_HUGETLB_PAGE
-	if (PageHuge(page)) {
-		struct hstate *h = page_hstate(page);
-
-		gfp_mask = htlb_modify_alloc_mask(h, gfp_mask);
-		return alloc_huge_page_nodemask(h, nid, NULL, gfp_mask);
-	}
-#endif
-	if (PageTransHuge(page)) {
-		struct page *thp;
-		/*
-		 * ignore allocation failure warnings
-		 */
-		gfp_t thp_gfpmask = GFP_TRANSHUGE | __GFP_NOWARN;
-
-		thp = __alloc_pages_node(nid, thp_gfpmask, HPAGE_PMD_ORDER);
-		if (!thp)
-			return NULL;
-		prep_transhuge_page(thp);
-		return thp;
-	}
-
-	return __alloc_pages_node(nid, gfp_mask, 0);
-}
-
 static long check_and_migrate_cma_pages(struct task_struct *tsk,
 					struct mm_struct *mm,
 					unsigned long start,
@@ -1669,6 +1623,10 @@ static long check_and_migrate_cma_pages(
 	bool migrate_allow = true;
 	LIST_HEAD(cma_page_list);
 	long ret = nr_pages;
+	struct migration_target_control mtc = {
+		.nid = NUMA_NO_NODE,
+		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_NOWARN,
+	};
 
 check_again:
 	for (i = 0; i < nr_pages;) {
@@ -1714,8 +1672,8 @@ check_again:
 		for (i = 0; i < nr_pages; i++)
 			put_page(pages[i]);
 
-		if (migrate_pages(&cma_page_list, new_non_cma_page,
-				  NULL, 0, MIGRATE_SYNC, MR_CONTIG_RANGE)) {
+		if (migrate_pages(&cma_page_list, alloc_migration_target, NULL,
+			(unsigned long)&mtc, MIGRATE_SYNC, MR_CONTIG_RANGE)) {
 			/*
 			 * some of the pages failed migration. Do get_user_pages
 			 * without migration.
_
