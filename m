From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated]
 mm-migrate-make-a-standard-migration-target-allocation-function.patch
 removed from -mm tree
Date: Tue, 07 Jul 2020 12:47:26 -0700
Message-ID: <20200707194726.oI9OhfjWl%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728265AbgGGTr1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 15:47:27 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hch@infradead.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz


The patch titled
     Subject: mm/migrate: make a standard migration target allocation function
has been removed from the -mm tree.  Its filename was
     mm-migrate-make-a-standard-migration-target-allocation-function.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/migrate: make a standard migration target allocation function

There are some similar functions for migration target allocation.  Since
there is no fundamental difference, it's better to keep just one rather
than keeping all variants.  This patch implements base migration target
allocation function.  In the following patches, variants will be converted
to use this function.

Note that PageHighmem() call in previous function is changed to open-code
"is_highmem_idx()" since it provides more readability.

Link: http://lkml.kernel.org/r/1592892828-1934-6-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    5 +++--
 mm/internal.h           |    7 +++++++
 mm/memory-failure.c     |    8 ++++++--
 mm/memory_hotplug.c     |   14 +++++++++-----
 mm/migrate.c            |   21 +++++++++++++--------
 mm/page_isolation.c     |    8 ++++++--
 6 files changed, 44 insertions(+), 19 deletions(-)

--- a/include/linux/migrate.h~mm-migrate-make-a-standard-migration-target-allocation-function
+++ a/include/linux/migrate.h
@@ -10,6 +10,8 @@
 typedef struct page *new_page_t(struct page *page, unsigned long private);
 typedef void free_page_t(struct page *page, unsigned long private);
 
+struct migration_target_control;
+
 /*
  * Return values from addresss_space_operations.migratepage():
  * - negative errno on page migration failure;
@@ -39,8 +41,7 @@ extern int migrate_page(struct address_s
 			enum migrate_mode mode);
 extern int migrate_pages(struct list_head *l, new_page_t new, free_page_t free,
 		unsigned long private, enum migrate_mode mode, int reason);
-extern struct page *new_page_nodemask(struct page *page,
-		int preferred_nid, nodemask_t *nodemask);
+extern struct page *alloc_migration_target(struct page *page, unsigned long private);
 extern int isolate_movable_page(struct page *page, isolate_mode_t mode);
 extern void putback_movable_page(struct page *page);
 
--- a/mm/internal.h~mm-migrate-make-a-standard-migration-target-allocation-function
+++ a/mm/internal.h
@@ -614,4 +614,11 @@ static inline bool is_migrate_highatomic
 
 void setup_zone_pageset(struct zone *zone);
 extern struct page *alloc_new_node_page(struct page *page, unsigned long node);
+
+struct migration_target_control {
+	int nid;		/* preferred node id */
+	nodemask_t *nmask;
+	gfp_t gfp_mask;
+};
+
 #endif	/* __MM_INTERNAL_H */
--- a/mm/memory-failure.c~mm-migrate-make-a-standard-migration-target-allocation-function
+++ a/mm/memory-failure.c
@@ -1648,9 +1648,13 @@ EXPORT_SYMBOL(unpoison_memory);
 
 static struct page *new_page(struct page *p, unsigned long private)
 {
-	int nid = page_to_nid(p);
+	struct migration_target_control mtc = {
+		.nid = page_to_nid(p),
+		.nmask = &node_states[N_MEMORY],
+		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
+	};
 
-	return new_page_nodemask(p, nid, &node_states[N_MEMORY]);
+	return alloc_migration_target(p, (unsigned long)&mtc);
 }
 
 /*
--- a/mm/memory_hotplug.c~mm-migrate-make-a-standard-migration-target-allocation-function
+++ a/mm/memory_hotplug.c
@@ -1267,19 +1267,23 @@ found:
 
 static struct page *new_node_page(struct page *page, unsigned long private)
 {
-	int nid = page_to_nid(page);
 	nodemask_t nmask = node_states[N_MEMORY];
+	struct migration_target_control mtc = {
+		.nid = page_to_nid(page),
+		.nmask = &nmask,
+		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
+	};
 
 	/*
 	 * try to allocate from a different node but reuse this node if there
 	 * are no other online nodes to be used (e.g. we are offlining a part
 	 * of the only existing node)
 	 */
-	node_clear(nid, nmask);
-	if (nodes_empty(nmask))
-		node_set(nid, nmask);
+	node_clear(mtc.nid, *mtc.nmask);
+	if (nodes_empty(*mtc.nmask))
+		node_set(mtc.nid, *mtc.nmask);
 
-	return new_page_nodemask(page, nid, &nmask);
+	return alloc_migration_target(page, (unsigned long)&mtc);
 }
 
 static int
--- a/mm/migrate.c~mm-migrate-make-a-standard-migration-target-allocation-function
+++ a/mm/migrate.c
@@ -1513,29 +1513,34 @@ out:
 	return rc;
 }
 
-struct page *new_page_nodemask(struct page *page,
-				int preferred_nid, nodemask_t *nodemask)
+struct page *alloc_migration_target(struct page *page, unsigned long private)
 {
-	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL;
+	struct migration_target_control *mtc;
+	gfp_t gfp_mask;
 	unsigned int order = 0;
 	struct page *new_page = NULL;
+	int zidx;
+
+	mtc = (struct migration_target_control *)private;
+	gfp_mask = mtc->gfp_mask;
 
 	if (PageHuge(page)) {
 		return alloc_huge_page_nodemask(
-				page_hstate(compound_head(page)),
-				preferred_nid, nodemask, 0, false);
+				page_hstate(compound_head(page)), mtc->nid,
+				mtc->nmask, gfp_mask, false);
 	}
 
 	if (PageTransHuge(page)) {
+		gfp_mask &= ~__GFP_RECLAIM;
 		gfp_mask |= GFP_TRANSHUGE;
 		order = HPAGE_PMD_ORDER;
 	}
-
-	if (PageHighMem(page) || (zone_idx(page_zone(page)) == ZONE_MOVABLE))
+	zidx = zone_idx(page_zone(page));
+	if (is_highmem_idx(zidx) || zidx == ZONE_MOVABLE)
 		gfp_mask |= __GFP_HIGHMEM;
 
 	new_page = __alloc_pages_nodemask(gfp_mask, order,
-				preferred_nid, nodemask);
+				mtc->nid, mtc->nmask);
 
 	if (new_page && PageTransHuge(new_page))
 		prep_transhuge_page(new_page);
--- a/mm/page_isolation.c~mm-migrate-make-a-standard-migration-target-allocation-function
+++ a/mm/page_isolation.c
@@ -309,7 +309,11 @@ int test_pages_isolated(unsigned long st
 
 struct page *alloc_migrate_target(struct page *page, unsigned long private)
 {
-	int nid = page_to_nid(page);
+	struct migration_target_control mtc = {
+		.nid = page_to_nid(page),
+		.nmask = &node_states[N_MEMORY],
+		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
+	};
 
-	return new_page_nodemask(page, nid, &node_states[N_MEMORY]);
+	return alloc_migration_target(page, (unsigned long)&mtc);
 }
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-gup-use-a-standard-migration-target-allocation-callback.patch
mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch
mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch
