Return-Path: <SRS0=97KN=AZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD71C433E3
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:21:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D7F221548
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594689718;
	bh=QkBdVORgQSMd86nB/nKWTqCXflY8e26PyP3LfdqyfhU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=JirAdwDWyI6Yc2ek7wj+129UWr2gSt5gHSCVsoSyUoNuqudaRuKvni1bnJ4jy9d7z
	 n+67dru47wT9iTGTRrUwjUnKGM5evqJMxLN977QoZ6EVC71delVc1gBufJrEqPqfs0
	 Knryah79NdQ7dePoWKi+S0ljPbaIKgMr25HsYZ44=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgGNBV6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:21:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbgGNBV6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jul 2020 21:21:58 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBE55206F0;
        Tue, 14 Jul 2020 01:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594689717;
        bh=QkBdVORgQSMd86nB/nKWTqCXflY8e26PyP3LfdqyfhU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mlcOpfzyFGOkKnUKrnTsxnBaRa+nZ2UG64u/kU6274HVzXgF2OJjSL/5vuUKA00Rl
         cUl2CjcWu50xcRs85q3UJ0SthQFRAATqKTtxjkJi7vZy0Yg2t2eEGau/2meCdmj+5Z
         kfoFQOKzdeLQMw6rp+oZLCFRmyq1D/1J/nsQmkls=
Date:   Mon, 13 Jul 2020 18:21:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     guro@fb.com, hch@infradead.org, iamjoonsoo.kim@lge.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        vbabka@suse.cz
Subject:  +
 mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch added to
 -mm tree
Message-ID: <20200714012156.XBGYMFbv_%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: remove a wrapper for alloc_migration_target()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch

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
Subject: mm/page_alloc: remove a wrapper for alloc_migration_target()

There is a well-defined standard migration target callback.  Use it
directly.

Link: http://lkml.kernel.org/r/1594622517-20681-8-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c     |    8 ++++++--
 mm/page_isolation.c |   10 ----------
 2 files changed, 6 insertions(+), 12 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-a-wrapper-for-alloc_migration_target
+++ a/mm/page_alloc.c
@@ -8358,6 +8358,10 @@ static int __alloc_contig_migrate_range(
 	unsigned long pfn = start;
 	unsigned int tries = 0;
 	int ret = 0;
+	struct migration_target_control mtc = {
+		.nid = zone_to_nid(cc->zone),
+		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
+	};
 
 	migrate_prep();
 
@@ -8384,8 +8388,8 @@ static int __alloc_contig_migrate_range(
 							&cc->migratepages);
 		cc->nr_migratepages -= nr_reclaimed;
 
-		ret = migrate_pages(&cc->migratepages, alloc_migrate_target,
-				    NULL, 0, cc->mode, MR_CONTIG_RANGE);
+		ret = migrate_pages(&cc->migratepages, alloc_migration_target,
+				NULL, (unsigned long)&mtc, cc->mode, MR_CONTIG_RANGE);
 	}
 	if (ret < 0) {
 		putback_movable_pages(&cc->migratepages);
--- a/mm/page_isolation.c~mm-page_alloc-remove-a-wrapper-for-alloc_migration_target
+++ a/mm/page_isolation.c
@@ -306,13 +306,3 @@ int test_pages_isolated(unsigned long st
 
 	return pfn < end_pfn ? -EBUSY : 0;
 }
-
-struct page *alloc_migrate_target(struct page *page, unsigned long private)
-{
-	struct migration_target_control mtc = {
-		.nid = page_to_nid(page),
-		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
-	};
-
-	return alloc_migration_target(page, (unsigned long)&mtc);
-}
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-page_isolation-prefer-the-node-of-the-source-page.patch
mm-migrate-move-migration-helper-from-h-to-c.patch
mm-hugetlb-unify-migration-callbacks.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations.patch
mm-migrate-make-a-standard-migration-target-allocation-function.patch
mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch
mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target.patch

