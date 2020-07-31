Return-Path: <SRS0=f579=BK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9659FC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75446208E4
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596226987;
	bh=NHthXn8ZlikvNAJ0TVSaP5D76V6Pjm8s4UxsPo6HIXA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=wnrixdavrTxcdyFN7weCVSHjrLeLpCtbVlPqjdbTCx1KZ2WzUCtDF6YRBGlSLBxoj
	 qnXCKwZbQTzn9JwFIPqhWZ+phdD2pp2MW2lio1GsQTNXbjc+iOd3ejAvv+QHVYuioj
	 ZB0zn1PWsWJxhcioJXWFYGtSiahLLI2Aoih4/nFg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbgGaUXH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Jul 2020 16:23:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726950AbgGaUXH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jul 2020 16:23:07 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA78B2087C;
        Fri, 31 Jul 2020 20:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596226986;
        bh=NHthXn8ZlikvNAJ0TVSaP5D76V6Pjm8s4UxsPo6HIXA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vg9L1UScXBVDv4PIYU5Mh/1VlsnwjlBX/wuzmihcT1wVem4lBJawhXfduLawZQHA4
         AQ6nsYIGT62aooB25dVP9JaWXyVpDazDLBfYcwnKmvP9BB2iWfxU8z8CgT2pnAnEhO
         ELgRFnFmHF35Gl87BoM8OFyPhsP98v/P8sA2n9Ow=
Date:   Fri, 31 Jul 2020 13:23:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aneesh.kumar@linux.ibm.com, guro@fb.com, hch@infradead.org,
        iamjoonsoo.kim@lge.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        vbabka@suse.cz
Subject:  +
 mm-gup-restrict-cma-region-by-using-allocation-scope-api.patch added to -mm
 tree
Message-ID: <20200731202305.qJtp_n8fC%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: restrict CMA region by using allocation scope API
has been added to the -mm tree.  Its filename is
     mm-gup-restrict-cma-region-by-using-allocation-scope-api.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-restrict-cma-region-by-using-allocation-scope-api.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-restrict-cma-region-by-using-allocation-scope-api.patch

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
Subject: mm/gup: restrict CMA region by using allocation scope API

We have well defined scope API to exclude CMA region.  Use it rather than
manipulating gfp_mask manually.  With this change, we can now restore
__GFP_MOVABLE for gfp_mask like as usual migration target allocation.  It
would result in that the ZONE_MOVABLE is also searched by page allocator. 
For hugetlb, gfp_mask is redefined since it has a regular allocation mask
filter for migration target.  __GPF_NOWARN is added to hugetlb gfp_mask
filter since a new user for gfp_mask filter, gup, want to be silent when
allocation fails.

Note that this can be considered as a fix for the commit 9a4e9f3b2d73
("mm: update get_user_pages_longterm to migrate pages allocated from CMA
region").  However, "Fixes" tag isn't added here since it is just
suboptimal but it doesn't cause any problem.

Link: http://lkml.kernel.org/r/1596180906-8442-1-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 ++
 mm/gup.c                |   17 ++++++++---------
 2 files changed, 10 insertions(+), 9 deletions(-)

--- a/include/linux/hugetlb.h~mm-gup-restrict-cma-region-by-using-allocation-scope-api
+++ a/include/linux/hugetlb.h
@@ -708,6 +708,8 @@ static inline gfp_t htlb_modify_alloc_ma
 	/* Some callers might want to enfoce node */
 	modified_mask |= (gfp_mask & __GFP_THISNODE);
 
+	modified_mask |= (gfp_mask & __GFP_NOWARN);
+
 	return modified_mask;
 }
 
--- a/mm/gup.c~mm-gup-restrict-cma-region-by-using-allocation-scope-api
+++ a/mm/gup.c
@@ -1620,10 +1620,12 @@ static struct page *new_non_cma_page(str
 	 * Trying to allocate a page for migration. Ignore allocation
 	 * failure warnings. We don't force __GFP_THISNODE here because
 	 * this node here is the node where we have CMA reservation and
-	 * in some case these nodes will have really less non movable
+	 * in some case these nodes will have really less non CMA
 	 * allocation memory.
+	 *
+	 * Note that CMA region is prohibited by allocation scope.
 	 */
-	gfp_t gfp_mask = GFP_USER | __GFP_NOWARN;
+	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_NOWARN;
 
 	if (PageHighMem(page))
 		gfp_mask |= __GFP_HIGHMEM;
@@ -1631,6 +1633,8 @@ static struct page *new_non_cma_page(str
 #ifdef CONFIG_HUGETLB_PAGE
 	if (PageHuge(page)) {
 		struct hstate *h = page_hstate(page);
+
+		gfp_mask = htlb_modify_alloc_mask(h, gfp_mask);
 		/*
 		 * We don't want to dequeue from the pool because pool pages will
 		 * mostly be from the CMA region.
@@ -1645,11 +1649,6 @@ static struct page *new_non_cma_page(str
 		 */
 		gfp_t thp_gfpmask = GFP_TRANSHUGE | __GFP_NOWARN;
 
-		/*
-		 * Remove the movable mask so that we don't allocate from
-		 * CMA area again.
-		 */
-		thp_gfpmask &= ~__GFP_MOVABLE;
 		thp = __alloc_pages_node(nid, thp_gfpmask, HPAGE_PMD_ORDER);
 		if (!thp)
 			return NULL;
@@ -1795,7 +1794,6 @@ static long __gup_longterm_locked(struct
 				     vmas_tmp, NULL, gup_flags);
 
 	if (gup_flags & FOLL_LONGTERM) {
-		memalloc_nocma_restore(flags);
 		if (rc < 0)
 			goto out;
 
@@ -1808,9 +1806,10 @@ static long __gup_longterm_locked(struct
 
 		rc = check_and_migrate_cma_pages(tsk, mm, start, rc, pages,
 						 vmas_tmp, gup_flags);
+out:
+		memalloc_nocma_restore(flags);
 	}
 
-out:
 	if (vmas_tmp != vmas)
 		kfree(vmas_tmp);
 	return rc;
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

