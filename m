Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4676CECAAD1
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 22:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiH0WdT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Aug 2022 18:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiH0WdS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Aug 2022 18:33:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C522B4CA17
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 15:33:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58E8C60EBF
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 22:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6BDC433D6;
        Sat, 27 Aug 2022 22:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661639596;
        bh=jQ61BDKP4CuOaIBAYVd4KuzrzxXqsnuQjpJTcJHfn88=;
        h=Date:To:From:Subject:From;
        b=splspWLWwPuI7hKyO9UPRkEkyEJpRc5p/9NbK7StVvM31LSa0Kzx/S/uZSf9WOWl4
         L2duSXdXqKIW53Z82ukuR+/DV9yBXI1C6VNF/dtLM6Q0VwEoP4UXboaC9HoyAOEFj/
         /oxKHRg+0LMr5QfZydN0DIik+x9RjcZJhny7PDyM=
Date:   Sat, 27 Aug 2022 15:33:15 -0700
To:     mm-commits@vger.kernel.org, prakash.sangappa@oracle.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache-fix.patch added to mm-unstable branch
Message-Id: <20220827223316.9E6BDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache-fix
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache-fix.patch

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
Subject: hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache-fix
Date: Sat Aug 27 03:31:52 PM PDT 2022

remove stray "*" in comment, per Miaohe Lin

Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Prakash Sangappa <prakash.sangappa@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache-fix
+++ a/fs/hugetlbfs/inode.c
@@ -478,7 +478,7 @@ static void remove_inode_hugepages(struc
 			folio_lock(folio);
 			/*
 			 * We must free the huge page and remove from page
-			 * cache BEFORE removing the * region/reserve map
+			 * cache BEFORE removing the region/reserve map
 			 * (hugetlb_unreserve_pages).  In rare out of memory
 			 * conditions, removal of the region/reserve map could
 			 * fail. Correspondingly, the subpool and global
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

asm-generic-sections-refactor-memory_intersects-fix.patch
mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation-fix.patch
procfs-add-path-to-proc-pid-fdinfo-fix.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch
hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache-fix.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
page_ext-introduce-boot-parameter-early_page_ext-fix.patch
mm-fix-null-ptr-deref-in-kswapd_is_running-fix.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch

