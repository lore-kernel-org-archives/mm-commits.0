Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E100C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377875AbiATV1c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377821AbiATV1Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:27:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D0CC061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:27:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01ACAB81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB9AC340E0;
        Thu, 20 Jan 2022 21:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714042;
        bh=ALXi+VxYWraIKFb+81XP7l2Uv+1o/tGjHySo6g8IOBY=;
        h=Date:From:To:Subject:From;
        b=j/48QN1d/wocAwR//Jw1cJiRTfGggQRAhRT/NcnOsq06iKFQhdN7KCmx3MPKABN7t
         FBOxDK8z0eg2CW/T7blnn9jksTAeb59vAiBHOGEumY3DZNwmzFC3HzVpVmqEVK24lL
         rNECbfE/DQLSp8wAlw9FanPpx1pcOhk9yYY4y7js=
Date:   Thu, 20 Jan 2022 13:27:22 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, mm-commits@vger.kernel.org,
        rostedt@goodmis.org, ziy@nvidia.com
Subject:  [merged]
 mm-migrate-fix-the-return-value-of-migrate_pages.patch removed from -mm
 tree
Message-ID: <20220120212722.EPMPD4az1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: fix the return value of migrate_pages()
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-the-return-value-of-migrate_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: migrate: fix the return value of migrate_pages()

Patch series "Improve the migration stats".

According to talk with Zi Yan [1], this patch set changes the return value
of migrate_pages() to avoid returning a number which is larger than the
number of pages the users tried to migrate by move_pages() syscall.  Also
fix the hugetlb migration stats and migration stats in
trace_mm_compaction_migratepages().

[1] https://lore.kernel.org/linux-mm/7E44019D-2A5D-4BA7-B4D5-00D4712F1687@nvidia.com/


This patch (of 3):

As Zi Yan pointed out, the syscall move_pages() can return a non-migrated
number larger than the number of pages the users tried to migrate, when a
THP page is failed to migrate.  This is confusing for users.

Since other migration scenarios do not care about the actual non-migrated
number of pages except the memory compaction migration which will fix in
following patch.  Thus we can change the return value to return the number
of {normal page, THP, hugetlb} instead to avoid this issue, and the number
of THP splits will be considered as the number of non-migrated THP, no
matter how many subpages of the THP are migrated successfully.  Meanwhile
we should still keep the migration counters using the number of normal
pages.

Link: https://lkml.kernel.org/r/cover.1636275127.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/6486fabc3e8c66ff613e150af25e89b3147977a6.1636275127.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Co-developed-by: Zi Yan <ziy@nvidia.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   63 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 47 insertions(+), 16 deletions(-)

