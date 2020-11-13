Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388D3C4742C
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 23:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D229C22260
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 23:42:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="l8qo73zR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgKMXmh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Nov 2020 18:42:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:53520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbgKMXmg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Nov 2020 18:42:36 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CE062225D;
        Fri, 13 Nov 2020 23:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605310955;
        bh=ZtWIhM+ccReK0zNYi8lf1qz/081fGLDcJThiDJ6lkkc=;
        h=Date:From:To:Subject:From;
        b=l8qo73zR8lp0WBi3ai8O9twpm6v4GkerYLuTopPKTsavJL1Y2ZVE6CUeSGq0tENTa
         DPwoV7Q6ZI8wjXPQcwxTXF4HGJdQ+KAZ8hVlUFIe7SZ+Zwj2ceu+2fxGc1IyrWqGW5
         m6E0ukl6Qxro//RRMkWumLUUQhmpO+av4i/a1p1A=
Date:   Fri, 13 Nov 2020 15:42:34 -0800
From:   akpm@linux-foundation.org
To:     jack@suse.cz, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        songliubraving@fb.com, willy@infradead.org, ziy@nvidia.com
Subject:  +
 mm-migrate-skip-shared-exec-thp-for-numa-balancing.patch added to -mm tree
Message-ID: <20201113234234.O27X3ZkvF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: skip shared exec THP for NUMA balancing
has been added to the -mm tree.  Its filename is
     mm-migrate-skip-shared-exec-thp-for-numa-balancing.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-skip-shared-exec-thp-for-numa-balancing.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-skip-shared-exec-thp-for-numa-balancing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-truncate_complete_page-is-not-existed-anymore.patch
mm-migrate-simplify-the-logic-for-handling-permanent-failure.patch
mm-migrate-skip-shared-exec-thp-for-numa-balancing.patch
mm-migrate-clean-up-migrate_prep_local.patch
mm-migrate-return-enosys-if-thp-migration-is-unsupported.patch

