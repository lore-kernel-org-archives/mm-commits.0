Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16DE4C3526B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E16FA22CF7
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgLOX7q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729722AbgLOX0F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:26:05 -0500
Date:   Tue, 15 Dec 2020 15:23:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074608;
        bh=C/bahwjdmYflqZbM/+Ru7ypiAcIPzI6bgQetI+0z/gk=;
        h=From:To:Subject:From;
        b=a9sdXHOCMfZg84muu6T7kqpLSuqYRZICiHi8KZwqMOJxsZSXAayxjh1nsqHiXtGXs
         elAbuauGJHiuE29h9bXpOsGLQkjNTg6/tRcC74KPfIAe/fsLIkElFd1iJE2eQQbtn7
         +uyhZlhwXlAJYw//sRmDhJ8W2txiuCAglwIHHeWo=
From:   akpm@linux-foundation.org
To:     jack@suse.cz, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        songliubraving@fb.com, willy@infradead.org, ziy@nvidia.com
Subject:  [merged]
 mm-migrate-skip-shared-exec-thp-for-numa-balancing.patch removed from -mm
 tree
Message-ID: <20201215232328.VcbhDjjhs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: skip shared exec THP for NUMA balancing
has been removed from the -mm tree.  Its filename was
     mm-migrate-skip-shared-exec-thp-for-numa-balancing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: migrate: skip shared exec THP for NUMA balancing

The NUMA balancing skip shared exec base page.  Since
CONFIG_READ_ONLY_THP_FOR_FS was introduced, there are probably shared exec
THP, so skip such THPs for NUMA balancing as well.

And Willy's regular filesystem THP support patches could create shared
exec THP wven without that config.

In addition, the page_is_file_lru() is used to tell if the page is file
cache or not, but it filters out shmem page.  It sounds like a typical
usecase by putting executables in shmem to achieve performance gain via
using shmem-THP, so it sounds worth skipping migration for such case too.

Link: https://lkml.kernel.org/r/20201113205359.556831-4-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-migrate-skip-shared-exec-thp-for-numa-balancing
+++ a/mm/migrate.c
@@ -2071,6 +2071,17 @@ bool pmd_trans_migrating(pmd_t pmd)
 	return PageLocked(page);
 }
 
+static inline bool is_shared_exec_page(struct vm_area_struct *vma,
+				       struct page *page)
+{
+	if (page_mapcount(page) != 1 &&
+	    (page_is_file_lru(page) || vma_is_shmem(vma)) &&
+	    (vma->vm_flags & VM_EXEC))
+		return true;
+
+	return false;
+}
+
 /*
  * Attempt to migrate a misplaced page to the specified destination
  * node. Caller is expected to have an elevated reference count on
@@ -2088,8 +2099,7 @@ int migrate_misplaced_page(struct page *
 	 * Don't migrate file pages that are mapped in multiple processes
 	 * with execute permissions as they are probably shared libraries.
 	 */
-	if (page_mapcount(page) != 1 && page_is_file_lru(page) &&
-	    (vma->vm_flags & VM_EXEC))
+	if (is_shared_exec_page(vma, page))
 		goto out;
 
 	/*
@@ -2144,6 +2154,9 @@ int migrate_misplaced_transhuge_page(str
 	int page_lru = page_is_file_lru(page);
 	unsigned long start = address & HPAGE_PMD_MASK;
 
+	if (is_shared_exec_page(vma, page))
+		goto out;
+
 	new_page = alloc_pages_node(node,
 		(GFP_TRANSHUGE_LIGHT | __GFP_THISNODE),
 		HPAGE_PMD_ORDER);
@@ -2255,6 +2268,7 @@ out_fail:
 
 out_unlock:
 	unlock_page(page);
+out:
 	put_page(page);
 	return 0;
 }
_

Patches currently in -mm which might be from shy828301@gmail.com are


