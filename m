Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5CBC07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E6A861C7F
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbhGFTWW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:22:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231815AbhGFTWW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:22:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A16366192B;
        Tue,  6 Jul 2021 19:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599183;
        bh=LJQYTDyNwJoRLBjcb5oyALJHdC/ULA00S1YcbUV5F/k=;
        h=Date:From:To:Subject:From;
        b=OcXDUn7dpLZ/SKT6xH+pNjDV/RVVm++LwdZwjP+PtsrrzzyeTQSlA1P5uIDN8NI6D
         1yjwJQkjSzt1XGoz/qo7YNu0QrJet8Bs9iGlFUdoRNktZNnkqqjvsb4KQGzxqRk6oY
         q5iXVX+i56b5IYl/FVSCIvcIzDFheRWtv+kDjSoM=
Date:   Tue, 06 Jul 2021 12:19:42 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, gerald.schaefer@linux.ibm.com,
        gor@linux.ibm.com, hca@linux.ibm.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  [merged]
 mm-migrate-dont-split-thp-for-misplaced-numa-page.patch removed from -mm
 tree
Message-ID: <20210706191942.H10hlkED4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: don't split THP for misplaced NUMA page
has been removed from the -mm tree.  Its filename was
     mm-migrate-dont-split-thp-for-misplaced-numa-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1423,6 +1423,7 @@ int migrate_pages(struct list_head *from
 	int swapwrite = current->flags & PF_SWAPWRITE;
 	int rc, nr_subpages;
 	LIST_HEAD(ret_pages);
+	bool nosplit = (reason == MR_NUMA_MISPLACED);
 
 	trace_mm_migrate_pages_start(mode, reason);
 
@@ -1494,8 +1495,9 @@ retry:
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


