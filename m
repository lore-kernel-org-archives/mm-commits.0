Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55044C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 415BC6112E
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350502AbhICVB2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:01:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350431AbhICVB0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:01:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC207610FB;
        Fri,  3 Sep 2021 21:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702826;
        bh=OYjHYy3pSPoNsw6s4Y5VLjMp7L+FJQQonaNNYAh/BKg=;
        h=Date:From:To:Subject:From;
        b=ksZBQfORCLChqdLhGIIUTwX8L418nIyPJIh3Cw5HJZrkqjxATYRZpX3kjIy+fM+/R
         Q2aquyBNOyshj+A2iXK7JRJRiAyBISYNmvHTMhUlS6oOLEdAd98AdEwzRfU6cOxlTq
         pKmgj2plGrfyI6yCh1da2Ei4Bru4asM8S5x/OsWo=
Date:   Fri, 03 Sep 2021 14:00:25 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, gthelen@google.com, kbusch@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        rientjes@google.com, shy828301@gmail.com, weixugc@google.com,
        yang.shi@linux.alibaba.com, ying.huang@intel.com, ziy@nvidia.com
Subject:  [merged]
 mm-migrate-enable-returning-precise-migrate_pages-success-count.patch
 removed from -mm tree
Message-ID: <20210903210025.V8cXNzcvr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: enable returning precise migrate_pages() success count
has been removed from the -mm tree.  Its filename was
     mm-migrate-enable-returning-precise-migrate_pages-success-count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm/migrate: enable returning precise migrate_pages() success count

Under normal circumstances, migrate_pages() returns the number of pages
migrated.  In error conditions, it returns an error code.  When returning
an error code, there is no way to know how many pages were migrated or not
migrated.

Make migrate_pages() return how many pages are demoted successfully for
all cases, including when encountering errors.  Page reclaim behavior will
depend on this in subsequent patches.

Link: https://lkml.kernel.org/r/20210721063926.3024591-3-ying.huang@intel.com
Link: https://lkml.kernel.org/r/20210715055145.195411-4-ying.huang@intel.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Suggested-by: Oscar Salvador <osalvador@suse.de> [optional parameter]
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    5 +++--
 mm/compaction.c         |    2 +-
 mm/gup.c                |    2 +-
 mm/memory-failure.c     |    2 +-
 mm/memory_hotplug.c     |    2 +-
 mm/mempolicy.c          |    4 ++--
 mm/migrate.c            |   11 ++++++++---
 mm/page_alloc.c         |    2 +-
 8 files changed, 18 insertions(+), 12 deletions(-)

--- a/include/linux/migrate.h~mm-migrate-enable-returning-precise-migrate_pages-success-count
+++ a/include/linux/migrate.h
@@ -41,7 +41,8 @@ extern int migrate_page(struct address_s
 			struct page *newpage, struct page *page,
 			enum migrate_mode mode);
 extern int migrate_pages(struct list_head *l, new_page_t new, free_page_t free,
-		unsigned long private, enum migrate_mode mode, int reason);
+		unsigned long private, enum migrate_mode mode, int reason,
+		unsigned int *ret_succeeded);
 extern struct page *alloc_migration_target(struct page *page, unsigned long private);
 extern int isolate_movable_page(struct page *page, isolate_mode_t mode);
 
@@ -56,7 +57,7 @@ extern int migrate_page_move_mapping(str
 static inline void putback_movable_pages(struct list_head *l) {}
 static inline int migrate_pages(struct list_head *l, new_page_t new,
 		free_page_t free, unsigned long private, enum migrate_mode mode,
-		int reason)
+		int reason, unsigned int *ret_succeeded)
 	{ return -ENOSYS; }
 static inline struct page *alloc_migration_target(struct page *page,
 		unsigned long private)
--- a/mm/compaction.c~mm-migrate-enable-returning-precise-migrate_pages-success-count
+++ a/mm/compaction.c
@@ -2398,7 +2398,7 @@ compact_zone(struct compact_control *cc,
 
 		err = migrate_pages(&cc->migratepages, compaction_alloc,
 				compaction_free, (unsigned long)cc, cc->mode,
-				MR_COMPACTION);
+				MR_COMPACTION, NULL);
 
 		trace_mm_compaction_migratepages(cc->nr_migratepages, err,
 							&cc->migratepages);
--- a/mm/gup.c~mm-migrate-enable-returning-precise-migrate_pages-success-count
+++ a/mm/gup.c
@@ -1772,7 +1772,7 @@ static long check_and_migrate_movable_pa
 	if (!list_empty(&movable_page_list)) {
 		ret = migrate_pages(&movable_page_list, alloc_migration_target,
 				    NULL, (unsigned long)&mtc, MIGRATE_SYNC,
-				    MR_LONGTERM_PIN);
+				    MR_LONGTERM_PIN, NULL);
 		if (ret && !list_empty(&movable_page_list))
 			putback_movable_pages(&movable_page_list);
 	}
