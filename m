Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86946C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 21:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6713F61361
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 21:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240342AbhERVJi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 May 2021 17:09:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352352AbhERVJh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 May 2021 17:09:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDD22611BD;
        Tue, 18 May 2021 21:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621372099;
        bh=pWSOlvK2Rb5x+R4S4Vw8/ksPwPuOkn70Lj/48T3VytY=;
        h=Date:From:To:Subject:From;
        b=ZD650lhQJeIHvSHK2osBDCGAmB2W32XpphSarqopQPTL26BW7nz3XFpJtNRDv8B/p
         4b+MJmaur4Mou9QnyBrQ7XLCWGtTEiHONH2ySIdkq/iVHJxvgDVUUpMEcJa99FVENa
         kjHRbQESTPVmXadTe/lDseSEZUkFl1DuNzfyvJSU=
Date:   Tue, 18 May 2021 14:08:18 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, gerald.schaefer@linux.ibm.com,
        gor@linux.ibm.com, hca@linux.ibm.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  + mm-migrate-dont-split-thp-for-misplaced-numa-page.patch
 added to -mm tree
Message-ID: <20210518210818.0IDh8lflq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: don't split THP for misplaced NUMA page
has been added to the -mm tree.  Its filename is
     mm-migrate-dont-split-thp-for-misplaced-numa-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-dont-split-thp-for-misplaced-numa-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-dont-split-thp-for-misplaced-numa-page.patch

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
Subject: mm: migrate: don't split THP for misplaced NUMA page

The old behavior didn't split THP if migration is failed due to lack of
memory on the target node.  But the THP migration does split THP, so keep
the old behavior for misplaced NUMA page migration.

Link: https://lkml.kernel.org/r/20210518200801.7413-6-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-dont-split-thp-for-misplaced-numa-page
+++ a/mm/migrate.c
@@ -1422,6 +1422,7 @@ int migrate_pages(struct list_head *from
 	int swapwrite = current->flags & PF_SWAPWRITE;
 	int rc, nr_subpages;
 	LIST_HEAD(ret_pages);
+	bool nosplit = (reason == MR_NUMA_MISPLACED);
 
 	trace_mm_migrate_pages_start(mode, reason);
 
@@ -1493,8 +1494,9 @@ retry:
 				/*
 				 * When memory is low, don't bother to try to migrate
 				 * other pages, just exit.
+				 * THP NUMA faulting doesn't split THP to retry.
 				 */
-				if (is_thp) {
+				if (is_thp && !nosplit) {
 					if (!try_split_thp(page, &page2, from)) {
 						nr_thp_split++;
 						goto retry;
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-thp-check-total_mapcount-instead-of-page_mapcount.patch
mm-memory-add-orig_pmd-to-struct-vm_fault.patch
mm-memory-make-numa_migrate_prep-non-static.patch
mm-thp-refactor-numa-fault-handling.patch
mm-migrate-account-thp-numa-migration-counters-correctly.patch
mm-migrate-dont-split-thp-for-misplaced-numa-page.patch
mm-migrate-check-mapcount-for-thp-instead-of-refcount.patch
mm-thp-skip-make-pmd-prot_none-if-thp-migration-is-not-supported.patch

