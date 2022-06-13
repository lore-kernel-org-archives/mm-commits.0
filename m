Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 445F1C43334
	for <mm-commits@archiver.kernel.org>; Mon, 13 Jun 2022 20:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351074AbiFMUTj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jun 2022 16:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351117AbiFMUSw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jun 2022 16:18:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E9410FE4
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 11:57:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D685C613F5
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 18:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38003C3411C;
        Mon, 13 Jun 2022 18:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655146657;
        bh=8WS7RbXCofxPbX8JiasPwLnrJaakje+HswmNgTv0Pw0=;
        h=Date:To:From:Subject:From;
        b=IRzxY8Ydlb1qQ2GvnkCrYwomvGBrWLXhyXHvDYrrgmzC2j6NFWMDakaLI4FDZujaX
         sQTgNYRVMGXL797Q+3iJCZ93qlrVC5gnut5QHMzML5m0UBjPoSsONsldOJmy4vzoLn
         yRW+jsLc++1pXjO5vizbJ/KmgVCyMIvevM2wH/iE=
Date:   Mon, 13 Jun 2022 11:57:36 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, naoya.horiguchi@linux.dev,
        mike.kravetz@oracle.com, mhocko@suse.com, david@redhat.com,
        dave.hansen@intel.com, axelrasmussen@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-zero-partial-pages-during-fallocate-hole-punch-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20220613185737.38003C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs-zero-partial-pages-during-fallocate-hole-punch-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     hugetlbfs-zero-partial-pages-during-fallocate-hole-punch-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-zero-partial-pages-during-fallocate-hole-punch-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: hugetlbfs-zero-partial-pages-during-fallocate-hole-punch-fix
Date: Mon Jun 13 11:54:37 AM PDT 2022

use loff_t, per Matthew

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-zero-partial-pages-during-fallocate-hole-punch-fix
+++ a/fs/hugetlbfs/inode.c
@@ -602,8 +602,7 @@ static void hugetlb_vmtruncate(struct in
 
 static void hugetlbfs_zero_partial_page(struct hstate *h,
 					struct address_space *mapping,
-					unsigned long start,
-					unsigned long end)
+					loff_t start, loff_t end)
 {
 	pgoff_t idx = start >> huge_page_shift(h);
 	struct page *page;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hugetlbfs-zero-partial-pages-during-fallocate-hole-punch-fix.patch
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

