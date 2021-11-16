Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3A24C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FFFB61A88
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240059AbhKPEUm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 23:20:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242925AbhKPESg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 23:18:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A99861A3A;
        Tue, 16 Nov 2021 04:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637036139;
        bh=DCX1LNxkblvzQwTsfgSKp2hZ/4p4EVn0Paxq0SaD9dQ=;
        h=Date:From:To:Subject:From;
        b=YSHePIzk9Eg5D4F4OEuhxl5++Ir7Fyq+L/PW0qE+C6ZohEc+kzWMPO8EXVK3PeIO0
         gV71uB+IzlkdjWPd01Et7d/KYf9EgKt8XILZdB16XMoh1uHzJPQhLO42WE6Aldj/jb
         hlJMQ9oE8BLum8m3iA6SQ3sWFHNi2zcqSLM54ub0=
Date:   Mon, 15 Nov 2021 20:15:38 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, mm-commits@vger.kernel.org,
        rostedt@goodmis.org, ziy@nvidia.com
Subject:  + mm-migrate-fix-the-return-value-of-migrate_pages.patch
 added to -mm tree
Message-ID: <20211116041538.-orop5VVN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: fix the return value of migrate_pages()
has been added to the -mm tree.  Its filename is
     mm-migrate-fix-the-return-value-of-migrate_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-fix-the-return-value-of-migrate_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-fix-the-return-value-of-migrate_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1422,7 +1422,7 @@ static inline int try_split_thp(struct p
  * @mode:		The migration mode that specifies the constraints for
  *			page migration, if any.
  * @reason:		The reason for page migration.
- * @ret_succeeded:	Set to the number of pages migrated successfully if
+ * @ret_succeeded:	Set to the number of normal pages migrated successfully if
  *			the caller passes a non-NULL pointer.
  *
  * The function returns after 10 attempts or if no pages are movable any more
@@ -1430,7 +1430,9 @@ static inline int try_split_thp(struct p
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
@@ -1439,6 +1441,7 @@ int migrate_pages(struct list_head *from
 	int retry = 1;
 	int thp_retry = 1;
 	int nr_failed = 0;
+	int nr_failed_pages = 0;
 	int nr_succeeded = 0;
 	int nr_thp_succeeded = 0;
 	int nr_thp_failed = 0;
@@ -1450,13 +1453,16 @@ int migrate_pages(struct list_head *from
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
@@ -1505,18 +1511,20 @@ retry:
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
@@ -1525,16 +1533,19 @@ retry:
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
@@ -1560,17 +1571,37 @@ retry:
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
@@ -1579,11 +1610,11 @@ out:
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

mm-migrate-fix-the-return-value-of-migrate_pages.patch
mm-migrate-correct-the-hugetlb-migration-stats.patch
mm-compaction-fix-the-migration-stats-in-trace_mm_compaction_migratepages.patch
mm-migrate-support-multiple-target-nodes-demotion.patch

