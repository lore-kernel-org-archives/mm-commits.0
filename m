Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29BE9C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ABBD61421
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhEHWuT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:50:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229690AbhEHWuT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:50:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8427E6100C;
        Sat,  8 May 2021 22:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514156;
        bh=wOqd1LyIE6zShkTaPfDCxhLifHvcVVs7vlKHBp68Aio=;
        h=Date:From:To:Subject:From;
        b=sLgzOVABEGwBIwaex0JOP5pcGSSLi7qc8ixZqix5khgD1vvb8LUCkAw4JlBcTJjle
         jHxPVanMManFtkL/XV7yY4GJ1N9cH5in7WFwhQ5d15Fd86t6HGP+47k5FntKsfEXsI
         e3DcoP53xHO/w2O4BLxLkQBCf8sygg+qHGkJdAlw=
Date:   Sat, 08 May 2021 15:49:16 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, aquini@redhat.com, david@redhat.com,
        jglisse@redhat.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com
Subject:  [merged]
 =?US-ASCII?Q?mm-migratec-use-helper-migrate=5Fvma=5Fcollect=5Fskip-in-mi?=
 =?US-ASCII?Q?grate=5Fvma=5Fcollect=5Fhole.patch?= removed from -mm tree
Message-ID: <20210508224916.m4MfjDoDZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate.c: use helper migrate_vma_collect_skip() in migrate_vma_collect_hole()
has been removed from the -mm tree.  Its filename was
     mm-migratec-use-helper-migrate_vma_collect_skip-in-migrate_vma_collect_hole.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/migrate.c: use helper migrate_vma_collect_skip() in migrate_vma_collect_hole()

It's more recommended to use helper function migrate_vma_collect_skip() to
skip the unexpected case and it also helps remove some duplicated codes. 
Move migrate_vma_collect_skip() above migrate_vma_collect_hole() to avoid
compiler warning.

Link: https://lkml.kernel.org/r/20210325131524.48181-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

--- a/mm/migrate.c~mm-migratec-use-helper-migrate_vma_collect_skip-in-migrate_vma_collect_hole
+++ a/mm/migrate.c
@@ -2290,44 +2290,38 @@ out:
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_DEVICE_PRIVATE
-static int migrate_vma_collect_hole(unsigned long start,
+static int migrate_vma_collect_skip(unsigned long start,
 				    unsigned long end,
-				    __always_unused int depth,
 				    struct mm_walk *walk)
 {
 	struct migrate_vma *migrate = walk->private;
 	unsigned long addr;
 
-	/* Only allow populating anonymous memory. */
-	if (!vma_is_anonymous(walk->vma)) {
-		for (addr = start; addr < end; addr += PAGE_SIZE) {
-			migrate->src[migrate->npages] = 0;
-			migrate->dst[migrate->npages] = 0;
-			migrate->npages++;
-		}
-		return 0;
-	}
-
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
-		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE;
 		migrate->dst[migrate->npages] = 0;
-		migrate->npages++;
-		migrate->cpages++;
+		migrate->src[migrate->npages++] = 0;
 	}
 
 	return 0;
 }
 
-static int migrate_vma_collect_skip(unsigned long start,
+static int migrate_vma_collect_hole(unsigned long start,
 				    unsigned long end,
+				    __always_unused int depth,
 				    struct mm_walk *walk)
 {
 	struct migrate_vma *migrate = walk->private;
 	unsigned long addr;
 
+	/* Only allow populating anonymous memory. */
+	if (!vma_is_anonymous(walk->vma))
+		return migrate_vma_collect_skip(start, end, walk);
+
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
+		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE;
 		migrate->dst[migrate->npages] = 0;
-		migrate->src[migrate->npages++] = 0;
+		migrate->npages++;
+		migrate->cpages++;
 	}
 
 	return 0;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


