Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17369C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 18 Jun 2022 18:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbiFRS7Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 18 Jun 2022 14:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiFRS7V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 18 Jun 2022 14:59:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79719BE0C
        for <mm-commits@vger.kernel.org>; Sat, 18 Jun 2022 11:59:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22360B80B2F
        for <mm-commits@vger.kernel.org>; Sat, 18 Jun 2022 18:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C399DC3411A;
        Sat, 18 Jun 2022 18:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655578757;
        bh=YrpzMU63w8yAdGcZbQpfptC12OkA1O8FRAFuu4waaH8=;
        h=Date:To:From:Subject:From;
        b=GZHeUthPBHFfyh2rkUPrIm+N3d1Ng9iIHtKbsrmI6gN1EASy+OOQAyWUDpEWmAIdB
         2cOQYg/3DJXnl/2PNn+nd7NqlJQhpySfhrJYDiYDGtY/UVXbbLXuKLmANCFsZmXjmw
         ExwrSFrc/XW5qGA98sVCpF9PDBIYfqs8G+t3fjz4=
Date:   Sat, 18 Jun 2022 11:59:17 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry-fix.patch added to mm-unstable branch
Message-Id: <20220618185917.C399DC3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry-fix
Date: Sat Jun 18 11:58:03 AM PDT 2022

reduce scope of `ptep'

Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry-fix
+++ a/mm/madvise.c
@@ -195,7 +195,6 @@ success:
 static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
 	unsigned long end, struct mm_walk *walk)
 {
-	pte_t *ptep;
 	struct vm_area_struct *vma = walk->private;
 	unsigned long index;
 	struct swap_iocb *splug = NULL;
@@ -208,6 +207,7 @@ static int swapin_walk_pmd_entry(pmd_t *
 		swp_entry_t entry;
 		struct page *page;
 		spinlock_t *ptl;
+		pte_t *ptep;
 
 		ptep = pte_offset_map_lock(vma->vm_mm, pmd, index, &ptl);
 		pte = *ptep;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes.patch
mm-remove-the-vma-linked-list-fix-fix.patch
mm-remove-the-vma-linked-list-fix-fix-fix.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers-fix.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch
xfs-support-cow-in-fsdax-mode-fix.patch
mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry-fix.patch

