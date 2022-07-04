Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 518C1C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 00:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbiGDADj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 20:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiGDADi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 20:03:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B22389A
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 17:03:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97A96B80909
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 00:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3119CC341C6;
        Mon,  4 Jul 2022 00:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656893015;
        bh=EBZGMPrAh8f/p2JuAz3ZTCRRJ+SPX/JGMtubKMJaNI8=;
        h=Date:To:From:Subject:From;
        b=v6Wr0f3w5HWcjdnKG/XOuX6RPjr/EXhUvsZIIgoDJlz8b+b2b7vKJxKi4JPVa4/W6
         so5XZj7I5Vff8cwMP478pHnWPMTLNynPPsJR4F6yjmE8Vp/mDomOeoJlysV5D+XmhC
         CwgGmSgCyUp8igHwlWnY1++IUf8iErceckU69xF8=
Date:   Sun, 03 Jul 2022 17:03:34 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry-fix.patch removed from -mm tree
Message-Id: <20220704000335.3119CC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry-fix
has been removed from the -mm tree.  Its filename was
     mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry-fix.patch

This patch was dropped because it was folded into mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry.patch

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

mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry.patch
mm-docs-fix-comments-that-mention-mem_hotplug_end-fix.patch
android-binder-stop-saving-a-pointer-to-the-vma-fix.patch
mm-remove-the-vma-linked-list-fix-2-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch
xfs-support-cow-in-fsdax-mode-fix.patch
mm-thp-kill-transparent_hugepage_active-fix.patch
mm-thp-kill-transparent_hugepage_active-fix-fix.patch
x86-mm-move-protection_map-inside-the-platform-fix.patch

