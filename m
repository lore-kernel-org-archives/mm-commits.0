Return-Path: <SRS0=97KN=AZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C04C433E5
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F3CE206F0
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594689715;
	bh=5zAxEUggnMfDzY0/9fZnMc1Hb3MnXRfZTLvZy/yvdgc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=mX93JdxYqD49EJfTxkZPiSmCvXO7ybr1nthMzIbqDgYvs3aJVS7KiMVUUKFluwR2z
	 R3DuHnCP5FHN3QzPoPbnhe2V3jYfSIfMvy4Wz7wL7cEATV0/mZfy2uDMElfPUJui+c
	 SCejpHVRpVSLPqYITAbyi9NagNwwlvcZ2rQ+ALJ4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgGNBVz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:21:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbgGNBVz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jul 2020 21:21:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7F3D2192A;
        Tue, 14 Jul 2020 01:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594689714;
        bh=5zAxEUggnMfDzY0/9fZnMc1Hb3MnXRfZTLvZy/yvdgc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eAkDbzPJq/w60TDIOjN4GDQt/RQzK/e21QocQVxstNEcmsDo43mNIu9yDAYGtiKY0
         6eMBYrRtcHuSe986H1walOrGPosdDaB0pijfZ6UP2miQeNXn8eKUqA2zNEvnEnrMpv
         ymYfo+PO2WxKgSq0OB2s3QbvEkKjm1xy09hi6i30=
Date:   Mon, 13 Jul 2020 18:21:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     guro@fb.com, hch@infradead.org, iamjoonsoo.kim@lge.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        vbabka@suse.cz
Subject:  +
 mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch
 added to -mm tree
Message-ID: <20200714012153.aysVaQQVj%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: use a standard migration target allocation callback
has been added to the -mm tree.  Its filename is
     mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch

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
@@ -1594,9 +1594,13 @@ static int do_move_pages_to_node(struct
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