--- a/mm/migrate.c~mm-migrate-fix-the-return-value-of-migrate_pages
+++ a/mm/migrate.c
@@ -1421,7 +1421,7 @@ static inline int try_split_thp(struct p
  * @mode:		The migration mode that specifies the constraints for
  *			page migration, if any.
  * @reason:		The reason for page migration.
- * @ret_succeeded:	Set to the number of pages migrated successfully if
+ * @ret_succeeded:	Set to the number of normal pages migrated successfully if
  *			the caller passes a non-NULL pointer.
  *
  * The function returns after 10 attempts or if no pages are movable any more
@@ -1429,7 +1429,9 @@ static inline int try_split_thp(struct p
  * It is caller's responsibility to call putback_movable_pages() to return pages
  * to the LRU or free list only if ret != 0.
  *
- * Returns the number of pages that were not migrated, or an error code.
+ * Returns the number of {normal page, THP} that were not migrated, or an error code.
+ * The number of THP splits will be considered as the number of non-migrated THP,
+ * no matter how many subpages of the THP are migrated successfully.
  */
 int migrate_pages(struct list_head *from, new_page_t get_new_page,
 		free_page_t put_new_page, unsigned long private,
@@ -1438,6 +1440,7 @@ int migrate_pages(struct list_head *from
 	int retry = 1;
 	int thp_retry = 1;
 	int nr_failed = 0;
+	int nr_failed_pages = 0;
 	int nr_succeeded = 0;
 	int nr_thp_succeeded = 0;
 	int nr_thp_failed = 0;
@@ -1449,13 +1452,16 @@ int migrate_pages(struct list_head *from
 	int swapwrite = current->flags & PF_SWAPWRITE;
 	int rc, nr_subpages;
 	LIST_HEAD(ret_pages);
+	LIST_HEAD(thp_split_pages);
 	bool nosplit = (reason == MR_NUMA_MISPLACED);
+	bool no_subpage_counting = false;
 
 	trace_mm_migrate_pages_start(mode, reason);
 
 	if (!swapwrite)
 		current->flags |= PF_SWAPWRITE;
 
+thp_subpage_migration:
 	for (pass = 0; pass < 10 && (retry || thp_retry); pass++) {
 		retry = 0;
 		thp_retry = 0;
@@ -1504,18 +1510,20 @@ retry:
 			case -ENOSYS:
 				/* THP migration is unsupported */
 				if (is_thp) {
-					if (!try_split_thp(page, &page2, from)) {
+					nr_thp_failed++;
+					if (!try_split_thp(page, &page2, &thp_split_pages)) {
 						nr_thp_split++;
 						goto retry;
 					}
 
-					nr_thp_failed++;
-					nr_failed += nr_subpages;
+					nr_failed_pages += nr_subpages;
 					break;
 				}
 
 				/* Hugetlb migration is unsupported */
-				nr_failed++;
+				if (!no_subpage_counting)
+					nr_failed++;
+				nr_failed_pages++;
 				break;
 			case -ENOMEM:
 				/*
@@ -1524,16 +1532,19 @@ retry:
 				 * THP NUMA faulting doesn't split THP to retry.
 				 */
 				if (is_thp && !nosplit) {
-					if (!try_split_thp(page, &page2, from)) {
+					nr_thp_failed++;
+					if (!try_split_thp(page, &page2, &thp_split_pages)) {
 						nr_thp_split++;
 						goto retry;
 					}
 
-					nr_thp_failed++;
-					nr_failed += nr_subpages;
+					nr_failed_pages += nr_subpages;
 					goto out;
 				}
-				nr_failed++;
+
+				if (!no_subpage_counting)
+					nr_failed++;
+				nr_failed_pages++;
 				goto out;
 			case -EAGAIN:
 				if (is_thp) {
@@ -1559,17 +1570,37 @@ retry:
 				 */
 				if (is_thp) {
 					nr_thp_failed++;
-					nr_failed += nr_subpages;
+					nr_failed_pages += nr_subpages;
 					break;
 				}
-				nr_failed++;
+
+				if (!no_subpage_counting)
+					nr_failed++;
+				nr_failed_pages++;
 				break;
 			}
 		}
 	}
-	nr_failed += retry + thp_retry;
+	nr_failed += retry;
 	nr_thp_failed += thp_retry;
-	rc = nr_failed;
+	/*
+	 * Try to migrate subpages of fail-to-migrate THPs, no nr_failed
+	 * counting in this round, since all subpages of a THP is counted
+	 * as 1 failure in the first round.
+	 */
+	if (!list_empty(&thp_split_pages)) {
+		/*
+		 * Move non-migrated pages (after 10 retries) to ret_pages
+		 * to avoid migrating them again.
+		 */
+		list_splice_init(from, &ret_pages);
+		list_splice_init(&thp_split_pages, from);
+		no_subpage_counting = true;
+		retry = 1;
+		goto thp_subpage_migration;
+	}
+
+	rc = nr_failed + nr_thp_failed;
 out:
 	/*
 	 * Put the permanent failure page back to migration list, they
@@ -1578,11 +1609,11 @@ out:
 	list_splice(&ret_pages, from);
 
 	count_vm_events(PGMIGRATE_SUCCESS, nr_succeeded);
-	count_vm_events(PGMIGRATE_FAIL, nr_failed);
+	count_vm_events(PGMIGRATE_FAIL, nr_failed_pages);
 	count_vm_events(THP_MIGRATION_SUCCESS, nr_thp_succeeded);
 	count_vm_events(THP_MIGRATION_FAIL, nr_thp_failed);
 	count_vm_events(THP_MIGRATION_SPLIT, nr_thp_split);
-	trace_mm_migrate_pages(nr_succeeded, nr_failed, nr_thp_succeeded,
+	trace_mm_migrate_pages(nr_succeeded, nr_failed_pages, nr_thp_succeeded,
 			       nr_thp_failed, nr_thp_split, mode, reason);
 
 	if (!swapwrite)
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


