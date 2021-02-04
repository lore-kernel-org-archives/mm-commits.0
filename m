Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3189BC43217
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 00:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E83C164F68
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 00:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbhBDA6Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Feb 2021 19:58:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:40440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234328AbhBDA6R (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Feb 2021 19:58:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCD5264F68;
        Thu,  4 Feb 2021 00:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612400241;
        bh=zYKmYrP64oIoSVHQHnFqKf9ktvAMFwwUdIWJbp3+Hjg=;
        h=Date:From:To:Subject:From;
        b=dXZtLjnJXzdMN5V411T2bAdkUaKXkwPsyzua+mdjoXsFQPGooKpRuK7UncfEOQLY+
         KevXjcBA6GbC24UZah8CLXACfrt6qwAhMeATfPtGJEegHCzx/HyPqxImHVYLAgEl4q
         juYqE3Mlv+CtifS6ZzlRHkOlOlfDSU9FoHqzduW0=
Date:   Wed, 03 Feb 2021 16:57:19 -0800
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, david@redhat.com, iamjoonsoo.kim@lge.com,
        ira.weiny@intel.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, jmorris@namei.org, mgorman@suse.de,
        mhocko@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, peterz@infradead.org,
        rientjes@google.com, rostedt@goodmis.org, sashal@kernel.org,
        tyhicks@linux.microsoft.com, vbabka@suse.cz, willy@infradead.org
Subject:  [to-be-updated] mm-gup-check-for-isolation-errors.patch
 removed from -mm tree
Message-ID: <20210204005719.3t8DZw_If%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: check for isolation errors
has been removed from the -mm tree.  Its filename was
     mm-gup-check-for-isolation-errors.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Subject: mm/gup: check for isolation errors

It is still possible that we pin movable CMA pages if there are isolation
errors and cma_page_list stays empty when we check again.

Check for isolation errors, and return success only when there are no
isolation errors, and cma_page_list is empty after checking.

Because isolation errors are transient, we retry indefinitely.

Link: https://lkml.kernel.org/r/20210201153827.444374-5-pasha.tatashin@soleen.com
Fixes: 9a4e9f3b2d73 ("mm: update get_user_pages_longterm to migrate pages allocated from CMA region")
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   60 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 26 deletions(-)

--- a/mm/gup.c~mm-gup-check-for-isolation-errors
+++ a/mm/gup.c
@@ -1548,8 +1548,8 @@ static long check_and_migrate_cma_pages(
 					struct vm_area_struct **vmas,
 					unsigned int gup_flags)
 {
-	unsigned long i;
-	bool drain_allow = true;
+	unsigned long i, isolation_error_count;
+	bool drain_allow;
 	LIST_HEAD(cma_page_list);
 	long ret = nr_pages;
 	struct page *prev_head, *head;
@@ -1560,6 +1560,8 @@ static long check_and_migrate_cma_pages(
 
 check_again:
 	prev_head = NULL;
+	isolation_error_count = 0;
+	drain_allow = true;
 	for (i = 0; i < nr_pages; i++) {
 		head = compound_head(pages[i]);
 		if (head == prev_head)
@@ -1571,25 +1573,35 @@ check_again:
 		 * of the CMA zone if possible.
 		 */
 		if (is_migrate_cma_page(head)) {
-			if (PageHuge(head))
-				isolate_huge_page(head, &cma_page_list);
-			else {
+			if (PageHuge(head)) {
+				if (!isolate_huge_page(head, &cma_page_list))
+					isolation_error_count++;
+			} else {
 				if (!PageLRU(head) && drain_allow) {
 					lru_add_drain_all();
 					drain_allow = false;
 				}
 
-				if (!isolate_lru_page(head)) {
-					list_add_tail(&head->lru, &cma_page_list);
-					mod_node_page_state(page_pgdat(head),
-							    NR_ISOLATED_ANON +
-							    page_is_file_lru(head),
-							    thp_nr_pages(head));
+				if (isolate_lru_page(head)) {
+					isolation_error_count++;
+					continue;
 				}
+				list_add_tail(&head->lru, &cma_page_list);
+				mod_node_page_state(page_pgdat(head),
+						    NR_ISOLATED_ANON +
+						    page_is_file_lru(head),
+						    thp_nr_pages(head));
 			}
 		}
 	}
 
+	/*
+	 * If list is empty, and no isolation errors, means that all pages are
+	 * in the correct zone.
+	 */
+	if (list_empty(&cma_page_list) && !isolation_error_count)
+		return ret;
+
 	if (!list_empty(&cma_page_list)) {
 		/*
 		 * drop the above get_user_pages reference.
@@ -1609,23 +1621,19 @@ check_again:
 			return ret > 0 ? -ENOMEM : ret;
 		}
 
-		/*
-		 * We did migrate all the pages, Try to get the page references
-		 * again migrating any new CMA pages which we failed to isolate
-		 * earlier.
-		 */
-		ret = __get_user_pages_locked(mm, start, nr_pages,
-						   pages, vmas, NULL,
-						   gup_flags);
-
-		if (ret > 0) {
-			nr_pages = ret;
-			drain_allow = true;
-			goto check_again;
-		}
+		/* We unpinned pages before migration, pin them again */
+		ret = __get_user_pages_locked(mm, start, nr_pages, pages, vmas,
+					      NULL, gup_flags);
+		if (ret <= 0)
+			return ret;
+		nr_pages = ret;
 	}
 
-	return ret;
+	/*
+	 * check again because pages were unpinned, and we also might have
+	 * had isolation errors and need more pages to migrate.
+	 */
+	goto check_again;
 }
 #else
 static long check_and_migrate_cma_pages(struct mm_struct *mm,
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-cma-rename-pf_memalloc_nocma-to-pf_memalloc_pin.patch
mm-apply-per-task-gfp-constraints-in-fast-path.patch
mm-honor-pf_memalloc_pin-for-all-movable-pages.patch
mm-gup-do-not-migrate-zero-page.patch
mm-gup-do-not-migrate-zero-page-fix.patch
mm-gup-migrate-pinned-pages-out-of-movable-zone.patch
memory-hotplugrst-add-a-note-about-zone_movable-and-page-pinning.patch
mm-gup-change-index-type-to-long-as-it-counts-pages.patch
mm-gup-longterm-pin-migration-cleanup.patch
selftests-vm-gup_test-fix-test-flag.patch
selftests-vm-gup_test-test-faulting-in-kernel-and-verify-pinnable-pages.patch

