Return-Path: <SRS0=+Rhw=AS=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F016EC433DF
	for <mm-commits@archiver.kernel.org>; Tue,  7 Jul 2020 19:47:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3FBE206E9
	for <mm-commits@archiver.kernel.org>; Tue,  7 Jul 2020 19:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594151256;
	bh=R4oQb6PN1h5Hq3TPo7hYdm6iJxCAwilflD4w41slXy4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Gc35//g0VPFQJkKWnZKOKgzO2O/j3ZUhyIrZFiHpQ6Ace6LSWZ31TFFgC8Nv0svEE
	 x8jrqdaILM+fHN5sVRKFH1qn8ZKMdQvMCW8z2fBY5Rdmm+BWXP1Ccu/rwwe3EV3l76
	 IvmQ8tIePe76NDlvtufSybw+2kM8QbyByQPNVqRE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbgGGTrg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Jul 2020 15:47:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbgGGTrg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 15:47:36 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95A4E206BE;
        Tue,  7 Jul 2020 19:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594151255;
        bh=R4oQb6PN1h5Hq3TPo7hYdm6iJxCAwilflD4w41slXy4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WcYi+fuSXmRHpQKEnlqutFL4G0oOSyAFYGLRZ91dyiZtdKCpLdFxPK+y9CBkshpsZ
         2TbHCfmJ+RydiRuSBbTdNtA6k5b1xEBnobKH2MMW78whFdwlmpF0WpXxlXZbiy1NiR
         aa6+BryBlUD3Ay3tYMBB3YQ+RwF4Da5MSLOp79JI=
Date:   Tue, 07 Jul 2020 12:47:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     guro@fb.com, hch@infradead.org, iamjoonsoo.kim@lge.com,
        mgorman@techsingularity.net, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, vbabka@suse.cz
Subject:  [to-be-updated]
 mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch removed
 from -mm tree
Message-ID: <20200707194735.HDeK0HQY8%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
Message-ID: <20200707194735.y4th81oGUWKhJCqmznKQsM3_GwLlNMVAuIEfJQrrOJQ@z>


The patch titled
     Subject: mm/page_alloc: remove a wrapper for alloc_migration_target()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_alloc: remove a wrapper for alloc_migration_target()

There is a well-defined standard migration target callback.  Use it
directly.

Link: http://lkml.kernel.org/r/1592892828-1934-9-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c     |    9 +++++++--
 mm/page_isolation.c |   11 -----------
 2 files changed, 7 insertions(+), 13 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-a-wrapper-for-alloc_migration_target
+++ a/mm/page_alloc.c
@@ -8354,6 +8354,11 @@ static int __alloc_contig_migrate_range(
 	unsigned long pfn = start;
 	unsigned int tries = 0;
 	int ret = 0;
+	struct migration_target_control mtc = {
+		.nid = zone_to_nid(cc->zone),
+		.nmask = &node_states[N_MEMORY],
+		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
+	};
 
 	migrate_prep();
 
@@ -8380,8 +8385,8 @@ static int __alloc_contig_migrate_range(
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
@@ -306,14 +306,3 @@ int test_pages_isolated(unsigned long st
 
 	return pfn < end_pfn ? -EBUSY : 0;
 }
-
-struct page *alloc_migrate_target(struct page *page, unsigned long private)
-{
-	struct migration_target_control mtc = {
-		.nid = page_to_nid(page),
-		.nmask = &node_states[N_MEMORY],
-		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
-	};
-
-	return alloc_migration_target(page, (unsigned long)&mtc);
-}
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are


