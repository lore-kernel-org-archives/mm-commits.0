Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD742C61DB3
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 23:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbjAJXyR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 18:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234469AbjAJXyO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 18:54:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BC0564F9
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 15:54:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BF81B81A20
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 23:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0369C433D2;
        Tue, 10 Jan 2023 23:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673394849;
        bh=U9Rck5qWBSoeXNSVrXiciIwqgXIt6+d7pi6Y81/9kaQ=;
        h=Date:To:From:Subject:From;
        b=UX0lyuDuNrjlpnfuZy+9wKqYhnvqko1d1i9cKcyFvuDUrELRzvURbPYXBHxZOOGEM
         IsaqjfQg/401wLrdjEGCVIeJ28S+CA5sh1fel9kd4MgtlAn20+0h4G+Vd1+KmPY6x7
         Xhnw+FYIbsCu7tOYV2fmygSMEaA/HIu/k5MIe4G8=
Date:   Tue, 10 Jan 2023 15:54:08 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, xhao@linux.alibaba.com,
        willy@infradead.org, shy828301@gmail.com, osalvador@suse.de,
        bharata@amd.com, baolin.wang@linux.alibaba.com, apopple@nvidia.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate_pages-restrict-number-of-pages-to-migrate-in-batch.patch added to mm-unstable branch
Message-Id: <20230110235409.B0369C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate_pages: restrict number of pages to migrate in batch
has been added to the -mm mm-unstable branch.  Its filename is
     migrate_pages-restrict-number-of-pages-to-migrate-in-batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate_pages-restrict-number-of-pages-to-migrate-in-batch.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: migrate_pages: restrict number of pages to migrate in batch
Date: Tue, 10 Jan 2023 15:53:21 +0800

This is a preparation patch to batch the folio unmapping and moving for
non-hugetlb folios.

If we had batched the folio unmapping, all folios to be migrated would be
unmapped before copying the contents and flags of the folios.  If the
folios that were passed to migrate_pages() were too many in unit of pages,
the execution of the processes would be stopped for too long time, thus
too long latency.  For example, migrate_pages() syscall will call
migrate_pages() with all folios of a process.  To avoid this possible
issue, in this patch, we restrict the number of pages to be migrated to be
no more than HPAGE_PMD_NR.  That is, the influence is at the same level of
THP migration.

Link: https://lkml.kernel.org/r/20230110075327.590514-4-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: haoxin <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |  174 +++++++++++++++++++++++++++++--------------------
 1 file changed, 106 insertions(+), 68 deletions(-)

