Return-Path: <SRS0=f579=BK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8772C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:23:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9765D208E4
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596226993;
	bh=gOte3wVnB6RNTTBaiGPqy7CZ2lso7GgVOLbk17V/t50=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=V3FuzDjRr04041mftQr5YD3d/QHEdW78X4NxRifflkcE4N0DOPdGo+3evW9ClEYWm
	 xkSqJl3a/bX4kRk5EVXvNQZ5pSXDPb1yu+PtloyF1zyrYxPfrY0BgrrPJF39NiOZxr
	 a2peuLgK1NiFP5WAO3JxgDOAGgU6EeW/adMT4oqM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgGaUXN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Jul 2020 16:23:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726950AbgGaUXN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jul 2020 16:23:13 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA7C72087C;
        Fri, 31 Jul 2020 20:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596226992;
        bh=gOte3wVnB6RNTTBaiGPqy7CZ2lso7GgVOLbk17V/t50=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LSyay1p+kgsn6hreUaS1M/sTDuT2DndT+66626RFamfWbQR5+kRno6096va+60HKM
         EsCU4pGr8q4Wyo/SN0qkPaxlddJuOYVpnMUqraiiPMSd9ko91nLUiNEzggWXAnHXk0
         gvspHcjm7v9Ni1IBx1KdrHXzzp4bDcgfMy+fKvrA=
Date:   Fri, 31 Jul 2020 13:23:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aneesh.kumar@linux.ibm.com, guro@fb.com, hch@infradead.org,
        iamjoonsoo.kim@lge.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        vbabka@suse.cz
Subject:  +
 mm-gup-use-a-standard-migration-target-allocation-callback.patch added to
 -mm tree
Message-ID: <20200731202311.443ypjMoy%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: use a standard migration target allocation callback
has been added to the -mm tree.  Its filename is
     mm-gup-use-a-standard-migration-target-allocation-callback.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-use-a-standard-migration-target-allocation-callback.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-use-a-standard-migration-target-allocation-callback.patch

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

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-page_alloc-fix-memalloc_nocma_save-restore-apis.patch
mm-vmscan-make-active-inactive-ratio-as-1-1-for-anon-lru.patch
mm-vmscan-protect-the-workingset-on-anonymous-lru.patch
mm-workingset-prepare-the-workingset-detection-infrastructure-for-anon-lru.patch
mm-swapcache-support-to-handle-the-shadow-entries.patch
mm-swap-implement-workingset-detection-for-anonymous-lru.patch
mm-vmscan-restore-active-inactive-ratio-for-anonymous-lru.patch
mm-page_isolation-prefer-the-node-of-the-source-page.patch
mm-migrate-move-migration-helper-from-h-to-c.patch
mm-hugetlb-unify-migration-callbacks.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations.patch
mm-migrate-make-a-standard-migration-target-allocation-function.patch
mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch
mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target.patch
mm-gup-restrict-cma-region-by-using-allocation-scope-api.patch
mm-hugetlb-make-hugetlb-migration-callback-cma-aware.patch
mm-gup-use-a-standard-migration-target-allocation-callback.patch

