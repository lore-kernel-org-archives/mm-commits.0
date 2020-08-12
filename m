Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D6BC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41B3F2054F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196253;
	bh=bKAPJNIGiVJlKhCT4bZZpnE0Q/Iy6y8D8bXa9KzP67s=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=le9881/g+d6T7UEEceefWnLZbpQPd6tLHPo8KWZCCt6cBn24CxTYUqjHi8z7VP3p/
	 uNaXSEgCnxnWfHbifhsV9Pzb5OyY+LtI4u6tLrVfnR5/GL6UFy7jygj7s3zEJ1Zwi1
	 2lPwZCuzUeT0Dy2Opl6rvzPVDK+sm3czgPMFQocs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgHLBhd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:37:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBhc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:37:32 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE74A2076C;
        Wed, 12 Aug 2020 01:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196252;
        bh=bKAPJNIGiVJlKhCT4bZZpnE0Q/Iy6y8D8bXa9KzP67s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OeXnUKnRsULF2WigFu8qs4DU6ZMnwYP4emmZzlcrefp5Mv9oIyE13ujPTZ7EzfHSO
         /y1vUUfUSf5FA3BnLsNKM19uqitR6qIbGH+/3NIDGh/oQfMra8WyZAuYe7Le8mBnd9
         iZP++TqnjvaitGFoaNpjGKk3zqggo62VdwJq0xFs=
Date:   Tue, 11 Aug 2020 18:37:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hch@infradead.org,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 137/165] mm/page_alloc: remove a wrapper for
 alloc_migration_target()
Message-ID: <20200812013731.WRd9fl7-I%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -8347,6 +8347,10 @@ static int __alloc_contig_migrate_range(
 	unsigned long pfn = start;
 	unsigned int tries = 0;
 	int ret = 0;
+	struct migration_target_control mtc = {
+		.nid = zone_to_nid(cc->zone),
+		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
+	};
 
 	migrate_prep();
 
@@ -8373,8 +8377,8 @@ static int __alloc_contig_migrate_range(
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