--- a/mm/migrate.c~migrate_pages-restrict-number-of-pages-to-migrate-in-batch
+++ a/mm/migrate.c
@@ -1413,6 +1413,11 @@ static inline int try_split_folio(struct
 	return rc;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#define NR_MAX_BATCHED_MIGRATION	HPAGE_PMD_NR
+#else
+#define NR_MAX_BATCHED_MIGRATION	512
+#endif
 #define NR_MAX_MIGRATE_PAGES_RETRY	10
 
 struct migrate_pages_stats {
@@ -1514,40 +1519,15 @@ static int migrate_hugetlbs(struct list_
 	return nr_failed;
 }
 
-/*
- * migrate_pages - migrate the folios specified in a list, to the free folios
- *		   supplied as the target for the page migration
- *
- * @from:		The list of folios to be migrated.
- * @get_new_page:	The function used to allocate free folios to be used
- *			as the target of the folio migration.
- * @put_new_page:	The function used to free target folios if migration
- *			fails, or NULL if no special handling is necessary.
- * @private:		Private data to be passed on to get_new_page()
- * @mode:		The migration mode that specifies the constraints for
- *			folio migration, if any.
- * @reason:		The reason for folio migration.
- * @ret_succeeded:	Set to the number of folios migrated successfully if
- *			the caller passes a non-NULL pointer.
- *
- * The function returns after NR_MAX_MIGRATE_PAGES_RETRY attempts or if no folios
- * are movable any more because the list has become empty or no retryable folios
- * exist any more. It is caller's responsibility to call putback_movable_pages()
- * to return folios to the LRU or free list only if ret != 0.
- *
- * Returns the number of {normal folio, large folio, hugetlb} that were not
- * migrated, or an error code. The number of large folio splits will be
- * considered as the number of non-migrated large folio, no matter how many
- * split folios of the large folio are migrated successfully.
- */
-int migrate_pages(struct list_head *from, new_page_t get_new_page,
+static int migrate_pages_batch(struct list_head *from, new_page_t get_new_page,
 		free_page_t put_new_page, unsigned long private,
-		enum migrate_mode mode, int reason, unsigned int *ret_succeeded)
+		enum migrate_mode mode, int reason, struct list_head *ret_folios,
+		struct migrate_pages_stats *stats)
 {
 	int retry = 1;
 	int large_retry = 1;
 	int thp_retry = 1;
-	int nr_failed;
+	int nr_failed = 0;
 	int nr_retry_pages = 0;
 	int nr_large_failed = 0;
 	int pass = 0;
@@ -1555,20 +1535,9 @@ int migrate_pages(struct list_head *from
 	bool is_thp = false;
 	struct folio *folio, *folio2;
 	int rc, nr_pages;
-	LIST_HEAD(ret_folios);
 	LIST_HEAD(split_folios);
 	bool nosplit = (reason == MR_NUMA_MISPLACED);
 	bool no_split_folio_counting = false;
-	struct migrate_pages_stats stats;
-
-	trace_mm_migrate_pages_start(mode, reason);
-
-	memset(&stats, 0, sizeof(stats));
-	rc = migrate_hugetlbs(from, get_new_page, put_new_page, private, mode, reason,
-			      &stats, &ret_folios);
-	if (rc < 0)
-		goto out;
-	nr_failed = rc;
 
 split_folio_migration:
 	for (pass = 0;
@@ -1580,12 +1549,6 @@ split_folio_migration:
 		nr_retry_pages = 0;
 
 		list_for_each_entry_safe(folio, folio2, from, lru) {
-			/* Retried hugetlb folios will be kept in list  */
-			if (folio_test_hugetlb(folio)) {
-				list_move_tail(&folio->lru, &ret_folios);
-				continue;
-			}
-
 			/*
 			 * Large folio statistics is based on the source large
 			 * folio. Capture required information that might get
@@ -1599,15 +1562,14 @@ split_folio_migration:
 
 			rc = unmap_and_move(get_new_page, put_new_page,
 					    private, folio, pass > 2, mode,
-					    reason, &ret_folios);
+					    reason, ret_folios);
 			/*
 			 * The rules are:
 			 *	Success: folio will be freed
 			 *	-EAGAIN: stay on the from list
 			 *	-ENOMEM: stay on the from list
 			 *	-ENOSYS: stay on the from list
-			 *	Other errno: put on ret_folios list then splice to
-			 *		     from list
+			 *	Other errno: put on ret_folios list
 			 */
 			switch(rc) {
 			/*
@@ -1624,17 +1586,17 @@ split_folio_migration:
 				/* Large folio migration is unsupported */
 				if (is_large) {
 					nr_large_failed++;
-					stats.nr_thp_failed += is_thp;
+					stats->nr_thp_failed += is_thp;
 					if (!try_split_folio(folio, &split_folios)) {
-						stats.nr_thp_split += is_thp;
+						stats->nr_thp_split += is_thp;
 						break;
 					}
 				} else if (!no_split_folio_counting) {
 					nr_failed++;
 				}
 
-				stats.nr_failed_pages += nr_pages;
-				list_move_tail(&folio->lru, &ret_folios);
+				stats->nr_failed_pages += nr_pages;
+				list_move_tail(&folio->lru, ret_folios);
 				break;
 			case -ENOMEM:
 				/*
@@ -1643,13 +1605,13 @@ split_folio_migration:
 				 */
 				if (is_large) {
 					nr_large_failed++;
-					stats.nr_thp_failed += is_thp;
+					stats->nr_thp_failed += is_thp;
 					/* Large folio NUMA faulting doesn't split to retry. */
 					if (!nosplit) {
 						int ret = try_split_folio(folio, &split_folios);
 
 						if (!ret) {
-							stats.nr_thp_split += is_thp;
+							stats->nr_thp_split += is_thp;
 							break;
 						} else if (reason == MR_LONGTERM_PIN &&
 							   ret == -EAGAIN) {
@@ -1667,17 +1629,17 @@ split_folio_migration:
 					nr_failed++;
 				}
 
-				stats.nr_failed_pages += nr_pages + nr_retry_pages;
+				stats->nr_failed_pages += nr_pages + nr_retry_pages;
 				/*
 				 * There might be some split folios of fail-to-migrate large
-				 * folios left in split_folios list. Move them back to migration
+				 * folios left in split_folios list. Move them to ret_folios
 				 * list so that they could be put back to the right list by
 				 * the caller otherwise the folio refcnt will be leaked.
 				 */
-				list_splice_init(&split_folios, from);
+				list_splice_init(&split_folios, ret_folios);
 				/* nr_failed isn't updated for not used */
 				nr_large_failed += large_retry;
-				stats.nr_thp_failed += thp_retry;
+				stats->nr_thp_failed += thp_retry;
 				goto out;
 			case -EAGAIN:
 				if (is_large) {
@@ -1689,8 +1651,8 @@ split_folio_migration:
 				nr_retry_pages += nr_pages;
 				break;
 			case MIGRATEPAGE_SUCCESS:
-				stats.nr_succeeded += nr_pages;
-				stats.nr_thp_succeeded += is_thp;
+				stats->nr_succeeded += nr_pages;
+				stats->nr_thp_succeeded += is_thp;
 				break;
 			default:
 				/*
@@ -1701,20 +1663,20 @@ split_folio_migration:
 				 */
 				if (is_large) {
 					nr_large_failed++;
-					stats.nr_thp_failed += is_thp;
+					stats->nr_thp_failed += is_thp;
 				} else if (!no_split_folio_counting) {
 					nr_failed++;
 				}
 
-				stats.nr_failed_pages += nr_pages;
+				stats->nr_failed_pages += nr_pages;
 				break;
 			}
 		}
 	}
 	nr_failed += retry;
 	nr_large_failed += large_retry;
-	stats.nr_thp_failed += thp_retry;
-	stats.nr_failed_pages += nr_retry_pages;
+	stats->nr_thp_failed += thp_retry;
+	stats->nr_failed_pages += nr_retry_pages;
 	/*
 	 * Try to migrate split folios of fail-to-migrate large folios, no
 	 * nr_failed counting in this round, since all split folios of a
@@ -1725,7 +1687,7 @@ split_folio_migration:
 		 * Move non-migrated folios (after NR_MAX_MIGRATE_PAGES_RETRY
 		 * retries) to ret_folios to avoid migrating them again.
 		 */
-		list_splice_init(from, &ret_folios);
+		list_splice_init(from, ret_folios);
 		list_splice_init(&split_folios, from);
 		no_split_folio_counting = true;
 		retry = 1;
@@ -1734,6 +1696,82 @@ split_folio_migration:
 
 	rc = nr_failed + nr_large_failed;
 out:
+	return rc;
+}
+
+/*
+ * migrate_pages - migrate the folios specified in a list, to the free folios
+ *		   supplied as the target for the page migration
+ *
+ * @from:		The list of folios to be migrated.
+ * @get_new_page:	The function used to allocate free folios to be used
+ *			as the target of the folio migration.
+ * @put_new_page:	The function used to free target folios if migration
+ *			fails, or NULL if no special handling is necessary.
+ * @private:		Private data to be passed on to get_new_page()
+ * @mode:		The migration mode that specifies the constraints for
+ *			folio migration, if any.
+ * @reason:		The reason for folio migration.
+ * @ret_succeeded:	Set to the number of folios migrated successfully if
+ *			the caller passes a non-NULL pointer.
+ *
+ * The function returns after NR_MAX_MIGRATE_PAGES_RETRY attempts or if no folios
+ * are movable any more because the list has become empty or no retryable folios
+ * exist any more. It is caller's responsibility to call putback_movable_pages()
+ * to return folios to the LRU or free list only if ret != 0.
+ *
+ * Returns the number of {normal folio, large folio, hugetlb} that were not
+ * migrated, or an error code. The number of large folio splits will be
+ * considered as the number of non-migrated large folio, no matter how many
+ * split folios of the large folio are migrated successfully.
+ */
+int migrate_pages(struct list_head *from, new_page_t get_new_page,
+		free_page_t put_new_page, unsigned long private,
+		enum migrate_mode mode, int reason, unsigned int *ret_succeeded)
+{
+	int rc, rc_gather;
+	int nr_pages;
+	struct folio *folio, *folio2;
+	LIST_HEAD(folios);
+	LIST_HEAD(ret_folios);
+	struct migrate_pages_stats stats;
+
+	trace_mm_migrate_pages_start(mode, reason);
+
+	memset(&stats, 0, sizeof(stats));
+
+	rc_gather = migrate_hugetlbs(from, get_new_page, put_new_page, private,
+				     mode, reason, &stats, &ret_folios);
+	if (rc_gather < 0)
+		goto out;
+again:
+	nr_pages = 0;
+	list_for_each_entry_safe(folio, folio2, from, lru) {
+		/* Retried hugetlb folios will be kept in list  */
+		if (folio_test_hugetlb(folio)) {
+			list_move_tail(&folio->lru, &ret_folios);
+			continue;
+		}
+
+		nr_pages += folio_nr_pages(folio);
+		if (nr_pages > NR_MAX_BATCHED_MIGRATION)
+			break;
+	}
+	if (nr_pages > NR_MAX_BATCHED_MIGRATION)
+		list_cut_before(&folios, from, &folio->lru);
+	else
+		list_splice_init(from, &folios);
+	rc = migrate_pages_batch(&folios, get_new_page, put_new_page, private,
+				 mode, reason, &ret_folios, &stats);
+	list_splice_tail_init(&folios, &ret_folios);
+	if (rc < 0) {
+		rc_gather = rc;
+		goto out;
+	}
+	rc_gather += rc;
+	if (!list_empty(from))
+		goto again;
+out:
 	/*
 	 * Put the permanent failure folio back to migration list, they
 	 * will be put back to the right list by the caller.
@@ -1745,7 +1783,7 @@ out:
 	 * are migrated successfully.
 	 */
 	if (list_empty(from))
-		rc = 0;
+		rc_gather = 0;
 
 	count_vm_events(PGMIGRATE_SUCCESS, stats.nr_succeeded);
 	count_vm_events(PGMIGRATE_FAIL, stats.nr_failed_pages);
@@ -1759,7 +1797,7 @@ out:
 	if (ret_succeeded)
 		*ret_succeeded = stats.nr_succeeded;
 
-	return rc;
+	return rc_gather;
 }
 
 struct page *alloc_migration_target(struct page *page, unsigned long private)
_

Patches currently in -mm which might be from ying.huang@intel.com are

migrate_pages-organize-stats-with-struct-migrate_pages_stats.patch
migrate_pages-separate-hugetlb-folios-migration.patch
migrate_pages-restrict-number-of-pages-to-migrate-in-batch.patch
migrate_pages-split-unmap_and_move-to-_unmap-and-_move.patch
migrate_pages-batch-_unmap-and-_move.patch
migrate_pages-move-migrate_folio_unmap.patch
migrate_pages-share-more-code-between-_unmap-and-_move.patch
migrate_pages-batch-flushing-tlb.patch
migrate_pages-move-thp-hugetlb-migration-support-check-to-simplify-code.patch

