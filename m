Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5886C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE94A2080C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266366;
	bh=JkEkCtWWLHNijOS5L5BpDcXNohiA3bnt+GpbByd9B4g=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=WobwIjWFOZNK8YHm6UMsdl70Kvfp/zFb3OTUjk6b8yMzLOSPC+JB7uOeXFrIcF0Zs
	 WckrA0/1q86ZlScdondKccqt5Is5Ot6IDSGZ9zrJKDeQbJgjsD6JRx6fynVQo9/UQ8
	 KcD5pLzwqMgsje0nhJUQWfBDJRsG0K3qCY/XjJcc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgHLVGG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:06:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbgHLVGG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:06:06 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B1B620B1F;
        Wed, 12 Aug 2020 21:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266364;
        bh=JkEkCtWWLHNijOS5L5BpDcXNohiA3bnt+GpbByd9B4g=;
        h=Date:From:To:Subject:From;
        b=l1gjxIy4pvPjwKgrhiq8gN4kRRvZi/M6jQtJj3jzYKT66mG02SqhPLBPLMhDZtZMm
         BbThQZbPfhPeHH4bSiQGhGfCAMFM1GA9vF58DhtCiQY30G3b26qSPMKFUl+L1ZY+Ab
         9Zne0qb4y71eTUx9TqO8PUSVc+QzVE9YvAf0cOv8=
Date:   Wed, 12 Aug 2020 14:06:04 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hch@infradead.org, iamjoonsoo.kim@lge.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch removed
 from -mm tree
Message-ID: <20200812210604.a3xzD3AO7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: remove a wrapper for alloc_migration_target()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target.patch

