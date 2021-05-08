Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 869FBC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F05461402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhEHW4Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:56:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229679AbhEHW4W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:56:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85BB361402;
        Sat,  8 May 2021 22:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514520;
        bh=nx6UUG3bN5MrexsPLxC0xF3+8Zf6l9DX4K7l4GlW5c0=;
        h=Date:From:To:Subject:From;
        b=gzQFjYtrDczk+V5VEVbijhbMuTuBm7vCUm4wsxrLhW7fqRpQYo5HQActAztAShSuw
         wFz2OPtWBNcslmebwSa1Szx94kg+f68O4atZI3yOjpBrg/0GHwXo2QANg0RVNA7Dp7
         PTNx3omyBu/28J71TwaQ/DnTSB3yfsx3RtvLk5R8=
Date:   Sat, 08 May 2021 15:55:20 -0700
From:   akpm@linux-foundation.org
To:     lujialin4@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged] mm-fix-typos-in-comments-2.patch removed from
 -mm tree
Message-ID: <20210508225520.CqzCVpNL6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix typos in comments
has been removed from the -mm tree.  Its filename was
     mm-fix-typos-in-comments-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lu Jialin <lujialin4@huawei.com>
Subject: mm: fix typos in comments

succed -> succeed in mm/hugetlb.c
wil -> will in mm/mempolicy.c
wit -> with in mm/page_alloc.c
Retruns -> Returns in mm/page_vma_mapped.c
confict -> conflict in mm/secretmem.c
No functionality changed.

Link: https://lkml.kernel.org/r/20210408140027.60623-1-lujialin4@huawei.com
Signed-off-by: Lu Jialin <lujialin4@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c       |    2 +-
 mm/page_alloc.c      |    2 +-
 mm/page_vma_mapped.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mempolicy.c~mm-fix-typos-in-comments-2
+++ a/mm/mempolicy.c
@@ -994,7 +994,7 @@ static long do_get_mempolicy(int *policy
 		if (flags & MPOL_F_ADDR) {
 			/*
 			 * Take a refcount on the mpol, lookup_node()
-			 * wil drop the mmap_lock, so after calling
+			 * will drop the mmap_lock, so after calling
 			 * lookup_node() only "pol" remains valid, "vma"
 			 * is stale.
 			 */
--- a/mm/page_alloc.c~mm-fix-typos-in-comments-2
+++ a/mm/page_alloc.c
@@ -4173,7 +4173,7 @@ out:
 }
 
 /*
- * Maximum number of compaction retries wit a progress before OOM
+ * Maximum number of compaction retries with a progress before OOM
  * killer is consider as the only way to move forward.
  */
 #define MAX_COMPACT_RETRIES 16
--- a/mm/page_vma_mapped.c~mm-fix-typos-in-comments-2
+++ a/mm/page_vma_mapped.c
@@ -134,7 +134,7 @@ static bool check_pte(struct page_vma_ma
  * regardless of which page table level the page is mapped at. @pvmw->pmd is
  * NULL.
  *
- * Retruns false if there are no more page table entries for the page in
+ * Returns false if there are no more page table entries for the page in
  * the vma. @pvmw->ptl is unlocked and @pvmw->pte is unmapped.
  *
  * If you need to stop the walk before page_vma_mapped_walk() returned false,
_

Patches currently in -mm which might be from lujialin4@huawei.com are


