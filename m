From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated]
 mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch
 removed from -mm tree
Date: Tue, 07 Jul 2020 12:47:32 -0700
Message-ID: <20200707194732.aXXWZe5Bx%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbgGGTrd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 15:47:33 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hch@infradead.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz


The patch titled
     Subject: mm/mempolicy: use a standard migration target allocation callback
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/mempolicy: use a standard migration target allocation callback

There is a well-defined migration target allocation callback.  Use it.

Link: http://lkml.kernel.org/r/1592892828-1934-8-git-send-email-iamjoonsoo.kim@lge.com
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

 mm/internal.h  |    1 -
 mm/mempolicy.c |   30 ++++++------------------------
 mm/migrate.c   |    8 ++++++--
 3 files changed, 12 insertions(+), 27 deletions(-)

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
@@ -1065,28 +1065,6 @@ static int migrate_page_add(struct page
 	return 0;
 }
 
-/* page allocation callback for NUMA node migration */
-struct page *alloc_new_node_page(struct page *page, unsigned long node)
-{
-	if (PageHuge(page)) {
-		return alloc_huge_page_nodemask(
-			page_hstate(compound_head(page)), node,
-			NULL, __GFP_THISNODE, false);
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
@@ -1097,6 +1075,10 @@ static int migrate_to_node(struct mm_str
 	nodemask_t nmask;
 	LIST_HEAD(pagelist);
 	int err = 0;
+	struct migration_target_control mtc = {
+		.nid = dest,
+		.gfp_mask = GFP_HIGHUSER_MOVABLE | __GFP_THISNODE,
+	};
 
 	nodes_clear(nmask);
 	node_set(source, nmask);
@@ -1111,8 +1093,8 @@ static int migrate_to_node(struct mm_str
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
@@ -1567,9 +1567,13 @@ static int do_move_pages_to_node(struct
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

mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch
