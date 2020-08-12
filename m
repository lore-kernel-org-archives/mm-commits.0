Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68D93C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4095C2080C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266356;
	bh=q4AGOW3gTBn21TZM/03+RdjOdVBDF1ugyNqkQ7acb7s=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=boB2sLNmMgEo6LioVrGJ/A6dv6Z50LXH7Fpy0qdNPeiPSzgQ+JkLpFGbITb3Clbfd
	 3+WlDxgPiklxaxGCf9zlD0nshcBF2w2xUCY9B1O5s8btWIcnFUS1JSdbgUdlIbu07l
	 m4bxpIlbhx2S92Lr9mjuxM6rgG7nw2DIrIYQEZc0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgHLVF4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:05:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgHLVFz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:05:55 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA7DB2078B;
        Wed, 12 Aug 2020 21:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266355;
        bh=q4AGOW3gTBn21TZM/03+RdjOdVBDF1ugyNqkQ7acb7s=;
        h=Date:From:To:Subject:From;
        b=Bu2FdUCVUnn2x05jr35CRZSKKuZXyYtMkAAwfxvnY8BSxDm4/Nm8k5yB+eXP+W69P
         8tsdhEu2W28gN9BSAeVhJFwapW/rnyWytMY1ZGSYMxGf7x0a4ygNs5GKpZ0xcTj9vg
         3v4GAUZjn2RyefValDnz+yPQ+FohBTg1I4IqHlXk=
Date:   Wed, 12 Aug 2020 14:05:54 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hch@infradead.org, iamjoonsoo.kim@lge.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-migrate-move-migration-helper-from-h-to-c.patch removed from -mm tree
Message-ID: <20200812210554.4bv-h4yvw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: move migration helper from .h to .c
has been removed from the -mm tree.  Its filename was
     mm-migrate-move-migration-helper-from-h-to-c.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/migrate: move migration helper from .h to .c

It's not performance sensitive function.  Move it to .c.  This is a
preparation step for future change.

Link: http://lkml.kernel.org/r/1594622517-20681-3-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |   33 +++++----------------------------
 mm/migrate.c            |   29 +++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 28 deletions(-)

--- a/include/linux/migrate.h~mm-migrate-move-migration-helper-from-h-to-c
+++ a/include/linux/migrate.h
@@ -31,34 +31,6 @@ enum migrate_reason {
 /* In mm/debug.c; also keep sync with include/trace/events/migrate.h */
 extern const char *migrate_reason_names[MR_TYPES];
 
-static inline struct page *new_page_nodemask(struct page *page,
-				int preferred_nid, nodemask_t *nodemask)
-{
-	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL;
-	unsigned int order = 0;
-	struct page *new_page = NULL;
-
-	if (PageHuge(page))
-		return alloc_huge_page_nodemask(page_hstate(compound_head(page)),
-				preferred_nid, nodemask);
-
-	if (PageTransHuge(page)) {
-		gfp_mask |= GFP_TRANSHUGE;
-		order = HPAGE_PMD_ORDER;
-	}
-
-	if (PageHighMem(page) || (zone_idx(page_zone(page)) == ZONE_MOVABLE))
-		gfp_mask |= __GFP_HIGHMEM;
-
-	new_page = __alloc_pages_nodemask(gfp_mask, order,
-				preferred_nid, nodemask);
-
-	if (new_page && PageTransHuge(new_page))
-		prep_transhuge_page(new_page);
-
-	return new_page;
-}
-
 #ifdef CONFIG_MIGRATION
 
 extern void putback_movable_pages(struct list_head *l);
@@ -67,6 +39,8 @@ extern int migrate_page(struct address_s
 			enum migrate_mode mode);
 extern int migrate_pages(struct list_head *l, new_page_t new, free_page_t free,
 		unsigned long private, enum migrate_mode mode, int reason);
+extern struct page *new_page_nodemask(struct page *page,
+		int preferred_nid, nodemask_t *nodemask);
 extern int isolate_movable_page(struct page *page, isolate_mode_t mode);
 extern void putback_movable_page(struct page *page);
 
@@ -85,6 +59,9 @@ static inline int migrate_pages(struct l
 		free_page_t free, unsigned long private, enum migrate_mode mode,
 		int reason)
 	{ return -ENOSYS; }
+static inline struct page *new_page_nodemask(struct page *page,
+		int preferred_nid, nodemask_t *nodemask)
+	{ return NULL; }
 static inline int isolate_movable_page(struct page *page, isolate_mode_t mode)
 	{ return -EBUSY; }
 
--- a/mm/migrate.c~mm-migrate-move-migration-helper-from-h-to-c
+++ a/mm/migrate.c
@@ -1538,6 +1538,35 @@ out:
 	return rc;
 }
 
+struct page *new_page_nodemask(struct page *page,
+				int preferred_nid, nodemask_t *nodemask)
+{
+	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL;
+	unsigned int order = 0;
+	struct page *new_page = NULL;
+
+	if (PageHuge(page))
+		return alloc_huge_page_nodemask(
+				page_hstate(compound_head(page)),
+				preferred_nid, nodemask);
+
+	if (PageTransHuge(page)) {
+		gfp_mask |= GFP_TRANSHUGE;
+		order = HPAGE_PMD_ORDER;
+	}
+
+	if (PageHighMem(page) || (zone_idx(page_zone(page)) == ZONE_MOVABLE))
+		gfp_mask |= __GFP_HIGHMEM;
+
+	new_page = __alloc_pages_nodemask(gfp_mask, order,
+				preferred_nid, nodemask);
+
+	if (new_page && PageTransHuge(new_page))
+		prep_transhuge_page(new_page);
+
+	return new_page;
+}
+
 #ifdef CONFIG_NUMA
 
 static int store_status(int __user *status, int start, int value, int nr)
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target.patch