--- a/mm/memory-failure.c~mm-migrate-enable-returning-precise-migrate_pages-success-count
+++ a/mm/memory-failure.c
@@ -2099,7 +2099,7 @@ static int __soft_offline_page(struct pa
 
 	if (isolate_page(hpage, &pagelist)) {
 		ret = migrate_pages(&pagelist, alloc_migration_target, NULL,
-			(unsigned long)&mtc, MIGRATE_SYNC, MR_MEMORY_FAILURE);
+			(unsigned long)&mtc, MIGRATE_SYNC, MR_MEMORY_FAILURE, NULL);
 		if (!ret) {
 			bool release = !huge;
 
--- a/mm/memory_hotplug.c~mm-migrate-enable-returning-precise-migrate_pages-success-count
+++ a/mm/memory_hotplug.c
@@ -1469,7 +1469,7 @@ do_migrate_range(unsigned long start_pfn
 		if (nodes_empty(nmask))
 			node_set(mtc.nid, nmask);
 		ret = migrate_pages(&source, alloc_migration_target, NULL,
-			(unsigned long)&mtc, MIGRATE_SYNC, MR_MEMORY_HOTPLUG);
+			(unsigned long)&mtc, MIGRATE_SYNC, MR_MEMORY_HOTPLUG, NULL);
 		if (ret) {
 			list_for_each_entry(page, &source, lru) {
 				if (__ratelimit(&migrate_rs)) {
--- a/mm/mempolicy.c~mm-migrate-enable-returning-precise-migrate_pages-success-count
+++ a/mm/mempolicy.c
@@ -1084,7 +1084,7 @@ static int migrate_to_node(struct mm_str
 
 	if (!list_empty(&pagelist)) {
 		err = migrate_pages(&pagelist, alloc_migration_target, NULL,
-				(unsigned long)&mtc, MIGRATE_SYNC, MR_SYSCALL);
+				(unsigned long)&mtc, MIGRATE_SYNC, MR_SYSCALL, NULL);
 		if (err)
 			putback_movable_pages(&pagelist);
 	}
@@ -1338,7 +1338,7 @@ static long do_mbind(unsigned long start
 		if (!list_empty(&pagelist)) {
 			WARN_ON_ONCE(flags & MPOL_MF_LAZY);
 			nr_failed = migrate_pages(&pagelist, new_page, NULL,
-				start, MIGRATE_SYNC, MR_MEMPOLICY_MBIND);
+				start, MIGRATE_SYNC, MR_MEMPOLICY_MBIND, NULL);
 			if (nr_failed)
 				putback_movable_pages(&pagelist);
 		}
--- a/mm/migrate.c~mm-migrate-enable-returning-precise-migrate_pages-success-count
+++ a/mm/migrate.c
@@ -1429,6 +1429,8 @@ static inline int try_split_thp(struct p
  * @mode:		The migration mode that specifies the constraints for
  *			page migration, if any.
  * @reason:		The reason for page migration.
+ * @ret_succeeded:	Set to the number of pages migrated successfully if
+ *			the caller passes a non-NULL pointer.
  *
  * The function returns after 10 attempts or if no pages are movable any more
  * because the list has become empty or no retryable pages exist any more.
@@ -1439,7 +1441,7 @@ static inline int try_split_thp(struct p
  */
 int migrate_pages(struct list_head *from, new_page_t get_new_page,
 		free_page_t put_new_page, unsigned long private,
-		enum migrate_mode mode, int reason)
+		enum migrate_mode mode, int reason, unsigned int *ret_succeeded)
 {
 	int retry = 1;
 	int thp_retry = 1;
@@ -1594,6 +1596,9 @@ out:
 	if (!swapwrite)
 		current->flags &= ~PF_SWAPWRITE;
 
+	if (ret_succeeded)
+		*ret_succeeded = nr_succeeded;
+
 	return rc;
 }
 
@@ -1663,7 +1668,7 @@ static int do_move_pages_to_node(struct
 	};
 
 	err = migrate_pages(pagelist, alloc_migration_target, NULL,
-			(unsigned long)&mtc, MIGRATE_SYNC, MR_SYSCALL);
+		(unsigned long)&mtc, MIGRATE_SYNC, MR_SYSCALL, NULL);
 	if (err)
 		putback_movable_pages(pagelist);
 	return err;
@@ -2178,7 +2183,7 @@ int migrate_misplaced_page(struct page *
 
 	list_add(&page->lru, &migratepages);
 	nr_remaining = migrate_pages(&migratepages, *new, NULL, node,
-				     MIGRATE_ASYNC, MR_NUMA_MISPLACED);
+				     MIGRATE_ASYNC, MR_NUMA_MISPLACED, NULL);
 	if (nr_remaining) {
 		if (!list_empty(&migratepages)) {
 			list_del(&page->lru);
--- a/mm/page_alloc.c~mm-migrate-enable-returning-precise-migrate_pages-success-count
+++ a/mm/page_alloc.c
@@ -8990,7 +8990,7 @@ static int __alloc_contig_migrate_range(
 		cc->nr_migratepages -= nr_reclaimed;
 
 		ret = migrate_pages(&cc->migratepages, alloc_migration_target,
-				NULL, (unsigned long)&mtc, cc->mode, MR_CONTIG_RANGE);
+			NULL, (unsigned long)&mtc, cc->mode, MR_CONTIG_RANGE, NULL);
 
 		/*
 		 * On -ENOMEM, migrate_pages() bails out right away. It is pointless
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are


