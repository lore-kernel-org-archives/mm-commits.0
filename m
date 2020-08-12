Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7255BC433E3
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53BC420658
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196250;
	bh=TZanbVBUHN0RRIQAyHhjapwFcTY0LHEhCgqRN/FuE4k=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=dM7AcOvYcZZOst7LaVbRWZVFKGg6pfHhfbEdrjRUJk9q3qLRgFQp5cr2kWTibjTQY
	 SOx/k5ejG/byfUik75Q9uon0CyiYni2npuYSZneaMWOtiDwZU3IjCK4DwM0uIdB38X
	 viKpfZT91AGDk/sN0b7PNEciRlXDxLgH57Z/jMss=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgHLBha (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:37:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBha (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:37:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C34332054F;
        Wed, 12 Aug 2020 01:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196249;
        bh=TZanbVBUHN0RRIQAyHhjapwFcTY0LHEhCgqRN/FuE4k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jjHsXfc0idGktt/F/Da8Wf7szlmrI8kVLPIlGLJYKRZCJF6x1En93aXWeYUWN4lKh
         BDNdwmqsnwAOlR0SIdhTAiMW0MQwPHivz9TZ3IqEGV5MMzR0vtz9svnBZb3szmuWW0
         X03ajZ37F8utrgC8NuCczh1456DsKzJH7Er3gmNY=
Date:   Tue, 11 Aug 2020 18:37:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hch@infradead.org,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 136/165] mm/mempolicy: use a standard migration
 target allocation callback
Message-ID: <20200812013728.FhUOwuCCe%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/mempolicy: use a standard migration target allocation callback

There is a well-defined migration target allocation callback.  Use it.

Link: http://lkml.kernel.org/r/1594622517-20681-7-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h  |    1 -
 mm/mempolicy.c |   31 ++++++-------------------------
 mm/migrate.c   |    8 ++++++--
 3 files changed, 12 insertions(+), 28 deletions(-)

--- a/mm/internal.h~mm-mempolicy-use-a-standard-migration-target-allocation-callback
+++ a/mm/internal.h
@@ -613,7 +613,6 @@ static inline bool is_migrate_highatomic
 }
 
 void setup_zone_pageset(struct zone *zone);
-extern struct page *alloc_new_node_page(struct page *page, unsigned long node);
 
 struct migration_target_control {
 	int nid;		/* preferred node id */
--- a/mm/mempolicy.c~mm-mempolicy-use-a-standard-migration-target-allocation-callback
+++ a/mm/mempolicy.c
@@ -1065,29 +1065,6 @@ static int migrate_page_add(struct page
 	return 0;
 }
 
-/* page allocation callback for NUMA node migration */
-struct page *alloc_new_node_page(struct page *page, unsigned long node)
-{
-	if (PageHuge(page)) {
-		struct hstate *h = page_hstate(compound_head(page));
-		gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
-
-		return alloc_huge_page_nodemask(h, node, NULL, gfp_mask);
-	} else if (PageTransHuge(page)) {
-		struct page *thp;
-
-		thp = alloc_pages_node(node,
-			(GFP_TRANSHUGE | __GFP_THISNODE),
-			HPAGE_PMD_ORDER);
-		if (!thp)
-			return NULL;
-		prep_transhuge_page(thp);
-		return thp;
-	} else
-		return __alloc_pages_node(node, GFP_HIGHUSER_MOVABLE |
-						    __GFP_THISNODE, 0);
-}
-
 /*
  * Migrate pages from one node to a target node.
  * Returns error or the number of pages not migrated.
@@ -1098,6 +1075,10 @@ static int migrate_to_node(struct mm_str
 	nodemask_t nmask;
 	LIST_HEAD(pagelist);
 	int err = 0;
+	struct migration_target_control mtc = {
+		.nid = dest,
+		.gfp_mask = GFP_HIGHUSER_MOVABLE | __GFP_THISNODE,
+	};
 
 	nodes_clear(nmask);
 	node_set(source, nmask);
@@ -1112,8 +1093,8 @@ static int migrate_to_node(struct mm_str
 			flags | MPOL_MF_DISCONTIG_OK, &pagelist);
 
 	if (!list_empty(&pagelist)) {
-		err = migrate_pages(&pagelist, alloc_new_node_page, NULL, dest,
-					MIGRATE_SYNC, MR_SYSCALL);
+		err = migrate_pages(&pagelist, alloc_migration_target, NULL,
+				(unsigned long)&mtc, MIGRATE_SYNC, MR_SYSCALL);
 		if (err)
 			putback_movable_pages(&pagelist);
 	}
--- a/mm/migrate.c~mm-mempolicy-use-a-standard-migration-target-allocation-callback
+++ a/mm/migrate.c
@@ -1598,9 +1598,13 @@ static int do_move_pages_to_node(struct
 		struct list_head *pagelist, int node)
 {
 	int err;
+	struct migration_target_control mtc = {
+		.nid = node,
+		.gfp_mask = GFP_HIGHUSER_MOVABLE | __GFP_THISNODE,
+	};
 
-	err = migrate_pages(pagelist, alloc_new_node_page, NULL, node,
-			MIGRATE_SYNC, MR_SYSCALL);
+	err = migrate_pages(pagelist, alloc_migration_target, NULL,
+			(unsigned long)&mtc, MIGRATE_SYNC, MR_SYSCALL);
 	if (err)
 		putback_movable_pages(pagelist);
 	return err;
_
