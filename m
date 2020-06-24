From: akpm@linux-foundation.org
Subject: + mm-migrate-move-migration-helper-from-h-to-c.patch added
 to -mm tree
Date: Wed, 24 Jun 2020 15:06:10 -0700
Message-ID: <20200624220610.QZw6H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388749AbgFXWGL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 18:06:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, n-horiguchi@ah.jp.nec.com, mike.kravetz@oracle.com, mhocko@suse.com, mgorman@techsingularity.net, hch@infradead.org, guro@fb.com, iamjoonsoo.kim@lge.com


The patch titled
     Subject: mm/migrate: move migration helper from .h to .c
has been added to the -mm tree.  Its filename is
     mm-migrate-move-migration-helper-from-h-to-c.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-move-migration-helper-from-h-to-c.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-move-migration-helper-from-h-to-c.patch

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
Subject: mm/migrate: move migration helper from .h to .c

It's not performance sensitive function.  Move it to .c.  This is a
preparation step for future change.

Link: http://lkml.kernel.org/r/1592892828-1934-3-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
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
@@ -1513,6 +1513,35 @@ out:
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

mm-swap-fix-for-mm-workingset-age-nonresident-information-alongside-anonymous-pages.patch
mm-memory-fix-io-cost-for-anonymous-page.patch
mm-page_isolation-prefer-the-node-of-the-source-page.patch
mm-migrate-move-migration-helper-from-h-to-c.patch
mm-hugetlb-unify-migration-callbacks.patch
mm-hugetlb-make-hugetlb-migration-callback-cma-aware.patch
mm-migrate-make-a-standard-migration-target-allocation-function.patch
mm-gup-use-a-standard-migration-target-allocation-callback.patch
mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch
mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch
